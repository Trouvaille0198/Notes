# 剑指 Offer 46. 把数字翻译成字符串

`mid`

给定一个数字，我们按照如下规则把它翻译为字符串：0 翻译成 “a” ，1 翻译成 “b”，……，11 翻译成 “l”，……，25 翻译成 “z”。一个数字可能有多个翻译。请编程实现一个函数，用来计算一个数字有多少种不同的翻译方法。

**示例 1:**

```
输入: 12258
输出: 5
解释: 12258有5种不同的翻译，分别是"bccfi", "bwfi", "bczi", "mcfi"和"mzi"
```

## DP

字符串的第 ii 位置：

- 可以单独作为一位来翻译
- 如果第 i - 1i−1 位和第 ii 位组成的数字在 1010 到 2525 之间，可以把这两位连起来翻译

![image-20220221004819514](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221004819514.png)

```go
func translateNum(num int) int {
	s := strconv.Itoa(num)
	if len(s) == 0 {
		return 0
	}
	dp := make([]int, len(s))
	dp[0] = 1
	if len(s) == 1 {
		return 1
	}
	if s[0:2] <= "25" && s[0:2] >= "10" {
		dp[1] = 2
	} else {
		dp[1] = 1
	}

	for i := 2; i < len(s); i++ {
		pre := s[i-1 : i+1]
		if pre <= "25" && pre >= "10" {
			dp[i] = dp[i-1] + dp[i-2]
		} else {
			dp[i] = dp[i-1]
		}
	}
	return dp[len(s)-1]
}
```

## 优化

将空间压缩为 O(1)

```go
func translateNum(num int) int {
	s := strconv.Itoa(num)
	if len(s) == 0 {
		return 0
	}
	a1, a2 := 1, 1 // dp[i-1]和dp[i-2]
	result := 1
	for i := 1; i < len(s); i++ {
		pre := s[i-1 : i+1] // 当前位和上一位组成的二位数字
		if pre <= "25" && pre >= "10" {
			result = a1 + a2
		} else {
			result = a1
		}
		a2 = a1
		a1 = result
	}
	return result
}
```

