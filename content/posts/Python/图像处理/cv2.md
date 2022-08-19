---
title: "CV2"
date: 2022-02-20
draft: false
author: "MelonCholi"
tags: [快速开始, Python, cv2]
categories: [Python]
---

# CV2

## 认识

### 安装

```shell
pip install opencv-python 
pip install opencv-contrib-python
```

## 图片的基本操作

### 图片的加载、显示与保存

```python
import cv2
# 生成图片
img = cv2.imread("1.jpg")
# 生成灰色图片
imgGrey = cv2.imread("1.jpg", 0)
# 展示原图
cv2.imshow("img", img)
# 展示灰色图片
cv2.imshow("imgGrey", imgGrey)
# 等待图片的关闭
cv2.waitKey()
# 保存灰色图片
cv2.imwrite("Copy.jpg", imgGrey)
```

***cv2.imread(filepath, flags)***     

- 读入一张图像
- *filepath*：图片路径
- *flags*：读入图片的标志 
    - `cv2.IMREAD_COLOR`：**默认参数**，读入一副彩色图片，忽略 alpha 通道
    - `cv2.IMREAD_GRAYSCALE`：读入灰度图片
    - `cv2.IMREAD_UNCHANGED`：顾名思义，读入完整图片，包括 alpha 通道

***cv2.imshow(wname, img)***   

- 显示图像

- *wname*：显示图像的窗口的名字
- *img*：要显示的图像（imread 读入的图像），窗口大小自动调整为图片大小

***cv2.imwrite(file, img, num)***    

- 保存一张图像
- *file*：是要保存的文件名
- *img*：要保存的图像。
- *num*：压缩级别。默认为 3

***cv2.waitKey(time)***

- 等待指定时间内是否有键盘输入
    - 若在等待时间内按下任意键则返回按键的 ASCII 码，程序继续运行
    - 若没有按下任何键，超时后返回 -1。参数为 0 表示无限等待（只显示第一帧）
    - 不调用此函数的话，窗口会一闪而逝，看不到显示的图片
- *time*：时间，单位为毫秒

***img.copy()***   

- 图像复制

***np.zeros(img.shape, np.uint8)***

- 返回指定大小的空图像

```python
import cv2
import numpy as np

img = cv2.imread("1.jpg")
imgZero = np.zeros(img.shape, np.uint8)

imgFix = np.zeros((300, 500, 3), np.uint8)
# imgFix = np.zeros((300,500),np.uint8)

cv2.imshow("img", img)
cv2.imshow("imgZero", imgZero)
cv2.imshow("imgFix", imgFix)
cv2.waitKey()
```

### 图像显示窗口创建与销毁

```python
import cv2

img = cv2.imread("1.jpg")

cv2.namedWindow("img", cv2.WINDOW_NORMAL)
cv2.imshow("img", img)
cv2.waitKey()
cv2.destroyAllWindows()
```

***cv2.namedWindow(wname, flag)*** 

- 创建一个窗口
- *wname*：窗口名

- flag：指定窗口大小模式
    - cv2.WINDOW_AUTOSIZE：默认值，根据图像大小自动创建大小
    - cv2.WINDOW_NORMAL：窗口大小可调整
    - cv2.destoryAllWindows（窗口名）：删除任何建立的窗口

***cv2.destroyAllWindow()***

- 销毁所有窗口

***cv2.destroyWindow(wname)***

- 销毁指定窗口
- *wname*：窗口名

### 图像对象的属性

***img.shape***

- 返回图像高（图像矩阵的行数）、宽（图像矩阵的列数）和通道数 3 个属性组成的元组
- 若图像是非彩色图，则只返回高和宽组成的元组。

```python
import cv2

img = cv2.imread("1.jpg")
imgGrey = cv2.imread("1.jpg", 0)

sp1 = img.shape
sp2 = imgGrey.shape

print(sp1)
print(sp2)
# ======输出=======
#(1200, 1920, 3)
#(1200, 1920)
```

