---
title: "Seaborn"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Python, 数据分析]
categories: [Python]
---

# Seaborn

## 基本知识

### 概念

seaborn 是基于 matplotlib 的图形可视化 python 包。它提供了一种高度交互式界面，便于用户能够做出各种有吸引力的统计图表。

Seaborn 是在 matplotlib 的基础上进行了更高级的 API 封装，从而使得作图更加容易，在大多数情况下使用 seaborn 能做出很具有吸引力的图，而使用 matplotlib 就能制作具有更多特色的图。应该把 Seaborn 视为 matplotlib 的补充，而不是替代物。同时它能高度兼容 numpy 与 pandas 数据结构以及 scipy 与 statsmodels 等统计模式

```python
import seaborn as sns
```

### 层级 API

Seaborn 中的 API 分为 Figure-level 和 Axes-level 两种

Axes-level 的函数可以实现与 Matplotlib 更灵活和紧密的结合，而 Figure-level 则更像是「懒人函数」，适合于快速应用

### 声明样式

```python
sns.set()
```

#### 参数

- *context*
  - 控制着默认的画幅大小，分别有 `{paper, notebook, talk, poster}` 四个值。
  - 其中，`poster > talk > notebook > paper`。
- *style*
  - 控制默认样式，分别有 `{darkgrid, whitegrid, dark, white, ticks}`
- *palette*
  - 预设的调色板。分别有 `{deep, muted, bright, pastel, dark, colorblind}` 等
- *font*
  - 用于设置字体
  - *font_scale* ：设置字体大小
  - *color_codes*： 不使用调色板而采用先前的 `'r'` 等色彩缩写。

默认参数

```python
sns.set(context='notebook', style='darkgrid', palette='deep', font='sans-serif', font_scale=1, color_codes=False, rc=None)
```

### 通用参数

**sns.图名(x='X轴 列名', y='Y轴 列名', data=原始数据df对象)**

**sns.图名(x=np.array, y=np.array[, ...])**

数据必须以长格式的 DataFrame 传入，同时变量通过`x`, `y`及其他参数指定。

- *x, y*：*data* 中的变量名
- *data*：长格式的 DataFrame，每列是一个变量，每行是一个观察值。
- *hue*： *data* 中的名称，可选
  - 将会产生具有不同颜色的元素的变量进行分组
  - *palette*：色盘名，列表，或者字典，可选
    - 用于 *hue* 变量的不同级别的颜色
- *size*：*data* 中的名称，可选
  - 将会产生具有不同尺寸的元素的变量进行分组
- *style*：*data*中的名称，可选
  - 将会产生具有不同风格的元素的变量进行分组
- *row*, *col*：*data* 中的变量名，可选
  - 确定网格的分面的类别变量
  - *col_wrap*：int，可选
    - 以此宽度“包裹”列变量，以便列分面跨越多行。与 *row* 分面不兼容
- color：控制颜色
- bins：条形图的条数
- palette：颜色列表

### 保存

```python
ax = sns.distplot(x) # 画图

# fig = ax.get_figure() # 获取图片

fig.savefig(path, dpi = 400) # 保存图片
```

## 关联图

（Relational plots）

关联图用于呈现数据之间的关系，主要有散点图和条形图 2 种样式

两个连续型变量之间的关系

| 关联性分析  |       介绍       |
| :---------: | :--------------: |
|   relplot   |    绘制关系图    |
| scatterplot | 多维度分析散点图 |
|  lineplot   | 多维度分析线形图 |

### 函数

```python
seaborn.relplot(kind='scatter')
```

*kind* 参数选择要使用的基础轴级函数：

- 散点图
  - *scatterplot()*：通过 `kind="scatter"` 访问；默认为此
- 折线图
  - *lineplot()*：通过 `kind="line"` 访问

### 例

以鸢尾花数据集为例

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122121854899.png" alt="image-20210122121854899" style="zoom:67%;" />

