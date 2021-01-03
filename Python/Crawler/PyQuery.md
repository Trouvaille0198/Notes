# 一、初始化

```python
from pyquery import PyQuery as pq
```

## 1.1 字符初始化

```python
html = '''
<div>
    <ul>
         <li class="item-0">first item</li>
         <li class="item-1"><a href="link2.html">second item</a></li>
         <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
         <li class="item-1 active"><a href="link4.html">fourth item</a></li>
         <li class="item-0"><a href="link5.html">fifth item</a></li>
     </ul>
 </div>
'''

doc = pq(html)
```

## 1.2 URL初始化

```python
doc = pq(url="http://www.baidu.com",encoding='utf-8')
# 或
doc = pq(requests.get('http://cuiqingcai.com').text)
```

## 1.3 文件初始化

```python
doc = pq(filename='demo.html')
```

最常用的初始化方式还是以字符串形式传递

# 二、CSS选择器

| 名称              | 例子            | 说明                         |
| ----------------- | --------------- | ---------------------------- |
| .class            | .color          | 选择class='color'的所有元素  |
| #id               | #info           | 选择id='info'的所有元素      |
| *                 | *               | 选择所有元素                 |
| element           | p               | 选择所有的p元素              |
| element, element  | div, p          | 选择所有的div元素和p元素     |
| element element   | div p           | 选择div标签内的所有p元素     |
| [attribute]       | [target]        | 选择带有target属性的所有元素 |
| [attribute=value] | [target=_blank] | 选择target=_blank的所有元素  |

# 三、查找节点

pyquery 的选择结果可能是多个节点，也可能是单个节点，类型都是` PyQuery `类型，并没有返回像 Beautiful Soup 那样的列表。

## 3.1 子节点

### 3.1.1 子孙节点 

```python
items = doc('.list')
lis = items.find('li')
```

首先，我们选取 class 为 list 的节点，然后调用了 `find()` 方法，传入 CSS 选择器，选取其内部的 li 节点，最后打印输出。

`find() `方法会将符合条件的所有节点选择出来，结果的类型是 `PyQuery` 类型。

### 3.1.2 直接子节点

```python
lis = items.children('li')
```

## 3.2 父节点

### 3.2.1 直接父节点

用 parent 方法来获取某个节点的父节点

```python
items = doc('.list')
container = items.parent()
```

## 3.3 兄弟节点

