# database

Go 使用 SQL 与类 SQL 数据库的惯例是通过标准库 [database/sql](http://golang.org/pkg/database/sql/)。这是一个对关系型数据库的通用抽象，它提供了标准的、轻量的、面向行的接口

```go
import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)
func main() {
	db, err := sql.Open("mysql",
		"user:password@tcp(127.0.0.1:3306)/hello")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
        err = db.Ping()
        if err != nil {
	     // do something here
        }
}
```

## 快速开始

在 Go 中访问数据库需要用到 `sql.DB` 接口：它可以创建语句 (statement) 和事务 (transaction)，执行查询，获取结果。

`sql.DB` 并不是数据库连接，也并未在概念上映射到特定的数据库 (Database) 或模式 (schema)。它只是一个抽象的接口，不同的具体驱动有着不同的实现方式。

通常而言，`sql.DB` 会处理一些重要而麻烦的事情，例如操作具体的驱动打开/关闭实际底层数据库的连接，按需管理连接池。

`sql.DB` 这一抽象让用户不必考虑如何管理并发访问底层数据库的问题。当一个连接在执行任务时会被标记为正在使用。用完之后会放回连接池中。不过用户如果用完连接后忘记释放，就会产生大量的连接，极可能导致资源耗尽

### 导入驱动

Mysql："github.com/go-sql-driver/mysql"

sqlite："github.com/mattn/go-sqlite3"

### 建立连接池

```go
db, err := sql.Open("mysql",
		"user:password@tcp(127.0.0.1:3306)/hello")
```

`sql.DB` 刚开始建立时是懒加载的，不会自动创建新的连接，只有使用 `Ping()` 或者运行查询时才会自动生成一个新的连接然后去连接数据库，只有这个时候才能确定数据库是否真的OK，所以建议**一定要在 `sql.Open` 后运行 `Ping()` 确定数据连接正常运行**。

`sql.DB` 是连接后初始化的一个连接池，通常全局就初始化这一个连接池，并且长期运行，所有后续数据库操作都使用该连接池进行。

`sql.DB` **内部自动维护连接池**，当需要连接时自动选择一个空闲的连接，如果没有空闲就建立一个新的连接，当连接不再使用时放回连接池中，内部会自动管理空闲回收。

数据库的连接是一个比较大的耗时和资源消耗操作，首选需要经典的 TCP 三次握手，tcp 连接后数据库需要分配连接资源，同时根据连接信息鉴权等，所以建议使用长连接。对应到我们的 go 中，`sql.DB` 会自动管理连接池，最好**全局使用一个连接池**，不要重复的 open 或者 close。

### 查询

`sql.DB` 支持 4 种查询：

```go
db.Query()    
db.QueryRow()
db.Prepare(sql)   stmt.Query(args)
db.Exec()
```

- `db.Query()` 返回多行数据，需要依次遍历，并且需要自己关闭查询结果集
- `db.QueryRow()` 是专门查询一行数据的一个语法糖，返回 ErrNoRow 或者一行数据，不需要自己关闭结果集
- `db.Prepare()` 是预先将一个数据库连接（con）和一个条 sql 语句绑定并返回 stmt 结构体代表这个绑定后的连接，然后运行 `stmt.Query()` 或者 `stmt.QueryRow()`；stmt 是并发安全的。之所以这样设计，是因为每次直接调用 db.Prepare 都会自动选择一个可用的 con，每次选择的可能不是同一个 con
- `db.Exec()` 适用于执行 insert、update、delete 等不需要返回结果集的操作

### 结果集

只有 `db.Query()` 返回结果集

```go
var (
	id int
	name string
)
rows, err := db.Query("select id, name from users where id = ?", 1)
if err != nil {
	log.Fatal(err)
}
defer rows.Close()
for rows.Next() {
	err := rows.Scan(&id, &name)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(id, name)
}
err = rows.Err()
if err != nil {
	log.Fatal(err)
}
```

> Close 是可以重复调用的，关闭已经关闭的结果集不会报错

使用 `for rows.Next()` 遍历结果集，这样迭代**一行一行处理结果**，节约内存分配，同时防止出现 OOM 的问题

使用 `rows.Scan` 将一行数据填入指定的变量中，**scan 会自动根据目标变量的类型处理类型转换**的问题，比如数据库中是 varchar，但目标变量是 int，那么 scan 会自动转换，当然如果转化出现 error 会返回 error

### 事务

```go
tx := db.Begin()
tx.Commit()
tx.Rollback()
```

事务是使用 `db.begin` 开始，以 `db.commit`/`db.rollback` 结束

普通的 `db.Query`/`db.QueryRow` 自动从连接池中选择一个可用连接，运行结束后会自动将连接放回连接池，下次运行再次重复这个过程

**`db.begin` 会自动从连接池中选择一个连接并返回一直持有该连接的 tx**（和 `db.Prepare` 有点像），后续所有事务操作都用 tx，这样能保证是在用一个连接内运行事务，只有 `commit`/`rollback` 才会释放连接

### 错误处理

- 结果集遍历后 error，每次 `for rows.Next` 结束后要跟一个 `rows.Err()` 检测

```go
for rows.Next() {
	// ...
}
if err = rows.Err(); err != nil {
	// handle the error here
}
```

- 结果集遍历 close error

```go
if err = rows.Close(); err != nil {
	// but what should we do if there's an error?
	log.Println(err)
}
```

- QueryRow() Error

```go
err = db.QueryRow("select name from users where id = ?", 1).Scan(&name)
if err != nil {
	log.Fatal(err)
}
```

QueryRow 的结果是在 Scan 时才会出现

- Mysql 特定 Error

```go
if driverErr, ok := err.(*mysql.MySQLError); ok { 
    // Now the error number is accessible directly
	if driverErr.Number == 1045 {
		// Handle the permission-denied error
	}
}
```

- 连接没释放问题
    1. 事务没有 commit 或者 rollback
    2. 查询集没有 close

- 查询参数问题
    1. Mysql 使用？做参数，防止 sql 注入
    2. 既然是参数，就只能当参数，不可以用于其他部分，也不能做插值

### 标准库 sql 不支持但常用的特性

- 不支持多条 sql 执行

    - `database/sql` 并没有对在一次查询中执行多条 SQL 语句的显式支持，具体的行为以驱动的实现为准。所以对于

        ```go
        _, err := db.Exec("DELETE FROM tbl1; DELETE FROM tbl2") // Error/unpredictable result
        ```

        这样的查询，怎样执行完全由驱动说了算，用户并无法确定驱动到底执行了什么，又返回了什么。

- 不支持返回多个结果集

- 不支持存储过程（Mysql 驱动目前不支持）

- 不支持 Scan 到 map、struct

- 不建议 uint64

### 处理空值

可空列（Nullable Column）非常的恼人，容易导致代码变得丑陋。如果可以，在设计时就应当尽量避免。因为：

- Go 语言的每一个变量都有着默认零值，当数据的零值没有意义时，可以用零值来表示空值。但很多情况下，数据的零值和空值实际上有着不同的语义。单独的原子类型无法表示这种情况。
- 标准库只提供了有限的四种 `Nullable type`：`NullInt64, NullFloat64, NullString, NullBool`。并没有诸如`NullUint64`，`NullYourFavoriteType`，用户需要自己实现。
- 空值有很多麻烦的地方。例如用户认为某一列不会出现空值而采用基本类型接收时却遇到了空值，程序就会崩溃。这种错误非常稀少，难以捕捉、侦测、处理，甚至意识到。

`database\sql` 提供了四种基本可空数据类型：使用基本类型和一个布尔标记的复合结构体表示可空值。例如：

```go
type NullInt64 struct {
        Int64 int64
        Valid bool // Valid is true if Int64 is not NULL
}
```

可空类型的使用方法与基本类型一致：

```go
for rows.Next() {
    var s sql.NullString
    err := rows.Scan(&s)
    // check err
    if s.Valid {
       // use s.String
    } else {
       // handle NULL case
    }
}
```

### 处理动态列

`Scan()` 函数要求传递给它的目标变量的数目，与结果集中的列数正好匹配，否则就会出错。

但总有一些情况，用户事先并不知道返回的结果到底有多少列，例如调用一个返回表的存储过程时。

在这种情况下，使用 `rows.Columns()` 来获取列名列表。在不知道列类型情况下，应当使用 `sql.RawBytes` 作为接受变量的类型。获取结果后自行解析。

```go
cols, err := rows.Columns()
if err != nil {
    // handle this....
}

// 目标列是一个动态生成的数组
dest := []interface{}{
    new(string),
    new(uint32),
    new(sql.RawBytes),
}

// 将数组作为可变参数传入Scan中。
err = rows.Scan(dest...)
// ...
```

## database/sql

```go
import "database/sql"
```

sql 包提供了保证 SQL 或类 SQL 数据库的泛用接口。

使用 sql 包时必须注入（至少）一个数据库驱动。

### type DB

```go
type DB struct {
    // 内含隐藏或非导出字段
}
```

DB 是一个数据库（操作）**句柄**，代表一个具有零到多个底层连接的连接池。它可以安全的被多个 go 程同时使用。

`sql.DB` 不是一个连接，它是数据库的抽象接口。它可以根据 driver 驱动打开关闭数据库连接，管理连接池。

正在使用的连接被标记为繁忙，用完后回到连接池等待下次使用。所以，如果你没有把连接释放回连接池，会导致过多连接使系统资源耗尽。

sql 包会自动创建和释放连接；它也会维护一个闲置连接的连接池。如果数据库具有单连接状态的概念，该状态只有在事务中被观察时才可信。

一旦调用了 DB.Begin，返回的 Tx 会绑定到单个连接。当调用事务 Tx 的 Commit 或 Rollback 后，该事务使用的连接会归还到 DB 的闲置连接池中。

连接池的大小可以用 SetMaxIdleConns 方法控制。

#### func Open

```go
func Open(driverName, dataSourceName string) (*DB, error)
```

Open 打开一个 dirverName 指定的数据库，dataSourceName 指定数据源，一般包至少括数据库文件名和（可能的）连接信息。

- 第一个参数是调用的驱动名，比如下面的例子中使用的是 github.com/go-sql-driver/mysql 中注册的驱动 "mysql"
- 第二个参数依赖与特定驱动的语法，用来连接数据库，通常是 URL 的形式，如 "root:user78@/test"

大多数用户会通过数据库特定的连接帮助函数打开数据库，返回一个 *DB。

Go 标准库中没有数据库驱动。参见 http://golang.org/s/sqldrivers 获取第三方驱动。

Open 函数不创建与数据库的连接，也不验证其参数。它可能会延迟到你第一次调用该数据库时才回去真正创建与数据库的连接。所以如果要立即检查数据源的名称是否合法，或者数据库是否实际可用，应调用返回值的 Ping 方法。

#### func (*DB) Ping

```go
func (db *DB) Ping() error
```

Ping 检查与数据库的连接是否仍有效，如果需要会创建连接。

#### func (*DB) Close

```go
func (db *DB) Close() error
```

Close 关闭数据库，释放任何打开的资源。一般不会关闭 DB，因为 DB 句柄通常被多个 go 程共享，并长期活跃。

举例，正确是不会报错：

```go
package main 
import(
    "log"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "root:user78@/test") // 格式为"user:password@/dbname"
    defer db.Close()
    if err != nil{
        panic(err)
    }

    //使用Ping检查数据库是否实际可用
    if err = db.Ping(); err != nil{
        log.Fatal(err)
    }
}
```

如果写错密码，则会返回：

```go
userdeMBP:go-learning user$ go run test.go
2019/02/20 19:51:00 Error 1045: Access denied for user 'root'@'localhost' (using password: YES)
exit status 1
```

可见调用 `sql.Open()` 函数时并没有报错，是调用 `db.Ping()` 函数时才报出的密码错误

返回的 DB 可以安全的被多个 go 程同时使用，并会维护自身的闲置连接池。这样一来，Open 函数只需调用一次。很少需要关闭 DB，因为 `sql.DB` 对象是为了长连接设计的，不要频繁使用 `Open()` 和 `Close()` 函数，否则会导致各种错误。

因此应该为每个待访问的数据库创建一个 `sql.DB` 实例，并在用完前保留它。如果需要短连接使用，那么可以将其作为函数的参数传递给别的 function 的参数使用，而不是在这个 function 中调用 Open() 和 Close() 再建立已经创建的 sql.DB 实例，或者将其设置为全局变量。

#### func (*DB) Driver

```go
func (db *DB) Driver() driver.Driver
```

Driver 方法返回数据库下层驱动。



下面的四个函数用于进行数据库操作

#### func (*DB) Exec

```go
func (db *DB) Exec(query string, args ...interface{}) (Result, error)
```

Exec 执行一次命令（包括查询、删除、更新、插入等），不返回数据集，返回的结果是 Result

`Result` 接口允许获取执行结果的元数据。参数 args 表示 query 中的占位参数。

#### func (*DB) Query

```go
func (db *DB) Query(query string, args ...interface{}) (*Rows, error)
```

Query 执行一次查询，返回多行结果（即 Rows），一般用于执行 select 命令。

参数 args 表示 query 中的占位参数。



上面两个的差别在于：Query 会返回查询结果 Rows, Exec 不会返回查询结果，只会返回一个结果的状态 Result

**所以一般进行不需要返回值的 DDL 和增删改等操作时会使用 Exec，查询则使用 Query**。当然这主要还是取决于是否需要返回值

#### func (*DB) QueryRow

```go
func (db *DB) QueryRow(query string, args ...interface{}) *Row
```

QueryRow执行一次查询，并期望返回最多一行结果（即Row）。QueryRow总是返回非nil的值，直到返回值的Scan方法被调用时，才会返回被延迟的错误。（如：未找到结果）

#### func (*DB) Prepare

```go
func (db *DB) Prepare(query string) (*Stmt, error)
```

Prepare 创建一个准备好的状态用于之后的查询和命令，即**准备一个需要多次使用的语句，供后续执行用**。返回值可以同时执行多个查询和命令。

#### func (*DB) Begin

```go
func (db *DB) Begin() (*Tx, error)
```

Begin开始一个事务。隔离水平由数据库驱动决定。

####  例

首先先在 mysql 中创建数据库 test，并生成两个表，一个是用户表 userinfo，一个是关联用户信息表 userdetail。使用 workbench 进行创建，首先创建数据库 test：

```sql
CREATE SCHEMA `test` DEFAULT CHARACTER SET utf8;
```

然后创建表：

```go
use test;
create table `userinfo` (
    `uid` int(10) not null auto_increment,
    `username` varchar(64) null default null,
    `department` varchar(64) null default null,
    `created` date null default null,
    primary key (`uid`)
);

create table `userdetail`(
    `uid` int(10) not null default '0',
    `intro` text null,
    `profile` text null,
    primary key (`uid`)
);
```

接下来就示范怎么使用 database/sql 接口对数据库进行增删改查操作：

当然运行前首先需要下载驱动：

```go
go get -u github.com/go-sql-driver/mysql
```

当然，如果你连接的是 sqlite3 数据库，那么你要下载的驱动是：

```
http://github.com/mattn/go-sqlite3
```

举例；

```go
package main 
import(
    "fmt"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func checkErr(err error){
    if err != nil{
        panic(err)
    }
}


func main() {
    db, err := sql.Open("mysql", "root:user78@/test") // 格式为"user:password@/dbname"
    defer db.Close()
    checkErr(err)

    // 插入数据
    stmt, err := db.Prepare("insert userinfo set username = ?,department=?,created=?")
    checkErr(err)

    // 执行准备好的Stmt
    res, err := stmt.Exec("user1", "computing", "2019-02-20")
    checkErr(err)

    // 获取上一个，即上面insert操作的ID
    id, err := res.LastInsertId()
    checkErr(err)
    fmt.Println(id) // 1

    
    // 更新数据
    stmt, err =db.Prepare("update userinfo set username=? where uid=?")
    checkErr(err)

    res, err = stmt.Exec("user1update", id)
    checkErr(err)

    affect, err := res.RowsAffected()
    checkErr(err)
    fmt.Println(affect) // 1

    // 查询数据
    rows, err := db.Query("select * from userinfo")
    checkErr(err)

    for rows.Next() { //作为循环条件来迭代获取结果集Rows
　　　　 //从结果集中获取一行结果
        err = rows.Scan(&uid, &username, &department, &created) 
        // 结果应为: 1 user1update computing 2019-02-20
        checkErr(err)
        fmt.Println(uid, username, department, created)
    }
　　defer rows.Close() // 关闭结果集，释放链接
    // 删除数据
    stmt, err = db.Prepare("delete from userinfo where uid=?")
    checkErr(err)

    res, err = stmt.Exec(id)
    checkErr(err)

    affect, err = res.RowsAffected()
    checkErr(err)
    fmt.Println(affect) // 1

}
```

返回：

```
userdeMBP:go-learning user$ go run test.go
1
1
1 user1update computing 2019-02-20
1
```

上面代码使用的函数的作用分别是：

1. `sql.Open()` 函数用来打开一个注册过的数据库驱动，go-sql-driver/mysql 中注册了 mysql 这个数据库驱动，第二个参数是 DNS（Data Source Name），它是 go-sql-driver/mysql 定义的一些数据库连接和配置信息，其支持下面的几种格式：

```
user@unix(/path/to/socket)/dbname?charset=utf8
user:password@tcp(localhost:5555)/dbname?charset=utf8
user:password@/dbname
user:password@tcp([de:ad:be::ca:fe]:80)/dbname
```

2. `db.Prepare()` 函数用来返回准备要执行的 sql 操作，然后返回准备完毕的执行状态

3. `db.Query()` 函数用来直接执行 Sql 并返回 Rows 结果

4. `stmt.Exec()` 函数用来执行 stmt 准备好的 SQL 语句,然后返回 Result

> sql 中传入的参数都是 =？对应的数据，这样做可以在一定程度上防止 SQL 注入

#### func (*DB) SetMaxOpenConns

```go
func (db *DB) SetMaxOpenConns(n int)
```

SetMaxOpenConns 设置与数据库建立连接的最大数目。

如果 n 大于 0 且小于最大闲置连接数，会将最大闲置连接数减小到匹配最大开启连接数的限制。

如果 n <= 0，不会限制最大开启连接数，默认为 0（无限制）。

#### func (*DB) SetMaxIdleConns

```
func (db *DB) SetMaxIdleConns(n int)
```

SetMaxIdleConns设置连接池中的最大闲置连接数。

如果n大于最大开启连接数，则新的最大闲置连接数会减小到匹配最大开启连接数的限制。

如果n <= 0，不会保留闲置连接。

### type Result

```go
type Result interface {
    LastInsertId() (int64, error)
    RowsAffected() (int64, error)
}
```

Result 是对已执行的 SQL 命令的总结。

- LastInsertId 返回一个数据库生成的回应命令的整数。
    - 当插入新行时，一般来自一个"自增"列。
    - 不是所有的数据库都支持该功能，该状态的语法也各有不同。
- RowsAffected 返回被 update、insert 或 delete 命令影响的**行数**。
    - 不是所有的数据库都支持该功能。

### type Row

上面的 DB 的函数 `Query()` 和 `QueryRow()` 会返回 *ROWs* 和 *ROW*，因此下面就是如何去得到返回结果的更多详细的信息

```go
type Row struct {
    // 内含隐藏或非导出字段
}
```

QueryRow 方法返回 Row，代表单行查询结果。

#### func (*Row) Scan

```go
func (r *Row) Scan(dest ...interface{}) error
```

Scan 将该行查询结果各列分别保存进 dest 参数指定的值中。如果该查询匹配多行，Scan 会使用第一行结果并丢弃其余各行。如果没有匹配查询的行，Scan 会返回 ErrNoRows。

举例：一开始数据库中为空，因此调用 Scan 会返回错误：

```go
package main 
import(
    "fmt"
    "log"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "root:user78@/test") //后面格式为"user:password@/dbname"
    defer db.Close()
    if err != nil{
        panic(err)
    }

    //使用Ping检查数据库是否实际可用
    if err = db.Ping(); err != nil{
        log.Fatal(err)
    }

    //查询数据
    var uid int 
    var username, department, created string
    err = db.QueryRow("select * from userinfo").Scan(&uid, &username, &department, &created)
    switch {
    case err == sql.ErrNoRows:
        log.Printf("No user with that ID.") // 返回 2019/02/21 10:38:33 No user with that ID.
    case err != nil:
        log.Fatal(err)
    default:
        fmt.Printf("Username is %s\n", username)
    }

}
```

因此如果先插入数据再调用 `QueryRow` 则不会出错了：

```go
package main 
import(
    "fmt"
    "log"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "root:user78@/test") // 格式为"user:password@/dbname"
    defer db.Close()
    if err != nil{
        log.Fatal(err)
    }

    // 使用Ping检查数据库是否实际可用
    if err = db.Ping(); err != nil{
        log.Fatal(err)
    }

    stmt, err := db.Prepare("insert userinfo set username =?,department=?,created=?")
    if err != nil{
        log.Fatal(err)
    }

    _, err = stmt.Exec("testQueryRow", "computing", "2019-02-21")
    if err != nil{
        log.Fatal(err)
    }

    // 查询数据
    var uid int 
    var username, department, created string
    err = db.QueryRow("select * from userinfo").Scan(&uid, &username, &department, &created)
    switch {
    case err == sql.ErrNoRows:
        log.Printf("No user with that ID.")
    case err != nil:
        log.Fatal(err)
    default:
        fmt.Printf("Uid is %v, username is %s, department is %s, created at %s\n", uid, username, department, created)
    }

}
```

返回：

```
userdeMBP:go-learning user$ go run test.go
Uid is 3, username is testQueryRow, department is computing, created at 2019-02-21
```

### type Rows

```go
type Rows struct {
    // 内含隐藏或非导出字段
}
```

Rows 是查询的结果。它的游标指向结果集的第零行，使用 Next 方法来遍历各行结果：

```go
rows, err := db.Query("SELECT ...")
...
defer rows.Close()
for rows.Next() {
    var id int
    var name string
    err = rows.Scan(&id, &name)
    ...
}
err = rows.Err() // 在退出迭代后检查错误
...
```

#### func (*Rows) Columns

```go
func (rs *Rows) Columns() ([]string, error)
```

Columns 返回列名。如果 Rows 已经关闭会返回错误。

#### func (*Rows) Scan

```go
func (rs *Rows) Scan(dest ...interface{}) error
```

Scan 将当前行各列结果填充进 dest 指定的各个值中，用于在迭代中获取一行结果。

如果某个参数的类型为 []byte，Scan 会保存对应数据的拷贝，该拷贝为调用者所有，可以安全地修改或无限期地保存。如果参数类型为 *RawBytes 可以避免拷贝；参见 RawBytes 的文档获取其使用的约束。

如果某个参数的类型为 *interface{}，Scan 会不做转换的拷贝底层驱动提供的值。如果值的类型为 []byte，会进行数据的拷贝，调用者可以安全使用该值。

#### func (*Rows) Next

```go
func (rs *Rows) Next() bool
```

Next 准备用于 Scan 方法的下一行结果。如果成功会返回 true，如果没有下一行或者出现错误会返回 false。Err() 方法应该被调用以区分这两种情况。

**每一次调用 Scan 方法，甚至包括第一次调用该方法，都必须在前面先调用 Next 方法。**

#### func (*Rows) Close

```go
func (rs *Rows) Close() error
```

Close 关闭 Rows，阻止对其更多的列举。 如果 Next 方法返回 false，Rows 会自动关闭，满足检查 Err 方法结果的条件。Close 方法是幂等的（即多次调用不会出错），不影响 Err 方法的结果。

用于关闭结果集 Rows。结果集引用了数据库连接，并会从中读取结果。读取完之后必须关闭它才能避免资源泄露。只要结果集仍然打开着，相应的底层连接就处于忙碌状态，不能被其他查询使用。

#### func (*Rows) Err

```go
func (rs *Rows) Err() error
```

Err 返回可能的、在迭代时出现的错误，即用于在退出迭代后检查错误。Err 需在显式或隐式调用 Close 方法后调用，即如果 Next 方法返回 false，Rows 会自动关闭，相当于调用了 Close()。

正常情况下迭代退出是因为内部产生的 EOF 错误（即数据读取完毕），使得下一次 `rows.Next() == false`，从而终止循环；在迭代结束后要检查错误，以确保迭代是因为数据读取完毕，而非其他“真正”错误而结束的。

举例：

包括上面的例子，这里再插入一条数据，这样数据库中就有两条数据了

```go
package main 
import(
    "fmt"
    "log"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "root:user78@/test") // 格式为"user:password@/dbname"
    defer db.Close()
    if err != nil{
        log.Fatal(err)
    }

    // 使用Ping检查数据库是否实际可用
    if err = db.Ping(); err != nil{
        log.Fatal(err)
    }

    stmt, err := db.Prepare("insert userinfo set username =?,department=?,created=?")
    if err != nil{
        log.Fatal(err)
    }

    _, err = stmt.Exec("testQuery", "data mining", "2019-02-21")
    if err != nil{
        log.Fatal(err)
    }

    // 查询数据
    rows, err := db.Query("select * from userinfo")
    if err != nil{
        log.Fatal(err)
    }
    defer rows.Close()

    // 迭代结果
    var uid int 
    var username, department, created string
    for rows.Next() {
        if err = rows.Scan(&uid, &username, &department, &created); err != nil {
            log.Fatal(err)
        }
        fmt.Printf("Uid is %v, username is %s, department is %s, created at %s\n", uid, username, department, created)
    }
    // 查看迭代时是否出错以及出的是什么错
    if rows.Err() != nil {
        log.Fatal(err)
    }

}
```

返回：

```
userdeMBP:go-learning user$ go run test.go
Uid is 3, username is testQueryRow, department is computing, created at 2019-02-21
Uid is 4, username is testQuery, department is data mining, created at 2019-02-21
```

### type Stmt

在调用 `db.Prepare()` 后会返回 *Stmt，即准备好的语句

一般一个**会多次进行查询的语句**就应该将其设置为准备好的语句。

Stmt 是和单个数据库直接绑定的。客户端会发送一个带有占位符，如 ？的 SQL 语句的 Stmt 到服务端，然后服务端会返回一个 Stmt ID，说明给你绑定的连接是哪一个。然后之后当客户端要执行该 Stmt 时，就会发送 ID 和参数来绑定连接并执行操作。

要注意的是不能直接为 Stmt 绑定连接，连接只能与 DB 和 Tx 绑定，当我们生成一个 Stmt 时，首先它会自动在连接池中绑定一个空闲连接，然后 Stmt 会记住该连接，然后之后执行时尝试使用这个连接，如果不可用，如连接繁忙或关闭，则会重新准备语句并再绑定一个新的连接

Stmt 中可以执行的方法与 db 中的方法十分类似

- `func (*Stmt) Exec`
- `func (*Stmt) Query`
- `func (*Stmt) QueryRow`
- `func (*Stmt) Close`

```go
package main 
import(
    "fmt"
    "log"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "root:user78@/test") //后面格式为"user:password@/dbname"
    defer db.Close()
    if err != nil{
        log.Fatal(err)
    }

    //使用Ping检查数据库是否实际可用
    if err = db.Ping(); err != nil{
        log.Fatal(err)
    }

    stmt1, err := db.Prepare("insert userinfo set username =?,department=?,created=?")
    if err != nil{
        log.Fatal(err)
    }

    _, err = stmt1.Exec("testStmtExecAndQueryRow", "accounting", "2019-02-21")
    if err != nil{
        log.Fatal(err)
    }
    defer stmt1.Close()

    stmt2, err := db.Prepare("select * from userinfo where uid =?")
    if err != nil{
        log.Fatal(err)
    }

    //查询数据
    var uid int 
    var username, department, created string
    err = stmt2.QueryRow(5).Scan(&uid, &username, &department, &created)
    if err != nil{
        log.Fatal(err)
    }
    fmt.Printf("Uid is %v, username is %s, department is %s, created at %s\n", uid, username, department, created)
    defer stmt2.Close()

}
```

输出

```
userdeMBP:go-learning user$ go run test.go
Uid is 5, username is testStmtExecAndQueryRow, department is accounting, created at 2019-02-21
```

### type Tx

`db.Begin()` 函数会返回 *Tx。Go 中事务（Tx）是一个持有数据库连接的对象，它允许用户在同一个连接上执行上面提到的各类操作。

使用它的原因是：Tx 上执行的方法都保证是在同一个底层连接上执行的，这样对连接状态的修改将会一直对后续的操作起作用

然而 DB 的方法就不会保证是在同一条连接上执行，如果之前的连接繁忙或关闭，那么就会使用其他的连接

Tx 和 Stmt 不能分离，意思就是 Tx 必须调用自己的 Tx.Prepare() 函数来生成 Stmt 来供自己使用，而不能使用 DB 生成的 Stmt，因为这样他们使用的必定不是同一个连接。

当然，如果你想要在该事务中使用已存在的状态，参见 Tx.Stmt 方法，将 DB 的 Stmt 转成 Tx 的 Stmt。

```go
type Tx struct {
    // 内含隐藏或非导出字段
}
```

Tx 代表一个进行中的数据库事务。

一次事务必须以对 Commit 或 Rollback 的调用结束。

调用 Commit 或 Rollback 后，所有对事务的操作都会失败并返回错误值 ErrTxDone。

- `func (*Stmt) Exec`
- `func (*Stmt) Query`
- `func (*Stmt) QueryRow`

#### 事务中的多条语句

因为事务保证在它上面执行的查询都由同一个连接来执行，因此事务中的语句必需按顺序一条一条执行。

对于返回结果集的查询，事务必须在结果集执行 `Close()` 之后才能进行下一次查询。

用户如果尝试在前一条语句的结果还没读完前就执行新的查询，连接就会失去同步。这意味着事务中返回结果集的语句都会占用一次单独的网络往返。

#### func (*Tx) Prepare

```go
func (tx *Tx) Prepare(query string) (*Stmt, error)
```

`Prepare` 准备一个专用于该事务的状态。返回的该事务专属状态操作在 Tx 递交或回滚后不能再使用，因此一定要在事务结束前，即调用 Commit() 或 Rollback 函数前关闭准备语句。

**在事务中使用 `defer stmt.Close()` 是相当危险的**。因为当事务 Tx 结束后，它会先释放自己持有的数据库 DB 连接，但事务 Tx 创建的未关闭 `Stmt` 仍然保留着对事务 Tx 连接的引用。

在事务结束后执行 `stmt.Close()`，他就会根据引用去查找之前的数据库 DB 连接，然后想要释放它。但是其实数据库的连接早就被释放了，而且如果原来释放的数据库 DB 连接已经被其他查询获取并使用，就会产生竞争，极有可能破坏连接的状态。因此两者的释放顺序是十分重要的

先释放在事务 Tx 的状态 Stmt，再释放事务 Tx，最后释放 db

```go
package main 
import(
    "fmt"
    "log"
    "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

func checkErr(err error){
    if err != nil{
        log.Fatal(err)
    }  
}

func main() {
    db, err := sql.Open("mysql", "root:user78@/test") // 格式为"user:password@/dbname"
    defer db.Close()
    checkErr(err)

    // 使用Ping检查数据库是否实际可用
    if err = db.Ping(); err != nil{
        log.Fatal(err)
    }
    
    tx, err := db.Begin()
    checkErr(err)
    defer tx.Commit()

    stmt1, err := tx.Prepare("insert userinfo set username =?,department=?,created=?")
    checkErr(err)

    result, err := stmt1.Exec("testTx", "PD", "2019-02-21")
    checkErr(err)
    id, err := result.LastInsertId()
    checkErr(err)
    defer stmt1.Close()

    stmt2, err := tx.Prepare("select * from userinfo where uid =?")
    checkErr(err)

    //查询数据
    var uid int 
    var username, department, created string
    err = stmt2.QueryRow(id).Scan(&uid, &username, &department, &created)
    checkErr(err)
    fmt.Printf("Uid is %v, username is %s, department is %s, created at %s\n", uid, username, department, created)
    defer stmt2.Close()

}
```

上面的 defer 会安装 stmt2 -> stmt1 -> tx -> db 的顺序来关闭连接

成功返回：

```
userdeMBP:go-learning user$ go run test.go
Uid is 6, username is testTx, department is PD, created at 2019-02-21
```

#### func (*Tx) Stmt

```go
func (tx *Tx) Stmt(stmt *Stmt) *Stmt
```

Stmt 使用已存在的状态生成一个该事务特定的状态。

示例：

```go
updateMoney, err := db.Prepare("UPDATE balance SET money=money+? WHERE id=?")
...
tx, err := db.Begin()
...
res, err := tx.Stmt(updateMoney).Exec(123.45, 98293203)
```

#### func (*Tx) Commit

```go
func (tx *Tx) Commit() error
```

Commit 递交事务。

#### func (*Tx) Rollback

```go
func (tx *Tx) Rollback() error
```

Rollback 放弃并回滚事务。

## database/sql/driver

https://www.cnblogs.com/wanghui-garcia/p/10405601.html

```go
import "database/sql/driver"
```

driver 包定义了应被数据库驱动实现的接口，这些接口会被 sql 包使用。 

绝大多数代码应使用 sql 包。

### driver.Driver

Driver是一个数据库驱动的接口，其定义了一个Open(name string)方法，该方法返回一个数据库的Conn接口：

```go
type Driver interface {
    Open(name string) (Conn, error)
}
```

`Open` 返回一个新的与数据库的连接，参数 name 的格式是驱动特定的。

`Open` 可能返回一个缓存的连接（之前关闭的连接），但这么做是不必要的；

sql 包会维护闲置连接池以便有效的重用连接。

返回的连接同一时间只会被一个 go 程使用。所以返回的 Conn 只能用来进行一次 goroutine 操作，即不能把这个Conn 应用于 Go 的多个 goroutine 中，否则会出现错误，如：

```go
go goroutineA(Conn) //执行查询操作
go goroutineB(Conn) //执行插入操作
```

这样的代码会使 Go 不知某个操作到底是由哪个 goroutine 发起的从而导致数据混乱。

可能会发生： goroutineA 里面执行的查询操作的结果返回给 goroutineB，从而让 goroutineB 将此结果当成自己执行的插入数据

### driver.Conn

Conn 是一个数据连接的接口定义。它只能应用在一个 goroutine 中

```go
type Conn interface {
    Prepare(query string) (Stmt, error)
    Close() error
    Begin() (Tx, error)
}
```

`Prepare` 返回一个准备好的、绑定到该连接的状态，换句话说，返回与当前连接相关的 SQL 语句的准备状态，可以进行查询、删除等操作

`Close` 作废并停止任何现在准备好的状态和事务，将该连接标注为不再使用。

> 因为 sql 包维护着一个连接池，只有当闲置连接过剩时才会调用 Close 方法，驱动的实现中不需要添加自己的连接缓存池。
>
> 因为驱动实现了 database/sql 中建议的 conn pool，所以不用再去实现缓存 conn 之类的，这样会更容易引起问题

`Begin` 返回一个代表事务处理的 Tx，通过它你可以进行查询、更新等操作，或者对事务进行回滚、递交