# 一、初始化

```python
from pyquery import PyQuery as pq
```

## 1.1 字符初始化

```python
html = '''
<div class="wrap">
    <div id="container">
        <ul class="list">
             <li class="item-0">first item</li>
             <li class="item-1"><a href="link2.html">second item</a></li>
             <li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
             <li class="item-1 active"><a href="link4.html">fourth item</a></li>
             <li class="item-0"><a href="link5.html">fifth item</a></li>
         </ul>
     </div>
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

| 名称              | 例子            | 说明                             |
| ----------------- | --------------- | -------------------------------- |
| .class            | .color          | 选择class='color'的所有元素      |
| #id               | #info           | 选择id='info'的所有元素          |
| *                 | *               | 选择所有元素                     |
| element           | p               | 选择所有的p元素                  |
| element, element  | div, p          | 选择所有的div元素和p元素         |
| element element   | div p           | 选择div标签内的所有p元素         |
| element > element | div > p         | 选择所有父级是 div 元素的 p 元素 |
| [attribute]       | [target]        | 选择带有target属性的所有元素     |
| [attribute=value] | [target=_blank] | 选择target=_blank的所有元素      |

# 三、查找节点

pyquery 的选择结果可能是多个节点，也可能是单个节点，类型都是 ` PyQuery ` 类型，并没有返回像 Beautiful Soup 那样的列表。

所有查找结点的方法都可以加入CSS选择器

## 3.1 子节点

### 3.1.1 子孙节点 

```python
items.find()
```

首先，我们选取 class 为 list 的节点，然后调用了 `find()` 方法，传入 CSS 选择器，选取其内部的 li 节点，最后打印输出。

`find() `方法会将符合条件的所有节点选择出来，结果的类型是 `PyQuery` 类型。

### 3.1.2 直接子节点

```python
items.children()
```

## 3.2 父节点

### 3.2.1 直接父节点

用 parent 方法来获取某个节点的父节点

```python
items.parent()
```

### 3.2.2 祖先节点

```python
items.parents()
```

## 3.3 兄弟节点

选择 class 为 list 的节点内部 class 为 item-0 和 active 的节点

```python
items.siblings()
```

# 四、遍历节点

对于单个节点来说，可以直接打印输出，也可以直接转成字符串

```python
doc = pq(html)
li = doc('.item-0.active')
print(li)
print(str(li))
```

输出

```html
<li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
<li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
```

对于多个节点的结果，需要遍历来获取

```python
doc = pq(html)
lis = doc('li').items()
print(type(lis))
for li in lis:
    print(li, type(li))
```

输出

```html
<class 'generator'>
<li class="item-0">first item</li>
<class 'pyquery.pyquery.PyQuery'>
<li class="item-1"><a href="link2.html">second item</a></li>
<class 'pyquery.pyquery.PyQuery'>
<li class="item-0 active"><a href="link3.html"><span class="bold">third item</span></a></li>
<class 'pyquery.pyquery.PyQuery'>
<li class="item-1 active"><a href="link4.html">fourth item</a></li>
<class 'pyquery.pyquery.PyQuery'>
<li class="item-0"><a href="link5.html">fifth item</a></li>
<class 'pyquery.pyquery.PyQuery'>
```

调用 items() 方法后，会得到一个生成器，遍历一下，就可以逐个得到 li 节点对象了，它的类型也是 PyQuery 类型

# 五、获取信息

## 5.1 获取属性

### 5.1.1 单个节点

#### 1）attr()

```python
a = doc('.item-0.active a')

print(a.attr('href'))
```

选中 class 为 item-0 和 active 的 li 节点内的 a 节点,调用 attr 方法。在这个方法中传入属性的名称，就可以得到这个属性值了

```html
link3.html
```

#### 2）attr属性

```python
print(a.attr.href)
```

### 5.1.2 多个节点

当返回结果包含多个节点时，调用 attr 方法，只会得到第一个节点的属性。需要遍历获得	

```python
for item in a.items():
    print(item.attr('href'))
```

## 5.2 获取文本

### 5.2.1 单个节点

#### 1）text()

```python
a = doc('.item-0.active a')

print(a.text())
```

首先选中一个 a 节点，然后调用 text 方法，就可以获取其内部的文本信息

```html
third item
```

#### 2）html()

获取这个节点内部的 HTML 文本，

```python
print(li.html())
```

输出

```html
<span class="bold">third item</span>
```

### 5.2.2 多个节点

若结果是多个节点：

1. html 方法返回的是第一个 节点的内部 HTML 文本（需要遍历每个节点）
2. text 则返回了所有的 li 节点内部的纯文本，中间用一个空格分割开，即返回结果是一个字符串（不需要遍历）

# 六、DOM操作

## 6.1 addClass()、removeClass()

添加，移除class标签

```python
items.removeClass('active')
items.addClass('active')
```

## 6.2 attr、text、html

```python
items.attr('name', 'link') #属性名，属性值
items.text('changed item')
items.html('<span>changed item</span>')
```

## 6.3 remove

例如，想提取 Hello, World 这个字符串，而不要 p 节点内部的字符串

```python
html = '''
<div class="wrap">
    Hello, World
    <p>This is a paragraph.</p>
 </div>
'''
from pyquery import PyQuery as pq
doc = pq(html)
wrap = doc('.wrap')
wrap.find('p').remove()
print(wrap.text())
```

首先选中 p 节点，然后调用了 remove() 方法将其移除，然后这时 wrap 内部就只剩下 Hello, World 这句话了，然后再利用 text() 方法提取即可

```python
Hello, World
```

