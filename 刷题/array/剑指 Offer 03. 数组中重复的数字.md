# 剑指 Offer 03. 数组中重复的数字

`easy` `search`

https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/

找出数组中重复的数字。


在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。请找出数组中任意一个重复的数字。

**示例 1：**

```
输入：
[2, 3, 1, 0, 2, 5, 3]
输出：2 或 3 
```

## 散列表

其实用哈希集合更好，但 Go 里没有...

```go
// 散列表
func findRepeatNumber(nums []int) int {
	existNum := map[int]int{}
	for _, num := range nums {
		if _, ok := existNum[num]; !ok {
			existNum[num] = 0
		} else {
			return num
		}
	}
	return -1
}
```

## 排序

```go
// 排序
func findRepeatNumber2(nums []int) int {
	sort.Ints(nums)
	for i := 1; i < len(nums); i++ {
		if nums[i] == nums[i-1] {
			return nums[i]
		}
	}
	return -1
}
```

## 原地交换

把数组的索引利用起来

从头到尾扫描这个数组中的数字，当扫描到下标为i的数字时，首先比较这个数字（用m表示）是不是等于i

- 如果是则接着扫描下一个数字；
- 如果不是，则拿它和第m个数字进行比较
    - 如果它和第m个数字相等，就找到了一个重复的数字（该数字在下标为i和m的位置都出现了）；
    - 如果它和第m个数字不相等，就把第i个数字和第m个数字交换，把m放到属于它的位置。

接下来再重复这个比较、交换的过程，直到我们发现一个重复的数字

```go
// 原地交换
func findRepeatNumber3(nums []int) int {
	i := 0
	for i < len(nums) {
		if nums[i] == i {
			// 数字即在对应的索引位置
			i++
			continue
		}
		if nums[nums[i]] == nums[i] {
			// 重复
			return nums[i]
		}
		// 交换到正确的位置
		nums[nums[i]], nums[i] = nums[i], nums[nums[i]]
	}
	return -1
}
```