***img.size***

- 图像像素总数目

***img.dtype***

- 图像数据类型，一般情况下都是 uint8

***img[B, G, R]***

- 访问图像对应位置的像素

```python
#获取图像的三通道
blue,green,red = cv2.split(f)    
#或者
blue = f[:,:,0]
green = f[:,:,1]
red = f[:,:,2]
```

OpenCV 中图像矩阵的顺序是 B、G、R。可以直接通过坐标位置访问和操作图像像素。

```python
import cv2
 
img = cv2.imread("01.jpg")
 
numb = img[50,100]
print(numb)

img[50,100] = (0,0,255)#将50，100处的像素点改为红色
cv2.imshow("img",img)
cv2.waitKey()
```

分开访问图像某一通道像素值

```python
import cv2

img = cv2.imread("01.jpg")

img[0:100,100:200,0] = 255
img[100:200,200:300,1] = 255
img[200:300,300:400,2] = 255

cv2.imshow("img",img)
cv2.waitKey()
```

更改某一矩阵中的像素值

```python
import cv2

img = cv2.imread("01.jpg")

img[0:50,1:100] = (0,0,255) 

cv2.imshow("img",img)
cv2.waitKey()
```

### 图像颜色空间

***cv2.cvtColor(img, cv2.COLOR_X2Y)***

- 图像颜色空间转换
- *img*：图像对象
- *cv2.COLOR_X2Y*：从 X 图像转为 Y 图像
    - 其中 X, Y = RGB, BGR, GRAY, HSV, YCrCb, XYZ, Lab, Luv, HLS

```python
img2 = cv2.cvtColor(img,cv2.COLOR_RGB2GRAY)   #灰度化：彩色图像转为灰度图像
img3 = cv2.cvtColor(img,cv2.COLOR_GRAY2RGB)   #彩色化：灰度图像转为彩色图像
```

### 图像的几何变换

#### 平移

```python
height, width, _ = img.shape
moving_matrix = np.float64([[1, 0, x_offset], [0, 1, y_offset]])
moved_img = cv2.warpAffine(img, moving_matrix, (height, width))
```

#### 缩放

***cv2.resize(image, dsize, fx, fy, interpolation)***

- 图像缩放，返回缩放后的图像

- *img*：原始图像

- *dsize*：图像大小，宽度在前，高度在后，如 `(200, 100)`

- *fx*：代表水平方向上（图像宽度）的缩放系数

- *fy*：代表竖直方向上（图像高度）的缩放系数

- | interpolation 选项 | 所用的插值方法                                               |
    | ------------------ | ------------------------------------------------------------ |
    | INTER_NEAREST      | 最近邻插值                                                   |
    | INTER_LINEAR       | 双线性插值（默认设置）                                       |
    | INTER_AREA         | 使用像素区域关系进行重采样。 它可能是图像抽取的首选方法，因为它会产生无云纹理的结果。 但是当图像缩放时，它类似于INTER_NEAREST方法。 |
    | INTER_CUBIC        | 4x4像素邻域的双三次插值                                      |
    | INTER_LANCZOS4     | 8x8像素邻域的Lanczos插值                                     |

    在缩小时推荐使用 `cv2.INTER_AREA`，扩大时推荐使用 `cv2.INTER_CUBIC` 和 `cv2.INTER_LINEAR`。

将图片放大一倍

```python
img = cv2.resize(img, dsize=None, fx=2, fy=2, interpolation=cv2.INTER_LINEAR)
# or
img = cv2.resize(img, (int(2*width), int(2*height)), interpolation=cv2.INTER_AREA)
```

#### 翻转

***cv2.flip(img, flipCode)***

- 图像翻转
- *img*：原始图像
- *flipCode*：控制翻转效果
    - flipCode = 0：沿 x 轴翻转；
    - flipCode > 0：沿 y 轴翻转；
    - flipCode < 0：x, y 轴同时翻转

