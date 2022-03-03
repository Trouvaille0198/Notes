---
title: "剑指 Offer 65. 不用加减乘除做加法"
date: 2022-03-03
draft: false
author: "MelonCholi"
tags: [算法,位运算]
categories: [刷题]
---

# 剑指 Offer 65. 不用加减乘除做加法

写一个函数，求两个整数之和，要求在函数体内不得使用 “+”、“-”、“*”、“/” 四则运算符号。

**示例:**

```
输入: a = 1, b = 1
输出: 2
```

**提示：**

- `a`, `b` 均可能是负数或 0
- 结果不会溢出 32 位整数

## 位运算

![image-20220303204314920](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303204314920.png)

```go
func add(a int, b int) int {
	// 进位
	var carry int
	for b != 0 {
		// 进位
		carry = (a & b) << 1
		// 不加进位
		a ^= b
		// 加进位
		b = carry
	}

	return a
}
```

