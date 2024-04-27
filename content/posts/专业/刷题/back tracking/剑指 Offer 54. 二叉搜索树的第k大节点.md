# 剑指 Offer 54. 二叉搜索树的第k大节点

给定一棵二叉搜索树，请找出其中第 `k` 大的节点的值。

**示例 1:**

```
输入: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
输出: 4
```

```
输入: root = [5,3,6,2,4,null,null,1], k = 3
       5
      / \
     3   6
    / \
   2   4
  /
 1
输出: 4
```

## DFS

中序遍历倒序，即中右左，这样就能转化为求中序遍历倒序第 k 个结点值

```go
func kthLargest(root *TreeNode, k int) int {
   var dfs func(root *TreeNode)
   var i, res int
   dfs = func(root *TreeNode) {
      if root == nil {
         return
      }
      dfs(root.Right)
      i++
      if i == k {
         res = root.Val
      }
      dfs(root.Left)
   }
   dfs(root)
   return res
}
```