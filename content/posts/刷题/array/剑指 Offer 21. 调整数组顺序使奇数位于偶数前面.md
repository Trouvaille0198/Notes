---
title: "剑指 Offer 21. 调整数组顺序使奇数位于偶数前面"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,双指针]
categories: [刷题]
---

# 剑指 Offer 21. 调整数组顺序使奇数位于偶数前面

`easy`

输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有奇数在数组的前半部分，所有偶数在数组的后半部分。

**示例：**

```
输入：nums = [1,2,3,4]
输出：[1,3,2,4] 
注：[3,1,2,4] 也是正确的答案之一。
```

## 快慢指针

```go
func exchange(nums []int) []int {
	// i始终在第一个偶数上 j往前探索找奇数
	slow, fast := 0, 0
	for fast < len(nums) {
		if nums[fast]%2 == 1 {
			nums[slow], nums[fast] = nums[fast], nums[slow]
			slow++
		}
		fast++
	}
	return nums
}
```

## 头尾指针

```go
func exchange(nums []int) []int {
	low, high := 0, len(nums)-1

	for low <= high {
		for low < len(nums) && nums[low]%2 == 1 {
			// low往前走 直到遇到偶数
			low++
		}
		for high >= 0 && nums[high]%2 == 0 {
			// high往后退 直到遇到奇数
			high--
		}
		if low < high {
			nums[low], nums[high] = nums[high], nums[low]
		}
	}
	return nums
}
```

