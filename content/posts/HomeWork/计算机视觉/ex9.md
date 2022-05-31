# 《计算机视觉》实验九报告

姓名：孙天野

学号：19120198

## 任务

采用基于背景建模的方法实现运动目标检测，建模方法自选

算法步骤：

1. 读取视频（逐帧读取）
2. 累加权重重构背景（中值/均值建模），可选其他建模方法
3. 计算象素差，即每一帧图像与背景模板的差值
4. 图像去噪：中值滤波、均值滤波、形态学变换（腐蚀、膨胀）
5. 画出候选框，可用 `cv2.findContours()` 函数
6. 通过非极大值抑制筛选去除多余候选框
7. 输出检测结果

检测结果以视频形式呈现，需要一并上传

### 核心代码

```python
import cv2


# 逐帧读取视频
cap = cv2.VideoCapture(r'D:\Repo\PythonLearning\ComputerVisionLearning\assets\test.avi')
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))  # 宽度
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))  # 高度
fps = cap.get(cv2.CAP_PROP_FPS)  # 帧率
fourcc = int(cap.get(cv2.CAP_PROP_FOURCC))  # 编码
# 录制视频
video = cv2.VideoWriter('file.mp4', fourcc=cv2.VideoWriter_fourcc(*'mp4v'), fps=fps, frameSize=(width, height))

# 初始化形态学需要的卷积核
kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
# 高斯混合模型建模
model = cv2.createBackgroundSubtractorMOG2()

while (True):
    ret, frame = cap.read()  # 读取一帧
    mask = model.apply(frame)
    if mask is None:
        break
    # 使用形态学开运算去噪 对白点进行腐蚀
    mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    # 绘制候选框
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    # 去除多余候选框
    for c in contours:
        # 计算轮廓周长
        perimeter = cv2.arcLength(c, True)
        if perimeter > 188:
            # 找到直矩形 (不会旋转)
            x, y, w, h = cv2.boundingRect(c)
            # 绘制矩形
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
    video.write(frame)
    # 播放一帧
    cv2.imshow('frame', frame)
    cv2.imshow('fgmask', mask)
    # 延长放映时间
    k = cv2.waitKey(50) & 0xff
    if k == 27:
        break
cap.release()
video.release()
cv2.destroyAllWindows()
```

### 实验结果截图

![image-20220526180400086](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220526180400086.png)

![image-20220526180405999](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220526180405999.png)

### 小结

本实验我基于高斯混合模型背景建模的方法完成了运动目标检测的目标，使用形态学中的开运算达成了去噪点的目的，删除了多余的候选框，最后绘制出目标框直观地展示了运动目标。