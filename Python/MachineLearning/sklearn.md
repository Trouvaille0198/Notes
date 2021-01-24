# 一、简介

# 二、特征工程

(Feature Engineering)

特征工程是使用专业背景知识和技巧处理数据**，**使得特征能在机器学习算法上发挥更好的作用的过程

## 2.1 数据集

*scikit-learn* 提供了一些标准数据集

```python
from sklearn import datasets
```

### 2.1.1 小规模 load_\*()

***datasets.load_\*()***

获取小规模数据集，数据包含在datasets里

```python
data1 = datasets.load_iris()
data2 = datasets.load_boston()
```

### 2.1.2 大规模 fetch_\*()

***datasets.fetch_\*(data_home, subset)***

获取大规模数据集，需要从网络上下载

- *data_home*：数据集下载的目录，默认是 ~/scikit_learn_data/
- *subset*：选择要加载的数据集。'train'或者'test'，'all'，可选

### 2.1.3 返回值

load 和 fetch 返回的数据类型为 *datasets.base.Bunch* (字典继承)

- *data*：特征数据数组，是二维 numpy.ndarray 数组
- *target：*标签数组，是 n_samples 的一维 numpy.ndarray 数组
- *DESCR*：数据描述
- *feature_names*：特征名,新闻数据，手写数字、回归数据集没有
- *target_names*：标签名

```python
from sklearn.datasets import load_iris
# 获取鸢尾花数据集
iris = load_iris()
print("鸢尾花数据集的返回值：\n", iris) # 将所有参数全部返回，返回值是一个继承自字典的Bench
print("鸢尾花的特征值:\n", iris.data)
print("鸢尾花的目标值：\n", iris.target)
print("鸢尾花特征的名字：\n", iris.feature_names)
print("鸢尾花目标值的名字：\n", iris.target_names)
print("鸢尾花的描述：\n", iris.DESCR)

# 同样可以写作诸如iris['data']的格式
```

输出

```pyhton
 鸢尾花的特征值:
 [[5.1 3.5 1.4 0.2]
 [4.9 3.  1.4 0.2]
 [4.7 3.2 1.3 0.2]
 [4.6 3.1 1.5 0.2]
 ...
 [6.3 2.5 5.  1.9]
 [6.5 3.  5.2 2. ]
 [6.2 3.4 5.4 2.3]
 [5.9 3.  5.1 1.8]]
    
 鸢尾花的目标值：
 [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2
 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 2 2]
 
 鸢尾花特征的名字：
 ['sepal length (cm)', 'sepal width (cm)', 'petal length (cm)', 'petal width (cm)']
 
 鸢尾花目标值的名字：
 ['setosa' 'versicolor' 'virginica']
 
 鸢尾花的描述：
 .. _iris_dataset:

Iris plants dataset
--------------------

**Data Set Characteristics:**

    :Number of Instances: 150 (50 in each of three classes)
 ...
   - Many, many more ...
```

## 2.2 数据集划分

```python
from sklearn.model_selection import train_test_split
```

***sklearn.model_selection.train_test_split( arrays, \*options )***

- x：数据集的特征值
- y：数据集的标签值
- test_size：测试集的大小，一般为float
- random_state：随机数种子,不同的种子会造成不同的随机采样结果。相同的种子采样结果相同。

返回：测试集特征值，测试集标签，训练集特征值，训练集标签（默认随机取）

```python
x_train, x_test, y_train, y_test = train_test_split(iris.data, iris.target, random_state=22)
```

## 2.3 特征抽取

（feature extraction）

将任意数据（如文本或图像）转换为可用于机器学习的数字特征

```python
import sklearn.feature_extraction
```

### 2.3.1 字典特征提取 DictVectorizer 

它是一个转换器，应用时需要进行实例化

#### 1）API

***sklearn.feature_extraction.DictVectorizer(sparse=True,…)***

- *DictVectorizer.fit_transform(X)*
  - X：字典或者包含字典的迭代器
  - 返回sparse矩阵或array数组
- *DictVectorizer.inverse_transform(X)*
  - X：array数组或者sparse矩阵 
  - 返回转换之前数据格式
- *DictVectorizer.get_feature_names()* 
  - 返回类别名称

#### 2）例

流程分析

- 实例化类DictVectorizer
- 调用fit_transform方法输入数据并转换（注意返回格式）

```python
from sklearn.feature_extraction import DictVectorizer

data = [{'city': '北京','temperature':100}, {'city': '上海','temperature':60}, {'city': '深圳','temperature':30}]

# 1、实例化一个转换器类
transfer = DictVectorizer(sparse=False)# 拒绝返回稀疏矩阵
# 2、调用fit_transform
data = transfer.fit_transform(data)

print("返回的结果:\n", data)
print("特征名字：\n", transfer.get_feature_names())
```

输出

```python
返回的结果:
[[  0.   1.   0. 100.]
 [  1.   0.   0.  60.]
 [  0.   0.   1.  30.]]
特征名字：
 ['city=上海', 'city=北京', 'city=深圳', 'temperature']
```

若返回稀疏矩阵，改sparse=True

```python
返回的结果:
(0, 1)	1.0
(0, 3)	100.0
(1, 0)	1.0
(1, 3)	60.0
(2, 2)	1.0
(2, 3)	30.0
特征名字：
 ['city=上海', 'city=北京', 'city=深圳', 'temperature']
```

这个处理数据的技巧叫做 *one-hot* 编码

### 2.3.2 文本词频特征提取 text.CountVectorizer

对文本数据进行词频特征值化

它是一个转换器，应用时需要进行实例化

#### 1）API

