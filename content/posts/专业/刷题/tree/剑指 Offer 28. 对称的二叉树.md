---
title: "剑指 Offer 28. 对称的二叉树"
date: 2022-02-28
draft: false
author: "MelonCholi"
tags: [算法,树,对称性递归]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 28. 对称的二叉树

`mid`

请实现一个函数，用来判断一棵二叉树是不是对称的。如果一棵二叉树和它的镜像一样，那么它是对称的。

例如，二叉树 [1,2,2,3,4,4,3] 是对称的。

```
    1
   / \
  2   2
 / \ / \
3  4 4  3
```

但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:

```
    1
   / \
  2   2
   \   \
   3    3
```

## 递归

![Picture1.png](https://pic.leetcode-cn.com/ebf894b723530a89cc9a1fe099f36c57c584d4987b080f625b33e228c0a02bec-Picture1.png)

```go
func isSymmetric(root *TreeNode) bool {
	if root == nil {
		return true
	}

	return isSymmetricHelp(root.Left, root.Right)
}

// 判断两棵树是否镜像
func isSymmetricHelp(A *TreeNode, B *TreeNode) bool {
	if A == nil && B == nil {
		return true
	} else if A == nil || B == nil {
		// 若一个为空一个不为空
		return false
	}

	if A.Val == B.Val && isSymmetricHelp(A.Left, B.Right) && isSymmetricHelp(A.Right, B.Left) {
		return true
	}
	return false
}
```

