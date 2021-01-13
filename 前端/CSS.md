# 一、基本知识

## 1.1 简介

层叠样式表(英文全称：Cascading Style Sheets)是一种用来表现HTML（标准通用标记语言的一个应用）或XML（标准通用标记语言的一个子集）等文件样式的计算机语言

## 1.2 语法

选择器{声明}

```css
selector { property: value }

/* Example */
div {
      font-size: 100px;
      color: red;
    }
```

- 选择器（Selector）：浏览器根据选择器决定哪些html元素受css样式的影响

- 属性（Property）：是你要改变的样式名
- 值（Value ）：将值分配给属性

注意

1. 每个属性用；分开。

2. CSS注释以 **/\*** 开始, 以 ***/** 结束

## 1.3 引入方式

优先级：内联样式 > 内部样式 > 外部样式

注意：如果外部样式放在内部样式的后面，则外部样式将覆盖内部样式

### 1.3.1 内联样式表

Inline style，也叫行内式

在元素标签内部的style属性中设定CSS格式

```css
<div style="color: red; font-size: 12px;">起飞</div>
```

### 1.3.2 内部样式表

Internal style sheet，也叫嵌入式

将所有CSS代码抽取出来，单独放到一个\<style\>标签中 

```css
<style>
div {
    border: 2px solid green;
    font-size: 100px;
    color: green;
}
</style>
```

### 1.3.3 外部样式表

External style sheet，也叫链接式

样式单独写到CSS文件中，把文件引入到HTML页面中使用

建立步驟

1. 新建一个后缀名为.css样式的文件，把CSS代码放入其中
2. 用\<link>标签引入文件

```css
<link rel="stylesheet" type="text/css" href="css文件路径">
```

## 1.4 Emmet语法

### 1.4.1 快速生成HTML语法

-  生成标签：写标签名，按tab
- 生成多个相同标签：标签名*num，按tab
- 生成父子级标签：用>，如ul>li
- 生成兄弟级标签：用+，如div+p

# 二、选择器

## 2.1 标签选择器

也叫元素选择器，selector为标签名

```css
div {
  border: 1px solid blue;
  font-size: 10px;
  color: blue;
}
```

## 2.2 类选择器

以一个点"."号显示

任何标签都可以添加一个或多个class属性（类名间用空格分开），并且class属性是可以相同的

类选择器实现差异化选择不同标签

```css
.class_name {
  border: 10px solid green;
  font-size: 30px;
  color: green;
}
```

## 2.3 id选择器

以 "#" 来定义

任何标签都可以添加id属性，并且一个页面的id应该保持**唯一性**

只能调用一次，一般用于页面唯一性的元素上

```css
#id_name {
  border: 5px solid red;
  font-size: 20px;
  color: red;
}
```

- 可以单独设置拥有class名的特定标签的样式

```css
h1.black {
   color: #000000; 
}
```

上述规则仅将**class**属性设置为black的\<h1>元素呈现为黑色

- 可以单独设置位于拥有class名的标签内部的标签的样式

```css
.black h1 {
   color: #000000; 
}
```

在此示例中，当所有\<h1>位于 id 属性设置为 black 的标签中时，这些标题将以黑色显示

## 2.4 通配符选择器

使用“*”定义，表示选取页面中所有的元素（标签）

不需要调用，作用于全局

```css
* {
  border: 10px solid green;
  font-size: 30px;
  color: green;
}
```

## 2.5 聚合选择器

可以将样式应用于许多选择器，只需用逗号分隔

```css
h1, h2, h3 {
   color: #36C;
   font-weight: normal;
   letter-spacing: .4em;
   margin-bottom: 1em;
   text-transform: lowercase;
}

#content, #footer, #supplement {
   position: absolute;
   left: 510px;
   width: 200px;
}
```

## 2.6 特定选择器

假设仅当样式规则位于特定元素内时，才希望将其应用于特定元素

如以下示例所示，样式规则仅在\<em>元素位于\<ul>标签内时才适用

```css
ul em {
   color: #000000; 
}
```

## 2.7 子元素选择器

```css
body > p {
   color: #000000; 
}
```

\<body>元素的直接\<p>子元素将呈现为黑色

## 2.8 属性选择器

将样式应用于具有特定属性的HTML元素

```css
input[type="text"] {
   color: #000000; 
}
```

上述样式规则将匹配所有具有type属性值为 text 的输入元素

以下规则适用于属性选择器

- `p [lang]` - 选择有 lang 属性的所有段落元素。
- `p [lang ="fr"]` - 选择其 lang 属性的值为" fr"的所有段落元素。
- `p [lang~="fr"]` - 选择所有 lang 属性包含单词" fr"的段落元素。
- `p [lang|="en"]` - 选择其 lang 属性包含的值完全为" en"或以"en-"开始的所有段落元素。

## 2.9 选择器查询表

| 选择器                                                       | 例子                  | 例子描述                                                    | CSS  |
| ------------------------------------------------------------ | --------------------- | ----------------------------------------------------------- | ---- |
| [.*class*](https://www.w3school.com.cn/cssref/selector_class.asp) | .intro                | 选择 class="intro" 的所有元素。                             | 1    |
| [#*id*](https://www.w3school.com.cn/cssref/selector_id.asp)  | #firstname            | 选择 id="firstname" 的所有元素。                            | 1    |
| [*](https://www.w3school.com.cn/cssref/selector_all.asp)     | *                     | 选择所有元素。                                              | 2    |
| [*element*](https://www.w3school.com.cn/cssref/selector_element.asp) | p                     | 选择所有 <p> 元素。                                         | 1    |
| [*element*,*element*](https://www.w3school.com.cn/cssref/selector_element_comma.asp) | div,p                 | 选择所有 <div> 元素和所有 <p> 元素。                        | 1    |
| [*element* *element*](https://www.w3school.com.cn/cssref/selector_element_element.asp) | div p                 | 选择 <div> 元素内部的所有 <p> 元素。                        | 1    |
| [*element*>*element*](https://www.w3school.com.cn/cssref/selector_element_gt.asp) | div>p                 | 选择父元素为 <div> 元素的所有 <p> 元素。                    | 2    |
| [*element*+*element*](https://www.w3school.com.cn/cssref/selector_element_plus.asp) | div+p                 | 选择紧接在 <div> 元素之后的所有 <p> 元素。                  | 2    |
| [[*attribute*\]](https://www.w3school.com.cn/cssref/selector_attribute.asp) | [target]              | 选择带有 target 属性所有元素。                              | 2    |
| [[*attribute*=*value*\]](https://www.w3school.com.cn/cssref/selector_attribute_value.asp) | [target=_blank]       | 选择 target="_blank" 的所有元素。                           | 2    |
| [[*attribute*~=*value*\]](https://www.w3school.com.cn/cssref/selector_attribute_value_contain.asp) | [title~=flower]       | 选择 title 属性包含单词 "flower" 的所有元素。               | 2    |
| [[*attribute*\|=*value*\]](https://www.w3school.com.cn/cssref/selector_attribute_value_start.asp) | [lang\|=en]           | 选择 lang 属性值以 "en" 开头并用“-”分隔的字符串的所有元素。 | 2    |
| [:link](https://www.w3school.com.cn/cssref/selector_link.asp) | a:link                | 选择所有未被访问的链接。                                    | 1    |
| [:visited](https://www.w3school.com.cn/cssref/selector_visited.asp) | a:visited             | 选择所有已被访问的链接。                                    | 1    |
| [:active](https://www.w3school.com.cn/cssref/selector_active.asp) | a:active              | 选择活动链接。                                              | 1    |
| [:hover](https://www.w3school.com.cn/cssref/selector_hover.asp) | a:hover               | 选择鼠标指针位于其上的链接。                                | 1    |
| [:focus](https://www.w3school.com.cn/cssref/selector_focus.asp) | input:focus           | 选择获得焦点的 input 元素。                                 | 2    |
| [:first-letter](https://www.w3school.com.cn/cssref/selector_first-letter.asp) | p:first-letter        | 选择每个 <p> 元素的首字母。                                 | 1    |
| [:first-line](https://www.w3school.com.cn/cssref/selector_first-line.asp) | p:first-line          | 选择每个 <p> 元素的首行。                                   | 1    |
| [:first-child](https://www.w3school.com.cn/cssref/selector_first-child.asp) | p:first-child         | 选择属于父元素的第一个子元素的每个 <p> 元素。               | 2    |
| [:before](https://www.w3school.com.cn/cssref/selector_before.asp) | p:before              | 在每个 <p> 元素的内容之前插入内容。                         | 2    |
| [:after](https://www.w3school.com.cn/cssref/selector_after.asp) | p:after               | 在每个 <p> 元素的内容之后插入内容。                         | 2    |
| [:lang(*language*)](https://www.w3school.com.cn/cssref/selector_lang.asp) | p:lang(it)            | 选择带有以 "it" 开头的 lang 属性值的每个 <p> 元素。         | 2    |
| [*element1*~*element2*](https://www.w3school.com.cn/cssref/selector_gen_sibling.asp) | p~ul                  | 选择前面有 <p> 元素的每个 <ul> 元素。                       | 3    |
| [[*attribute*^=*value*\]](https://www.w3school.com.cn/cssref/selector_attr_begin.asp) | a[src^="https"]       | 选择其 src 属性值以 "https" 开头的每个 <a> 元素。           | 3    |
| [[*attribute*$=*value*\]](https://www.w3school.com.cn/cssref/selector_attr_end.asp) | a[src$=".pdf"]        | 选择其 src 属性以 ".pdf" 结尾的所有 <a> 元素。              | 3    |
| [[*attribute**=*value*\]](https://www.w3school.com.cn/cssref/selector_attr_contain.asp) | a[src*="abc"]         | 选择其 src 属性中包含 "abc" 子串的每个 <a> 元素。           | 3    |
| [:first-of-type](https://www.w3school.com.cn/cssref/selector_first-of-type.asp) | p:first-of-type       | 匹配同类型(<p>)中的**第一个**同级兄弟(含自己) <p> 元素      | 3    |
| [:last-of-type](https://www.w3school.com.cn/cssref/selector_last-of-type.asp) | p:last-of-type        | 匹配同类型(<p>)中的**最后一个**同级兄弟(含自己) <p> 元素    | 3    |
| [:only-of-type](https://www.w3school.com.cn/cssref/selector_only-of-type.asp) | p:only-of-type        | 选择属于其父元素**唯一的** <p> 元素。                       | 3    |
| [:only-child](https://www.w3school.com.cn/cssref/selector_only-child.asp) | p:only-child          | 选择属于其父元素的唯一子元素。                              | 3    |
| [:nth-child(*n*)](https://www.w3school.com.cn/cssref/selector_nth-child.asp) | p:nth-child(2)        | 选择属于p的父元素的第二个子元素                             | 3    |
| [:nth-last-child(*n*)](https://www.w3school.com.cn/cssref/selector_nth-last-child.asp) | p:nth-last-child(2)   | 同上，从最后一个子元素开始计数。                            | 3    |
| [:nth-of-type(*n*)](https://www.w3school.com.cn/cssref/selector_nth-of-type.asp) | p:nth-of-type(2)      | 选择属于p的父元素第二个同类（这里是p）元素。                | 3    |
| [:nth-last-of-type(*n*)](https://www.w3school.com.cn/cssref/selector_nth-last-of-type.asp) | p:nth-last-of-type(2) | 同上，但是从最后一个子元素开始计数。                        | 3    |
| [:last-child](https://www.w3school.com.cn/cssref/selector_last-child.asp) | p:last-child          | 选择属于其父元素最后一个子元素每个 <p> 元素。               | 3    |
| [:root](https://www.w3school.com.cn/cssref/selector_root.asp) | :root                 | 选择文档的根元素。                                          | 3    |
| [:empty](https://www.w3school.com.cn/cssref/selector_empty.asp) | p:empty               | 选择没有子元素的每个 <p> 元素（包括文本节点）。             | 3    |
| [:target](https://www.w3school.com.cn/cssref/selector_target.asp) | #news:target          | 选择当前活动的 #news 元素。                                 | 3    |
| [:enabled](https://www.w3school.com.cn/cssref/selector_enabled.asp) | input:enabled         | 选择每个启用的 <input> 元素。                               | 3    |
| [:disabled](https://www.w3school.com.cn/cssref/selector_disabled.asp) | input:disabled        | 选择每个禁用的 <input> 元素                                 | 3    |
| [:checked](https://www.w3school.com.cn/cssref/selector_checked.asp) | input:checked         | 选择每个被选中的 <input> 元素。                             | 3    |
| [:not(*selector*)](https://www.w3school.com.cn/cssref/selector_not.asp) | :not(p)               | 选择非 <p> 元素的每个元素。                                 | 3    |
| [::selection](https://www.w3school.com.cn/cssref/selector_selection.asp) | ::selection           | 选择被用户选取的元素部分。                                  | 3    |

# 三、字体属性

Font

CSS字体属性定义字体，加粗，大小，文字样式

## 3.1 字体 font-family

- font - family属性指定一个元素的字体。

- font-family 可以把多个字体名称作为一个"回退"系统来保存。如果浏览器不支持第一个字体，则会尝试下一个

```css
p {
  font-family: "Times New Roman", Georgia, Serif;
}
```

有两种类型的字体系列名称

- **family-name** - 指定的系列名称：具体字体的名称，比如："times"、"courier"、"arial"
- **generic-family** - 通常字体系列名称：比如："serif"、"sans-serif"、"cursive"、"fantasy"、"monospace

注意

-  每个值用逗号分开
- 如果字体名称包含空格，它必须加上引号；在HTML中使用"style"属性时，必须使用单引号

## 3.2 大小 font-size

font-size 属性用于设置字体大小

```css
p {
  font-size: 18px;
}
```

### 3.2.1 属性值

| 值                                                           | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| xx-small   x-small   small   medium   large    x-large  xx-large | 把字体的尺寸设置为不同的尺寸，从 xx-small 到 xx-large。默认值：medium。 |
| smaller                                                      | 把 font-size 设置为比父元素更小的尺寸。                      |
| larger                                                       | 把 font-size 设置为比父元素更大的尺寸。                      |
| *length*                                                     | 把 font-size 设置为一个固定的值。                            |
| *%*                                                          | 把 font-size 设置为基于父元素的一个百分比值。                |

```css
/* <absolute-size>，绝对大小值 */
font-size: xx-small;
font-size: x-small;
font-size: small;
font-size: medium; 
font-size: large;
font-size: x-large;
font-size: xx-large;
 
