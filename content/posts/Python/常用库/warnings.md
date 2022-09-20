---
title: "Python warnings 库"
date: 2022-09-15
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# warnings

Python 通过调用 warnings 模块中定义的 `warn()` 函数来发出警告。警告消息通常用于提示用户一些错误或者过时的用法，当这些情况发生时我们不希望抛出异常或者直接退出程序。

警告消息通常写入 `sys.stderr`，对警告的处理方式可以灵活的更改，例如忽略或者转变为异常。警告的处理可以根据警告类别，警告消息的文本和发出警告消息的源位置而变化。对相同源位置的特定警告的重复通常被抑制。

警告控制分为两个阶段：首先，警告被触发时，确定是否应该发出消息；接下来，如果要发出消息，则使用用户可设置的钩子来格式化和打印消息。

警告过滤器可以用来控制是否发出警告消息，警告过滤器是一些匹配规则和动作的序列。可以通过调用 `filterwarnings()` 将规则添加到过滤器，并通过调用 `resetwarnings()` 将其重置为默认状态。

警告消息的输出是通过调用 `showwarning()` 函数来完成的，其可以被覆盖；该函数的默认实现通过调用 `formatwarning()` 格式化消息，这也可以由自定义实现使用。

## 警告类别

內建警告类型：

| 类                        | 描述                                         |
| :------------------------ | :------------------------------------------- |
| Warning                   | 所有警告类别类的基类，它是 Exception 的子类  |
| UserWarning               | 函数 warn() 的默认类别                       |
| DeprecationWarning        | 用于已弃用功能的警告（默认被忽略）           |
| SyntaxWarning             | 用于可疑语法的警告                           |
| RuntimeWarning            | 用于有关可疑运行时功能的警告                 |
| FutureWarning             | 对于未来特性更改的警告                       |
| PendingDeprecationWarning | 对于未来会被弃用的功能的警告（默认将被忽略） |
| ImportWarning             | 导入模块过程中触发的警告（默认被忽略）       |
| UnicodeWarning            | 与 Unicode 相关的警告                        |
| BytesWarning              | 与 bytes 和 bytearray 相关的警告 (Python3)   |
| ResourceWarning           | 与资源使用相关的警告(Python3)                |

可以通过继承內建警告类型来实现自定义的警告类型，警告类型必须始终是 `Warning` 类的子类。

## 警告过滤器

警告过滤器用于控制警告的行为，如**忽略，显示或转换为错误（引发异常）**。警告过滤器维护着一个有序的过滤规则列表，匹配规则用于确定如何处理警告，任何特定警告都将依次与列表中的每个过滤规则匹配，直到找到匹配为止。过滤规则类型为一个元组 `(action，message，category，module，lineno)`，其中：

- **action** 为以下值：

| 值        | 处理方式                                |
| :-------- | :-------------------------------------- |
| "error"   | 将匹配警告转换为异常                    |
| "ignore"  | 忽略匹配的警告                          |
| "always"  | 始终输出匹配的警告                      |
| "default" | 对于同样的警告只输出第一次出现的警告    |
| "module"  | 在一个模块中只输出第一次出现的警告      |
| "once"    | 输出第一次出现的警告,而不考虑它们的位置 |

- **message** 是包含正则表达式的字符串，警告消息的开始必须匹配，不区分大小写
- **category** 是一个警告类型（必须是 Warning 的子类）
- **module** 是包含模块名称的正则表达式字符串，区分大小写
- **lineno** 是一个整数，警告发生的行号，为 0 则匹配所有行号

## 默认警告过滤器

默认情况下，Python 设置了几个警告过滤器，可以通过 -W 命令行选项和调用 `filterwarnings()` 函数来覆盖它们。

- `DeprecationWarning` 和 `PendingDeprecationWarning` 和 `ImportWarning` 被默认忽略。
- 除非 -b 选项给出一次或两次，否则忽略 `BytesWarning`；在这种情况下，此警告或者被输出（-b）或者变成异常（-bb）。
- 除非 Python 是在调试模式下构建的，否则将忽略 ResourceWarning。

