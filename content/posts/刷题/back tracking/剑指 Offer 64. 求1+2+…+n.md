---
title: "剑指 Offer 64. 求1+2+…+n"
date: 2022-02-27
draft: false
author: "MelonCholi"
tags: [算法,回溯]
categories: [刷题]
---

# 剑指 Offer 64. 求1+2+…+n

`mid`

求 `1+2+...+n` ，要求不能使用乘除法、for、while、if、else、switch、case等关键字及条件判断语句（A?B:C）。

 **示例 1：**

```
输入: n = 3
输出: 6
```

**示例 2：**

```
输入: n = 9
输出: 45
```

## 逻辑与算符短路

![image-20220227215248107](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227215248107.png)

```go
// 逻辑短路
func sumNums(n int) int {
	res := 0
	var sum func(n int) bool
	sum = func(n int) bool {
		res += n
		return n > 0 && sum(n-1) // 不满足n>1时 递归就会退出
	}
	sum(n)
	return res
}
```

