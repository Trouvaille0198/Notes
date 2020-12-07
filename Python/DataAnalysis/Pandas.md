# 一、分类与创建

## 1.1 Series

Series是一种类似于以为NumPy数组的对象，它由一组数据（各种NumPy数据类型）和与之相关的一组数据标签（即索引）组成的。可以用index和values分别规定索引和值。如果不规定索引，会自动创建 0 到 N-1 索引。

Series是1维的数据，拥有的索引，一般以竖行形式输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207200644867.png" alt="image-20201207200644867" style="zoom:50%;" />

### 1.1.1 创建

Series可以方便的通过list，array还有dict来构建

```python
pd.Series()
```

```python
import numpy as np
import pandas as pd

mylist = list('abc')
myarr = np.arange(3)
mydict = dict(zip(mylist, myarr))

ser1 = pd.Series(mylist)  #使用列表创建
ser2 = pd.Series(myarr)   #使用数组创建
ser3 = pd.Series(mydict)  #使用字典创建

print(ser1,'\n')
print(ser2,'\n')
print(ser3,'\n')
```

输出

```python
0    a
1    b
2    c
dtype: object 

0    0
1    1
2    2
dtype: int32 

a    0
b    1
c    2
dtype: int64 
```

在构建Series的时候，指定index来代替默认的0~n数字式索引

```python
ser4 = pd.Series([100, 200, 150], index=['apple', 'banana', 'peach'])
print(ser4)
```

```python
apple     100
banana    200
peach     150
dtype: int64
```

### 1.1.2 访问

下标方式访问

```python
ser4['banana']
```

index方式访问

```python
ser4[1]
```

## 1.2 DataFrame

DataFrame是一种表格型结构，含有一组有序的列，每一列可以是不同的数据类型。既有行索引，又有列索引<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/J$F`0{7$G@6E@1QX3O3$X{Q.png" alt="img" style="zoom:67%;" />

### 1.2.1 从具有索引标签的字典数据创建

```python
data = {'animal': ['cat', 'cat', 'snake', 'dog', 'dog', 'cat', 'snake', 'cat', 'dog', 'dog'],
        'age': [2.5, 3, 0.5, np.nan, 5, 2, 4.5, np.nan, 7, 3],
        'visits': [1, 3, 2, 3, 2, 3, 1, 1, 2, 1],
        'priority': ['yes', 'yes', 'no', 'yes', 'no', 'no', 'no', 'yes', 'no', 'no']}
labels = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']

df = pd.DataFrame(data,index = labels)
df
```

输出

![image-20201207205444467](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205444467.png)

### 1.2.2 从numpy 数组创建

```python
df2 = pd.DataFrame(np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]]),
                    columns=['a', 'b', 'c'])
df2
```

输出

![image-20201207205555602](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205555602.png)

```python
df = pd.DataFrame(np.arange(9).reshape(3, 3), index = [
    "Mon", "Tue", "Wed"], columns=['store1', 'store2', 'store3'])
df
```

输出

![image-20201207205853449](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205853449.png)

### 1.2.3 通过其他DataFrame来创建

```python
df3 = df2[["a","b","c"]].copy()
df3
```

输出

![image-20201207205620990](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205620990.png)

### 1.2.4 从csv文件创建

```python
df = pd.read_csv('path')
```

### 1.2.5 用Series创建

```python
s_1 = pd.Series(data['animal'])
s_2 = pd.Series(data['age'])
s_3 = pd.Series(data['visits'])
s_4 = pd.Series(data['priority'])

df = pd.DataFrame([s_1,s_2,s_3,s_4])
df
```

输出

![image-20201207205642638](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205642638.png)

这玩意可以看做是多个Series的组合。DataFrame的不同列可以是不同的数据类型,如果以Series数组来创建DataFrame，每个Series将成为一行，而不是一列

# 二、基本操作

## 2.1 访问

以下图为例

![image-20201207222452955](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207222452955.png)

col，index为列号和行号

colName，indexName为具体值

### 2.1.1 `df[colName]`

根据列名，并以Series的形式返回列

若列名为默认的数字时，colName可以被视为col（其中就col可以表示为列表形式和切片形式）

```python
df['a'] 			#取a列
df[['b','e','f']]   #取b,e,f列
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207223843331.png" alt="image-20201207223843331" style="zoom:80%;" />

### 2.1.2 `df[colName][indexName]`

更精准的访问（几列几行）

若列名为默认的数字时，colName可以被视为col（其中就col可以表示为列表形式和切片形式）

```python
df['c']['B']
```

输出

```python
0.5
```

### 2.1.3 ` df.iloc[index, col]`

其中index，col可以表示为列表形式和切片形式，当只传入一个参数时，该参数默认为index

```python
df.iloc[0:1] 			#取第0行数据，较为规范
df.iloc[0]   			#硬要这样俺也没办法
df.iloc[:,[2]]  		#取第2列数据
df.iloc[0:3,2:6]  		#取0到2行，2到5列数据
df.iloc[[0,3],[2,3,7]]  #取0和3行，2、3、7列相交数据
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207224248457.png" alt="image-20201207224248457" style="zoom: 80%;" />

### 2.1.5 `df.loc[indexName,colName]`

`df.iloc`只能选取数据表里实际有的行和列，而`df.loc`可以选取没有的行和列，赋值后就可以添加新行或者列

```python
df.loc[:,'c'] 						#选取c列
df.loc[['A','C'],['c','e','f']] 	#选取A,C列，c,e,f行相交数据
df.loc[df['c']=='snake'] 			#选取c列中内容为snake的行数据
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207230245814.png" alt="image-20201207230245814" style="zoom:80%;" />