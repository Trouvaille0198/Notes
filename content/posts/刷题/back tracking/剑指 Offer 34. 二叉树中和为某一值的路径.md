# 剑指 Offer 34. 二叉树中和为某一值的路径

`mid` `DFS`

给你二叉树的根节点 root 和一个整数目标和 targetSum ，找出所有**从根节点到叶子节点**路径总和等于给定目标和的路径。

叶子节点是指没有子节点的节点。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220223205317253.png" alt="image-20220223205317253" style="zoom: 50%;" />

## DFS

每个递归维护一个数组，保存历史路径上的节点值；每次查到底，发现路径和满足要求就将数组添加到结果中。

注意 road 是一个切片，底层是指针，添加到 res 中时需要深拷贝

```go
func sum(nums []int) (sum int) {
	for _, num := range nums {
		sum += num
	}
	return
}

func pathSum(root *TreeNode, target int) [][]int {
	res := make([][]int, 0)
	var backtracking func(root *TreeNode, road []int)
	backtracking = func(root *TreeNode, road []int) {
		if root == nil {
			return
		}

		road = append(road, root.Val)
		if sum(road) == target && root.Left == nil && root.Right == nil {
			// 到叶子节点 且路径和等于目标值
			tmp := make([]int, len(road)) // 拷贝切片
			copy(tmp, road)
			res = append(res, tmp)
			return
		}
		backtracking(root.Left, road)
		backtracking(root.Right, road)
	}
	backtracking(root, []int{})
	return res
}
```

回溯函数还可以传值，road 由一个变量统一维护：

```go
func pathSum(root *TreeNode, target int) [][]int {
	res := make([][]int, 0)
	road := make([]int, 0)
	var backtracking func(root *TreeNode, leftVal int)
	backtracking = func(root *TreeNode, leftVal int) {
		if root == nil {
			return
		}

		road = append(road, root.Val)
		defer func() {
			road = road[:len(road)-1] // 收回最后一步
		}()

		leftVal -= root.Val
		if leftVal == 0 && root.Left == nil && root.Right == nil {
			// 到叶子节点 且路径和等于目标值
			res = append(res, append([]int{}, road...)) // 拷贝 因为road唯一 会不断变化
			return
		}
		backtracking(root.Left, leftVal)
		backtracking(root.Right, leftVal)
	}
	backtracking(root, target)
	return res
}
```



