# 剑指 Offer 06. 从尾到头打印链表

`easy`

输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。

**示例 1：**

```
输入：head = [1,3,2]
输出：[2,3,1]
```

## 辅助栈

```go
// 辅助栈
func reversePrint(head *ListNode) []int {
	var stack []int
	for p := head; p != nil; p = p.Next {
		stack = append(stack, p.Val)
	}
	var result []int
	for i := len(stack) - 1; i >= 0; i-- {
		result = append(result, stack[i])
	}
	return result
}
```

## 递归

```go
// 递归
func reversePrint(head *ListNode) []int {
	if head == nil {
		return []int{}
	}
	return append(reversePrint(head.Next), head.Val)
}
```

