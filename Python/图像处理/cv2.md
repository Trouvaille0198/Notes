# CV2

## 认识

### 安装

```shell
pip install opencv-python 
pip install opencv-contrib-python
```

## 基本操作

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
    - 若在等待时间内按下任意键则返回按键的ASCII码，程序继续运行
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

OpenCV 中图像矩阵的顺序是B、G、R。可以直接通过坐标位置访问和操作图像像素。

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

    在缩小时推荐使用 cv2.INTER_AREA，扩大时推荐使用 cv2.INTER_CUBIC 和 cv2.INTER_LINEAR。

将图片放大一倍

```python
img = cv2.resize(img, dsize=None, fx=2, fy=2, interpolation=cv2.INTER_LINEAR)
# or
img = cv2.resize(img, (int(2*width), int(2*height)), interpolation=cv2.INTER_AREA)
```

***cv2.flip(img, flipcode)***

- 图像翻转
- *img*：原始图像
- *flipcode*：控制翻转效果
    - flipcode = 0：沿 x 轴翻转；
    - flipcode > 0：沿 y 轴翻转；
    - flipcode < 0：x, y 轴同时翻转

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

图像旋转

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

### 正确的退出方法

### 实现正常退出

`cv2.waitkey(delaytime) ->returnvalue` 

- 在 `delaytime` 时间内，按键盘，返回所按键的ASCII值

- 若未在 `delaytime` 时间内按任何键，返回 -1

- 当 `delaytime` 为 0 时，表示永不退回

- 当按 ecs 键时，因为其 ASCII 值为 27，而所有returnvalue的值为27，故可用此机制实现在 `delaytime` 内正常退出

- 推荐使用

    - ```python
        if cv2.waitKey() == ord('q'):
            cv2.destroyAllWindows()
        # ord(‘q’)返回q对应的Unicode码对应的值
        ```