***sklearn.feature_extraction.text.CountVectorizer(stop_words=[])***

- CountVectorizer.fit_transform(X)
  -  X：文本或者包含文本字符串的可迭代对象
  - 返回sparse矩阵
- CountVectorizer.inverse_transform(X)
  -  X：array数组或者sparse矩阵 
  - 返回转换之前数据格
- CountVectorizer.get_feature_names() 
  - 返回值单词列表

#### 2）例

流程分析

- 实例化类CountVectorizer
- 调用fit_transform方法输入数据并转换 （注意返回格式，利用toarray()进行sparse矩阵转换array数组）

```python
from sklearn.feature_extraction.text import CountVectorizer

data = ["life is short,i like like python",
        "life is too long,i dislike python"]

# 1、实例化一个转换器类
transfer = CountVectorizer()
# 2、调用fit_transform
data = transfer.fit_transform(data)

print("文本特征抽取的结果：\n", data.toarray())
print("返回特征名字：\n", transfer.get_feature_names())
```

输出（因为没有 sparse 参数，若要转换成二维数组形式，需要利用toarray()）

```python
文本特征抽取的结果：
 [[0 1 1 2 0 1 1 0]
 [1 1 1 0 1 1 0 1]]
返回特征名字：
 ['dislike', 'is', 'life', 'like', 'long', 'python', 'short', 'too']
```

若直接返回稀疏矩阵

```python
文本特征抽取的结果：
(0, 2)	1
(0, 1)	1
(0, 6)	1
(0, 3)	2
(0, 5)	1
(1, 2)	1
(1, 1)	1
(1, 5)	1
(1, 7)	1
(1, 4)	1
(1, 0)	1
返回特征名字：
 ['dislike', 'is', 'life', 'like', 'long', 'python', 'short', 'too']
```

#### 3）中文处理

使用jieba分词库

***jieba.cut()***

- 返回词语组成的生成器

分析

- 准备句子，利用jieba.cut进行分词
- 实例化CountVectorizer
- 将分词结果变成字符串当作fit_transform的输入值

```python
from sklearn.feature_extraction.text import CountVectorizer
import jieba


def cut_word(text):
    # 用结巴对中文字符串进行分词
    text = " ".join(list(jieba.cut(text)))
    return text


data = ["一种还是一种今天很残酷，明天更残酷，后天很美好，但绝对大部分是死在明天晚上，所以每个人不要放弃今天。",
        "我们看到的从很远星系来的光是在几百万年之前发出的，这样当我们看到宇宙时，我们是在看它的过去。",
        "如果只用一种方式了解某样事物，你就不会真正了解它。了解事物真正含义的秘密取决于如何将其与我们所了解的事物相联系。"]

# 将原始数据转换成分好词的形式
text_list = []
for sent in data:
    text_list.append(cut_word(sent))
print(text_list)

# 1、实例化一个转换器类
transfer = CountVectorizer()
# 2、调用fit_transform
data = transfer.fit_transform(text_list)

print("文本特征抽取的结果：\n", data.toarray())
print("返回特征名字：\n", transfer.get_feature_names())
```

输出

```python

['一种 还是 一种 今天 很 残酷 ， 明天 更 残酷 ， 后天 很 美好 ， 但 绝对 大部分 是 死 在 明天 晚上 ， 所以 每个 人 不要 放弃 今天 。', '我们 看到 的 从 很 远 星系 来 的 光是在 几百万年 之前 发出 的 ， 这样 当 我们 看到 宇宙 时 ， 我们 是 在 看 它 的 过去 。', '如果 只用 一种 方式 了解 某样 事物 ， 你 就 不会 真正 了解 它 。 了解 事物 真正 含义 的 秘密 取决于 如何 将 其 与 我们 所 了解 的 事物 相 联系 。']

文本特征抽取的结果：
 [[2 0 1 0 0 0 2 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 2 0 1 0 2 1 0 0 0 1 1 0 0 1
  0]
 [0 0 0 1 0 0 0 1 1 1 0 0 0 0 0 0 0 1 3 0 0 0 0 1 0 0 0 0 2 0 0 0 0 0 1 0
  1]
 [1 1 0 0 4 3 0 0 0 0 1 1 0 1 0 1 1 0 1 0 0 1 0 0 0 1 0 0 0 2 1 0 0 1 0 0
  0]]
返回特征名字：
 ['一种', '不会', '不要', '之前', '了解', '事物', '今天', '光是在', '几百万年', '发出', '取决于', '只用', '后天', '含义', '大部分', '如何', '如果', '宇宙', '我们', '所以', '放弃', '方式', '明天', '星系', '晚上', '某样', '残酷', '每个', '看到', '真正', '秘密', '绝对', '美好', '联系', '过去', '还是', '这样']
```

### 2.3.3 Tf-idf文本特征提取 text.TfidfVectorizer

TF-IDF的主要思想是：如果某个词或短语在一篇文章中出现的概率高，并且在其他文章中很少出现，则认为此词或者短语具有很好的类别区分能力，适合用来分类。

TF-IDF作用：用以评估一字词对于一个文件集或一个语料库中的其中一份文件的重要程度。

#### 1）公式

- 词频（term frequency，tf）指的是某一个给定的词语在该文件中出现的频率
- 逆向文档频率（inverse document frequency，idf）是一个词语普遍重要性的度量。由总文件数目除以包含该词语之文件的数目，再将得到的商取以10为底的对数得到

$$
tfidf_{i,j}=tf_{i,j}\times idf_i
$$

