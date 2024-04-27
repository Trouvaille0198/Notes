---
title: "剑指 Offer 22. 链表中倒数第 k 个节点"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法, 链表]
categories: [算法]
---

# 剑指 Offer 22. 链表中倒数第 k 个节点

`easy`

输入一个链表，**输出该链表中倒数第 k 个节点**。为了符合大多数人的习惯，本题从 1 开始计数，即链表的尾节点是倒数第 1 个节点。

例如，一个链表有 6 个节点，从头节点开始，它们的值依次是 1、2、3、4、5、6。这个链表的倒数第 3 个节点是值为 4 的节点。

**示例：**

```
给定一个链表: 1->2->3->4->5, 和 k = 2.

返回链表 4->5.
```

## 双指针

fast 先走 k 步，然后 slow 和 fast 一起走，直到 fast 走到空

```go
func getKthFromEnd(head *ListNode, k int) *ListNode {
	curNode, preNode := head, head
	for curNode != nil {
		curNode = curNode.Next
		if k == 0 {
			preNode = preNode.Next
		} else {
			k--
		}
	}
	return preNode
}
```

