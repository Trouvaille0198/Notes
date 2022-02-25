# 剑指 Offer 32 - II. 从上到下打印二叉树 II

`easy`

从上到下按层打印二叉树，同一层的节点按从左到右的顺序打印，每一层打印到一行。

例如:

给定二叉树: `[3,9,20,null,null,15,7]`,

```
  3
   / \
  9  20
    /  \
   15   7
```

返回其层次遍历结果：

```
[
  [3],
  [9,20],
  [15,7]
]
```

## 解

记录一下就好了

```go
func levelOrder(root *TreeNode) [][]int {
	if root == nil {
		return [][]int{}
	}
	result := make([][]int, 0)
	queue := make([]*TreeNode, 0)
	queue = append(queue, root)
	curCount := 1
	curLevel := 0
	nextCount := 0
	for len(queue) != 0 {
		curNodes := make([]int, 0)
		for curCount > 0 {
			curNode := queue[0]
			queue = queue[1:]
			curNodes = append(curNodes, curNode.Val)
			if curNode.Left != nil {
				queue = append(queue, curNode.Left)
				nextCount++
			}
			if curNode.Right != nil {
				queue = append(queue, curNode.Right)
				nextCount++
			}
			curCount--
		}
		result = append(result, curNodes)
		curCount = nextCount
		nextCount = 0
		curLevel++
	}
	return result
}
```

