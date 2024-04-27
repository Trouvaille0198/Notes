---
title: "《计算机视觉》实验六报告"
date: 2022-05-09
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验六报告

姓名：孙天野

学号：19120198

## 任务一

1. 自选数据集，使用 hog + svm 实现行人检测
2. svm 参数调优，提高分类准确率
3. 画出 roc 曲线

### 核心代码

图片读取

```python
def load_data():
    """
    读取样本图片 返回HOG特征向量训练集
    return: HOG列表, label列表
    """
    pos_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\walkman_img\train\pos"
    neg_path = r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\walkman_img\train\neg"
    pos_imgs = os.listdir(pos_path)
    neg_imgs = os.listdir(neg_path)

    data_set = []
    label = []
    # 读取正样本
    for i in range(len(pos_imgs)):
        path = pos_path + '\\' + pos_imgs[i]
        img = cv2.imread(path, 0)  # 灰度图
        hog_vector, _ = hog(img, orientations=9, pixels_per_cell=(8, 8), cells_per_block=(8, 8),
                            block_norm='L2-Hys', visualize=True)
        data_set.append(hog_vector)
        label.append(1)

    # 读取负样本
    for i in range(len(neg_imgs)):
        path = neg_path + '\\' + neg_imgs[i]
        img = cv2.imread(path, 0)
        hog_vector, _ = hog(img, orientations=9, pixels_per_cell=(8, 8), cells_per_block=(8, 8),
                            block_norm='L2-Hys', visualize=True)
        data_set.append(hog_vector)
        label.append(-1)

    return data_set, label
```

训练、保存模型并且绘制 ROC 曲线图

```python
def train():
    """
    训练样本
    """
    data_set, label = load_data()
    x_train, x_test, y_train, y_test = train_test_split(data_set, label, random_state=452)
    clf = SVC(gamma=0.05).fit(x_train, y_train)  # SVM

    joblib.dump(clf, r"D:\Repo\PythonLearning\ComputerVisionLearning\assets\clf.pkl")  # 保存模型

    y_pred = clf.predict(x_test)
    count = 0
    for x in range(len(y_pred)):
        if y_pred[x] == y_test[x]:
            count += 1
    print(count / len(y_pred))
    # 绘制ROC图
    fpr, tpr, thresholds = roc_curve(y_test, clf.decision_function(x_test))
    plt.plot(fpr, tpr, label='ROC')
    plt.xlabel('FPR')
    plt.ylabel('TPR')
    plt.show()
```

### 实验结果截图

测试样例

![image-20220509220054016](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220509220054016.png)

ROC 曲线图<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220509215502856.png" alt="image-20220509215502856" style="zoom:67%;" />

### 小结

本次实验主要体验了使用 hog + svm 实现行人检测的算法。我主要使用了 `sikit-image` 库中的 HOG 特征提取函数和 `sklearn` 库中封装的 SVC 算法完成训练的功能。在训练过程中，我也遇到了训练样本过拟合，导致测试结果不甚理想的情况，也通过调参和优筛选数据库进行了适当的优化。