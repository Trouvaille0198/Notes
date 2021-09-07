# 书写规范

```html
<!-- html文件开始, lang="zh_CN"表示中文 -->
<html lang="zh_CN">
  <!-- 头信息 一般分  title标题  css样式 js代码 -->
  <head>
    <!-- 表示当前页面使用UTF-8编码 -->
    <meta charset="UTF-8">
    <title>标题</title>
  </head>
  <body>
    <!-- 页面主体信息 -->
    hello
  </body>
</html>
```

1. html 语言是不区分大小写的语言。

2. html 的属性写法，写在标签中 `属性名 = 值`，值是可以用双引号，也可以用单引号或者不写，注意如果不写后面一定要加一个空格。

## 基本结构标签

1. `<html><html>` ：HTML标签，根标签，页面中最大的标签

2. `<head></head>`：文档的头部，在其中必须设置title标签

3. `<title></title>`：文档的标题

4. `<body></body>`：文档主体，包含文档的所有内容

## 其他信息

1. 文档类型声明标签 `<!DOCTYPE>`

   告诉浏览器使用那种HTML版本来显示网页，写在最前面

```html
<!DOCTYPE html>
```

2. lang 语言种类

   定义当前文档显示的语言。en 为英语；zh-CN 为中文

```html
<html lang="en">
```

3. 字符集

   通过 `<meta>` 标签的 charset 属性规定字符编码

```html
<meta charset="UTF-8">
```

# 常用标签

## 标题标签 `<h1>-<h6>`

6 个等级，1-6 重要级递减

加了标题的文字更粗更大，一个标题独占一行

## 段落标签 `<p>`

分段，浏览器根据窗口大小自动换行，段落之前有空行

## 换行标签 `<br />` （单标签）

强制换行

## 文本格式化标签

1. 加粗 `<strong></strong>` 或 `<b></b>`

2. 倾斜 `<em></em>` 或 `<i></i>`

3. 删除线 `<del></del>` 或 `<s></s>`

4. 下划线 `<ins></ins>` 或 `<u></u>`

## 区块 `<div>` 和 `<span>`

没有语义，是一个盒子，用来装内容

`<div>` 独占一行，大盒子

`<span>` 在一行可以放多个，小盒子

## 图像标签

```html
<img src="图像URL" />
```

src 是 `<img>` 标签的必须属性，用于指定图像文件的路径和文件名

| 属性名称 | 属性值 | 描述                     |
| -------- | ------ | ------------------------ |
| src      | url    | 图像的路径               |
| alt      | 文本   | 图像不能显示时的替换文本 |
| title    | 文本   | 鼠标悬停显示的内容       |
| width    | 像素   | 设置图像的宽度           |
| height   | 像素   | 设置图像的高度           |
| border   | 数字   | 设置图像边框的宽度       |

## 超链接标签 `<a>`

### 语法格式

```html
<a href="跳转目标" target="目标窗口的弹出方式"> 文本或图像 </a>
```

- *href* 用于指定链接目标的 url 地址，必须属性

- *target* 用于指定链接页面的打开方式，其中 *_self* 为默认值，*_blank* 为在新窗口中打开

### 分类

- 外部链接：`http://`
- 内部链接：页面名称 
- 空链接：#
- 下载链接：地址链接的是文件、exe、zip 等，会下载这个文件
- 网页元素链接：文本、图像、视频、音频、表格等都可以添加超链接
- 锚点链接：快速定位到页面中的某个位置

### id 属性

在 HTML 文档中插入 id

```html
<p id="tips">有用的提示部分</p>
```

在 HTML 文档中创建一个链接到"有用的提示部分 `(id="tips")`"

```html
<a href="#tips">访问有用的提示部分</a>
```

或者，从另一个页面创建一个链接到"有用的提示部分 `(id="tips")`"

```html
<a href="https://www.runoob.com/html/html-links.html#tips">访问有用的提示部分</a>
```