>  假如一篇文件的总词语数是100个，而词语"非常"出现了5次，那么"非常"一词在该文件中的词频就是5/100=0.05。而计算文件频率（IDF）的方法是以文件集的文件总数，除以出现"非常"一词的文件数。所以，如果"非常"一词在1,000份文件出现过，而文件总数是10,000,000份的话，其逆向文件频率就是lg（10,000,000 / 1,0000）=3。最后"非常"对于这篇文档的tf-idf的分数为0.05 * 3=0.15

#### 2）API

***sklearn.feature_extraction.text.TfidfVectorizer(stop_words=[])***

- TfidfVectorizer.fit_transform(X)
  -  X：文本或者包含文本字符串的可迭代对象
  - 返回sparse矩阵
- TfidfVectorizer.inverse_transform(X)
  -  X：array数组或者sparse矩阵 
  - 返回转换之前数据格
- TfidfVectorizer.get_feature_names() 
  - 返回值单词列表

#### 3）例

```python
from sklearn.feature_extraction.text import TfidfVectorizer
import jieba

def cut_word(text):
    # 用结巴对中文字符串进行分词
    text = " ".join(list(jieba.cut(text)))
    return text

data = ["一种还是一种今天很残酷，明天更残酷，后天很美好，但绝对大部分是死在明天晚上，所以每个人不要放弃今天。",
        "我们看到的从很远星系来的光是在几百万年之前发出的，这样当我们看到宇宙时，我们是在看它的过去。",
        "如果只用一种方式了解某样事物，你就不会真正了解它。了解事物真正含义的秘密取决于如何将其与我们所了解的事物相联系。"]

# 将原始数据转换成分好词的形式
text_list = []
for sent in data:
    text_list.append(cut_word(sent))
print(text_list)

# 1、实例化一个转换器类
transfer = TfidfVectorizer(stop_words=['一种', '不会', '不要'])
# 2、调用fit_transform
data = transfer.fit_transform(text_list)

print("文本特征抽取的结果：\n", data.toarray())
print("返回特征名字：\n", transfer.get_feature_names())
```

输出

```python
['一种 还是 一种 今天 很 残酷 ， 明天 更 残酷 ， 后天 很 美好 ， 但 绝对 大部分 是 死 在 明天 晚上 ， 所以 每个 人 不要 放弃 今天 。', '我们 看到 的 从 很 远 星系 来 的 光是在 几百万年 之前 发出 的 ， 这样 当 我们 看到 宇宙 时 ， 我们 是 在 看 它 的 过去 。', '如果 只用 一种 方式 了解 某样 事物 ， 你 就 不会 真正 了解 它 。 了解 事物 真正 含义 的 秘密 取决于 如何 将 其 与 我们 所 了解 的 事物 相 联系 。']

文本特征抽取的结果：
 [[0.         0.         0.         0.43643578 0.         0.
  0.         0.         0.         0.21821789 0.         0.21821789
  0.         0.         0.         0.         0.21821789 0.21821789
  0.         0.43643578 0.         0.21821789 0.         0.43643578
  0.21821789 0.         0.         0.         0.21821789 0.21821789
  0.         0.         0.21821789 0.        ]
 [0.2410822  0.         0.         0.         0.2410822  0.2410822
  0.2410822  0.         0.         0.         0.         0.
  0.         0.         0.2410822  0.55004769 0.         0.
  0.         0.         0.2410822  0.         0.         0.
  0.         0.48216441 0.         0.         0.         0.
  0.         0.2410822  0.         0.2410822 ]
 [0.         0.644003   0.48300225 0.         0.         0.
  0.         0.16100075 0.16100075 0.         0.16100075 0.
  0.16100075 0.16100075 0.         0.12244522 0.         0.
  0.16100075 0.         0.         0.         0.16100075 0.
  0.         0.         0.3220015  0.16100075 0.         0.
  0.16100075 0.         0.         0.        ]]
返回特征名字：
 ['之前', '了解', '事物', '今天', '光是在', '几百万年', '发出', '取决于', '只用', '后天', '含义', '大部分', '如何', '如果', '宇宙', '我们', '所以', '放弃', '方式', '明天', '星系', '晚上', '某样', '残酷', '每个', '看到', '真正', '秘密', '绝对', '美好', '联系', '过去', '还是', '这样']
```

## 2.4 特征预处理

（feature preprocessing）

通过一些转换函数将特征数据转换成更加适合算法模型的特征数据过程

数据的无量纲处理：**使不同规格的数据转换到同一规格**

- 归一化
- 标准化

特征的单位或者大小相差较大，或者某特征的方差相比其他的特征要大出几个数量级**，**容易影响（支配）目标结果，使得一些算法无法学习到其它的特征，所以要进行归一化/标准化。

```python
import sklearn.preprocessing
```

### 2.4.1 归一化

通过对原始数据进行变换把数据映射到（默认为）[0,1] 之间

#### 1）公式

$$
X'=\cfrac{x-min}{max-min}\\
X''=X'*(mx-mi)+mi
$$

>  作用于每一列，max 为一列的最大值，min 为一列的最小值，X’’为最终结果，mx，mi分别为指定区间值，默认mx为1，mi为0

#### 2）API

***sklearn.preprocessing.MinMaxScaler (feature_range=(0,1)… )***

- *MinMaxScalar.fit_transform(X)*
  - X：numpy array格式的数据 [n_samples,n_features]
  - 返回值：转换后的形状相同的array

#### 3）例

以下为数据实例

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210118192214857.png" alt="image-20210118192214857" style="zoom:80%;" />

- 实例化MinMaxScalar

- 通过fit_transform转换

