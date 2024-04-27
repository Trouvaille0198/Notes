---
title: "text/template"
date: 2022-06-22
draft: false
author: "MelonCholi"
tags: []
categories: [Golang]
---

# text/template

`text/template` 是 Golang 标准库，实现数据驱动模板以生成文本输出，可理解为一组文本按照特定格式嵌套动态嵌入另一组文本中。可用来开发代码生成器。

`text/template` 包是数据驱动的文本输出模板，即在编写好的模板中填充数据。一般而言，模板使用流程分为三个步骤：定义模板、解析模板、数据驱动模板。

```go
package main

import (
    "os"
    "text/template"
)

func main() {
    //创建模板
    id := 100
    tmpl, err := template.New("tplname").Parse("id = {{.}}")
    if err != nil {
        panic(err)
    }
    //模板合并输出
    err = tmpl.Execute(os.Stdout, id)
    if err != nil {
        panic(err)
    }
}

// output: id = 100
```

## Actions

- `{{.}}` 中 `.` 点号表示传入模板的数据，代表**当前作用域的当前对象**
- `.` 点可代表 Golang 的任何类型，比如 Struct、Map 等。
- `{{` 和 `}}` 包裹的内容统称为 `Actions`

模板的输入文本是任何格式的 UTF-8 编码文本，，`action` 可分为两种：

- 数据求值（data evaluations）：`action` 数据求值的结果会直接复制到模板中
- 控制结构（control structures）：`action` 控制结构和 Golang 程序类似，也是条件语句、循环语句、变量、函数调用等

将模板成功解析后可安全地在并发环境中使用，若输出到同一个 `io.Writer` 数据可能会重叠，不能保证并发执行的先后顺序。

### 分类

下面是一个 action（动作）的列表。"Arguments" 和 "pipelines" 代表数据的执行结果，细节定义在后面。

- `{{/* a comment */}}`
  - 注释，执行时会忽略。可以多行。注释不能嵌套，并且必须紧贴分界符始止，就像这里表示的一样。

- `{{pipeline}}`
  - pipeline 的值的默认文本表示会被拷贝到输出里。
- `{{if pipeline}} T1 {{end}}`
  - 如果 pipeline 的值为 empty，不产生输出，否则输出 T1 执行结果。不改变 dot 的值。
  - Empty 值包括 false、0、任意 nil 指针或者 nil 接口，任意长度为 0 的数组、切片、字典。
- `{{if pipeline}} T1 {{else}} T0 {{end}}`
  - 如果 pipeline 的值为 empty，输出 T0 执行结果，否则输出 T1 执行结果。不改变 dot 的值。
- `{{if pipeline}} T1 {{else if pipeline}} T0 {{end}}`
  - 用于简化 if-else 链条，else action 可以直接包含另一个 if；等价于：
    - `{{if pipeline}} T1 {{else}}{{if pipeline}} T0 {{end}}{{end}}`
- `{{range pipeline}} T1 {{end}}`
  - pipeline 的值必须是 array、slice、map 或者 chan。
  - 如果 pipeline 的值其长度为 0，不会有任何输出；否则 dot 依次设为 array、slice、map 或者 chan 的每一个成员元素并执行 T1；
  - 如果 pipeline 的值为 map，且键可排序的基本类型，元素也会按键的顺序排序。
- `{{range pipeline}} T1 {{else}} T0 {{end}}`
  - pipeline 的值必须是数组、切片、字典或者通道。
  - 如果 pipeline 的值其长度为 0，不改变 dot 的值并执行 T0；否则会修改 dot 并执行 T1
- `{{template "name"}}`
  - 执行名为 name 的模板，提供给模板的参数为 nil，如模板不存在输出为 ""
- `{{template "name" pipeline}}`
  - 执行名为 name 的模板，提供给模板的参数为 pipeline 的值。
- `{{with pipeline}} T1 {{end}}`
  - 如果 pipeline 为 empty 不产生输出，否则将 dot 设为 pipeline 的值并执行 T1。不修改外面的 dot
