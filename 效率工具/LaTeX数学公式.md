 # 数学模式

在LaTeX数学模式中，公式有两种形式——行内公式和行间公式。前者公式嵌入在行内，适用于简单短小的公式；后者居中独占一行，适用于比较长或重要的公式。

- 空格

  公式中的空格均会被忽略，可以使用命令`\quad`或`\qquad`实现

- 编号

  在行间公式中，命令`\tag{n}`可以进行手动编号

  例

  ```latex
  $$ f(x) = a - b \tag{1.1} $$
  ```

  $$
  f(x) = a - b \tag{1.1}
  $$

  

## 行内公式

- 格式

  `$ 公式 $`

- 例

  ```latex
  $ f(x)=a+b $
  ```

  $f(x)=a+b$

## 行间公式

- 格式

  `$$ 公式 $$`

- 例

  ```latex
  $$ f(x) = a+b $$
  ```

  
  $$
  f(x) = a+b
  $$

- 说明

  使用Typora时，$$ + Enter即可快速创建一个公式块

- 多行公式

  使用\\\\来换行

  ```latex
  $$   
  2x+3y=34\\   
  x+4y=25  
  $$
  ```

  $$
  2x+3y=34\\   
  x+4y=25  
  $$

  

# 数学结构

## 常用符号

| 名称           | 代码                                  | 示例                                                         | 显示                                                         |
| -------------- | ------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 上下标         | ^, _                                  | a_{ij}^{2}                                                   | $a_{ij}^{2} $                                                |
| 分数           | \frac  \cfrac                         | \frac {1}{3}   \cfrac {1}{3}                                 | $\frac {1}{3}$  $\cfrac {1}{3}$                              |
| 开方           | \sqrt[n]  []不写默认开平方根          | \sqrt[3]{5-x}                                                | $\sqrt[3]{5-x}$                                              |
| 上下标记       | \overline, \underline                 | \overline{x+y} \qquad \underline{a+b}​                        | $\overline{x+y} \qquad \underline{a+b}$                      |
| 上下水平大括号 | \overbrace, \underbrace               | \overbrace{1+2+\cdots+n}^{n个} \\ \underbrace{a+b+\cdots+z}_{26} | $\overbrace{1+2+\cdots+n}^{n个} \\ \underbrace{a+b+\cdots+z}_{26}$ |
| 向量           | \vec, \overrightarrow, \overleftarrow | \vec{a} + \overrightarrow{AB} + \overleftarrow{DE}           | $\vec{a} + \overrightarrow{AB} + \overleftarrow{DE}$         |

## 关系运算符

| 代码           | 符号         |
| -------------- | ------------ |
| \pm            | $\pm$        |
| \times         | $\times$     |
| \div           | $\div$       |
| \mid           | $\mid$       |
| \cdot （点乘） | $\cdot$      |
| \bigodot       | $\bigodot$   |
| \bigotimes     | $\bigotimes$ |
| \bigoplus      | $\bigoplus$  |
| \leq           | $\leq$       |
| \geq           | $\geq$       |
| \neq           | $\neq$       |
| \approx        | $\approx$    |
| \equiv         | $\equiv$     |
| \sum           | $\sum$       |
| \prod          | $\prod$      |

## 对数运算符

| 代码 | 符号   |
| ---- | ------ |
| \log | $\log$ |
| \lg  | $\lg$  |
| \ln  | $\ln$  |

## 三角运算符

| 代码   | 符号     |
| ------ | -------- |
| \bot   | $\bot$   |
| \angle | $\angle$ |
| \sin   | $\sin$   |
| \cos   | $\cos$   |
| \tan   | $\tan$   |
| \cot   | $\cot$   |
| \sec   | $\sec$   |
| \csc   | $\csc$   |

## 微积分运算符

| 代码       | 符号         |
| ---------- | ------------ |
| \int       | $\int$       |
| \iint      | $\iint$      |
| \iiint     | $\iiint$     |
| \oint      | $\oint$      |
| \lim       | $\lim$       |
| \infty     | $\infty$     |
| \mathrm{d} | $\mathrm{d}$ |
| \partial   | $\partial$   |

## 集合运算符

| 代码      | 符号        |
| --------- | ----------- |
| \emptyset | $\emptyset$ |
| \in       | $\in$       |
| \notin    | $\notin$    |
| \subset   | $\subset$   |
| \subseteq | $\subseteq$ |
| \supseteq | $\supseteq$ |
| \bigcap   | $\bigcap$   |
| \bigcup   | $\bigcup$   |
| \bigvee   | $\bigvee$   |
| \bigwedge | $\bigwedge$ |

## 矩阵

