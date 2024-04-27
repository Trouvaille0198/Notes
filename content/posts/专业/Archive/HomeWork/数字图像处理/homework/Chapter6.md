---
draft: true
---

# 第六章

***rgb2hsv，hsv2rgb***

两函数完成了图像在 RGB 颜色空间和 HSV 颜色空间的互相转换

HSV 的定义与 HSI 类似，只是 V（亮度）是 RGB 中的最大值 `max(max(r,g),b)`，I （强度）指 RGB 的平均值 `(r+g+b) / 3`。函数严格遵循以下公式：

![](https://images2015.cnblogs.com/blog/757205/201704/757205-20170429114726865-1579160119.png)

![](https://images2015.cnblogs.com/blog/757205/201704/757205-20170429114808194-565902650.png)

![](https://images2015.cnblogs.com/blog/757205/201704/757205-20170429114808194-565902650.png)

![](https://images2015.cnblogs.com/blog/757205/201704/757205-20170429114808194-565902650.png)

****

6-3 

![image-20211027183333415](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027183333415.png)

可以得出，落在边上的颜色坐标取决于边的两个顶点代表的颜色和两个顶点到此点的长度之比，而第三个点对于此点的没有影响。

如图，$\frac{p_1}{p_2}=\frac{c_1c_0}{c_2c_0}$，$p_1+p_2=100-p_3$，对于 $c_1$ 和 $c_2$ 亦如是，即可得出三个颜色在新颜色上的占比 $p_1, p_2, p_3$

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027183319838.png" alt="image-20211027183319838" style="zoom:50%;" />

****

6-5 

![image-20211027174259905](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027174259905.png)
$$
\frac{1}{2}R+\frac{1}{2}B+G=midgray+\frac{1}{2}G
$$
图像颜色为纯绿色加上中灰色，显示一个亮度更亮的绿色。

****

6-14

![image-20211027174657436](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027174657436.png)

（a）8bit 图像的色调最多只能被分为 255 个值；又因为色调在 0°-360° 的范围内，故 8bit 图像中，每一级色调的增量为 360/255，也就是说，[0,360] 的色调范围被压缩到了 [0, 255]。

- 黄色 60°，灰度值为 43
- 绿色 120°，灰度值为 85
- 可得另外两个区域的灰度值为 170 和 213，中间的纯白色区域为 0，黑色背景则为 255

（b）圆圈区域饱完全饱和，灰度值为 255；中心区域是白色的，灰度值为 0

（c）中心区域白色，灰度值为 255；红色、蓝色、绿色的亮度是相等的；故浅灰色部分为 170，深灰色部分为 85

****

6-25 

![image-20211027180853605](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027180853605.png)

（a）因为图像完全饱和，所以图像 S 恒为 1；所有方块的亮度 I 均为 1/3；H：故红色部分最灰，绿色部分次灰，蓝色部分灰色最浅。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027181746179.png" alt="image-20211027181746179" style="zoom:50%;" />

（c）在方块内部，颜色恒定不变，在方块边界的值将介于几个方快之间，并取决于模板中不同颜色方块所占的比例。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211027181943106.png" alt="image-20211027181943106" style="zoom:50%;" />