- `{{with pipeline}} T1 {{else}} T0 {{end}}`
  - 如果 pipeline 为 empty，不改变 dot 并执行 T0，否则 dot 设为 pipeline 的值并执行 T1。

## Arguments

- go 语法的布尔值、字符串、字符、整数、浮点数、虚数、复数，视为无类型字面常数，字符串不能跨行
- 关键字 nil，代表一个 go 的无类型的 nil 值
- 字符 `.`（句点，用时不加单引号），代表 dot 的值
- 变量名，以美元符号起始加上（可为空的）字母和数字构成的字符串，如：`$piOver2` 和 $；执行结果为变量的值，变量参见下面的介绍
- **结构体**数据的字段名，以句点起始，如：`.Field`；
  - 执行结果为字段的值，支持链式调用：`.Field1.Field2`；
  - 字段也可以在变量上使用（包括链式调用）：`$x.Field1.Field2`；
- 字典类型数据的键名；以句点起始，如：`.Key`；
  - 执行结果是该键在字典中对应的成员元素的值；
  - 键也可以和字段配合做链式调用，深度不限：`.Field1.Key1.Field2.Key2`；
  - 虽然键也必须是字母和数字构成的标识字符串，但不需要以大写字母起始；
  - 键也可以用于变量（包括链式调用）：`$x.key1.key2`；
- 数据的无参数方法名，以句点为起始，如：`.Method`；
  - 执行结果为 dot 调用该方法的返回值，`dot.Method()`；
  - 该方法必须有 1 到 2 个返回值，如果有 2 个则后一个必须是 error 接口类型；
  - 如果有 2 个返回值的方法返回的 error 非 nil，模板执行会中断并返回给调用模板执行者该错误；
  - 方法可和字段、键配合做链式调用，深度不限：`.Field1.Key1.Method1.Field2.Key2.Method2`；
  - 方法也可以在变量上使用（包括链式调用）：`$x.Method1.Field`；
- 无参数的函数名，如：`fun`；
- 执行结果是调用该函数的返回值 `fun()`；对返回值的要求和方法一样；函数和函数名细节参见后面。
- 上面某一条的实例加上括弧（用于分组）
  - 执行结果可以访问其字段或者键对应的值：
  - `print (.F1 arg1) (.F2 arg2)`
  - `(.StructValuedMethod "arg").Field`

### 去除空白

template 引擎在进行替换的时候，是完全按照文本格式进行替换的。除了需要评估和替换的地方，所有的行分隔符、空格等等空白都原样保留。所以，**对于要解析的内容，不要随意缩进、随意换行**。

可以在 `{{` 符号的后面加上短横线并保留一个或多个空格"- "来去除它前面的空白 (包括换行符、制表符、空格等)，即 `{{- xxxx`。

在 `}}` 的前面加上一个或多个空格以及一个短横线 "-" 来去除它后面的空白，即 `xxxx -}}`。

```go
{{23}} < {{45}}        -> 23 < 45
{{23}} < {{- 45}}      ->  23 <45
{{23 -}} < {{45}}      ->  23< 45
{{23 -}} < {{- 45}}    ->  23<45
```

其中 `{{23 -}}` 中的短横线去除了这个替换结构后面的空格，即 `}} <` 中间的空白。同理 `{{- 45}}` 的短横线去除了 `< {{` 中间的空白。

## template.New

```go
func New(name string) *Template
```

`template.New()` 创建名为 `name` 的模板

```go
package main

import (
    "os"
    "text/template"
)

func main() {
    //模板变量
    type User struct {
        Id   int
        Name string
    }
    user := User{100, "admin"}
    //创建模板
    tplname := "user"
    tmpl := template.New(tplname)
    //解析模板
    text := "id = {{.Id}} name = {{.Name}}"
    tpl, err := tmpl.Parse(text)
    if err != nil {
        panic(err)
    }
    //渲染输出
    err = tpl.Execute(os.Stdout, user)
    if err != nil {
        panic(err)
    }
}
```