/* <relative-size>，相对大小值 */
font-size: larger;
font-size: smaller;
 
/* <length>，长度值 */
font-size: 12px;
font-size: 0.8em;
 
/* <percentage>，百分比值 */
font-size: 80%;
```

### 3.2.2 长度单位

#### 1）绝对单位

1 `in`=2.54`cm`=25.4`mm`=72`pt`=6`pc`。

各种单位的含义：

- `in`：英寸Inches (1 英寸 = 2.54 厘米)
- `cm`：厘米Centimeters
- `mm`：毫米Millimeters
- `pt`：点Points，或者叫英镑 (1点 = 1/72英寸)
- `pc`：皮卡Picas (1 皮卡 = 12 点)

#### 2）相对单位

- `px`：像素
- `em`：印刷单位相当于12个点

### 3.2.3 用em来设置字体大小

为了避免Internet Explorer 中无法调整文本的问题，许多开发者使用 em 单位代替像素。

em的尺寸单位由W3C建议。

1em和当前字体大小相等。在浏览器中默认的文字大小是16px，因此有**px/16=em**

```css
h1 {
  font-size: 2.5em;
} /* 40px/16=2.5em */
h2 {
  font-size: 1.875em;
} /* 30px/16=1.875em */
p {
  font-size: 0.875em;
} /* 14px/16=0.875em */
```

### 3.2.4 使用百分比和EM组合

在所有浏览器的解决方案中，设置 \<body>元素的默认字体大小的是百分比

```css
body {
  font-size: 100%;
}
h1 {
  font-size: 2.5em;
}
h2 {
  font-size: 1.875em;
}
p {
  font-size: 0.875em;
}
```

## 3.3 样式 font-style

font-style属性指定文本的字体样式

```css
p {
  font-style: italic;
}
```

属性值

| 值      | 描述                                   |
| :------ | :------------------------------------- |
| normal  | 默认值。浏览器显示一个标准的字体样式。 |
| italic  | 浏览器会显示一个斜体的字体样式。       |
| oblique | 浏览器会显示一个倾斜的字体样式。       |

## 3.4 粗细 font-weight

font-weight 属性设置文本的粗细

```css
p.normal {
  font-weight: normal;
}

