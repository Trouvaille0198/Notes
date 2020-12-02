## 16.2
$$
Q_{n}(k)=\frac{1}{n}\left((n-1)\times Q_{n-1}(k)+v_{n}\right)
$$

[推导]：
$$
\begin{aligned}
Q_{n}(k)&=\frac{1}{n}\sum_{i=1}^{n}v_{i}\\
&=\frac{1}{n}\left(\sum_{i=1}^{n-1}v_{i}+v_{n}\right)\\
&=\frac{1}{n}\left((n-1)\times Q_{n-1}(k)+v_{n}\right)\\
&=Q_{n-1}(k)+\frac{1}{n}\left(v_n-Q_{n-1}(k)\right)
\end{aligned}
$$

## 16.3

$$
\begin{aligned}
&Q_{n}(k)=\frac{1}{n}\left((n-1) \times Q_{n-1}(k)+v_{n}\right)\\
&=Q_{n-1}(k)+\frac{1}{n}\left(v_{n}-Q_{n-1}(k)\right)
\end{aligned}
$$



[推导]：参见 16.2

## 16.4

$$
P(k)=\frac{e^{\frac{Q(k)}{\tau }}}{\sum_{i=1}^{K}e^{\frac{Q(i)}{\tau}}}
$$

[解析]：
$$
P(k)=\frac{e^{\frac{Q(k)}{\tau }}}{\sum_{i=1}^{K}e^{\frac{Q(i)}{\tau}}}\propto e^{\frac{Q(k)}{\tau }}\propto\frac{Q(k)}{\tau }\propto\frac{1}{\tau}
$$

## 16.7

$$
\begin{aligned}
V_{T}^{\pi}(x)&=\mathbb{E}_{\pi}[\frac{1}{T}\sum_{t=1}^{T}r_{t}\mid x_{0}=x]\\
&=\mathbb{E}_{\pi}[\frac{1}{T}r_{1}+\frac{T-1}{T}\frac{1}{T-1}\sum_{t=2}^{T}r_{t}\mid x_{0}=x]\\
&=\sum_{a\in A}\pi(x,a)\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{a}(\frac{1}{T}R_{x\rightarrow x{}'}^{a}+\frac{T-1}{T}\mathbb{E}_{\pi}[\frac{1}{T-1}\sum_{t=1}^{T-1}r_{t}\mid x_{0}=x{}'])\\
&=\sum_{a\in A}\pi(x,a)\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{a}(\frac{1}{T}R_{x\rightarrow x{}'}^{a}+\frac{T-1}{T}V_{T-1}^{\pi}(x{}')])
\end{aligned}
$$

[解析]：

因为
$$
\pi(x,a)=P(action=a|state=x)
$$
表示在状态$x$下选择动作$a$的概率，又因为动作事件之间两两互斥且和为动作空间，由全概率展开公式
$$
P(A)=\sum_{i=1}^{\infty}P(B_{i})P(A\mid B_{i})
$$
可得
$$
\begin{aligned}
&\mathbb{E}_{\pi}[\frac{1}{T}r_{1}+\frac{T-1}{T}\frac{1}{T-1}\sum_{t=2}^{T}r_{t}\mid x_{0}=x]\\
&=\sum_{a\in A}\pi(x,a)\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{a}(\frac{1}{T}R_{x\rightarrow x{}'}^{a}+\frac{T-1}{T}\mathbb{E}_{\pi}[\frac{1}{T-1}\sum_{t=1}^{T-1}r_{t}\mid x_{0}=x{}'])
\end{aligned}
$$
其中
$$
r_{1}=\pi(x,a)P_{x\rightarrow x{}'}^{a}R_{x\rightarrow x{}'}^{a}
$$
最后一个等式用到了递归形式。



## 16.8

$$
V_{\gamma }^{\pi}(x)=\sum _{a\in A}\pi(x,a)\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{a}(R_{x\rightarrow x{}'}^{a}+\gamma V_{\gamma }^{\pi}(x{}'))
$$

[推导]：
$$
\begin{aligned}
V_{\gamma }^{\pi}(x)&=\mathbb{E}_{\pi}[\sum_{t=0}^{\infty }\gamma^{t}r_{t+1}\mid x_{0}=x]\\
&=\mathbb{E}_{\pi}[r_{1}+\sum_{t=1}^{\infty}\gamma^{t}r_{t+1}\mid x_{0}=x]\\
&=\mathbb{E}_{\pi}[r_{1}+\gamma\sum_{t=1}^{\infty}\gamma^{t-1}r_{t+1}\mid x_{0}=x]\\
&=\sum _{a\in A}\pi(x,a)\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{a}(R_{x\rightarrow x{}'}^{a}+\gamma \mathbb{E}_{\pi}[\sum_{t=0}^{\infty }\gamma^{t}r_{t+1}\mid x_{0}=x{}'])\\
&=\sum _{a\in A}\pi(x,a)\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{a}(R_{x\rightarrow x{}'}^{a}+\gamma V_{\gamma }^{\pi}(x{}'))
\end{aligned}
$$

