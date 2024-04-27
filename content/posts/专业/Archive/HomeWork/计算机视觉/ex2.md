---
title: "《计算机视觉》实验二报告"
date: 2022-03-16
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验二报告

姓名：孙天野

学号：19120198

## 任务一

读取一张图片，完成以下任务：

1. 平移：x 轴平移 100 像素，y 轴平移 150 像素
2. 缩放：缩放到 1024*768；按比例缩小（60%）
3. 翻转：水平翻转，垂直翻转，水平+垂直翻转
4. 旋转：给出旋转中心，旋转角度，对图片旋转
5. 缩略：将图片缩小，放到原图的左上角

### 核心代码

```python
from typing import Tuple
import cv2
import numpy as np
import ex1


def move(img: np.ndarray, x_offset: int, y_offset: int) -> np.ndarray:
    """
    按照指定偏移量平移图片
    :param x_offset: x轴偏移像素
    :param y_offset: y轴偏移像素
    """
    height, width, _ = img.shape
    moving_matrix = np.float64([[1, 0, x_offset], [0, 1, y_offset]])

    moved_img = cv2.warpAffine(img, moving_matrix, (height, width))

    return moved_img


def resize(img: np.ndarray, height: int, width: int) -> np.ndarray:
    """
    按照指定分辨率缩放图片
    :param height: 高度
    :param width: 宽度
    """
    resized_img = cv2.resize(img, (width, height))
    return resized_img


def resize_by_scale(img: np.ndarray, scale: float = 1) -> np.ndarray:
    """
    按照指定比例缩放图片
    :param height: 高度
    :param width: 宽度
    """
    resized_img = cv2.resize(img, dsize=None, fx=scale, fy=scale)
    return resized_img


def flip(img: np.ndarray, x: bool, y: bool) -> np.ndarray:
    """
    翻转图片
    :param x: 是否水平翻转
    :param x: 是否垂直翻转
    """
    if x and y:
        flip_code = -1
    elif x and not y:
        flip_code = 0
    elif not x and y:
        flip_code = 1
    else:
        return img

    flipped_img = cv2.flip(img, flip_code)
    return flipped_img


def rotate(img: np.ndarray, angle: float = 0, rotate_center: Tuple[int, int] = (0.5, 0.5)) -> np.ndarray:
    """
    按照指定角度旋转图片
    :param file_path: 图片路径 
    :param angle: 旋转角度
    """
    rows, cols = img.shape[:2]
    M = cv2.getRotationMatrix2D((int(cols*rotate_center[0]), int(rows*rotate_center[1])), angle, 1)
    rotated_img = cv2.warpAffine(img, M, (cols, rows), borderValue=(255, 255, 255))
    return rotated_img

def thumbnail(img: np.ndarray) -> np.ndarray:
    """
    缩略图
    """
    tiny_img = cv2.resize(img, None, fx=0.5, fy=0.5, interpolation=cv2.INTER_AREA)
    height, width, _ = tiny_img.shape

    black_img = np.zeros(img.shape, dtype="uint8")
    black_img[:height, :width] = tiny_img
    return black_img

def turn_gray(img: np.ndarray) -> np.ndarray:
    """
    将彩色图转成灰度图
    """
    return cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)


def add_cricle_mask(img: np.ndarray) -> np.ndarray:
	"""
    使用圆形掩模对图片进行切片
    """
   
    # 创建圆形区域，填充白色255
    circle = np.zeros(img.shape[0:2], dtype="uint8")
    cv2.circle(circle, tuple(map(lambda x: int(x/2), img.shape[0:2])), img.shape[0]//2, 255, -1)  # 修改

    return cv2.bitwise_and(img, img, mask=circle)


if __name__ == '__main__':
    img_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka.png"
    ori_img = ex1.read_img(img_path)
	
    # 使用实验一的展示图片函数
    ex1.show_img(ori_img)  # 原图

    ex1.show_img(move(ori_img, 100, 150))  # 平移

    ex1.show_img(resize(ori_img, 1024, 768))  # 缩放成1024*768
    ex1.show_img(resize_by_scale(ori_img, 0.6))  # 缩放成60%

    ex1.show_img(flip(ori_img, True, False))  # 水平翻转
    ex1.show_img(flip(ori_img, False, True))  # 垂直翻转
    ex1.show_img(flip(ori_img, True, True))  # 水平+垂直翻转

    ex1.show_img(rotate(ori_img, 36, (0.6, 0.1)))  # 按指定旋转中心和角度旋转
    
    ex1.show_img(thumbnail(ori_img)) # 缩略图

    gray_img = resize(turn_gray(ori_img), 500, 500)  # 正方形灰度图
    ex1.show_img(add_cricle_mask(gray_img))  # 圆形掩模切片
```

### 实验结果截图

![image-20220316085553468](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316085553468.png)

![image-20220316090950129](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316090950129.png)

![image-20220316092316809](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316092316809.png)

![image-20220316092215601](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316092215601.png)

![image-20220316092220815](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316092220815.png)

![image-20220316092930947](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316092930947.png)

![](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316092832628.png)

![image-20220316124454347](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316124454347.png)

![image-20220316120740394](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316120740394.png)

![image-20220316121822545](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220316121822545.png)

### 小结

这次实验是使用 `cv2` 图像处理的进阶操作，我们学习了图像的平移、缩放、翻转、旋转、添加掩模等操作，了解了 opencv 的相关接口。