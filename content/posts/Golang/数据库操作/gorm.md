---
title: "Go GORM 库"
date: 2022-02-14
draft: false
author: "MelonCholi"
tags: [数据库,后端]
categories: [Golang]
---

# gorm

官方文档：https://gorm.io/zh_CN/docs

```go
package main

import (
  "gorm.io/gorm"
  "gorm.io/driver/sqlite"
)

type Product struct {
  gorm.Model
  Code  string
  Price uint
}

func main() {
  db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
  if err != nil {
    panic("failed to connect database")
  }

  // 迁移 schema
  db.AutoMigrate(&Product{})

  // Create
  db.Create(&Product{Code: "D42", Price: 100})

  // Read
  var product Product
  db.First(&product, 1) // 根据整型主键查找
  db.First(&product, "code = ?", "D42") // 查找 code 字段值为 D42 的记录

  // Update - 将 product 的 price 更新为 200
  db.Model(&product).Update("Price", 200)
  // Update - 更新多个字段
  db.Model(&product).Updates(Product{Price: 200, Code: "F42"}) // 仅更新非零值字段
  db.Model(&product).Updates(map[string]interface{}{"Price": 200, "Code": "F42"})

  // Delete - 删除 product
  db.Delete(&product, 1)
}
```

若要打开 MySQL

```go
package main
import (
    "fmt"
    "time"

    "github.com/jinzhu/gorm"
    _ "github.com/jinzhu/gorm/dialects/mysql"
)


// 定义一个数据模型(user表)
// 列名是字段名的蛇形小写(PassWd->pass_word)
type User struct {
    Id          uint        `gorm:"AUTO_INCREMENT"`
    Name        string      `gorm:"size:50"`
    Age         int         `gorm:"size:3"`
    Birthday    *time.Time
    Email       string      `gorm:"type:varchar(50);unique_index"`
    PassWord    string      `gorm:"type:varchar(25)"`
}

var db *gorm.DB

func main() {
    db,err := gorm.Open("mysql","root:bgbiao.top@(127.0.0.1:13306)/test_api?charset=utf8&parseTime=True&loc=Local")
    if err != nil {
        fmt.Errorf("创建数据库连接失败:%v",err)

    }

    // defer db.Close() // GORM v2 不需要此步

    // 自动迁移数据结构(table schema)
    // 注意:在gorm中，默认的表名都是结构体名称的复数形式，比如User结构体默认创建的表为users
    // db.SingularTable(true) 可以取消表名的复数形式，使得表名和结构体名称一致
    db.AutoMigrate(&User{})


    // 添加唯一索引
    db.Model(&User{}).AddUniqueIndex("name_email", "id", "name","email")

    // 插入记录
    db.Create(&User{Name:"bgbiao",Age:18,Email:"bgbiao@bgbiao.top"})
    db.Create(&User{Name:"xxb",Age:18,Email:"xxb@bgbiao.top"})

    var user User
    var users []User
    // 查看插入后的全部元素
    fmt.Printf("插入后元素:\n")
    db.Find(&users)
    fmt.Println(users)

    // 查询一条记录
    db.First(&user,"name = ?","bgbiao")
    fmt.Println("查看查询记录:",user)

    // 更新记录(基于查出来的数据进行更新)
    db.Model(&user).Update("name","biaoge")
    fmt.Println("更新后的记录:",user)

    // 删除记录
    db.Delete(&user)

    // 查看全部记录
    fmt.Println("查看全部记录:")

    db.Find(&users)
    fmt.Println(users)
}
```

```sh
# 运行gorm实例
$ go run gorm-mysql-example.go
插入后元素:
[{1 bgbiao 18 <nil> bgbiao@bgbiao.top } {2 xxb 18 <nil> xxb@bgbiao.top }]
查看查询记录: {1 bgbiao 18 <nil> bgbiao@bgbiao.top }
更新后的记录: {1 biaoge 18 <nil> bgbiao@bgbiao.top }
查看全部记录:
[{2 xxb 18 <nil> xxb@bgbiao.top }]
```

## 快速开始

https://zhuanlan.zhihu.com/p/113251066

### 安装

支持的数据库以及导入路径如下:

- mysql: github.com/jinzhu/gorm/dialects/mysql
- postgres: github.com/jinzhu/gorm/dialects/postgres
- sqlite: github.com/jinzhu/gorm/dialects/sqlite
- sqlserver: github.com/jinzhu/gorm/dialects/mssql

gorm 框架只是简单封装了数据库的驱动包，在安装时仍需要下载原始的驱动包

```go
$ go get -u github.com/jinzhu/gorm
$ go get -u github.com/go-sql-driver/mysql

$ go get -u gorm.io/driver/mysql
```

## 模型

