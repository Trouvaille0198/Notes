---
title: "pyinstaller"
date: 2021-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# pyinstaller

## 步骤

1. 在 cmd 中使用命令找到 py 程序所在目录
2. 使用命令

```shell
pyinstaller -F <name>.py
```

​		dist 文件夹中的 exe 即为我们所需要的可执行文件

## 常用参数

语法

```shell
pyinstaller 选项 Python 源文件
```

| 参数                | 描述                               |
| :------------------ | :--------------------------------- |
| -h                  | 查看帮助                           |
| --clean             | 清理打包过程中的临时文件           |
| -D, --onedir        | 默认值，生成dist文件夹             |
| -F, --onefile       | 在dist文件夹中只生成独立的打包文件 |
| -i <图标文件名.ico> | 指定打包程序使用的图标（icon）文件 |

