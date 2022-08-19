---
title: "CSS"
date: 2021-11-30
author: MelonCholi
draft: false
tags: [CSS,前端,快速入门]
categories: [前端]
---

# CSS

## 基本知识

### 简介

层叠样式表(英文全称：Cascading Style Sheets)是一种用来表现 HTML（标准通用标记语言的一个应用）或 XML（标准通用标记语言的一个子集）等文件样式的计算机语言

### 语法

选择器{声明}

```css
selector { property: value }

/* Example */
div {
      font-size: 100px;
      color: red;
    }
```

- 选择器（Selector）：浏览器根据选择器决定哪些 html 元素受 css 样式的影响

- 属性（Property）：是你要改变的样式名
- 值（Value ）：将值分配给属性

注意

1. 每个属性用；分开。

2. CSS 注释以 **/\*** 开始, 以 **\*/** 结束

### 引入方式

优先级：内联样式 > 内部样式 > 外部样式

注意：如果外部样式放在内部样式的后面，则外部样式将覆盖内部样式

#### 内联样式表

Inline style，也叫行内式

在元素标签内部的 style 属性中设定 CSS 格式

```css
<div style="color: red; font-size: 12px;">起飞</div>
```

#### 内部样式表

Internal style sheet，也叫嵌入式

将所有 CSS 代码抽取出来，单独放到一个 `<style>` 标签中

```css
<style>
div {
    border: 2px solid green;
    font-size: 100px;
    color: green;
}
</style>
```

#### 外部样式表

External style sheet，也叫链接式

样式单独写到 CSS 文件中，把文件引入到 HTML 页面中使用

建立步驟

1. 新建一个后缀名为 .css 样式的文件，把 CSS 代码放入其中
2. 用\<link>标签引入文件

```css
<link rel="stylesheet" type="text/css" href="css文件路径">
```

### Emmet 语法

#### 快速生成 HTML 语法

-  生成标签：写标签名，按 tab
- 生成多个相同标签：标签名 *num，按 tab
- 生成父子级标签：用 >，如 ul>li
- 生成兄弟级标签：用 +，如 div+p

## 选择器

ID 选择器 > 类选择器 > 标签选择器

### 标签选择器

也叫元素选择器，selector 为标签名

```css
div {
  border: 1px solid blue;
  font-size: 10px;
  color: blue;
}
```

### 类选择器

以一个点 "." 号显示

任何标签都可以添加一个或多个 class 属性（类名间用空格分开），并且 class 属性是可以相同的

类选择器实现差异化选择不同标签

```css
.class_name {
  border: 10px solid green;
  font-size: 30px;
  color: green;
}
```

- **可以单独设置拥有 class 名的特定标签的样式**

```css
h1.black {
   color: #000000;
}
```

上述规则仅将 **class** 属性设置为 black 的 `<h1>` 元素呈现为黑色

- **可以单独设置位于拥有 class 名的标签内部的标签的样式**

```css
.black h1 {
   color: #000000;
}
```

在此示例中，当所有 `<h1>` 位于 id 属性设置为 black 的标签中时，这些标题将以黑色显示

### id 选择器

以 "#" 来定义

任何标签都可以添加 id 属性，并且一个页面的 id 应该保持**唯一性**

只能调用一次，一般用于页面唯一性的元素上

```css
#id_name {
  border: 5px solid red;
  font-size: 20px;
  color: red;
}
```

### 通配符选择器

使用 “*” 定义，表示选取页面中所有的元素（标签）

不需要调用，作用于全局

```css
* {
  border: 10px solid green;
  font-size: 30px;
  color: green;
}
```

### 聚合选择器

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

### 特定选择器

假设仅当样式规则位于特定元素内时，才希望将其应用于特定元素

如以下示例所示，样式规则仅在 `<em>` 元素位于 `<ul>` 标签内时才适用

```css
ul em {
   color: #000000;
}
```

### 子元素选择器

```css
body > p {
   color: #000000;
}
```

`<body>` 元素的直接 `<p>` 子元素将呈现为黑色

### 属性选择器

将样式应用于具有特定属性的 HTML 元素

```css
input[type="text"] {
   color: #000000;
}
```

上述样式规则将匹配所有具有 type 属性值为 text 的输入元素

以下规则适用于属性选择器

- `p [lang]` - 选择有 lang 属性的所有段落元素。
- `p [lang ="fr"]` - 选择其 lang 属性的值为" fr"的所有段落元素。
- `p [lang~="fr"]` - 选择所有 lang 属性包含单词" fr"的段落元素。
- `p [lang|="en"]` - 选择其 lang 属性包含的值完全为" en"或以"en-"开始的所有段落元素。

### 选择器查询表

| 选择器                                                                                             | 例子                  | 例子描述                                                    | CSS |
| -------------------------------------------------------------------------------------------------- | --------------------- | ----------------------------------------------------------- | --- |
| .*class*                                                                                           | .intro                | 选择 class="intro" 的所有元素。                             | 1   |
| #*id*                                                                                              | #firstname            | 选择 id="firstname" 的所有元素。                            | 1   |
| *                                                                                                  | *                     | 选择所有元素。                                              | 2   |
| *element*                                                                                          | p                     | 选择所有 \<p> 元素。                                        | 1   |
| *element*, *element*                                                                               | div,p                 | 选择所有 \<div> 元素和所有 \<p> 元素。                      | 1   |
| *element* *element*                                                                                | div p                 | 选择 \<div> 元素内部的所有 \<p> 元素。                      | 1   |
| *element* > *element*                                                                              | div>p                 | 选择父元素为 \<div> 元素的所有 \<p> 元素。                  | 2   |
| *element* + *element*                                                                              | div+p                 | 选择紧接在 \<div> 元素之后的所有 \<p> 元素。                | 2   |
| [*attribute*]                       | [target]              | 选择带有 target 属性所有元素。                              | 2   |
| [*attribute*=*value*\]          | [target=_blank]       | 选择 target="_blank" 的所有元素。                           | 2   |
| [*attribute*~=*value*\] | [title~=flower]       | 选择 title 属性包含单词 "flower" 的所有元素。               | 2   |
| [*attribute*\|=*value*\]  | [lang\|=en]           | 选择 lang 属性值以 "en" 开头并用“-”分隔的字符串的所有元素。 | 2   |
| :link                                      | a:link                | 选择所有未被访问的链接。                                    | 1   |
| :visited                                | a:visited             | 选择所有已被访问的链接。                                    | 1   |
| [:active](https://www.w3school.com.cn/cssref/selector_active.asp)                                  | a:active              | 选择活动链接。                                              | 1   |
| [:hover](https://www.w3school.com.cn/cssref/selector_hover.asp)                                    | a:hover               | 选择鼠标指针位于其上的链接。                                | 1   |
| [:focus](https://www.w3school.com.cn/cssref/selector_focus.asp)                                    | input:focus           | 选择获得焦点的 input 元素。                                 | 2   |
| [:first-letter](https://www.w3school.com.cn/cssref/selector_first-letter.asp)                      | p:first-letter        | 选择每个 \<p> 元素的首字母。                                | 1   |
| [:first-line](https://www.w3school.com.cn/cssref/selector_first-line.asp)                          | p:first-line          | 选择每个 \<p> 元素的首行。                                  | 1   |
| [:first-child](https://www.w3school.com.cn/cssref/selector_first-child.asp)                        | p:first-child         | 选择属于父元素的第一个子元素的每个 \<p> 元素。              | 2   |
| [:before](https://www.w3school.com.cn/cssref/selector_before.asp)                                  | p:before              | 在每个 \<p> 元素的内容之前插入内容。                        | 2   |
| [:after](https://www.w3school.com.cn/cssref/selector_after.asp)                                    | p:after               | 在每个 \<p> 元素的内容之后插入内容。                        | 2   |
| [:lang(*language*)](https://www.w3school.com.cn/cssref/selector_lang.asp)                          | p:lang(it)            | 选择带有以 "it" 开头的 lang 属性值的每个 \<p> 元素。        | 2   |
| [*element1*~*element2*](https://www.w3school.com.cn/cssref/selector_gen_sibling.asp)               | p~ul                  | 选择前面有 \<p> 元素的每个 \<ul> 元素。                     | 3   |
| [[*attribute*^=*value*\]](https://www.w3school.com.cn/cssref/selector_attr_begin.asp)              | a[src^="https"]       | 选择其 src 属性值以 "https" 开头的每个 \<a> 元素。          | 3   |
| [[*attribute*$=*value*\]](https://www.w3school.com.cn/cssref/selector_attr_end.asp)                | a[src$=".pdf"]        | 选择其 src 属性以 ".pdf" 结尾的所有 \<a> 元素。             | 3   ||
| [[*attribute**=*value*\]](https://www.w3school.com.cn/cssref/selector_attr_contain.asp)            | a[src*="abc"]         | 选择其 src 属性中包含 "abc" 子串的每个 \<a> 元素。          | 3   |
| [:first-of-type](https://www.w3school.com.cn/cssref/selector_first-of-type.asp)                    | p:first-of-type       | 匹配同类型(\<p>)中的**第一个**同级兄弟(含自己) \<p> 元素    | 3   |
| [:last-of-type](https://www.w3school.com.cn/cssref/selector_last-of-type.asp)                      | p:last-of-type        | 匹配同类型(\<p>)中的**最后一个**同级兄弟(含自己) \<p> 元素  | 3   |
| [:only-of-type](https://www.w3school.com.cn/cssref/selector_only-of-type.asp)                      | p:only-of-type        | 选择属于其父元素**唯一的** \<p> 元素。                      | 3   |
| [:only-child](https://www.w3school.com.cn/cssref/selector_only-child.asp)                          | p:only-child          | 选择属于其父元素的唯一子元素。                              | 3   |
| [:nth-child(*n*)](https://www.w3school.com.cn/cssref/selector_nth-child.asp)                       | p:nth-child(2)        | 选择属于p的父元素的第二个子元素                             | 3   |
| [:nth-last-child(*n*)](https://www.w3school.com.cn/cssref/selector_nth-last-child.asp)             | p:nth-last-child(2)   | 同上，从最后一个子元素开始计数。                            | 3   |
| [:nth-of-type(*n*)](https://www.w3school.com.cn/cssref/selector_nth-of-type.asp)                   | p:nth-of-type(2)      | 选择属于p的父元素第二个同类（这里是p）元素。                | 3   |
| [:nth-last-of-type(*n*)](https://www.w3school.com.cn/cssref/selector_nth-last-of-type.asp)         | p:nth-last-of-type(2) | 同上，但是从最后一个子元素开始计数。                        | 3   |
| [:last-child](https://www.w3school.com.cn/cssref/selector_last-child.asp)                          | p:last-child          | 选择属于其父元素最后一个子元素每个 \<p> 元素。              | 3   |
| [:root](https://www.w3school.com.cn/cssref/selector_root.asp)                                      | :root                 | 选择文档的根元素。                                          | 3   |
| [:empty](https://www.w3school.com.cn/cssref/selector_empty.asp)                                    | p:empty               | 选择没有子元素的每个 \<p> 元素（包括文本节点）。            | 3   |
| [:target](https://www.w3school.com.cn/cssref/selector_target.asp)                                  | #news:target          | 选择当前活动的 #news 元素。                                 | 3   |
| [:enabled](https://www.w3school.com.cn/cssref/selector_enabled.asp)                                | input:enabled         | 选择每个启用的 \<input> 元素。                              | 3   |
| [:disabled](https://www.w3school.com.cn/cssref/selector_disabled.asp)                              | input:disabled        | 选择每个禁用的 \<input> 元素                                | 3   |
| [:checked](https://www.w3school.com.cn/cssref/selector_checked.asp)                                | input:checked         | 选择每个被选中的 \<input> 元素。                            | 3   |
| [:not(*selector*)](https://www.w3school.com.cn/cssref/selector_not.asp)                            | :not(p)               | 选择非 \<p> 元素的每个元素。                                | 3   |
| [::selection](https://www.w3school.com.cn/cssref/selector_selection.asp)                           | ::selection           | 选择被用户选取的元素部分。                                  | 3   |

## 字体属性

（Font）

CSS 字体属性定义字体，加粗，大小，文字样式

### 字体 font-family

- font - family 属性指定一个元素的字体。

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
- 如果字体名称包含空格，它必须加上引号；在 HTML 中使用"style"属性时，必须使用单引号

### 大小 font-size

font-size 属性用于设置字体大小

```css
p {
  font-size: 18px;
}
```

#### 属性值

| 值                                                               | 描述                                                                    |
| :--------------------------------------------------------------- | :---------------------------------------------------------------------- |
| xx-small   x-small   small   medium   large    x-large  xx-large | 把字体的尺寸设置为不同的尺寸，从 xx-small 到 xx-large。默认值：medium。 |
| smaller                                                          | 把 font-size 设置为比父元素更小的尺寸。                                 |
| larger                                                           | 把 font-size 设置为比父元素更大的尺寸。                                 |
| *length*                                                         | 把 font-size 设置为一个固定的值。                                       |
| *%*                                                              | 把 font-size 设置为基于父元素的一个百分比值。                           |

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

#### 长度单位

##### 绝对单位

1 `in`=2.54`cm`=25.4`mm`=72`pt`=6`pc`。

各种单位的含义：

- `in`：英寸 Inches (1 英寸 = 2.54 厘米)
- `cm`：厘米 Centimeters
- `mm`：毫米 Millimeters
- `pt`：点 Points，或者叫英镑 (1 点 = 1/72 英寸)
- `pc`：皮卡 Picas (1 皮卡 = 12 点)

##### 相对单位

- `px`：像素
- `em`：印刷单位相当于 12 个点

#### 用 em 来设置字体大小

为了避免 Internet Explorer 中无法调整文本的问题，许多开发者使用 em 单位代替像素。

em 的尺寸单位由 W3C 建议。

1em 和当前字体大小相等。在浏览器中默认的文字大小是 16px，因此有**px/16=em**

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

#### 使用百分比和 EM 组合

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

### 样式 font-style

font-style 属性指定文本的字体样式

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

### 粗细 font-weight

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

### 小型大写字母字体 font-variant

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

### 字体复合属性 font

font 简写属性在一个声明中设置所有字体属性。

可设置的属性是（按顺序）： "font-style  font-variant  font-weight  font-size/line-height  font-family"

font-size 和 font-family 的值是必需的。如果缺少了其他值，默认值将被插入，如果有默认值的话

```css
p.ex1 {
  font: 15px arial, sans-serif;
}

p.ex2 {
  font: italic bold 12px/30px Georgia, serif;
}
```

## 文本

Text

### 颜色 color

color 属性指定文本的颜色

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

| 值         | 描述                                                                                           | 实例                                                                                                 |
| :--------- | :--------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------- |
| *颜色名称* | 颜色的名称，比如red, blue, brown, lightseagreen等，不区分大小写。                              | color:red;    红色  color:black;  黑色  color:gray;   灰色  color:white;   白色  color:purple;  紫色 |
| *十六进制* | 十六进制符号 #RRGGBB 和 #RGB（比如 #ff0000）。"#" 后跟 6 位或者 3 位十六进制字符（0-9, A-F）。 | #f03 #F03 #ff0033 #FF0033                                                                            |
| *RGB*      | 函数格式为 rgb(R,G,B)，取值可以是 0-255 的整数或百分比。                                       | rgb(255,0,51) rgb(255, 0, 51) rgb(100%,0%,20%) rgb(100%, 0%, 20%)                                    |

### 对齐方式 text-align

text-align 属性指定元素文本的水平对齐方式。

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

###  修饰 text-decoration

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

### 首行文本缩进 text-indent

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

### 控制大小写 text-transform

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

### 字符间距 letter-spacing

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

### 字间距 word-spacing

word-spacing 属性增加或减少字与字之间的空白。

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

### 行间距 line-height

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

### 文字阴影 text-shadow

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

## 背景

Backgrounds

### 颜色 background-color

background-color 属性设置一个元素的背景颜色。

元素的背景是元素的总大小，包括填充和边界（但不包括边距）

```css
body {
    background-color: yellow;
}

h1 {
    background-color: #00ff00;
}

p {
    background-color: rgb(255, 0, 255);
}
```

属性值

| 值          | 描述                                                                                                            |
| :---------- | :-------------------------------------------------------------------------------------------------------------- |
| *color*     | 指定背景颜色。在[CSS颜色值](https://www.runoob.com/css/css-colors-legal.html)近可能的寻找一个颜色值的完整列表。 |
| transparent | 指定背景颜色应该是透明的。这是默认                                                                              |

### 图像 background-image

background-image 属性设置一个元素的背景图像。

元素的背景是元素的总大小，包括填充和边界（但不包括边距）。

默认情况下，background-image 放置在元素的左上角，并重复垂直和水平方向。

提示：请设置一种可用的背景颜色，这样的话，假如背景图像不可用，可以使用背景色带代替。

```css
body {
    background-image: url('paper.gif');
    background-color: #cccccc;
}
```

属性

| 值                                                                                               | 说明                                      |
| :----------------------------------------------------------------------------------------------- | :---------------------------------------- |
| url(*'URL'*)                                                                                     | 图像的URL                                 |
| none                                                                                             | 无图像背景会显示。这是默认                |
| [linear-gradient()](https://www.runoob.com/cssref/func-linear-gradient.html)                     | 创建一个线性渐变的 "图像"(从上到下)       |
| [radial-gradient()](https://www.runoob.com/cssref/func-radial-gradient.html)                     | 用径向渐变创建 "图像"。 (center to edges) |
| [repeating-linear-gradient()](https://www.runoob.com/cssref/func-repeating-linear-gradient.html) | 创建重复的线性渐变 "图像"。               |
| [repeating-radial-gradient()](https://www.runoob.com/cssref/func-repeating-radial-gradient.html) | 创建重复的径向渐变 "图像"                 |

### 图像重复设置 background-repeat

设置如何平铺对象的 background-image 属性。

默认情况下，重复 background-image 的垂直和水平方向。

```css
body {
    background-image: url('paper.gif');
    background-repeat: repeat-y;
}
```

属性

| 值        | 说明                                     |
| :-------- | :--------------------------------------- |
| repeat    | 背景图像将向垂直和水平方向重复。（默认） |
| repeat-x  | 只有水平位置会重复背景图像               |
| repeat-y  | 只有垂直位置会重复背景图像               |
| no-repeat | background-image不会重复，即显示图片原长 |

### 图像固定或滚动 background-attachment

 background-attachment 设置背景图像是否固定或者随着页面的其余部分滚动。

```css
body
{
    background-image:url('smiley.gif');
    background-repeat:no-repeat;
    background-attachment:fixed;
}
```

属性值

| 值     | 描述                                       |
| :----- | :----------------------------------------- |
| scroll | 背景图片随着页面的滚动而滚动，这是默认的。 |
| fixed  | 背景图片不会随着页面的滚动而滚动。         |
| local  | 背景图片会随着元素内容的滚动而滚动。       |

### 图像起始位置 background-position

background-position 属性设置背景图像的起始位置。

```css
body {
    background-image: url('smiley.gif');
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-position: center;
}
```

属性值

| 值                                                                                                                          | 描述                                                                                                                                                                                                    |
| :-------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| left top， left center， left bottom， right top， right center， right bottom， center top， center center， center bottom | 如果仅指定一个关键字，其他值将会是"center"                                                                                                                                                              |
| *x% y%*                                                                                                                     | 第一个值是水平位置，第二个值是垂直。左上角是0％0％。右下角是100％100％。如果仅指定了一个值，其他值将是50％。 。默认值为：0％0％                                                                         |
| *xpos ypos*                                                                                                                 | 第一个值是水平位置，第二个值是垂直。左上角是0。单位可以是像素（0px0px）或任何其他 [CSS单位](https://www.runoob.com/try/css-units.html)。如果仅指定了一个值，其他值将是50％。你可以混合使用％和positions |

### 背景复合属性

背景缩写属性可以在一个声明中设置所有的背景属性。

可以设置的属性分别是：background-color、background-position、background-size、background-repeat、background-origin、background-clip、background-attachment 和 background-image。

各值之间用空格分隔，不分先后顺序。可以只有其中的某些值

> background:bg-color bg-image position/bg-size bg-repeat bg-origin bg-clip bg-attachment initial|inherit;

属性值

| 值                                                                                     | 说明                                             | CSS  |
| :------------------------------------------------------------------------------------- | :----------------------------------------------- | :--- |
| *[background-color](https://www.runoob.com/cssref/pr-background-color.html)*           | 指定要使用的背景颜色                             | 1    |
| *[background-position](https://www.runoob.com/cssref/pr-background-position.html)*     | 指定背景图像的位置                               | 1    |
| *[background-size](https://www.runoob.com/cssref/css3-pr-background-size.html)*        | 指定背景图片的大小                               | 3    |
| *[background-repeat](https://www.runoob.com/cssref/pr-background-repeat.html)*         | 指定如何重复背景图像                             | 1    |
| *[background-origin](https://www.runoob.com/cssref/css3-pr-background-origin.html)*    | 指定背景图像的定位区域                           | 3    |
| *[background-clip](https://www.runoob.com/cssref/css3-pr-background-clip.html)*        | 指定背景图像的绘画区域                           | 3    |
| *[background-attachment](https://www.runoob.com/cssref/pr-background-attachment.html)* | 设置背景图像是否固定或者随着页面的其余部分滚动。 | 1    |
| *[background-image](https://www.runoob.com/cssref/pr-background-image.html)*           | 指定要使用的一个或多个背景图像                   |      |

## 链接

链接的样式，可以用任何 CSS 属性（如颜色，字体，背景等）

特别的链接，可以有不同的样式，这取决于他们是什么状态

这四个链接状态是：

- a:link - 正常，未访问过的链接
- a:visited - 用户已访问过的链接
- a:hover - 当用户鼠标放在链接上时
- a:active - 链接被点击的那一刻

```css
/* 未访问链接*/
a:link {
    color: #000000;
}

