# CV2

## 认识

### 安装

```shell
pip install opencv-python  
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

***cv2.imread(filepath,flags)***     

- 读入一张图像
- *filepath*：图片路径
- *flags*：读入图片的标志 
    - `cv2.IMREAD_COLOR`：**默认参数**，读入一副彩色图片，忽略 alpha 通道
    - `cv2.IMREAD_GRAYSCALE`：读入灰度图片
    - `cv2.IMREAD_UNCHANGED`：顾名思义，读入完整图片，包括 alpha 通道

***cv2.imshow(wname,img)***   

- 显示图像

- *wname*：显示图像的窗口的名字
- *img*：要显示的图像（imread 读入的图像），窗口大小自动调整为图片大小

