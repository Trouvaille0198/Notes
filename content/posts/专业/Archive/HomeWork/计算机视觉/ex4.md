---
title: "《计算机视觉》实验四报告"
date: 2022-03-31
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验四报告

姓名：孙天野

学号：19120198

## 任务一

用 PCA+KNN 算法实现人脸识别

1. 数据集自选；
2. 详细说明实验参数，包括参与训练和测试的图片数量，分类个数，降维维度，knn 参数等，总结各参数对准确率的影响，不断提高准确率。

### 实现细节

本实验采用 ORL 人脸数据集进行训练。共 400 份样本。数据文件的存储方式是一个人占有一个子文件夹，所以在读取图片时需要注意根据此规律标注人脸标签。

在进行分类训练前。还需要对图片进行统一的预处理，比如转换为灰度图、直方图均衡化、裁剪大小、将图片矩阵转换为一维矩阵等操作。（虽然 ORL 数据已经预先统一了图片大小与直方图均衡的步骤）

需要调整测试的参数主要有两项：PCA 降维保留数据方差的百分比和 KNN 分类中 `n_neighbors` 的个数。

### 核心代码

```python
from tkinter import X
import cv2
import numpy as np
import os
from sklearn import neighbors
from typing import Optional, Tuple, List, Union
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.decomposition import PCA
import random

IMG_PATH: str = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\ORL"


def loadimages(
        path: str = IMG_PATH) -> Tuple[np.ndarray, np.ndarray, List[str]]:
    '''
    return images: 照片列表
    return name: 子文件夹名 可以代表人名
    return label: 标签 从0开始
    '''

    images, labels, names = [], [], []
    # 读取照片所在的所有文件夹
    label = 0
    for subdir_name in os.listdir(path):
        # subdir_name 子文件夹的名字
        sub_path = os.path.join(path, subdir_name)
        if os.path.isdir(sub_path):
            # sub_path里包含同一个人的照片
            names.append(subdir_name)
            for file_name in os.listdir(sub_path):
                img_path = os.path.join(sub_path, file_name)
                img = cv2.imread(img_path, 0)  # 读取灰度图
                images.append(img)
                labels.append(label)
            label += 1  # 下一人
    return np.asarray(images), np.asarray(labels), names


class FaceRecognizer:
    def __init__(self, images: np.ndarray, labels: np.ndarray, dsize=(92, 112), n_components: Union[int, float] = 0.5):
        self.x = images
        self.y = labels
        self.dsize = dsize

        self.estimator_knn = neighbors.KNeighborsClassifier()
        self.transfer_pca = PCA(n_components=n_components)
        self.best_param = dict()

    def preprocess(self, images: np.ndarray) -> np.ndarray:
        """
        图片预处理 统一大小 直方图均衡化 将图片变为一行
        """
        new_images = []
        for image in images:
            # 调整大小
            resized_img = cv2.resize(image, self.dsize)
            # 直方图均衡化
            hist_img = cv2.equalizeHist(resized_img)
            # 转为一行
            hist_img = np.reshape(hist_img, (1, -1))
            new_images.append(hist_img[0])
        new_images = np.asarray(new_images)  # 列表变为数组

        return new_images

    def fit(self):
        """
        训练
        """
        # 划分数据集
        x_train, x_test, y_train, y_test = train_test_split(self.preprocess(self.x), self.y, random_state=233)
        # PCA
        x_train = self.transfer_pca.fit_transform(x_train)
        x_test = self.transfer_pca.transform(x_test)

        # 标准化
        # transfer_std = StandardScaler()
        # x_train = transfer_std.fit_transform(x_train)
        # x_test = transfer_std.transform(x_test)

        # 调优
        param_dict = {"n_neighbors": [i for i in range(1, 20)]}
        self.estimator_knn = GridSearchCV(
            self.estimator_knn, param_grid=param_dict)

        # 训练模型
        self.estimator_knn.fit(x_train, y_train)
        y_pred = self.estimator_knn.predict(x_test)

        # print("准确率为：\n", self.estimator_knn.score(x_test, y_test))
        print("最佳准确率为：\n", self.estimator_knn.best_score_)
        print("最佳超参数为：\n", self.estimator_knn.best_params_)
        print("最佳估计器:\n", self.estimator_knn.best_estimator_)

    def predict(self, img: np.ndarray, label: int):
        """
        预测
        """
        x_test = self.transfer_pca.transform(self.preprocess([img]))
        y_pred = self.estimator_knn.predict(x_test, **self.best_param)
        print("真实: {}, 预测: {}".format(label, y_pred), end='\t')
        if y_pred == label:
            print("识别成功")
        else:
            print("识别失败")


if __name__ == '__main__':
    x_train, y_train, names = loadimages()
    # print(x_train, y_train, names)
    face_recognizer = FaceRecognizer(x_train, y_train)
    face_recognizer.fit()

    for _ in range(len(x_train)//10):
        i = random.randint(0, len(x_train)-1)
        face_recognizer.predict(x_train[i], y_train[i])
```

### 实验结果截图

经过超参数调优，取 `n_neighbors` 从 0 到 20，取 PCA 降维去除 70% 维度进行训练，获得的最佳参数和最佳准确率：

![image-20220331094554831](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220331094554831.png)

发现 `n_neighbors` 为 1 时，估计器的准确度是最高的。但是 `k=1` 往往会发生过拟合的现象，故取  `n_neighbors` 从 5 到 20 进行训练：

![image-20220331095338839](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220331095338839.png)

发现准确率有所下降，但是可以避免过拟合问题。

随机抽取若干的样本进行测试

![image-20220331095405706](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220331095405706.png)

PCA 降维的力度对最终结果的准确率影响也很大。实验发现，降维在 50% 到 80% 的范围内的准确率较高；

| 维度保留的百分比 | 最终准确率 |
| ---------------- | ---------- |
| 10%              | 21%        |
| 20%              | 40%        |
| 30%              | 58%        |
| 40%              | 79%        |
| 50%              | 87%        |
| 60%              | 89%        |
| 70%              | 93%        |
| 80%              | 94%        |
| 90%              | 94%        |

可以看到，40% 之前的维度数和准确率呈线性关系。

### 小结

这次实验是运用机器学习的方法实现人脸识别。我使用了 `sklearn` 机器学习库来构建训练程序。