```shell
$ go run main.go
id = 100 name = admin
```

## Parse

### template.Parse

```go
func (t *Template) Parse(text string) (*Template, error)
```

`template.Parse()` 方法将字符串 `text` 解析为模板，嵌套定义的模板会关联到最顶层 `t`。

`template.Parse()` 可以多次调用，但只有第一次调用可以包含空格、注释、模板定义之外的文本。若后续调用解析后仍剩余文本会引发错误、返回 `nil`、丢弃剩余文本。若解析得到的模板已有相关联的同名模板则会覆盖原模板。

### template.ParseFiles

`ParseFiles` 方法接收 一个字符串，字符串的内容是一个模板文件的路径，可为绝对路径或相对路径。

解析模板文件

```shell
$ vim view/default.html
```

```html
id = {{.Id}} name = {{.Name}}
```

解析模板文件

```shell
$ vim main.go
```

```go
package main

import (
    "os"
    "text/template"
)

func main() {
    //模板变量
    type User struct {
        Id   int
        Name string
    }
    user := User{100, "admin"}
    //创建模板
    tmpl, err := template.ParseFiles("./view/default.html")
    if err != nil {
        panic(err)
    }
    //模板合并输出
    err = tmpl.Execute(os.Stdout, user)
    if err != nil {
        panic(err)
    }
}
```

```shell
$ go run main.go
id = 100 name = admin
```

## Execute

### template.ExecuteTemplate

多模板时指定模板

```go
package main

import (
    "os"
    "text/template"
)

func main() {
    // 模板变量
    type User struct {
        Id   int
        Name string
    }
    user := User{100, "admin"}
    // 创建模板
    tplname := "tplname"
    tmpl := template.New(tplname)
    // 解析模板
    text := "id = {{.Id}} name = {{.Name}}"
    tpl, err := tmpl.Parse(text)
    if err != nil {
        panic(err)
    }
    // 渲染输出
    err = tpl.ExecuteTemplate(os.Stdout, tplname, user)
    if err != nil {
        panic(err)
    }
}
```

### template.Execute

`template.Execute()` 方法将解析好的模板应用到`data`，并将输出写入 `wr`。若执行时出现错误则会停止执行，但有可能已经写入部分数据，模板可以安全的并发执行。

```go
func (t *Template) Execute(wr io.Writer, data interface{}) (err error)
```

输出到指定文件

```go
package main

import (
    "os"
    "text/template"
)

func main() {
    // 模板变量
    type User struct {
        Id   int
        Name string
    }
    user := User{100, "admin"}
    // 创建模板
    tplname := "tplname"
    tmpl := template.New(tplname)
    // 解析模板
    text := "id = {{.Id}} name = {{.Name}}"
    tpl, err := tmpl.Parse(text)
    if err != nil {
        panic(err)
    }
    //输出文件
    file, err := os.OpenFile("./public/tpl.txt", os.O_CREATE|os.O_WRONLY, 0755)
    if err != nil {
        panic(err)
    }
    //渲染输出
    err = tpl.Execute(file, user)
    if err != nil {
        panic(err)
    }
}
```

读取模板文件解析后输出到指定位置

```go
package main

import (
    "os"
    "text/template"
)

func main() {
    //模板变量
    type User struct {
        Id   int
        Name string
    }
    user := User{100, "admin"}
    //解析模板
    tplFile := "./view/default.html"
    tpl, err := template.ParseFiles(tplFile)
    if err != nil {
        panic(err)
    }
    //输出文件
    outFile := "./runtime/view/default.html"
    file, err := os.OpenFile(outFile, os.O_CREATE|os.O_WRONLY, 0755)
    if err != nil {
        panic(err)
    }
    //渲染输出
    err = tpl.Execute(file, user)
    if err != nil {
        panic(err)
    }
}
```

