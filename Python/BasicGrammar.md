# 一、基本语法

## 1.1 if语句

格式

```python
if <condition1>:
    <statement1>
elif < condition2>:
    <statement2>
elif < condition3>:
    <statement3>
else:
    <statement4>
```

注意冒号和缩进

## 1.2 循环

### 1.2.1 for循环

#### 1) 格式

```python
for < variable> in < sequence >:
    <statements>
else:
    <statements>
```

#### 2) 特殊语句

- **break** 语句可以跳出 for 和 while 的循环体。如果你从 for 或 while 循环中终止，任何对应的循环 else 块将不执行
- **continue** 语句被用来告诉 Python 跳过当前循环块中的剩余语句，然后继续进行下一轮循环

#### 3) 迭代

如果给定一个list或tuple，我们可以通过for循环来遍历这个list或tuple，这种遍历我们称为迭代（Iteration）。在Python中，迭代是通过for ... in来完成的。Python的for循环不仅可以用在list或tuple上，还可以作用在其他可迭代对象上

1. 默认情况下，dict迭代的是key。如果要迭代value，可以用for value in d.values()，如果要同时迭代key和value，可以用`for k, v in d.items()`

```python
>>> d = {'a': 1, 'b': 2, 'c': 3}
>>> for key in d:
...     print(key)
...
a
c
b
```

2. 由于字符串也是可迭代对象，因此，也可以作用于for循环

```python
>>> for ch in 'ABC':
...     print(ch)
...
A
B
C
```

如何判断一个对象是可迭代对象呢？方法是通过collections模块的Iterable类型判断

```python
>>> from collections import Iterable
>>> isinstance('abc', Iterable) # str是否可迭代
True
>>> isinstance([1,2,3], Iterable) # list是否可迭代
True
>>> isinstance(123, Iterable) # 整数是否可迭代
False
```

### 1.2.2 while循环

```python
while <condition>:
    <statements>
```

## 1.3 函数

## 1.3.1 定义

```python
def 函数名（参数列表）:
    函数体
```

## 1.3.2 参数

### 1） 默认参数

必选参数在前，默认参数在后，否则Python的解释器会报错

当函数有多个参数时，把变化大的参数放前面，变化小的参数放后面。变化小的参数就可以作为默认参数

### 2）可变参数

传入的参数个数可变

1. 传列表、元组

```python
def calc(numbers):
    
calc([1, 2, 3])
calc((1, 3, 5, 7))
```

2. 用*号

```python
def calc(*numbers)

calc(1, 2)
```

*numbers表示把number这个list的所有元素作为可变参数传进去。这种写法相当有用，而且很常见

### 3）关键字参数

键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict

```python
def func(name, age, **kw)

extra = {'city': 'Beijing', 'job': 'Engineer'}
func('Jack', 24, city=extra['city'], job=extra['job'])
func('Jack', 24, **extra)
```

\*\*extra表示把extra这个dict的所有key-value用关键字参数传入到函数的\*\*kw参数

### 4）补充

*args是可变参数，args接收的是一个tuple

**kw是关键字参数，kw接收的是一个dict

# 二、列表

## 2.1 基本语句

### 2.1.1 声明列表

例

```python
favorate_singers = ['Mika','Jay Chou','Bruno Mars','Ed Sheeran']
```

### 2.1.2 添加列表元素

1. 在列表末尾添加元素

```python
列表名.append(元素值)
```

2. 在列表中插入元素

  ```python
列表名.insert(索引数，元素值)
  ```

### 2.1.3 删除列表元素

1. 知晓索引并将其删除

```python
 del 列表名[索引数]
```

2. 删除元素并将其弹出

```python
列表名.pop(索引数)	#括号内为空，则弹出最后一个元素
                     #元素在删除的过程中，可用新变量来储存：value=列表名.pop(索引数)
```

3. 根据值删除元素

```python’
列表名.remove(元素值)               #只删除第一个指定的值，要删除多个相同值需使用循环
```

### 2.1.4 组织列表

#### 1）按照首字母顺序排序列表(永久性）

