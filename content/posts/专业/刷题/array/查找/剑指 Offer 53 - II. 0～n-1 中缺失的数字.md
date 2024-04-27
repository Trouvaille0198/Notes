---
title: "剑指 Offer 53 - II. 0～n-1中缺失的数字"
date: 2022-02-19
draft: false
author: "MelonCholi"
tags: [算法,数组,二分]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 53 - II. 0～n-1 中缺失的数字

`easy`

一个长度为 n-1 的递增排序数组中的所有数字都是唯一的，并且每个数字都在范围 0～n-1 之内。在范围 0～n-1 内的 n 个数字中有且只有一个数字不在该数组中，请找出这个数字。

**示例 1:**

```
输入: [0,1,3]
输出: 2
```

**示例 2:**

```
输入: [0,1,2,3,4,5,6,7,9]
输出: 8
```

## 遍历

遍历，当前后差为 2 时返回。边界条件比较麻烦。时间复杂度 O(n)

```go
// 遍历 出现前后差为2则返回
func missingNumber(nums []int) int {
	for i := 0; i < len(nums); i++ {
		if i+1 <= len(nums)-1 && nums[i+1]-nums[i] > 1 {
			return i + 1
		}
	}
	if nums[len(nums)-1] == len(nums)-1 {
		return len(nums)
	} else {
		return 0
	}
}
```

## 等差数列求和

很骚，两者之差即为空缺值。时间复杂度 O(n)

```go
// 等差数列求和
func missingNumber(nums []int) int {
	n := len(nums)
	totalSum := n * (n + 1) / 2
	sum := 0
	for i := 0; i < len(nums); i++ {
		sum += nums[i]
	}
	return totalSum - sum
}
```

## 二分

有规律：当 `nums[i]==i` 时，缺失值在 i 右边；否则在 i 左边。于是就有了二分分半的条件

```go
// 二分
func missingNumber(nums []int) int {
	low, high := 0, len(nums)-1
	for low <= high {
		mid := (low + high) >> 1
		if mid == nums[mid] {
			// 缺失值在右边
			if mid == len(nums)-1 || nums[mid+1]-nums[mid] > 1 {
				return nums[mid] + 1
			}
			low = mid + 1
		} else {
			// 缺失值在左边
			if mid == 0 || nums[mid]-nums[mid-1] > 1 {
				return nums[mid] - 1
			}
			high = mid - 1
		}
	}
	return -1
}
```

