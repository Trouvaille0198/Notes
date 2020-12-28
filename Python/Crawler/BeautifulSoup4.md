# 一、基本操作

## 1.1 导入

```python
from bs4 import BeautifulSoup
html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>

<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>

<p class="story">...</p>
"""
soup = BeautifulSoup(html_doc,"html.parser")
```

| 解析器           | 使用方法                                                     | 优势                                                  | 劣势                                            |
| ---------------- | ------------------------------------------------------------ | ----------------------------------------------------- | ----------------------------------------------- |
| Python标准库     | `BeautifulSoup(markup, "html.parser")`                       | Python的内置标准库执行速度适中文档容错能力强          | Python 2.7.3 or 3.2.2)前 的版本中文档容错能力差 |
| lxml HTML 解析器 | `BeautifulSoup(markup, "lxml")`                              | 速度快文档容错能力强                                  | 需要安装C语言库                                 |
| lxml XML 解析器  | `BeautifulSoup(markup, ["lxml-xml"])``BeautifulSoup(markup, "xml")` | 速度快唯一支持XML的解析器                             | 需要安装C语言库                                 |
| html5lib         | `BeautifulSoup(markup, "html5lib")`                          | 最好的容错性以浏览器的方式解析文档生成HTML5格式的文档 | 速度慢不依赖外部扩展                            |

## 1.2 标准缩进格式

```python
print(soup.prettify())
```

输出

```html
<html>
 <head>
  <title>
   The Dormouse's story
  </title>
 </head>
 <body>
  <p class="title">
   <b>
    The Dormouse's story
   </b>
  </p>
  <p class="story">
   Once upon a time there were three little sisters; and their names were
   <a class="sister" href="http://example.com/elsie" id="link1">
    Elsie
   </a>
   ,
   <a class="sister" href="http://example.com/lacie" id="link2">
    Lacie
   </a>
   and
   <a class="sister" href="http://example.com/tillie" id="link3">
    Tillie
   </a>
   ;
and they lived at the bottom of a well.
  </p>
  <p class="story">
   ...
  </p>
 </body>
</html>
```

# 二、对象

## 2.1 Tag

每个标签节点就是一个Tag对象

```python
soup.head
soup.a 		#输出soup中的第一个a标签
soup.p.b  	#p下的b标签
```

输出

```html
<head><title>The Dormouse's story</title></head>
<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>
<b>The Dormouse's story</b>
```

以下是Tag对象的部分属性

### 2.1.1 .name

标签名属性

```python
soup.head.name
soup.a.name
```

输出

```html
head
a
```

### 2.1.2 .string

文本内容属性

```python
soup.head.string
soup.a.string
```

输出

```python
The Dormouse's story
Elsie
```

### 2.1.3 [‘attributes’]

标签指定属性属性

```python
soup.a['id']	#返回字符串
soup.a['class']	#多值属性返回list
```

返回列表

```
link1
['sister'] 
```

如果转换的文档是XML格式,那么tag中不包含多值属性

### 2.1.4 .attrs

```python
soup.a.attrs
```

输出字典

```python
{'href': 'http://example.com/elsie', 'class': ['sister'], 'id': 'link1'}
```

## 2.2 NavigableString

字符串常被包含在tag内.Beautiful Soup用 `NavigableString` 类来包装tag中的字符串

直接使用 *.stirng* 即可获取

### 2.2.1 将其转换为 unicode 字符串

```python
uni_str = unicode(soup.head.string) #在python3中不适用
uni_str = str(soup.head.string)
```

### 2.2.2 replace_with()

tag中包含的字符串不能编辑,但是可以被替换成其它的字符串

```python
soup.head.string.replace_with('Harry potter')
```

## 2.3 BeautifulSoup

`BeautifulSoup` 对象表示的是一个文档的全部内容

### 2.3.1 .name

`BeautifulSoup` 对象包含了一个值为 “[document]” 的特殊属性，用`.name`调用

```python
soup.name
```

输出

```html
'[document]'
```

## 2.4 Comment

`Comment` 对象是一个特殊类型的 `NavigableString` 对象，是文档的注释部分

```python
markup = "<b><!--Hey, buddy. Want to buy a used parser?--></b>"
soup = BeautifulSoup(markup)
comment = soup.b.string
type(comment)
```

当它出现在HTML文档中时, `Comment` 对象会使用特殊的格式输出

```html
bs4.element.Comment
```

# 三、遍历文档树

遍历文档树，就是是从根节点 html 标签开始遍历，直到找到目标元素为止，

