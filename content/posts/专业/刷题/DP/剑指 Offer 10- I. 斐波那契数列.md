# 剑指 Offer 10- I. 斐波那契数列

`easy`

写一个函数，输入 `n` ，求斐波那契（Fibonacci）数列的第 `n` 项（即 `F(N)`）。斐波那契数列的定义如下：

```
F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
```

斐波那契数列由 0 和 1 开始，之后的斐波那契数就是由之前的两数相加而得出。

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

 **示例 1：**

```
输入：n = 2
输出：1
```

**示例 2：**

```
输入：n = 5
输出：5
```

## 解

还省去了一张 O(n) 的表，妙哉

```go
// DP
func fib2(n int) int {
   const mod int = 1e9 + 7
   if n < 2 {
      return n
   }
   a, b, sum := 0, 0, 1
   for i := 2; i <= n; i++ {
      a = b
      b = sum
      sum = (a + b) % mod
   }
   return sum
}
```

```go
func totalFruit(fruits []int) int {
	if len(fruits) == 0 {
		return 0
	}
	dp := make([]int, len(fruits))
	dp[0] = 1
	a, b, aIndex, bIndex := -1, fruits[0], -1, 0
	maxResult := 1
	for i := 1; i < len(fruits); i++ {
		if fruits[i] == a || fruits[i] == b {
			// 加老果子
			if fruits[i] == a {
				aIndex = i
			}
			if fruits[i] == b {
				bIndex = i
			}
			dp[i] = dp[i-1] + 1
		} else {
			// 换新果子
			var length int
			// 计算最近一类果实的长度 并覆盖掉丢弃果子的种类
			if aIndex > bIndex {
				length = aIndex - bIndex
				b = fruits[i]
				bIndex = i
			} else {
				length = bIndex - aIndex
				a = fruits[i]
				aIndex = i
			}
			dp[i] = length + 1
		}
		if maxResult < dp[i] {
			maxResult = dp[i]
		}
	}
	return maxResult
}
```

## 滑动窗口

