# 剑指 Offer 47. 礼物的最大价值

`mid`

在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。

 你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？

## DP

$$
f(i,j)=max[f(i,j−1),f(i−1,j)]+grid(i,j)
$$

![image-20220220222545083](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220220222545083.png)

```go
func maxValue(grid [][]int) int {
	if len(grid) == 0 {
		return 0
	}
	m, n := len(grid), len(grid[0])

	dp := make([][]int, 0)
	for i := 0; i < m; i++ {
		tmp := make([]int, n)
		dp = append(dp, tmp)
	}

	var up, left int
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if i == 0 && j == 0 {
				dp[i][j] = grid[i][j]
				continue
			}
			if i > 0 {
				up = dp[i-1][j] + grid[i][j]
			} else {
				up = 0
			}
			if j > 0 {
				left = dp[i][j-1] + grid[i][j]
			} else {
				left = 0
			}

			if up > left {
				dp[i][j] = up
			} else {
				dp[i][j] = left
			}
		}
	}
	return dp[m-1][n-1]
}
```

## 优化

可以原地修改数组

```go
func maxValue(grid [][]int) int {
	if len(grid) == 0 {
		return 0
	}
	m, n := len(grid), len(grid[0])

	var up, left int
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if i == 0 && j == 0 {
				continue
			}
			if i > 0 {
				up = grid[i-1][j] + grid[i][j]
			} else {
				up = 0
			}
			if j > 0 {
				left = grid[i][j-1] + grid[i][j]
			} else {
				left = 0
			}

			if up > left {
				grid[i][j] = up
			} else {
				grid[i][j] = left
			}
		}
	}
	return grid[m-1][n-1]
}
```

## 极致优化

以上代码逻辑清晰，和转移方程直接对应，但仍可提升效率：当 grid 矩阵很大时，i=0 或 j = 0 的情况仅占极少数，相当循环每轮都冗余了一次判断。因此，可先初始化矩阵第一行和第一列，再开始遍历递推。

