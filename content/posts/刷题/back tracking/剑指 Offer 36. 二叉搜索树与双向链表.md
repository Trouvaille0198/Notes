# 剑指 Offer 36. 二叉搜索树与双向链表

`mid`

输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的循环双向链表。要求不能创建任何新的节点，只能调整树中节点指针的指向。

以下面的二叉搜索树为例：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/bstdlloriginalbst.png" alt="img" style="zoom:50%;" />

我们希望将这个二叉搜索树转化为双向循环链表。链表中的每个节点都有一个前驱和后继指针。对于双向循环链表，第一个节点的前驱是最后一个节点，最后一个节点的后继是第一个节点。

下图展示了上面的二叉搜索树转化成的链表。“head” 表示指向链表中有最小元素的节点。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/bstdllreturndll.png" alt="img" style="zoom: 50%;" />

特别地，我们希望可以就地完成转换操作。当转化完成以后，树中节点的左指针需要指向前驱，树中节点的右指针需要指向后继。还需要返回链表中的第一个节点的指针。

## DFS

二叉树中序遍历模板

1. 双指针记录头结点和前驱
2. 中序遍历顺着 Left 指针入栈，为了不破坏次序。利用 Right 指针在回溯的过程中指向上一层的节点（强行解释）。但已经回溯到上一层时怎么利用之前的节点呢。那就用 pre 变量保存前驱节点。当前节点（实际上已经回溯到上一层了）的 Left 指针指向前驱。这样约定好了之后。递归处理即可
3. 置为双向循环链表

```go
func treeToDoublyList(root *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}
    var pre, head *TreeNode
    
	var inOrder func(root *TreeNode)
	inOrder = func(root *TreeNode) {
		if root == nil {
			return
		}

		inOrder(root.Left)

		if pre == nil {
			// 遍历到头节点
			head = root
		}
		root.Left = pre
		pre.Right = root

		pre = root
		inOrder(root.Right)
	}
	inOrder(root)
	// pre最终指向尾结点
	pre.Right = head
	head.Left = pre
	return head
}
```



