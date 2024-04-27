---
draft: true
---

# 实验一

## 问题描述

编写程序，实现图像任意角度的旋转（注意精度）

## 实验分析

## 实现

图像旋转通常以中心为原点进行，基本步骤为

1. 将矩阵坐标转换为笛卡尔坐标系
2. 将该点旋转 $\theta$ 度
3. 将旋转后的点再转换为矩阵坐标

有

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2010122615441054.png)

值得注意的是，图像旋转后，新图像的大小会发生改变

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2010122616090174.png)

取旋转后四个绝对值最大的点，定义新图像的大小

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2010122616144144.png)

### 代码

`show_rotate1` 函数调用了 cv2 的 `warpAffine` 函数，运用仿射变换原理完成了图像的旋转

`show_rotate2` 函数则手动实现了朴素的旋转算法

```python
# ex1 图像任意角度旋转
import math
import numpy as np
import cv2


def show_rotate1(file_path: str, angle: float = 0):
    """
    按照指定角度旋转头像
    :param file_path: 图片路径 
    :param angle: 旋转角度
    """
    img = cv2.imread(file_path)
    rows, cols = img.shape[:2]
    M = cv2.getRotationMatrix2D((cols/2, rows/2), angle, 1)
    img = cv2.warpAffine(img, M, (cols, rows), borderValue=(255, 255, 255))
    cv2.imshow('img', img)
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


def show_rotate2(file_path: str, angle: float = 0):
    img = cv2.imread(file_path)
    height, width = img.shape[:2]

    angle_pi = angle*math.pi/180.0
    cos_A = math.cos(angle_pi)
    sin_A = math.sin(angle_pi)

    # 确定新图的大小
    new_x1 = math.ceil(abs(0.5*height*cos_A + 0.5*width*sin_A))
    new_x2 = math.ceil(abs(0.5*height*cos_A - 0.5*width*sin_A))
    new_y1 = math.ceil(abs(-0.5*height*sin_A + 0.5*width*cos_A))
    new_y2 = math.ceil(abs(-0.5*height*sin_A - 0.5*width*cos_A))
    new_height = int(2*max(new_y1, new_y2))
    new_width = int(2*max(new_x1, new_x2))

    new_img = np.zeros(shape=(new_height, new_width, 3), dtype=np.uint8)

    for i in range(height):
        for j in range(width):
            x = int(
                cos_A*i-sin_A*j-0.5*width*cos_A+0.5*height*sin_A+0.5*new_width)
            y = int(
                sin_A*i+cos_A*j-0.5*width*sin_A-0.5*height*cos_A+0.5*new_height)

            new_img[x, y] = img[i, j]
    cv2.imshow('img', new_img)
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


if __name__ == '__main__':
    file_path = r"D:\Repo\PythonLearning\cv2Learning\assets\pic.jpg"
    show_rotate2(file_path, 66.71)
```

### 示例

cv2 函数效果

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103192759573.png" alt="image-20211103192759573" style="zoom: 33%;" />

手动实现的算法效果

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103192249074.png" alt="image-20211103192249074" style="zoom: 33%;" />

可以看到手动实现的图像新添了很多“蜂窝煤”状的坏点
