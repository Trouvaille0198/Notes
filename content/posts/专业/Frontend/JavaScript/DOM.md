---
title: "JavaScript DOM"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [JavaScript,前端]
categories: [前端]
---

# DOM

## 简介

### 概念

文档对象模型（Document Object Model，简称 DOM），是 W3C 组织推荐的处理可拓展标记语言（HTML 或 XML）的标准编程接口

- 文档：一个页面就是一个文档，用 document 表示

- 元素：页面中所有标签都是元素，用 element 表示

- 节点：网页中所有内容都是节点（标签，属性，文本，注释等），用 node 表示

DOM 把以上内容都看作对象

### 节点思想

根据 W3C 的 HTML DOM 标准，HTML 文档中的所有内容都是节点：

- 整个文档是一个文档节点
- 每个 HTML 元素是元素节点
- HTML 元素内的文本是文本节点
- 每个 HTML 属性是属性节点
- 注释是注释节点

## DOM 属性

### 元素属性

以下为 `Node` 对象的属性

- ***.nodeName***

    nodeName 属性规定节点的名称。

    - nodeName 是只读的
    - 元素节点的 nodeName 与标签名相同
    - 属性节点的 nodeName 与属性名相同
    - 文本节点的 nodeName 始终是 #text
    - 文档节点的 nodeName 始终是 #document


- ***.nodeValue***

    nodeValue 属性规定节点的值。

    - 元素节点的 nodeValue 是 undefined 或 null
    - 文本节点的 nodeValue 是文本本身
    - 属性节点的 nodeValue 是属性值

```html
<html>
<body>

<p id="intro">Hello World!</p>

<script>
x=document.getElementById("intro");
document.write(x.firstChild.nodeValue);
</script>

</body>
</html>
```

- ***nodeType***

    nodeType 属性返回节点的类型。nodeType 是只读的

| 元素类型 | NodeType |
| :------- | :------- |
| 元素     | 1        |
| 属性     | 2        |
| 文本     | 3        |
| 注释     | 8        |
| 文档     | 9        |

以下为 `Element` 的属性

- ***.innerHTML***

    innerHTML 属性可用于获取或改变任意 HTML 元素，包括 \<html> 和 \<body>

```html
<html>
<body>

<p id="intro">Hello World!</p>

<script>
var txt=document.getElementById("intro").innerHTML;
document.write(txt);
</script>

</body>
</html>
```

- ***.attributes***

    返回该元素所有属性节点的一个实时集合

```javascript
var para = document.getElementsByTagName("p")[0];
var atts = para.attributes;
```

- ***.classList***

    返回一个元素的类属性的实时 `DOMTokenList` 集合。

- ***.className***

    获取或设置指定元素的 class 属性的值，返回以空格分隔的字符串

- ***.tagName***

    返回当前元素的标签名

### 元素定位

以下为 `Node` 对象的属性

- ***.parentNode***

    返回父节点，若无则返回 `null`

- ***.firstChild***

    返回第一个孩子节点

- ***.lastChild***

    返回最后一个孩子节点

- ***.nextSibling***

    返回下一个兄弟

- ***.previousSibling***

    返回前一个兄弟

- ***.childNodes***

    返回孩子节点的 `NodeList`

### 根节点

这里有两个特殊的属性，可以访问全部文档：

- `document.documentElement` - 全部文档
- `document.body` - 文档的主体

## DOM 方法

| 方法                     | 描述                                                            |
| :----------------------- | :-------------------------------------------------------------- |
| getElementById()         | 返回带有指定 ID 的元素。                                        |
| getElementsByTagName()   | 返回包含带有指定标签名称的所有元素的节点列表（集合/节点数组）。 |
| getElementsByClassName() | 返回包含带有指定类名的所有元素的节点列表。                      |
| appendChild()            | 把新的子节点添加到指定节点。                                    |
| removeChild()            | 删除子节点。                                                    |
| replaceChild()           | 替换子节点。                                                    |
| insertBefore()           | 在指定的子节点前面插入新的子节点。                              |
| createAttribute()        | 创建属性节点。                                                  |
| createElement()          | 创建元素节点。                                                  |
| createTextNode()         | 创建文本节点。                                                  |
| getAttribute()           | 返回指定的属性值。                                              |
| setAttribute()           | 把指定属性设置或修改为指定的值。                                |

### 访问

以下为 `Document` 对象的方法

- ***getElementById()***

    返回带有指定 ID 的元素