| 代码     | 示例                                                  | 显示                                                    |
| -------- | ----------------------------------------------------- | ------------------------------------------------------- |
| \matrix  | \begin{matrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{matrix}   | $\begin{matrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{matrix}$   |
| \bmatrix | \begin{bmatrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{bmatrix} | $\begin{bmatrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{bmatrix}$ |
| \vmatrix | \begin{vmatrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{vmatrix} | $\begin{vmatrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{vmatrix}$ |
| \pmatrix | \begin{pmatrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{pmatrix} | $\begin{pmatrix} 1&2&3 \\ 4&5&6 \\ 7&8&9 \end{pmatrix}$ |

下列代码中，&用于分隔列，\用于分隔行

```latex
$$\begin{bmatrix}
1 & 2 & \cdots \\
67 & 95 & \cdots \\
\vdots  & \vdots & \ddots \\
\end{bmatrix}$$
```

$$
\begin{bmatrix}
1 & 2 & \cdots \\
67 & 95 & \cdots \\
\vdots  & \vdots & \ddots \\
\end{bmatrix}
$$

# 希腊字母

| 代码     | 大写       | 代码      | 小写       |
| -------- | ---------- | --------- | ---------- |
| A        | $A$        | \alpha    | $\alpha$   |
| B        | $B$        | \beta     | $\beta$    |
| \Gamma   | $\Gamma$   | \gamma    | $\gamma$   |
| \Delta   | $\Delta$   | \delta    | $\delta$   |
| E        | $E$        | \epsilon  | $\epsilon$ |
| Z        | $Z$        | \zeta     | $\zeta$    |
| H        | $H$        | \eta      | $\eta$     |
| \Theta   | $\Theta$   | \theta    | $\theta$   |
| I        | $I$        | \iota     | $\iota$    |
| K        | $K$        | \kappa    | $\kappa$   |
| \Lambda  | $\Lambda$  | \lambda   | $\lambda$  |
| M        | $M$        | \mu       | $\mu$      |
| N        | $N$        | \nu       | $\nu$      |
| Xi       | $Xi$       | \xi       | $\xi$      |
| O        | $O$        | \\omicron | $\omicron$ |
| \Pi      | $\Pi$      | \pi       | $\pi$      |
| P        | $P$        | \rho      | $\rho$     |
| \Sigma   | $\Sigma$   | \sigma    | $\sigma$   |
| T        | $T$        | \tau      | $\tau$     |
| \Upsilon | $\Upsilon$ | \upsilon  | $\upsilon$ |
| \Phi     | $\Phi$     | \phi      | $\phi$     |
| X        | $X$        | \chi      | $\chi$     |
| \Psi     | $\Psi$     | \psi      | $\psi$     |
| \Omega   | $\Omega$   | \omega    | $\omega$   |

# 一万个例子

```latex
$$ \int_0^1 \arctan \mathrm{d}x = \arctan x \bigg| _0^1 - \int _0^1 x \mathrm{d}(\arctan x) = \frac{\pi}{4} - \frac{1}{2}\ln(1+x^2) $$
```

$$
\int_0^1 \arctan \mathrm{d}x = \arctan x \bigg| _0^1 - \int _0^1 x \mathrm{d}(\arctan x) = \frac{\pi}{4} - \frac{1}{2}\ln(1+x^2)
$$

```latex
$$ \int _{-3}^3 \frac{x^5 \sin ^3 x}{4+x^2+x^4}\mathrm{d}x + \int _0^1 e ^\sqrt{x}\mathrm{d}x $$
```


$$
\int _{-3}^3 \frac{x^5 \sin ^3 x}{4+x^2+x^4}\mathrm{d}x + \int _0^1 e ^\sqrt{x}\mathrm{d}x
$$

```latex
$$ \begin{cases}
\  \alpha_i \ge 0
\\ \ y_if(x_i)-1 \ge 0
\\ \ \alpha_i(y_if(\vec x_i)-1) \ge 0
\end{cases} $$
```

$$
\begin{cases}
   \  \alpha_i \ge 0
\\ \ y_if(x_i)-1 \ge 0
\\ \ \alpha_i(y_if(\vec x_i)-1) \ge 0
\end{cases}
$$

- 界定符前冠以 \left（修饰左定界符）或 \right（修饰右定界符），可以得到自适应缩放的定界符

```latex
$$ \left( \sum_{k=\frac{1}{2}}^{N^2}\frac{1}{k} \right) $$
```

$$
\left(\sum_{k=\frac{1}{2}}^{N^2}\frac{1}{k}\right)
$$

```latex
$$ A+AB=A
\\ A+\overline AB=A+B
\\ AB+\A \overline B=A
\\ AB+\overline {A}C +BC=AB+\overline{A}C $$
```

$$ A+AB=A
\\ A+\overline AB=A+B
\\ AB+A \overline B=A
\\ AB+\overline {A}C +BC=AB+\overline{A}C $$

