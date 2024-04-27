---
title: "Python ipdb 库"
date: 2022-09-15
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# ipdb

## 介绍

是一款集成了 Ipython 的 Python 代码命令行调试工具，可以看做 PDB 的升级版

开发一直是在 pycharm 下，虽然 pycharm 可以断点调试，但是程序是一直往下走的，没法像 Viso 那样拖动当前的位置，如果发现某个地方因为数据导致有问题，需要断开调试，修改完数据后，再次 debug，很废时间。而 ipdb 可以通过 **jump 行数**任意各种跳，相当方便

## 启动

### 命令式

`python -m ipdb xxx.py` 单步调试

### 集成式

在需要断点的地方插入两句话

```py
import ipdb
ipdb.set_trace()
```

- 运行程序后, 会在执行到 set_trace()的时候中断程序 并出现提示符
- `ipdb>`
- 好像进入了 ipython 一样

## 常用命令

- h (help) - 帮助文档
- l (list) 开始行,结束行 - 查看指定行数之间的代码（逗号很重要），如果不带结束行，则显示开始行的上下 5 行。
- w (where) - 打印目前所在的行号位置以及上下文信息。
- j (jump) 行 - 跳转到指定行。
- n (next) - 单步执行。函数调用也是一个语句。
- s (step|step next) - 进入函数内部。
- a (args) - 进入函数内部后，打印函数的所有参数。
- u (up) - 跳回上一层调用，只是在代码层面跳转，程序执行到哪一步还是在哪一步，不信可以用 n 命令试一下。
- d (down) - 跳到调用的下一层，只是在代码层面跳转，程序执行到哪一步还是在哪一步，不信可以用 n 命令试一下。
- b (break) [ ([filename:]lineno | function) [, condition] ] - 在指定文件（不指定，默认当前文件）指定行 打断点
- p (print) 变量 - 打印变量的值
- pp (pretty print) 变量 - 格式化打印变量的值
- c (continue) - 继续运行，直到遇到下一个断点
- cl (clear) filename:lineno - 清除断点（只能清除交互调试中打的断点，在代码中 set_trace()是无法清除的）
- r (return) - 继续运行直到函数返回（函数内 return 语句，如果没有返回值，则跳到函数的最后）
- restart - 重新启动调试器，断点等信息都会保留
- q (quit) - 退出调试模式
- 变量名 - 查看变量内容
- ! 变量名 - 如果代码中变量名与 ipdb 命令冲突，则使用 **!** 解决冲突。