/* 已访问链接 */
a:visited {
    color: #00FF00;
}

/* 鼠标移动到链接上 */
a:hover {
    color: #FF00FF;
}

/* 鼠标点击时 */
a:active {
    color: #0000FF;
}
```

规则

四种状态**必须按照固定的顺序写**，也就是所谓的“爱恨原则”（LoVe/HAte）：

> a:link 、a:visited 、a:hover 、a:active

## 列表

CSS 列表属性作用如下：

- 设置不同的列表项标记为有序列表
- 设置不同的列表项标记为无序列表
- 设置列表项标记为图像

### 图像替代 list-style-image

list-style-image 属性使用图像来替换列表项的标记。

```css
ul {
    list-style-image: url('sqpurple.gif');
}
```

属性值

| 值    | 描述                 |
| :---- | :------------------- |
| *URL* | 图像的路径。         |
| none  | 默认。无图形被显示。 |

### 标记位置 list-style-position

list-style-position 属性指示如何相对于对象的内容绘制列表项标记

```css
ul {
    list-style-position: inside;
}
```

属性值

| 值      | 描述                                                                                   |
| :------ | :------------------------------------------------------------------------------------- |
| inside  | 列表项目标记放置在文本以内，且环绕文本根据标记对齐。                                   |
| outside | 默认值。保持标记位于文本的左侧。列表项目标记放置在文本以外，且环绕文本不根据标记对齐。 |

<p>该列表的 list-style-position 的值是 "inside"：</p>
<ul class="inside" style="list-style-position: inside">
<li>Earl Grey Tea - 一种黑颜色的茶</li>
<li>Jasmine Tea - 一种神奇的“全功能”茶</li>
<li>Honeybush Tea - 一种令人愉快的果味茶</li>
</ul>

<p>该列表的 list-style-position 的值是 "outside"：</p>
<ul class="outside" style="list-style-position: outside">
<li>Earl Grey Tea - 一种黑颜色的茶</li>
<li>Jasmine Tea - 一种神奇的“全功能”茶</li>
<li>Honeybush Tea - 一种令人愉快的果味茶</li>
</ul>

### 标记类型 list-style-type

list-style-type 属性设置列表项标记的类型

```css
ul.circle {
    list-style-type: circle
}