```javascript
document.getElementById("intro");
```

- ***getElementsByTagName()***

    返回带有指定标签名的所有元素

```javascript
document.getElementsByTagName("p");
```

- ***getElementsByClassName()***

    返回带有相同类名的所有 HTML 元素

以下为 `Node` 对象的方法

- ***.getRootNode()***

    返回上下文中的根节点

### 修改

#### 创建

##### 创建内容

创建元素内容的最简单的方法是使用 innerHTML 属性

```java
document.getElementById("p1").innerHTML="New text!";
```

##### 改变样式

```javascript
document.getElementById("p2").style.color="blue";
```

##### 创建元素

先创建该元素（元素节点），然后把它追加到已有的元素上

```html
<div id="d1">
<p id="p1">This is a paragraph.</p>
<p id="p2">This is another paragraph.</p>
</div>

<script>
var para=document.createElement("p");
var node=document.createTextNode("This is new.");
para.appendChild(node);

var element=document.getElementById("d1");
element.appendChild(para);
</script>
```

以下为 `Document` 对象的方法

- ***createElement()***

    创建元素节点

```javascript
var para=document.createElement("p");
```

- ***createTextNode()***

    创建文本节点

```javascript
var node=document.createTextNode("This is a new paragraph.");
```

#### 添加

以下为 `Node` 对象的方法

- ***appendChild()***

    添加孩子节点，将新元素作为父元素的最后一个子元素进行添加

```javascript
element.appendChild(para);
```
- ***insertBefore(newItem,existingItem)***

    在指定的已有子节点之前插入新的子节点

#### 删除

- ***removeChild()***

    删除指定的子节点，为 `Node` 对象的方法

```javascript
parent.removeChild(child);
```

​		在不直接引用父元素的情况下删除某个元素：找需要删除的子元素，然后使用 parentNode 属性来查找其父元素

```javascript
var child=document.getElementById("p1");
child.parentNode.removeChild(child);
```

#### 替换

- ***replaceChild(newnode,oldnode)***

    替换一个子节点为指定节点，为 `Node` 对象的方法

```javascript
parent.replaceChild(newChild,oldChild);
```

### 其他

以下为 `Node` 对象的方法

- ***.contains()***

    返回 Boolean，来表示传入的节点是否为该节点的后代节点

    `node.contains( otherNode )`

- ***.cloneNode()***

    返回调用该方法的节点的一个副本

    `var dupNode = node.cloneNode();`

- ***.hasChildNodes()***

    返回 Boolean，来表示该元素是否包含有子节点

## 事件

HTML DOM 允许您在事件发生时执行代码。

当 HTML 元素”有事情发生“时，浏览器就会生成事件：

- 当用户点击鼠标时
- 当网页已加载时
- 当图片已加载时
- 当鼠标移动到元素上时
- 当输入字段被改变时
- 当 HTML 表单被提交时
- 当用户触发按键时

### 创建事件

#### 在元素中创建

如需在用户点击某个元素时执行代码，把 JavaScript 代码添加到 HTML 事件属性中

```html
onclick=JavaScript
```

```html
<html>
<body>
<h1 onclick="this.innerHTML='hello!'">请点击这段文本!</h1>
</body>
</html>
```

#### 使用 DOM 分配事件

```html
<script>
document.getElementById("myBtn").onclick=function(){displayDate()};
</script>
```

### 事件类型

- ***onload***

    用户进入界面

    onload 事件可用于检查访客的浏览器类型和版本，以便基于这些信息来加载不同版本的网页

```html
<body onload="checkCookies()">
```

- ***onunload***

    用户离开界面

- ***onchange***

    onchange 事件常用于输入字段的验证。当用户改变输入字段的内容时，运行对应 js 语句。

```html
<input type="text" id="fname" onchange="upperCase()">
```

- ***onmouseover***

    鼠标指针移动到元素上时

- ***onmouseout***

    鼠标指针离开元素时

```html
<div 
onmouseover="mOver(this)" 
onmouseout="mOut(this)" 
style="background-color:yellow;width:200px;height:50px;padding-top:25px;text-align:center;">
Mouse Over Me
</div>

<script>
function mOver(obj)
{
obj.innerHTML="谢谢你"
}

function mOut(obj)
{
obj.innerHTML="把鼠标指针移动到上面"
}
</script>
```

- ***onmousedown***

    鼠标被点击时

- ***onmouseup***

    鼠标松开时

