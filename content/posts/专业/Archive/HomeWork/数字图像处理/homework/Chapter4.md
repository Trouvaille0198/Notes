---
draft: true
---

# 第四章

![image-20211020180137663](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020180137663.png)

不会有区别。因为无论哪种填充方式，都能同样地分离图像

****

![image-20211020181106974](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020181106974.png)

上述的操作中，“取该变换的复共轭” 一步，将傅里叶变换中的 j 改为了 -j，从而将原图函数 f(x, y) 转换为 f(-x, -y)，造成图像的镜面翻转

![image-20211020181131232](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020181131232.png)

****

![image-20211020181641145](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020181641145.png)

1. 如果只进行了高通操作，戒指会有一个黑暗的中心。但是这个黑暗的中心区域被低通滤波器平均化了。

    戒指中心明亮的原因是，环状物边界上的不连续边缘比图像中其他地方高得多

2. 不会，因为傅里叶变换进行滤波是一个线性过程。

****

![image-20211024122318023](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211024122318023.png)

![image-20211024122327840](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211024122327840.png)

(a) 是的，图像不会发生变化。存在一个 K 值，使图像中所有像素灰度值的平均值为 0。

(b) ![image-20211024122745572](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211024122745572.png)

****

![image-20211024122920032](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211024122920032.png)

1. 中值滤波以消除孤立亮点

2. 高通滤波以增强对比度

3. 直方图均衡

4. 计算平均灰度为 V~0~，再对于所有像素加上 (V-V~0~) 灰度

5. 对所有像素执行以下函数：

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211024123325702.png" alt="image-20211024123325702" style="zoom:50%;" />
