# 第四章

![image-20211020180137663](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020180137663.png)

不会有区别。因为无论哪种填充方式，都能同样地分离图像

****

![image-20211020181106974](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020181106974.png)

上述的操作中，“取该变换的复共轭”一步，将傅里叶变换中的 j 改为了 -j，从而将原图函数 f(x, y) 转换为 f(-x, -y)，造成图像的镜面翻转

The complex conjugate simply changes j to −j in the inverse transform, so the image on the right is given by

![image-20211020181131232](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020181131232.png)

which simply mirrors f(x,y ) about the origin, thus producing the image on the right.

****

![image-20211020181641145](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211020181641145.png)

1. 如果只进行了高通操作，戒指会有一个黑暗的中心。但是这个黑暗地中心区域被低通滤波器平均化了。

    戒指中心明亮的原因是，环状物边界上的不连续边缘比图像中其他地方高得多

2. 不会，因为傅里叶变换进行滤波是一个线性过程。

