# 剑指 Offer 48. 最长不含重复字符的子字符串

请从字符串中找出一个最长的不包含重复字符的子字符串，计算该最长子字符串的长度。

**示例 1:**

```
输入: "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
```

**示例 2:**

```
输入: "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

**示例 3:**

```
输入: "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

## DP

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221170402420.png" alt="image-20220221170402420" style="zoom: 67%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221170411096.png" alt="image-20220221170411096" style="zoom: 67%;" />

### 哈希表

可以用一张哈希表来存放每个出现过的字母的最后位置

```go
func lengthOfLongestSubstring(s string) int {
	if len(s) == 0 {
		return 0
	}
	hash := make(map[byte]int) // 记录每个字母最大的索引
	dp := make([]int, len(s))
	dp[0] = 1
	hash[s[0]] = 0

	maxResult := 1
	for i := 1; i < len(s); i++ {
		index, ok := hash[s[i]]
		if !ok {
			// s[i]未出现过
			dp[i] = dp[i-1] + 1
		} else {
			if i-index > dp[i-1] {
				// 上一个与s[i]相等的字母下标在dp[i-1]之前 可以加1
				dp[i] = dp[i-1] + 1
			} else {
				// 上一个与s[i]相等的字母下标在dp[i-1]之中 没有办法
				dp[i] = i - index
			}
		}
		hash[s[i]] = i
		if maxResult < dp[i] {
			maxResult = dp[i]
		}
	}
	return maxResult
}
```

dp 表还可以省略

```go
func lengthOfLongestSubstring(s string) int {
	if len(s) == 0 {
		return 0
	}
	hash := make(map[byte]int) // 记录每个字母最大的索引

	hash[s[0]] = 0
	maxResult := 1
	pre := 1          // 记录dp[i-1]
	var curResult int // 记录dp[i]

	for i := 1; i < len(s); i++ {
		index, ok := hash[s[i]]
		if !ok {
			// s[i]未出现过
			curResult = pre + 1
		} else {
			if i-index > pre {
				// 上一个与s[i]相等的字母下标在dp[i-1]之前 可以加1
				curResult = pre + 1
			} else {
				// 上一个与s[i]相等的字母下标在dp[i-1]之中 没有办法
				curResult = i - index
			}
		}
		hash[s[i]] = i // 更新
		pre = curResult
		if maxResult < curResult {
			maxResult = curResult
		}
	}
	return maxResult
}

```

### 线性遍历

左边界 i 获取方式： 遍历到 s[j] 时，初始化索引 i = j - 1，向左遍历搜索第一个满足 s[i] = s[j] 的字符即可 。

![image-20220221170805733](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220221170805733.png)

不想写代码了

## 双指针

> 滑动窗口

其实原理是一样的，用一个 i 来框定左边界，保证 i+1 到 j 的字串无重复

```go
// 双指针
func lengthOfLongestSubstring(s string) int {
	if len(s) == 0 {
		return 0
	}
	hash := make(map[byte]int) // 记录每个字母最大的索引
	maxResult := 1

	i := -1 // 左指针 定义左边界 保证i+1到j的字串无重复
	for j := 0; j < len(s); j++ {
		lastIndex, ok := hash[s[j]]

		if ok && lastIndex > i {
			// 上一个与s[j]相等的字母下标在左边界i右边 以其为新左边界
			i = lastIndex
		}
		hash[s[j]] = j // 更新

		if maxResult < j-i {
			maxResult = j - i
		}
	}
	return maxResult
}
```