通过遍历文档树的方式获取标签节点可以直接通过 `.标签名`的方式获取

- 缺陷
  - 如果要找的内容在文档的末尾，那要遍历整个文档才能找到它，速度上就慢了
  - 只能获取到与之匹配的第一个子节点

## 3.1 子节点

### 3.1.1 .contents

#### 1）Tag

Tag`的 `.contents` 属性可以将tag的子节点以列表的方式输出

```python
soup.body.contents
soup.body.contents[1]
```

以列表输出

```html
['\n',
 <p class="title"><b>The Dormouse's story</b></p>,
 '\n',
 <p class="story">Once upon a time there were three little sisters; and their names were
 <a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a> and
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>;
 and they lived at the bottom of a well.</p>,
 '\n',
 <p class="story">...</p>,
 '\n']

<p class="title"><b>The Dormouse's story</b></p>
```

#### 2）NavigableString

字符串`NavigableString`没有 `.contents` 属性,因为字符串没有子节点

```python
soup.head.string.cotents
```

报错

```python
AttributeError: 'NavigableString' object has no attribute 'cotents'
```

#### 3）BeautifulSoup

`BeautifulSoup` 对象本身一定会包含子节点,也就是说`<html>`标签也是 `BeautifulSoup` 对象的子节点

```python
soup.contents
```

输出

```python
['\n',
 <html><head><title>Harry potter</title></head>
 <body>
 <p class="title"><b>The Dormouse's story</b></p>
 <p class="story">Once upon a time there were three little sisters; and their names were
 <a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a> and
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>;
 and they lived at the bottom of a well.</p>
 <p class="story">...</p>
 </body></html>]
```

### 3.2.2 .children

通过tag的 `.children` 生成器,可以对tag的子节点进行循环

```python
for child in soup.body.children:
    print(child)
```

输出

```html


<p class="title"><b>The Dormouse's story</b></p>


<p class="story">Once upon a time there were three little sisters; and their names were
<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a> and
<a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>


<p class="story">...</p>
```

### 3.3.3 .descendants

`.contents` 和 `.children` 属性仅包含tag的直接子节点，而`.descendants` 生成器可以对所有tag的子孙节点进行递归循环 

```python
for child in soup.body.descendants:
    print(child)
```

输出

```html
<p class="title"><b>The Dormouse's story</b></p>
<b>The Dormouse's story</b>
The Dormouse's story


<p class="story">Once upon a time there were three little sisters; and their names were
<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a> and
<a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>
Once upon a time there were three little sisters; and their names were

<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>
Elsie
,

<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>
Lacie
 and

<a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>
Tillie
;
and they lived at the bottom of a well.


<p class="story">...</p>
...
```

## 3.2 父节点

### 3.2.1 .parent

通过 `.parent` 属性来获取某个元素的父节点

```python
soup.title.parent
soup.title.string.parent 	#字符串也有父节点
type(soup.html.parent)		#文档的顶层节点比如<html>的父节点是 BeautifulSoup 对象
print(soup.parent)			#BeautifulSoup 对象的 .parent 是None
```

输出

```html
<head><title>Harry potter</title></head>
<title>Harry potter</title>
bs4.BeautifulSoup
None
```

### 3.2.2 .parents

通过元素的 `.parents` 生成器可以递归得到元素的所有父辈节点

```python
for parent in soup.b.parents:
    print(parent.name)
```

## 3.3 兄弟节点

### 3.3.1 .next_sibling 和 .previous_sibling

```python
soup.a.next_sibling   				#真实结果是第一个<a>标签和第二个<a>标签之间的顿号和换行符
soup.a.next_sibling.next_sibling
```

输出

```html
',\n'
<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>
```

### 3.3.2 .next_siblings 和 .previous_siblings

通过 `.next_siblings` 和 `.previous_siblings` 生成器可以对当前节点的兄弟节点迭代输出

```python
for sibling in soup.a.next_siblings:
    print(repr(sibling))
```

输出

```html
',\n'
<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>
' and\n'
<a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>
';\nand they lived at the bottom of a well.'
```

# 四、搜索文档树

搜索文档树是通过指定标签名来搜索元素，另外还可以通过指定标签的属性值来精确定位某个节点元素

最常用的两个方法就是 find 和 find_all。这两个方法在 BeatifulSoup 和 Tag 对象上都可以被调用

## 4.1 过滤器

## 4.2 find_all()

```python
find_all( name , attrs , recursive , string , **kwargs )
```

`find_all()` 方法搜索当前tag的所有tag子节点,并判断是否符合过滤器的条件