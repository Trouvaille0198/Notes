---
title: "剑指 Offer 33. 二叉搜索树的后序遍历序列"
date: 2022-03-03
draft: false
author: "MelonCholi"
tags: [算法,树,分治]
categories: [刷题]
---

# 剑指 Offer 33. 二叉搜索树的后序遍历序列

输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历结果。如果是则返回 `true`，否则返回 `false`。假设输入的数组的任意两个数字都互不相同。

参考以下这颗二叉搜索树：

```
     5
    / \
   2   6
  / \
 1   3
```

**示例 1：**

```
输入: [1,6,3,2,5]
输出: false
```

**示例 2：**

```
输入: [1,3,2,6,5]
输出: true
```

## 递归分治

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/4a2780853b72a0553194773ff65c8c81ddcc4ee5d818cb3528d5f8dd5fa3b6d8-Picture1.png" alt="Picture1.png" style="zoom:50%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303184653473.png" alt="image-20220303184653473" style="zoom: 67%;" />

- 逻辑

    - 从后向前遍历，寻找第一个小于根节点的元素下标 i（这样可以保证右子树均大于根节点）

    - 对左子树正确性进行判断，即从 i 向前进行遍历，若发现大于根节点的值，则判断不是搜索二叉树，返回 false

    - 对左右子树递归

```go
func verifyPostorder(postorder []int) bool {
	if len(postorder) == 0 {
		return true
	}
	rootVal := postorder[len(postorder)-1]
	var i int
	for i = len(postorder) - 1; i >= 0; i-- {
		// 找到第一个小于rootVal的下标
		if postorder[i] < rootVal {
			break
		}
	}

	for j := i; j >= 0; j-- {
		if postorder[j] > rootVal {
			return false
		}
	}

	return verifyPostorder(postorder[:i+1]) && verifyPostorder(postorder[i+1:len(postorder)-1])
}
```