```python
from sklearn.preprocessing import MinMaxScaler
import pandas as pd

path = "../Data/Dating.txt"
data = pd.read_csv(path)

# 1、实例化一个转换器类
transfer = MinMaxScaler(feature_range=(0, 1)) # 默认 MIN=0, MAX=1
# 2、调用fit_transform
data = transfer.fit_transform(data[['milage','Liters','Consumtime']]) # 需要传numpy array格式, 返回array

print("最小值最大值归一化处理的结果：\n", data)
```

输出

```python
最小值最大值归一化处理的结果：
 [[0.43582641 0.58819286 0.53237967]
 [0.         0.48794044 1.        ]
 [0.19067405 0.         0.43571351]
 [1.         1.         0.19139157]
 [0.3933518  0.01947089 0.        ]]
```

注意最大值最小值是变化的，另外，最大值与最小值非常容易受异常点影响，所以这种方法鲁棒性较差，只适合传统精确小数据场景

### 2.4.2 标准化

通过对原始数据进行变换把数据变换到均值为0，标准差为1的范围内

优势

- 对于归一化来说：如果出现异常点，影响了最大值和最小值，那么结果显然会发生改变
- 对于标准化来说：如果出现异常点，由于具有一定数据量，少量的异常点对于平均值的影响并不大，从而方差改变较小

#### 1）公式

$$
X'=\cfrac{x-mean}{\sigma}
$$

> 作用于每一列，mean 为平均值，σ 为标准差

#### 2）API

***sklearn.preprocessing.StandardScaler( )***

- *StandardScaler.fit_transform(X)*
  - X：numpy array 格式的数据[n_samples, n_features]
  - 返回值：转换后的形状相同的array
- *StandardScaler.mean_*
  - 返回值：每一列特征的平均值
- *StandardScaler.var_*
  - 返回值：每一列特征的方差

#### 3）例

同样对 2.4.1 的数据进行处理

- 实例化MinMaxScalar

- 通过fit_transform转换

```python
import pandas as pd
from sklearn.preprocessing import StandardScaler

data = pd.read_csv(path)

# 1、实例化一个转换器类
transfer = StandardScaler() # 值都在0附近,所以有负数是正常的
# 2、调用fit_transform
data = transfer.fit_transform(data[['milage','Liters','Consumtime']]) 

print("标准化的结果:\n", data)
print("每一列特征的平均值：\n", transfer.mean_)
print("每一列特征的方差：\n", transfer.var_)
```

输出

```python
标准化的结果:
[[ 0.0947602   0.44990013  0.29573441]
 [-1.20166916  0.18312874  1.67200507]
 [-0.63448132 -1.11527928  0.01123265]
 [ 1.77297701  1.54571769 -0.70784025]
 [-0.03158673 -1.06346729 -1.27113187]]
每一列特征的平均值：
 [3.8988000e+04 6.3478996e+00 7.9924800e-01]
每一列特征的方差：
 [4.15683072e+08 1.93505309e+01 2.73652475e-01]
```

## 2.5 特征降维

（Feature Dimension Reduce）

降维是指在某些限定条件下，降低随机变量（特征）个数，得到一组“不相关”主变量的过程

两种方式

- 特征选择
- 主成分分析（可以理解一种特征提取的方式）

### 2.5.1 特征选择

```python
import sklearn.feature_selection
```

数据中包含冗余或无关变量（或称特征、属性、指标等），旨在从原有特征中找出主要特征

方法

- 过滤式（Filter）：主要探究特征本身特点、特征与特征和目标值之间关联
  - 方差选择法：低方差特征过滤
  - 相关系数
- 嵌入式（Embedded）：算法自动选择特征（特征与目标值之间的关联）
  - 决策树：信息熵、信息增益
  - 正则化：L1、L2
  - 深度学习：卷积等

#### 1）低方差特征过滤

删除低方差的一些特征

##### API

***sklearn.feature_selection.VarianceThreshold(threshold = 0.0)***

- *Variance.fit_transform(X)*
  - X：numpy array 格式的数据 [n_samples, n_features]
  - 返回值：训练集差异低于 threshold 的特征将被删除。默认值是保留所有非零方差特征，即删除所有样本中具有相同值的特征。

##### 例

处理以下例子

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210118192214857.png" alt="image-20210118192214857" style="zoom:80%;" />

分析

- 初始化 VarianceThreshold ，指定阀值方差

- 调用 fit_transform

```python
from sklearn.feature_selection import VarianceThreshold
import pandas as pd

path="../Data/Dating.txt"
data = pd.read_csv(path)

# 1、实例化一个转换器类
transfer = VarianceThreshold(threshold=1)
# 2、调用fit_transform
data = transfer.fit_transform(data.iloc[:, 0:-1])

print("删除低方差特征的结果：\n", data)
print("形状：\n", data.shape)
```

输出

```python
删除低方差特征的结果：
 [[4.0920000e+04 8.3269760e+00]
 [1.4488000e+04 7.1534690e+00]
 [2.6052000e+04 1.4418710e+00]
 [7.5136000e+04 1.3147394e+01]
 [3.8344000e+04 1.6697880e+00]]
形状：
 (5, 2)
```

#### 2）相关系数

去除相关特征（correlated feature）的影响

使用 Scipy 实现

```python
from scipy.stats import pearsonr
```

##### 原理

皮尔逊相关系数（Pearson Correlation Coefficient）：反映变量之间相关关系密切程度的统计指标
$$
r=\cfrac{n\sum xy=\sum x\sum y}{\sqrt{n\sum x^2 -(\sum x)^2}\sqrt{n\sum y^2-(\sum y)^2}}
$$
相关系数的值介于–1与+1之间，即–1≤ r ≤+1。其性质如下：

