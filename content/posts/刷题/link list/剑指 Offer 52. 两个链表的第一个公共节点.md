---
title: "剑指 Offer 52. 两个链表的第一个公共节点"
date: 2022-02-26
draft: false
author: "MelonCholi"
tags: [算法, 链表]
categories: [算法]
---

# 剑指 Offer 52. 两个链表的第一个公共节点

输入两个链表，找出它们的第一个公共节点。

如下面的两个链表：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/160_statement.png" alt="img" style="zoom:50%;" />

在节点 c1 开始相交。

**示例 1：**

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/160_example_1.png" alt="img" style="zoom:50%;" />

```go
输入：intersectVal = 8, listA = [4,1,8,4,5], listB = [5,0,1,8,4,5], skipA = 2, skipB = 3
输出：Reference of the node with value = 8
输入解释：相交节点的值为 8 （注意，如果两个列表相交则不能为 0）。从各自的表头开始算起，链表 A 为 [4,1,8,4,5]，链表 B 为 [5,0,1,8,4,5]。在 A 中，相交节点前有 2 个节点；在 B 中，相交节点前有 3 个节点。
```

## 哈希

时间复杂度：O(m+n)；空间复杂度：O(m)，链表 A 的长度

```go
// 哈希
func getIntersectionNode2(headA, headB *ListNode) *ListNode {
	vis := map[*ListNode]bool{}
	for tmp := headA; tmp != nil; tmp = tmp.Next {
		vis[tmp] = true
	}
	for tmp := headB; tmp != nil; tmp = tmp.Next {
		if vis[tmp] {
			return tmp
		}
	}
	return nil
}
```

## 补差值

虽然也是两个指针，但是感觉不能叫双指针...

```go
func getIntersectionNode(headA, headB *ListNode) *ListNode {
	// 分别计算两链表的长度
	i := headA
	aNum := 0
	for i != nil {
		aNum++
		i = i.Next
	}
	i = headB
	bNum := 0
	for i != nil {
		bNum++
		i = i.Next
	}
	var diff int                     // 两链表的差值
	var fastNode, slowNode *ListNode // 要往前跑diff步的链表头 停在原地的链表头
	// 选出长链表的头节点为fastNode
	if aNum > bNum {
		fastNode, slowNode = headA, headB
		diff = aNum - bNum
	} else {
		fastNode, slowNode = headB, headA
		diff = bNum - aNum
	}
	// 往前跑diff步
	for diff != 0 {
		fastNode = fastNode.Next
		diff--
	}
	// 一起跑 直到相遇
	for fastNode != nil && fastNode != slowNode {
		fastNode = fastNode.Next
		slowNode = slowNode.Next
	}
	return fastNode
}
```

## 双指针

太妙了！！！

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221193039971.png" alt="image-20220221193039971" style="zoom:40%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221193121305.png" alt="image-20220221193121305" style="zoom:40%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221193143441.png" alt="image-20220221193143441" style="zoom:40%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221193200216.png" alt="image-20220221193200216" style="zoom:40%;" />

```go
func getIntersectionNode2(headA, headB *ListNode) *ListNode {
	if headA == nil || headB == nil {
		return nil
	}
	pa, pb := headA, headB
	for pa != pb {
		if pa == nil {
			pa = headB
		} else {
			pa = pa.Next
		}
		if pb == nil {
			pb = headA
		} else {
			pb = pb.Next
		}
	}
	return pa
}
```

