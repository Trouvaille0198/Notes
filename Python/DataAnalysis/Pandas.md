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

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205444467.png" alt="image-20201207205444467" style="zoom:80%;" />

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

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205853449.png" alt="image-20201207205853449" style="zoom:80%;" />

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
df = pd.read_csv('test.csv', encoding='gbk, sep=';') 	#分隔符为“；”，编码格式为gbk
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

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207205642638.png" alt="image-20201207205642638" style="zoom:80%;" />

这玩意可以看做是多个Series的组合。DataFrame的不同列可以是不同的数据类型,如果以Series数组来创建DataFrame，每个Series将成为一行，而不是一列

# 二、审视

## 2.1 访问

以下图为例

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207222452955.png" alt="image-20201207222452955" style="zoom:80%;" />

col，index为列号和行号

colName，indexName为具体值

### 2.1.1 `df[colName]`

根据列名，并以Series的形式返回列

若列名为默认的数字时，colName可以被视为col（其中就col可以表示为列表形式和切片形式）

```python
df['a'] 			#取a列
df.a				#也可
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

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207224248457.png" alt="image-20201207224248457" style="zoom: 65%;" />

### 2.1.5 `df.loc[indexName,colName]`

`df.iloc`只能选取数据表里实际有的行和列，而`df.loc`可以选取没有的行和列，赋值后就可以添加新行或者列

```python
df.loc[:,'c'] 						#选取c列
df.loc[['A','C'],['c','e','f']] 	#选取A,C列，c,e,f行相交数据
df.loc[df['c']=='snake'] 			#选取c列中内容为snake的行数据
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201207230245814.png" alt="image-20201207230245814" style="zoom:70%;" />

### 2.1.6 `df.ix[in,co]`

ix是loc和iloc的混合，既能按索引标签提取，也能按位置进行数 据提取

### 2.1.7 筛选

```python
df.loc[df.index[[1,3]], ['d','f']]	#筛选出索引为1，3行的d，f列
df[df['d'] > 3]						#筛选d（列名）值大于3的行
df[df['d'].isnull()] 				#筛选d（列名）值为空的行

df['A'].isin(['cat'])				#筛选A列中含有cat的行
#输出
a     True
b     True
c    False
d    False
e    False
f     True
g    False
h     True
i    False
j    False
Name: A, dtype: bool
```



## 2.2 查看

### 2.2.1 查看行数、列数

```python
df.shape
```

输出

```python
(4, 10)
```

### 2.2.2 查看整体信息

使用info函数查看数据表的整体信息，包括数据维度、列名称、数据格式和所占空间等信息

```python
df.info()
```

输出

```python
<class 'pandas.core.frame.DataFrame'>
Index: 4 entries, A to D
Data columns (total 10 columns):
 #   Column  Non-Null Count  Dtype 
---  ------  --------------  ----- 
 0   a       4 non-null      object
 1   b       4 non-null      object
 2   c       4 non-null      object
 3   d       3 non-null      object
 4   e       4 non-null      object
 5   f       4 non-null      object
 6   g       4 non-null      object
 7   h       3 non-null      object
 8   i       4 non-null      object
 9   j       4 non-null      object
dtypes: object(10)
memory usage: 352.0+ bytes
```

### 2.2.3 **查看数据格式**

使用dtypes函数来返回数据格式

```python
df.dtypes       #查看数据表各列格式
df['B'].dtype	#查看单列格式
```

输出

```python
a    object
b    object
c    object
d    object
e    object
f    object
g    object
h    object
i    object
j    object
dtype: object
    
dtype('O')
```

### 2.2.4 查看空值

```python
df.isnull()			#检查数据空值
df['h'].isnull()	#检查特定列空值
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209152042577.png" alt="image-20201209152042577" style="zoom:80%;" />

```python
A    False
B     True
C    False
D    False
Name: h, dtype: bool
```

### 2.2.5 查看唯一值

```python
df['a'].unique()	#查看a列中的唯一值
```

输出

```python
array(['cat', 2.5, 1, 'yes'], dtype=object)
```

### 2.2.6 **查看数据表数值**

````python
df.values
````

输出

```python
array([['cat', 'cat', 'snake', 'dog', 'dog', 'cat', 'snake', 'cat',
        'dog', 'dog'],
       [2.5, 3.0, 0.5, nan, 5.0, 2.0, 4.5, nan, 7.0, 3.0],
       [1, 3, 2, 3, 2, 3, 1, 1, 2, 1],
       ['yes', 'yes', 'no', 'yes', 'no', 'no', 'no', 'yes', 'no', 'no']],
      dtype=object)
```

### 2.2.7 查看行、列名称

```python
df.columns	#查看列名称
df.index	#查看行名称
```

输出

```python
Index(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'], dtype='object')
Index(['A', 'B', 'C', 'D'], dtype='object')
```

### 2.2.8 查看前后n行数据

```python
df.head(5)
df.tail(3)
```

## 2.3 统计

以下图为例

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209203305092.png" alt="image-20201209203305092" style="zoom: 80%;" />

### 2.3.1 对数据的统计汇总

只会统计数值型数据

```python
df.describe()
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209203341244.png" alt="image-20201209203341244" style="zoom: 75%;" />

### 2.3.2 排序

```python
df.sort_values(by=['C'])								#按特定列的值升序排序
df.sort_values(by=['B'],ascending=False)				#降序排序
df.sort_values(by=['B', 'C'], ascending=[False, True])	#先按B降序，再按C升序
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209205226758.png" alt="image-20201209205226758" style="zoom:60%;" />

```python
df.sort_index(axis=0，ascending=1)		#按索引列升序排序，需要默认的索引值
```

axis=0（行），1（列）

输出（此处index设置为了’A’）

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209212247769.png" alt="image-20201209212247769" style="zoom: 67%;" />

### 2.3.3 求平均值

```python
df.mean() 		#默认跨行取均值
df.mean(axis=1)	#跨列取均值
```

输出

```python
B    2.75
C    1.90
dtype: float64
    
a    1.75
b    3.00
c    1.25
d    1.50
e    3.50
f    2.50
g    2.75
h    0.50
i    4.50
j    2.00
dtype: float64
```

### 2.3.4 其他

```python
df.corr()		#返回列与列之间的相关系数
df.count()		#返回每一列中的非空值的个数
df.max()		#返回每一列的最大值
df.min()		#返回每一列的最小值
df.median()		#返回每一列的中位数
df.std()		#返回每一列的标准差
```

# 三、预处理

## 3.1 数据清理

所有函数，不赋值不会生效

以下图为例

![image-20201209163600487](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209163600487.png)

### 3.1.1 处理空值

- `dropna(axis=, how=)`：丢弃NaN数据
  - axis：0(按行丢弃)，1(按列丢弃)
  - how：'any'(只要含有NaN数据就丢弃)，'all'(所有数据都为NaN时丢弃)
- `fillna(value=)`：将NaN值都设置为value的值

```python
df.dropna(how='any')					#删除数据表中含有空值的行
df.fillna(value=0)						#使用数字0填充数据表中空值
df['B'].fillna(df['B'].mean())			#使用price均值对NA进行填充
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209164235597.png" alt="image-20201209164235597" style="zoom:67%;" />

### 3.1.2 **清理空格**

```python
df['city']=df['city'].map(str.strip)	#清除city字段中的字符空格
```

### 3.1.3 **大小写转换**

```python
df['A'].str.upper()				#city列大小写转换
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209164710193.png" alt="image-20201209164710193" style="zoom:67%;" />

### 3.1.4 **更改数据格式**

```python
df['C'].astype('int')
```

输出

```python
a    1
b    3
c    2
d    3
e    2
f    3
g    1
h    1
i    2
j    1
Name: C, dtype: int32
```

### 3.1.5 更改行列名称

```python
df.rename(columns={'A': 'Name','C':'Age'})	#更改列名称
df.rename(index={'e': 'eee'})				#更改行名称
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209165738698.png" alt="image-20201209165738698" style="zoom:67%;" />

### 3.1.6 删除重复值

```python
df['A'].drop_duplicates()					#删除A列中有重复值的列
df['A'].drop_duplicates(keep='last')		#删除先出现的重复值
```

输出

```python
a      cat
c    snake
d      dog
Name: A, dtype: object

g    snake
h      cat
j      dog
Name: A, dtype: object
```

### 3.1.7 **数值修改及替换**

```python
df['D'].replace('yes', 'true')
```

输出

```python
a    true
b    true
c      no
d    true
e      no
f      no
g      no
h    true
i      no
j      no
Name: D, dtype: object
```

### 3.1.8 设置索引列

```python
df_inner.set_index('A')
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209212104774.png" alt="image-20201209212104774" style="zoom:67%;" />

## 3.2 数据表合并

以下两张图为例

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209210714655.png" alt="image-20201209210714655" style="zoom:65%;" />

### 3.2.1` .merge()`

```python
df_inner=pd.merge(df1,df2,how='inner') 	#以小表为准
df_outer=pd.merge(df1,df2,how='outer')	#以大表为准
df_left=pd.merge(df1,df2,how='left')	#以左表为准，这里等同于inner_df
df_right=pd.merge(df1,df2,how='right')	#以右表为准,这里等同于outer_df
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209211615829.png" alt="image-20201209211615829" style="zoom:67%;" />

### 3.2.2 `.concat()`

第一个参数：需要合并的矩阵

axis：合并维度，0：按行合并，1：按列合并，默认为0

join：处理非公有 列/行 的方式，inner：去除非公有的 列/行，outer：对非公有的 列/行 进行NaN值填充然后合并

ignore_index：是否重排行索引，若重排，行索引为顺序。默认为0

```python
pd.concat([df1, df2], join='outer', ignore_index=True) 	#按行合并，重排行索引
pd.concat([df1, df2], axis=1, join='inner')				#按列合并
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209213557164.png" alt="image-20201209213557164" style="zoom: 80%;" />

## 3.3 数据分组

### 3.3.1 分类汇总

```python
df_inner.groupby('city').count()								#对所有列进行计数汇总
df_inner.groupby('city')['id'].count()							#对特定的ID列进行计数汇总
df_inner.groupby(['city','pay'])['id'].count()					#对两个字段进行汇总计数
df_inner.groupby('city')['price'].agg([len,np.sum, np.mean])	#对city字段进行汇总并计算price的合计和均值
```

输出

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201209222416782.png" alt="image-20201209222416782" style="zoom:67%;" />



# 四、导入与到导出

## 4.1 导入数据

```python
pd.read_csv(filename)					#从CSV文件导入数据
pd.read_table(filename)					#从限定分隔符的文本文件导入数据
pd.read_excel(filename)					#从Excel文件导入数据
pd.read_sql(query, connection_object)	#从SQL表/库导入数据
pd.read_json(json_string)				#从JSON格式的字符串导入数据
pd.read_html(url)						#解析URL、字符串或者HTML文件，抽取其中的tables表格
pd.read_clipboard()						#从你的粘贴板获取内容，并传给read_table()
```

## 4.2 导出数据

```python
df.to_csv(filename)							#导出数据到CSV文件
df.to_excel(filename)						#导出数据到Excel文件
df.to_sql(table_name, connection_object)	#导出数据到SQL表
df.to_json(filename)						#以Json格式导出数据到文本文件
```