模型是标准的 struct，由 Go 的基本数据类型、实现了 [Scanner](https://pkg.go.dev/database/sql/?tab=doc#Scanner) 和 [Valuer](https://pkg.go.dev/database/sql/driver#Valuer) 接口的自定义类型及其指针或别名组成

```go
type User struct {
  ID           uint
  Name         string
  Email        *string
  Age          uint8
  Birthday     *time.Time
  MemberNumber sql.NullString
  ActivatedAt  sql.NullTime
  CreatedAt    time.Time
  UpdatedAt    time.Time
}
```

### 约定

GORM 倾向于**约定**，而不是配置。

默认情况下，Gorm：

- 使用 `ID` 作为主键
- 使用结构体名的 `蛇形复数` 作为表名
- 字段名的 `蛇形` 作为列名
- 使用 `CreatedAt`、`UpdatedAt` 字段追踪创建、更新时间

遵循 GORM 已有的约定，可以减少您的配置和代码量。如果约定不符合您的需求，[GORM 允许您自定义配置它们](https://gorm.io/zh_CN/docs/conventions.html)

### gorm.Model

GORM 定义一个 `gorm.Model` 结构体，其包括字段 `ID`、`CreatedAt`、`UpdatedAt`、`DeletedAt`

```go
// gorm.Model 的定义
type Model struct {
  ID        uint           `gorm:"primaryKey"`
  CreatedAt time.Time
  UpdatedAt time.Time
  DeletedAt gorm.DeletedAt `gorm:"index"`
}
```

您可以将它嵌入到您的结构体中，以包含这几个字段

### 字段标签

声明 model 时，tag 是可选的，GORM 支持以下 tag： tag 名大小写不敏感，但建议使用 `camelCase` 风格

| 标签名                 | 说明                                                         |
| :--------------------- | :----------------------------------------------------------- |
| column                 | 指定 db 列名                                                 |
| type                   | 列数据类型，推荐使用兼容性好的通用类型，例如：所有数据库都支持 bool、int、uint、float、string、time、bytes 并且可以和其他标签一起使用，例如：`not null`、`size`, `autoIncrement`… 像 `varbinary(8)` 这样指定数据库数据类型也是支持的。在使用指定数据库数据类型时，它需要是完整的数据库数据类型，如：`MEDIUMINT UNSIGNED not NULL AUTO_INCREMENT` |
| size                   | 指定列大小，例如：`size:256`                                 |
| primaryKey             | 指定列为主键                                                 |
| unique                 | 指定列为唯一                                                 |
| default                | 指定列的默认值                                               |
| precision              | 指定列的精度                                                 |
| scale                  | 指定列大小                                                   |
| not null               | 指定列为 NOT NULL                                            |
| autoIncrement          | 指定列为自动增长                                             |
| autoIncrementIncrement | 自动步长，控制连续记录之间的间隔                             |
| embedded               | 嵌套字段                                                     |
| embeddedPrefix         | 嵌入字段的列名前缀                                           |
| autoCreateTime         | 创建时追踪当前时间，对于 `int` 字段，它会追踪秒级时间戳，您可以使用 `nano`/`milli` 来追踪纳秒、毫秒时间戳，例如：`autoCreateTime:nano` |
| autoUpdateTime         | 创建/更新时追踪当前时间，对于 `int` 字段，它会追踪秒级时间戳，您可以使用 `nano`/`milli` 来追踪纳秒、毫秒时间戳，例如：`autoUpdateTime:milli` |
| index                  | 根据参数创建索引，多个字段使用相同的名称则创建复合索引，查看 [索引](https://gorm.io/zh_CN/docs/indexes.html) 获取详情 |
| uniqueIndex            | 与 `index` 相同，但创建的是唯一索引                          |
| check                  | 创建检查约束，例如 `check:age > 13`，查看 [约束](https://gorm.io/zh_CN/docs/constraints.html) 获取详情 |
| <-                     | 设置字段写入的权限， `<-:create` 只创建、`<-:update` 只更新、`<-:false` 无写入权限、`<-` 创建和更新权限 |
| ->                     | 设置字段读的权限，`->:false` 无读权限                        |
| -                      | 忽略该字段，`-` 无读写权限                                   |
| comment                | 迁移时为字段添加注释                                         |

### 字段级权限控制

可导出的字段在使用 GORM 进行 CRUD 时拥有全部的权限，此外，GORM 允许您用标签控制字段级别的权限。这样您就可以让一个字段的权限是只读、只写、只创建、只更新或者被忽略

> **注意：** 使用 GORM Migrator 创建表时，不会创建被忽略的字段

```go
type User struct {
  Name string `gorm:"<-:create"` // 允许读和创建
  Name string `gorm:"<-:update"` // 允许读和更新
  Name string `gorm:"<-"`        // 允许读和写（创建和更新）
  Name string `gorm:"<-:false"`  // 允许读，禁止写
  Name string `gorm:"->"`        // 只读（除非有自定义配置，否则禁止写）
  Name string `gorm:"->;<-:create"` // 允许读和写
  Name string `gorm:"->:false;<-:create"` // 仅创建（禁止从 db 读）
  Name string `gorm:"-"`  // 通过 struct 读写会忽略该字段
}
```

### 创建/更新时间追踪（纳秒、毫秒、秒、Time）

GORM 约定使用 `CreatedAt`、`UpdatedAt` 追踪创建/更新时间。如果您定义了这种字段，GORM 在创建、更新时会自动填充 [当前时间](https://gorm.io/zh_CN/docs/gorm_config.html#now_func)

要使用不同名称的字段，您可以配置 `autoCreateTime`、`autoUpdateTime` 标签

如果您想要保存 UNIX（毫/纳）秒时间戳，而不是 time，您只需简单地将 `time.Time` 修改为 `int` 即可

```go
type User struct {
  CreatedAt time.Time // Set to current time if it is zero on creating
  UpdatedAt int       // Set to current unix seconds on updating or if it is zero on creating
  Updated   int64 `gorm:"autoUpdateTime:nano"` // Use unix nano seconds as updating time
  Updated   int64 `gorm:"autoUpdateTime:milli"`// Use unix milli seconds as updating time
  Created   int64 `gorm:"autoCreateTime"`      // Use unix seconds as creating time
}
```

### 嵌入结构体

对于匿名字段，GORM 会将其字段包含在父结构体中，例如：

```go
type User struct {
  gorm.Model
  Name string
}
// 等效于
type User struct {
  ID        uint           `gorm:"primaryKey"`
  CreatedAt time.Time
  UpdatedAt time.Time
  DeletedAt gorm.DeletedAt `gorm:"index"`
  Name string
}
```

对于正常的结构体字段，你也可以通过标签 `embedded` 将其嵌入，例如：

```go
type Author struct {
    Name  string
    Email string
}

type Blog struct {
  ID      int
  Author  Author `gorm:"embedded"`
  Upvotes int32
}
// 等效于
type Blog struct {
  ID    int64
  Name  string
  Email string
  Upvotes  int32
}
```

并且，您可以使用标签 `embeddedPrefix` 来为 db 中的字段名添加前缀，例如：

```go
type Blog struct {
  ID      int
  Author  Author `gorm:"embedded;embeddedPrefix:author_"`
  Upvotes int32
}
// 等效于
type Blog struct {
  ID          int64
    AuthorName  string
    AuthorEmail string
  Upvotes     int32
}
```

### 关联标签

GORM 允许通过标签为关联配置外键、约束、many2many 表

| 标签             | 描述                                     |
| :--------------- | :--------------------------------------- |
| foreignKey       | 指定当前模型的列作为连接表的外键         |
| references       | 指定引用表的列名，其将被映射为连接表外键 |
| polymorphic      | 指定多态类型，比如模型名                 |
| polymorphicValue | 指定多态值、默认表名                     |
| many2many        | 指定连接表表名                           |
| joinForeignKey   | 指定连接表的外键列名，其将被映射到当前表 |
| joinReferences   | 指定连接表的外键列名，其将被映射到引用表 |
| constraint       | 关系约束，例如：`OnUpdate`、`OnDelete`   |

## 连接到数据库

GORM 官方支持的数据库类型有： MySQL, PostgreSQL, SQlite, SQL Server

### MySQL

```go
import (
  "gorm.io/driver/mysql"
  "gorm.io/gorm"
)

func main() {
  // 参考 https://github.com/go-sql-driver/mysql#dsn-data-source-name 获取详情
  dsn := "user:pass@tcp(127.0.0.1:3306)/dbname?charset=utf8mb4&parseTime=True&loc=Local"
  db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
}
```

MySQl 驱动程序提供了 [一些高级配置](https://github.com/go-gorm/mysql) 可以在初始化过程中使用，例如：

```go
db, err := gorm.Open(mysql.New(mysql.Config{
  DSN: "gorm:gorm@tcp(127.0.0.1:3306)/gorm?charset=utf8&parseTime=True&loc=Local", // DSN data source name
  DefaultStringSize: 256, // string 类型字段的默认长度
  DisableDatetimePrecision: true, // 禁用 datetime 精度，MySQL 5.6 之前的数据库不支持
  DontSupportRenameIndex: true, // 重命名索引时采用删除并新建的方式，MySQL 5.7 之前的数据库和 MariaDB 不支持重命名索引
  DontSupportRenameColumn: true, // 用 `change` 重命名列，MySQL 8 之前的数据库和 MariaDB 不支持重命名列
  SkipInitializeWithVersion: false, // 根据当前 MySQL 版本自动配置
}), &gorm.Config{})
```

#### 自定义驱动

GORM 允许通过 `DriverName` 选项自定义 MySQL 驱动，例如：

```go
import (
  _ "example.com/my_mysql_driver"
  "gorm.io/gorm"
)

db, err := gorm.Open(mysql.New(mysql.Config{
  DriverName: "my_mysql_driver",
  DSN: "gorm:gorm@tcp(localhost:9910)/gorm?charset=utf8&parseTime=True&loc=Local", // Data Source Name，参考 https://github.com/go-sql-driver/mysql#dsn-data-source-name
}), &gorm.Config{})
```

#### 现有的数据库连接

GORM 允许通过一个现有的数据库连接来初始化 `*gorm.DB`

```go
import (
  "database/sql"
  "gorm.io/driver/mysql"
  "gorm.io/gorm"
)

sqlDB, err := sql.Open("mysql", "mydb_dsn")
gormDB, err := gorm.Open(mysql.New(mysql.Config{
  Conn: sqlDB,
}), &gorm.Config{})
```

### SQLite

```go
import (
  "gorm.io/driver/sqlite"
  "gorm.io/gorm"
)

// github.com/mattn/go-sqlite3
db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{})
```

> **注意：** 您也可以使用 `file::memory:?cache=shared` 替代文件路径。 这会告诉 SQLite 在系统内存中使用一个临时数据库。

## 连接池

GORM 使用 [database/sql](https://pkg.go.dev/database/sql) 维护连接池

```go
sqlDB, err := db.DB()

// SetMaxIdleConns 设置空闲连接池中连接的最大数量
sqlDB.SetMaxIdleConns(10)

// SetMaxOpenConns 设置打开数据库连接的最大数量。
sqlDB.SetMaxOpenConns(100)

// SetConnMaxLifetime 设置了连接可复用的最大时间。
sqlDB.SetConnMaxLifetime(time.Hour)
```

## 创建

### 创建记录

```go
user := User{Name: "Jinzhu", Age: 18, Birthday: time.Now()}

result := db.Create(&user) // 通过数据的指针来创建

user.ID             // 返回插入数据的主键
result.Error        // 返回 error
result.RowsAffected // 返回插入记录的条数
```

### 筛选指定字段来创建记录

创建记录并更新给出的字段。

```go
db.Select("Name", "Age", "CreatedAt").Create(&user)
// INSERT INTO `users` (`name`,`age`,`created_at`) VALUES ("jinzhu", 18, "2020-07-04 11:05:21.775")
```

创建一个记录且一同忽略传递给略去的字段值。

```go
db.Omit("Name", "Age", "CreatedAt").Create(&user)
// INSERT INTO `users` (`birthday`,`updated_at`) VALUES ("2020-01-01 00:00:00.000", "2020-07-04 11:05:21.775")
```

### 批量插入

要有效地插入大量记录，请将一个 `slice` 传递给 `Create` 方法。 GORM 将生成**单独一条** SQL 语句来插入所有数据，并回填主键的值，钩子方法也会被调用。

```go
var users = []User{{Name: "jinzhu1"}, {Name: "jinzhu2"}, {Name: "jinzhu3"}}
db.Create(&users)

for _, user := range users {
  user.ID // 1,2,3
}
```

使用 `CreateInBatches` 分批创建时，你可以指定每批的数量，例如：

```go
var users = []User{{name: "jinzhu_1"}, ...., {Name: "jinzhu_10000"}}

// 数量为 100
db.CreateInBatches(users, 100)
```

[Upsert](https://gorm.io/zh_CN/docs/create.html#upsert) 和 [Create With Associations](https://gorm.io/zh_CN/docs/create.html#create_with_associations) 也支持批量插入

> **注意** 使用 `CreateBatchSize` 选项初始化 GORM 时，所有的创建 & 关联 `INSERT` 都将遵循该选项

```go
db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{
  CreateBatchSize: 1000,
})

db := db.Session(&gorm.Session{CreateBatchSize: 1000})

users = [5000]User{{Name: "jinzhu", Pets: []Pet{pet1, pet2, pet3}}...}

db.Create(&users)
// INSERT INTO users xxx (5 batches)
// INSERT INTO pets xxx (15 batches)
```

### 创建钩子

GORM 允许用户定义的钩子有 `BeforeSave`, `BeforeCreate`, `AfterSave`, `AfterCreate` 创建记录时将调用这些钩子方法

```go
func (u *User) BeforeCreate(tx *gorm.DB) (err error) {
  	u.UUID = uuid.New()

    if u.Role == "admin" {
        return errors.New("invalid role")
    }
    return
}
```

如果您想跳过 `钩子` 方法，您可以使用 `SkipHooks` 会话模式，例如：

```go
DB.Session(&gorm.Session{SkipHooks: true}).Create(&user)

DB.Session(&gorm.Session{SkipHooks: true}).Create(&users)

DB.Session(&gorm.Session{SkipHooks: true}).CreateInBatches(users, 100)
```

### 根据 Map 创建

GORM 支持根据 `map[string]interface{}` 和 `[]map[string]interface{}{}` 创建记录，例如：

```go
db.Model(&User{}).Create(map[string]interface{}{
  "Name": "jinzhu", "Age": 18,
})

// batch insert from `[]map[string]interface{}{}`
db.Model(&User{}).Create([]map[string]interface{}{
  {"Name": "jinzhu_1", "Age": 18},
  {"Name": "jinzhu_2", "Age": 20},
})
```

> **注意：** 根据 map 创建记录时，association 不会被调用，且主键也不会自动填充

### 使用 SQL 表达式、Context Valuer 创建记录

GORM 允许使用 SQL 表达式插入数据，有两种方法实现这个目标。根据 `map[string]interface{}` 或 [自定义数据类型](https://gorm.io/zh_CN/docs/data_types.html#gorm_valuer_interface) 创建，例如：

```go
// 通过 map 创建记录
db.Model(User{}).Create(map[string]interface{}{
  "Name": "jinzhu",
  "Location": clause.Expr{SQL: "ST_PointFromText(?)", Vars: []interface{}{"POINT(100 100)"}},
})
// INSERT INTO `users` (`name`,`location`) VALUES ("jinzhu",ST_PointFromText("POINT(100 100)"));

// 通过自定义类型创建记录
type Location struct {
    X, Y int
}

// Scan 方法实现了 sql.Scanner 接口
func (loc *Location) Scan(v interface{}) error {
  // Scan a value into struct from database driver
}

func (loc Location) GormDataType() string {
  return "geometry"
}

func (loc Location) GormValue(ctx context.Context, db *gorm.DB) clause.Expr {
  return clause.Expr{
    SQL:  "ST_PointFromText(?)",
    Vars: []interface{}{fmt.Sprintf("POINT(%d %d)", loc.X, loc.Y)},
  }
}

type User struct {
  Name     string
  Location Location
}

db.Create(&User{
  Name:     "jinzhu",
  Location: Location{X: 100, Y: 100},
})
// INSERT INTO `users` (`name`,`location`) VALUES ("jinzhu",ST_PointFromText("POINT(100 100)"))
```

### 高级选项

#### 关联创建

创建关联数据时，如果关联值是非零值，这些关联会被 upsert，且它们的 `Hook` 方法也会被调用

```go
type CreditCard struct {
  gorm.Model
  Number   string
  UserID   uint
}

type User struct {
  gorm.Model
  Name       string
  CreditCard CreditCard
}

db.Create(&User{
  Name: "jinzhu",
  CreditCard: CreditCard{Number: "411111111111"}
})
// INSERT INTO `users` ...
// INSERT INTO `credit_cards` ...
```

您也可以通过 `Select`、 `Omit` 跳过关联保存，例如：

```go
db.Omit("CreditCard").Create(&user)

// 跳过所有关联
db.Omit(clause.Associations).Create(&user)
```

#### 默认值

您可以通过标签 `default` 为字段定义默认值，如：

```go
type User struct {
  ID   int64
  Name string `gorm:"default:galeone"`
  Age  int64  `gorm:"default:18"`
}
```

插入记录到数据库时，默认值 *会被用于* 填充值为 [零值](https://tour.golang.org/basics/12) 的字段

> **注意** 对于声明了默认值的字段，像 `0`、`''`、`false` 等零值是不会保存到数据库。您需要使用指针类型或 Scanner/Valuer 来避免这个问题，例如：

```go
type User struct {
  gorm.Model
  Name string
  Age  *int           `gorm:"default:18"`
  Active sql.NullBool `gorm:"default:true"`
}
```

> **注意** 若要数据库有默认、虚拟/生成的值，你必须为字段设置 `default` 标签。若要在迁移时跳过默认值定义，你可以使用 `default:(-)`，例如：

```go
type User struct {
  ID        string `gorm:"default:uuid_generate_v3()"` // db func
  FirstName string
  LastName  string
  Age       uint8
  FullName  string `gorm:"->;type:GENERATED ALWAYS AS (concat(firstname,' ',lastname));default:(-);"`
}
```

使用虚拟/生成的值时，你可能需要禁用它的创建、更新权限，查看 [字段级权限](https://gorm.io/zh_CN/docs/models.html#field_permission) 获取详情

#### Upsert 及冲突

GORM 为不同数据库提供了兼容的 Upsert 支持

```go
import "gorm.io/gorm/clause"

// 在冲突时，什么都不做
db.Clauses(clause.OnConflict{DoNothing: true}).Create(&user)

// 在`id`冲突时，将列更新为默认值
db.Clauses(clause.OnConflict{
  Columns:   []clause.Column{{Name: "id"}},
  DoUpdates: clause.Assignments(map[string]interface{}{"role": "user"}),
}).Create(&users)
// MERGE INTO "users" USING *** WHEN NOT MATCHED THEN INSERT *** WHEN MATCHED THEN UPDATE SET ***; SQL Server
// INSERT INTO `users` *** ON DUPLICATE KEY UPDATE ***; MySQL

// 使用SQL语句
db.Clauses(clause.OnConflict{
  Columns:   []clause.Column{{Name: "id"}},
  DoUpdates: clause.Assignments(map[string]interface{}{"count": gorm.Expr("GREATEST(count, VALUES(count))")}),
}).Create(&users)
// INSERT INTO `users` *** ON DUPLICATE KEY UPDATE `count`=GREATEST(count, VALUES(count));

// 在`id`冲突时，将列更新为新值
db.Clauses(clause.OnConflict{
  Columns:   []clause.Column{{Name: "id"}},
  DoUpdates: clause.AssignmentColumns([]string{"name", "age"}),
}).Create(&users)
// MERGE INTO "users" USING *** WHEN NOT MATCHED THEN INSERT *** WHEN MATCHED THEN UPDATE SET "name"="excluded"."name"; SQL Server
// INSERT INTO "users" *** ON CONFLICT ("id") DO UPDATE SET "name"="excluded"."name", "age"="excluded"."age"; PostgreSQL
// INSERT INTO `users` *** ON DUPLICATE KEY UPDATE `name`=VALUES(name),`age=VALUES(age); MySQL

// 在冲突时，更新除主键以外的所有列到新值。
db.Clauses(clause.OnConflict{
  UpdateAll: true,
}).Create(&users)
// INSERT INTO "users" *** ON CONFLICT ("id") DO UPDATE SET "name"="excluded"."name", "age"="excluded"."age", ...;
```

您还可以查看 [高级查询](https://gorm.io/zh_CN/docs/advanced_query.html) 中的 `FirstOrInit`、`FirstOrCreate`

#### 复合主键

通过将多个字段设为主键，以创建复合主键，例如：

```
type Product struct {
  ID           string `gorm:"primaryKey"`
  LanguageCode string `gorm:"primaryKey"`
  Code         string
  Name         string
}
```

**注意：**默认情况下，整型 `PrioritizedPrimaryField` 启用了 `AutoIncrement`，要禁用它，您需要为整型字段关闭 `autoIncrement`：

```
type Product struct {
  CategoryID uint64 `gorm:"primaryKey;autoIncrement:false"`
  TypeID     uint64 `gorm:"primaryKey;autoIncrement:false"`
}
```

## 查询

### 检索单个对象

GORM 提供了 `First`、`Take`、`Last` 方法，以便从数据库中检索单个对象。当查询数据库时它添加了 `LIMIT 1` 条件，且没有找到记录时，它会返回 `ErrRecordNotFound` 错误

```go
// 获取第一条记录（主键升序）
db.First(&user)
// SELECT * FROM users ORDER BY id LIMIT 1;

// 获取一条记录，没有指定排序字段
db.Take(&user)
// SELECT * FROM users LIMIT 1;

// 获取最后一条记录（主键降序）
db.Last(&user)
// SELECT * FROM users ORDER BY id DESC LIMIT 1;

result := db.First(&user)
result.RowsAffected // 返回找到的记录数
result.Error        // returns error or nil

// 检查 ErrRecordNotFound 错误
errors.Is(result.Error, gorm.ErrRecordNotFound)
```

> 如果你想避免 `ErrRecordNotFound` 错误，你可以使用 `Find`，比如 `db.Limit(1).Find(&user)`，`Find`方法可以接受 struct 和 slice 的数据。

**只有在目标 struct 是指针或者通过 `db.Model()` 指定 model 时，该方法才有效**。 

此外，如果相关 model 没有定义主键，那么将按 model 的第一个字段进行排序。 例如:

```go
var user User
var users []User  

// 有效，因为目标 struct 是指针
db.First(&user)
// SELECT * FROM `users` ORDER BY `users`.`id` LIMIT 1

// 有效，因为通过 `db.Model()` 指定了 model
result := map[string]interface{}{}
db.Model(&User{}).First(&result)
// SELECT * FROM `users` ORDER BY `users`.`id` LIMIT 1

// 无效
result := map[string]interface{}{}
db.Table("users").First(&result)

// 配合 Take 有效
result := map[string]interface{}{}
db.Table("users").Take(&result)

// 未指定主键，会根据第一个字段排序(即：`Code`)
type Language struct {
  Code string
  Name string
}
db.First(&Language{})
// SELECT * FROM `languages` ORDER BY `languages`.`code` LIMIT 1
```

#### 用主键检索

如果主键是数字类型，您可以使用 [内联条件](https://gorm.io/zh_CN/docs/query.html#inline_conditions) 来检索对象。 传入字符串参数时，需要特别注意 SQL 注入问题

```go
db.First(&user, 10)
// SELECT * FROM users WHERE id = 10;

db.First(&user, "10")
// SELECT * FROM users WHERE id = 10;

db.Find(&users, []int{1,2,3})
// SELECT * FROM users WHERE id IN (1,2,3);
```

如果主键是字符串（例如像 uuid），查询将被写成这样：

```go
db.First(&user, "id = ?", "1b74413f-f3b8-409f-ac47-e8c062e3472a")
// SELECT * FROM users WHERE id = "1b74413f-f3b8-409f-ac47-e8c062e3472a";
```

### 检索全部对象

```go
// 获取全部记录
result := db.Find(&users)
// SELECT * FROM users;

result.RowsAffected // 返回找到的记录数，相当于 `len(users)`
result.Error        // returns error
```

### 条件

#### String 条件

```go
// 获取第一条匹配的记录
db.Where("name = ?", "jinzhu").First(&user)
// SELECT * FROM users WHERE name = 'jinzhu' ORDER BY id LIMIT 1;

// 获取全部匹配的记录
db.Where("name <> ?", "jinzhu").Find(&users)
// SELECT * FROM users WHERE name <> 'jinzhu';

// IN
db.Where("name IN ?", []string{"jinzhu", "jinzhu 2"}).Find(&users)
// SELECT * FROM users WHERE name IN ('jinzhu','jinzhu 2');

// LIKE
db.Where("name LIKE ?", "%jin%").Find(&users)
// SELECT * FROM users WHERE name LIKE '%jin%';

// AND
db.Where("name = ? AND age >= ?", "jinzhu", "22").Find(&users)
// SELECT * FROM users WHERE name = 'jinzhu' AND age >= 22;

// Time
db.Where("updated_at > ?", lastWeek).Find(&users)
// SELECT * FROM users WHERE updated_at > '2000-01-01 00:00:00';

// BETWEEN
db.Where("created_at BETWEEN ? AND ?", lastWeek, today).Find(&users)
// SELECT * FROM users WHERE created_at BETWEEN '2000-01-01 00:00:00' AND '2000-01-08 00:00:00';
```

#### Struct & Map 条件

```go
// Struct
db.Where(&User{Name: "jinzhu", Age: 20}).First(&user)
// SELECT * FROM users WHERE name = "jinzhu" AND age = 20 ORDER BY id LIMIT 1;

// Map
db.Where(map[string]interface{}{"name": "jinzhu", "age": 20}).Find(&users)
// SELECT * FROM users WHERE name = "jinzhu" AND age = 20;

// 主键切片条件
db.Where([]int64{20, 21, 22}).Find(&users)
// SELECT * FROM users WHERE id IN (20, 21, 22);
```

> **注意** 当使用结构作为条件查询时，GORM 只会查询非零值字段。这意味着如果您的字段值为 `0`、`''`、`false` 或其他 [零值](https://tour.golang.org/basics/12)，该字段不会被用于构建查询条件，例如：

```go
db.Where(&User{Name: "jinzhu", Age: 0}).Find(&users)
// SELECT * FROM users WHERE name = "jinzhu";
```

如果想要包含零值查询条件，你可以使用 map，其会包含所有 key-value 的查询条件，例如：

```go
db.Where(map[string]interface{}{"Name": "jinzhu", "Age": 0}).Find(&users)
// SELECT * FROM users WHERE name = "jinzhu" AND age = 0;
```

或者使用 6.3.3 的方法

#### 指定结构体查询字段

当使用 struct 进行查询时，你可以通过向 `Where()` 传入 struct 来指定查询条件的字段、值、表名，例如：

```go
db.Where(&User{Name: "jinzhu"}, "name", "Age").Find(&users)
// SELECT * FROM users WHERE name = "jinzhu" AND age = 0;

db.Where(&User{Name: "jinzhu"}, "Age").Find(&users)
// SELECT * FROM users WHERE age = 0;
```

#### 内联条件

查询条件也可以被内联到 `First` 和 `Find` 之类的方法中，其用法类似于 `Where`。

```go
// 根据主键获取记录，如果是非整型主键
db.First(&user, "id = ?", "string_primary_key")
// SELECT * FROM users WHERE id = 'string_primary_key';

// Plain SQL
db.Find(&user, "name = ?", "jinzhu")
// SELECT * FROM users WHERE name = "jinzhu";

db.Find(&users, "name <> ? AND age > ?", "jinzhu", 20)
// SELECT * FROM users WHERE name <> "jinzhu" AND age > 20;

// Struct
db.Find(&users, User{Age: 20})
// SELECT * FROM users WHERE age = 20;

// Map
db.Find(&users, map[string]interface{}{"age": 20})
// SELECT * FROM users WHERE age = 20;
```

#### Not 条件

构建 NOT 条件，用法与 `Where` 类似

```go
db.Not("name = ?", "jinzhu").First(&user)
// SELECT * FROM users WHERE NOT name = "jinzhu" ORDER BY id LIMIT 1;

// Not In
db.Not(map[string]interface{}{"name": []string{"jinzhu", "jinzhu 2"}}).Find(&users)
// SELECT * FROM users WHERE name NOT IN ("jinzhu", "jinzhu 2");

// Struct
db.Not(User{Name: "jinzhu", Age: 18}).First(&user)
// SELECT * FROM users WHERE name <> "jinzhu" AND age <> 18 ORDER BY id LIMIT 1;

// 不在主键切片中的记录
db.Not([]int64{1,2,3}).First(&user)
// SELECT * FROM users WHERE id NOT IN (1,2,3) ORDER BY id LIMIT 1;
```

#### Or 条件

```go
db.Where("role = ?", "admin").Or("role = ?", "super_admin").Find(&users)
// SELECT * FROM users WHERE role = 'admin' OR role = 'super_admin';

// Struct
db.Where("name = 'jinzhu'").Or(User{Name: "jinzhu 2", Age: 18}).Find(&users)
// SELECT * FROM users WHERE name = 'jinzhu' OR (name = 'jinzhu 2' AND age = 18);

// Map
db.Where("name = 'jinzhu'").Or(map[string]interface{}{"name": "jinzhu 2", "age": 18}).Find(&users)
// SELECT * FROM users WHERE name = 'jinzhu' OR (name = 'jinzhu 2' AND age = 18);
```

更复杂的 SQL 查询， 请查看 [高级查询中的组条件](https://gorm.io/zh_CN/docs/advanced_query.html#group_conditions)。

### 选择特定字段

`Select` 允许您指定从数据库中检索哪些字段， 默认情况下，GORM 会检索所有字段。

```go
db.Select("name", "age").Find(&users)
// SELECT name, age FROM users;

db.Select([]string{"name", "age"}).Find(&users)
// SELECT name, age FROM users;

db.Table("users").Select("COALESCE(age,?)", 42).Rows()
// SELECT COALESCE(age,'42') FROM users;
```

还可以看一看 [智能选择字段](https://gorm.io/ zh_CN/docs/advanced_query.html#smart_select)

### Order

指定从数据库检索记录时的排序方式

```go
db.Order("age desc, name").Find(&users)
// SELECT * FROM users ORDER BY age desc, name;

// 多个 order
db.Order("age desc").Order("name").Find(&users)
// SELECT * FROM users ORDER BY age desc, name;

db.Clauses(clause.OrderBy{
  Expression: clause.Expr{SQL: "FIELD(id,?)", Vars: []interface{}{[]int{1, 2, 3}}, WithoutParentheses: true},
}).Find(&User{})
// SELECT * FROM users ORDER BY FIELD(id,1,2,3)
```

### Limit & Offset

`Limit` 指定获取记录的最大数量 

`Offset` 指定在开始返回记录之前要跳过的记录数量

```go
db.Limit(3).Find(&users)
// SELECT * FROM users LIMIT 3;

// 通过 -1 消除 Limit 条件
db.Limit(10).Find(&users1).Limit(-1).Find(&users2)
// SELECT * FROM users LIMIT 10; (users1)
// SELECT * FROM users; (users2)

db.Offset(3).Find(&users)
// SELECT * FROM users OFFSET 3;

db.Limit(10).Offset(5).Find(&users)
// SELECT * FROM users OFFSET 5 LIMIT 10;

// 通过 -1 消除 Offset 条件
db.Offset(10).Find(&users1).Offset(-1).Find(&users2)
// SELECT * FROM users OFFSET 10; (users1)
// SELECT * FROM users; (users2)
```

查看 [Pagination](https://gorm.io/zh_CN/docs/scopes.html#pagination) 学习如何写一个分页器

### GroupBy & Having

```go
type result struct {
  Date  time.Time
  Total int
}

db.Model(&User{}).Select("name, sum(age) as total").Where("name LIKE ?", "group%").Group("name").First(&result)
// SELECT name, sum(age) as total FROM `users` WHERE name LIKE "group%" GROUP BY `name` LIMIT 1


db.Model(&User{}).Select("name, sum(age) as total").Group("name").Having("name = ?", "group").Find(&result)
// SELECT name, sum(age) as total FROM `users` GROUP BY `name` HAVING name = "group"

rows, err := db.Table("orders").Select("date(created_at) as date, sum(amount) as total").Group("date(created_at)").Rows()
for rows.Next() {
  ...
}

rows, err := db.Table("orders").Select("date(created_at) as date, sum(amount) as total").Group("date(created_at)").Having("sum(amount) > ?", 100).Rows()
for rows.Next() {
  ...
}

type Result struct {
  Date  time.Time
  Total int64
}
db.Table("orders").Select("date(created_at) as date, sum(amount) as total").Group("date(created_at)").Having("sum(amount) > ?", 100).Scan(&results)
```

#### Distinct

从模型中选择不相同的值

```go
db.Distinct("name", "age").Order("name, age desc").Find(&results)
```

`Distinct` 也可以配合 [`Pluck`](https://gorm.io/zh_CN/docs/advanced_query.html#pluck), [`Count`](https://gorm.io/zh_CN/docs/advanced_query.html#count) 使用

### Joins

指定 Joins 条件

```go
type result struct {
  Name  string
  Email string
}

db.Model(&User{}).Select("users.name, emails.email").Joins("left join emails on emails.user_id = users.id").Scan(&result{})
// SELECT users.name, emails.email FROM `users` left join emails on emails.user_id = users.id

rows, err := db.Table("users").Select("users.name, emails.email").Joins("left join emails on emails.user_id = users.id").Rows()
for rows.Next() {
  ...
}

db.Table("users").Select("users.name, emails.email").Joins("left join emails on emails.user_id = users.id").Scan(&results)

// 带参数的多表连接
db.Joins("JOIN emails ON emails.user_id = users.id AND emails.email = ?", "jinzhu@example.org").Joins("JOIN credit_cards ON credit_cards.user_id = users.id").Where("credit_cards.number = ?", "411111111111").Find(&user)
```

#### Joins 预加载

您可以使用 `Joins` 实现**单条 SQL 预加载关联记录**，例如：

```go
db.Joins("Company").Find(&users)
// SELECT `users`.`id`,`users`.`name`,`users`.`age`,`Company`.`id` AS `Company__id`,`Company`.`name` AS `Company__name` FROM `users` LEFT JOIN `companies` AS `Company` ON `users`.`company_id` = `Company`.`id`;
```

Join with conditions

```go
db.Joins("Company", DB.Where(&Company{Alive: true})).Find(&users)
// SELECT `users`.`id`,`users`.`name`,`users`.`age`,`Company`.`id` AS `Company__id`,`Company`.`name` AS `Company__name` FROM `users` LEFT JOIN `companies` AS `Company` ON `users`.`company_id` = `Company`.`id` AND `Company`.`alive` = true;
```

For more details, please refer to [Preloading (Eager Loading)](https://gorm.io/zh_CN/docs/preload.html).

### Scan

Scanning results into a struct works similarly to the way we use `Find`

`Find` 中只能传递 gorm 模型，但 `Scan` 中可以传递任意结构体，用以接收只含有部分字段的查询结果

```go
type Result struct {
  Name string
  Age  int
}

var result Result
db.Table("users").Select("name", "age").Where("name = ?", "Antonio").Scan(&result)

// Raw SQL
db.Raw("SELECT name, age FROM users WHERE name = ?", "Antonio").Scan(&result)
```

## 更新

### 保存所有字段

`Save` 会保存所有的字段，即使字段是零值

```go
db.First(&user)

user.Name = "jinzhu 2"
user.Age = 100
db.Save(&user)
// UPDATE users SET name='jinzhu 2', age=100, birthday='2016-01-01', updated_at = '2013-11-17 21:34:10' WHERE id=111;
```

### 更新单个列

当使用 `Update` 更新单个列时，你需要指定条件，否则会返回 `ErrMissingWhereClause` 错误，查看 [Block Global Updates](https://gorm.io/zh_CN/docs/update.html#block_global_updates) 获取详情。当使用了 `Model` 方法，且该对象主键有值，该值会被用于构建条件，例如：

```go
// 条件更新
db.Model(&User{}).Where("active = ?", true).Update("name", "hello")
// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE active=true;

// User 的 ID 是 `111`
db.Model(&user).Update("name", "hello")
// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE id=111;

// 根据条件和 model 的值进行更新
db.Model(&user).Where("active = ?", true).Update("name", "hello")
// UPDATE users SET name='hello', updated_at='2013-11-17 21:34:10' WHERE id=111 AND active=true;
```

### 更新多列

`Updates` 方法支持 `struct` 和 `map[string]interface{}` 参数。

当使用 `struct` 更新时，默认情况下，GORM 只会更新非零值的字段

```go
// 根据 `struct` 更新属性，只会更新非零值的字段
db.Model(&user).Updates(User{Name: "hello", Age: 18, Active: false})
// UPDATE users SET name='hello', age=18, updated_at = '2013-11-17 21:34:10' WHERE id = 111;

// 根据 `map` 更新属性
db.Model(&user).Updates(map[string]interface{}{"name": "hello", "age": 18, "active": false})
// UPDATE users SET name='hello', age=18, active=false, updated_at='2013-11-17 21:34:10' WHERE id=111;
```

> **注意** 当通过 struct 更新时，GORM 只会更新非零字段。 如果您想确保指定字段被更新，你应该使用 `Select` 更新选定字段，或使用 `map` 来完成更新操作

### 更新选定字段

如果您想要在更新时选定、忽略某些字段，您可以使用 `Select`、`Omit`

```go
// 使用 Map 进行 Select
// User's ID is `111`:
db.Model(&user).Select("name").Updates(map[string]interface{}{"name": "hello", "age": 18, "active": false})
// UPDATE users SET name='hello' WHERE id=111;

db.Model(&user).Omit("name").Updates(map[string]interface{}{"name": "hello", "age": 18, "active": false})
// UPDATE users SET age=18, active=false, updated_at='2013-11-17 21:34:10' WHERE id=111;

// 使用 Struct 进行 Select（会 select 零值的字段）
db.Model(&user).Select("Name", "Age").Updates(User{Name: "new_name", Age: 0})
// UPDATE users SET name='new_name', age=0 WHERE id=111;

// Select 所有字段（查询包括零值字段的所有字段）
db.Model(&user).Select("*").Update(User{Name: "jinzhu", Role: "admin", Age: 0})

// Select 除 Role 外的所有字段（包括零值字段的所有字段）
db.Model(&user).Select("*").Omit("Role").Update(User{Name: "jinzhu", Role: "admin", Age: 0})
```

### 更新 Hook

对于更新操作，GORM 支持 `BeforeSave`、`BeforeUpdate`、`AfterSave`、`AfterUpdate` 钩子，这些方法将在更新记录时被调用，详情请参阅 [钩子](https://gorm.io/zh_CN/docs/hooks.html)

```go
func (u *User) BeforeUpdate(tx *gorm.DB) (err error) {
    if u.Role == "admin" {
        return errors.New("admin user not allowed to update")
    }
    return
}
```

### 批量更新

如果您尚未通过 `Model` 指定记录的主键，则 GORM 会执行批量更新

```go
// 根据 struct 更新
db.Model(User{}).Where("role = ?", "admin").Updates(User{Name: "hello", Age: 18})
// UPDATE users SET name='hello', age=18 WHERE role = 'admin';

// 根据 map 更新
db.Table("users").Where("id IN ?", []int{10, 11}).Updates(map[string]interface{}{"name": "hello", "age": 18})
// UPDATE users SET name='hello', age=18 WHERE id IN (10, 11);
```

#### 阻止全局更新

如果在没有任何条件的情况下执行批量更新，默认情况下，GORM 不会执行该操作，并返回 `ErrMissingWhereClause` 错误

对此，你必须加一些条件，或者使用原生 SQL，或者启用 `AllowGlobalUpdate` 模式，例如：

```go
db.Model(&User{}).Update("name", "jinzhu").Error // gorm.ErrMissingWhereClause

db.Model(&User{}).Where("1 = 1").Update("name", "jinzhu")
// UPDATE users SET `name` = "jinzhu" WHERE 1=1

db.Exec("UPDATE users SET name = ?", "jinzhu")
// UPDATE users SET name = "jinzhu"

db.Session(&gorm.Session{AllowGlobalUpdate: true}).Model(&User{}).Update("name", "jinzhu")
// UPDATE users SET `name` = "jinzhu"
```

#### 更新的记录数

获取受更新影响的行数

```go
// 通过 `RowsAffected` 得到更新的记录数
result := db.Model(User{}).Where("role = ?", "admin").Updates(User{Name: "hello", Age: 18})
// UPDATE users SET name='hello', age=18 WHERE role = 'admin';

result.RowsAffected // 更新的记录数
result.Error        // 更新的错误
```

### 高级选项

#### 使用 SQL 表达式更新

GORM 允许使用 SQL 表达式更新列，例如：

```go
// product 的 ID 是 `3`
db.Model(&product).Update("price", gorm.Expr("price * ? + ?", 2, 100))
// UPDATE "products" SET "price" = price * 2 + 100, "updated_at" = '2013-11-17 21:34:10' WHERE "id" = 3;

db.Model(&product).Updates(map[string]interface{}{"price": gorm.Expr("price * ? + ?", 2, 100)})
// UPDATE "products" SET "price" = price * 2 + 100, "updated_at" = '2013-11-17 21:34:10' WHERE "id" = 3;

// 不会更新 updated_at 字段
db.Model(&product).UpdateColumn("quantity", gorm.Expr("quantity - ?", 1))
// UPDATE "products" SET "quantity" = quantity - 1 WHERE "id" = 3;

db.Model(&product).Where("quantity > 1").UpdateColumn("quantity", gorm.Expr("quantity - ?", 1))
// UPDATE "products" SET "quantity" = quantity - 1 WHERE "id" = 3 AND quantity > 1;
```

并且 GORM 也允许使用 SQL 表达式、[自定义数据类型](https://gorm.io/zh_CN/docs/data_types.html#gorm_valuer_interface)的 Context Valuer 来更新，例如：

```go
// 根据自定义数据类型创建
type Location struct {
    X, Y int
}

func (loc Location) GormValue(ctx context.Context, db *gorm.DB) clause.Expr {
  return clause.Expr{
    SQL:  "ST_PointFromText(?)",
    Vars: []interface{}{fmt.Sprintf("POINT(%d %d)", loc.X, loc.Y)},
  }
}

db.Model(&User{ID: 1}).Updates(User{
  Name:  "jinzhu",
  Location: Location{X: 100, Y: 100},
})
// UPDATE `user_with_points` SET `name`="jinzhu",`location`=ST_PointFromText("POINT(100 100)") WHERE `id` = 1
```

#### 根据子查询进行更新

使用子查询更新表

```go
db.Model(&user).Update("company_name", db.Model(&Company{}).Select("name").Where("companies.id = users.company_id"))
// UPDATE "users" SET "company_name" = (SELECT name FROM companies WHERE companies.id = users.company_id);

db.Table("users as u").Where("name = ?", "jinzhu").Update("company_name", db.Table("companies as c").Select("name").Where("c.id = u.company_id"))
// UPDATE "users as u" SET "company_name" = (SELECT name FROM companies as c WHERE c.id = u.company_id) WHERE name = "jinzhu"

db.Table("users as u").Where("name = ?", "jinzhu").Updates(map[string]interface{}{}{"company_name": db.Table("companies as c").Select("name").Where("c.id = u.company_id")})
```

#### 不使用 Hook 和时间追踪

如果您想在更新时跳过 `Hook` 方法且不追踪更新时间，可以使用 `UpdateColumn`、`UpdateColumns`，其用法类似于 `Update`、`Updates`

```go
// 更新单个列
db.Model(&user).UpdateColumn("name", "hello")
// UPDATE users SET name='hello' WHERE id = 111;

// 更新多个列
db.Model(&user).UpdateColumns(User{Name: "hello", Age: 18})
// UPDATE users SET name='hello', age=18 WHERE id = 111;

// 更新选中的列
db.Model(&user).Select("name", "age").UpdateColumns(User{Name: "hello", Age: 0})
// UPDATE users SET name='hello', age=0 WHERE id = 111;
```

#### 返回修改行的数据

返回被修改的数据，仅适用于支持 Returning 的数据库，例如：

```go
// 返回所有列
var users []User
DB.Model(&users).Clauses(clause.Returning{}).Where("role = ?", "admin").Update("salary", gorm.Expr("salary * ?", 2))
// UPDATE `users` SET `salary`=salary * 2,`updated_at`="2021-10-28 17:37:23.19" WHERE role = "admin" RETURNING *
// users => []User{{ID: 1, Name: "jinzhu", Role: "admin", Salary: 100}, {ID: 2, Name: "jinzhu.2", Role: "admin", Salary: 1000}}

// 返回指定的列
DB.Model(&users).Clauses(clause.Returning{Columns: []clause.Column{{Name: "name"}, {Name: "salary"}}}).Where("role = ?", "admin").Update("salary", gorm.Expr("salary * ?", 2))
// UPDATE `users` SET `salary`=salary * 2,`updated_at`="2021-10-28 17:37:23.19" WHERE role = "admin" RETURNING `name`, `salary`
// users => []User{{ID: 0, Name: "jinzhu", Role: "", Salary: 100}, {ID: 0, Name: "jinzhu.2", Role: "", Salary: 1000}}
```

#### 检查字段是否有变更

GORM 提供了 `Changed` 方法，它可以被用在 **Before Update Hook** 里，它会返回字段是否有变更的布尔值

`Changed` 方法只能与 `Update`、`Updates` 方法一起使用，并且它只是检查 Model 对象字段的值与 `Update`、`Updates` 的值是否相等，如果值有变更，且字段没有被忽略，则返回 true

```go
func (u *User) BeforeUpdate(tx *gorm.DB) (err error) {
  // 如果 Role 字段有变更
    if tx.Statement.Changed("Role") {
    return errors.New("role not allowed to change")
    }

  if tx.Statement.Changed("Name", "Admin") { // 如果 Name 或 Role 字段有变更
    tx.Statement.SetColumn("Age", 18)
  }

  // 如果任意字段有变更
    if tx.Statement.Changed() {
        tx.Statement.SetColumn("RefreshedAt", time.Now())
    }
    return nil
}

db.Model(&User{ID: 1, Name: "jinzhu"}).Updates(map[string]interface{"name": "jinzhu2"})
// Changed("Name") => true
db.Model(&User{ID: 1, Name: "jinzhu"}).Updates(map[string]interface{"name": "jinzhu"})
// Changed("Name") => false, 因为 `Name` 没有变更
db.Model(&User{ID: 1, Name: "jinzhu"}).Select("Admin").Updates(map[string]interface{
  "name": "jinzhu2", "admin": false,
})
// Changed("Name") => false, 因为 `Name` 没有被 Select 选中并更新

db.Model(&User{ID: 1, Name: "jinzhu"}).Updates(User{Name: "jinzhu2"})
// Changed("Name") => true
db.Model(&User{ID: 1, Name: "jinzhu"}).Updates(User{Name: "jinzhu"})
// Changed("Name") => false, 因为 `Name` 没有变更
db.Model(&User{ID: 1, Name: "jinzhu"}).Select("Admin").Updates(User{Name: "jinzhu2"})
// Changed("Name") => false, 因为 `Name` 没有被 Select 选中并更新
```

#### 在 Update 时修改值

若要在 Before 钩子中改变要更新的值，如果它是一个完整的更新，可以使用 `Save`；否则，应该使用 `SetColumn` ，例如：

```go
func (user *User) BeforeSave(tx *gorm.DB) (err error) {
  if pw, err := bcrypt.GenerateFromPassword(user.Password, 0); err == nil {
    tx.Statement.SetColumn("EncryptedPassword", pw)
  }

  if tx.Statement.Changed("Code") {
    s.Age += 20
    tx.Statement.SetColumn("Age", s.Age+20)
  }
}

db.Model(&user).Update("Name", "jinzhu")
```

## 删除

### 删除一条记录

删除一条记录时，删除对象需要指定主键，否则会触发 [批量 Delete](https://gorm.io/zh_CN/docs/delete.html#batch_delete)，例如：

```go
// Email 的 ID 是 `10`
db.Delete(&email)
// DELETE from emails where id = 10;

// 带额外条件的删除
db.Where("name = ?", "jinzhu").Delete(&email)
// DELETE from emails where id = 10 AND name = "jinzhu";
```

### 根据主键删除

GORM 允许通过主键 (可以是复合主键) 和内联条件来删除对象，它可以使用数字（如以下例子。也可以使用字符串——译者注）。查看 [查询-内联条件（Query Inline Conditions）](https://gorm.io/zh_CN/docs/query.html#inline_conditions) 了解详情。

```go
db.Delete(&User{}, 10)
// DELETE FROM users WHERE id = 10;

db.Delete(&User{}, "10")
// DELETE FROM users WHERE id = 10;

db.Delete(&users, []int{1,2,3})
// DELETE FROM users WHERE id IN (1,2,3);
```

### Delete Hook

对于删除操作，GORM 支持 `BeforeDelete`、`AfterDelete` Hook，在删除记录时会调用这些方法，查看 [Hook](https://gorm.io/zh_CN/docs/hooks.html) 获取详情

```go
func (u *User) BeforeDelete(tx *gorm.DB) (err error) {
    if u.Role == "admin" {
        return errors.New("admin user not allowed to delete")
    }
    return
}
```

### 批量删除

如果指定的值不包括主属性，那么 GORM 会执行批量删除，它将删除所有匹配的记录

```go
db.Where("email LIKE ?", "%jinzhu%").Delete(Email{})
// DELETE from emails where email LIKE "%jinzhu%";

db.Delete(Email{}, "email LIKE ?", "%jinzhu%")
// DELETE from emails where email LIKE "%jinzhu%";
```

#### 阻止全局删除

如果在没有任何条件的情况下执行批量删除，GORM 不会执行该操作，并返回 `ErrMissingWhereClause` 错误

对此，你必须加一些条件，或者使用原生 SQL，或者启用 `AllowGlobalUpdate` 模式，例如：

```go
db.Delete(&User{}).Error // gorm.ErrMissingWhereClause

db.Where("1 = 1").Delete(&User{})
// DELETE FROM `users` WHERE 1=1

db.Exec("DELETE FROM users")
// DELETE FROM users

db.Session(&gorm.Session{AllowGlobalUpdate: true}).Delete(&User{})
// DELETE FROM users
```

#### 返回删除行的数据

返回被删除的数据，仅适用于支持 Returning 的数据库，例如：

```go
// 返回所有列
var users []User
DB.Clauses(clause.Returning{}).Where("role = ?", "admin").Delete(&users)
// DELETE FROM `users` WHERE role = "admin" RETURNING *
// users => []User{{ID: 1, Name: "jinzhu", Role: "admin", Salary: 100}, {ID: 2, Name: "jinzhu.2", Role: "admin", Salary: 1000}}

// 返回指定的列
DB.Clauses(clause.Returning{Columns: []clause.Column{{Name: "name"}, {Name: "salary"}}}).Where("role = ?", "admin").Delete(&users)
// DELETE FROM `users` WHERE role = "admin" RETURNING `name`, `salary`
// users => []User{{ID: 0, Name: "jinzhu", Role: "", Salary: 100}, {ID: 0, Name: "jinzhu.2", Role: "", Salary: 1000}}
```

### 软删除

如果您的模型包含了一个 `gorm.deletedat` 字段（`gorm.Model` 已经包含了该字段)，它将自动获得软删除的能力！

拥有软删除能力的模型调用 `Delete` 时，记录不会被数据库。但 GORM 会将 `DeletedAt` 置为当前时间， 并且你不能再通过普通的查询方法找到该记录。

```go
// user 的 ID 是 `111`
db.Delete(&user)
// UPDATE users SET deleted_at="2013-10-29 10:23" WHERE id = 111;

// 批量删除
db.Where("age = ?", 20).Delete(&User{})
// UPDATE users SET deleted_at="2013-10-29 10:23" WHERE age = 20;

// 在查询时会忽略被软删除的记录
db.Where("age = 20").Find(&user)
// SELECT * FROM users WHERE age = 20 AND deleted_at IS NULL;
```

如果您不想引入 `gorm.Model`，您也可以这样启用软删除特性：

```go
type User struct {
  ID      int
  Deleted gorm.DeletedAt
  Name    string
}
```

#### 查找被软删除的记录

您可以使用 `Unscoped` 找到被软删除的记录

```go
db.Unscoped().Where("age = 20").Find(&users)
// SELECT * FROM users WHERE age = 20;
```

#### 永久删除

您也可以使用 `Unscoped` 永久删除匹配的记录

```go
db.Unscoped().Delete(&order)
// DELETE FROM orders WHERE id=10;
```

#### Delete Flag

将 unix 时间戳作为 delete flag

```go
import "gorm.io/plugin/soft_delete"

type User struct {
  ID        uint
  Name      string
  DeletedAt soft_delete.DeletedAt
}

// 查询
SELECT * FROM users WHERE deleted_at = 0;

// 删除
UPDATE users SET deleted_at = /* current unix second */ WHERE ID = 1;
```

> **INFO** 在配合 unique 字段使用软删除时，您需要使用这个基于 unix 时间戳的 `DeletedAt` 字段创建一个复合索引，例如：
>
> ```
> import "gorm.io/plugin/soft_delete"
> 
> type User struct {
>   ID        uint
>   Name      string                `gorm:"uniqueIndex:udx_name"`
>   DeletedAt soft_delete.DeletedAt `gorm:"uniqueIndex:udx_name"`
> }
> ```

使用 `1` / `0` 作为 delete flag

```go
import "gorm.io/plugin/soft_delete"

type User struct {
  ID    uint
  Name  string
  IsDel soft_delete.DeletedAt `gorm:"softDelete:flag"`
}

// 查询
SELECT * FROM users WHERE is_del = 0;

// 删除
UPDATE users SET is_del = 1 WHERE ID = 1;
```

## 关联

### Belongs to

`belongs to` 会与另一个模型建立了一对一的连接。 这种模型的每一个实例都“属于”另一个模型的一个实例。

例如，您的应用包含 user 和 company，并且每个 user 能且只能被分配给一个 company。下面的类型就表示这种关系。 

注意，在 `User` 对象中，有一个和 `Company` 一样的 `CompanyID`。 默认情况下， `CompanyID` 被隐含地用来在 `User` 和 `Company` 之间创建一个外键关系， 因此必须包含在 `User` 结构体中才能填充 `Company` 内部结构体。

```go
// `User` 属于 `Company`，`CompanyID` 是外键
type User struct {
  gorm.Model
  Name      string
  CompanyID int
  Company   Company
}

type Company struct {
  ID   int
  Name string
}
```

#### 重写外键

要定义一个 belongs to 关系，数据库的表中必须存在外键。

默认情况下，**外键的名字，使用拥有者的类型名称加上表的主键的字段名字**

例如，定义一个 User 实体属于 Company 实体，那么外键的名字一般使用 CompanyID。

GORM 同时提供自定义外键名字的方式，如下例所示。

```go
type User struct {
  gorm.Model
  Name         string
  CompanyRefer int
  Company      Company `gorm:"foreignKey:CompanyRefer"`
  // 使用 CompanyRefer 作为外键
}

type Company struct {
  ID   int
  Name string
}
```

#### 重写引用

对于 belongs to 关系，GORM 通常使用数据库表，主表（拥有者）的主键值作为外键参考。 正如上面的例子，我们使用主表 Company 中的主键字段 ID 作为外键的参考值。

如果在 Company 实体中设置了 User 实体，那么 GORM 会自动把 Company 中的 ID 属性保存到 User 的 CompanyID 属性中。

同样的，您也可以使用标签 `references` 来更改它，例如：

```go
type User struct {
  gorm.Model
  Name      string
  CompanyID string
  Company   Company `gorm:"references:Code"` // 使用 Code 作为引用
}

type Company struct {
  ID   int
  Code string
  Name string
}
```

#### 外键约束

你可以通过 `OnUpdate`, `OnDelete` 配置标签来增加关联关系的级联操作，如下面的例子，通过 GORM 可以完成用户和公司的级联更新和级联删除操作：

```go
type User struct {
  gorm.Model
  Name      string
  CompanyID int
  Company   Company `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}

type Company struct {
  ID   int
  Name string
}
```

### Has One

`has one` 与另一个模型建立一对一的关联，但它和一对一关系有些许不同。 这种关联表明一个模型的每个实例都包含或拥有另一个模型的一个实例。

例如，您的应用包含 user 和 credit card 模型，且每个 user 只能有一张 credit card。

```go
// User 有一张 CreditCard，UserID 是外键
type User struct {
  gorm.Model
  CreditCard CreditCard
}

type CreditCard struct {
  gorm.Model
  Number string
  UserID uint
}
```

#### 重写外键

对于 `has one` 关系，同样必须存在外键字段。拥有者将把属于它的模型的主键保存到这个字段。

这个字段的名称通常**由 `has one` 模型的类型加上其 `主键` 生成**，对于上面的例子，它是 `UserID`。

为 user 添加 credit card 时，它会将 user 的 `ID` 保存到自己的 `UserID` 字段。

如果你想要使用另一个字段来保存该关系，你同样可以使用标签 `foreignKey` 来更改它，例如：

```go
type User struct {
  gorm.Model
  CreditCard CreditCard `gorm:"foreignKey:UserName"`
  // 使用 UserName 作为外键
}

type CreditCard struct {
  gorm.Model
  Number   string
  UserName string
}
```

#### 重写引用

默认情况下，**拥有者实体会将 `has one` 对应模型的主键保存为外键**，您也可以修改它，用另一个字段来保存，例如下个这个使用 `Name` 来保存的例子。

您可以使用标签 `references` 来更改它，例如：

```go
type User struct {
  gorm.Model
  Name       string     `gorm:"index"`
  CreditCard CreditCard `gorm:"foreignkey:UserName;references:name"`
}

type CreditCard struct {
  gorm.Model
  Number   string
  UserName string
}
```

#### 多态关联

GORM 为 `has one` 和 `has many` 提供了多态关联支持，它会将拥有者实体的表名、主键值都保存到多态类型的字段中。

```go
type Cat struct {
  ID    int
  Name  string
  Toy   Toy `gorm:"polymorphic:Owner;"`
}

type Dog struct {
  ID   int
  Name string
  Toy  Toy `gorm:"polymorphic:Owner;"`
}

type Toy struct {
  ID        int
  Name      string
  OwnerID   int
  OwnerType string
}

db.Create(&Dog{Name: "dog1", Toy: Toy{Name: "toy1"}})
// INSERT INTO `dogs` (`name`) VALUES ("dog1")
// INSERT INTO `toys` (`name`,`owner_id`,`owner_type`) VALUES ("toy1","1","dogs")
```

您可以使用标签 `polymorphicValue` 来更改多态类型的值，例如：

```go
type Dog struct {
  ID   int
  Name string
  Toy  Toy `gorm:"polymorphic:Owner;polymorphicValue:master"`
}

type Toy struct {
  ID        int
  Name      string
  OwnerID   int
  OwnerType string
}

db.Create(&Dog{Name: "dog1", Toy: Toy{Name: "toy1"}})
// INSERT INTO `dogs` (`name`) VALUES ("dog1")
// INSERT INTO `toys` (`name`,`owner_id`,`owner_type`) VALUES ("toy1","1","master")
```

#### 自引用 Has One

```go
type User struct {
  gorm.Model
  Name      string
  ManagerID *uint
  Manager   *User
}
```

#### 外键约束

你可以通过为标签 `constraint` 配置 `OnUpdate`、`OnDelete` 实现外键约束，在使用 GORM 进行迁移时它会被创建，例如：

```go
type User struct {
  gorm.Model
  CreditCard CreditCard `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}

type CreditCard struct {
  gorm.Model
  Number string
  UserID uint
}
```

你也可以在删除记录时通过 `Select` 来删除关联的记录

### Has Many

`has many` 与另一个模型建立了一对多的连接。 不同于 `has one`，拥有者可以有零或多个关联模型。

例如，您的应用包含 user 和 credit card 模型，且每个 user 可以有多张 credit card。

```go
// User 有多张 CreditCard，UserID 是外键
type User struct {
  gorm.Model
  CreditCards []CreditCard
}

type CreditCard struct {
  gorm.Model
  Number string
  UserID uint
}
```

#### 重写外键

要定义 `has many` 关系，同样必须存在外键。 默认的外键名是拥有者的类型名加上其主键字段名

例如，要定义一个属于 `User` 的模型，则其外键应该是 `UserID`。

此外，想要使用另一个字段作为外键，您可以使用 `foreignKey` 标签自定义它：

```go
type User struct {
  gorm.Model
  CreditCards []CreditCard `gorm:"foreignKey:UserRefer"`
}

type CreditCard struct {
  gorm.Model
  Number    string
  UserRefer uint
}
```

#### 重写引用

GORM 通常使用拥有者的主键作为外键的值。 对于上面的例子，它是 `User` 的 `ID` 字段。

为 user 添加 credit card 时，GORM 会将 user 的 `ID` 字段保存到 credit card 的 `UserID` 字段。

同样的，您也可以使用标签 `references` 来更改它，例如：

```go
type User struct {
  gorm.Model
  MemberNumber string
  CreditCards  []CreditCard `gorm:"foreignKey:UserNumber;references:MemberNumber"`
}

type CreditCard struct {
  gorm.Model
  Number     string
  UserNumber string
}
```

#### 多态关联

GORM 为 `has one` 和 `has many` 提供了多态关联支持，它会将拥有者实体的表名、主键都保存到多态类型的字段中。

```go
type Dog struct {
  ID   int
  Name string
  Toys []Toy `gorm:"polymorphic:Owner;"`
}

type Toy struct {
  ID        int
  Name      string
  OwnerID   int
  OwnerType string
}

db.Create(&Dog{Name: "dog1", Toys: []Toy{{Name: "toy1"}, {Name: "toy2"}}})
// INSERT INTO `dogs` (`name`) VALUES ("dog1")
// INSERT INTO `toys` (`name`,`owner_id`,`owner_type`) VALUES ("toy1","1","dogs"), ("toy2","1","dogs")
```

您可以使用标签 `polymorphicValue` 来更改多态类型的值，例如：

```go
type Dog struct {
  ID   int
  Name string
  Toys []Toy `gorm:"polymorphic:Owner;polymorphicValue:master"`
}

type Toy struct {
  ID        int
  Name      string
  OwnerID   int
  OwnerType string
}

db.Create(&Dog{Name: "dog1", Toys: []Toy{{Name: "toy1"}, {Name: "toy2"}}})
// INSERT INTO `dogs` (`name`) VALUES ("dog1")
// INSERT INTO `toys` (`name`,`owner_id`,`owner_type`) VALUES ("toy1","1","master"), ("toy2","1","master")
```

#### 自引用 Has Many

```go
type User struct {
  gorm.Model
  Name      string
  ManagerID *uint
  Team      []User `gorm:"foreignkey:ManagerID"`
}
```

#### 外键约束

你可以通过为标签 `constraint` 配置 `OnUpdate`、`OnDelete` 实现外键约束，在使用 GORM 进行迁移时它会被创建，例如：

```go
type User struct {
  gorm.Model
  CreditCards []CreditCard `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}

type CreditCard struct {
  gorm.Model
  Number string
  UserID uint
}
```

你也可以在删除记录时通过 `Select` 来删除 has many 关联的记录

### Many To Many

Many to Many 会在两个 model 中添加一张连接表。

例如，您的应用包含了 user 和 language，且一个 user 可以说多种 language，多个 user 也可以说一种 language。

```go
// User 拥有并属于多种 language，`user_languages` 是连接表
type User struct {
  gorm.Model
  Languages []Language `gorm:"many2many:user_languages;"`
}

type Language struct {
  gorm.Model
  Name string
}
```

当使用 GORM 的 `AutoMigrate` 为 `User` 创建表时，GORM 会自动创建连接表

#### 反向引用

```go
// User 拥有并属于多种 language，`user_languages` 是连接表
type User struct {
  gorm.Model
  Languages []*Language `gorm:"many2many:user_languages;"`
}

type Language struct {
  gorm.Model
  Name string
  Users []*User `gorm:"many2many:user_languages;"`
}
```

#### 重写外键

对于 `many2many` 关系，连接表会同时拥有两个模型的外键，例如：

```go
type User struct {
  gorm.Model
  Languages []Language `gorm:"many2many:user_languages;"`
}

type Language struct {
  gorm.Model
  Name string
}

// 连接表：user_languages
//   foreign key: user_id, reference: users.id
//   foreign key: language_id, reference: languages.id
```

若要重写它们，可以使用标签 `foreignKey`、`references`、`joinforeignKey`、`joinReferences`。当然，您不需要使用全部的标签，你可以仅使用其中的一个重写部分的外键、引用。

```go
type User struct {
    gorm.Model
    Profiles []Profile `gorm:"many2many:user_profiles;foreignKey:Refer;joinForeignKey:UserReferID;References:UserRefer;joinReferences:ProfileRefer"`
    Refer    uint      `gorm:"index:,unique"`
}

type Profile struct {
    gorm.Model
    Name      string
    UserRefer uint `gorm:"index:,unique"`
}

// 会创建连接表：user_profiles
//   foreign key: user_refer_id, reference: users.refer
//   foreign key: profile_refer, reference: profiles.user_refer
```

> **注意：** 某些数据库只允许在唯一索引字段上创建外键，如果您在迁移时会创建外键，则需要指定 `unique index` 标签。

#### 自引用 Many2Many

自引用 many2many 关系

```go
type User struct {
  gorm.Model
    Friends []*User `gorm:"many2many:user_friends"`
}

// 会创建连接表：user_friends
//   foreign key: user_id, reference: users.id
//   foreign key: friend_id, reference: users.id
```

#### 自定义连接表

`连接表` 可以是一个全功能的模型，支持 `Soft Delete`、`钩子`、更多的字段，就跟其它模型一样。您可以通过 `SetupJoinTable` 指定它，例如：

> **注意：** 自定义连接表要求外键是复合主键或复合唯一索引

```go
type Person struct {
  ID        int
  Name      string
  Addresses []Address `gorm:"many2many:person_addresses;"`
}

type Address struct {
  ID   uint
  Name string
}

type PersonAddress struct {
  PersonID  int `gorm:"primaryKey"`
  AddressID int `gorm:"primaryKey"`
  CreatedAt time.Time
  DeletedAt gorm.DeletedAt
}

func (PersonAddress) BeforeCreate(db *gorm.DB) error {
  // ...
}

// 修改 Person 的 Addresses 字段的连接表为 PersonAddress
// PersonAddress 必须定义好所需的外键，否则会报错
err := db.SetupJoinTable(&Person{}, "Addresses", &PersonAddress{})
```

#### 外键约束

你可以通过为标签 `constraint` 配置 `OnUpdate`、`OnDelete` 实现外键约束，在使用 GORM 进行迁移时它会被创建，例如：

```go
type User struct {
  gorm.Model
  Languages []Language `gorm:"many2many:user_speaks;"`
}

type Language struct {
  Code string `gorm:"primarykey"`
  Name string
}

// CREATE TABLE `user_speaks` (`user_id` integer,`language_code` text,PRIMARY KEY (`user_id`,`language_code`),CONSTRAINT `fk_user_speaks_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,CONSTRAINT `fk_user_speaks_language` FOREIGN KEY (`language_code`) REFERENCES `languages`(`code`) ON DELETE SET NULL ON UPDATE CASCADE);
```

你也可以在删除记录时通过 `Select` 来删除 many2many 关系的记录，查看 [Delete with Select](https://gorm.io/zh_CN/docs/associations.html#delete_with_select) 获取详情

#### 复合外键

如果您的模型使用了 [复合主键](https://gorm.io/zh_CN/docs/composite_primary_key.html)，GORM 会**默认启用复合外键**。

您也可以覆盖默认的外键、指定多个外键，只需用逗号分隔那些键名，例如：

```go
type Tag struct {
  ID     uint   `gorm:"primaryKey"`
  Locale string `gorm:"primaryKey"`
  Value  string
}

type Blog struct {
  ID         uint   `gorm:"primaryKey"`
  Locale     string `gorm:"primaryKey"`
  Subject    string
  Body       string
  Tags       []Tag `gorm:"many2many:blog_tags;"`
  LocaleTags []Tag `gorm:"many2many:locale_blog_tags;ForeignKey:id,locale;References:id"`
  SharedTags []Tag `gorm:"many2many:shared_blog_tags;ForeignKey:id;References:id"`
}

// 连接表：blog_tags
//   foreign key: blog_id, reference: blogs.id
//   foreign key: blog_locale, reference: blogs.locale
//   foreign key: tag_id, reference: tags.id
//   foreign key: tag_locale, reference: tags.locale

// 连接表：locale_blog_tags
//   foreign key: blog_id, reference: blogs.id
//   foreign key: blog_locale, reference: blogs.locale
//   foreign key: tag_id, reference: tags.id

// 连接表：shared_blog_tags
//   foreign key: blog_id, reference: blogs.id
//   foreign key: tag_id, reference: tags.id
```

### 关联模式

#### 自动创建、更新

在创建、更新记录时，GORM 会通过 [Upsert](https://gorm.io/zh_CN/docs/create.html#upsert) 自动保存关联及其引用记录。

```go
user := User{
  Name:            "jinzhu",
  BillingAddress:  Address{Address1: "Billing Address - Address 1"},
  ShippingAddress: Address{Address1: "Shipping Address - Address 1"},
  Emails:          []Email{
    {Email: "jinzhu@example.com"},
    {Email: "jinzhu-2@example.com"},
  },
  Languages:       []Language{
    {Name: "ZH"},
    {Name: "EN"},
  },
}

db.Create(&user)
// BEGIN TRANSACTION;
// INSERT INTO "addresses" (address1) VALUES ("Billing Address - Address 1"), ("Shipping Address - Address 1") ON DUPLICATE KEY DO NOTHING;
// INSERT INTO "users" (name,billing_address_id,shipping_address_id) VALUES ("jinzhu", 1, 2);
// INSERT INTO "emails" (user_id,email) VALUES (111, "jinzhu@example.com"), (111, "jinzhu-2@example.com") ON DUPLICATE KEY DO NOTHING;
// INSERT INTO "languages" ("name") VALUES ('ZH'), ('EN') ON DUPLICATE KEY DO NOTHING;
// INSERT INTO "user_languages" ("user_id","language_id") VALUES (111, 1), (111, 2) ON DUPLICATE KEY DO NOTHING;
// COMMIT;

db.Save(&user)
```

如果您想要更新关联的数据，您应该使用 `FullSaveAssociations` 模式：

```go
db.Session(&gorm.Session{FullSaveAssociations: true}).Updates(&user)
// ...
// INSERT INTO "addresses" (address1) VALUES ("Billing Address - Address 1"), ("Shipping Address - Address 1") ON DUPLICATE KEY SET address1=VALUES(address1);
// INSERT INTO "users" (name,billing_address_id,shipping_address_id) VALUES ("jinzhu", 1, 2);
// INSERT INTO "emails" (user_id,email) VALUES (111, "jinzhu@example.com"), (111, "jinzhu-2@example.com") ON DUPLICATE KEY SET email=VALUES(email);
// ...
```

#### 跳过自动创建、更新

若要在创建、更新时跳过自动保存，您可以使用 `Select` 或 `Omit`，例如：

```go
user := User{
  Name:            "jinzhu",
  BillingAddress:  Address{Address1: "Billing Address - Address 1"},
  ShippingAddress: Address{Address1: "Shipping Address - Address 1"},
  Emails:          []Email{
    {Email: "jinzhu@example.com"},
    {Email: "jinzhu-2@example.com"},
  },
  Languages:       []Language{
    {Name: "ZH"},
    {Name: "EN"},
  },
}

db.Select("Name").Create(&user)
// INSERT INTO "users" (name) VALUES ("jinzhu", 1, 2);

db.Omit("BillingAddress").Create(&user)
// Skip create BillingAddress when creating a user

db.Omit(clause.Associations).Create(&user)
// Skip all associations when creating a user
```

> **NOTE:** 对于 many2many 关联，GORM 在创建连接表引用之前，会先 upsert 关联。如果你想跳过关联的 upsert，你可以这样做：
>
> ```
> db.Omit("Languages.*").Create(&user)
> ```
>
> 下面的代码将跳过创建关联及其引用
>
> ```
> db.Omit("Languages").Create(&user)
> ```

#### Select/Omit 关联字段

```go
user := User{
  Name:            "jinzhu",
  BillingAddress:  Address{Address1: "Billing Address - Address 1", Address2: "addr2"},
  ShippingAddress: Address{Address1: "Shipping Address - Address 1", Address2: "addr2"},
}

// 创建 user 及其 BillingAddress、ShippingAddress
// 在创建 BillingAddress 时，仅使用其 address1、address2 字段，忽略其它字段
db.Select("BillingAddress.Address1", "BillingAddress.Address2").Create(&user)

db.Omit("BillingAddress.Address2", "BillingAddress.CreatedAt").Create(&user)
```

#### 关联模式

关联模式包含一些在处理关系时有用的方法

```go
// 开始关联模式
var user User
db.Model(&user).Association("Languages")
// `user` 是源模型，它的主键不能为空
// 关系的字段名是 `Languages`
// 如果匹配了上面两个要求，会开始关联模式，否则会返回错误
db.Model(&user).Association("Languages").Error
```

##### 查找关联

查找所有匹配的关联记录

```go
db.Model(&user).Association("Languages").Find(&languages)
```

查找带条件的关联

```sql
select * from courses as c, selections as sc where sc.student_id = 1 and c.id = sc.co 
```

```go
codes := []string{"zh-CN", "en-US", "ja-JP"}
db.Model(&user).Where("code IN ?", codes).Association("Languages").Find(&languages)

db.Model(&user).Where("code IN ?", codes).Order("code desc").Association("Languages").Find(&languages)
```

##### 添加关联

为 `many to many`、`has many` 添加新的关联；为 `has one`,  `belongs to` 替换当前的关联

```go
db.Model(&user).Association("Languages").Append([]Language{languageZH, languageEN})

db.Model(&user).Association("Languages").Append(&Language{Name: "DE"})

db.Model(&user).Association("CreditCard").Append(&CreditCard{Number: "411111111111"})
```

##### 替换关联

用一个新的关联替换当前的关联

```go
db.Model(&user).Association("Languages").Replace([]Language{languageZH, languageEN})

db.Model(&user).Association("Languages").Replace(Language{Name: "DE"}, languageEN)
```

##### 删除关联

如果存在，则删除源模型与参数之间的关系，**只会删除引用，不会从数据库中删除这些对象**。

```go
db.Model(&user).Association("Languages").Delete([]Language{languageZH, languageEN})
db.Model(&user).Association("Languages").Delete(languageZH, languageEN)
```

##### 清空关联

删除源模型与关联之间的所有引用，但不会删除这些关联

```go
db.Model(&user).Association("Languages").Clear()
```

##### 关联计数

返回当前关联的计数

```go
db.Model(&user).Association("Languages").Count()

// 条件计数
codes := []string{"zh-CN", "en-US", "ja-JP"}
db.Model(&user).Where("code IN ?", codes).Association("Languages").Count()
```

##### 批量处理数据

关联模式也支持批量处理，例如：

```go
// 查询所有用户的所有角色
db.Model(&users).Association("Role").Find(&roles)

// 从所有 team 中删除 user A
db.Model(&users).Association("Team").Delete(&userA)

// 获取去重的用户所属 team 数量
db.Model(&users).Association("Team").Count()

// 对于批量数据的 `Append`、`Replace`，参数的长度必须与数据的长度相同，否则会返回 error
var users = []User{user1, user2, user3}
// 例如：现在有三个 user，Append userA 到 user1 的 team，Append userB 到 user2 的 team，Append userA、userB 和 userC 到 user3 的 team
db.Model(&users).Association("Team").Append(&userA, &userB, &[]User{userA, userB, userC})
// 重置 user1 team 为 userA，重置 user2 的 team 为 userB，重置 user3 的 team 为 userA、 userB 和 userC
db.Model(&users).Association("Team").Replace(&userA, &userB, &[]User{userA, userB, userC})
```

#### 带 Select 的删除

你可以在删除记录时通过 `Select` 来删除具有 has one、has many、many2many 关系的记录，例如：

```go
// 删除 user 时，也删除 user 的 account
db.Select("Account").Delete(&user)

// 删除 user 时，也删除 user 的 Orders、CreditCards 记录
db.Select("Orders", "CreditCards").Delete(&user)

// 删除 user 时，也删除用户所有 has one/many、many2many 记录
db.Select(clause.Associations).Delete(&user)

// 删除 users 时，也删除每一个 user 的 account
db.Select("Account").Delete(&users)
```

> **注意：** 只有当记录的主键不为空时，关联才会被删除，GORM 会使用这些主键作为条件来删除关联记录
>
> ```go
> // DOESN'T WORK
> db.Select("Account").Where("name = ?", "jinzhu").Delete(&User{})
> // 会删除所有 name=`jinzhu` 的 user，但这些 user 的 account 不会被删除
> 
> db.Select("Account").Where("name = ?", "jinzhu").Delete(&User{ID: 1})
> // 会删除 name = `jinzhu` 且 id = `1` 的 user，并且 user `1` 的 account 也会被删除
> 
> db.Select("Account").Delete(&User{ID: 1})
> // 会删除 id = `1` 的 user，并且 user `1` 的 account 也会被删除
> ```

#### 关联标签

| 标签             | 描述                                     |
| :--------------- | :--------------------------------------- |
| foreignKey       | 指定当前模型的列作为连接表的外键         |
| references       | 指定引用表的列名，其将被映射为连接表外键 |
| polymorphic      | 指定多态类型，比如模型名                 |
| polymorphicValue | 指定多态值、默认表名                     |
| many2many        | 指定连接表表名                           |
| joinForeignKey   | 指定连接表的外键列名，其将被映射到当前表 |
| joinReferences   | 指定连接表的外键列名，其将被映射到引用表 |
| constraint       | 关系约束，例如：`OnUpdate`、`OnDelete`   |

### 预加载

GORM 允许在 `Preload` 的其它 SQL 中直接加载关系，例如：

```go
type User struct {
  gorm.Model
  Username string
  Orders   []Order
}

type Order struct {
  gorm.Model
  UserID uint
  Price  float64
}

// 查找 user 时预加载相关 Order
db.Preload("Orders").Find(&users)
// SELECT * FROM users;
// SELECT * FROM orders WHERE user_id IN (1,2,3,4);

db.Preload("Orders").Preload("Profile").Preload("Role").Find(&users)
// SELECT * FROM users;
// SELECT * FROM orders WHERE user_id IN (1,2,3,4); // has many
// SELECT * FROM profiles WHERE user_id IN (1,2,3,4); // has one
// SELECT * FROM roles WHERE id IN (4,5,6); // belongs to
```

#### Joins 预加载

`Preload` 在一个单独查询中加载关联数据。而 `Join Preload` 会使用 inner join 加载关联数据，例如：

```go
db.Joins("Company").Joins("Manager").Joins("Account").First(&user, 1)
db.Joins("Company").Joins("Manager").Joins("Account").First(&user, "users.name = ?", "jinzhu")
db.Joins("Company").Joins("Manager").Joins("Account").Find(&users, "users.id IN ?", []int{1,2,3,4,5})
```

带条件的 Join

```go
db.Joins("Company", DB.Where(&Company{Alive: true})).Find(&users)
// SELECT `users`.`id`,`users`.`name`,`users`.`age`,`Company`.`id` AS `Company__id`,`Company`.`name` AS `Company__name` FROM `users` LEFT JOIN `companies` AS `Company` ON `users`.`company_id` = `Company`.`id` AND `Company`.`alive` = true;
```

> **注意** `Join Preload` 适用于**一对一**的关系，例如： `has one`, `belongs to`

#### 预加载全部

与创建、更新时使用 `Select` 类似，`clause.Associations` 也可以和 `Preload` 一起使用，它可以用来 `预加载` 全部关联，例如：

```go
type User struct {
  gorm.Model
  Name       string
  CompanyID  uint
  Company    Company
  Role       Role
  Orders     []Order
}

db.Preload(clause.Associations).Find(&users)
```

`clause.Associations` **不会预加载嵌套的关联**，但你可以使用[嵌套预加载](https://gorm.io/zh_CN/docs/preload.html#nested_preloading) 例如：

```go
db.Preload("Orders.OrderItems.Product").Preload(clause.Associations).Find(&users)
```

#### 带条件的预加载

GORM 允许带条件的 Preload 关联，类似于[内联条件](https://gorm.io/zh_CN/docs/query.html#inline_conditions)

```go
// 带条件的预加载 Order
db.Preload("Orders", "state NOT IN (?)", "cancelled").Find(&users)
// SELECT * FROM users;
// SELECT * FROM orders WHERE user_id IN (1,2,3,4) AND state NOT IN ('cancelled');

db.Where("state = ?", "active").Preload("Orders", "state NOT IN (?)", "cancelled").Find(&users)
// SELECT * FROM users WHERE state = 'active';
// SELECT * FROM orders WHERE user_id IN (1,2) AND state NOT IN ('cancelled');
```

#### 自定义预加载 SQL

您可以通过 `func(db *gorm.DB) *gorm.DB` 实现自定义预加载 SQL，例如：

```go
db.Preload("Orders", func(db *gorm.DB) *gorm.DB {
  return db.Order("orders.amount DESC")
}).Find(&users)
// SELECT * FROM users;
// SELECT * FROM orders WHERE user_id IN (1,2,3,4) order by orders.amount DESC;
```

#### 嵌套预加载

GORM 支持嵌套预加载，例如：

```go
db.Preload("Orders.OrderItems.Product").Preload("CreditCard").Find(&users)

// 自定义预加载 `Orders` 的条件
// 这样，GORM 就不会加载不匹配的 order 记录
db.Preload("Orders", "state = ?", "paid").Preload("Orders.OrderItems").Find(&users)
```

## 高级查询

### 智能选择字段

GORM 允许通过 [`Select`](https://gorm.io/zh_CN/docs/query.html) 方法选择特定的字段，如果您在应用程序中经常使用此功能，你也可以定义一个较小的结构体，以实现调用 API 时自动选择特定的字段，例如：

```go
type User struct {
  ID     uint
  Name   string
  Age    int
  Gender string
  // 假设后面还有几百个字段...
}

type APIUser struct {
  ID   uint
  Name string
}

// 查询时会自动选择 `id`, `name` 字段
db.Model(&User{}).Limit(10).Find(&APIUser{})
// SELECT `id`, `name` FROM `users` LIMIT 10
```

> **注意** `QueryFields` 模式会根据当前 model 的所有字段名称进行 select。

```go
db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{
  QueryFields: true,
})

db.Find(&user)
// SELECT `users`.`name`, `users`.`age`, ... FROM `users` // 带上这个选项

// Session Mode
db.Session(&gorm.Session{QueryFields: true}).Find(&user)
// SELECT `users`.`name`, `users`.`age`, ... FROM `users`
```

### Locking (FOR UPDATE)

GORM 支持多种类型的锁，例如：

```go
db.Clauses(clause.Locking{Strength: "UPDATE"}).Find(&users)
// SELECT * FROM `users` FOR UPDATE

db.Clauses(clause.Locking{
  Strength: "SHARE",
  Table: clause.Table{Name: clause.CurrentTable},
}).Find(&users)
// SELECT * FROM `users` FOR SHARE OF `users`

db.Clauses(clause.Locking{
  Strength: "UPDATE",
  Options: "NOWAIT",
}).Find(&users)
// SELECT * FROM `users` FOR UPDATE NOWAIT
```

查看 [原生 SQL 及构造器](https://gorm.io/zh_CN/docs/sql_builder.html) 获取详情

### 子查询

子查询可以嵌套在查询中，GORM 允许在使用 `*gorm.DB` 对象作为参数时生成子查询

```go
db.Where("amount > (?)", db.Table("orders").Select("AVG(amount)")).Find(&orders)
// SELECT * FROM "orders" WHERE amount > (SELECT AVG(amount) FROM "orders");

subQuery := db.Select("AVG(age)").Where("name LIKE ?", "name%").Table("users")
db.Select("AVG(age) as avgage").Group("name").Having("AVG(age) > (?)", subQuery).Find(&results)
// SELECT AVG(age) as avgage FROM `users` GROUP BY `name` HAVING AVG(age) > (SELECT AVG(age) FROM `users` WHERE name LIKE "name%")
```

### From 子查询

GORM 允许您在 `Table` 方法中通过 FROM 子句使用子查询，例如：

```go
db.Table("(?) as u", db.Model(&User{}).Select("name", "age")).Where("age = ?", 18}).Find(&User{})
// SELECT * FROM (SELECT `name`,`age` FROM `users`) as u WHERE `age` = 18

subQuery1 := db.Model(&User{}).Select("name")
subQuery2 := db.Model(&Pet{}).Select("name")
db.Table("(?) as u, (?) as p", subQuery1, subQuery2).Find(&User{})
// SELECT * FROM (SELECT `name` FROM `users`) as u, (SELECT `name` FROM `pets`) as p
```

### Group 条件

使用 Group 条件可以更轻松的编写复杂 SQL

```go
db.Where(
    db.Where("pizza = ?", "pepperoni").Where(db.Where("size = ?", "small").Or("size = ?", "medium")),
).Or(
    db.Where("pizza = ?", "hawaiian").Where("size = ?", "xlarge"),
).Find(&Pizza{}).Statement

// SELECT * FROM `pizzas` WHERE (pizza = "pepperoni" AND (size = "small" OR size = "medium")) OR (pizza = "hawaiian" AND size = "xlarge")
```

### 带多个列的 in

带多个列的 in 查询

```go
db.Where("(name, age, role) IN ?", [][]interface{}{{"jinzhu", 18, "admin"}, {"jinzhu2", 19, "user"}}).Find(&users)
// SELECT * FROM users WHERE (name, age, role) IN (("jinzhu", 18, "admin"), ("jinzhu 2", 19, "user"));
```

### 命名参数

GORM 支持 [`sql.NamedArg`](https://tip.golang.org/pkg/database/sql/#NamedArg) 和 `map[string]interface{}{}` 形式的命名参数，例如：

```go
db.Where("name1 = @name OR name2 = @name", sql.Named("name", "jinzhu")).Find(&user)
// SELECT * FROM `users` WHERE name1 = "jinzhu" OR name2 = "jinzhu"

db.Where("name1 = @name OR name2 = @name", map[string]interface{}{"name": "jinzhu"}).First(&user)
// SELECT * FROM `users` WHERE name1 = "jinzhu" OR name2 = "jinzhu" ORDER BY `users`.`id` LIMIT 1
```

查看 [原生 SQL 及构造器](https://gorm.io/zh_CN/docs/sql_builder.html#named_argument) 获取详情

### Find 至 map

GORM 允许扫描结果至 `map[string]interface{}` 或 `[]map[string]interface{}`，此时别忘了指定 `Model` 或 `Table`，例如：

```go
result := map[string]interface{}{}
db.Model(&User{}).First(&result, "id = ?", 1)

var results []map[string]interface{}
db.Table("users").Find(&results)
```

### FirstOrInit

获取第一条匹配的记录，或者根据给定的条件初始化一个实例（仅支持 sturct 和 map 条件）

```go
// 未找到 user，则根据给定的条件初始化一条记录
db.FirstOrInit(&user, User{Name: "non_existing"})
// user -> User{Name: "non_existing"}

// 找到了 `name` = `jinzhu` 的 user
db.Where(User{Name: "jinzhu"}).FirstOrInit(&user)
// user -> User{ID: 111, Name: "Jinzhu", Age: 18}

// 找到了 `name` = `jinzhu` 的 user
db.FirstOrInit(&user, map[string]interface{}{"name": "jinzhu"})
// user -> User{ID: 111, Name: "Jinzhu", Age: 18}
```

如果没有找到记录，可以使用包含更多的属性的结构体初始化 user，`Attrs` 不会被用于生成查询 SQL

```go
// 未找到 user，则根据给定的条件以及 Attrs 初始化 user
db.Where(User{Name: "non_existing"}).Attrs(User{Age: 20}).FirstOrInit(&user)
// SELECT * FROM USERS WHERE name = 'non_existing' ORDER BY id LIMIT 1;
// user -> User{Name: "non_existing", Age: 20}

// 未找到 user，则根据给定的条件以及 Attrs 初始化 user
db.Where(User{Name: "non_existing"}).Attrs("age", 20).FirstOrInit(&user)
// SELECT * FROM USERS WHERE name = 'non_existing' ORDER BY id LIMIT 1;
// user -> User{Name: "non_existing", Age: 20}

// 找到了 `name` = `jinzhu` 的 user，则忽略 Attrs
db.Where(User{Name: "Jinzhu"}).Attrs(User{Age: 20}).FirstOrInit(&user)
// SELECT * FROM USERS WHERE name = jinzhu' ORDER BY id LIMIT 1;
// user -> User{ID: 111, Name: "Jinzhu", Age: 18}
```

不管是否找到记录，`Assign` 都会将属性赋值给 struct，但这些属性不会被用于生成查询 SQL，也不会被保存到数据库

```go
// 未找到 user，根据条件和 Assign 属性初始化 struct
db.Where(User{Name: "non_existing"}).Assign(User{Age: 20}).FirstOrInit(&user)
// user -> User{Name: "non_existing", Age: 20}

// 找到 `name` = `jinzhu` 的记录，依然会更新 Assign 相关的属性
db.Where(User{Name: "Jinzhu"}).Assign(User{Age: 20}).FirstOrInit(&user)
// SELECT * FROM USERS WHERE name = jinzhu' ORDER BY id LIMIT 1;
// user -> User{ID: 111, Name: "Jinzhu", Age: 20}
```

### FirstOrCreate

获取第一条匹配的记录，或者根据给定的条件创建一条新纪录（仅支持 sturct 和 map 条件）

```go
// 未找到 user，则根据给定条件创建一条新纪录
db.FirstOrCreate(&user, User{Name: "non_existing"})
// INSERT INTO "users" (name) VALUES ("non_existing");
// user -> User{ID: 112, Name: "non_existing"}

// 找到了 `name` = `jinzhu` 的 user
db.Where(User{Name: "jinzhu"}).FirstOrCreate(&user)
// user -> User{ID: 111, Name: "jinzhu", "Age": 18}
```

如果没有找到记录，可以使用包含更多的属性的结构体创建记录，`Attrs` 不会被用于生成查询 SQL 。

```go
// 未找到 user，根据条件和 Assign 属性创建记录
db.Where(User{Name: "non_existing"}).Attrs(User{Age: 20}).FirstOrCreate(&user)
// SELECT * FROM users WHERE name = 'non_existing' ORDER BY id LIMIT 1;
// INSERT INTO "users" (name, age) VALUES ("non_existing", 20);
// user -> User{ID: 112, Name: "non_existing", Age: 20}

// 找到了 `name` = `jinzhu` 的 user，则忽略 Attrs
db.Where(User{Name: "jinzhu"}).Attrs(User{Age: 20}).FirstOrCreate(&user)
// SELECT * FROM users WHERE name = 'jinzhu' ORDER BY id LIMIT 1;
// user -> User{ID: 111, Name: "jinzhu", Age: 18}
```

不管是否找到记录，`Assign` 都会将属性赋值给 struct，并将结果写回数据库

```go
// 未找到 user，根据条件和 Assign 属性创建记录
db.Where(User{Name: "non_existing"}).Assign(User{Age: 20}).FirstOrCreate(&user)
// SELECT * FROM users WHERE name = 'non_existing' ORDER BY id LIMIT 1;
// INSERT INTO "users" (name, age) VALUES ("non_existing", 20);
// user -> User{ID: 112, Name: "non_existing", Age: 20}

// 找到了 `name` = `jinzhu` 的 user，依然会根据 Assign 更新记录
db.Where(User{Name: "jinzhu"}).Assign(User{Age: 20}).FirstOrCreate(&user)
// SELECT * FROM users WHERE name = 'jinzhu' ORDER BY id LIMIT 1;
// UPDATE users SET age=20 WHERE id = 111;
// user -> User{ID: 111, Name: "jinzhu", Age: 20}
```

### 优化器、索引提示

**优化器提示**用于控制查询优化器选择某个查询执行计划，GORM 通过 `gorm.io/hints` 提供支持，例如：

```go
import "gorm.io/hints"

db.Clauses(hints.New("MAX_EXECUTION_TIME(10000)")).Find(&User{})
// SELECT * /*+ MAX_EXECUTION_TIME(10000) */ FROM `users`
```

**索引提示**允许传递索引提示到数据库，以防查询计划器出现混乱。

```go
import "gorm.io/hints"

db.Clauses(hints.UseIndex("idx_user_name")).Find(&User{})
// SELECT * FROM `users` USE INDEX (`idx_user_name`)

db.Clauses(hints.ForceIndex("idx_user_name", "idx_user_id").ForJoin()).Find(&User{})
// SELECT * FROM `users` FORCE INDEX FOR JOIN (`idx_user_name`,`idx_user_id`)"
```

参考 [优化器提示、索引、备注](https://gorm.io/zh_CN/docs/hints.html) 获取详情

### 迭代

GORM 支持通过行进行迭代

```go
rows, err := db.Model(&User{}).Where("name = ?", "jinzhu").Rows()
defer rows.Close()

for rows.Next() {
  var user User
  // ScanRows 方法用于将一行记录扫描至结构体
  db.ScanRows(rows, &user)

  // 业务逻辑...
}
```

### FindInBatches

用于批量查询并处理记录

```go
// 每次批量处理 100 条
result := db.Where("processed = ?", false).FindInBatches(&results, 100, func(tx *gorm.DB, batch int) error {
  for _, result := range results {
    // 批量处理找到的记录
  }

  tx.Save(&results)

  tx.RowsAffected // 本次批量操作影响的记录数

  batch // Batch 1, 2, 3

  // 如果返回错误会终止后续批量操作
  return nil
})

result.Error // returned error
result.RowsAffected // 整个批量操作影响的记录数
```

### 查询钩子

对于查询操作，GORM 支持 `AfterFind` 钩子，查询记录后会调用它，详情请参考 [钩子](https://gorm.io/zh_CN/docs/hooks.html)

```go
func (u *User) AfterFind(tx *gorm.DB) (err error) {
  if u.Role == "" {
    u.Role = "user"
  }
  return
}
```

### Pluck

Pluck 用于从数据库查询单个列，并将结果扫描到切片。如果您想要查询多列，您应该使用 `Select` 和 [`Scan`](https://gorm.io/zh_CN/docs/query.html#scan)

```go
var ages []int64
db.Model(&users).Pluck("age", &ages)

var names []string
db.Model(&User{}).Pluck("name", &names)

db.Table("deleted_users").Pluck("name", &names)

// Distinct Pluck
db.Model(&User{}).Distinct().Pluck("Name", &names)
// SELECT DISTINCT `name` FROM `users`

// 超过一列的查询，应该使用 `Scan` 或者 `Find`，例如：
db.Select("name", "age").Scan(&users)
db.Select("name", "age").Find(&users)
```

### Scope

`Scopes` 允许你指定常用的查询，可以在调用方法时引用这些查询

```go
func AmountGreaterThan1000(db *gorm.DB) *gorm.DB {
  return db.Where("amount > ?", 1000)
}

func PaidWithCreditCard(db *gorm.DB) *gorm.DB {
  return db.Where("pay_mode_sign = ?", "C")
}

func PaidWithCod(db *gorm.DB) *gorm.DB {
  return db.Where("pay_mode_sign = ?", "C")
}

func OrderStatus(status []string) func (db *gorm.DB) *gorm.DB {
  return func (db *gorm.DB) *gorm.DB {
    return db.Where("status IN (?)", status)
  }
}

db.Scopes(AmountGreaterThan1000, PaidWithCreditCard).Find(&orders)
// 查找所有金额大于 1000 的信用卡订单

db.Scopes(AmountGreaterThan1000, PaidWithCod).Find(&orders)
// 查找所有金额大于 1000 的货到付款订单

db.Scopes(AmountGreaterThan1000, OrderStatus([]string{"paid", "shipped"})).Find(&orders)
// 查找所有金额大于 1000 且已付款或已发货的订单
```

查看 [Scopes](https://gorm.io/zh_CN/docs/scopes.html) 获取详情

### Count

Count 用于获取匹配的记录数

```go
var count int64
db.Model(&User{}).Where("name = ?", "jinzhu").Or("name = ?", "jinzhu 2").Count(&count)
// SELECT count(1) FROM users WHERE name = 'jinzhu' OR name = 'jinzhu 2'

db.Model(&User{}).Where("name = ?", "jinzhu").Count(&count)
// SELECT count(1) FROM users WHERE name = 'jinzhu'; (count)

db.Table("deleted_users").Count(&count)
// SELECT count(1) FROM deleted_users;

// Count with Distinct
db.Model(&User{}).Distinct("name").Count(&count)
// SELECT COUNT(DISTINCT(`name`)) FROM `users`

db.Table("deleted_users").Select("count(distinct(name))").Count(&count)
// SELECT count(distinct(name)) FROM deleted_users

// Count with Group
users := []User{
  {Name: "name1"},
  {Name: "name2"},
  {Name: "name3"},
  {Name: "name3"},
} // data in sql

db.Model(&User{}).Group("name").Count(&count)
count // => 3
```
