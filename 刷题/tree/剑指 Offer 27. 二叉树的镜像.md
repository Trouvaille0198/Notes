# 剑指 Offer 27. 二叉树的镜像

`mid`

请完成一个函数，输入一个二叉树，该函数输出它的镜像。

例如输入：

```
     4
   /   \
  2     7
 / \   / \
1   3 6   9
```

镜像输出：

```
     4
   /   \
  7     2
 / \   / \
9   6 3   1
```

**示例 1：**

```
输入：root = [4,2,7,1,3,6,9]
输出：[4,7,2,9,6,3,1]
```

## 递归

```go
// 递归
func mirrorTree(root *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}

	left := mirrorTree(root.Left)
	right := mirrorTree(root.Right)

	root.Left = right
	root.Right = left
	return root
}
```