- 当r > 0时，表示两变量正相关，r < 0时，两变量为负相关
- 当|r|=1时，表示两变量为完全相关，当 r=0 时，表示两变量间无相关关系
- 当0<|r|<1时，表示两变量存在一定程度的相关。且|r|越接近1，两变量间线性关系越密切；|r|越接近于0，表示两变量的线性相关越弱
- 一般可按三级划分：|r|<0.4为低度相关；0.4≤|r|<0.7为显著性相关；0.7≤|r|<1为高度线性相关

##### API

***pearsonr(X, Y)***

- X：numpy array 格式的数据
- Y：numpy array 格式的数据
- 返回值
  - r：相关系数 [-1，1] 之间
  - p-value：p值（p值越小，表示相关系数越显著，一般p值在500个样本以上时有较高的可靠性）



如果相关性高可用以下方法:

1. 选取其中一个特征

2. 两个特征加权求和

3. 主成分分析（高维数据变低维，舍弃原由数据，创造新数据，如：压缩数据维数，降低原数据复杂度，损失少了信息）

##### 例

两两特征之间进行相关性计算

```python
from scipy.stats import pearsonr
import pandas as pd

path="../Data/Dating.txt"
data = pd.read_csv(path)

# 皮尔逊相关系数范围[-1,1], 如果大于0就是正相关(越接近1就越相关), 反之亦然
r = pearsonr(data["milage"], data["Liters"])
print("milage和Liters的相关系数为:\n", r)

r = pearsonr(data["milage"], data["Consumtime"])
print("milage和Liters的相关系数为:\n", r)
```

输出

```python
milage和Liters的相关系数为:
 (0.660861943290103, 0.2246299034335304)
milage和Liters的相关系数为:
 (-0.6406267138718624, 0.2441916485876286)
```

### 2.5.2 主成分分析

（PCA）将数据分解为较低维数空间

```python
from sklearn.decomposition import PCA
```

#### 1）概念

- 定义：高维数据转化为低维数据的过程，在此过程中可能会舍弃原有数据、创造新的变量
- 作用：是数据维数压缩，尽可能降低原数据的维数（复杂度），损失少量信息
- 应用：回归分析或者聚类分析当中

#### 2）API

***sklearn.decomposition.PCA(n_components=None)***

- 参数：*n_components*
  - 小数：表示保留百分之多少的信息
  - 整数：减少到多少特征

- *PCA.fit_transform(X)*
  - X：numpy array 格式的数据 [n_samples,n_features]
  - 返回值：转换后指定维度的 array

#### 3）例

```python
from sklearn.decomposition import PCA

data = [[2, 8, 4, 5], [3, 8, 5, 5], [10, 5, 1, 0]]  # 3*4矩阵 包含四个特征

transfer = PCA(n_components=3) # 为整数就是转为多少个特征  保留的至少都比原特征值少一个
data_new = transfer.fit_transform(data)
print("(主成分分析)PCA降维:\n", data_new)
```

输出

```python
(主成分分析)PCA降维:
[[-3.57495904e+00 -6.64748145e-01  1.07947657e-16]
 [-3.17447323e+00  6.91574499e-01  1.07947657e-16]
 [ 6.74943227e+00 -2.68263539e-02  1.07947657e-16]]
```

若 n_components 设为0.95

```python
(主成分分析)PCA降维:
[[-3.57495904]
 [-3.17447323]
 [ 6.74943227]]
```

# 三、转换器和估计器

## 3.1 转换器

（transformer）

特征工程的接口称之为转换器；转换器是特征工程的父类

调用步骤

1. 实例化 (实例化的是一个转换器类(Transformer))

2. 调用fit_transform(对于文档建立分类词频矩阵，不能同时调用)

转换器调用形式

- fit_transform()
- fit()
  - 按公式计算
- transform()
  - 进行最终的转换

## 3.2 估计器

（estimator）

估计器实现了算法的API，估计器是算法的父类

- 用于分类的估计器：
  - sklearn.neighbors k-近邻算法
  - sklearn.naive_bayes 贝叶斯
  - sklearn.linear_model.LogisticRegression 逻辑回归
  - sklearn.tree 决策树与随机森林
- 用于回归的估计器：
  - sklearn.linear_model.LinearRegression 线性回归
  - sklearn.linear_model.Ridge 岭回归
- 用于无监督学习的估计器
  - sklearn.cluster.KMeans 聚类

调用步骤

1. 实例化估计器类estimator

2. 进行训练，一旦调用完毕，意味着模型生成

   - *estimator.fit(x_train, y_train)*

3. 模型评估

   - 直接比对真实值和预测值

     *y_predict = estimator.predict(x_test)*

     *y_test == y_predict*

   - 计算准确率

     *accuracy = estimator.score(x_test, y_test)*

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/估计器工作流程.png" alt="估计器工作流程" style="zoom:67%;" />



## 3.3 模型选择与调优

```python
from sklearn.model_selection import GridSearchCV
```

### 3.3.1 概念

#### 1）交叉验证

（cross validation）

将拿到的训练数据，分为训练和验证集

#### 2）超参数搜索-网格搜索

（Grid Search）

通常情况下，有很多参数是需要手动指定的（如k-近邻算法中的K值），这种叫超参数。但是手动过程繁杂，所以需要对模型预设几种超参数组合。每组超参数都采用交叉验证来进行评估。最后选出最优参数组合建立模型。

### 3.3.2 API

***sklearn.model_selection.GridSearchCV(estimator, param_grid=None,cv=None)***

