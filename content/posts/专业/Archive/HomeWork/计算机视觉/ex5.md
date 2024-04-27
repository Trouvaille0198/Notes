---
title: "《计算机视觉》实验五报告"
date: 2022-05-09
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验五报告

姓名：孙天野

学号：19120198

## 任务

1. 基于 haar 特征和 adaboost 算法实现人脸检测器；
2. 自选数据集进行测试，给出数据集名称及检测结果截图（最少 5 张）；

### 核心代码

```python
import cv2
import numpy as np

face_cascade = cv2.CascadeClassifier(r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\haarcascade_frontalface_alt.xml")


def face_detection(img_path):
    """
    人脸检测
    """
    colored_img = cv2.imread(img_path)

    img = cv2.imread(img_path, 0)

    # 直方图均衡
    img = cv2.equalizeHist(img)
    size = colored_img.shape[:2]
    face_rects = face_cascade.detectMultiScale(img, 1.10, 2, cv2.CASCADE_SCALE_IMAGE, (size[1] // 10, size[0] // 10))

    for face_rect in face_rects:
        x, y, w, h = face_rect
        cv2.rectangle(colored_img, (x, y), (x + w, y + h), [0, 255, 0], 2)

    cv2.imshow('img', colored_img)
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()
```

### 实验结果截图

![image-20220509222919191](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220509222919191.png)

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220509224120846.png" alt="image-20220509224120846" style="zoom: 50%;" />

![image-20220509223342332](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220509223342332.png)

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220509224441876.png" alt="image-20220509224441876" style="zoom: 33%;" />

### 小结

本次实验我主要完成了基于 haar 特征和 adaboost 算法实现人脸检测器的编写。AdaBoost 通过多个弱分类器的增强学习集合成一个强分类器的思想非常奇妙，而且不会出现很强的过拟合现象，速度也比较快。我使用了 openCV 中自带的 AdaBoost 联级分类器，默认采用了 Haar 特征。