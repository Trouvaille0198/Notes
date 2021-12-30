# gorm

## 快速开始

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