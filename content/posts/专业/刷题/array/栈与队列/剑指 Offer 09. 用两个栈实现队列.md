---
title: "剑指 Offer 09. 用两个栈实现队列"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [算法,栈与队列]
categories: [刷题]
hiddenFromHomePage: true
---

# 剑指 Offer 09. 用两个栈实现队列

`easy` `stack`

https://leetcode-cn.com/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof/

用两个栈实现一个队列。队列的声明如下，请实现它的两个函数 appendTail 和 deleteHead ，分别完成在队列尾部插入整数和在队列头部删除整数的功能。(若队列中没有元素，deleteHead 操作返回 -1 )

示例 1：

```
输入：
["CQueue","appendTail","deleteHead","deleteHead"]
[[],[3],[],[]]
输出：[null,null,3,-1]
```

## 双栈

根据栈先进后出的特性，我们每次往第一个栈里插入元素后，第一个栈的顶部元素是最后插入的元素，第一个栈的底部元素是下一个待删除的元素。

为了维护队列先进先出的特性，我们引入第二个栈，用第二个栈维护待删除的元素，在执行删除操作的时候我们首先看下第二个栈是否为空。

如果为空，我们将第一个栈里的元素一个个弹出插入到第二个栈里，这样第二个栈里元素的顺序就是待删除的元素的顺序，要执行删除操作的时候我们直接弹出第二个栈的元素返回即可。

```go
type CQueue struct {
	stack1 []int // 主栈
	stack2 []int // 副栈
}

func Constructor() CQueue {
	return CQueue{stack1: []int{}, stack2: []int{}}
}

func (this *CQueue) AppendTail(value int) {
	this.stack1 = append(this.stack1, value)
}

func (this *CQueue) DeleteHead() int {
    // 只有stack2为空时，stack1中的元素才会倒入stack2中
	if len(this.stack2) == 0 {
		if len(this.stack1) == 0 {
			return -1
		}
		// 逆序传给stack2
		for i := len(this.stack1) - 1; i >= 0; i-- {
			this.stack2 = append(this.stack2, this.stack1[i])
		}
		this.stack1 = []int{}
	}
	result := this.stack2[len(this.stack2)-1]
	this.stack2 = this.stack2[:len(this.stack2)-1] // 去掉stack2栈顶元素
	return result
}
```