对估计器的指定参数值进行详尽搜索
- 参数
  - *estimator*：估计器对象
  - *param_grid*：估计器参数 ` (dict){“n_neighbors”:[1,3,5]}`
  - *cv*：指定几折交叉验证
- 方法
  - *fit*：输入训练数据
  - *score*：准确率
- 结果分析：
  - *best_params_*：在交叉验证中验证的最好超参数
  - *best_score_*：在交叉验证中验证的最好结果
  - *best_estimator_*：最好的参数模型
  - *cv_results_*：每次交叉验证后的验证集准确率结果和训练集准确率结果

# 四、分类

## 4.1 KNN 算法

> 根据邻居，判断类别

```python
from sklearn.neighbors import KNeighborsClassifier
```

（K Nearest Neighbor）即K - 近邻算法

如果一个样本在特征空间中的**k个最相似(即特征空间中最邻近)的样本中的大多数属于某一个类别**，则该样本也属于这个类别。

- 优点：
  - 简单，易于理解，易于实现，无需训练
- 缺点：
  - 懒惰算法，对测试样本分类时的计算量大，内存开销大
  - 必须指定K值，K值选择不当则分类精度不能保证
- 使用场景：小数据场景，几千～几万样本，具体场景具体业务去测试

### 4.1.1 API

***sklearn.neighbors.KNeighborsClassifier(n_neighbors=5,algorithm='auto')***

- n_neighbors：int，可选（默认= 5），使用的邻居数
- algorithm：*{‘auto’，‘ball_tree’，‘kd_tree’，‘brute’}*，可选用于计算最近邻居的算法，不同实现方式影响效率
  - *‘ball_tree’* 将会使用 BallTree
  - *‘kd_tree’* 将使用 KDTree
  - *‘auto’* 将尝试根据传递给fit方法的值来决定最合适的算法

### 4.1.2 例

```python
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn import datasets
import numpy as np
import pandas as pd

# 数据集导入
iris = datasets.load_iris()

# 数据集划分
x_train, x_test, y_train, y_test = train_test_split(
    iris.data, iris.target, random_state=43)

# 标准化
transfer_std = StandardScaler()
x_train_std = transfer_std.fit_transform(x_train)
x_test_std = transfer_std.transform(x_test)  # 测试集不要用fit, 因为要保持和训练集处理方式一致

# KNN
estimator_knn = KNeighborsClassifier(n_neighbors=3)

# 调优
param_dict = {"n_neighbors": [1, 3, 5, 7, 9, 11]}
estimator_knn = GridSearchCV(
    estimator_knn, param_grid=param_dict, cv=10)  # 10折

# 训练模型
estimator_knn.fit(x_train_std, y_train)
y_pred = estimator_knn.predict(x_test_std)

print("预测值为:", y_pred, "\n真实值为:", y_test, "\n比较结果为:", y_test == y_pred)
print("准确率为：\n", estimator_knn.score(x_test_std, y_test))

print("最佳参数:\n", estimator_knn.best_params_)
print("最佳结果:\n", estimator_knn.best_score_)
print("最佳估计器:\n", estimator_knn.best_estimator_)
print("交叉验证结果:\n", estimator_knn.cv_results_)

```

输出

```python
预测值为: [0 0 2 1 2 0 2 1 1 1 0 1 2 0 1 1 0 0 2 2 0 0 0 1 2 2 0 1 0 0 1 0 1 1 2 2 1
 2] 
真实值为: [0 0 2 1 2 0 2 1 1 1 0 1 2 0 1 1 0 0 2 2 0 0 0 2 2 2 0 1 0 0 1 0 1 1 2 2 1
 2] 
比较结果为: [ True  True  True  True  True  True  True  True  True  True  True  True
  True  True  True  True  True  True  True  True  True  True  True False
  True  True  True  True  True  True  True  True  True  True  True  True
  True  True]
准确率为：
 0.9736842105263158
最佳参数:
 {'n_neighbors': 1}
最佳结果:
 0.9469696969696969
最佳估计器:
 KNeighborsClassifier(n_neighbors=1)
交叉验证结果:
 {'mean_fit_time': array([0.00029657, 0.00039995, 0.00039968, 0.00049977, 0.00029998,
       0.00040131]), 'std_fit_time': array([0.00045309, 0.00048983, 0.00048951, 0.00049977, 0.00045822,
       0.0004915 ]), 'mean_score_time': array([0.00089977, 0.00080023, 0.00110025, 0.00080018, 0.00079889,
       0.00080283]), 'std_score_time': array([0.00029992, 0.0004004 , 0.00030082, 0.00040009, 0.00039965,
       0.00040154]), 'param_n_neighbors': masked_array(data=[1, 3, 5, 7, 9, 11],
             mask=[False, False, False, False, False, False],
       fill_value='?',
            dtype=object), 'params': [{'n_neighbors': 1}, {'n_neighbors': 3}, {'n_neighbors': 5}, {'n_neighbors': 7}, {'n_neighbors': 9}, {'n_neighbors': 11}], 'split0_test_score': array([0.91666667, 0.91666667, 0.91666667, 0.91666667, 0.91666667,
       0.91666667]), 'split1_test_score': array([0.91666667, 0.91666667, 0.83333333, 0.91666667, 0.91666667,
       0.91666667]), 'split2_test_score': array([0.90909091, 0.90909091, 0.90909091, 0.90909091, 0.90909091,
       1.        ]), 'split3_test_score': array([0.90909091, 0.90909091, 0.90909091, 0.90909091, 0.90909091,
       0.81818182]), 'split4_test_score': array([1., 1., 1., 1., 1., 1.]), 'split5_test_score': array([0.90909091, 0.90909091, 1.        , 1.        , 1.        ,
       1.        ]), 'split6_test_score': array([1., 1., 1., 1., 1., 1.]), 'split7_test_score': array([0.90909091, 0.81818182, 0.81818182, 0.81818182, 0.81818182,
       0.81818182]), 'split8_test_score': array([1., 1., 1., 1., 1., 1.]), 'split9_test_score': array([1.        , 0.90909091, 1.        , 1.        , 1.        ,
       0.90909091]), 'mean_test_score': array([0.9469697 , 0.92878788, 0.93863636, 0.9469697 , 0.9469697 ,
       0.93787879]), 'std_test_score': array([0.04338734, 0.05412294, 0.06830376, 0.05945884, 0.05945884,
       0.07048305]), 'rank_test_score': array([1, 6, 4, 1, 1, 5])}
```