## 注释

```html
<!-- -->
```

## 特殊字符

| **显示结果** | **描述**          | **实体名称**         | **实体编号** |
| ------------ | ----------------- | -------------------- | ------------ |
|              | 空格              | \&nbsp;              | \&#160;      |
| <            | 小于号            | \&lt;                | \&#60;       |
| >            | 大于号            | \&gt;                | \&#62;       |
| &            | 和号              | \&amp;               | \&#38;       |
| "            | 引号              | \&quot;              | \&#34;       |
| '            | 撇号              | \&apos;  (IE 不支持) | \&#39;       |
| ￠            | 分（cent）        | \&cent;              | \&#162;      |
| £            | 镑（pound）       | \&pound;             | \&#163;      |
| ¥            | 元（yen）         | \&yen;               | \&#165;      |
| €            | 欧元（euro）      | \&euro;              | \&#8364;     |
| §            | 小节              | \&sect;              | \&#167;      |
| ©            | 版权（copyright） | \&copy;              | \&#169;      |
| ®            | 注册商标          | \&reg;               | \&#174;      |
| ™            | 商标              | \&trade;             | \&#8482;     |
| ×            | 乘号              | \&times;             | \&#215;      |
| ÷            | 除号              | \&divide;            | \&#247;      |

## 表格标签

```html
<table>
    <tr>
        <td>单元格内的文字</td>
        ...
    </tr>
    ...
</table>
```

1. `<table></table>`  定义表格
2. `<tr></tr>`  定义表格中的行
3. `<td></td>`  定义单元格
4. `<th></th>`  表头单元格标签，加粗居中显示

### 表格结构标签

1. `<thead></thead>` 表格的头部区域，一般包含着 tr 和 td

2. `<tbody></tbody>` 表格的主题区域，一般包含着 tr 和 th

3. 合并单元格

   跨行合并，写在最上侧单元格 

```html
<td rowspan="要合并的数量"></td>
```

​		跨列合并，写在最左侧单元格

```html
<td colspan="要合并的数量"></td>
```

### 例

```html
<table border="1" width="300" height="300" align="center" cellspacing="0">
    <thead> <!--  thhead表示表头 -->
        <th>第1列</th>
        <th>第2列</th><!--  th是字体加粗的td标签一般用在表头 -->
        <th>第3列</th>
    </thead>
    <tr><!-- 行 -->
        <td align="left">1-1</td><!-- 列，单元格 -->
        <td align="center">1-2</td>
        <td align="right">1-3</td>
    </tr>
    <tr><!-- 行 -->
        <td><b>2-1</b></td><!-- 列，单元格 b标签加粗 -->
        <td>2-2</td>
        <td>2-3</td>
    </tr>
    <tr><!-- 行 -->
        <td>3-1</td><!-- 列，单元格 -->
        <td>3-2</td>
        <td>3-3</td>
    </tr>
</table>
```

