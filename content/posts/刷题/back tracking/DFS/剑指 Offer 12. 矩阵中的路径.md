---
title: "剑指 Offer 12. 矩阵中的路径"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,回溯]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 12. 矩阵中的路径

`mid`

给定一个 `m x n` 二维字符网格 `board` 和一个字符串单词 `word` 。如果 `word` 存在于网格中，返回 `true` ；否则，返回 `false` 。

单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用。

例如，在下面的 3×4 的矩阵中包含单词 "ABCCED"（单词中的字母已标出）。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/word2.jpg)

**示例 1：**

```
输入：board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
输出：true
```

**示例 2：**

```
输入：board = [["a","b"],["c","d"]], word = "abcd"
输出：false
```

## DFS

约束条件

1. 超出边界
2. 回到上一层（可以并到 1）
3. 字符不同

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220223112841945.png" alt="image-20220223112841945" style="zoom:50%;" />

```go
func exist(board [][]byte, word string) bool {
	m, n := len(board), len(board[0])
	var backtracking func(i, j, layer int) bool
	// i,j为board指针 layer为层数 从0开始
	backtracking = func(i, j, layer int) bool {
		if i < 0 || i > m-1 || j < 0 || j > n-1 {
			// 超出边界或回到了上一层
			return false
		}
		if board[i][j] != word[layer] {
			// 字符不同
			return false
		}
		if layer == len(word)-1 {
			return true
		}
		board[i][j] = ' ' // 用来防止回到上一层
		res := backtracking(i+1, j, layer+1) || backtracking(i-1, j, layer+1) ||
			backtracking(i, j+1, layer+1) || backtracking(i, j-1, layer+1)
		board[i][j] = word[layer]
		return res
	}
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if backtracking(i, j, 0) {
				return true
			}
		}
	}
	return false
}
```

