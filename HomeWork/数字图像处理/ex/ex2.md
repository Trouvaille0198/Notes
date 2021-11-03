# 实验二

## 问题描述

编写程序，实现图像的实数倍放大

## 实验分析

采用复制行/列可以实现整数倍的放大图像，采用删除行/列可以实现整数倍的缩小图像，但两种方法都无法实现任意倍数和任意位置的放大和缩小图像

步骤

- 计算新的像素在原图的对应位置；
- 为这些对应位置赋灰度值。

##### 计算新像素在原图的对应位置

f(x,y) 表示输出图像，g(u,v) 表示输入图像。几何运算（图像的放大或缩小也是图像的几何运算）可定义为：

![](https://img-blog.csdnimg.cn/2020032123500391.png)

- 如果令：$u_0 = a(x,y) = x$; $v_0 = b(x,y) = y$
    - 那么仅仅是把 g 拷贝到 f 而不加任何改动的恒等运算。
- 如果令：$u_0 = a(x,y) = x + x_0$; $v_0 = b(x,y) = y + y_0$
    - 那么得到平移运算，其中点 (x~0~,y~0~) 被平移到原点
- 如果令：$u_0 = a(x,y) = x/c$; $v_0 = b(x,y) = y/d$
    - 那么会使图像在 x 轴方向放大 c 倍，在 y 轴放大 d 倍。
    - 例如：将一幅 200x200 的图像 g(u,v) 放大 1.5 倍，那么将得到 300x300 的新图像 f(x,y)。
    - 产生新图像的过程，实际就是为 300x300 的像素赋值的过程。
    - 假如为 f(150,150) 赋值 $f(150,150) = g(150/1.5,150/1.5) = g(100,100)$;
    - 假如为 f(100,100) 赋值 $f(100,100) = g(100/1.5,100/1.5) = g(66.7,66.7)$
    - 由于图像像素都是在整数坐标中，所以没有坐标值为 (66.7,66.7) 的像素。所以要采用**插值**的方法给其赋值。

##### 为这些对应位置赋灰度值

因为 (u~0~, v~0~) 不一定要在坐标点上，故需要插值求 g(u~0~, v~0~)；

- **最近邻内插**
    - 取点 (u~0~, v~0~) 最近的整数坐标 (u, v)。在上述例子中，为了求 (66.7, 66.7) 的灰度值，则用 (67, 67) 的灰度值来做插值
- **双线性插值**
    - 根据四个邻点的灰度值通过插值计算 g(u~0~, v~0~)
- **更多邻点的内插**
    - 更高次内插，这种方法往往能取得更为精确的结果，但是相应的计算量也会更大）

使用最邻近插值法实现图像的缩放，比较简单方便；cv2 中同样也提供了图像缩放的函数 `resize`

## 实现

### 代码

`show_scale1` 函数调用了 `cv2.resize`

`show_scale2` 函数手动实现了以便最邻近插值

```python
# ex2 图像的实数倍放大，并且实现图像的规定长度和宽度缩放.
import numpy as np
import cv2
file_path = r"D:\Repo\PythonLearning\cv2Learning\assets\seg.png"


def show_scale1(file_path: str, x_scale: float = 1, y_scale: float = 1):
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


def show_scale2(file_path: str, x_scale: float = 1, y_scale: float = 1):
    img = cv2.imread(file_path)
    cv2.imshow('ori', img)

    ori_height, ori_width = img.shape[:2]  # 将图片尺寸记录下来
    tar_height = round(ori_height*x_scale)
    tar_width = round(ori_width*y_scale)

    new_img = np.zeros(shape=(tar_height, tar_width, 3), dtype=np.uint8)
    for x in range(tar_height):
        for y in range(tar_width):
            src_x = int(x/x_scale)
            src_y = int(y/y_scale)
            if src_x < ori_height and src_y < ori_width:
                new_img[x, y] = img[src_x, src_y]
    cv2.imshow('final', new_img)
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


if __name__ == '__main__':
    show_scale2(file_path, 2.31, 3.34)
```

### 示例

实现了纵向 2.31 倍、横向 3.34 倍的图像放大

![image-20211103185257086](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103185257086.png)
