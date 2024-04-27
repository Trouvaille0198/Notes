---
title: "exa"
date: 2022-01-13
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---

# exa

> exa is a modern replacement for ls.

项目地址：https://github.com/ogham/exa

## 安装

On Ubuntu 20.10 (Groovy Gorilla) and later, install the [`exa`](https://packages.ubuntu.com/jammy/exa) package.

```
sudo apt install exa
```

## 使用

`exa` 使用非常简单，其语法格式为 `exa [OPTIONS] [FILES]`，基本上和 `ls` 一样。

一行只输出一个结果

```sh
$ exa -1 
```

输出结果并显示详细信息

```sh
$ exa -l
```

对比：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20230113163739849.png" alt="image-20230113163739849" style="zoom: 67%;" />

递归显示当然目录的所有文件

> 输出结果的顺序为：先显示当前文件夹的，再递归显示每个子文件夹中的文件。

```sh
$ exa -R
```

以目录树结构显示目录下所有文件

```sh
$ exa -T
```

以网格方式排序

```sh
$ exa -x
```