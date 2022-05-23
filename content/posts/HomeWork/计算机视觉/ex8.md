# 《计算机视觉》实验八报告

姓名：孙天野

学号：19120198

## 任务一

采用 SIFT 特征实现图像检索功能，即输入一张图片，在数据集中检索出相似的图片，数据集自选。

以下 2 问选做加分

1. 基于词袋模型实现

2. 检索结果按照相似度进行排序

### 核心代码

```python
import cv2
import numpy as np
import os
from sklearn.cluster import KMeans
from matplotlib import pyplot as plt

# ### 基于SIFT,BOW的图像检索
# #### 1、SIFT提取每幅图像的特征点
# #### 2、聚类获取视觉单词中心（聚类中心），构造视觉单词词典
# #### 3、将图像特征点映射到视觉单词上，得到图像特征
# #### 4、计算待检索图像的最近邻图像


def get_img_paths(target_img_path) -> list:
    """
    获取样本图片路径
    """
    file_dir = r'D:\Repo\PythonLearning\ComputerVisionLearning\assets\ex8'
    img_names = os.listdir(file_dir)

    img_paths = []
    for name in img_names:
        if os.path.join(file_dir, name) == target_img_path:
            continue
        img_path = os.path.join(file_dir, name)
        img_paths.append(img_path)
    return img_paths


def get_cluster_centers(img_paths, num_words=1000):
    '''
    获取聚类中心
    param img_paths: 图像路径
    num_words: 聚类中心数
    '''
    sift_det = cv2.SIFT_create()
    des_list = []  # 特征描述
    des_matrix = np.zeros((1, 128))

    for path in img_paths:
        img = cv2.imread(path)
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
        kp, des = sift_det.detectAndCompute(gray, None)
        if des is not None:
            des_matrix = np.row_stack((des_matrix, des))
        des_list.append(des)

    des_matrix = des_matrix[1:, :]   # sift 特征矩阵

    # 计算聚类中心  构造视觉单词词典
    kmeans = KMeans(n_clusters=num_words, random_state=233)
    kmeans.fit(des_matrix)
    centers = kmeans.cluster_centers_

    return centers, des_list


def des2feature(des, centers, num_words=1000,):
    """
    将特征描述转换为特征向量
    des: 一副图片的SIFT特征 
    num_words: 聚类中心数
    centers: 聚类中心坐标, num_words*128
    return: 特征向量 num_words*1
    """
    img_feature_vec = np.zeros((1, num_words), 'float32')
    for i in range(des.shape[0]):
        feature_k_rows = np.ones((num_words, 128), 'float32')
        feature = des[i]
        feature_k_rows = feature_k_rows*feature
        feature_k_rows = np.sum((feature_k_rows-centers)**2, 1)
        index = np.argmax(feature_k_rows)
        img_feature_vec[0][index] += 1
    return img_feature_vec


def get_all_features(des_list, num_words):
    """
    获取所有图片的特征向量
    """
    allvec = np.zeros((len(des_list), num_words), 'float32')
    for i in range(len(des_list)):
        if des_list[i] is not None:
            allvec[i] = des2feature(centers=centres, des=des_list[i], num_words=num_words)
    return allvec


def get_nearest_imgs(feature, img_feats, num=1):
    """
    找出最近似目标的图像
    param feature: 目标图像特征
    param img_feats: 数据集图像特征向量数组
    param num: 最相似个数
    return: 最相似的num个图像在数据集中的索引
    """
    features = np.ones((img_feats.shape[0], len(feature)), 'float32')
    features = features*feature
    dist = np.sum((features-img_feats)**2, 1)  # 计算欧式距离
    dist_index = np.argsort(dist)  # 排序
    return dist_index[:num]


def show_img(target_img_path, img_paths, index):
    """
    显示最相似的图片集合
    param target_img_path: 目标图片路径
    param img_paths: 数据集图片数组
    """
    paths = [img_paths[i] for i in index]
    plt.figure(figsize=(10, 20))
    plt.subplot(432), plt.imshow(plt.imread(target_img_path)), plt.title('target_img')

    for i in range(len(index)):
        plt.subplot(4, 3, i+4), plt.imshow(plt.imread(paths[i]))
    plt.show()
    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


def retrieval_img(img_path, img_features, centers, img_paths, num=3):
    """
    在数据集中检索图像
    param img_path: 目标图像
    param img_features: 数据集图像特征向量
    param centers: 聚类中心
    param img_paths: 数据集图片数组
    """
    img = cv2.imread(img_path)
    img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    sift = cv2.SIFT_create()
    kp, des = sift.detectAndCompute(img, None)
    # 获取目标图像的特征向量
    feature = des2feature(des=des, centers=centers, num_words=1000)
    sorted_index = get_nearest_imgs(feature, img_features, num)

    show_img(img_path,  img_paths, sorted_index)


if __name__ == '__main__':
    target_img_path = r'D:\Repo\PythonLearning\ComputerVisionLearning\assets\ex8\13.jfif'
    img_paths = get_img_paths(target_img_path)

    centres, des_list = get_cluster_centers(img_paths=img_paths, num_words=1000)
    img_features = get_all_features(des_list, 1000)
    retrieval_img(target_img_path, img_features, centres, img_paths)
```

### 实验结果截图

![image-20220520161051206](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220520161051206.png)

### 小结

本实验我提取了数据集图片的 SIFT 特征，采用 BOW 词袋法的思想，把每幅图片都描述成 SIFT 特征的无序集合，再使用 K-means 聚类算法将特征进行聚类，每个聚类中心被看作是词典中的一个视觉词汇(Visual Word)，这样图像上的特征都被映射到视觉词典上；统计每个聚类中心的出现次数，将图像描述为一个特征向量，建立索引，进行检索。