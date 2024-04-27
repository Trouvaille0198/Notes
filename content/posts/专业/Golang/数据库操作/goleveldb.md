---
title: "Go goleveldb 库"
date: 2023-02-17
author: MelonCholi
draft: false
tags: [数据库]
categories: [Golang]
---

# goleveldb

> https://github.com/syndtr/goleveldb

## 快速开始

### 安装

```shell
go get github.com/syndtr/goleveldb/leveldb
```

### 基本操作

- 获取 db 实例;
- 添加数据;
- 删除数据;
- 获取 db 快照

```go
package main
import (
    "fmt"
    "github.com/syndtr/goleveldb/leveldb"
)
func main() {
    levelDB()
}
func levelDB() {
    // 定义字符数组key value
    key := []byte("hello")
    value := []byte("hi i'm levelDB by go")
    // 定义字符串的键值对
    k1 := "hhh"
    v1 := "heiheiheihei"
    
    // The returned DB instance is safe for concurrent use.
    // The DB must be closed after use, by calling Close method.
    // 文件夹位置,获取db实际
    db, err := leveldb.OpenFile("path/to/db", nil)
    
    //延迟关闭db流,必须的操作
    defer db.Close()
    if err != nil {
        fmt.Println(err)
    }
    
    // 向db中插入键值对
    e := db.Put(key, value, nil)
    // 将字符串转换为byte数组
    e = db.Put([]byte(k1), []byte(v1), nil)
    fmt.Println(e)//<nil>
   
    /*
    注意:查看路径下的db文件,可知道文件都是自动切分为一些小文件.
    */
    
    // 根据key值查询value
    data, _ := db.Get(key, nil)
    fmt.Println(data)        // [104 105 32 105 39 109 32 108 101 118 101 108 68 66 32 98 121 32 103 111]
    fmt.Printf("%c\n",data)  // [h i   i ' m   l e v e l D B   b y   g o]
    
    data, _ = db.Get([]byte(k1), nil)
    fmt.Println(data)        // [104 101 105 104 101 105 104 101 105 104 101 105]
    fmt.Printf("%c\n",data)  // [h e i h e i h e i h e i]
    // It is safe to modify the contents of the arguments after Delete returns but not before.
    
    // 根据key进行删除操作
    i := db.Delete(key, nil)
    fmt.Println(i)             // <nil>
    
    data, _ = db.Get(key, nil)
    fmt.Println(data)          // []
    
    // 获取db快照
    snapshot, i := db.GetSnapshot()
    fmt.Println(snapshot)      // leveldb.Snapshot{22}
    fmt.Println(i)             // <nil>
   
    // The snapshot must be released after use, by calling Release method.
    // 也就是说snapshot在使用之后,必须使用它的Release方法释放!
    snapshot.Release()
}
```

### 其他操作

#### 迭代

Iterate over database content 迭代数据库内容

```go
iter := db.NewIterator(nil, nil)
for iter.Next() {
	// Remember that the contents of the returned slice should not be modified, and
	// only valid until the next call to Next.
	key := iter.Key()
	value := iter.Value()
	...
}
iter.Release()
err = iter.Error()
...
```

Seek-then-Iterate 查找然后迭代

```go
iter := db.NewIterator(nil, nil)
for ok := iter.Seek(key); ok; ok = iter.Next() {
	// Use key/value.
	...
}
iter.Release()
err = iter.Error()
...
```

Iterate over subset of database content 迭代数据库内容的子集

```go
iter := db.NewIterator(&util.Range{Start: []byte("foo"), Limit: []byte("xoo")}, nil)
for iter.Next() {
	// Use key/value.
	...
}
iter.Release()
err = iter.Error()
...
```

Iterate over subset of database content with a particular prefix 使用特定前缀迭代数据库内容的子集

```go
iter := db.NewIterator(util.BytesPrefix([]byte("foo-")), nil)
for iter.Next() {
	// Use key/value.
	...
}
iter.Release()
err = iter.Error()
...
```

#### 批量写入

Batch writes 批量写入

```go
batch := new(leveldb.Batch)
batch.Put([]byte("foo"), []byte("value"))
batch.Put([]byte("bar"), []byte("another value"))
batch.Delete([]byte("baz"))
err = db.Write(batch, nil)
...
```

#### 使用布隆过滤器

Use bloom filter 使用 bloom 过滤器

```go
o := &opt.Options{
	Filter: filter.NewBloomFilter(10),
}
db, err := leveldb.OpenFile("path/to/db", o)
...
defer db.Close()
...
```
