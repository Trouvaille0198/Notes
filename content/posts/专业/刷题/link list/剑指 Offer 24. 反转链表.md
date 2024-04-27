---
title: "剑指 Offer 24. 反转链表"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法, 链表]
categories: [算法]
---

# 剑指 Offer 24. 反转链表

`easy`

定义一个函数，输入一个链表的头节点，反转该链表并输出反转后链表的头节点。

**示例:**

```
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
```

## 三指针

```go
// 三指针
func reverseList(head *ListNode) *ListNode {
	var prev, next *ListNode // 默认为nil
	cur := head
	for cur != nil {
		next = cur.Next
		cur.Next = prev
		prev = cur
		cur = next
	}
	return prev
}
```

## 递归

```go
// 递归
func reverseList2(head *ListNode) *ListNode {
	if head == nil || head.Next == nil {
		return head
	}
	newHead := reverseList2(head.Next)
	head.Next.Next = head
	head.Next = nil
	return newHead
}
```

