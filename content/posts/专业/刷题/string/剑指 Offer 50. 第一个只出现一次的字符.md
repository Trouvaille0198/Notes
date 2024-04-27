# 剑指 Offer 50. 第一个只出现一次的字符

在字符串 s 中找出第一个只出现一次的字符。如果没有，返回一个单空格。 s 只包含小写字母。

**示例 1:**

```
输入：s = "abaccdeff"
输出：'b'
```

**示例 2:**

```
输入：s = "" 
输出：' '
```

## 哈希表

哈希表存放每个出现过字母的出现位置索引

```go
func firstUniqChar(s string) byte {
	hash := make(map[byte][]int)
	for i := 0; i < len(s); i++ {
		hash[s[i]] = append(hash[s[i]], i)
	}
	resultWord := byte(' ')
	index := math.MaxInt
	for k, v := range hash {
		if len(v) == 1 && v[len(v)-1] < index {
			resultWord = k
			index = v[len(v)-1]
		}
	}
	return resultWord
}
```

## 不用哈希表

题目特性：26 个小写字母可以存在 `[26]int` 的数组中

先遍历一遍字符串，将其出现次数存储在数组中，在按字符串遍历一次，同时按字母查询数组，如果次数为 1 则返回。

更快一点。

```go
func firstUniqChar2(s string) byte {
	var list [26]int
	length := len(s)
	for i := 0; i < length; i++ {
		list[s[i]-'a']++
	}
	for i := 0; i < length; i++ {
		if list[s[i]-'a'] == 1 {
			return s[i]
		}
	}
	return ' '
}
```