```python
列表名.sort()	#反向排序：列表名.sort(reverse=True)
```

#### 2）按照首字母顺序排序列表(临时性)

```python
sorted(列表名)
```

#### 3）倒着排序列表(永久性)

```python
列表名.reverse()	#恢复的办法，再来一次reverse()
```

#### 4）确定列表的长度

```python
len(列表名)
```

### 2.3.5 操作列表

#### 1）遍历列表

```python
L=[1,2,3,4,5]
for i in range(len(L)):
     L[i]+=10         
print(L) 
               #等效于
L=[ ]
for i in range(1,6):
	L.append(i+10)
print(L)
```

#### 2）列表解析

```python
L=[1,2,3,4,5]
L=[x+10 for x in L]     #result:[11,12,13,14,15]
```

#### 3）创建切片

参数 [start_index:  stop_index:  step] ：

   	 start_index是切片的起始位置索引，不提供时默认从头
   	
   	 stop_index是切片的结束位置（**不包括**）索引，不提供时默认至尾,可为负
   	
   	 step为步长，可以不提供，默认值是1

### 2.3.6 复制列表/创建列表副本

 用切片复制

```python
List2 = List1[:]
```

### 2.3.7 检查元素是否在列表中

```python
List = [a,b,c,d,e]
if a in List
if a not in List
```

## 2.2 元组

概念：不可变的列表，用圆括号来标识（tuple）

### 2.2.1 定义元组

 例

```python
tup1 = ('physics', 'chemistry', 1997, 2000)
tup2 = (1, 2, 3, 4, 5 )
tup3 = "a", "b", "c", "d"
```

### 2.2.2注意

1. 元组本身不可改变，但是可以给元组变量赋值
2. 元组中只包含一个元素时，需要在元素后面添加逗号

```python
tup1 = (50,)
```

3. 可以对元组进行连接组合       

 ```python
tup1 =  
tup2 = ('abc', 'xyz') 
tup3 = tup1 + tup2
 ```

## 2.3 生成器

### 2.3.1 定义

在Python中，一边循环一边计算的机制，称为生成器（generator）

生成器是一个特殊的程序，可以被用作控制循环的迭代行为，python中生成器是迭代器的一种，使用yield返回值函数，每次调用yield会暂停，而可以使用`next()`函数和`send()`函数恢复生成器

生成器类似于返回值为数组的一个函数，这个函数可以接受参数，可以被调用，但是，不同于一般的函数会一次性返回包括了所有数值的数组，生成器一次只能产生一个值，这样消耗的内存数量将大大减小，而且允许调用函数可以很快的处理前几个返回值，因此生成器看起来像是一个函数，但是表现得却像是迭代器

### 2.3.2 创建

#### 1）把一个列表生成式的[]中括号改为（）小括号

```python
l = [x*x for x in range(10)]
g = (x*x for x in range(10))
```

1. 直接打印g的结果

```python
<generator object <genexpr> at 0x000002A4CBF9EBA0>
```

2. 打印值

   如果要一个个打印出来，可以通过next（）函数获得generator的下一个返回值

```python
print(next(g))
print(next(g))
print(next(g))
```

​			计算出最后一个元素，没有更多的元素时，会抛出StopIteration的错误

​		或使用for循环

```python
for i in g:
    print(i)
```

#### 2）构建函数

如果一个函数定义中包含yield关键字，那么这个函数就不再是一个普通函数，而是一个generator

```python
def generator(max):
    x = 1
    while x <= max:
        yield x**2
        x += 1
    return 'done'

g = generator(4)
```

## 2.4 技巧

1. 索引数从0开始
2. 将索引指定为-1，可以返回最后一个列表元素
3. 负数索引返回离列表末尾相应距离的元素，如print(list[-3:])即打印list的最后三个元素

![image-20201206215555032](https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201206215555032.png)

4. 在if语句和while语句中，将列表名用在条件表达式中时，列表包含至少一个元素，则返回True；列表为空返回False

