# 基本操作

注意：当 element 对象使用 xpath 方法时，切记在语法字符串前加上当前路径 `.`

## 导入

### 从字符串中导入

```python
from lxml import etree
text = '''
<div>
    <ul>
         <li class="item-0"><a href="link1.html">first item</a></li>
         <li class="item-1"><a href="link2.html">second item</a></li>
         <li class="item-inactive"><a href="link3.html">third item</a></li>
         <li class="item-1"><a href="link4.html">fourth item</a></li>
         <li class="item-0"><a href="link5.html">fifth item</a>
     </ul>
 </div>
'''
html = etree.HTML(text) 		#调用HTML类进行初始化，构造了一个XPath解析对象
result = etree.tostring(html)	#result为修正后的HTML代码(bytes类型)
print(result.decode('utf-8'))	#用decode方法将其转成str类型并输出
```

 etree 模块可以自动修正 HTML 文本

```html
<html><body><div>
    <ul>
         <li class="item-0"><a href="link1.html">first item</a></li>
         <li class="item-1"><a href="link2.html">second item</a></li>
         <li class="item-inactive"><a href="link3.html">third item</a></li>
         <li class="item-1"><a href="link4.html">fourth item</a></li>
         <li class="item-0"><a href="link5.html">fifth item</a>
     </li></ul>
 </div>
</body></html>
```

### 从文件中导入

```python
html = etree.parse('path', etree.HTMLParser())
```

# 选取节点

在 XPath 中，有七种类型的节点：元素、属性、文本、命名空间、处理指令、注释以及文档节点（或称为根节点）

XPath 使用路径表达式来选取 XML 文档中的节点或节点集。节点是通过沿着路径 (path) 或者步 (steps) 来选取的

## 路径选取

### 基本表达式

| 表达式   | 描述                                                       |
| :------- | :--------------------------------------------------------- |
| nodename | 选取此节点的所有子节点。                                   |
| /        | 从根节点选取。                                             |
| //       | 从匹配选择的当前节点选择文档中的节点，而不考虑它们的位置。 |
| .        | 选取当前节点。                                             |
| ..       | 选取当前节点的父节点。                                     |
| @        | 选取属性。                                                 |

例

| 路径表达式      | 结果                                                                                        |
| :-------------- | :------------------------------------------------------------------------------------------ |
| bookstore       | 选取 bookstore 元素的所有子节点。                                                           |
| /bookstore      | 选取根元素 bookstore。注释：假如路径起始于正斜杠( / )，则此路径始终代表到某元素的绝对路径！ |
| bookstore/book  | 选取属于 bookstore 的子元素的所有 book 元素。                                               |
| //book          | 选取所有 book 子元素，而不管它们在文档中的位置。                                            |
| bookstore//book | 选择属于 bookstore 元素的后代的所有 book 元素，而不管它们位于 bookstore 之下的什么位置。    |
| //@lang         | 选取名为 lang 的所有属性。                                                                  |

### 谓语

谓语（Predicates）用来查找某个特定的节点或者包含某个指定的值的节点；谓语被嵌在方括号中。

例

| 路径表达式                         | 结果                                                                                      |
| :--------------------------------- | :---------------------------------------------------------------------------------------- |
| /bookstore/book[1]                 | 选取属于 bookstore 子元素的第一个 book 元素。                                             |
| /bookstore/book[last()]            | 选取属于 bookstore 子元素的最后一个 book 元素。                                           |
| /bookstore/book[last()-1]          | 选取属于 bookstore 子元素的倒数第二个 book 元素。                                         |
| /bookstore/book[position()<3]      | 选取最前面的两个属于 bookstore 元素的子元素的 book 元素。                                 |
| //title[@lang]                     | 选取所有拥有名为 lang 的属性的 title 元素。                                               |
| //title[@lang='eng']               | 选取所有 title 元素，且这些元素拥有值为 eng 的 lang 属性。                                |
| /bookstore/book[price>35.00]       | 选取 bookstore 元素的所有 book 元素，且其中的 price 元素的值须大于 35.00。                |
| /bookstore/book[price>35.00]/title | 选取 bookstore 元素中的 book 元素的所有 title 元素，且其中的 price 元素的值须大于 35.00。 |

### 选取未知节点

XPath 通配符可用来选取未知的 XML 元素。

| 通配符 | 描述                 |
| :----- | :------------------- |
| *      | 匹配任何元素节点。   |
| @*     | 匹配任何属性节点。   |
| node() | 匹配任何类型的节点。 |

例

