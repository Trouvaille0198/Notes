---
title: "剑指 Offer 61. 扑克牌中的顺子"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法,排序]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 61. 扑克牌中的顺子

`easy` 

从若干副扑克牌中随机抽 5 张牌，判断是不是一个顺子，即这 5 张牌是不是连续的。2～10 为数字本身，A 为 1，J 为 11，Q 为 12，K 为 13，而大、小王为 0 ，可以看成任意数字。A 不能视为 14。

**示例 1:**

```
输入: [1,2,3,4,5]
输出: True
```

**示例 2:**

```
输入: [0,0,1,2,5]
输出: True
```

**限制：**

- 数组长度为 5 

- 数组的数取值为 [0, 13] .

## 朴素的方法

排序、数 0、看条件

```go
func isStraight(nums []int) bool {
	sort.Ints(nums)
	zeroCount := 0
	for _, num := range nums {
		if num == 0 {
			zeroCount++
		}
	}
	one, two := 0, 0
	for i := zeroCount + 1; i < 5; i++ {
		{
			diff := nums[i] - nums[i-1]
			if diff == 1 {
				continue
			} else if diff == 2 {
				one++
			} else if diff == 3 {
				two++
			} else {
				return false
			}
		}
	}
	if (one == 0 && two == 0) || (one <= zeroCount && two == 0) || (one == 0 && two*2 <= zeroCount) {
		return true
	} else {
		return false
	}
}
```

## 分析

其实不用考虑大小王的个数的，想到 $max-min<5$ 这个点，题目就很简单了

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226145420578.png" alt="image-20220226145420578" style="zoom: 67%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/df03847e2d04a3fcb5649541d4b6733fb2cb0d9293c3433823e04935826c33ef-Picture1.png" alt="Picture1.png" style="zoom: 50%;" />

### 哈希表 + 遍历

哈希表判断重复；遍历找最小和最大

![image-20220226145546131](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226145546131.png)

```go
func isStraight(nums []int) bool {
	hash := make(map[int]struct{})
	minVal, maxVal := math.MaxInt, math.MinInt
	for i := 0; i < len(nums); i++ {
		if nums[i] != 0 {
			// 把0跳过
			if _, ok := hash[nums[i]]; ok {
				// 有重复 必不可能构成顺子
				return false
			}
			hash[nums[i]] = struct{}{}
			if nums[i] < minVal {
				minVal = nums[i]
			}
			if nums[i] > maxVal {
				maxVal = nums[i]
			}
		}
	}
	if maxVal-minVal < 5 {
		return true
	}
	return false
}
```

### 排序 + 遍历

![image-20220226150250978](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226150250978.png)

代码懒得写了