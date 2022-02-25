# 剑指 Offer 57. 和为s的两个数字

`easy` `双指针`

输入一个递增排序的数组和一个数字s，在数组中查找两个数，使得它们的和正好是s。如果有多对数字的和等于s，则输出任意一对即可。	

**示例 1：**

```
输入：nums = [2,7,11,15], target = 9
输出：[2,7] 或者 [7,2]
```

**示例 2：**

```
输入：nums = [10,26,30,31,47,60], target = 40
输出：[10,30] 或者 [30,10]
```

## 对撞指针

```go
func twoSum(nums []int, target int) []int {
	if len(nums) <= 1 {
		return []int{}
	}
	i, j := 0, len(nums)-1
	for i < j {
		if nums[i]+nums[j] < target {
			i++
		} else if nums[i]+nums[j] > target {
			j--
		} else {
			return []int{nums[i], nums[j]}
		}
	}
	return []int{}
}
```