```html
<div 
onmousedown="mDown(this)" 
onmouseup="mUp(this)" 
style="background-color:#D94A38;width:200px;height:50px;padding-top:25px;text-align:center;">
点击这里
</div>

<script>
function mDown(obj)
{
obj.style.backgroundColor="#1ec5e5";
obj.innerHTML="松开鼠标"
}

function mUp(obj)
{
obj.style.backgroundColor="#D94A38";
obj.innerHTML="谢谢你"
}
</script>
```

- ***onclick***

    一次鼠标点击过程完成时

- ***ondblclick***

    一次鼠标双击过程完成时

- ***onfocus***

    元素获得焦点时

    在本例中，当输入框获得焦点时，其背景颜色将改变

```html
<html>
<head>
<script type="text/javascript">
function setStyle(x)
{
document.getElementById(x).style.background="yellow"
}
</script>
</head>

<body>

First name: <input type="text"
onfocus="setStyle(this.id)" id="fname" />
<br />
Last name: <input type="text"
onfocus="setStyle(this.id)" id="lname" />

</body>
</html>
```



- ***onkeydown***

    某个按键被按下时

```javascript
//键盘监听
document.addEventListener("keydown",keydown);
//参数1：表示事件，keydown:键盘向下按；参数2：表示要触发的事件
function keydown(event){
//表示键盘监听所触发的事件，同时传递传递参数event
    document.write(event.keyCode);//keyCode表示键盘编码
}
```

- ***onkeyup***

    某个按键松开时

- ***onkeypress***

    某个按键被被按下并松开时