| 路径表达式   | 结果                              |
| :----------- | :-------------------------------- |
| /bookstore/* | 选取 bookstore 元素的所有子元素。 |
| //*          | 选取文档中的所有元素。            |
| //title[@*]  | 选取所有带有属性的 title 元素。   |

### 选取若干路径

在路径表达式中使用“|”运算符

例

| 路径表达式                       | 结果                                                                                |
| :------------------------------- | :---------------------------------------------------------------------------------- |
| //book/title \| //book/price     | 选取 book 元素的所有 title 和 price 元素。                                          |
| //title \| //price               | 选取文档中的所有 title 和 price 元素。                                              |
| /bookstore/book/title \| //price | 选取属于 bookstore 元素的 book 元素的所有 title 元素，以及文档中所有的 price 元素。 |

## 步选取

步（step）包括：

- 轴（axis）

  定义所选节点与当前节点之间的树关系

- 节点测试（node-test）

  识别某个轴内部的节点

- 零个或者更多谓语（predicate）

  更深入地提炼所选的节点集

步的语法

```
轴名称::节点测试[谓语]
```

### 轴

轴可定义相对于当前节点的节点集。

| 轴名称             | 结果                                                     |
| :----------------- | :------------------------------------------------------- |
| ancestor           | 选取当前节点的所有先辈（父、祖父等）。                   |
| ancestor-or-self   | 选取当前节点的所有先辈（父、祖父等）以及当前节点本身。   |
| attribute          | 选取当前节点的所有属性。                                 |
| child              | 选取当前节点的所有子元素。                               |
| descendant         | 选取当前节点的所有后代元素（子、孙等）。                 |
| descendant-or-self | 选取当前节点的所有后代元素（子、孙等）以及当前节点本身。 |
| following          | 选取文档中当前节点的结束标签之后的所有节点。             |
| namespace          | 选取当前节点的所有命名空间节点。                         |
| parent             | 选取当前节点的父节点。                                   |
| preceding          | 选取文档中当前节点的开始标签之前的所有节点。             |
| preceding-sibling  | 选取当前节点之前的所有同级节点。                         |
| self               | 选取当前节点。                                           |

### 例

| 例子                   | 结果                                                               |
| :--------------------- | :----------------------------------------------------------------- |
| child::book            | 选取所有属于当前节点的子元素的 book 节点。                         |
| attribute::lang        | 选取当前节点的 lang 属性。                                         |
| child::*               | 选取当前节点的所有子元素。                                         |
| attribute::*           | 选取当前节点的所有属性。                                           |
| child::text()          | 选取当前节点的所有文本子节点。                                     |
| child::node()          | 选取当前节点的所有子节点。                                         |
| descendant::book       | 选取当前节点的所有 book 后代。                                     |
| ancestor::book         | 选择当前节点的所有 book 先辈。                                     |
| ancestor-or-self::book | 选取当前节点的所有 book 先辈以及当前节点（如果此节点是 book 节点） |
| child::*/child::price  | 选取当前节点的所有 price 孙节点。z                                 |

# Python 实现

## 选取所有节点

```python
result = html.xpath('//*') #匹配所有节点
result = html.xpath('//li')#获取所有 li 节点
```

返回形式是一个列表，每个元素是 Element 类型，其后跟了节点的名称，如 html、body、div、ul、li、a 等

## 选取子节点

通过 / 或 // 即可查找元素的子节点或子孙节点

```python
result = html.xpath('//li/a') #选择 li 节点的所有直接 a 子节点
result = html.xpath('//ul//a') #获取 ul 节点下的所有子孙 a 节点
```

## 父节点

选中 href 属性为 link4.html 的 a 节点，然后再获取其父节点，然后再获取其 class 属性

```python
result = html.xpath('//a[@href="link4.html"]/../@class')  
```

输出

```html
['item-1']
```

通过 parent:: 来获取父节点

```python
result = html.xpath('//a[@href="link4.html"]/parent::*/@class')  
```

## 属性匹配

### 单值匹配

用 @ 符号进行属性过滤

如果要选取 class 为 item-0 的 li 节点

```python
result = html.xpath('//li[@class="item-0"]')  
```

### 多值匹配

若有

```html
<li class="li li-first"><a href="link.html">first item</a></li> 
```

使用上述方法将得不到结果，需要用 contains 方法

```python
result = html.xpath('//li[contains(@class, "li")]/a/text()')  
```

输出

```python
['first item']
```

此种方式在某个节点的某个属性有多个值时经常用到，如某个节点的 class 属性通常有多个

### 多属性匹配

另外，我们可能还遇到一种情况，那就是根据多个属性确定一个节点，这时就需要同时匹配多个属性。此时可以使用运算符 and 来连接

```python
text = '''  
<li class="li li-first" name="item"><a href="link.html">first item</a></li>
'''  
html = etree.HTML(text) 

result = html.xpath('//li[contains(@class, "li") and @name="item"]/a/text()')  
```

## 文本获取

尝试获取前面 li 节点中的文本

```python
result = html.xpath('//li[@class="item-0"]/text()')  
result = html.xpath('//li[@class="item-0"]/a/text()') 
result = html.xpath('//li[@class="item-0"]//text()')  
```

输出

```html
['\n     ']
['first item', 'fifth item']
['first item', 'fifth item', '\n     ']
```

1. 直接子节点并没有文本内容；自动修正的 li 节点的尾标签换行了。
2. 先选取 a 节点再获取文本
3. 使用 //，还会输出尾部的换行符

## 属性获取

想获取所有 li 节点下所有 a 节点的 href 属性

```python
result = html.xpath('//li/a/@href') 
```

输出

```html
['link1.html', 'link2.html', 'link3.html', 'link4.html', 'link5.html']
```

## 按序选择

有时候，我们在选择的时候某些属性可能同时匹配了多个节点，但是只想要其中的某个节点，如第二个节点或者最后一个节点，这时可以利用中括号传入索引的方法获取特定次序的节点

```python
result = html.xpath('//li[1]/a/text()')
result = html.xpath('//li[last()]/a/text()')
result = html.xpath('//li[position()<3]/a/text()')
result = html.xpath('//li[last()-2]/a/text()')
```

## 节点轴选择

```python
result = html.xpath('//li[1]/ancestor::*')
result = html.xpath('//li[1]/ancestor::div')
result = html.xpath('//li[1]/attribute::*')
result = html.xpath('//li[1]/child::a[@href="link1.html"]')
result = html.xpath('//li[1]/descendant::span')
result = html.xpath('//li[1]/following::*[2]')
result = html.xpath('//li[1]/following-sibling::*')
```

