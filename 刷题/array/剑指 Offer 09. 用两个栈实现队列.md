# 用两个栈实现队列

`easy`

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