## 16.10

$$
\left\{\begin{array}{l}
Q_{T}^{\pi}(x, a)=\sum_{x^{\prime} \in X} P_{x \rightarrow x^{\prime}}^{a}\left(\frac{1}{T} R_{x \rightarrow x^{\prime}}^{a}+\frac{T-1}{T} V_{T-1}^{\pi}\left(x^{\prime}\right)\right) \\
Q_{\gamma}^{\pi}(x, a)=\sum_{x^{\prime} \in X} P_{x \rightarrow x^{\prime}}^{a}\left(R_{x \rightarrow x^{\prime}}^{a}+\gamma V_{\gamma}^{\pi}\left(x^{\prime}\right)\right)
\end{array}\right.
$$

[推导]：参见 16.7, 16.8

## 16.14

$$
V^{*}(x)=\max _{a \in A} Q^{\pi^{*}}(x, a)
$$

[解析]：为了获得最优的状态值函数$V$，这里取了两层最优，分别是采用最优策略$\pi^{*}$和选取使得状态动作值函数$Q$最大的状态$\max_{a\in A}$。

## 16.16

$$
V^{\pi}(x)\leq V^{\pi{}'}(x)
$$

[推导]：
$$
\begin{aligned}
V^{\pi}(x)&\leq Q^{\pi}(x,\pi{}'(x))\\
&=\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{\pi{}'(x)}(R_{x\rightarrow x{}'}^{\pi{}'(x)}+\gamma V^{\pi}(x{}'))\\
&\leq \sum_{x{}'\in X}P_{x\rightarrow x{}'}^{\pi{}'(x)}(R_{x\rightarrow x{}'}^{\pi{}'(x)}+\gamma Q^{\pi}(x{}',\pi{}'(x{}')))\\
&=\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{\pi{}'(x)}(R_{x\rightarrow x{}'}^{\pi{}'(x)}+\gamma \sum_{x{}'\in X}P_{x{}'\rightarrow x{}'}^{\pi{}'(x{}')}(R_{x{}'\rightarrow x{}'}^{\pi{}'(x{}')}+\gamma V^{\pi}(x{}')))\\
&=\sum_{x{}'\in X}P_{x\rightarrow x{}'}^{\pi{}'(x)}(R_{x\rightarrow x{}'}^{\pi{}'(x)}+\gamma V^{\pi{}'}(x{}'))\\
&=V^{\pi{}'}(x)
\end{aligned}
$$
其中，使用了动作改变条件
$$
Q^{\pi}(x,\pi{}'(x))\geq V^{\pi}(x)
$$
以及状态-动作值函数
$$
Q^{\pi}(x{}',\pi{}'(x{}'))=\sum_{x{}'\in X}P_{x{}'\rightarrow x{}'}^{\pi{}'(x{}')}(R_{x{}'\rightarrow x{}'}^{\pi{}'(x{}')}+\gamma V^{\pi}(x{}'))
$$
于是，当前状态的最优值函数为

$$
V^{\ast}(x)=V^{\pi{}'}(x)\geq V^{\pi}(x)
$$



## 16.31

$$
Q_{t+1}^{\pi}(x,a)=Q_{t}^{\pi}(x,a)+\alpha (R_{x\rightarrow x{}'}^{a}+\gamma Q_{t}^{\pi}(x{}',a{}')-Q_{t}^{\pi}(x,a))
$$

[推导]：对比公式16.29
$$
Q_{t+1}^{\pi}(x,a)=Q_{t}^{\pi}(x,a)+\frac{1}{t+1}(r_{t+1}-Q_{t}^{\pi}(x,a))
$$
以及由
$$
\frac{1}{t+1}=\alpha
$$
可知，若下式成立，则公式16.31成立
$$
r_{t+1}=R_{x\rightarrow x{}'}^{a}+\gamma Q_{t}^{\pi}(x{}',a{}')
$$
而$r_{t+1}$表示$t+1$步的奖赏，即状态$x$变化到$x'$的奖赏加上前面$t$步奖赏总和$Q_{t}^{\pi}(x{}',a{}')$的$\gamma$折扣，因此这个式子成立。