## 4.2 朴素贝叶斯算法

（Naive Bayes）

> 相互独立的特征 + 贝叶斯公式

```python
from sklearn.naive_bayes import MultinomialNB
```

朴素：特征与特征之间是相互独立的

朴素贝叶斯算法经常用于文本分类, 因为文章转换成机器学习算法识别的数据是以单词为特征的

- 优点：
  - 朴素贝叶斯模型发源于古典数学理论，有稳定的分类效率。
  - 对缺失数据不太敏感，算法也比较简单，常用于文本分类。
  - 分类准确度高，速度快
- 缺点：
  - 由于使用了样本属性独立性的假设，所以如果特征属性有关联时其效果不好

### 4.2.1 原理

#### 1）贝叶斯公式

以文本分类为例
$$
P(C|F_1,F_2,\ldots)=\cfrac{P(F_1,F_2,\ldots|C)P(C)}{P(F_1,F_2,\ldots)}
$$

- $P(C)$：每个文档类别的概率(某文档类别数／总文档数量)
- $P(W│C)$：给定类别下特征（被预测文档中出现的词）的概率
  - $W$ 为给定文档的特征值（频数统计）
  - 计算方法：$P(F_1│C)=N_i/N$ （训练文档中去计算）
    - $N_i$：该 $F_1$ 词在 $C$ 类别所有文档中出现的次数
    - $N$：所属类别 $C$ 下的文档的文本总和
- $P(F_1,F_2,\ldots)$ 预测文档中每个词的概率

#### 2）拉普拉斯平滑系数

目的：防止计算出的分类概率为0
$$
P(F_1|C)=\cfrac{N_i+\alpha}{N+\alpha m}
$$

- $\alpha$：预先指定的系数，默认为 1
- $m$：训练文档中特征词的种类数

```python
# 因为样本数量不够，会出现特征词不在一类文本中出现的情况
P(娱乐|影院,支付宝,云计算) = 𝑃(影院,支付宝,云计算|娱乐)∗P(娱乐)=(56/121)∗(15/121)∗(0/121)∗(60/90) = 0
# 此时需要实用到拉普拉斯平滑系数
P(娱乐|影院,支付宝,云计算) =P(影院,支付宝,云计算|娱乐)P(娱乐)=(56+1/121+4)(15+1/121+4)(0+1/121+1*4)(60/90) = 0.00002
```

### 4.2.2 API

***sklearn.naive_bayes.MultinomialNB(alpha = 1.0)***

- *alpha*：拉普拉斯平滑系数

### 4.2.3 例：20类新闻分类

分析

- 划分数据集
- tfidf 进行的特征抽取
- 朴素贝叶斯预测

```python
from sklearn.datasets import fetch_20newsgroups, load_files
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
import pandas as pd

data = fetch_20newsgroups(subset="all") 
x_train, x_test, y_train, y_test = \
        train_test_split(data.data, data.target, test_size=0.2, random_state=22)
# 文本分类
transfer = TfidfVectorizer()  
x_train = transfer.fit_transform(x_train)
x_test = transfer.transform(x_test)  
# 朴素贝叶斯
estimator = MultinomialNB()
estimator.fit(x_train, y_train)
y_predict = estimator.predict(x_test)

print("预测值为:", y_predict, "\n真实值为:", y_test, "\n比较结果为:", y_test == y_predict)
score = estimator.score(x_test, y_test)
print("准确率为: ", score)
```

输出

```python
预测值为: [15 13 16 ... 13  2 13] 
真实值为: [15 13 16 ... 13  2 13] 
比较结果为: [ True  True  True ...  True  True  True]
准确率为:  0.8511936339522547
```

## 4.3 决策树

（Decision Tree）

```python
from sklearn.tree import DecisionTreeClassifier
```

> if - else

### 4.3.1 原理

#### 1）信息熵

$$
H(X)=-\sum\limits_{i=1}^n P(x_i)log_bP(x_i)
$$

#### 2）条件信息熵

$$
H(D|A)=\sum\limits_{i=1}^n \cfrac{|D_i|}{|D|}H(D_i)
$$



#### 3）信息增益

决策树的划分依据之一

特征 $A$ 对训练数据集 $D$ 的信息增益 $g(D,A)$,定义为集合 D 的信息熵 $H(D)$ 与特征 $A$ 给定条件下 $D$ 的信息条件熵 $H(D|A)$ 之差
$$
g(D,A)=H(D)=H(D|A)
$$

#### 4）三种算法实现

- ID3
  - 信息增益 最大的准则
- C4.5
  - 信息增益比 最大的准则
- CART
  - 分类树: 基尼系数 最小的准则 在sklearn中可以选择划分的默认原则
  - 优势：划分更加细致（从后面例子的树显示来理解）

### 4.3.2 API

