# 实验一

## 问题描述

编写程序，实现图像任意角度的旋转（注意精度）

## 实验分析

## 实现

### 代码

```python
# ex1 图像任意角度旋转
import numpy as np
import cv2
file_path = r"D:\Repo\PythonLearning\cv2Learning\assets\pic.jpg"


def show_rotate(file_path: str, angle: float = 0):
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


if __name__ == '__main__':
    show_rotate(file_path, 45)
```

### 示例