在 3.2 版中的调整: 除 PendingDeprecationWarning 之外，默认情况下将忽略 DeprecationWarning。

## 可用函数

**warn**

```py
warnings.warn(message, category=None, stacklevel=1, source=None)
```

触发异常。`category` 参数默认为 UserWarning。`message` 参数为警告消息，可以是 Warning 实例，在这种情况下，将忽略 category 并使用 `message.__class__`，消息文本则为 str(message)。

**warn_explicit**

```py
warnings.warn_explicit(message, category, filename, lineno, module=None, registry=None, module_globals=None, source=None)
```

这是 warn() 函数的低级接口，明确传递消息，类别，文件名和行号，以及可选的模块名称和注册表（应该是模块的 `__warningregistry__` 字典）

**showwarning**

```py
warnings.showwarning(message, category, filename, lineno, file=None, line=None)
```

写入警告到文件。默认调用 `formatwarning(message, category, filename, lineno, line)` 并将结果字符串写入 `file`，默认为 sys.stderr。 `line` 是包含在警告消息中的一行源代码；如果未提供则尝试读取由 filename 和 lineno 指定的行。

**formatwarning**

```py
warnings.formatwarning(message, category, filename, lineno, line=None)
```

格式化警告，返回一个字符串。可能包含嵌入的换行符，并以换行符结束。 `line` 是包含在警告消息中的一行源代码；如果不提供则尝试读取由 filename 和 lineno 指定的行。

**filterwarnings**

```py
warnings.filterwarnings(action, message='', category=Warning, module='', lineno=0, append=False)
```

过滤警告，在 `警告过滤器规则` 列表中插入一个条目。默认情况下，条目插入在前面；如果 append 为真，则在末尾插入。它检查参数的类型，编译 message 和 module 的正则表达式，并将它们作为警告过滤器列表中的元组插入。如果多个地方都匹配特定的警告，那么更靠近列表前面的条目会覆盖列表中后面的条目，省略的参数默认为匹配一切的值。

**simplefilter**

```py
warnings.simplefilter(action, category=Warning, lineno=0, append=False)
```

复制

简单易用的过滤器，类似 `filterwarnings()` 函数，但是不需要正则表达式。

**resetwarnings**

```py
warnings.resetwarnings()
```

重置警告过滤器。这会丢弃所有以前对 `filterwarnings()` 调用的影响，包括 -W 命令行选项和对 simplefilter() 的调用的影响。

## 可用的上下文管理器

```py
class warnings.catch_warnings(*, record=False, module=None)
```

捕获警告，在退出上下文时恢复警告过滤器和 `showwarning()` 函数功能。如果 record 参数是 False （缺省值），则上下文管理器在入口处返回 None。如果 record 是 True，则返回一个列表，该列表元素为 `showwarning()` 函数所见的对象，列表中的每个元素都具有与 `showwarning()` 的参数具有相同名称的属性。

```py
import warnings

warnings.simplefilter("always")

def fxn():
    warnings.warn("this is a warning", Warning)

with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    fxn()

with warnings.catch_warnings(Warning):
    warnings.warn("this is a warning2", Warning)

warnings.warn("this is a warning3", Warning)

def fxn2():
    warnings.warn("deprecated", DeprecationWarning)

with warnings.catch_warnings(record=True) as w:
    # Cause all warnings to always be triggered.
    warnings.simplefilter("always")
    # Trigger a warning.
    fxn2()
    # Verify some things
    assert len(w) == 1
    assert issubclass(w[-1].category, DeprecationWarning)
    assert "deprecated" in str(w[-1].message)
```

可以从命令行通过传递 -Wd 参数到解释器（即为 `-W default` 的速记）。这将为所有警告启用默认处理，包括默认情况下忽略的警告。要更改遇到的警告所采取的操作，只需更改传递给 -W 的参数即可，如 `-W error`。可以用 `python --help` 来查看 -W 参数的详细使用。

在代码中实现 `-Wd` 的功能为:

```py
warnings.simplefilter('default')
```

这样的代码应该在程序开始被执行，否则有些警告可能仍然会被触发。
