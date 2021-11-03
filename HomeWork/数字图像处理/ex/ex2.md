# 实验二

## 问题描述

编写程序，实现图像的实数倍放大

## 实验分析

## 实现

### 代码

```python
# ex2 图像的实数倍放大，并且实现图像的规定长度和宽度缩放.
import numpy as np
import cv2
file_path = r"D:\Repo\PythonLearning\cv2Learning\assets\pic.jpg"


def show_scale(file_path: str, x_scale: float = 1, y_scale: float = 1):
    """
    按照规定长度和宽度缩放图像
    :param file_path: 图片路径 
    :param x_scale: 水平缩放倍数
    :param y_scale: 垂直缩放倍数
    """
    img = cv2.imread(file_path)
    img = cv2.resize(img, dsize=None, fx=x_scale, fy=y_scale)
    cv2.imshow('img', img)
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


if __name__ == '__main__':
    show_scale(file_path, 0.2, 0.5)
```

### 示例

