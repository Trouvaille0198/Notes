---
title: "剑指 Offer 26. 树的子结构"
date: 2022-02-28
draft: false
author: "MelonCholi"
tags: [算法,树,对称性递归]
categories: [刷题]
---

# 剑指 Offer 26. 树的子结构

`mid`

输入两棵二叉树 A 和 B，判断 B 是不是 A 的子结构。(约定空树不是任意一个树的子结构)

B 是 A 的子结构， 即 A 中有出现和 B 相同的结构和节点值。

例如:

给定的树 A:

```
     3
    / \
   4   5
  / \
 1   2
```

给定的树 B：

```
   4  
  /
 1
```

返回 true，因为 B 与 A 的一个子树拥有相同的结构和节点值。

**示例 1：**

```
输入：A = [1,2,3], B = [3,1]
输出：false
```

**示例 2：**

```
输入：A = [3,4,5,1,2], B = [4,1]
输出：true
```

## 对称性递归

```go
// 从头结点开始 是不是子树
func isSubStructureHelp(A *TreeNode, B *TreeNode) bool {
	if B == nil {
		return true
	} else if A == nil {
		// B不空A空
		return false
	}

	if A.Val == B.Val {
		return isSubStructureHelp(A.Left, B.Left) && isSubStructureHelp(A.Right, B.Right)
	}
	return false
}

func isSubStructure(A *TreeNode, B *TreeNode) bool {
	if A == nil || B == nil {
		return false
	}
	return isSubStructureHelp(A, B) || isSubStructure(A.Left, B) || isSubStructure(A.Right, B)
}
```

