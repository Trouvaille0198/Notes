# 剑指 Offer 35. 复杂链表的复制

`mid`

请实现 copyRandomList 函数，复制一个复杂链表。在复杂链表中，每个节点除了有一个 next 指针指向下一个节点，还有一个 random 指针指向链表中的任意节点或者 null。

示例 1：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/e1.png)

```
输入：head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
输出：[[7,null],[13,0],[11,4],[10,2],[1,0]]
```

**示例 2：**

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/e2.png)

```
输入：head = [[1,1],[2,1]]
输出：[[1,1],[2,1]]
```

**示例 3：**

```
输入：head = []
输出：[]
解释：给定的链表为空（空指针），因此返回 null。
```

## 哈希表

在赋值的过程中，将新链表的每个结点与原链表的每个结点用散列表一一对应起来

```go
// 哈希表
func copyRandomList(head *Node) *Node {
	if head == nil {
		return head
	}
	nodeMap := make(map[*Node]*Node)
	newHead := &Node{} // 空头结点

	for p, k := head, newHead; p != nil; p, k = p.Next, k.Next {
		k.Next = &Node{Val: p.Val}
		nodeMap[p] = k.Next
	}
	for p, k := head, newHead; p != nil; p, k = p.Next, k.Next {
		if p.Random != nil {
			k.Next.Random = nodeMap[p.Random]
		}
	}
	return newHead.Next
}
```

## 原地转换

1. 复制一个新的节点在原有节点之后，如 1 -> 2 -> 3 -> null 复制完就是 1 -> 1 -> 2 -> 2 -> 3 - > 3 -> null
2. 从头开始遍历链表，通过 cur.next.random = cur.random.next 可以将复制节点的随机指针串起来，当然需要判断 cur.random 是否存在
3. 将复制完的链表一分为二

```go
// 原地转换
func copyRandomList2(head *Node) *Node {
	if head == nil {
		return head
	}
	// 复制结点插入到原节点后面
	for p := head; p != nil; p = p.Next.Next {
		p.Next = &Node{Val: p.Val, Next: p.Next}
	}
	// 设置Random指针
	for p := head; p != nil; p = p.Next.Next {
		k := p.Next
		if p.Random != nil {
			k.Random = p.Random.Next
		}
	}
	newHead := head.Next
	// 拆分原节点和新节点
	for p := head; p != nil; p = p.Next {
		k := p.Next
		p.Next = k.Next
		if k.Next != nil {
			k.Next = k.Next.Next
		}
	}
	return newHead
}
```

