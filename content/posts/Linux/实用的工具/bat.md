---
title: "bat"
date: 2022-01-13
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---

# bat

`bat` 是命令行下一款用来显示文件内容的工具，`bat` 命令功能跟常用命令 `cat` 类似。只是 `bat` 功能上更加强大一些，`bat` 在 `cat` 命令的基础上加入了行号显示、代码高亮和 Git 集成。

项目官方地址： `https://github.com/sharkdp/bat`

## 安装

`bat` is available on [Ubuntu since 20.04 ("Focal")](https://packages.ubuntu.com/search?keywords=bat&exact=1) and [Debian since August 2021 (Debian 11 - "Bullseye")](https://packages.debian.org/bullseye/bat).

If your Ubuntu/Debian installation is new enough you can simply run:

```
sudo apt install bat
```

**Important**: If you install `bat` this way, please note that the executable may be installed as `batcat` instead of `bat` (due to [a name clash with another package](https://github.com/sharkdp/bat/issues/982)). You can set up a `bat -> batcat` symlink or alias to prevent any issues that may come up because of this and to be consistent with other distributions:

```
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

## 示例

![image-20230113165553011](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20230113165553011.png)