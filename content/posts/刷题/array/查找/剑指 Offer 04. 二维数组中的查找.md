---
title: "剑指 Offer 04. 二维数组中的查找"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,数组,查找]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 04. 二维数组中的查找

`mid` `search`

在一个 n * m 的二维数组中，每一行都按照**从左到右递增**的顺序排序，每一列都按照**从上到下递增**的顺序排序。

请完成一个高效的函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

示例:

现有矩阵 matrix 如下：

```
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
```

给定 target = 5，返回 true。

给定 target = 20，返回 false。

## 行二分

每行都来个二分；没有利用到列递增这个特点

```go
// 行二分
func findNumberIn2DArray(matrix [][]int, target int) bool {
	for _, nums := range matrix {
		low, high := 0, len(nums)-1
		for low <= high {
			mid := (low + high) >> 1
			if nums[mid] > target {
				high = mid - 1
			} else if nums[mid] < target {
				low = mid + 1
			} else {
				return true
			}
		}
	}
	return false
}
```

## 标志位

如下图所示，我们将矩阵逆时针旋转 45° ，并将其转化为图形式，发现其类似于 二叉搜索树 ，即对于每个元素，其左分支元素更小、右分支元素更大。因此，通过从 “根节点” 开始搜索，遇到比 target 大的元素就向左，反之向右，即可找到目标值 target 。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227151607027.png" alt="image-20220227151607027" style="zoom: 33%;" />

算法流程：

1. 从矩阵 matrix 左下角元素（索引设为 (i, j) ）开始遍历，并与目标值对比：
    - 当 matrix[i][j] > target 时，执行 i-- ，即消去第 i 行元素；
    - 当 matrix[i][j] < target 时，执行 j++ ，即消去第 j 列元素；
    - 当 matrix[i][j] = target 时，返回 truetrue ，代表找到目标值。
2. 若行索引或列索引越界，则代表矩阵中无目标值，返回 false

```go
// 标志数
func findNumberIn2DArray2(matrix [][]int, target int) bool {
	row, col := len(matrix)-1, 0 // 从左下角开始

	for row >= 0 && col < len(matrix[0]) {
		if matrix[row][col] > target {
			row--
		} else if matrix[row][col] < target {
			col++
		} else {
			return true
		}
	}
	return false
}
```

