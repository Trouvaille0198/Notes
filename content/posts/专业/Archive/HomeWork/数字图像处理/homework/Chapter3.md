---
draft: true
---

# 第三章

**3-1 为了展开一幅图像的灰度，使其最低灰度为 C，最高灰度为 L-1，试给出一个单调的变换函数**
$$
s=T(r)=
\begin{cases}
   \  C, \ if \ r<C
\\ \ r, \ Others
\end{cases}
$$

****

**3-5 将低有效比特平面设为零对图像的直方图有什么影响？将高有效比特平面设为零对图像的直方图有什么影响？**

1. 将低有效比特平面设为零，图像中具有不同灰阶值的像素数目将降低。而像素的总数目不变，因此最终直方图中各分量的幅值将增加。灰阶值的减少通常会导致对比度下降。
2. 高有效比特平面设为零，将导致图像亮度和对比度的下降。并且因为丢失了大量的细节信息，造成图像质量严重下降。例如，若将 8bit 图像的最高位丢掉，图像的最高亮度就由 255 变成 127。同样，像素总数保持不变，最终直方图中某些分量的幅值将升高。直方图的整体形状就是高而窄，并且在大于 127 的灰度上没有直方图分量。

****

**3-6 为什么离散直方图均衡技术一般不能得到平坦的直方图？**

直方图均衡即在灰阶尺度上重新影射各直方图分量。

为了获得均匀平坦的直方图，要求在各灰阶上都具有相同的像素数目。即，假设共有 L 个灰阶，总的像素数目为 n，则每个直方图分量中都有 n/L 个像素。

而直方图均衡并不能确保实现上述分布。

****

**3-14**

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211017210530688.png" alt="image-20211017210530688" style="zoom:50%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211017210535045.png" alt="image-20211017210535045" style="zoom:50%;" />

具有相同灰度直方图的图像，用同一模板处理后，直方图应该还是相同的，因为其均值模板处理时是针对灰度值的，并不是针对图像像素的，所以其直方图还是相同的

****

**3-15**

![image-20211017210549655](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211017210549655.png)

(1) 对于 3×3 的掩模：
$$
R_{new}=R_{old}+(C_3-C_1)
$$
而对于 n×n 的掩模，计算 $C_n$ 需要 $(n-1)$ 次加法，计算 $R_{new}$ 需要 1 次减法和 1 次加法，共计 $(n+1)$ 次运算

(2)
$$
A=\frac{n^2-1}{n+1}=n-1
$$

****

**3-21**

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211017210559935.png" alt="image-20211017210559935" style="zoom:50%;" />

![image-20211017163221563](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211017163221563.png)

当 n=25 的方形均值掩模向右平移时，掩模所覆盖的属于竖直条的像素的个数并不发生变换，因而其输出的像素平均值不变。因此，竖条间没有间隔。

****

**3-23**

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211017210607573.png" alt="image-20211017210607573" style="zoom:67%;" />

拉普拉斯模板和均值模板都是线性操作，交换顺序不会影响结果

## imadjust

### 语法

`imadjust()` 

用于调节灰度图像的亮度或彩色图像的颜色矩阵。

常用语法有

- `J = imadjust(I)`

- `J = imadjust(I, [low_in; high_in], [low_out; high_out], gamma)`

### 描述

`J = imadjust(I)` 

- 将灰度图像 I 中的灰度值映射成输出图像 J 中的新值，使得灰度图像 I 在低灰度值和高灰度值上 1% 的数据是饱和的。这增强了输出图像 J 的对比度。
- 本语法相当于 `imadjust(I, stretchlim(I))`。

`J = imadjust(I, [low_in; high_in], [low_out; high_out], gamma)` 

- 将灰度图像 I 中的灰度值映射成输出图像 J 中的新值，使得 low_in 和 high_in 之间的值映射成 low_out 和 high_out 之间的值。
- low_in，high_in，low_out，high_out 的值必须在 0 到 1 之间。
- 低于 low_in 的值和高于 high_in 的值被去除，也就是说，低于 low_in 的值映射成 low_out，高于 high_in 的值映射成 high_out。
- 你可以用一个空矩阵 `[]` 来替代 `[low_in; high_in]` 或者 `[low_out; high_out]`，这样就默认为 [0 1]。
- 参数 `gamma` 指定了曲线的形状，该曲线用来映射 I 的亮度值。如果 `gamma` 小于 1，映射被加权到更高的输出值。如果 `gamma` 大于 1，映射被加权到更低的输出值。如果省略了函数的参量，则 `gamma` 默认为 1（线性映射）。

### 类型支持

对于包含输入图像（而不是色彩表）的语法变体，输入图像的类型可以是 uint8, uint16, int16, single 和 double，输出图像的类型与输入图像相同。对于包含色彩表的语法变体，输入和输出色彩表的类型都是 double。

 ## medfilt2

在 matlab 中，medfilt2 函数用于执行二维中值滤波，使用方法如下：

```matlab
B = medfilt2(A, [m n])  // 其中[m n]表示邻域块的大小，默认值为[3 3]。
B = medfilt2(A)
B = medfilt2(A, ’indexed’, ...)
```

