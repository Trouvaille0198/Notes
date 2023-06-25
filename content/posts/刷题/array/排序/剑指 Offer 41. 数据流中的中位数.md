---
title: "剑指 Offer 41. 数据流中的中位数"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法,排序]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 41. 数据流中的中位数

`hard` `堆排序`

如何得到一个数据流中的中位数？如果从数据流中读出奇数个数值，那么中位数就是所有数值排序之后位于中间的数值。如果从数据流中读出偶数个数值，那么中位数就是所有数值排序之后中间两个数的平均值。

设计一个支持以下两种操作的数据结构：

`void addNum(int num)` - 从数据流中添加一个整数到数据结构中。
`double findMedian()` - 返回目前所有元素的中位数。

```
输入：
["MedianFinder","addNum","addNum","findMedian","addNum","findMedian"]
[[],[1],[2],[],[3],[]]
输出：[null,null,null,1.50000,null,2.00000]
```

**示例 2：**

```
输入：
["MedianFinder","addNum","findMedian","addNum","findMedian"]
[[],[2],[],[3],[]]
输出：[null,null,2.00000,null,2.50000]
```

## 大顶堆 + 小顶堆

![image-20220226172633385](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226172633385.png)

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/25837f1b195e56de20587a4ed97d9571463aa611789e768914638902add351f4-Picture1.png" alt="Picture1.png" style="zoom:57%;" />

![image-20220226173122844](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226173122844.png)

![image-20220226173202297](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220226173202297.png)

```go
import (
	"container/heap"
	"sort"
)

type MedianFinder struct {
	minH iMinHeap // 小顶堆，保存较大的一半
	maxH iMaxHeap // 大顶堆，保存较小的一半
}

func Constructor() MedianFinder {
	maxH, minH := iMaxHeap{}, iMinHeap{}
	heap.Init(&maxH)
	heap.Init(&minH)
	finder := MedianFinder{
		minH: minH,
		maxH: maxH,
	}
	return finder
}

func (mf *MedianFinder) AddNum(num int) {
	if mf.minH.Len() != mf.maxH.Len() {
		heap.Push(&mf.minH, num)
		heap.Push(&mf.maxH, heap.Pop(&mf.minH))
	} else {
		heap.Push(&mf.maxH, num)
		heap.Push(&mf.minH, heap.Pop(&mf.maxH))
	}
}

func (mf *MedianFinder) FindMedian() float64 {
	if mf.minH.Len() == mf.maxH.Len() {
		return float64(mf.minH.Peek()+mf.maxH.Peek()) * 0.5
	}
	return float64(mf.minH.Peek())
}

// ---------------- 大顶堆/小顶堆 定义 ---------------- //
// int类型小顶堆，sort.IntSlice 默认升序，即小顶堆
type iMinHeap struct{ sort.IntSlice }

func (h *iMinHeap) Push(x interface{}) {
	h.IntSlice = append(h.IntSlice, x.(int))
}

func (h *iMinHeap) Pop() interface{} {
	n := h.IntSlice.Len()
	x := h.IntSlice[n-1]
	h.IntSlice = h.IntSlice[:n-1]
	return x
}

// Peek 查看堆顶元素，不改变结构
func (h iMinHeap) Peek() int {
	return h.IntSlice[0]
}

// int类型大顶堆，大顶堆需要重新 Less() 比较器
type iMaxHeap struct{ sort.IntSlice }

func (h iMaxHeap) Less(i, j int) bool {
	return h.IntSlice[i] > h.IntSlice[j]
}

func (h *iMaxHeap) Push(x interface{}) {
	h.IntSlice = append(h.IntSlice, x.(int))
}

func (h *iMaxHeap) Pop() interface{} {
	n := h.IntSlice.Len()
	x := h.IntSlice[n-1]
	h.IntSlice = h.IntSlice[:n-1]
	return x
}

func (h iMaxHeap) Peek() int {
	return h.IntSlice[0]
}
```

