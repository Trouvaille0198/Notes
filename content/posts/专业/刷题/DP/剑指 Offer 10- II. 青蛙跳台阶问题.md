# 剑指 Offer 10- II. 青蛙跳台阶问题

一只青蛙一次可以跳上 1 级台阶，也可以跳上 2 级台阶。求该青蛙跳上一个 n 级的台阶总共有多少种跳法。

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

**示例 1：**

```
输入：n = 2
输出：2
```

**示例 2：**

```
输入：n = 7
输出：21
```

**示例 3：**

```
输入：n = 0
输出：1
```

## 解

这就是斐波那契数列嘛

```go
func numWays(n int) int {
	const mod = 1e9 + 7
	a, b, sum := 0, 1, 1
	for i := 2; i <= n; i++ {
		a = b
		b = sum
		sum = (a + b) % mod
	}
	return sum
}
```

