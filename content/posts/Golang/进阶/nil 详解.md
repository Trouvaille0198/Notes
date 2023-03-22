---
title: "Go nil 详解"
date: 2022-03-22
draft: false
author: "MelonCholi"
tags: [进阶]
categories: [Golang]
---

# Go nil 详解

```go
a0 := make(map[string][]int, 0)
var a1 []int
a2 := []int{}
a3 := make([]int, 0)

if a0["zero"] == nil {
    // yes
    fmt.Println("a0 is nil")
}
if a1 == nil {
    // yes
    fmt.Println("a1 is nil")
}
if a2 == nil {
    // no
    fmt.Println("a2 is nil")
}
if a3 == nil {
    // no
    fmt.Println("a3 is nil")
}

// won't panic
a0["zero"] = append(a0["zero"], 1)
a1 = append(a1, 1)
a2 = append(a2, 1)
a3 = append(a3, 1)
```

## nil 到底是什么

答案是**变量**

```go
// nil is a predeclared identifier representing the zero value for a
// pointer, channel, func, interface, map, or slice type.
var nil Type // Type must be a pointer, channel, func, interface, map, or slice type

// Type is here for the purposes of documentation only. It is a stand-in
// for any Go type, but represents the same type for any given function
// invocation.
type Type int
```

从类型定义得到**两个关键点**：

1. `nil` 本质上是一个 `Type` 类型的变量而已；
2. `Type` 类型仅仅是基于 `int` 定义出来的一个新类型；

而从 `nil` 官方的注释中，我们可以得到一个重要信息：

**划重点**：`nil` 适用于 **指针**，**函数**，`interface`，`map`，`slice`，`channel` 这 6 种类型