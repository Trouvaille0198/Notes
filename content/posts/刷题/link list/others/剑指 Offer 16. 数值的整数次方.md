---
title: "剑指 Offer 16. 数值的整数次方"
date: 2022-03-03
draft: false
author: "MelonCholi"
tags: [算法,数学]
categories: [刷题]
---

# 剑指 Offer 16. 数值的整数次方

`easy`

实现 [pow(*x*, *n*)](https://www.cplusplus.com/reference/valarray/pow/) ，即计算 x 的 n 次幂函数（即，xn）。不得使用库函数，同时不需要考虑大数问题。

 **示例 1：**

```
输入：x = 2.00000, n = 10
输出：1024.00000
```

## 快速幂（二进制）

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303142146455.png" alt="image-20220303142146455" style="zoom:67%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303142152801.png" alt="image-20220303142152801" style="zoom:67%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303142245915.png" alt="image-20220303142245915" style="zoom:67%;" />

![image-20220303161004959](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303161004959.png)

```go
func myPow(x float64, n int) float64 {
   if x == 0 {
      return 0
   }
   if n < 0 {
      x, n = 1/x, -n
   }
   res := 1.0
   var b int // 二进制n的某一位 0或1
   for n != 0 {
      b = n & 1 // 获取二进制n最后一位
      if b != 0 {
         res *= x
      }
      n = n >> 1 // n右移一位
      x = x * x
   }
   return res
}
```

## 二分法角度理解

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303142442030.png" alt="image-20220303142442030" style="zoom: 67%;" />