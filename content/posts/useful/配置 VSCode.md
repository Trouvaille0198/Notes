---
title: "配置 VSCode"
date: 2023-02-21
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
---

# 配置 VSCode

> https://geek-docs.com/vscode/vscode-tutorials/what-is-vscode.html

## Debug 按键解释

- **继续** F5：直接跳到下一个断点
- **逐过程** F10：运行到**当前文件夹**的下一行（跳过当前语句，调用其他文件夹的所有语句）
    - 比如 a = func_b()，如果 func_b 是其他文件夹定义的复杂函数，直接跳过；
- **单步调试** F11：运行到自己写的文件下一行语句（最细致）
    - 比如 a = func_b()，如果 func_b 是其他文件定义的复杂函数，则进入其他文件，运行下一步；
- **单步跳出** Shift + F11：当 debug 陷入某个循环时，直接跳过当前循环。
- **重启**，重新 debug

## 常用快捷键记录

### 全局配置

pin：Ctrl + Alt + P

搜索文件：Ctrl + P 

### 插件配置

添加书签：Ctrl + Alt + M

复制行所在的文件路径及行号：Alt + L

### 个人配置

前进，后退：Alt + ←，Alt + →
