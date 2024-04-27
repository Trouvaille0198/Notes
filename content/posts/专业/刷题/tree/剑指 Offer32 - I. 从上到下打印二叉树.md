# 剑指 Offer32 - I. 从上到下打印二叉树.md

`easy`

从上到下打印出二叉树的每个节点，同一层的节点按照从左到右的顺序打印。

例如:
给定二叉树: `[3,9,20,null,null,15,7]`,

```
    3
   / \
  9  20
    /  \
   15   7
```

返回：

```
[3,9,20,15,7]
```

## 队列

就是一个层序遍历

```go
// 队列实现层序遍历
func levelOrder(root *TreeNode) []int {
	if root == nil {
		return []int{}
	}
	queue := make([]*TreeNode, 0)
	queue = append(queue, root)
	result := make([]int, 0)
	for len(queue) != 0 {
		curNode := queue[0]
		queue = queue[1:]
		result = append(result, curNode.Val)
		if curNode.Left != nil {
			queue = append(queue, curNode.Left)
		}
		if curNode.Right != nil {
			queue = append(queue, curNode.Right)
		}
	}
	return result
}
```