***class sklearn.tree.DecisionTreeClassifier(criterion=’gini’, max_depth=None,random_state=None)***

决策树分类器

- criterion：默认是’gini’系数，也可以选择信息增益的熵’entropy’
- max_depth：树的深度大小
- random_state：随机数种子

### 4.3.3 保存树的结构

```python
from sklearn.tree import export_graphviz
```

***sklearn.tree.export_graphviz()*** 

该函数能够导出DOT格式

- tree.export_graphviz(estimator, out_file=path, feature_names)

### 4.3.4 例

```python
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, export_graphviz

iris = datasets.load_iris()
x_train, x_test, y_train, y_test = train_test_split(
    iris.data, iris.target, random_state=22)
# 决策树训练
estimator = DecisionTreeClassifier(criterion="entropy")
estimator.fit(x_train, y_train)
# 生成树文件
export_graphviz(estimator, out_file="tree.dot",
                feature_names=iris.feature_names)

y_pred = estimator.predict(x_test)
print("预测值为:", y_pred, "\n真实值为:", y_test, "\n比较结果为:", y_test == y_pred)
score = estimator.score(x_test, y_test)
print("准确率为: ", score)
```

输出

```python
预测值为: [0 2 1 2 1 1 1 1 1 0 2 1 2 2 0 2 1 1 1 1 0 2 0 1 2 0 2 2 2 1 0 0 1 1 1 0 0
 0] 
真实值为: [0 2 1 2 1 1 1 2 1 0 2 1 2 2 0 2 1 1 2 1 0 2 0 1 2 0 2 2 2 2 0 0 1 1 1 0 0
 0] 
比较结果为: [ True  True  True  True  True  True  True False  True  True  True  True
  True  True  True  True  True  True False  True  True  True  True  True
  True  True  True  True  True False  True  True  True  True  True  True
  True  True]
准确率为:  0.9210526315789473
```

# 六、聚类

K-means（K均值聚类）

- 特点：采用迭代式算法，直观易懂并且非常实用
- 缺点：容易收敛到局部最优解(多次聚类)

## 6.1 聚类步骤

1. 随机设置 K 个特征空间内的点作为初始的聚类中心

2. 对于其他每个点计算到 K 个中心的距离，未知的点选择最近的一个聚类中心点作为标记类别

3. 接着对着标记的聚类中心之后，重新计算出每个聚类的新中心点（平均值）

4. 如果计算得出的新中心点与原中心点一样，那么结束，否则重新进行第二步过程

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/K-means过程分析.png" alt="K-means过程分析" style="zoom:67%;" />

## 6.2 API

***sklearn.cluster.KMeans(n_clusters=8, init=‘k-means++’…)***

- n_clusters：开始的聚类中心数量
- init：初始化方法，默认为'k-means ++’

*KMeans.labels_*：默认标记的类型，可以和真实值比较（不是值比较）

## 6.3  轮廓系数

轮廓系数作为 Kmeans 的性能评估指标

### 6.3.1 公式

$$
sc_i=\cfrac{b_i-a_i}{max(b_i,a_i)}
$$

> 注：对于每个点 $i$ 为已聚类数据中的样本 ，$b_i$ 为 $i$ 到其它族群的所有样本的距离最小值，$a_i$ 为 $i$ 到本身簇的距离平均值。最终计算出所有的样本点的轮廓系数平均值

### 6.3.2 轮廓系数值分析

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210118223723565.png" alt="image-20210118223723565" style="zoom: 60%;" />

**分析过程**（以一个蓝1点为例）

1. 计算出蓝1离本身族群所有点的距离的平均值$a_i$

2. 蓝1到其它两个族群的距离计算出平均值红平均，绿平均，取最小的那个距离作为$b_i$

3. 根据公式：极端值考虑：如果$b_i >>a_i$，那么公式结果趋近于1；如果$a_i>>>b_i$，那么公式结果趋近于-1

**结论**：如果$b_i>>a_i$，趋近于1，效果好， $b_i<<a_i$，趋近于-1，效果不好。轮廓系数的值是介于 [-1,1] ，越趋近于1代表内聚度和分离度都相对较优

### 6.3.3 API

- ***sklearn.metrics.silhouette_score(X, labels)***：计算所有样本的平均轮廓系数
  - X：特征值
  - labels：被聚类标记的目标值（聚类结果）

## 6.4 例

分析

1. 降维之后的数据

2. k-means聚类

3. 聚类结果显示
4. 用户聚类结果评估

```python
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline
from sklearn.datasets.samples_generator import make_blobs
# X为样本特征，Y为样本簇类别， 共1000个样本，每个样本2个特征，共4个簇，簇中心在[-1,-1], [0,0],[1,1], [2,2]， 簇方差分别为[0.4, 0.2, 0.2]
X, y = make_blobs(n_samples=1000, n_features=2, centers=[[-1,-1], [0,0], [1,1], [2,2]], cluster_std=[0.4, 0.2, 0.2, 0.2])
plt.scatter(X[:, 0], X[:, 1], marker='o')
plt.show()
```

案例样本

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210119103734104.png" alt="image-20210119103734104" style="zoom:67%;" />

```python
from sklearn.cluster import KMeans

#y_pred = KMeans(n_clusters=4).fit_predict(X)
estimator = KMeans(n_clusters=4, init='k-means++')
estimator.fit(X)
y_pred = estimator.predict(X)

plt.scatter(X[:, 0], X[:, 1], c=y_pred)
plt.show()
```

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210119104047678.png" alt="image-20210119104047678" style="zoom:67%;" />

输出

```python
模型轮廓系数为(1 最好, -1 最差): 0.6634549555891298
```