| 属性                                                                   | 此事件发生在何时...                  |
| :--------------------------------------------------------------------- | :----------------------------------- |
| [onabort](https://www.w3school.com.cn/jsref/event_onabort.asp)         | 图像的加载被中断。                   |
| [onblur](https://www.w3school.com.cn/jsref/event_onblur.asp)           | 元素失去焦点。                       |
| [onchange](https://www.w3school.com.cn/jsref/event_onchange.asp)       | 域的内容被改变。                     |
| [onclick](https://www.w3school.com.cn/jsref/event_onclick.asp)         | 当用户点击某个对象时调用的事件句柄。 |
| [ondblclick](https://www.w3school.com.cn/jsref/event_ondblclick.asp)   | 当用户双击某个对象时调用的事件句柄。 |
| [onerror](https://www.w3school.com.cn/jsref/event_onerror.asp)         | 在加载文档或图像时发生错误。         |
| [onfocus](https://www.w3school.com.cn/jsref/event_onfocus.asp)         | 元素获得焦点。                       |
| [onkeydown](https://www.w3school.com.cn/jsref/event_onkeydown.asp)     | 某个键盘按键被按下。                 |
| [onkeypress](https://www.w3school.com.cn/jsref/event_onkeypress.asp)   | 某个键盘按键被按下并松开。           |
| [onkeyup](https://www.w3school.com.cn/jsref/event_onkeyup.asp)         | 某个键盘按键被松开。                 |
| [onload](https://www.w3school.com.cn/jsref/event_onload.asp)           | 一张页面或一幅图像完成加载。         |
| [onmousedown](https://www.w3school.com.cn/jsref/event_onmousedown.asp) | 鼠标按钮被按下。                     |
| [onmousemove](https://www.w3school.com.cn/jsref/event_onmousemove.asp) | 鼠标被移动。                         |
| [onmouseout](https://www.w3school.com.cn/jsref/event_onmouseout.asp)   | 鼠标从某元素移开。                   |
| [onmouseover](https://www.w3school.com.cn/jsref/event_onmouseover.asp) | 鼠标移到某元素之上。                 |
| [onmouseup](https://www.w3school.com.cn/jsref/event_onmouseup.asp)     | 鼠标按键被松开。                     |
| [onreset](https://www.w3school.com.cn/jsref/event_onreset.asp)         | 重置按钮被点击。                     |
| [onresize](https://www.w3school.com.cn/jsref/event_onresize.asp)       | 窗口或框架被重新调整大小。           |
| [onselect](https://www.w3school.com.cn/jsref/event_onselect.asp)       | 文本被选中。                         |
| [onsubmit](https://www.w3school.com.cn/jsref/event_onsubmit.asp)       | 确认按钮被点击。                     |
| [onunload](https://www.w3school.com.cn/jsref/event_onunload.asp)       | 用户退出页面。                       |

## 对象

EventTarget <- Node <- Element <- Document

### Node

**`Node`** 是一个接口，各种类型的 DOM API 对象会从这个接口继承。它允许我们使用相似的方式对待这些不同类型的对象；比如, 继承同一组方法，或者用同样的方式测试。

### Element

**`Element`** 是一个通用性非常强的基类，所有 `Document`对象下的对象都继承自它。这个接口描述了所有相同种类的元素所普遍具有的方法和属性

### Document

`Document` 接口表示任何在浏览器中载入的网页，并作为网页内容的入口，也就是 DOM 树

`Document` 接口描述了任何类型的文档的通用属性与方法。

#### 属性

- ***.body***

    返回当前文档中的 `<body>` 元素或者 `<frameset>` 元素

- ***.scripts***

    返回一个 `HTMLCollection` 对象,包含了当前文档中所有 \<script> 元素的集合

    `var scriptList = document.scripts;`

- ***.URL***

    返回 url

- ***.title***

    返回标题

#### 方法

- ***.write()***

    向文档流中写入内容

### NodeList

`NodeList` 对象是节点的集合，通常是由属性，如`Node.childNodes` 和 方法，如`document.querySelectorAll` 返回的。

`NodeList` **不是一个数组**，是一个类似数组的对象 (*Like Array Object*)。虽然 `NodeList` 不是一个数组，但是可以使用 `forEach()` 来迭代，也可以用下标直接访问

在一些情况下，`NodeList` 是一个实时集合，也就是说，如果文档中的节点树发生变化，`NodeList` 也会随之变化

#### 属性

- ***NodeList.length***
    `NodeList` 中包含的节点个数。

#### 遍历

使用 length 属性来循环节点列表

```javascript
x=document.getElementsByTagName("p");

for (i=0;i<x.length;i++)
{
document.write(x[i].innerHTML);
document.write("<br />");
}
```

for...of 循环同样能正确的遍历 `NodeList` 对象：

```javascript
var list = document.querySelectorAll('input[type=checkbox]');
for (var checkbox of list) {
  checkbox.checked = true;
}
```

### DOMTokenList

`DOMTokenList` 接口表示一组空格分隔的标记（tokens），主要用于操作 `classList`

#### 属性

- ***.length***

    一个整数，表示存储在该对象里值的个数

#### 方法

- ***.contains(token)***
    是否包括指定字符串，返回 `bool`
- ***.add(token)***
    添加一个或多个标记（`token`）到 `DOMTokenList` 列表中。
- ***.remove(token)***
    移除一个或多个标记（`token`）。
- ***.replace(oldToken, newToken)***
    使用 `newToken` 替换 `token` 。

#### 修改空格和重复的特性

修改 `DOMTokenList` 的方法（例如 `DOMTokenList.add()`）会自动去除多余的空格（Whitespace）和列表中的重复项目

```javascript
<span class="    d   d e f"></span>

let span = document.querySelector("span");
let classes = span.classList;
span.classList.add("x");
span.textContent = `span classList is "${classes}"`;
```

输出：span classList is "d e f x"

### Window

`Window` 对象表示浏览器中打开的窗口，如果文档包含框架（frame 或 iframe 标签），浏览器会为 HTML 文档创建一个 `window` 对象，并为每个框架创建一个额外的 `window` 对象。

#### 属性

#### 方法

- ***.alert()***

    显示带有一条指定消息和一个 OK 按钮的警告框

    `window.alert(message);`

- ***.open()***

    打开一个新的浏览器窗口或查找一个已命名的窗口

    `window.open(URL,name,features,replace)`

    | 参数     | 描述                                                                                                                                                                                                                                                                                                         |
    | :------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | URL      | 一个可选的字符串，声明了要在新窗口中显示的文档的 URL。如果省略了这个参数，或者它的值是空字符串，那么新窗口就不会显示任何文档。                                                                                                                                                                               |
    | name     | 一个可选的字符串，该字符串是一个由逗号分隔的特征列表，其中包括数字、字母和下划线，该字符声明了新窗口的名称。这个名称可以用作标记 \<a> 和 \<form> 的属性 target 的值。如果该参数指定了一个已经存在的窗口，那么 open() 方法就不再创建一个新窗口，而只是返回对指定窗口的引用。在这种情况下，features 将被忽略。 |
    | features | 一个可选的字符串，声明了新窗口要显示的标准浏览器的特征。如果省略该参数，新窗口将具有所有标准特征。                                                                                                                                                                                                           |
    | replace  | 一个可选的布尔值。规定了装载到窗口的 URL 是在窗口的浏览历史中创建一个新条目，还是替换浏览历史中的当前条目。支持下面的值：true - URL 替换浏览历史中的当前条目。false - URL 在浏览历史中创建新的条目。                                                                                                         |

```html
<html>

<head>
    <script type="text/javascript">
        function open_win() {
            window.open("http://www.w3school.com.cn")
        }
    </script>
</head>

<body>

    <input type=button value="Open Window" onclick="open_win()" />

</body>

</html>
```

- ***.close()***

    关闭浏览器窗口

- ***.confirm(message)***

    如果用户点击确定按钮，则 `confirm()` 返回 true。如果点击取消按钮，则 `confirm()` 返回 false

```html
<html>

<head>
    <script type="text/javascript">
        function disp_confirm() {
            var r = confirm("Press a button")
            if (r == true) {
                document.write("You pressed OK!")
            }
            else {
                document.write("You pressed Cancel!")
            }
        }
    </script>
</head>

<body>

    <input type="button" onclick="disp_confirm()" value="Display a confirm box" />

</body>

</html>
```

- ***.moveBy()***

    相对窗口的当前坐标把它移动指定的像素

    `window.moveBy(x,y)`

    下面的例子将把窗口相对其当前位置移动 50 个像素

```html
<html>

<head>
    <script type="text/javascript">
        function moveWin() {
            myWindow.moveBy(50, 50)
        }
    </script>
</head>

<body>

    <script type="text/javascript">
        myWindow = window.open('', '', 'width=200,height=100')
        myWindow.document.write("This is 'myWindow'")
    </script>

    <input type="button" value="Move 'myWindow'" onclick="moveWin()" />

</body>

</html>
```

- ***.moveTo()***

    把窗口的左上角移动到一个指定的坐标

    `window.moveTo(x,y)`

- ***.print()***

    打印当前窗口的内容

- ***.prompt()***

    显示可提示用户进行输入的对话框

    如果用户单击提示框的取消按钮，则返回 null。如果用户单击确认按钮，则返回输入字段当前显示的文本。

    `prompt(text,defaultText)`

    | 参数        | 描述                                                       |
    | :---------- | :--------------------------------------------------------- |
    | text        | 可选。要在对话框中显示的纯文本（而不是 HTML 格式的文本）。 |
    | defaultText | 可选。默认的输入文本。                                     |

```html
<html>

<head>
    <script type="text/javascript">
        function disp_prompt() {
            var name = prompt("Please enter your name", "")
            if (name != null && name != "") {
                document.write("Hello " + name + "!")
            }
        }
    </script>
</head>

<body>

    <input type="button" onclick="disp_prompt()" value="Display a prompt box" />

</body>

</html>
```

- ***.resizeBy(width,height)***

    根据指定的像素来调整窗口的大小

- ***.resizeTo(width,height)***

    把窗口大小调整为指定的宽度和高度

- ***.scrollBy()***

    把内容滚动指定的像素数

    `scrollBy(xnum,ynum)`

- ***.scrollTo()***

    把内容滚动到指定的坐标

    `scrollTo(xpos,ypos)`

- ***setTimeOut()***

    在指定的毫秒数后调用函数或计算表达式

    `setTimeout(code,millisec)`

    `setTimeout()` 只执行 code 一次。如果要多次调用，请使用 `setInterval()` 或者让 code 自身再次调用 `setTimeout()`

    ```javascript
    function timedMsg() {
                var t = setTimeout("alert('5 seconds!')", 5000)
            }
    ```

- ***setInterval()***

    按照指定的周期（以毫秒计）来调用函数或计算表达式

    `setInterval(code,millisec[,"lang"])`

    返回一个可以传递给 `Window.clearInterval() `从而取消对 code 的周期性执行的值

    此方法会不停地调用函数，直到 `clearInterval()` 被调用或窗口被关闭。

    ```html
    <html>
    
    <body>
        <p id='clock'></p>
        <script language=javascript>
            var int = self.setInterval("clock()", 50)
            function clock() {
                var t = new Date()
                document.getElementById("clock").innerHTML = t
            }
        </script>
        </form>
        <button onclick="int=window.clearInterval(int)">
            Stop interval</button>
    
    </body>
    
    </html>
    ```

- ***clearInterval()***

    取消由` setInterval()` 设置的 timeout

    `clearInterval(id_of_setinterval)`

    id_of_setinterval：由 `setInterval()` 返回的 ID 值