5. 关于切片

   - 元组（tuple）也是一种list，唯一区别是tuple不可变。因此，tuple也可以用切片操作，只是操作的结果仍是tuple

     ```python
     >>> (0, 1, 2, 3, 4, 5)[:3]
     (0, 1, 2)
     ```

   - 字符串'xxx'也可以看成是一种list，每个元素就是一个字符。因此，字符串也可以用切片操作，只是操作结果仍是字符串

     ```python
     >>> 'ABCDEFG'[:3]
     'ABC'
     >>> 'ABCDEFG'[::2]
     'ACEG'
     ```

6. 运用列表生成式

   - 要生成[1x1, 2x2, 3x3, ..., 10x10]

     ```python
     [x * x for x in range(1, 11)]
     ```

   - 筛选出仅偶数的平方

     ```python
     [x * x for x in range(1, 11) if x % 2 == 0]
     ```

   - 生成全排列

     ```python
     [m + n for m in 'ABC' for n in 'XYZ']
     ```

   - 列出当前目录下的所有文件和目录名

     ```python
     >>> import os # 导入os模块
     >>> [d for d in os.listdir('.')] # os.listdir可以列出文件和目录
     ['.emacs.d', '.ssh', '.Trash', 'Adlm', 'Applications', 'Desktop', 'Documents', 'Downloads', 'Library', 'Movies', 'Music', 'Pictures', 'Public', 'VirtualBox VMs', 'Workspace', 'XCode']
     ```

   - 把一个list中所有的字符串变成小写

     ```python
     >>> L = ['Hello', 'World', 'IBM', 'Apple']
     >>> [s.lower() for s in L]
     ['hello', 'world', 'ibm', 'apple']
     ```

# 三、字典

## 3.1 基本语句

- 声明字典

```python
alien_0 = {'color':'green','points':5}         #字典是一系列键-值对
```

- 访问字典中的值

```python
print(alien_0['points'])
```

- 添加键-值对

```python
alien_0 ['x_position']=10
alien_0 ['y_position']=25
```

- 修改字典中的值

```python
alien_0['color'] = 'yellow'
```

- 删除键-值对

```python
del alien_0['color']
```

遍历字典

- 遍历键-值对

```python
for key,value in alien_0.items():
    print(key+':'+value+'\n')                #返回顺序与储存顺序无关
```

- 遍历键

```python
for key in alien_0.keys():                  #当要遍历所有键时，可去".keys()"
```

- 遍历值

```python
for value in alien_0.values(): 
```

- 有顺序地遍历

  使用sorted()函数，如：

```python
for key in sorted(alien_0.keys()):
```

- 合并遍历中的重复项

  使用set()函数，如：

```python
for value in set(alien_0.values()): 
```

## 3.2 集合

### 3.2.1 定义

集合（set）是一个无序的不重复元素序列

set和dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在set中，没有重复的key

### 3.2.2 基本操作

- 初始化

```python
s1 = set('cheershopa')         
s2 = set([1, 2, 3, 34, 15, 25, 35, 45, 75])         #传列表
```

- 添加值

```python
s.add(8)
```

- 删除值

```python
s.remove(8)
```

- 交集、并集

```python
s1 & s2
s1 | s2
```

### 3.2.3 嵌套

定义：列表中嵌套字典，字典中嵌套列表，字典中嵌套字典

#### 1）在列表中存储字典

```python
aliens=[]
for new_alien in range(30):
    new_alien={'color':'green','speed':'slow'}
    aliens.append(new_alien)
```

#### 2）在字典中存储列表

```python
favorate_languages={
       'Trouvaille':['C++'],
       'Nick':['Python'],
       'Leo':['Java','Python'],
       'Seamus':['Javascript','C++','Ruby']
   }
for x,y in favorate_languages.items( ):
    if len(y)>=2:
        print(x+"'s favorate are")
        for Y in y:
            print(Y)
     else: 
        print(x+"'s favorate is")
        for Y in y:
            print(Y)
```

#### 3）在字典中存储字典

