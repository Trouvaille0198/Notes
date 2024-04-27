---
title: "SQLite"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [数据库,快速入门]
categories: [数据库]
---

# SQLite

## 认识

SQLite 是一个进程内的库，实现了自给自足的、无服务器的、零配置的、事务性的 SQL 数据库引擎。

就像其他数据库，SQLite 引擎不是一个独立的进程，且可以按应用程序需求进行静态或动态连接。SQLite 直接访问其存储文件。

### 特性

- 不需要一个单独的服务器进程或操作的系统（无服务器的）。
- 不需要配置，这意味着不需要安装或管理。
- 一个完整的 SQLite 数据库是存储在一个单一的跨平台的磁盘文件。
- SQLite 是非常小的，是轻量级的，完全配置时小于 400KiB，省略可选功能配置时小于 250KiB。
- SQLite 是自给自足的，这意味着不需要任何外部的依赖。
- SQLite 事务是完全兼容 ACID 的，允许从多个进程或线程安全访问。
- SQLite 支持 SQL92（SQL2）标准的大多数查询语言的功能。
- SQLite 使用 ANSI-C 编写的，并提供了简单和易于使用的 API。
- SQLite 可在 UNIX（Linux, Mac OS-X, Android, iOS）和 Windows（Win32, WinCE, WinRT）中运行。

### 命令

与关系数据库进行交互的标准 SQLite 命令类似于 SQL。命令包括 CREATE、SELECT、INSERT、UPDATE、DELETE 和 DROP。这些命令基于它们的操作性质可分为以下几种：

**DDL - 数据定义语言**

| 命令   | 描述                                                   |
| :----- | :----------------------------------------------------- |
| CREATE | 创建一个新的表，一个表的视图，或者数据库中的其他对象。 |
| ALTER  | 修改数据库中的某个已有的数据库对象，比如一个表。       |
| DROP   | 删除整个表，或者表的视图，或者数据库中的其他对象。     |

**DML - 数据操作语言**

| 命令   | 描述           |
| :----- | :------------- |
| INSERT | 创建一条记录。 |
| UPDATE | 修改记录。     |
| DELETE | 删除记录。     |

**DQL - 数据查询语言**

| 命令   | 描述                           |
| :----- | :----------------------------- |
| SELECT | 从一个或多个表中检索某些记录。 |

![image-20240328165557012](C:\Users\chenx\AppData\Roaming\Typora\typora-user-images\image-20240328165557012.png)
