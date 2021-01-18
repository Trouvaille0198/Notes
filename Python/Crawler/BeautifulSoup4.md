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

输出

```html
p
body
html
[document]
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

过滤器贯穿整个搜索的API。过滤器可以被用在tag的name中,节点的属性中,字符串中或他们的混合中

### 4.1.1 字符串

在搜索方法中传入一个字符串参数,Beautiful Soup会查找与字符串完整匹配的内容

```python
soup.find_all('a')
```

输出

```html
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
```

### 4.1.2 正则表达式

Beautiful Soup会通过正则表达式的 `match()` 来匹配内容

下面代码找出所有名字中包含”t”的标签

```python
import re
for tag in soup.find_all(re.compile("t")):
    print(tag.name)
```

输出

```html
html
title
```

### 4.1.3 列表

Beautiful Soup会将与列表中任一元素匹配的内容返回

下面代码找到文档中所有<a>标签和<b>标签

```python
soup.find_all(["a", "b"])
```

输出

```html
[<b>The Dormouse's story</b>,
 <a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
```

### 4.1.4 True

`True` 可以匹配任何值

下面代码查找到所有的tag名

```python
for tag in soup.find_all(True):
    print(tag.name)
```

输出

```html
html
head
title
body
p
b
p
a
a
a
p
```

### 4.1.5 方法

如果没有合适过滤器,那么还可以定义一个方法,方法只接受一个元素参数 [[4\]](https://beautifulsoup.readthedocs.io/zh_CN/v4.4.0/#id91) ,如果这个方法返回 `True` 表示当前元素匹配并且被找到,如果不是则反回 `False`

下面方法校验了当前元素,如果包含 `class` 属性却不包含 `id` 属性,那么将返回 `True`

```python
def has_class_but_no_id(tag):
    return tag.has_attr('class') and not tag.has_attr('id')
soup.find_all(has_class_but_no_id)
```

输出

```html
[<p class="title"><b>The Dormouse's story</b></p>,
 <p class="story">Once upon a time there were three little sisters; and their names were
 <a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a> and
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>;
 and they lived at the bottom of a well.</p>,
 <p class="story">...</p>]	
```

通过一个方法来过滤一类标签属性的时候, 这个方法的参数是要被过滤的属性的值, 而不是这个标签

下面的例子是找出 `href` 属性不符合指定正则的 `a` 标签

```python
def not_lacie(href):
        return href and not re.compile("lacie").search(href)
soup.find_all(href=not_lacie)
```

输出

```html
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
```

## 4.2 find_all()

```python
find_all( name , attrs , recursive , string , **kwargs )
```

`find_all()` 方法搜索当前tag的所有tag子节点,并判断是否符合过滤器的条件

任意参数的值可以是任一类型的过滤器，字符串，正则表达式，列表，方法或是 `True` 

### 4.2.1 name

`name` 参数可以查找所有名字为 `name` 的tag，字符串对象会被自动忽略掉

```python
soup.find_all("a")
```

输出

```html
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
```

### 4.2.2 keyword

1. 如果一个指定名字的参数不是搜索内置的参数名,搜索时会把该参数当作指定名字tag的属性来搜索

```python
soup.find_all(id='link2')
soup.find_all("a",'sister',href=re.compile('^.*?la'))
soup.find_all(id=True)
```

输出

```html
[<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>]
[<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>]
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
```

2. 有些tag属性在搜索不能使用,比如HTML5中的 data-* 属性，但是可以通过 `find_all()` 方法的 `attrs` 参数定义一个字典参数来搜索包含特殊属性的tag

3. 标识CSS类名的关键字 `class` 在Python中是保留字,使用 `class` 做参数会导致语法错误.从Beautiful Soup的4.1.1版本开始,可以通过 `class_` 参数搜索有指定CSS类名的tag

```python
soup.find_all("a", class_="sister")

def has_six_characters(css_class):
    return css_class is not None and len(css_class) == 6
soup.find_all(class_=has_six_characters)                 #与第一种方法输出相同结果
```

输出

```html
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
 <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
```

### 4.2.3 string

通过 `string` 参数可以搜搜文档中的字符串内容

```python
soup.find_all(string="Elsie") #单独使用时，返回字符串
soup.find_all("a", string="Elsie") #与其他参数混合使用时，返回对应的Tag
```

输出

```html
['Elsie']
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>]
```

### 4.2.4 limit

`find_all()` 方法返回全部的搜索结构,如果文档树很大那么搜索会很慢.如果我们不需要全部结果,可以使用 `limit` 参数限制返回结果的数量

```python
soup.find_all("a", limit=2)
```

文档树中有3个tag符合搜索条件,但结果只返回了2个,因为我们限制了返回数量

```html
[<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
 <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>]
