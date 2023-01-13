---
title: "fd"
date: 2023-01-13
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---

# fd

fd 是基于 Rust 开发的一个速度超快的命令行搜索工具，fd 旨在成为 Linux / Unix 下 find 命令的替代品。

fd 虽然不能提供现在 find 命令所有的强大功能，但它也提供了足够强大的功能来满足你日常需要。比如：简洁的语法、彩色的终端输出、超快的查询速度、智能大小写、支持正则表达式以及可并行执行命令等特性。

项目地址：https://github.com/sharkdp/fd

## 安装

从 [releases 页面](https://github.com/sharkdp/fd/releases)下载最新`.deb`包装并通过以下方式安装:

```
sudo dpkg -i fd_7.0.0_amd64.deb  # adapt version number and architecture
```

## 用法

```shell
❯ fd -h
A program to find entries in your filesystem

Usage: fd [OPTIONS] [pattern] [path]...

Arguments:
  [pattern]  the search pattern (a regular expression, unless '--glob' is used; optional)
  [path]...  the root directories for the filesystem search (optional)

Options:
  -H, --hidden                     Search hidden files and directories
  -I, --no-ignore                  Do not respect .(git|fd)ignore files
  -s, --case-sensitive             Case-sensitive search (default: smart case)
  -i, --ignore-case                Case-insensitive search (default: smart case)
  -g, --glob                       Glob-based search (default: regular expression)
  -a, --absolute-path              Show absolute instead of relative paths
  -l, --list-details               Use a long listing format with file metadata
  -L, --follow                     Follow symbolic links
  -p, --full-path                  Search full abs. path (default: filename only)
  -d, --max-depth <depth>          Set maximum search depth (default: none)
  -E, --exclude <pattern>          Exclude entries that match the given glob pattern
  -t, --type <filetype>            Filter by type: file (f), directory (d), symlink (l),
                                   executable (x), empty (e), socket (s), pipe (p)
  -e, --extension <ext>            Filter by file extension
  -S, --size <size>                Limit results based on the size of files
      --changed-within <date|dur>  Filter by file modification time (newer than)
      --changed-before <date|dur>  Filter by file modification time (older than)
  -o, --owner <user:group>         Filter by owning user and/or group
  -x, --exec <cmd>...              Execute a command for each search result
  -X, --exec-batch <cmd>...        Execute a command with all search results at once
  -c, --color <when>               When to use colors [default: auto] [possible values: auto,
                                   always, never]
  -h, --help                       Print help information (use `--help` for more detail)
  -V, --version                    Print version information
```

### 简单搜索

fd 只需带上一个需要查找的参数就可以执行最简单的搜索，该参数就是你要搜索的任何东西。例如：你想要找一个包含 “go” 关键字的文件名或目录。

> 注：fd 默认是不区分大小写和支持模糊查询的。

```shell
❯ fd go
download/Python-3.11.1/Include/cpython/longobject.h
download/Python-3.11.1/Include/longobject.h
download/Python-3.11.1/Lib/idlelib/debugobj.py
download/Python-3.11.1/Lib/idlelib/debugobj_r.py
download/Python-3.11.1/PC/icons/logo.svg
download/Python-3.11.1/PC/icons/logox128.png
download/Python-3.11.1/Tools/scripts/google.py
download/node-v18.12.1-linux-x64/lib/node_modules/npm/docs/content/commands/npm-logout.md
download/node-v18.12.1-linux-x64/lib/node_modules/npm/docs/output/commands/npm-logout.html
powerlevel10k/gitstatus/src/algorithm.h
repos/PythonLearning/AlgorithmLearning/
repos/PythonLearning/DjangoLearning/
```

### 按指定类型进行搜索

默认情况下，fd 会搜索所有符合条件的结果。如果你想指定搜索的类型可以使用 `-t` 参数，fd 目前支持四种类型：`f`、`d`、`l`、`x`，分别表示：文件、目录、符号链接、可执行文件。

```shell
❯ fd -td go
download/node-v18.12.1-linux-x64/lib/node_modules/npm/node_modules/dezalgo/
download/node-v18.12.1-linux-x64/lib/node_modules/npm/node_modules/negotiator/
repos/PythonLearning/AlgorithmLearning/
repos/PythonLearning/DjangoLearning/
```

### 搜索指定目录

fd 默认会在当前目录和其下所有子目录中搜索，如果你想搜索指定的目录就需要在第二个参数中指定。例如：要在指定的 `/etc` 目录中搜索包含 passwd 关键字的文件或目录。

```shell
fd passwd /etc
```

### 通过正则表达式搜索

- 搜索当前目录下以 head 开头并以 swig 结尾的文件。

```sh
fd '^head.*swig$'
```

- 搜索当前目录下文件名包含字母且文件名后缀为 PNG 的文件。

```sh
fd '[a-z]\.png$'
```

### 搜索指定扩展名的文件

在当前目录下搜索文件扩展名为 md 的文件。

```sh
fd -e md
```

在当前目录下搜索文件名包含 reademe 且扩展名为 md 的文件。

```sh
fd -e md readme
```

### 排除特定的目录或文件

搜索当前目录下除 lib 目录外的所有包含关键字 readme 的文件或目录。

```sh
fd -E lib readme
```