ul.square {
    list-style-type: square
}

ol.upper-roman {
    list-style-type: upper-roman
}

ol.lower-alpha {
    list-style-type: lower-alpha
}
```

属性值

| 值                   | 描述                                                        |
| :------------------- | :---------------------------------------------------------- |
| none                 | 无标记。                                                    |
| disc                 | 默认。标记是实心圆。                                        |
| circle               | 标记是空心圆。                                              |
| square               | 标记是实心方块。                                            |
| decimal              | 标记是数字。                                                |
| decimal-leading-zero | 0开头的数字标记。(01, 02, 03, 等。)                         |
| lower-roman          | 小写罗马数字(i, ii, iii, iv, v, 等。)                       |
| upper-roman          | 大写罗马数字(I, II, III, IV, V, 等。)                       |
| lower-alpha          | 小写英文字母The marker is lower-alpha (a, b, c, d, e, 等。) |
| upper-alpha          | 大写英文字母The marker is upper-alpha (A, B, C, D, E, 等。) |
| lower-greek          | 小写希腊字母(alpha, beta, gamma, 等。)                      |
| lower-latin          | 小写拉丁字母(a, b, c, d, e, 等。)                           |
| upper-latin          | 大写拉丁字母(A, B, C, D, E, 等。)                           |
| hebrew               | 传统的希伯来编号方式                                        |
| armenian             | 传统的亚美尼亚编号方式                                      |
| georgian             | 传统的乔治亚编号方式(an, ban, gan, 等。)                    |
| cjk-ideographic      | 简单的表意数字                                              |
| hiragana             | 标记是：a, i, u, e, o, ka, ki, 等。（日文平假名字符）       |
| katakana             | 标记是：A, I, U, E, O, KA, KI, 等。（日文片假名字符）       |
| hiragana-iroha       | 标记是：i, ro, ha, ni, ho, he, to, 等。（日文平假名序号）   |
| katakana-iroha       | 标记是：I, RO, HA, NI, HO, HE, TO, 等。（日文片假名序号）   |

<p>无序列表实例:</p>

<ul class="a" style="list-style-type:circle;">
  <li>Coffee</li>
  <li>Tea</li>
  <li>Coca Cola</li>
</ul>

<ul class="b" style="list-style-type:square;">
  <li>Coffee</li>
  <li>Tea</li>
  <li>Coca Cola</li>
</ul>

<p>有序列表实例:</p>

<ol class="c" style="list-style-type:upper-roman;">
  <li>Coffee</li>
  <li>Tea</li>
  <li>Coca Cola</li>
</ol>

<ol class="d" style="list-style-type:lower-alpha;">
  <li>Coffee</li>
  <li>Tea</li>
  <li>Coca Cola</li>
</ol>

### 列表复合属性 list-style

list-style 简写属性在一个声明中设置所有的列表属性

可以设置的属性（按顺序）： list-style-type, list-style-position, list-style-image.

可以不设置其中的某个值，比如 "list-style:circle inside;" 也是允许的。未设置的属性会使用其默认值

```css
ul {
    list-style: square url("sqpurple.gif");
}
```

属性值

| 值                    | 描述                       |
| :-------------------- | :------------------------- |
| *list-style-type*     | 设置列表项标记的类型       |
| *list-style-position* | 设置在何处放置列表项标记   |
| *list-style-image*    | 使用图像来替换列表项的标记 |
| *initial*             | 将这个属性设置为默认值     |

## 表格

### 边框属性 border

```css
table, th, td
{
    border: 1px solid black;
}
```

在上面的例子中的表格有双边框。这是因为表和 th/ td 元素有独立的边界。

为了显示一个表的单个边框，使用 border-collapse 属性。

### 折叠边框 border-collapse

border-collapse 属性设置表格的边框是否被折叠成一个单一的边框或隔开

```css
table
{
    border-collapse:collapse;
}
table,th, td
{
    border: 1px solid black;
}
```

### 表格宽度和高度 Width 和 height

Width 和 height 属性定义表格的宽度和高度。

下面的例子是设置 100％的宽度，50 像素的 th 元素的高度的表格

```css
table
{
    width:100%;
}
th
{
    height:50px;
}
```

### 表格文字对齐 text-align 和 vertical-align

表格中的文本对齐和垂直对齐属性。

text-align 属性设置水平对齐方式，向左，右，或中心

```css
td
{
    text-align:right;
}
```

垂直对齐属性 vertical-align 设置垂直对齐，比如顶部，底部或中间

```css
td
{
    height:50px;
    vertical-align:bottom;
}
```

### 表格填充 padding

如果在表的内容中控制空格之间的边框，应使用 td 和 th 元素的填充属性 padding

```css
td
{
    padding:15px;
}
```

### 表格颜色 color

下面的例子指定边框的颜色，和 th 元素的文本和背景颜色

```css
table, td, th
{
    border:1px solid green;
}
th
{
    background-color:green;
    color:white;
}
```

![image-20210913153944537](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210913153944537.png)

## position

- **static**（静态定位）：默认值。没有定位，元素出现在正常的流中（忽略 top, bottom, left, right 或者 z-index 声明）。
- **relative**（相对定位）：生成相对定位的元素，通过 top,bottom,left,right 的设置相对于其正常（原先本身）位置进行定位。可通过 z-index 进行层次分级。　　
- **absolute**（绝对定位）：生成绝对定位的元素，相对于 static 定位以外的第一个父元素进行定位。元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定。可通过 z-index 进行层次分级。
- **fixed**（固定定位）：生成绝对定位的元素，相对于浏览器窗口进行定位。元素的位置通过 "left", "top", "right" 以及 "bottom" 属性进行规定。可通过 z-index 进行层次分级。