```

### 4.2.5 recursive

调用tag的 `find_all()` 方法时,Beautiful Soup会检索当前tag的所有子孙节点,如果只想搜索tag的直接子节点,可以使用参数 `recursive=False`

```python
soup.html.find_all("title")
# [<title>The Dormouse's story</title>]

soup.html.find_all("title", recursive=False)
# []
```

### 4.2.6 简写方式

`find_all()` 几乎是Beautiful Soup中最常用的搜索方法,所以我们定义了它的简写方法. `BeautifulSoup` 对象和 `tag` 对象可以被当作一个方法来使用,这个方法的执行结果与调用这个对象的 `find_all()` 方法相同

下面代码是等价的

```python
soup.find_all("a")
soup("a")

soup.title.find_all(string=True)
soup.title(string=True)
```

## 4.3 find()

find( name , attrs , recursive , string,  **kwargs )

`find()` 方法将返回文档中符合条件的第一个tag

下面两行代码是等价的

```python
soup.find_all('title', limit=1)
# [<title>The Dormouse's story</title>]

soup.find('title')
# <title>The Dormouse's story</title>
```

唯一的区别是 `find_all()` 方法的返回结果是值包含一个元素的列表,而 `find()` 方法直接返回结果

`find_all()` 方法没有找到目标是返回空列表, `find()` 方法找不到目标时,返回 `None`

`soup.head.title` 是tag的名字方法的简写.这个简写的原理就是多次调用当前tag的 `find()` 方法

```python
soup.head.title
# <title>The Dormouse's story</title>

soup.find("head").find("title")
# <title>The Dormouse's story</title>
```

## 4.4 其他方法

1. find_parents()和find_parent()

   前者返回所有祖先节点，后者返回直接父节点。

   ```python
   p_story = soup.find(class_='story')
   for i in p_story.find_parents():
       print(i.name)
   ```

   输出

   ```html
   body
   html
   [document]
   ```

2. find_next_siblings()和find_next_sibling()

   前者返回后面所有的兄弟节点，后者返回后面第一个兄弟节点。

3. find_previous_siblings()和find_previous_sibling()

   前者返回前面所有的兄弟节点，后者返回前面第一个兄弟节点。

4. find_all_next()和find_next()

   前者返回节点后所有符合条件的节点，后者返回第一个符合条件的节点。

5. find_all_previous()和find_previous()

   前者返回节点后所有符合条件的节点，后者返回第一个符合条件的节点

# 五、CSS选择器

在 `Tag` 或 `BeautifulSoup` 对象的 `.select()` 方法中传入字符串参数, 即可使用CSS选择器的语法找到tag

# 六、其他

## 6.1 复制Beautiful Soup对象

`copy.copy()` 方法可以复制任意 `Tag` 或 `NavigableString` 对象

```python
import copy
p_copy = copy.copy(soup.p)
```

复制后的对象跟与对象是相等的, 但指向不同的内存地址

```python
print soup.p == p_copy
# True

print soup.p is p_copy
# False
```

## 6.2 get_text()

获取标签里面内容，除了可以使用 .string 之外，还可以使用 get_text 方法，不同的地方在于前者返回的一个 NavigableString 对象，后者返回的是 unicode 类型的字符串。

实际场景中我们一般使用 get_text 方法获取标签中的内容。

```python
soup.head.get_text()
# 'Harry potter'
```

