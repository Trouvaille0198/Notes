---
draft: true
---

# 实验四

## 问题描述

编写程序，实现阈值分割算法

## 实验分析

阈值分割法是一种基于区域的图像分割技术，cv2 提供了丰富优秀的阈值分割算法。

***cv2.threshold(src, thresh, maxval, type[, dst])***

参数

- *thresh*：阈值

- *maxval*：最大阈值，一般为 25./.,.5

- *type*：阈值方式，最主要有五种

    - | 阈值 | 小于阈值的像素点 | 大于阈值的像素点 |
        | ---- | ---------------- | ---------------- |
        | 0    | 置0              | 置填充色         |
        | 1    | 置填充色         | 置0              |
        | 2    | 保持原色         | 置灰色           |
        | 3    | 置0              | 保持原色         |
        | 4    | 保持原色         | 置0              |

返回值

- *ret*
- *dst*：阈值分割后的图像

## 实现

### 代码

```python
# ex9 阈值分割算法
import cv2
import matplotlib.pyplot as plt

# 灰度图读入
img = cv2.imread(r'D:\Repo\PythonLearning\cv2Learning\assets\dog.png', 0)


# 5种不同的阈值方法
ret, th1 = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
ret, th2 = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY_INV)
ret, th3 = cv2.threshold(img, 127, 255, cv2.THRESH_TRUNC)
ret, th4 = cv2.threshold(img, 127, 255, cv2.THRESH_TOZERO)
ret, th5 = cv2.threshold(img, 127, 255, cv2.THRESH_TOZERO_INV)
titles = ['Original', 'BINARY', 'BINARY_INV', 'TRUNC', 'TOZERO', 'TOZERO_INV']
images = [img, th1, th2, th3, th4, th5]

# 使用Matplotlib显示
# 两行三列图
for i in range(6):
    plt.subplot(2, 3, i + 1)
    plt.imshow(images[i], 'gray')
    plt.title(titles[i], fontsize=8)
    plt.xticks([]), plt.yticks([])  # 隐藏坐标轴
plt.show()
```

### 示例

![image-20211103162537350](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103162537350.png)

