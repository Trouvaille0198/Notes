---
title: "剑指 Offer 25. 合并两个排序的链表"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法, 链表]
categories: [算法]
---

# 剑指 Offer 25. 合并两个排序的链表

`easy`

输入两个递增排序的链表，合并这两个链表并使新链表中的节点仍然是递增排序的。

**示例1：**

```
输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4
```

## 归并排序

本质上也是个双指针

```go
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
	fakeHead := &ListNode{} // 伪头节点
	curNode := fakeHead
	for l1 != nil || l2 != nil {
		if l1 == nil {
			curNode.Next = l2
			break
		}
		if l2 == nil {
			curNode.Next = l1
			break
		}

		if l1.Val > l2.Val {
			curNode.Next = l2
			l2 = l2.Next
		} else {
			curNode.Next = l1
			l1 = l1.Next
		}
		curNode = curNode.Next
	}
	return fakeHead.Next
}
```

伪头节点真的能减少很多边界条件的考虑！

不用伪头节点的情况，很繁琐：

```go
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
	if l1 == nil {
		return l2
	} else if l2 == nil {
		return l1
	}

	var head *ListNode
	if l1.Val > l2.Val {
		head = l2
		l2 = l2.Next
	} else {
		head = l1
		l1 = l1.Next
	}
	curNode := head
	for l1 != nil || l2 != nil {
		if l1 == nil {
			curNode.Next = l2
			break
		}
		if l2 == nil {
			curNode.Next = l1
			break
		}

		if l1.Val > l2.Val {
			curNode.Next = l2
			l2 = l2.Next
		} else {
			curNode.Next = l1
			l1 = l1.Next
		}
		curNode = curNode.Next
	}
	return head
}
```

