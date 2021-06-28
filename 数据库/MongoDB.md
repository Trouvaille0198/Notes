# MongoDB

## 认识

MongoDB 是由 C++ 语言编写的，是一个基于分布式文件存储的开源数据库系统

### 一些概念

| QL术语/概念 | MongoDB术语/概念 | 解释/说明                           |
| :---------- | :--------------- | :---------------------------------- |
| database    | database         | 数据库                              |
| table       | collection       | 数据库表/集合                       |
| row         | document         | 数据记录行/文档                     |
| column      | field            | 数据字段/域                         |
| index       | index            | 索引                                |
| table joins |                  | 表连接,MongoDB不支持                |
| primary key | primary key      | 主键,MongoDB自动将_id字段设置为主键 |

#### 数据库

数据库名可以是满足以下条件的任意 UTF-8 字符串。

- 不能是空字符串 `""`
- 不得含有 ' '（空格)、.、$、/、\和\0 (空字符)
- 应全部小写
- 最多 64 字节

有一些数据库名是保留的，可以直接访问这些有特殊作用的数据库。

- **admin**：从权限的角度来看，这是 "root" 数据库。要是将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。一些特定的服务器端命令也只能从这个数据库运行，比如列出所有的数据库或者关闭服务器。
- **local:** 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合
- **config**: 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息。

#### 文档

（Document）

文档是一组键值 (key-value) 对 (即 BSON)。MongoDB 的文档不需要设置相同的字段，并且相同的字段不需要相同的数据类型，这与关系型数据库有很大的区别，也是 MongoDB 非常突出的特点。

**注意**

1. 文档中的键/值对是有序的。
2. 文档中的值不仅可以是在双引号里面的字符串，还可以是其他几种数据类型（甚至可以是整个嵌入的文档)。
3. MongoDB 区分类型和大小写。
4. 文档不能有重复的键。
5. 文档的键是字符串。除了少数例外情况，键可以使用任意 UTF-8 字符。

**命名规范**

- 键不能含有 `\0` (空字符)。这个字符用来表示键的结尾。
- `.` 和 `$` 有特别的意义，只有在特定环境下才能使用。
- 以下划线 `_` 开头的键是保留的 (不严格要求)。

#### 集合

（Collections）

集合就是 MongoDB **文档组**，类似于 RDBMS （关系数据库管理系统：Relational Database Management System)中的**表格**。

集合存在于数据库中，集合没有固定的结构，这意味着你在对集合可以插入不同格式和类型的数据，但通常情况下我们插入集合的数据都会有一定的关联性

#### 数据类型

| 数据类型           | 描述                                                         |
| :----------------- | :----------------------------------------------------------- |
| String             | 字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。 |
| Integer            | 整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。 |
| Boolean            | 布尔值。用于存储布尔值（真/假）。                            |
| Double             | 双精度浮点值。用于存储浮点值。                               |
| Min/Max keys       | 将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。 |
| Array              | 用于将数组或列表或多个值存储为一个键。                       |
| Timestamp          | 时间戳。记录文档修改或添加的具体时间。                       |
| Object             | 用于内嵌文档。                                               |
| Null               | 用于创建空值。                                               |
| Symbol             | 符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。 |
| Date               | 日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。 |
| **Object ID**      | 对象 ID。用于创建文档的 ID。                                 |
| Binary Data        | 二进制数据。用于存储二进制数据。                             |
| Code               | 代码类型。用于在文档中存储 JavaScript 代码。                 |
| Regular expression | 正则表达式类型。用于存储正则表达式。                         |

### Mongo Shell 常用命令

- 显示所有数据库

    ```shell
    show dbs
    ```

- 显示当前数据库

    ```shell
    db
    ```

- 连接到指定数据库

    ```shell
    use DB_NAME
    ```

## 常用操作

### 数据库

#### 创建数据库

```shell
use DATABASE_NAME
```

> 在 MongoDB 中，集合只有在内容插入后才会创建! 也就是说，创建集合(数据表)后要再插入一个文档(记录)，集合才会真正创建。

#### 删除数据库

必须先用 `use` 命令选择要删除的数据库

```shell
db.dropDatabase()
```

删除当前数据库，默认为 test

### 集合

#### 创建集合

```shell
db.createCollection(name, options)
```

- name: 要创建的集合名称

