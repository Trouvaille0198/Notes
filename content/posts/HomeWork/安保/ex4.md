---
draft: true
---

# 实验四

https://zhuanlan.zhihu.com/p/48249182

**推导 rsa 私钥**

随机选择两个不相等的质数 p 和 q

计算 p 和 q 的乘积 n

计算 n 的欧拉函数 φ(n) = (p-1)(q-1)

随机选择一个整数 e，满足 1< e < φ(n)，且 e 与 φ(n) 互质

计算 e对于 φ(n) 的模反元素 d

即 ed ≡ 1 (mod φ(n))

等价于 ed - 1 = kφ(n)

将 n 和 e 封装成公钥，n 和 d 封装成私钥



公钥加密算法

设加密信息 m，其必须是整数（字符串可以取 ascii 值或 unicode 值），且 m > n。

求出对应的密文 c：

**m^e^ ≡ c (mod n)**



私钥解密算法

**c^d^ ≡ m (mod n)**

