---
title: "剑指 Offer 15. 二进制中1的个数"
date: 2022-03-03
draft: false
author: "MelonCholi"
tags: [算法,位运算]
categories: [刷题]
---

# 剑指 Offer 15. 二进制中1的个数

`easy`

编写一个函数，输入是一个无符号整数（以二进制串的形式），返回其二进制表达式中数字位数为 '1' 的个数（也被称为 [汉明重量](http://en.wikipedia.org/wiki/Hamming_weight)).）。

**示例 1：**

```
输入：n = 11 (控制台输入 00000000000000000000000000001011)
输出：3
解释：输入的二进制串 00000000000000000000000000001011 中，共有三位为 '1'
```

## 位运算

```go
func hammingWeight(num uint32) (count int) {
   for num > 0 {
      if num&1 == 1 {
         count++
      }
      num = num >> 1
   }
   return
}
```

![image-20220303200414645](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303200414645.png)

```go
func hammingWeight(num uint32) (ones int) {
    for i := 0; i < 32; i++ {
        if 1<<i&num > 0 {
            ones++
        }
    }
    return
}
```

![image-20220303200438396](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303200438396.png)

## 位运算优化

![image-20220303200456215](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303200456215.png)

```go
func hammingWeight(num uint32) (ones int) {
    for ; num > 0; num &= num - 1 {
        ones++
    }
    return
}
```