#### 仿射变化

***cv2.getRotationMarix2D(center, angle, scale)***

- 获得仿射变化矩阵
- *center*：旋转中心
- *angle*：旋转角度
- *scale*：缩放倍数

***cv2.warpAffine(img,M,dsize,flags,borderMode,borderValue)***

- 进行仿射变化
- *img*：图像
- *M*：变换矩阵
- *dsize*：输出图像的大小，格式为 `(rows,cols)`
- *flags*：插值方法的组合，默认为 `cv2.INTER_LINEAR`
- *borderMode*：边界像素模式，默认为 `cv2.BORDER_REFLECT`
- *borderValue*：边界填充值; 默认为 0，可设成 `(255,255,255)`
- 日常进行仿射变换时，在只设置前三个参数的情况下，如 `cv2.warpAffine(img,M,(rows,cols))` 可以实现基本的仿射变换效果，但可能出现“黑边”现象

#### 旋转

```python
import cv2

img = cv2.imread('4.jpg')
rows, cols = img.shape[:2]
# 第一个参数是旋转中心，第二个参数是旋转角度，第三个参数是缩放比例
M1 = cv2.getRotationMatrix2D((cols/2, rows/2), 45, 0.5)
M2 = cv2.getRotationMatrix2D((cols/2, rows/2), 45, 2)
M3 = cv2.getRotationMatrix2D((cols/2, rows/2), 45, 1)
res1 = cv2.warpAffine(img, M1, (cols, rows))
res2 = cv2.warpAffine(img, M2, (cols, rows))
res3 = cv2.warpAffine(img, M3, (cols, rows))
cv2.imshow('res1', res1)
cv2.imshow('res2', res2)
cv2.imshow('res3', res3)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

### 图像三通道分离和合并

***cv2.split(img)***

- 分离图像三通道，返回包含被分离的三个图像的元组
- *img*：原始图像

***cv2.merge(img_list)***

- 合并图像三通道，返回合并后的图像
- *img_list*：包含三个图像的数组

```python
import cv2
 
img = cv2.imread("01.jpg")

b , g , r = cv2.split(img)

# b = cv2.split(img)[0]
# g = cv2.split(img)[1]
# r = cv2.split(img)[2]

merged = cv2.merge([b,g,r])

cv2.imshow("Blue",b)
cv2.imshow("Green",g)
cv2.imshow("Red",r)