p.thick {
  font-weight: bold;
}

p.thicker {
  font-weight: 900;
}
```

属性值

| 值                                | 描述                                                        |
| :-------------------------------- | :---------------------------------------------------------- |
| normal                            | 默认值。定义标准的字符。                                    |
| bold                              | 定义粗体字符。                                              |
| bolder                            | 定义更粗的字符。                                            |
| lighter                           | 定义更细的字符。                                            |
| 100  200  300  400  500  600  700 | 定义由细到粗的字符。400 等同于 normal，而 700 等同于 bold。 |

## 3.5 小型大写字母字体 font-variant

font-variant 属性设置小型大写字母的字体显示文本，这意味着所有的小写字母均会被转换为大写，但是所有使用小型大写字体的字母与其余文本相比，其字体尺寸更小

```css
p {
  font-variant: small-caps;
}
```

属性值

| 值         | 描述                                 |
| :--------- | :----------------------------------- |
| normal     | 默认值。浏览器会显示一个标准的字体。 |
| small-caps | 浏览器会显示小型大写字母的字体。     |

## 3.6 字体复合属性 font

font 简写属性在一个声明中设置所有字体属性。

可设置的属性是（按顺序）： "font-style  font-variant  font-weight  font-size/line-height  font-family"

font-size和font-family的值是必需的。如果缺少了其他值，默认值将被插入，如果有默认值的话

```css
p.ex1 {
  font: 15px arial, sans-serif;
}