- options: 可选参数，指定有关内存大小及索引的选项

    | 字段        | 类型 | 描述                                                         |
    | :---------- | :--- | :----------------------------------------------------------- |
    | capped      | 布尔 | （可选）如果为 true，则创建固定集合。固定集合是指有着固定大小的集合，当达到最大值时，它会自动覆盖最早的文档。 **当该值为 true 时，必须指定 size 参数。** |
    | autoIndexId | 布尔 | 3.2 之后不再支持该参数。（可选）如为 true，自动在 _id 字段创建索引。默认为 false。 |
    | size        | 数值 | （可选）为固定集合指定一个最大值，即字节数。 **如果 capped 为 true，也需要指定该字段。** |
    | max         | 数值 | （可选）指定固定集合中包含文档的最大数量。                   |

#### 删除集合

```shell
db.collection.drop()
```

如

```shell
db.createCollection("mycol")
db.createCollection("mycol", { capped : true, autoIndexId : true, size : 
   6142800, max : 10000 } )
```

在 MongoDB 中，你不需要创建集合。当你插入一些文档时，MongoDB 会自动创建集合。

#### 查看现有集合

```shell
show collections
```

### 文档

#### 插入

##### 插入单个文档

```shell
db.collection.insertOne()
```

- 返回一个文档，其中包含新插入的文档的_id字段值
- 如果文档未指定 **_id** 字段，则 MongoDB 将具有 **ObjectId** 值的 **_id** 字段添加到新文档中

参数

- writeConcern：写入策略，默认为 1，即要求确认写操作，0 是不要求。

例

```shell
db.inventory.insertOne(  
        { item: "canvas", qty: 100, tags: ["cotton"], size: { h: 28, w: 35.5, uom: "cm" } }
)
```

##### 插入多个文档

```shell
db.collection.insertMany()
```

参数

- writeConcern：写入策略，默认为 1，即要求确认写操作，0 是不要求。
- ordered：指定是否按顺序写入，默认 true，按顺序写入。

例

```shell
db.inventory.insertMany([
        { item: "journal", qty: 25, tags: ["blank", "red"], size: { h: 14, w: 21, uom: "cm" } }, 
        { item: "mat", qty: 85, tags: ["gray"], size: { h: 27.9, w: 35.5, uom: "cm" } },
        { item: "mousepad", qty: 25, tags: ["gel", "blue"], size: { h: 19, w: 22.85, uom: "cm" } }
    ])
```

> 如果欲插入到的集合当前不存在，则插入操作将创建该集合。

#### 删除

##### 删除集合

必须要先用 `use` 命令选择待删除集合的数据库

```shell
 db.collectionName.drop()
```

##### 清空集合

```shell
db.collectionName.remove({})
```

#### 查询

```shell
bd.collectionName.find(query, projection)
```

- **query** ：可选，使用查询操作符指定查询条件
- **projection** ：可选，使用投影操作符指定返回的键。查询时返回文档中所有键值， 只需省略该参数即可（默认省略）

若要以易读的方式读取数据，可以用

```shell
db.collectionName.find().pretty()
```

##### 选择集合中的所有文档

将空文档作为查询过滤器参数传递给 `find` 方法

```shell
db.collectionName.find( {} )
```

对应于

```mysql
SELECT * FROM collectionName
```

##### 仅返回指定的字段（和_id字段）

将投影文档中的 `<field>` 设置为 1

```shell
db.collectionName.find( { status: "A" }, { item: 1, status: 1 } )
```

对应于

```shell
SELECT _id, item, status from collectionName WHERE status = "A"
```

若要禁止返回默认的 `_id_`，添加 `_id: 0`

```shell
db.collectionName.find( { status: "A" }, { item: 1, status: 1, _id: 0 } )
```

##### 返回除了被排除的字段之外的所有字段

```shell
db.collectionName.find( { status: "A" }, { status: 0, instock: 0 } )
```

可以使用 projection 来排除特定的字段，而不是列出要在匹配的文档中返回的字段

##### 条件操作符

| 操作       | 格式                     | 范例                               | RDBMS中的类似语句   |
| :--------- | :----------------------- | :--------------------------------- | :------------------ |
| 等于       | `{<key>:<value>`}        | `db.col.find({"name":"Loulou"})`   | `where by = 'name'` |
| 小于       | `{<key>:{$lt:<value>}}`  | `db.col.find({"likes":{$lt:50}})`  | `where likes < 50`  |
| 小于或等于 | `{<key>:{$lte:<value>}}` | `db.col.find({"likes":{$lte:50}})` | `where likes <= 50` |
| 大于       | `{<key>:{$gt:<value>}}`  | `db.col.find({"likes":{$gt:50}})`  | `where likes > 50`  |
| 大于或等于 | `{<key>:{$gte:<value>}}` | `db.col.find({"likes":{$gte:50}})` | `where likes >= 50` |
| 不等于     | `{<key>:{$ne:<value>}}`  | `db.col.find({"likes":{$ne:50}})`  | `where likes != 50` |