cv2.imshow("Merged",merged)
cv2.waitKey()
```

### 颜色空间转换

***cv2.cvtColor(img, cv2.COLOR_BGR2HSV)***

- 从 RGB 转换为 HSV

### 实现正常退出

***cv2.waitkey(delaytime) ->returnvalue***

- 在 `delaytime` 时间内，按键盘，返回所按键的 ASCII 值

- 若未在 `delaytime` 时间内按任何键，返回 -1

- 当 `delaytime` 为 0 时，表示永不退回

- 当按 ecs 键时，因为其 ASCII 值为 27，而所有 returnvalue 的值为 27，故可用此机制实现在 `delaytime` 内正常退出

- 推荐使用

    - ```python
        if cv2.waitKey() == ord('q'):
            cv2.destroyAllWindows()
        # ord('q')返回q对应的Unicode码对应的值
        ```

## 滤波

### 均值滤波

均值滤波只取内核区域下所有像素的平均值并替换中心元素。3x3 标准化的盒式过滤器如下所示：

![img](https://img-blog.csdnimg.cn/20191029161721268.png)

***cv2.blur(img,ksize)***

参数

- *ksize*：核大小，如 `(5, 5)`

特征：核中区域贡献率相同。

作用：对于椒盐噪声的滤除效果比较好。

### 中值滤波

中值滤波是一种典型的非线性滤波，是基于排序统计理论的一种能够有效抑制噪声的非线性信号处理技术

中值滤波将图像的每个像素用邻域（以当前像素为中心的正方形区域）像素的**中值**代替 。与邻域平均法类似，但计算的是中值。

特征：中心点的像素被核中中位数的像素值代替

作用：对于椒盐噪声有效

***cv2.medianBlur(img, ksize)***

参数

- ksize：滤波模板的尺寸大小，必须是大于 1 的奇数，如 3、5、7

### 高斯滤波

对整幅图像进行加权平均，每个像素的值尤其本身和邻域内的其他像素值经过加权平均后得到

***cv2.GuassianBlur(img, ksize,sigmaX,sigmaY)***

参数

- *sigmaX*，*sigmaY*：分别表示 X，Y 方向的标准偏差
    - 如果仅指定了 sigmaX，则 sigmaY 与 sigmaX 相同
    - 如果两者都为零，则根据内核大小计算它们

特征：核中区域贡献率与距离区域中心成正比，权重与高斯分布相关。

作用：高斯模糊在从图像中去除高斯噪声方面非常有效	

## 图像提取

SIFT 的全称是 Scale Invariant Feature Transform，尺度不变特征变换。是在不同的尺度空间上查找关键点（特征点），并计算出关键点的方向。

SIFT 所查找到的关键点是一些十分突出、不会因光照、仿射变换和噪音等因素而变化的点，如角点、边缘点、暗区的亮点及亮区的暗点等。

SIFT 特征对旋转、尺度缩放、亮度变化等保持不变性，是一种非常稳定的局部特征。

**环境**

```python
pip install opencv-contrib-python
```

**例**

```python
import cv2
import matplotlib.pyplot as plt

img = cv2.imread(
    r'D:\Repo\PythonLearning\cv2Learning\assets\selina.jpg', 0)  # 输入灰度图
# 构造生成器
sift = cv2.xfeatures2d.SIFT_create()
# 检测图片
kp, des = sift.detectAndCompute(img, None)  # 关键点（Keypoint）和描述子（Descriptor）
# 绘出关键点
img2 = cv2.drawKeypoints(img, kp, None, (255, 0, 0), 4)

# 显示
plt.figure(figsize=(10, 10))  # 画布放大10倍
plt.axis('off')  # 隐藏坐标轴
plt.imshow(img2)  # 打印图像
plt.show()  # 显示画布

if cv2.waitKey() == ord('q'):
    cv2.destroyAllWindows()
```

## 阈值分割

### 二值阈值分割

***cv2.threshold(src, thresh, maxval, type[, dst])***

参数

- *thresh*：阈值

- *maxval*：最大阈值，一般为 255

- *type*：阈值方式，最主要有五种

    - | 阈值 | 小于阈值的像素点 | 大于阈值的像素点 |
        | ---- | ---------------- | ---------------- |
        | 0    | 置 0             | 置填充色         |
        | 1    | 置填充色         | 置 0             |
        | 2    | 保持原色         | 置灰色           |
        | 3    | 置 0             | 保持原色         |
        | 4    | 保持原色         | 置 0             |

返回值

- *ret*
- *dst*：阈值分割后的图像

例：

```python
import cv2
import matplotlib.pyplot as plt

# 灰度图读入
img = cv2.imread(r'D:\Repo\PythonLearning\cv2Learning\assets\gradient.png', 0)

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

输出

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210929180610118.png" alt="image-20210929180610118" style="zoom:50%;" />

### 自适应阈值分割

固定阈值将整幅图片分成两类值，它并不适用于明暗分布不均的图片。而自适应阈值会每次取图片的一小部分计算阈值。这样图片不同区域的阈值就不尽相同

***cv2.adaptiveThreshold(src, maxValue, adaptiveMethod, thresholdType, blockSize, C)***

参数

- *maxValue*：当 thresholdType 采用 `cv2.THRESH_BINARY` 和 `cv2.THRESH_BINARY_INV` 时像素点被赋予的新值
- *adaptiveMethod*：自适应阈值的计算方法
    - `cv2.ADPTIVE_THRESH_MEAN_C`：阈值取**自相邻区域**（也就是小区域）的平均值
    - `cv2.ADPTIVE_THRESH_GAUSSIAN_C`：阈值取值相邻区域的加权和，权重为一个高斯窗口