```python
users={
    'Trouvaille':{
        'gender':'male',
        'location':'Hangzhou'
    },

    'Ketchup_Lover':{
        'gender':'male',
        'location':'Shanghai'
    }
}

for x,y in users.items():
    print(x+':')
    print("\t"+y['gender']+' , '+y['location'])
```

## 3.3 相关函数

### 3.3.1 get()

- 说明：返回指定键的值，如果值不在字典中返回默认值None

- 语法

```python
dict.get(key, default=None)
```

- 参数
  - key -- 字典中要查找的键
  - default -- 如果指定键的值不存在时，返回该默认值

### 3.3.2 len()

- 说明：计算字典元素个数，即键的总数。

- 语法

```python
len(dict)
```

## 3.4 其他技巧

1. 通常习惯声明一个空字典以便添加键-值对
2. 字典通常储存一个对象的多种信息，也可以储存多个对象的同一种信息

# 四、类

## 4.1 基本语句

### 4.1.1 创建类

```python
class Restaurant():
    def __init__(self, name, type):
        self.name = name
        self.type = type
        self.customer_number = 0
```

### 4.1.2 创建方法

```python
def describe_rest(self):
    print("The restaurant's name is " + self.name.title())
    print("The restaurant's type is " + self.type.title())

def open_rest(self):
    print("This restaurant is opening")
```

### 4.1.3 使用类和实例

```python
rest1 = Restaurant('KFC', 'snack bar')
```

### 4.1.4 调用方法

```python
rest1.describe_rest()
rest1.open_rest()
```

## 4.2 继承

### 4.2.1 子类

```python
class IceCreamStand(Restaurant):
      def __init__(self,name,type):
          super().__init__(name,type)                                        #super()用来继承父类的属性                                                                                            #父类也称超类(superclass)
          self.flavours=['strawberry','chocolate','milk','matcha']           #为子类定义的属性
```

### 4.2.2 给子类定义方法

```python
def describe_flavour(self):
print("There're several kinds of flavours which are",end=' ')
for flavour in self.flavours:
    print(flavour,end=' ')
```

### 4.2.3 使用子类和实例 

```python
rest2=IceCreamStand('Dairy Queen','Ice Cream Stand')
rest2.describe_rest()
rest2.describe_flavour()
```

## 4.3 导入

假若有 Car 类, ElectricCar 类于 car.py 模块中

- 导入单个类

```python
from car import Car
```

- 导入多个类

```python
from car import Car, ElectricCar
```

- 导入整个模块

```python
import car                  #需用句点表示法
```

- 导入模块中的所有类

```python
from car import *
```

必要时，也允许从一个模块中导入另一个模块来构建子类

### 4.3.1 关于 `if __name__ == '__main__'`

这是个 Python 的语法，**name** 是当前模块名，当模块被直接运行时模块名为 **main** 。这句话的意思就是，当模块被直接运行时，以下代码块将被运行，当模块是被导入时，代码块不被运行。
可以用作测试，也可以用作模板

# 五、文件

## 5.1 读取文件

### 5.1.1 全部读取

使用.read() 

```python
with open(filename) as file_object:
      contents = file_object.read()        #使用.read()读取文件的全部内容
      print(contents.rstrip())             #使用.rstrip()来剥除.read()造成的末尾空字符串
```

### 5.1.2 逐行读取

遍历

```python
with open(filename) as file_object:
    for line in file_object:
        print(line.rstrip())               #使用.rstrip()来剥除文件每行末尾的换行符
```

### 5.1.3 创建一个包含文件各行内容的列表

使用 .readlines()  

```python
with open(filename) as file_object:
    lines = file_object.readlines()       #使用.readlines() 从文件中读取每一行并存储到一个列表中

for line in lines:
    print(line.strip())
```

### 5.1.4 使用文件内容并将文件的空格全部移除

```python
with open(filename) as file_object:
    lines=file_object.readlines()

pi_string=''
for line in lines:
    pi_string+=line.strip()                 #使用.strip()将每行空格全部除去

print(pi_string)
print(pi_string[:10] + '...')
print(len(pi_string))
```

## 5.2 写入文件