- AND 条件：条件间以逗号隔开即可
- OR 条件：使用关键字 **$or**

例子

```shell
db.inventory.find( { status: "D" } )
db.inventory.find( { status: { $in: [ "A", "D" ] } } )
db.inventory.find( { status: "A", qty: { $lt: 30 } } )
db.inventory.find( { $or: [ { status: "A" }, { qty: { $lt: 30 } } ] } )
db.inventory.find( {
     status: "A",
     $or: [ { qty: { $lt: 30 } }, { item: /^p/ } ]
} )
```

##### `$type` 操作符

| **类型**                | **数字** | **备注**         |
| :---------------------- | :------- | :--------------- |
| Double                  | 1        |                  |
| String                  | 2        |                  |
| Object                  | 3        |                  |
| Array                   | 4        |                  |
| Binary data             | 5        |                  |
| Undefined               | 6        | 已废弃。         |
| Object id               | 7        |                  |
| Boolean                 | 8        |                  |
| Date                    | 9        |                  |
| Null                    | 10       |                  |
| Regular Expression      | 11       |                  |
| JavaScript              | 13       |                  |
| Symbol                  | 14       |                  |
| JavaScript (with scope) | 15       |                  |
| 32-bit integer          | 16       |                  |
| Timestamp               | 17       |                  |
| 64-bit integer          | 18       |                  |
| Min key                 | 255      | Query with `-1`. |
| Max key                 | 127      |                  |

```shell
db.collection.find({"title" : {$type : 2}})
```

#### 查询嵌入式文档数组

有例

```shell
db.inventory.insertMany( [
    { item: "journal", instock: [ { warehouse: "A", qty: 5 }, { warehouse: "C", qty: 15 } ] },  
    { item: "notebook", instock: [ { warehouse: "C", qty: 5 } ] },
    { item: "paper", instock: [ { warehouse: "A", qty: 60 }, { warehouse: "B", qty: 15 } ] },
    { item: "planner", instock: [ { warehouse: "A", qty: 40 }, { warehouse: "B", qty: 5 } ] }, 
    { item: "postcard", instock: [ { warehouse: "B", qty: 15 }, { warehouse: "C", qty: 35 } ] }
]);
```

##### 查询指定数组所属文档

下面的示例选择**包含指定元素**的数组所属的文档

```shell
db.inventory.find( { "instock": { warehouse: "A", qty: 5 } } )
```

> 字段顺序也要匹配！

##### 在数组的字段上指定查询条件

如果**不知道嵌套在数组中的文档的索引位置**，使用点 `.` 和嵌套文档中的字段名称（称为点表示法）来连接数组字段的名称。

```shell
db.inventory.find( { 'instock.qty': { $lte: 20 } } )
```

> 使用点表示法查询时，字段和索引必须在引号内

##### 使用数组索引来查询字段

下面的例子选择了所有 **instock** 数组的第一个元素是一个包含值小于或等于 **20** 的字段 **qty** 的文档

```shell
db.inventory.find( { 'instock.0.qty': { $lte: 20 } } )
```

##### 为数组指定多个条件

使用 `$elemMatch` 运算符可在一组嵌入式文档上指定多个条件，以使至少一个嵌入式文档满足所有指定条件。

下面的示例查询 **instock** 数组中至少有一个嵌入式文档的文档，包含数量等于 5 的字段和数量等于 A 的字段

```shell
db.inventory.find( { "instock": { $elemMatch: { qty: 5, warehouse: "A" } } } )
```

下面的示例查询 **instock** 数组中至少有一个嵌入式文档的文档，该嵌入式文档的 **qty** 字段大于 10 且小于或等于 20 的文档

```shell
db.inventory.find( { "instock": { $elemMatch: { qty: { $gt: 10, $lte: 20 } } } } )
```

##### 元素组合满足标准

如果数组字段上的复合查询条件未使用 `$elemMatch` 运算符，则查询将选择其数组包含满足条件的元素的**任意组合**的那些文档

下面的示例查询在 **instock** 阵列中的任何文档的数量字段大于 10，并且阵列中任何文档的数量字段小于或等于 20 的文档

```shell
db.inventory.find( { "instock.qty": { $gt: 10,  $lte: 20 } } )
```

下面的示例查询在 **instock** 数组中至少有一个包含数量等于 **5** 的嵌入式文档和至少一有个包含等于 **A** 的字段仓库的嵌入式文档的文档

```shell
db.inventory.find( { "instock.qty": 5, "instock.warehouse": "A" } )
```

