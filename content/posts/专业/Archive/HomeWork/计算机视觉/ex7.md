---
title: "《计算机视觉》实验七报告"
date: 2022-05-14
draft: true
author: "MelonCholi"
tags: []
categories: []
---

# 《计算机视觉》实验七报告

姓名：孙天野

学号：19120198

## 任务一

完成 SIFT 特征匹配，实现图片拼接，包括以下步骤

1. 输入两张同一场景不同视角拍摄的图片

2. 分别提取图片的 SIFT 特征

3. 关键点匹配

4. 采用 RANSAC 算法进行提纯

5. 获取两张图片的变换关系（单应性矩阵，可通过 4 对匹配点求出），完成拼接（选做加分）

以上步骤都需要给出实验结果图

### 核心代码

参考：https://blog.csdn.net/weixin_43823854/article/details/102803193

```python
# SIFT 算法提取图像特征
import cv2
import matplotlib.pyplot as plt
import numpy as np


def get_sift_feat(img, isShow=False):
    # 构造生成器
    sift = cv2.SIFT_create()
    # 检测图片
    kp, des = sift.detectAndCompute(img, None)  # 关键点（Keypoint）和描述子（Descriptor）
    if isShow:
        # 绘出关键点
        show_img(cv2.drawKeypoints(img, kp, None, (255, 0, 0), 4))
    return kp, des


def get_matches(des1, des2, way: str = 'flann'):
    """
    获取两组描述子的匹配
    """
    if way == "bf":
        bf = cv2.BFMatcher()
        matches: list = bf.knnMatch(des1, des2, k=2)

    if way == "flann":
        FLANN_INDEX_KDTREE = 0
        index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
        search_params = dict(checks=50)
        flann = cv2.FlannBasedMatcher(index_params, search_params)
        matches = flann.knnMatch(des1, des2, k=2)

    return matches


def show_match_img_with_RANSAC(matches, img1, img2, kp1, kp2, ratio: float = 0.9):
    good = []
    for m, n in matches:
        if m.distance < ratio * n.distance:
            good.append(m)

    if len(good) > 10:
        # 获取关键点坐标
        src_pts = np.float32([kp1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)  # queryIdx - 查询描述子里的描述子索引
        dst_pts = np.float32([kp2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)  # trainIdx - 训练描述子里的描述子索引

        # 利用 RANSAC 方法计算单应矩阵
        M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 5.0)  # M 为 3x3 变换矩阵
        print(M)
        # 将多维数组转换为一维数组
        matchesMask = mask.ravel().tolist()

        h, w = img1.shape[:2]
        # 使用得到的变换矩阵对原图像的四个变换获得在目标图像上的坐标
        pts = np.float32([[0, 0], [0, h-1], [w-1, h-1], [w-1, 0]]).reshape(-1, 1, 2)
        # 透视变换函数
        dst = cv2.perspectiveTransform(pts, M)
        # 绘制多边形
        img2 = cv2.polylines(img2, [np.int32(dst)], True, 255, 3, cv2.LINE_AA)
    else:
        print("匹配点不足！仅 {} 个".format((len(good))))
        matchesMask = None

    draw_params = {
        'matchColor': (0, 200, 0),  # 匹配线颜色
        'singlePointColor': None,
        'matchesMask': matchesMask,  # 只绘制正常数据
        'flags': 2
    }
    img = cv2.drawMatches(img1, kp1, img2, kp2, good, None, **draw_params)
    show_img(img)

    return good, M, mask


def show_combine_img(img1, img2, kp1, kp2, good, M, mask):
    # 图1视角变换
    result = cv2.warpPerspective(img1, M, (img1.shape[1] + img2.shape[1], img1.shape[0]))
    # 图2填充左端最左端
    result[0:img1.shape[0], 0:img1.shape[1]] = img1
    show_img(result)


def show_match_img(matches, img1, img2, kp1, kp2, ratio: float = 0.7):
    good = []
    for m, n in matches:
        # m 最近邻, n 次近邻
        if m.distance < ratio * n.distance:
            good.append([m])

    img = cv2.drawMatchesKnn(img1, kp1, img2, kp2, good, None, flags=2)
    show_img(img)


def show_img(img):
    """
    展示图片
    """
    plt.figure(figsize=(10, 10))  # 画布放大10倍
    plt.axis('off')  # 隐藏坐标轴
    plt.imshow(img)  # 打印图像
    plt.show()  # 显示画布

    if cv2.waitKey() == ord('q'):
        cv2.destroyAllWindows()


if __name__ == '__main__':
    img_path1 = r'D:\Repo\PythonLearning\ComputerVisionLearning\assets\sift\2.jpg'
    img_path2 = r'D:\Repo\PythonLearning\ComputerVisionLearning\assets\sift\1.jpg'
    img1 = cv2.imread(img_path1, 0)
    img2 = cv2.imread(img_path2, 0)

    kp1, des1 = get_sift_feat(img1)
    kp2, des2 = get_sift_feat(img2)
    matches = get_matches(des1, des2)
    # show_match_img(matches, img1, img2, kp1, kp2)

    good, M, mask = show_match_img_with_RANSAC(matches, img1, img2, kp1, kp2)
    ori_img1 = cv2.imread(img_path1)
    ori_img2 = cv2.imread(img_path2)
    show_combine_img(ori_img1, ori_img2, kp1, kp2, good, M, mask)

```

### 实验结果截图

关键点展示

![image-20220514185145625](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514185145625.png)

![image-20220514185205756](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514185205756.png)

关键点匹配

![image-20220514185250530](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514185250530.png)

单适应矩阵

![image-20220514185439306](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514185439306.png)

优化后的匹配图

![image-20220514185426707](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514185426707.png)

拼接结果

![image-20220514192938030](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514192938030.png)

### 小结

这次实验我使用 cv2 中的相关操作完成了 SIFT 特征匹配，并且实现了图片拼接的功能。这次试验难度较之前有所增加，关键点匹配、RANSAC 算法提纯等操作都比较复杂。我也是在同学和网络资源的帮助下完成了任务。经过这次事件，我获得了很多关于图像拼接方面的经验和知识，收获颇多。