p.ex2 {
  font: italic bold 12px/30px Georgia, serif;
}
```

# 四、文本

Text

## 4.1 颜色 color

color属性指定文本的颜色

```css
body {
  color: red;
}
h1 {
  color: #00ff00;
}
p {
  color: rgb(0, 0, 255);
}
```

属性值

| 值         | 描述                                                         | 实例                                                         |
| :--------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| *颜色名称* | 颜色的名称，比如red, blue, brown, lightseagreen等，不区分大小写。 | color:red;    红色  color:black;  黑色  color:gray;   灰色  color:white;   白色  color:purple;  紫色 |
| *十六进制* | 十六进制符号 #RRGGBB 和 #RGB（比如 #ff0000）。"#" 后跟 6 位或者 3 位十六进制字符（0-9, A-F）。 | #f03 #F03 #ff0033 #FF0033                                    |
| *RGB*      | 函数格式为 rgb(R,G,B)，取值可以是 0-255 的整数或百分比。     | rgb(255,0,51) rgb(255, 0, 51) rgb(100%,0%,20%) rgb(100%, 0%, 20%) |

## 4.2 对齐方式 text-align

text-align属性指定元素文本的水平对齐方式。

```css
h1 {
  text-align: center;
}
h2 {
  text-align: left;
}
h3 {
  text-align: right;
}
```

属性值

| 值      | 描述                                     |
| :------ | :--------------------------------------- |
| left    | 把文本排列到左边。默认值：由浏览器决定。 |
| right   | 把文本排列到右边。                       |
| center  | 把文本排列到中间。                       |
| justify | 实现两端对齐文本效果。                   |

## 4.3  修饰 text-decoration 

text-decoration 属性规定添加到文本的修饰，下划线、上划线、删除线等

```css
h1.under {
  text-decoration: underline;
}
h1.over {
  text-decoration: overline;
}
p.line {
  text-decoration: line-through;
}
p.blink {
  text-decoration: blink;
}
a.none {
  text-decoration: none;
}
p.underover {
  text-decoration: underline overline;
}
h3 {
  text-decoration: underline wavy red;
}
```

text-decoration 属性是以下三种属性的简写：

- text-decoration-line
- text-decoration-color
- text-decoration-style

属性值

| 值           | 描述                     |
| :----------- | :----------------------- |
| none         | 默认。定义标准的文本。   |
| underline    | 定义文本下的一条线。     |
| overline     | 定义文本上的一条线。     |
| line-through | 定义穿过文本下的一条线。 |
| blink        | 定义闪烁的文本。         |

## 4.4 首行文本缩进 text-indent

text-indent 属性规定文本块中首行文本的缩进。

```CSS
p {
  text-indent: 50px;
}
```

属性值

| 值       | 描述                               |
| :------- | :--------------------------------- |
| *length* | 定义固定的缩进。默认值：0。        |
| *%*      | 定义基于父元素宽度的百分比的缩进。 |

## 4.5 控制大小写 text-transform

text-transform 属性控制文本的大小写。

```css
h1 {
  text-transform: uppercase;
}
h2 {
  text-transform: capitalize;
}
p {
  text-transform: lowercase;
}
```

属性值

| 值         | 描述                                           |
| :--------- | :--------------------------------------------- |
| none       | 默认。定义带有小写字母和大写字母的标准的文本。 |
| capitalize | 文本中的每个单词以大写字母开头。               |
| uppercase  | 定义仅有大写字母。                             |
| lowercase  | 定义无大写字母，仅有小写字母。                 |



## 4.6 字符间距 letter-spacing

letter-spacing 属性增加或减少字符间的空白（字符间距）

```css
h1 {
  letter-spacing: 2px;
}
h2 {
  letter-spacing: -3px;
}
```

属性值

| 值       | 描述                                   |
| :------- | :------------------------------------- |
| normal   | 默认。规定字符间没有额外的空间。       |
| *length* | 定义字符间的固定空间（允许使用负值）。 |

## 4.7 字间距 word-spacing

word-spacing属性增加或减少字与字之间的空白。

```css
p {
  word-spacing: 30px;
}
```

属性值

| 值       | 描述                         |
| :------- | :--------------------------- |
| normal   | 默认。定义单词间的标准空间。 |
| *length* | 定义单词间的固定空间。       |

## 4.8 行间距 line-height

line-height 设置以百分比计的行高

```css
p.small {
  line-height: 90%;
}
p.big {
  line-height: 200%;
}
```

属性值

| 值       | 描述                                                 |
| :------- | :--------------------------------------------------- |
| normal   | 默认。设置合理的行间距。                             |
| *number* | 设置数字，此数字会与当前的字体尺寸相乘来设置行间距。 |
| *length* | 设置固定的行间距。                                   |
| *%*      | 基于当前字体尺寸的百分比行间距。                     |

## 4.9 文字阴影 text-shadow

text-shadow 属性应用于阴影文本

```css
h1 {
  text-shadow: 2px 2px #ff0000;
}
```

语法

```
text-shadow: h-shadow v-shadow blur color;
```

| 值         | 描述                             |
| :--------- | :------------------------------- |
| *h-shadow* | 必需。水平阴影的位置。允许负值。 |
| *v-shadow* | 必需。垂直阴影的位置。允许负值。 |
| *blur*     | 可选。模糊的距离。               |
| *color*    | 可选。阴影的颜色。               |

```html
<h1 style="text-shadow:0 0 3px #FF0000;">Text-shadow with neon glow</h1>
```

<h1 style="text-shadow:0 0 3px #FF0000;">Text-shadow with neon glow</h1>

```html
<h1 style="text-shadow:2px 2px 8px #FF0000;">Text-shadow with neon glow</h1>
```

<h1 style="text-shadow:2px 2px 8px #FF0000;">Text-shadow with neon glow</h1>

```html
<h1 style="color:white; text-shadow:2px 2px 4px #000000;">Text-shadow with neon glow</h1>
```

<h1 style="color:white; text-shadow:2px 2px 4px #000000;">Text-shadow with neon glow</h1>

