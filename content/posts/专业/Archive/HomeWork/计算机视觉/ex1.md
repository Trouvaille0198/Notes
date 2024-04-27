---
title: "《计算机视觉》实验一报告"
date: 2022-03-09
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验一报告

姓名：孙天野

学号：19120198

## 任务一

1. 读取一张图片并显示；

2. 在图片中加入文字（学号+姓名）；
3. 保存该图片到本地。

### 核心代码

```python
import cv2
import numpy as np


def read_img(path: str) -> np.ndarray:
    """
    读取图片
    """
    img = cv2.imread(path)
    return img


def show_img(img: np.ndarray):
    """
    显示图片
    """
    cv2.imshow('img', img)
    if cv2.waitKey() == ord('q'):
        # 按q退出
        cv2.destroyAllWindows()


def save_img(img: np.ndarray, path: str):
    """
    保存图片
    """
    cv2.imwrite(path, img)


def add_text(text: str, img: np.ndarray) -> np.ndarray:
    """
    为图片添加文字
    """
    font = cv2.FONT_HERSHEY_SIMPLEX # 设置字体
    img_word = cv2.putText(img, text, (50, 300), font, 1.2, (255, 255, 255), 2)
    return img_word

if __name__ == '__main__':
    img_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka.png"
    ori_img = read_img(img_path)
    show_img(ori_img)
    save_img(ori_img, r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka_ori.png")
    text_img = add_text('19120198-SunTianye', ori_img)
    show_img(text_img)
    save_img(text_img, r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\Asuka_text.png")
```

### 实验结果截图

展示原图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220309085450915.png" alt="image-20220309085450915" style="zoom:67%;" />

展示添加文字后的图片

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220309085458621.png" alt="image-20220309085458621" style="zoom:67%;" />

保存图片

![image-20220309085528850](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220309085528850.png)

### 小结

使用 `cv2` 库实现图片的读取、展示和保存，发现图片在程序内的存在形式为像素矩阵图，具有图像三通道颜色空间。

## 任务二

1. 读取一段本地视频（Waymo.mp4）并播放

### 核心代码

```python
import cv2
import numpy as np

def read_video(path: str) -> np.ndarray:
    """
    读取视频
    """
    video = cv2.VideoCapture(path)
    return video


def play_video(video: np.ndarray):
    """
    播放视频
    """
    while True:
        ret, frame = video.read()
        cv2.imshow('video', frame) # 逐帧播放
        if cv2.waitKey(1) == ord('q'):
            break
    video.release()
    cv2.destroyAllWindows()


if __name__ == '__main__':
    video_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\waymo.mp4"
    video = read_video(video_path)
    play_video(video)
```

### 实验结果截图

![image-20220309085516605](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220309085516605.png)

### 小结

使用 `cv2` 库完成视频的读取和播放，发现视频在程序中的存在本质为一组像素矩阵（帧），包括保存视频在内的相关视频处理大多也是逐帧处理的

## 对计算机视觉的个人理解

计算机视觉的本质即模拟：运用摄像机、计算机等硬件设施与图像处理算法、机器学习等理论知识，达到模拟人眼识别、跟踪、测量图片与视频的目的。这是一门综合性的学科，不仅涉及了摄影摄像、计算机等工科技术，也涉及了数字图像处理与人工智能的范畴；而且应用领域也极其宽广，在医疗、工业、科技领域皆大放异彩。我有幸选修过《数字图像处理》课程，算是对计算机视觉的一部分有了浅显的理解和认识；数字图像处理更偏重于图像在计算机中存储形式的讨论、加强或削弱图像的某种特性（预处理）、从图像中提取出有用的统计特性或结构信息（特征抽取）这些部分，而计算机视觉又在其基础上，运用人工智能理论，让机器具有“识别”、“决策”的能力，是图像处理的拓展和加深。

