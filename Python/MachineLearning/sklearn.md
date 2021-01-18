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

***sklearn.feature_extraction.DictVectorizer(sparse=True,…)***

它是一个转换器，应用时需要进行实例化

#### 1）方法

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

***sklearn.feature_extraction.text.CountVectorizer(stop_words=[])***

它是一个转换器，应用时需要进行实例化

#### 1）方法

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

***sklearn.feature_extraction.text.TfidfVectorizer(stop_words=[])***

TF-IDF的主要思想是：如果某个词或短语在一篇文章中出现的概率高，并且在其他文章中很少出现，则认为此词或者短语具有很好的类别区分能力，适合用来分类。

TF-IDF作用：用以评估一字词对于一个文件集或一个语料库中的其中一份文件的重要程度。

#### 1）公式

- 词频（term frequency，tf）指的是某一个给定的词语在该文件中出现的频率
- 逆向文档频率（inverse document frequency，idf）是一个词语普遍重要性的度量。由总文件数目除以包含该词语之文件的数目，再将得到的商取以10为底的对数得到

$$
tfidf_{i,j}=tf_{i,j}\times idf_i
$$

>  假如一篇文件的总词语数是100个，而词语"非常"出现了5次，那么"非常"一词在该文件中的词频就是5/100=0.05。而计算文件频率（IDF）的方法是以文件集的文件总数，除以出现"非常"一词的文件数。所以，如果"非常"一词在1,000份文件出现过，而文件总数是10,000,000份的话，其逆向文件频率就是lg（10,000,000 / 1,0000）=3。最后"非常"对于这篇文档的tf-idf的分数为0.05 * 3=0.15

#### 2）方法

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

（preprocessing）