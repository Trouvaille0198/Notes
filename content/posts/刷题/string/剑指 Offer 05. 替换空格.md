---
title: "剑指 Offer 05. 替换空格"
date: 2022-02-11
draft: false
author: "MelonCholi"
tags: [算法, 字符串]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 05. 替换空格

请实现一个函数，把字符串 s 中的每个空格替换成"%20"。

**示例 1：**

```
输入：s = "We are happy."
输出："We%20are%20happy."
```

## 遍历添加

```go
// 遍历添加 时间复杂度O(N),空间复杂度O(N)
func replaceSpace(s string) string {
	b := make([]byte, 0)
	for i := 0; i < len(s); i++ {
		if s[i] == ' ' {
			b = append(b, []byte("%20")...)
		} else {
			b = append(b, s[i])
		}
	}
	return string(b)
}
```

## 原地修改 

扩充然后逆序填入

**其实很多数组填充类的问题，都可以先预先给数组扩容带填充后的大小，然后再从后向前进行操作。**

```go
// 原地修改 时间复杂度O(N),空间复杂度O(1)
func replaceSpace2(s string) string {
	b := []byte(s)
	length := len(b)
	spaceCount := 0
	// 计算空格数量
	for _, v := range b {
		if v == ' ' {
			spaceCount++
		}
	}
	// 扩展原有切片
	tmp := make([]byte, spaceCount*2)
	b = append(b, tmp...)
	i := length - 1 // 指向原来最后一位
	j := len(b) - 1 // 指向现在最后一位
	// 从后向前填充
	for i >= 0 {
		if b[i] != ' ' {
			b[j] = b[i]
			i--
			j--
		} else {
			b[j] = '0'
			b[j-1] = '2'
			b[j-2] = '%'
			i--
			j = j - 3
		}
	}
	return string(b)
}
```

