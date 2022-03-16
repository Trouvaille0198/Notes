# 剑指 Offer 32 - III. 从上到下打印二叉树 III

`mid`

请实现一个函数按照之字形顺序打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右到左的顺序打印，第三行再按照从左到右的顺序打印，其他行以此类推。

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
  [20,9],
  [15,7]
]
```

## 解

隔一个倒序一下

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
	isAscending := true
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
		if !isAscending {
			// 倒序
			reversedNodes := make([]int, 0)
			for i := len(curNodes) - 1; i >= 0; i-- {
				reversedNodes = append(reversedNodes, curNodes[i])
			}
			result = append(result, reversedNodes)
		} else {
			result = append(result, curNodes)
		}
		curCount = nextCount
		nextCount = 0
		curLevel++
		isAscending = !isAscending
	}
	return result
}
```