![image-20210620161957250](http://lvshuhuai.cn/image-20210620161957250.png)


```html
<body>
    <!-- colspan表示跨列 rowspan表示跨行-->
    <table border="1" width="300" height="300" align="center" cellspacing="0">
        <thead> <!--  thhead表示表头 -->
            <th>第1列</th>
            <th>第2列</th><!--  th是字体加粗的td标签一般用在表头 -->
            <th>第3列</th>
        </thead>
        <tr><!-- 行 -->
            <td colspan="2">1-1</td><!-- 第一行的第一列跨2列 -->
            <td>1-3</td>
        </tr>
        <tr><!-- 行 -->
            <td rowspan="2">2-1</td><!-- 第二行的第一列跨2行 -->
            <td colspan="2" rowspan="2">2-2</td><!-- 第二行的第二列跨2行2列 -->
        </tr>
        <tr><!-- 行 -->

        </tr>
    </table>
</body>
```

![image-20210620162006891](http://lvshuhuai.cn/image-20210620162006891.png)


## 水平线标签 `<hr />`

生成一条水平线

## 列表标签

### 无序列表

```html
<ul>
    <li>列表项1</li>
    <li>列表项2</li>
    <li>列表项3</li>
</ul>
```

`<li></li>` 中间可以放置任何元素

### 有序列表

```html
<ol>
    <li>列表项1</li>
    <li>列表项2</li>
    <li>列表项3</li>
</ol>
```

### 自定义列表

常用于对术语或名词进行解释或描述，其列表项前没有任何符号

```html
<dl>
    <dt>名词1</dt>
    <dd>名词1的解释1</dd>
    <dd>名词1的解释2</dd>
</dl>
```

 ### 输出

![image-20210620161406006](http://lvshuhuai.cn/image-20210620161406006.png)


## 表单标签

### 表单域

把范围内的表单元素提交给服务器

```html
<form action="url地址" method="提交方式" name="表单域名称">
    各种表单元素控件
</form>
```

### 表单控件

允许用户在表单中输入或者选择的内容控件

#### 输入表单元素

```html
<input type="属性值" />
```

type 属性值

| 值       | 描述                                                       |
| :------- | :--------------------------------------------------------- |
| button   | 定义可点击的按钮（通常与 JavaScript 一起使用来启动脚本）。 |
| checkbox | 定义复选框。                                               |
| file     | 定义文件选择字段和 "浏览..." 按钮，供文件上传。            |
| date     | 定义 date 控件（包括年、月、日，不包括时间）。             |
| hidden   | 定义隐藏输入字段。                                         |
| image    | 定义图像作为提交按钮。                                     |
| password | 定义密码字段（字段中的字符会被遮蔽）。                     |
| radio    | 定义单选按钮。                                             |
| reset    | 定义重置按钮（重置所有的表单值为默认值）。                 |
| submit   | 定义提交按钮。                                             |
| search   | 定义用于输入搜索字符串的文本字段。                         |
| text     | 默认。定义一个单行的文本字段（默认宽度为 20 个字符）。     |
| color    | 定义拾色器。                                               |

其他参数

| 属性      | 值         | 描述                                                   |
| --------- | ---------- | ------------------------------------------------------ |
| checked   | checked    | 规定此 input  元素首次加载时应当被选中。               |
| maxlength | number     | 规定输入字段中的字符的最大长度。                       |
| name      | field_name | 定义  input 元素的名称。单选按钮和复选框应有相同的name |
| value     | value      | 规定 input  元素的值。在文本框中会显示                 |

#### 定义标注标签 `<label></label>`

绑定一个表单元素，当点击 label 标签内的文本时，浏览器会自动将焦点（光标）转到或者选择对应的表单元素上以增加用户体验

```html
<label for="id名字">文本或图片</label>
```

在 input 标签内写上 id 属性，即可一一对应

#### 下拉表单元素

有多个选项，用下拉列表以节约空间

```html
<select>
    <option>选项1</option>
    <option>选项2</option>
    <option>选项3</option>
</select>
```

在 option 中定义 `selected="selected"`，默认选中此选项

![image-20210620161419300](http://lvshuhuai.cn/image-20210620161419300.png)


#### 文本域元素

当用户输入内容较多时，用文本域标签定义多行文本输入

```html
<textarea>文本内容</textarea>
```

例

```html
<textarea rows="10" cols="30">
我是一个文本框。
</textarea>
```

![image-20210620161042167](http://lvshuhuai.cn/image-20210620161042167.png)


### 例子

```html
<form action="demo_form.php" method="post/get">
    <input type="text" name="email" size="40" maxlength="50" value="type your email here">
    <input type="password">
    <input type="checkbox" checked="checked">
    <input type="radio" checked="checked">
    <input type="submit" value="Send">
    <input type="reset">
    <input type="hidden">
    <select>
        <option>苹果</option>
        <option selected="selected">香蕉</option>
        <option>樱桃</option>
    </select>
    <textarea name="comment" rows="6" cols="20"></textarea>

</form>
```



![image-20210620161052876](http://lvshuhuai.cn/image-20210620161052876.png)



```html
<body>

<!-- form标签就是表单
 input type=text 是文本输入框 value 表示默认显示内容
 input type=password 是密码输入框 value 表示默认显示内容 password类型显示······
 input type=radio 是单选框 name 表示单选框的组同名的是一组 一组只能选一个，checked表示默认选中
 input type=checkbox 是多选框 name 表示多选框的组同名的是一组 一组可以选多个，checked表示默认选中
 select 是选择框下拉框 name 表示名字 option是下拉选项 selected表示默认选中 value表示选中后的值 不写取option中间的值
  textarea 表示文本域 多行文本框 rows表示行 cols表示列
 input type=reset 重置按钮 value表示修改按钮上的文本
 input type=submit 提交按钮 value表示修改按钮上的文本
 input type=button 提交按钮 value表示修改按钮上的文本
 input type=file 文件上传按钮 value表示修改按钮上的文本
 input type=hidden 隐藏域 不显示的组件，不需要用户参与的
-->
<form action="">
  <h1 align="center"> 用户注册</h1>
  <table cellspacing="0" align="center">
    <tr>
      <td>用户名：</td>
      <td>
        <input type="text" value="默认值"/><br>
      </td>
    </tr>
    <tr>
      <td>密码：</td>
      <td>
        <input type="password" value="密码"/><br>
      </td>
    </tr>
    <tr>
      <td>确认密码：</td>
      <td>
        <input type="password" value="密码"/><br>
      </td>
    </tr>
    <tr>
      <td>性别：</td>
      <td>
        <input type="radio" name="sex" checked="checked">男<input type="radio" name="sex">女<br>
      </td>
    </tr>
    <tr>
      <td> 兴趣爱好：</td>
      <td>
        <input type="checkbox" name="hobby" checked="checked">java
        <input type="checkbox" name="hobby"checked="checked">python
        <input type="checkbox" name="hobby">c++<br>
      </td>
    </tr>
    <tr>
      <td> 国籍：</td>
      <td>
        <select name="nation">
          <option>--请选择国籍--</option>
          <option value="1" selected="selected">中国</option>
          <option value="2">美国</option>
          <option value="3">英国</option>
        </select><br>
      </td>
    </tr>
    <tr>
      <td>  自我评价：</td>
      <td>
        <textarea cols="30" rows="10">这里写默认值 没有value属性</textarea><br>
      </td>
    </tr>
    <tr>
      <td> <input type="reset" value="重置"><input type="submit" value="提交"></td>
      <td><input type="button" value="普通按钮"><input type="file" value="提交文件"></td>
    </tr>
  </table>
  <input type="hidden" name="1111" value="隐藏域"><br>

</form>
</body>
```

![image-20210620161116099](http://lvshuhuai.cn/image-20210620161116099.png)


### 表单提交

```html
<form action="http://localhost:8080" method="GET">
```

- action：访问服务器的地址

- method：请求方式有GET和POST

> http://localhost:8080/?username=user&password=123&password2=123&sex=1&hobby=java&hobby=python&nation=1&desc=desc&1111=abc

1. 表单项数据要发送给服务器需要给表单项属性加上 name 属性
2. 表单项属性要发送指定数据给服务器，例如单选框选中男就发送 1 过去就需要给每个表单项设置 value 值
3. 表单项不在提交的 form 标签中，也不会提交

> 表单请求方法有 get 和 post

GET方式

1. 传递参数的地方	地址?参数   地址?键=值&键=值(name=value)
2. 不安全
3. 参数长度有限

POST 方式

1. 传递参数的地方	请求的请求实体中
2. 相对安全
3. 参数长度理论无限制  

> **一般带有上传文件/密码的表单使用 post 传递**