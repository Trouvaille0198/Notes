---
title: "剑指 Offer 07. 重建二叉树"
date: 2022-02-28
draft: false
author: "MelonCholi"
tags: [算法,树,分治]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 07. 重建二叉树

`mid`

输入某二叉树的前序遍历和中序遍历的结果，请构建该二叉树并返回其根节点。

假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220228193829120.png" alt="image-20220228193829120" style="zoom: 50%;" />

## 分治

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220228194014990.png" alt="image-20220228194014990" style="zoom:50%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220228194014990.png" style="zoom:50%;" />

```go
func buildTree(preorder []int, inorder []int) *TreeNode {
	hash := make(map[int]int)
    // 构建中序遍历的哈希表
	for i, val := range inorder {
		hash[val] = i
	}

	var bt func(preorder []int, inorder []int, offset int) *TreeNode
	bt = func(preorder []int, inorder []int, offset int) *TreeNode {
		// 为了方便哈希表查找 添加offset参数为相对0位置的偏移量
		if len(preorder) == 0 {
			return nil
		}
		root := TreeNode{Val: preorder[0]} // 找到根节点
		i := hash[root.Val] - offset       // 找到根节点在中序遍历中的索引位置

		root.Left = bt(preorder[1:i+1], inorder[:i], offset)
		root.Right = bt(preorder[i+1:], inorder[i+1:], offset+i+1)
		return &root
	}
	root := bt(preorder, inorder, 0)
	return root
}
```

