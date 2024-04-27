---
title: "剑指 Offer 55 - II. 平衡二叉树"
date: 2022-02-27
draft: false
author: "MelonCholi"
tags: [算法,树,回溯]
categories: [刷题]
---

# 剑指 Offer 55 - II. 平衡二叉树

`easy`

输入一棵二叉树的根节点，判断该树是不是平衡二叉树。如果某二叉树中任意节点的左右子树的深度相差不超过 1，那么它就是一棵平衡二叉树。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227212454992.png" alt="image-20220227212454992" style="zoom: 80%;" />

## 后序遍历（DFS）

```go
package tree

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

func isBalanced(root *TreeNode) bool {
	var bp func(root *TreeNode) (int, bool)
	bp = func(root *TreeNode) (int, bool) {
        // 返回高度, 是否是平衡二叉树
		if root == nil {
			return 0, true
		}
		d1, b1 := bp(root.Left)
		d2, b2 := bp(root.Right)

		if b1 && b2 && abs(d1-d2) <= 1 {
			return max(d1, d2)+1, true
		}
		return max(d1, d2)+1, false
	}
	_, res := bp(root)
	return res

}
```

