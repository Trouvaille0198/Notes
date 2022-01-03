# gorm

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
  db.First(&product, 1) // 根据整形主键查找
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
```