- *thresholdType*：阈值分割类型，共 5 种，同 `cv2.threshold()` 的阈值分割类型参数
- *blockSize*：用来计算阈值的邻域大小（小区域的面积，如 11 就是 11 * 11 的小块）
- *C*：常数，最终阈值 = 小区域计算出的阈值 - C

例

```python
import cv2
import matplotlib.pyplot as plt

# 灰度图读入
img = cv2.imread(r'D:\Repo\PythonLearning\cv2Learning\assets\selina.jpg', 0)

# 固定阈值
ret, th1 = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)

# 自适应阈值
th2 = cv2.adaptiveThreshold(
    img, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 4)
th3 = cv2.adaptiveThreshold(
    img, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 17, 6)

titles = ['Original', 'Global(v = 127)', 'Adaptive Mean', 'Adaptve Gaussian']
images = [img, th1, th2, th3]

for i in range(4):
    plt.subplot(2, 2, i + 1), plt.imshow(images[i], 'gray')
    plt.title(titles[i], fontsize=8)
    plt.xticks([]), plt.yticks([])  # 隐藏坐标轴
plt.show()
```

输出

![image-20210929182009030](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210929182009030.png)

## 标记

***cv2.drawKeypoints(img, keypoints, outputimage, color, flags)***

参数

- *keypoints*：从原图中获得的关键点，这也是画图时所用到的数据
- *outputimage*：输出（可以是原始图片）
- *color*：颜色设置，格式为 `(r, g, b)`
- *flags*：绘图功能的标识设置
    -  `cv2.DRAW_MATCHES_FLAGS_DEFAULT`：创建输出图像矩阵，使用现存的输出图像绘制匹配对和特征点，对每一个关键点只绘制中间点
    - `cv2.DRAW_MATCHES_FLAGS_DRAW_OVER_OUTIMG`：不创建输出图像矩阵，而是在输出图像上绘制匹配对
    - `cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS`：对每一个特征点绘制带大小和方向的关键点图形
    - `cv2.DRAW_MATCHES_FLAGS_NOT_DRAW_SINGLE_POINTS`：单点的特征点不被绘制 

## 其他图片操作

### 添加文字

```python
import cv2
img = cv2.imread('caijian.jpg')
font = cv2.FONT_HERSHEY_SIMPLEX

imgzi = cv2.putText(img, '000', (50, 300), font, 1.2, (255, 255, 255), 2)
```

***cv2.putText(img, text, org, fontFace, fontScale, color, thickness=None, lineType=None, bottomLeftOrigin=None)***

- *text*：str，文字
- *org*：tuple[2]，图像中文本字符串的左下角
- *fontFace*：字体类型，请参见 #HersheyFonts
- *fontScale*：字体比例因子乘以特定于字体的基本大小
- *color*：字体颜色
- *thickness*：线条粗细
- *lineType*：线型。 请参阅 #LineTypes
- *bottomLeftOrigin*：如果为 true，则图像数据原点位于左下角。 否则，它位于左上角

进行 putText 操作之后，读取原图像也是具有文字显示的

但是原图的文件并没有被改变

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20191025143148996.png)

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20191025143220522.png)

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20191025144020368.png)

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20191025144001417.png)

## 视频的基本操作

```python
import numpy as np
import cv2

cap = cv2.VideoCapture('video1.mp4')

while(cap.isOpened()):
    ret, frame = cap.read()
    cv2.imshow('frame',frame)
    # 按下 q 退出播放
    if cv2.waitKey(1) & 0xFF == ord('q'):	
        break

cap.release()
cv2.destroyAllWindows()
```

### 获取视频

#### 获取本地视频

```python
cap = cv2.VideoCapture('video1.mp4')
```

