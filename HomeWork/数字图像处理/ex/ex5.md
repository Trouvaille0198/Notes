# 实验五

## 问题描述

编写程序，对图像的分割区域进行标记，并提取标记区域特征．

## 实验分析

图像的分割算法可以参考实验四的阈值分割来完成

### 连通域标记算法

要对图像进行区域标记，常用的方法是连通域标记算法，其又分为四邻域标记算法与八邻域标记算法

 **四邻域标记算法**

1. 判断此点四邻域中的最左，最上有没有点，如果都没有点，则表示一个新的区域的开始。
2. 如果此点四邻域中的最左有点，最上没有点，则标记此点为最左点的值；如果此点四邻域中的最左没有点，最上有点，则标记此点为最上点的值。
3. 如果此点四邻域中的最左有点，最上都有点，则标记此点为这两个中的最小的标记点，并修改大标记为小标记。

**八邻域标记算法**

1. 判断此点八邻域中的最左，左上，最上，上右点的情况。 如果都没有点，则表示一个新的区域的开始。
2. 如果此点八邻域中的最左有点，上右都有点，则标记此点为这两个中的最小的标记点，并修改大标记为小标记。
3. 如果此点八邻域中的左上有点，上右都有点，则标记此点为这两个中的最小的标记点，并修改大标记为小标记。
4. 否则按照最左，左上，最上，上右的顺序，标记此点为四个中的一个。

### 轮廓检测

除了连通域标记算法，直接对图像进行轮廓检测也是一种很好的思路，对于一个经过处理的二值图像（如阈值分割、Canny、拉普拉斯等边缘检测算子处理），容易用 `findContours` 得到其轮廓数据

***cv2.findContours(image, mode, method[, contours[, hierarchy[, offset ]]])***

**参数**

- *image*：目标图像

- *mode*：轮廓的检索模式
    - cv2.RETR_EXTERNAL 表示只检测外轮廓
    - cv2.RETR_LIST 检测的轮廓不建立等级关系
    - cv2.RETR_CCOMP 建立两个等级的轮廓，上面的一层为外边界，里面的一层为内孔的边界信息。如果内孔内还有一个连通物体，这个物体的边界也在顶层。
    - cv2.RETR_TREE 建立一个等级树结构的轮廓。

- *method*：轮廓的近似办法
    - cv2.CHAIN_APPROX_NONE：存储所有的轮廓点，相邻的两个点的像素位置差不超过 1，即 `max(abs(x1-x2), abs(y2-y1)) == 1`
    - cv2.CHAIN_APPROX_SIMPLE：压缩水平方向，垂直方向，对角线方向的元素，只保留该方向的终点坐标，例如一个矩形轮廓只需4个点来保存轮廓信息
    - cv2.CHAIN_APPROX_TC89_L1，CV_CHAIN_APPROX_TC89_KCOS 使用 teh-Chinl chain 近似算法

**返回值**

函数返回两个值，一个是轮廓本身，还有一个是每条轮廓对应的属性。

### 区域特征提取

**SIFT** (Scale-Invariant Feature Transform) 是最成功的图像局部描述子之一。SIFT 特征包括兴趣点检测器和描述子，其中 SIFT 描述子具有非常强的稳健性，这在很大程度上也是 SIFT 特征能够成功和流行的主要原因。SIFT特征对于尺度、旋转、亮度都具有不变性。

可以用 sift 算法找出图像的角点分布

## 实现

### 连通域标记

使用四邻域标记算法标记区域，并且区域用不同颜色划分开来

#### 代码

```python
import cv2
import numpy as np
import matplotlib.pyplot as plt

# Read image
img = cv2.imread(r'D:\Repo\PythonLearning\cv2Learning\assets\seg.png').astype(np.float32)
height, weight, color = img.shape

label = np.zeros((height, weight), dtype=np.int)
label[img[..., 0] > 0] = 1

LUT = [0 for _ in range(height*weight)]

n = 1

for y in range(height):
    for x in range(weight):
        if label[y, x] == 0:
            continue
        c3 = label[max(y-1, 0), x]
        c5 = label[y, max(x-1, 0)]
        if c3 < 2 and c5 < 2:
            n += 1
            label[y, x] = n
        else:
            _vs = [c3, c5]
            vs = [a for a in _vs if a > 1]
            v = min(vs)
            label[y, x] = v

            minv = v
            for _v in vs:
                if LUT[_v] != 0:
                    minv = min(minv, LUT[_v])
            for _v in vs:
                LUT[_v] = minv

count = 1

for l in range(2, n+1):
    flag = True
    for i in range(n+1):
        if LUT[i] == l:
            if flag:
                count += 1
                flag = False
            LUT[i] = count

COLORS = [[0, 0, 255], [0, 255, 0], [255, 0, 0], [255, 255, 0]]
out = np.zeros((height, weight, color), dtype=np.uint8)

for i, lut in enumerate(LUT[2:]):
    out[label == (i+2)] = COLORS[(lut-2) % 4]

# Save result
cv2.imwrite("out.png", out)
cv2.imshow("result", out)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

#### 示例



<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103162100826.png" alt="image-20211103162100826" style="zoom:50%;" />

![image-20211103162219307](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103162219307.png)

### 轮廓检测

#### 代码

思路

- 查出地图上湖水的 RGB 值，根据这个值来对整个图像进行阈值分割
- 调用 `findContours` 找出湖泊轮廓
- 调用 `drawContours` 绘制轮廓线

```python
import cv2
import numpy as np

img = cv2.imread(r'D:\Repo\PythonLearning\cv2Learning\assets\map.png')
lake_BGR = np.array([224, 182, 156])
mask_img = cv2.inRange(img, lake_BGR-10, lake_BGR+10)

# ret, binary = cv2.threshold(img, 127, 255, 0)  # 阈值处理
contours, hierarchy = cv2.findContours(
    mask_img.copy(),
    cv2.RETR_EXTERNAL,
    cv2.CHAIN_APPROX_SIMPLE)  # 查找检测物体的轮廓，只检测最外轮廓


all_lakes_img = img
cv2.drawContours(
    all_lakes_img, contours, -1, (0, 0, 255), 3)  # 绘制轮廓


cv2.imshow("final", all_lakes_img)
if cv2.waitKey() == ord('q'):
    cv2.destroyAllWindows()
```

#### 示例

使用红线将江河的轮廓标记了出来

![image-20211103162251046](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103162251046.png)

### 区域特征提取

#### 代码

```python
# SIFT 算法提取图像特征
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

#### 示例

原图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103162419611.png" alt="image-20211103162419611" style="zoom: 33%;" />

找出图像的角点分布

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211103173940638.png" alt="image-20211103173940638" style="zoom: 25%;" />
