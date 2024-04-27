# 剑指 Offer 63. 股票的最大利润

假设把某股票的价格按照时间先后顺序存储在数组中，请问买卖该股票一次可能获得的最大利润是多少？

**示例 1:**

```
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
```

**示例 2:**

```
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

## 一次遍历

我们来假设自己来购买股票。随着时间的推移，每天我们都可以选择出售股票与否。那么，假设在第 i 天，如果我们要在今天卖股票，那么我们能赚多少钱呢？

显然，如果我们真的在买卖股票，我们肯定会想：如果我是在历史最低点买的股票就好了！太好了，在题目中，我们只要用一个变量记录一个历史最低价格 minprice，我们就可以假设自己的股票是在那天买的。那么我们在第 i 天卖出股票能得到的利润就是 prices[i] - minprice。

因此，我们只需要遍历价格数组一遍，记录历史最低点，然后在每一天考虑这么一个问题：如果我是在历史最低点买进的，那么我今天卖出能赚多少钱？当考虑完所有天数之时，我们就得到了最好的答案。

```go
func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// 一次遍历
func maxProfit(prices []int) int {
	curMinPrice := math.MaxInt
	maxPro := 1

	for i := 0; i < len(prices); i++ {
		maxPro = max(maxPro, prices[i]-curMinPrice)
		curMinPrice = min(curMinPrice, prices[i])
	}
	return maxPro
}
```

## DP

前 *i* 日最大利润 = max(前 (*i*−1) 日最大利润, 第 *i* 日价格 − 前 *i* 日最低价格)

dp[i] = max(dp[i−1],prices[i]−min(prices[0:i]))

```go
// DP
func maxProfit2(prices []int) int {
   if len(prices) == 0 {
      return 0
   }
   dp := make([]int, len(prices))
   minPrice := prices[0]
   for i := 1; i < len(prices); i++ {
      if dp[i-1] >= prices[i]-minPrice {
         dp[i] = dp[i-1]
      } else {
         dp[i] = prices[i] - minPrice
      }

      if prices[i] < minPrice {
         minPrice = prices[i]
      }
   }
   return dp[len(prices)-1]
}
```