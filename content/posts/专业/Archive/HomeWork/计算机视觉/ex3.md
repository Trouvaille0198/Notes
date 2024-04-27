---
title: "《计算机视觉》实验三报告"
date: 2022-03-23
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验三报告

姓名：孙天野

学号：19120198

## 任务一

1. 读取一张图片，将其转换为 HSV 空间
2. 分离原图片 RGB 通道及转换后的图片 HSV 通道
3. 对 RGB 三个通道分别画出其三维图（提示：polt_sufface 函数）

### 核心代码

```python
from typing import Tuple
import cv2
import numpy as np
import ex1
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter


def convert_HSV(img: np.ndarray) -> np.ndarray:
    """
    将图片转换为HSV空间
    """

    HSV_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    return HSV_img


def get_channels(img: np.ndarray) -> np.ndarray:
    return cv2.split(img)


def show_channel_3D(img: np.ndarray, channel: int = 0):
    """
    获取图像RGB三维图
    params channel: 0-R, 1-G, 2-B
    """
    fig = plt.figure(figsize=(16, 12))

    ax = fig.gca(projection="3d")
    imgd = cv2.split(img)[channel]
    # imgd = np.array(img)

    # 准备数据
    sp = img.shape
    h = int(sp[0])
    w = int(sp[1])

    x = np.arange(0, w, 1)
    y = np.arange(0, h, 1)
    x, y = np.meshgrid(x, y)
    z = imgd
    surf = ax.plot_surface(x, y, z, cmap=cm.coolwarm)  # cmap指color map
    # surf = ax.plot_surface(x, y, z, cmap=cm.rainbow)  # cmap指color map

    # 自定义z轴
    ax.set_zlim(-10, 255)
    ax.zaxis.set_major_locator(LinearLocator(10))  # z轴网格线的疏密，刻度的疏密，20表示刻度的个数
    ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))  # 将z的value字符串转为float，保留2位小数

    # 设置坐标轴的label和标题
    ax.set_xlabel('x', size=15)
    ax.set_ylabel('y', size=15)
    ax.set_zlabel('z', size=15)
    ax.set_title("Surface plot", weight='bold', size=20)

    # 添加右侧的色卡条
    # fig.colorbar(surf, shrink=0.6, aspect=8)  # shrink表示整体收缩比例，aspect仅对bar的宽度有影响，aspect值越大，bar越窄
    plt.show()

if __name__ == '__main__':
    img_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka.png"
    ori_img = ex1.read_img(img_path)

    ex1.show_img(ori_img)  # 原图
    ex1.show_img(convert_HSV(ori_img))  # 转换HSV空间

    print(get_channels(ori_img))  # 获取rgb三通道
    print(get_channels(convert_HSV(ori_img)))  # 获取hsv三通道
    # 展示3D图像
    show_channel_3D(ori_img, 0)
    show_channel_3D(ori_img, 1)
    show_channel_3D(ori_img, 2)
```

### 实验结果截图

HSV 空间

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323103419747.png" alt="image-20220323103419747" style="zoom:67%;" />

三通道

![image-20220323103611935](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323103611935.png)

B 通道

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323103442996.png" alt="image-20220323103442996" style="zoom:67%;" />

G 通道

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323103503757.png" alt="image-20220323103503757" style="zoom: 67%;" />

R 通道

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323103516127.png" alt="image-20220323103516127" style="zoom:67%;" />

### 小结

这次实验是使用 `cv2` 图像处理的进阶操作，我们学习了图像颜色空间的转换、分离三通道和展示通道三维图的操作

## 任务二

1. 读取彩色图像 home_color
2. 画出灰度化图像 home_gray 的灰度直方图，并拼接原灰度图与结果图；
3. 画出彩色 home_color 图像的直方图，并拼接原彩色图与结果图，且与上一问结果放在同一个窗口中显示；
4. 画出 ROI（感兴趣区域 ）的直方图，ROI 区域为 x：50-100，y：100-200，将原图 home_color，ROI 的 mask 图，ROI 提取后的图及其直方图放在一个窗口内显示。

### 核心代码

