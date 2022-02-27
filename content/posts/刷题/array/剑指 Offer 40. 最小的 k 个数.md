---
title: "剑指 Offer 40. 最小的 k 个数"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法,排序]
categories: [刷题]
---

# 剑指 Offer 40. 最小的 k 个数

`easy`

输入整数数组 `arr` ，找出其中最小的 `k` 个数。例如，输入4、5、1、6、2、7、3、8这8个数字，则最小的4个数字是1、2、3、4。

**示例 1：**

```
输入：arr = [3,2,1], k = 2
输出：[1,2] 或者 [2,1]
```

**示例 2：**

```
输入：arr = [0,1,2,1], k = 1
输出：[0]
```

## 排序

排序后取前 k 个数，很笨！

```go
func getLeastNumbers(arr []int, k int) []int {
	sort.Ints(arr)
	return arr[:k]
}
```

## 快排思想

![image-20220226165449390](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226165449390.png)

![image-20220226165623178](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226165623178.png)

```go
// 快排思想
func getLeastNumbers(arr []int, k int) []int {
	var quickSort func(nums []int, l, r, x int)
	quickSort = func(nums []int, l, r, x int) {
		if l > r {
			return
		}
		i, j := l, r
		pivotPos := true
		for i < j {
			if nums[i] > nums[j] {
				nums[i], nums[j] = nums[j], nums[i]
				pivotPos = !pivotPos
			}
			if pivotPos {
				j--
			} else {
				i++
			}
		}
		num := i - l + 1 // 本次划分 可以保证划分正确的个数为num
		if x == num {
			// 正好
			return
		} else if x < num {
			quickSort(nums, l, i-1, x)
		} else {
			quickSort(nums, i+1, r, x-num)
		}
	}
	if k == 0 {
		return []int{}
	}
	quickSort(arr, 0, len(arr)-1, k)
	return arr[:k]
}
```

## 堆

![image-20220226165517304](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226165517304.png)

![image-20220226165612477](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226165612477.png)

```go
func getLeastNumbers3(arr []int, k int) []int {
	// 大顶堆
	var heapify func(nums []int, root, end int)
	heapify = func(nums []int, root, end int) {
		// 大顶堆堆化，堆顶值小一直下沉
		for {
			// 左孩子节点索引
			child := root*2 + 1
			// 越界跳出
			if child > end {
				return
			}
			// 比较左右孩子，取大值，否则child不用++
			if child < end && nums[child] <= nums[child+1] {
				child++
			}
			// 如果父节点已经大于左右孩子大值，已堆化
			if nums[root] > nums[child] {
				return
			}
			// 孩子节点大值上冒
			nums[root], nums[child] = nums[child], nums[root]
			// 更新父节点到子节点，继续往下比较，不断下沉
			root = child
		}
	}
	end := len(arr) - 1
	// 从最后一个非叶子节点开始堆化
	for i := end / 2; i >= 0; i-- {
		heapify(arr, i, end)
	}
	// 依次弹出元素，然后再堆化，相当于依次把最大值放入尾部
	for i := end; i >= 0; i-- {
		arr[0], arr[i] = arr[i], arr[0]
		end--
		heapify(arr, 0, end)
	}
	return arr[:k]
}
```

