---
title: "offer 30"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,栈与队列]
categories: [刷题]
---

# 剑指 Offer 30. 包含 min 函数的栈

`easy` `stack`

https://leetcode-cn.com/problems/bao-han-minhan-shu-de-zhan-lcof/

定义栈的数据结构，请在该类型中实现一个能够得到栈的最小元素的 min 函数在该栈中，调用 min、push 及 pop 的时间复杂度都是 O(1)。

示例:

```go
MinStack minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
minStack.min();   --> 返回 -3.
minStack.pop();
minStack.top();      --> 返回 0.
minStack.min();   --> 返回 -2.
```

## 双栈

将 `min()` 函数复杂度降为 `O(1)`，可通过建立**辅助栈**实现；
数据栈 A： 栈 A 用于存储所有元素，保证入栈 `push()` 函数、出栈 `pop()` 函数、获取栈顶 `top()` 函数的正常逻辑。
辅助栈 B： 栈 B 中存储栈 A 中所有非严格降序的元素，则栈 A 中的最小元素始终对应栈 B 的栈顶元素，即 `min()` 函数只需返回栈 B 的栈顶元素即可

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/f31f4b7f5e91d46ea610b6685c593e12bf798a9b8336b0560b6b520956dd5272-Picture1.png" alt="Picture1.png" style="zoom:50%;" />

```go
package stack

import (
	"container/list"
)

type MinStack struct {
	stack    *list.List // 主栈
	minStack *list.List // 记录最小元素的栈
}

/** initialize your data structure here. */

func Constructor() MinStack {
	oriList := list.New()
	oriMinList := list.New()
	return MinStack{stack: oriList, minStack: oriMinList}
}

func (this *MinStack) Push(x int) {
	this.stack.PushBack(x)
	if this.minStack.Len() == 0 || x <= this.minStack.Back().Value.(int) {
		this.minStack.PushBack(x)
	}
}

func (this *MinStack) Pop() {
	deletedVal := this.stack.Remove(this.stack.Back())
	if deletedVal == this.minStack.Back().Value.(int) {
		this.minStack.Remove(this.minStack.Back())
	}
}

func (this *MinStack) Top() int {
	return this.stack.Back().Value.(int)
}

func (this *MinStack) Min() int {
	return this.minStack.Back().Value.(int)
}

/**
 * Your MinStack object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Push(x);
 * obj.Pop();
 * param_3 := obj.Top();
 * param_4 := obj.Min();
 */
```

