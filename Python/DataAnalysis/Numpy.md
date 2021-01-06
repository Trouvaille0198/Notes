# 一、数组基础

## 1.1 属性

1. *ndarray.ndim*

   数组的轴（维度）的个数。在Python世界中，维度的数量被称为rank（秩）

2. *ndarray.shape* 

   数组的维度。这是一个整数的元组，表示每个维度中数组的大小。对于有 n 行和 m 列的矩阵，shape 将是 (n,m)。因此，shape 元组的长度就是rank或维度的个数 ndim。

3. *ndarray.size*

   数组元素的总数。这等于 shape 的元素的乘积。

4. *ndarray.dtype* 

   一个描述数组中元素类型的对象。可以使用标准的Python类型创建或指定dtype。另外NumPy提供它自己的类型。例numpy.int32、numpy.int16和numpy.float64。

5. *ndarray.itemsize* 

   数组中每个元素的字节大小。例如，元素为 float64 类型的数组的 itemsize 为8（=64/8），而 complex32 类型的数组的 itemsize 为4（=32/8）。它等于 ndarray.dtype.itemsize 。

6. *ndarray.data*

   该缓冲区包含数组的实际元素。通常，我们不需要使用此属性，因为我们将使用索引访问数组中的元素。

## 1.2 创建

概览

```python
a = np.array([0, 1, 2, 3, 4])
b = np.array((0, 1, 2, 3, 4))
c = np.arange(5)
d = np.linspace(0, 2*np.pi, 5)
```

### 1.2.1 用列表和元组创建数组

 使用array函数

```python
a = np.array([2,3,4])
b = np.array([(1.5,2,3), (4,5,6)])

>>>
	array([2, 3, 4])

	array([[1.5, 2. , 3. ],
       		[4. , 5. , 6. ]])
```

数组类型可以在创建时显示指定

```python
c = np.array([[1, 2], [3, 4]], dtype=complex)

>>>
	array([[1.+0.j, 2.+0.j],
       		[3.+0.j, 4.+0.j]])
```

### 1.2.2 用占位符创建数组

```python
a = np.zeros((3, 4))
b = np.ones((2, 3, 4), dtype=np.int16)	# dtype can also be specified
c = np.empty((2, 3)) 					# uninitialized, output may vary
```

输出

```python
array([[0., 0., 0., 0.],
       [0., 0., 0., 0.],
       [0., 0., 0., 0.]])

array([[[1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1]],

       [[1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1]]], dtype=int16)
array([[1.5, 2. , 3. ],
       [4. , 5. , 6. ]])
```

### 1.2.3 在一定范围内创建数组

#### 1）使用arange函数

输入起始，终止，步长来创建数组

```python
a = np.arange(10, 30, 5)
b = np.arange(0, 2, 0.3)  # it accepts float arguments

>>>
	array([10, 15, 20, 25])
	array([0. , 0.3, 0.6, 0.9, 1.2, 1.5, 1.8])
```

#### 2）使用linspace函数

当arange与浮点参数一起使用时，由于有限的浮点精度，通常不可能预测所获得的元素的数量。出于这个原因，通常最好使用linspace函数来接收我们想要的元素数量的函数，而不是步长（step）

```python
a = np.linspace(0, 2, 9)     # 9 numbers from 0 to 2

>>>
	array([0.  , 0.25, 0.5 , 0.75, 1.  , 1.25, 1.5 , 1.75, 2.  ])
```

### 1.2.4 创建二维数组

用.reshape()方法

创建一个共20个整数、4行5列的二维数组

```python
a = np.arange(20).reshape(4, 5)

>>>
	array([[ 0,  1,  2,  3,  4],
       		[ 5,  6,  7,  8,  9],
       		[10, 11, 12, 13, 14],
       		[15, 16, 17, 18, 19]])
```

### 1.2.5 随机创建

#### 1）使用numpy.random.rand()

`numpy.random.rand(d0, d1, …, dn)`

