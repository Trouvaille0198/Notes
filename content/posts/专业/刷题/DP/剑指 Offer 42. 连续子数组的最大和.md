# 剑指 Offer 42. 连续子数组的最大和

`easy`

输入一个整型数组，数组中的一个或连续多个整数组成一个子数组。求所有子数组的和的最大值。

要求时间复杂度为 O(n)。

**示例1:**

```
输入: nums = [-2,1,-3,4,-1,2,1,-5,4]
输出: 6
解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。
```

## DP

用 dp(i) 代表以第 i 个数结尾的「连续子数组的最大和」

dp(i) = max{ dp(i−1) + nums[i], nums[i] }

```go
func maxSubArray(nums []int) int {
	dp := make([]int, len(nums))
	dp[0] = nums[0]
	maxResult := dp[0]
	for i := 1; i < len(nums); i++ {
		if dp[i-1]+nums[i] > nums[i] {
			dp[i] = dp[i-1] + nums[i]
		} else {
			dp[i] = nums[i]
		}
		if dp[i] > maxResult {
			maxResult = dp[i]
		}
	}
	return maxResult
}
```

## 更简便的方法

因为 dp[i] 只与 dp[i-1] 相关，所以用一个 pre 变量接住 dp[i-1] 将空间复杂度降至 O(1)

```go
func maxSubArray(nums []int) int {
	maxResult := nums[0]
	pre := nums[0]
	for i := 1; i < len(nums); i++ {
		if pre > 0 {
			pre = pre + nums[i]
		} else {
			pre = nums[i]
		}
		if pre > maxResult {
			maxResult = pre
		}
	}
	return maxResult
}
```

