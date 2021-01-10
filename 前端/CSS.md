# 一、基本知识

## 1.1 简介

层叠样式表(英文全称：Cascading Style Sheets)是一种用来表现HTML（标准通用标记语言的一个应用）或XML（标准通用标记语言的一个子集）等文件样式的计算机语言

## 1.2 语法

选择器{声明}

```css
<!-- Example -->
div {
      font-size: 100px;
      color: red;
    }
```

> 选择器：浏览器根据选择器决定哪些html元素受css样式的影响
>
> 属性：是你要改变的样式名，且每个属性都有一个值。属性和值呗冒号分开，并由花括号包围，这样组成了一个完整的样式声明
>
> 注意：每个属性用；分开。

## 1.3 引入方式

优先级：行内式 > 链接式 > 嵌入式

### 1.3.1 行内样式表（行内式）

在元素标签内部的style属性中设定CSS格式

```css
<div style="color: red; font-size: 12px;">起飞</div>
```

### 1.3.2 部样式表（嵌入式）

将所有CSS代码抽取出来，单独放到一个<style>标签中 

```css
<style>
div {
    border: 2px solid green;
    font-size: 100px;
    color: green;
}
</style>
```

### 1.3.3 外部样式表（链接式）

样式单独写到CSS文件中，把文件引入到HTML页面中使用

建立步驟

1. 新建一个后缀名为.css样式的文件，把CSS代码放入其中
2. 用\<link>标签引入文件

```css
<link rel="stylesheet" href="css文件路径">
```

## 1.4 Emmet语法

### 1.4.1 快速生成HTML语法

-  生成标签：写标签名，按tab
- 生成多个相同标签：标签名*num，按tab
- 生成父子级标签：用>，如ul>li
- 生成兄弟级标签：用+，如div+p