### 5.2.1 写入空文件

```python
filename = 'text_files\programming.txt'

with open(filename, 'w') as file_object:
    file_object.write('Heya!\n')                   #write()不会自动添加换行符，需手动添加
```

### 5.2.2 附加到文件

```python
filename = 'text_files\programming.txt'

with open(filename, 'a') as file_object:            #'a'表示以附加模式打开文件
    file_object.write('Greeting!\n') 
```

## 5.3 其他打开方式

- r：以只读方式打开文件。文件的指针将会放在文件的开头。这是默认模式。
- rb：以二进制只读方式打开一个文件。文件指针将会放在文件的开头。
- r+：以读写方式打开一个文件。文件指针将会放在文件的开头。
- rb+：以二进制读写方式打开一个文件。文件指针将会放在文件的开头。
- w：以写入方式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- wb：以二进制写入方式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- w+：以读写方式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- wb+：以二进制读写格式打开一个文件。如果该文件已存在，则将其覆盖。如果该文件不存在，则创建新文件。
- a：以追加方式打开一个文件。如果该文件已存在，文件指针将会放在文件结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，则创建新文件来写入。
- ab：以二进制追加方式打开一个文件。如果该文件已存在，则文件指针将会放在文件结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，则创建新文件来写入。
- a+：以读写方式打开一个文件。如果该文件已存在，文件指针将会放在文件的结尾。文件打开时会是追加模式。如果该文件不存在，则创建新文件来读写。
- ab+：以二进制追加方式打开一个文件。如果该文件已存在，则文件指针将会放在文件结尾。如果该文件不存在，则创建新文件用于读写。

## 5.4 用json处理数据

### 5.4.1 json格式

对象：它在 JavaScript 中是使用花括号 {} 包裹起来的内容，数据结构为 {key1：value1, key2：value2, ...} 的键值对结构。在面向对象的语言中，key 为对象的属性，value 为对应的值。键名可以使用整数和字符串来表示。值的类型可以是任意类型。

数组：数组在 JavaScript 中是方括号 [] 包裹起来的内容，数据结构为 ["java", "javascript", "vb", ...] 的索引结构。在 JavaScript 中，数组是一种比较特殊的数据类型，它也可以像对象那样使用键值对，但还是索引用得多。同样，值的类型可以是任意类型。

一个 JSON 对象可以写为如下形式：

```json
[{
    "name": "Bob",
    "gender": "male",
    "birthday": "1992-10-18"
}, {
     "name": "Selina",
    "gender": "female",
    "birthday": "1995-10-18"
}]
```

值得注意的是，JSON 的数据需要用双引号来包围，不能使用单引号

### 5.4.2 导入模块

```python
import json
```

### 5.4.3 存储数据

```python
filename = 'name.json'
with open(filename, 'w') as f_obj:
        json.dump(name, f_obj)                            #name为要储存的数据
```

### 5.4.4 读取数据

使用.loads() 

```python
filename = 'name.json'
with open(filename) as f_obj:
        name = json.loads(f_obj)                         #将json中的数据读到name中
```

使用 loads 方法将字符串转为 JSON 对象。由于最外层是中括号，所以最终的类型是列表类型。

### 5.4.5 输出数据

调用 dumps 方法将 JSON 对象转化为字符串

```python
import json

data = [{
    'name': 'Bob',
    'gender': 'male',
    'birthday': '1992-10-18'
}]
with open('data.json', 'w') as file:
    file.write(json.dumps(data))
```

利用 dumps 方法，我们可以将 JSON 对象转为字符串，然后再调用文件的 write 方法写入文本

如果想保存 JSON 的格式，可以再加一个参数 indent，代表缩进字符个数

```python
with open('data.json', 'w') as file:
    file.write(json.dumps(data, indent=2))
```

为了输出中文，还需要指定参数 ensure_ascii 为 False，另外还要规定文件输出的编码

```python
with open('data.json', 'w', encoding='utf-8') as file:
    file.write(json.dumps(data, indent=2, ensure_ascii=False))
```