1. rand函数根据给定维度生成[0,1)之间的数据，包含0，不包含1

2. dn表示每个维度

3. 返回值为指定维度的array

```python
np.random.rand(4, 2)

>>>
	array([[0.98674795, 0.13286586],
       		[0.29918216, 0.31617708],
       		[0.11613039, 0.06952587],
       		[0.854591  , 0.46243232]])
```

#### 2）使用numpy.random.randn()

`numpy.random.randn(d0, d1, …, dn)`

1. randn函数返回一个或一组样本，具有**标准正态分布**。

2. dn表格每个维度

3. 返回值为指定维度的array

4. 没有参数时，返回单个数据

```python
np.random.randn(2, 4)

>>>
	array([[-1.00153189,  2.24079402,  1.60828566, -0.65998837],
       		[ 1.98674251, -0.33065155,  0.48365328,  0.4008861 ]])
```

## 1.3 运算

### 1.3.1 基本运算符

1. 乘积运算符`*`在NumPy数组中按元素进行运算。矩阵乘积可以使用`@`运算符或`dot`函数或方法执行

```python
A = np.array([[1, 1], [0, 1]])
B = np.array([[2, 0], [3, 4]])

A*B
>>>
	array([[2, 0],
       		[0, 4]])

A@B
>>>
	array([[5, 4],
	       [3, 4]])

A.dot(B)
>>>
	array([[5, 4],
	       [3, 4]])
```

1. 某些操作（例如`+=`和`*=`）会更直接更改被操作的矩阵数组而不会创建新矩阵数组
2. 当使用不同类型的数组进行操作时，结果数组的类型对应于更一般或更精确的数组（称为向上转换的行为）

### 1.3.2 特殊运算符

```python
# dot, sum, min, max, cumsum
a = np.arange(10)
print(a.sum())  # >>>45
print(a.min())  # >>>0
print(a.max())  # >>>9
print(a.cumsum())  # >>>[ 0  1  3  6 10 15 21 28 36 45]
```

通过指定axis（列）参数，可以沿数组的指定轴应用操作

```python
b = np.arange(12).reshape(3, 4)
b.sum(axis=0)              # sum of each column

>>>
	array([12, 15, 18, 21])
```

## 1.4 通函数（ufunc）

[数学函数合集](https://www.numpy.org.cn/reference/routines/math.html)

NumPy提供熟悉的数学函数，例如sin，cos和exp。在NumPy中，这些被称为“通函数”。在NumPy中，这些函数在数组上按元素进行运算，产生一个数组作为输出

```python
A = np.arange(3)

np.exp(A)  # 以e为底的指数函数
>>>
	array([1.        , 2.71828183, 7.3890561 ])

np.sqrt(A)  # 开平方根
>>>
	array([0.        , 1.        , 1.41421356])

B = np.array([2., -1., 4.])
np.add(A, B)  # 相加
>>>
	array([2., 0., 6.])

x = np.array([[1, 2], [3, 4]])
y = np.array([[5, 6], [7, 8]])
# Matrix / matrix product; both produce the rank 2 array
print(x.dot(y))
print(np.dot(x, y))

>>>
	[[19 22]
	 [43 50]]
```

## 1.5 切片

### 1.5.1 一维数组

```python
a = np.arange(10)**3

a
>>> 
	array([  0,   1,   8,  27,  64, 125, 216, 343, 512, 729], dtype=int32)

a[2]
>>> 
	8

a[2:5]
>>> 
	array([ 8, 27, 64], dtype=int32)

a[:6:2] = -1000  # from start to position 6, exclusive, set every 2nd element to -1000

a
>>> 
	array([-1000,     1, -1000,    27, -1000,   125,   216,   343,   512,
         	729], dtype=int32)

a[::-1]          # reversed a
>>>
	array([  729,   512,   343,   216,   125, -1000,    27, -1000,     1,
       		-1000], dtype=int32)
```

### 1.5.2 多维数组