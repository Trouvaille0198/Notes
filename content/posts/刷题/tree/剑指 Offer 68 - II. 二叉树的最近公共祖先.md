---
title: "剑指 Offer 68 - II. 二叉树的最近公共祖先"
date: 2022-02-27
draft: false
author: "MelonCholi"
tags: [算法,树,回溯]
categories: [刷题]
---

# 剑指 Offer 68 - II. 二叉树的最近公共祖先

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227224352641.png" alt="image-20220227224352641" style="zoom:67%;" />

## DFS

递归地判断子树是否包含了 p 或 q

```go
func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// DFS
func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
	minDepth := math.MaxInt
	var res *TreeNode
	var bp func(root *TreeNode) (pv, qv bool, d int)
	bp = func(root *TreeNode) (pv, qv bool, d int) {
		// 返回以root为头节点的树是否含有p和q 和它的深度
		if root == nil {
			return false, false, 0
		}

		pv1, qv1, d1 := bp(root.Left)
		pv2, qv2, d2 := bp(root.Right)
		d = max(d1, d2) + 1
		if pv1 || pv2 || root.Val == p.Val {
			pv = true
		}
		if qv1 || qv2 || root.Val == q.Val {
			qv = true
		}
		if pv && qv && d < minDepth {
			res = root
			minDepth = d
		}
		return
	}
	bp(root)
	return res
}
```

## 更好的 DFS

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227230230636.png" alt="image-20220227230230636" style="zoom: 80%;" />

![image-20220227230311146](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227230311146.png)

```go
func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}
	if root.Val == p.Val || root.Val == q.Val {
		return root
	}
	left := lowestCommonAncestor(root.Left, p, q)
	right := lowestCommonAncestor(root.Right, p, q)
	if left != nil && right != nil {
		return root
	}
	if left == nil {
		return right
	}
	return left
}
```