***cv2.VideoCapture(path)***

获取视频的逐帧进行

cap 返回值如下：

```python
<VideoCapture 000001B6734E1310>
```

#### 获取摄像头

```python
cap = cv2.VideoCapture(0)
...
cap.release()
```

***VideoCapture()***

由摄像头输入视频，默认摄像头为 0

在使用 `cv2.VideoCapture()` 时习惯性在最后使用 `cap.release()` 释放视频。

### 读入视频

```python
ret, frame = cap.read()
print(ret,frame.shape)
```

***cap.read()***

返回值为 `retval `和 `image`，分别是一个**布尔值**和**读取的一帧图片**。

`frame.shape` 返回一个**布尔值**和**数组每个维度的值**。显示 True 表示这一帧被成功获取，1920 和 1080 是视频每一帧图片的高和宽，3 是图片的三原色。

```
True (1920, 1080, 3)
```

可使用 `cap.get(3)` 和 `cap.get(4)` 验证一下视频宽度和高度：

```python
cap.get(3)

# Out put: 1080.0
```

一般在使用 `cap.read()` 时，为避免获取未开始而出现错误，可以使用 `cap.isOpened()` 检查，实现只有在 `cap` 已经开始的情况下读取。

```python
while cap.isOpened():
    ret,frame = cap.read()
    ...
```

### 播放视频

```python
cv2.imshow('frame',frame)
# 按下 q 退出播放
if cv2.waitKey(1) & 0xFF == ord('q'):	
    break
```

***cv2.imshow(text, video)***

这里播放时也可将视频转换为任意模式，如改变去除颜色或 RGB，再进行播放

```python
gray = cv2.cvtColor(frame,code = cv2.COLOR_BGR2GRAY)
cv2.imshow('gray_frame',gray)
```

```python
RGB_mode = cv2.cvtColor(frame,code = cv2.COLOR_BGR2RGB)
cv2.imshow('RGB_frame',RGB_mode)
```

### 保存视频

```python
import numpy as np
import cv2

cap = cv2.VideoCapture(0)
cv2.VideoWriter_fourcc('M','J','P','G')

#设置输出文件的名称格式，指定FourCC编码，帧数，尺寸
out = cv2.VideoWriter('output.avi',fourcc, 20.0, (640,480)) # 视频MP4

while(cap.isOpened()):
    ret, frame = cap.read()
    if ret==True:
    	#参数为0时竖直方向翻转图片，-1时水平竖直均翻转，1时水平翻转
        frame = cv2.flip(frame,1)
        
        out.write(frame)
        cv2.imshow('frame',frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    else:
        break

cap.release()
out.release()
cv2.destroyAllWindows()
```

***cv2.imwrite()***

### 保存帧图像

```python

def video2image(video_dir,save_dir):
    cap = cv2.VideoCapture(video_dir) #生成读取视频对象
    n = 1   #计数
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))    #获取视频的宽度
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))   #获取视频的高度
    fps = cap.get(cv2.CAP_PROP_FPS)    #获取视频的帧率
    fourcc = int(cap.get(cv2.CAP_PROP_FOURCC))    #视频的编码
    # 定义视频输出
    #writer = cv2.VideoWriter("teswellvideo_02_result.mp4", fourcc, fps, (width, height))
    i = 0
    timeF = int(fps)     #视频帧计数间隔频率
    while cap.isOpened():
        ret,frame = cap.read() #按帧读取视频
        #到视频结尾时终止
        if ret is False :
            break
        #每隔timeF帧进行存储操作
        if (n % timeF == 0) :
            i += 1
            print('保存第 %s 张图像' % i)
            save_image_dir = os.path.join(save_dir,'%s.jpg' % i)
            print('save_image_dir: ', save_image_dir)
            cv2.imwrite(save_image_dir,frame) #保存视频帧图像
        n = n + 1
        cv2.waitKey(1) #延时1ms
```

