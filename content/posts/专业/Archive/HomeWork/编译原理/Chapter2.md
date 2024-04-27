---
draft: true
---

# 作业二 文法与语言

19120198 孙天野

1. ![image-20220404150016571](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404150016571.png)

全部元素：{abc}

2. ![image-20220404150358755](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404150358755.png)

全体非负整数

10. ![image-20220404150535456](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404150535456.png)

$$
G(E)=E=E+T=E+T*F
$$

故 $E+T*F$ 是它的一个右句型

- 短语：$E+T*F$
- 直接短语：$T*F$
- 句柄：$T*F$

15. ![image-20220404151110796](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404151110796.png)

允许 0 打头
$$
\begin{flalign}
&\ G(S) \\
&\ S \rightarrow C|AC \\
&\ C \rightarrow B|AB \\
&\ A \rightarrow 0|1|2|3|4|5|6|7|8|9 \\
&\ B \rightarrow 0|2|4|6|8
\end{flalign}
$$
不允许 0 打头
$$
\begin{flalign}
&\ G(S) \\
&\ S \rightarrow 0|C|AC \\
&\ C \rightarrow B|AB \\
&\ A \rightarrow 1|2|3|4|5|6|7|8|9 \\
&\ B \rightarrow 2|4|6|8
\end{flalign}
$$