```python
from typing import Tuple
import cv2
import numpy as np
import ex1
import matplotlib.pyplot as plt

def turn_gray(img: np.ndarray) -> np.ndarray:
    """
    将彩色图转成灰度图
    """
    return cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)


def save_histogram(img, name):
    color = ('b', 'g', 'r')
    for i, col in enumerate(color):
        histr = cv2.calcHist([img], [i], None, [256], [0, 256])
        plt.plot(histr, color=col)
        plt.xlim([0, 256])
    plt.savefig(name)
    plt.clf()  # 清空图像


def save_histogram_gray(img, name):
    plt.hist(img.ravel(), 256, [0, 256])
    plt.savefig(name)
    plt.clf()


def matplotlib_multi_pic(list, rows: int, cols: int):
    """
    使用matplotlib显示多张图片
    param list: 图片列表
    param rows: 行数
    param cols: 列数
    """
    for i in range(len(list)):
        title = "title" + str(i + 1)
        # 行，列，索引
        plt.subplot(rows, cols, i + 1)
        if len(list[i].shape) == 3:
            plt.imshow(list[i][:, :, [2, 1, 0]])
        else:
            plt.imshow(list[i], cmap="gray")
        plt.title(title, fontsize=8)
        plt.xticks([])
        plt.yticks([])
    plt.show()


if __name__ == '__main__':
    img_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka.png"
    ori_img = ex1.read_img(img_path)

    # ex1.show_img(ori_img)  # 原图
    # ex1.show_img(convert_HSV(ori_img))  # 转换HSV空间

    # print(get_channels(ori_img))  # 获取rgb三通道
    # print(get_channels(convert_HSV(ori_img)))  # 获取hsv三通道

    # 展示3D图像
    # show_channel_3D(ori_img, 0)
    # show_channel_3D(ori_img, 1)
    # show_channel_3D(ori_img, 2)

    # 保存直方图
    img_path2 = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\home_color.png"
    ori_img2 = ex1.read_img(img_path2)
    ori_img2_gray = turn_gray(ori_img2)

    save_histogram(ori_img2, r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\histogram.png")
    save_histogram_gray(ori_img2_gray, r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\histogram_gray.png")
    mask = np.zeros(ori_img2.shape, np.uint8)
    mask[50:100, 100:200] = 255
    bitwiseAnd = cv2.bitwise_and(ori_img2, mask)
    ROI = bitwiseAnd[50:100, 100:200]
    save_histogram(ROI, r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\ROI_histogram.png")

    # 展示直方图
    histogram = ex1.read_img(r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\histogram.png")
    histogram_grey = ex1.read_img(r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\histogram_gray.png")

    ROI_histogram = ex1.read_img(r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\ROI_histogram.png")

    matplotlib_multi_pic([ori_img2, histogram, ori_img2_gray, histogram_grey, bitwiseAnd, ROI_histogram], 3, 2)
```

### 实验结果截图

![image-20220323105510713](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323105510713.png)

### 小结

这个实验我使用 `matplotlib` 画图库展示了图像及其灰度图的直方图图像。将多张图像拼合在一起的步骤花了一点时间。

## 任务三

编程实现直方图均衡化，给出测试效果

### 核心代码

```python
import cv2
import numpy as np
import ex1


def turn_gray(img: np.ndarray) -> np.ndarray:
    """
    将彩色图转成灰度图
    """
    return cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)


def hist(img: np.ndarray):
    """
    直方图
    """
    hist, bins = np.histogram(img.flatten(), 256, [0, 256])
    # 获取直方图占比
    p = np.array([hist])/hist.sum()
    p = p[0]

    # 计算累积直方图
    _sum = 0
    for i in range(len(p)):
        p[i] += _sum
        _sum = p[i]
    # 取整扩展
    for i in range(len(p)):
        p[i] = int(p[i]*255+0.5)
    # 构建直方均衡后的图像
    new_img = np.zeros(shape=(img.shape[0], img.shape[1]), dtype=np.uint8)
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            new_img[i][j] = p[img[i][j]]
    return new_img


if __name__ == '__main__':
    img_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka.png"
    ori_img = ex1.read_img(img_path)
    ori_img_gray = turn_gray(ori_img)
    #  ex1.show_img(cv2.equalizeHist(ori_img_gray))  # 均衡化
    ex1.show_img(hist(ori_img_gray))
```

### 实验结果截图

原图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323130114173.png" alt="image-20220323130114173" style="zoom:67%;" />

直方图均衡化后的图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220323130121462.png" alt="image-20220323130121462" style="zoom:67%;" />

### 小结

这个实验我手动实现了直方图的均衡化过程，主要依照了下表进行操作：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20180404130223320" alt="img" style="zoom:67%;" />
