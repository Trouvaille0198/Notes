---
title: "剑指 Offer 11. 旋转数组的最小数字"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,数组,二分]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 11. 旋转数组的最小数字

`easy` `二分`

把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。

给你一个可能存在**重复**元素值的数组 numbers ，它原来是一个升序排列的数组，并按上述情形进行了一次旋转。请返回旋转数组的最小元素。例如，数组 [3,4,5,1,2] 为 [1,2,3,4,5] 的一次旋转，该数组的最小值为 1。  

**示例 1：**

```
输入：[3,4,5,1,2]
输出：1
```

**示例 2：**

```
输入：[2,2,2,0,1]
输出：0
```

## 分析 

首先，遍历一定是可以的。。但是时间复杂度是 O(N)

## 二分

- middle > high：代表最小值一定在 middle 右侧，所以 low 移到 middle + 1 的位置。
- middle < high：代表最小值一定在 middle 左侧**或者就是 middle**，所以 high 移到 middle 的位置。
- middle == high：这时候不好判断，只能**让 high 指针递减**，来一个一个找最小值了。

```go
// 二分
func minArray2(numbers []int) int {
	low := 0
	high := len(numbers) - 1
	for low < high {
		mid := low + (high-low)/2
		if numbers[mid] < numbers[high] {
			high = mid
		} else if numbers[mid] > numbers[high] {
			low = mid + 1
		} else {
			high--
		}
	}
	return numbers[low]
}
```

