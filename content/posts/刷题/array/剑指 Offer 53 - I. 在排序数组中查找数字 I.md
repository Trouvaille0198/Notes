# 剑指 Offer 53 - I. 在排序数组中查找数字 I

`easy` `search` `binary search`

统计一个数字在排序数组中出现的次数。

**示例 1:**

```
输入: nums = [5,7,7,8,8,10], target = 8
输出: 2
```

**示例 2:**

```
输入: nums = [5,7,7,8,8,10], target = 6
输出: 0
```

## 二分

跟 34 题差不多

```go
func search(nums []int, target int) int {
	low, high := 0, len(nums)-1
	for low <= high {
		mid := (high + low) >> 1
		if nums[mid] > target {
			high = mid - 1
		} else if nums[mid] < target {
			low = mid + 1
		} else {
			count := 1
			i := mid
			for i-1 >= 0 && nums[i] == nums[i-1] {
				count++
				i--
			}
			i = mid
			for i+1 <= len(nums)-1 && nums[i] == nums[i+1] {
				count++
				i++
			}
			return count
		}
	}
	return 0
}
```

