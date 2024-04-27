---
title: "剑指 Offer 68 - I. 二叉搜索树的最近公共祖先"
date: 2022-02-27
draft: false
author: "MelonCholi"
tags: [算法,树]
categories: [刷题]
---

# 剑指 Offer 68 - I. 二叉搜索树的最近公共祖先

给定一个**二叉搜索树**, 找到该树中两个指定节点的最近公共祖先。(**一个节点也可以是它自己的祖先**)

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227215905334.png" alt="image-20220227215905334" style="zoom:67%;" />

## 两次遍历

![image-20220227222708876](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227222708876.png)

![image-20220227222718928](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227222718928.png)

```go
func getPath(root, target *TreeNode) (path []*TreeNode) {
    // 获取从根节点到目标节点的路径结点数组
    node := root
    for node != target {
        path = append(path, node)
        if target.Val < node.Val {
            node = node.Left
        } else {
            node = node.Right
        }
    }
    path = append(path, node)
    return
}

func lowestCommonAncestor(root, p, q *TreeNode) (ancestor *TreeNode) {
    pathP := getPath(root, p)
    pathQ := getPath(root, q)
    for i := 0; i < len(pathP) && i < len(pathQ) && pathP[i] == pathQ[i]; i++ {
        ancestor = pathP[i]
    }
    return
}
```

## 一次遍历

![image-20220227222748824](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220227222748824.png)

```go
func lowestCommonAncestor(root, p, q *TreeNode) (ancestor *TreeNode) {
    ancestor = root
    for {
        if p.Val < ancestor.Val && q.Val < ancestor.Val {
            ancestor = ancestor.Left
        } else if p.Val > ancestor.Val && q.Val > ancestor.Val {
            ancestor = ancestor.Right
        } else {
            return
        }
    }
}
```

