# 剑指 Offer 58 - II. 左旋转字符串

`easy`

字符串的左旋转操作是把字符串前面的若干个字符转移到字符串的尾部。

请定义一个函数实现字符串左旋转操作的功能。

比如，输入字符串"abcdefg"和数字2，该函数将返回左旋转两位得到的结果"cdefgab"。

## 语法糖

```go
func reverseLeftWords(s string, n int) string {
	return s[n:] + s[:n]
}
```

## 三次倒转

三次反转即可得到所求答案，空间复杂度降低为O(1)，属于是原地旋转

```go
// reverse 倒转字节数组 s将会被修改
func reverse(s []byte) {
   n := len(s)
   for i := 0; i < n/2; i++ {
      // 交换头尾位置
      tmp := s[i]
      s[i] = s[n-i-1]
      s[n-i-1] = tmp
   }
}

// 三次倒转
func reverseLeftWords2(s string, n int) string {
   bytes := []byte(s)
   reverse(bytes[:n])
   reverse(bytes[n:])
   reverse(bytes)
   return string(bytes)
}
```