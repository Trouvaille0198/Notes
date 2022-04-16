# 作业三 词法分析

19120198 孙天野

1. ![image-20220415184728459](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415184728459.png)

![image-20220415192453173](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415192453173.png)



2. ![image-20220415185310749](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415185310749.png)


1. 划分成两个子集 $P_1=\{A,D,E\},P_2=\{B,C,F\}$

2. 区分 $P_2$：$P_{21}=\{C,F\},P_{22}=\{B\}$
3. 区分 $P_1$：$P_{11}=\{A,E\},P_{22}=\{D\}$

4. $A,E$ 可区分
5. $P=\{\{A\},\{B\},\{D\},\{E\},\{C,F\}\}$

| $I$    | $I_a$  | $I_b$    |
| ------ | ------ | -------- |
| A[S]   | B[Q,V] | C[Q,U]   |
| B[Q,V] | D[V,Z] | C[Q,U]   |
| C[Q,U] | E[V]   | F[Q,U,Z] |
| D[V,Z] | G[Z]   | G[Z]     |

4. ![image-20220415190241125](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415190241125.png)

(a) 先用子集法转换为 DFA

| $I$    | $I_a$  | $I_b$ |
| ------ | ------ | ----- |
| A[0]   | B[0,1] | C[1]  |
| B[0,1] | B[0,1] | C[1]  |
| C[1]   | A[0]   |       |

![image-20220415192527197](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415192527197.png)

(b) 已是 DFA

1. 划分成两个子集 $P_1=\{0\},P_2=\{1,2,3,4,5\}$

2. 区分 $P_2$：$P_{21}=\{4\},P_{22}=\{1,2,3,5\}$
3. 区分 $P_{22}$：$P_{221}=\{1,5\},P_{222}=\{2,3\}$

4. 区分 $P_{221}$：$P_{2211}=\{1\},P_{2212}=\{5\}$

5. 区分 $P_{222}$：$P_{2221}=\{2\},P_{2222}=\{3\}$

6. $P=\{\{0\},\{1,5\},\{2\},\{3\},\{4\}\}$

![image-20220415192626406](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415192626406.png)

5. ![image-20220415190426176](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415190426176.png)

正规式：$(0|(10))^*$

正规文法：
$$
\begin{flalign}
&\ G(A) \\
&\ A \rightarrow 1C|0A|\epsilon \\
&\ C \rightarrow 0A \\
\end{flalign}
$$

8. ![image-20220415190657287](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220415190657287.png)

$S=01S|10S|01|10=(01|10)S|(01|10)=(01|10)^*$

所以正规式为 $(01|10)$
