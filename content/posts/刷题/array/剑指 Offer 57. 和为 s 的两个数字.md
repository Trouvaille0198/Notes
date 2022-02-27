---
title: "剑指 Offer 57. 和为 s 的两个数字"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,数组,双指针]
categories: [刷题]
---

# 剑指 Offer 57. 和为 s 的两个数字

`easy`

输入一个递增排序的数组和一个数字 s，在数组中查找两个数，使得它们的和正好是 s。

如果有多对数字的和等于 s，则输出任意一对即可。	

**示例 1：**

```
输入：nums = [2,7,11,15], target = 9
输出：[2,7] 或者 [7,2]
```

**示例 2：**

```
输入：nums = [10,26,30,31,47,60], target = 40
输出：[10,30] 或者 [30,10]
```

## 对撞指针

```go
func twoSum(nums []int, target int) []int {
	if len(nums) <= 1 {
		return []int{}
	}
	i, j := 0, len(nums)-1
	for i < j {
		if nums[i]+nums[j] < target {
			i++
		} else if nums[i]+nums[j] > target {
			j--
		} else {
			return []int{nums[i], nums[j]}
		}
	}
	return []int{}
}
```

