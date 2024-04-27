---
draft: true
---

# 实验三

## 问题描述

编写程序，对图象进行中值滤波，并与实现相同功能的 Matlab 函数（或 cv2 函数）进行运算速度比较

## 实验分析

平滑滤波是低频增强的空间域滤波技术。它的目的有两类：一类是模糊；另一类是消除噪音。

空间域的平滑滤波一般采用简单平均法进行，就是求掩模内像素点的平均亮度值。此题则是求掩模内像素点的中位数。

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20170522174236373)

## 实现

### 代码

`median_blur1` 函数是调用了 cv2 的 `medianBlur ` 函数

`median_blur2` 手动实现了简单的中值滤波

```python
# ex3 中值滤波
import numpy as np
import cv2
import time
file_path = r"D:\Repo\PythonLearning\cv2Learning\assets\dog.png"


def median_blur1(file_path: str, ksize: int = 5):
    """
    opencv中值滤波
    :param file_path: 图片路径
    :param ksize: 滤波模板的尺寸大小，必须是大于1的奇数
    """
    start_time = time.time()
    img = cv2.imread(file_path)
    img = cv2.medianBlur(img, ksize)
    cv2.imshow('img', img)
    end_time = time.time()
    print('耗时{}s'.format(end_time - start_time))
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


def median_blur2(file_path: str, ksize: int = 5, is_grey: bool = False):
    """
    手动实现的中值滤波
    :param file_path: 图片路径
    :param ksize: 滤波模板的尺寸大小，必须是大于1的奇数
    """
    start_time = time.time()
    edge = int((ksize-1)/2)
    img = cv2.imread(file_path)
    if is_grey:
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    height, width = img.shape[:2]  # 将图片尺寸记录下来

    for i in range(height):
        for j in range(width):
            if i <= edge-1 or i >= height-edge-1 or j < edge-1 or j >= width-edge-1:
                # 忽略出界点
                continue
            if is_grey:
                img[i, j] = np.median(
                    img[i-edge:i+1+edge, j-edge:j+edge+1])
            else:
                img[i, j, 0] = np.median(
                    img[i-edge:i+1+edge, j-edge:j+edge+1, 0])
                img[i, j, 1] = np.median(
                    img[i-edge:i+1+edge, j-edge:j+edge+1, 1])
                img[i, j, 2] = np.median(
                    img[i-edge:i+1+edge, j-edge:j+edge+1, 2])

    cv2.imshow('img', img)
    end_time = time.time()
    print('耗时{}s'.format(end_time - start_time))
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


if __name__ == '__main__':
    median_blur2(file_path, 7)

```

### 示例

原图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103163129438.png" alt="image-20211103163129438" style="zoom:50%;" />

使用 cv2 的中值滤波函数

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103164641868.png" alt="image-20211103164641868" style="zoom:50%;" />

![image-20211103164749742](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103164749742.png)

自己实现的中值滤波函数

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103164601502.png" alt="image-20211103164601502" style="zoom:50%;" />

![image-20211103165001761](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103165001761.png)

可以看到，cv2 中的中值滤波函数经过优化，耗时非常短。