```python
sns.relplot(x='sepal_length',y='sepal_width',data=iris,hue='species') # 默认散点图

sns.relplot(kind='line',x='sepal_length',y='sepal_width',data=iris,hue='species') # 折线图
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122151004252.png" alt="image-20210122151004252" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122151011958.png" alt="image-20210122151011958" style="zoom:67%;" />

## 类别图

（categorical plots）

类别图呈现单个数据与类别之间的关系

针对一个离散型变量与一个连续型变量之间的关系

### 函数

```python
seaborn.catplot( kind='strip')
```

类别图的 Figure-level 接口是 `catplot`。而 `catplot` 实际上是如下 Axes-level 绘图 API 的集合：

- 分类散点图
  - *stripplot()*：(`kind="strip"`)
  - *swarmplot()*：(`kind="swarm"`)
- 分类分布图
  - *boxplot()*：(`kind="box"`)
  - *boxenplot()*：(`kind="boxen"`)
  - *violinplot()* (`kind="violin"`)
- 分类估计图
  - *pointplot()*： (`kind="point"`)
  - *barplot()*：(`kind="bar"`)
  - *countplot()*：(`kind="count"`)

### 参数说明

1. `hue=` 参数可以给图像引入另一个维度。如果一个数据集有多个类别，`hue=` 参数就可以让数据点有更好的区分
2. 计数条形图只传入一个分类参数
3.  *jitter*：表示抖动的程度(仅沿类別轴)。当很多数据点重叠时，可以指定抖动的数量或者设为True使用默认值。

### 例

#### 散点图

```python
sns.catplot(x="sepal_length", y="species", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122151541023.png" alt="image-20210122151541023" style="zoom:67%;" />

`kind="swarm"` 可以让散点按照 beeswarm 的方式防止重叠，可以更好地观测数据分布

```python
sns.catplot(x="sepal_length", y="species", kind="swarm", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122151628884.png" alt="image-20210122151628884" style="zoom:67%;" />

#### 分布图

##### 箱线图

```python
sns.catplot(x="sepal_length", y="species", kind="box", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122151848523.png" alt="image-20210122151848523" style="zoom:67%;" />

##### 增强箱线图

```python
sns.catplot(x="sepal_length", y="species", kind="boxen", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122151907621.png" alt="image-20210122151907621" style="zoom:67%;" />

##### 小提琴图

```python
sns.catplot(x="sepal_length", y="species", kind="violin", data=iris)
```

![image-20210122152044634](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122152044634.png)



#### 估计图

##### 点线图

````python
sns.catplot(x="sepal_length", y="species", kind="point", data=iris)
````

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122152518957.png" alt="image-20210122152518957" style="zoom:67%;" />

##### 条形图

```python
sns.catplot(x="sepal_length", y="species", kind="bar", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122152541817.png" alt="image-20210122152541817" style="zoom:67%;" />

##### 计数条形图

只传入一个分类参数

```python
sns.catplot(x="species", kind="count", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122152611043.png" alt="image-20210122152611043" style="zoom:67%;" />

## 分布图

（Distribution plots）

分布图主要是用于可视化变量的分布情况，一般分为单变量分布和多变量分布。当然这里的多变量多指二元变量，更多的变量无法绘制出直观的可视化图形

### displot() 单变量分布

```python
sns.displot(x, kind=hist, data)
```

该方法将会绘制直方图，拟合核密度估计图，或二者兼有

该方法主要做单变量分布，但同样可以传入 *y* 参数

可以引入 *hue* 进行分类

- 直方图
  - *histplot()*：通过 `kind='hist'` 访问
- 核密度估计图
  - *kdeplot()*：通过 `kind='kde'` 访问

#### 参数说明

*bins*：用于控制条形的数量。

*kdeplot* 中：

- *multiple*：{“layer”, “stack”, “fill”}
  - Method for drawing multiple elements when semantic mapping creates subsets. Only relevant with univariate data

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122170112089.png" alt="image-20210122170112089" style="zoom:67%;" />

#### 例

```python
sns.displot(x=iris["sepal_length"],kind='kde',data=iris) # 核密度估计图
sns.displot(x=iris["sepal_length"],kind='hist',data=iris,hue='species') # 直方图
sns.displot(x=iris["sepal_length"],kde=True,data=iris) # 直方图加核密度估计图
sns.displot(x=iris["sepal_length"],kind='kde',hue='species',data=iris) # 分类的核密度估计图
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122170404372.png" alt="image-20210122170404372" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122170410738.png" alt="image-20210122170410738" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122170416675.png" alt="image-20210122170416675" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122170422635.png" alt="image-20210122170422635" style="zoom:67%;" />

### jointplot() 双变量分布

```python
sns.jointplot(x, y, data)
```

该方法绘制二元变量之间的关系，它并不是一个 Figure-level 接口，但其支持 `kind=` 参数指定绘制出不同样式的分布图，默认为 scatter

- *kind*：{‘scatter’, ‘kde’, ‘hist’, ‘reg’,’hex’}

例

```python
sns.jointplot(x="sepal_length", y="sepal_width", data=iris,hue="species") 	# 散点对比图
sns.jointplot(x="sepal_length", y="sepal_width", data=iris, kind="kde",hue="species")  	# 核密度估计对比图
sns.jointplot(x="sepal_length", y="sepal_width", data=iris, kind="hex")	 	# 六边形计数图
sns.jointplot(x="sepal_length", y="sepal_width", data=iris, kind="reg")  	# 回归拟合图
sns.jointplot(x="sepal_length", y="sepal_width", data=iris, kind="hist",hue="species") 	# 直方对比图
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122155633769.png" alt="image-20210122155633769" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122155756830.png" alt="image-20210122155756830" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122155050779.png" alt="image-20210122155050779" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122155058342.png" alt="image-20210122155058342" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122155729225.png" alt="image-20210122155729225" style="zoom:67%;" />

### pairplot() 两两对比分布

```python
sns.pairplot(data)
```

该方法支持一次性将数据集中的特征变量两两对比绘图。默认情况下，对角线上是单变量分布图，而其他则是二元变量分布图

例

```python
sns.pairplot(iris,hue="species")
```

![image-20210122155340104](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122155340104.png)

## 回归图

（Regression plots）

### regplot 线性回归

```python
sns.regplot(x, y, data)
```

使用该方法绘制回归图时，只需要指定自变量和因变量即可，它会自动完成线性回归拟合

无`hue`参数



例

```python
sns.regplot(x="petal_length", y="petal_width", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122160432232.png" alt="image-20210122160432232" style="zoom:67%;" />

### lmplot 分类回归

```python
sns.lmplot(x, y, hue, data)
```

该方法支持引入第三维度进行对比，也就是可以用`hue`参数



例

```python
sns.lmplot(x="sepal_length", y="sepal_width", hue="species", data=iris)
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122160656660.png" alt="image-20210122160656660" style="zoom:67%;" />

## 矩阵图

（Matrix plots）

### heatmap() 热力图

```python
sns.heatmap(data)
```

必须传入二维数组类型的 *data*



例

```python
sns.heatmap(np.random.rand(10, 10))
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122161503663.png" alt="image-20210122161503663" style="zoom: 80%;" />

### clustermap() 分层聚类热图

```python
seaborn.clustermap(data)
```

*data*：2D array-like



例

```python
iris.pop("species")

sns.clustermap(iris)
```



<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210122161932756.png" alt="image-20210122161932756" style="zoom:67%;" />

## 技巧

1. 设置颜色

```python

```

