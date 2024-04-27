---
title: "配置 Neovim"
date: 2022-12-16
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
---

# 配置 Neovim

## 安装

### 安装 Neovim

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```

如果你这里出现报错，找不到 `add-apt-repository` 命令，这是因为系统缺少必要的依赖包，

需要先安装下边的包：

```sh
sudo apt-get install software-properties-common
```

安装完成后可选步骤，替换默认的 vim `nvim ~/.bashrc`，添加别名：

```bash
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
```

配置文件的位置位于 ` ~/.config/nvim` 中

### 安装 Packer.nvim 插件管理器

```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Neovim 推荐将数据存储在 **标准数据目录**下（`:h base-directories` 查看详细文档），**标准数据目录**默认是 `~/.local/share/nvim/` ，你可以通过调用 `:echo stdpath("data")` 命令查看你系统下的实际路径。

`Packer` 会将插件默认安装在标准数据目录 `/site/pack/packer/start` 中，完整目录也就是 `~/.local/share/nvim/site/pack/packer/start` 目录下。

在 vi 中运行 `:PackerSync`

### 一些插件的前置安装

#### telescope

##### 安装 repgrep

添加 `ppa` 后安装 `ripgrep` ：

```bash
sudo add-apt-repository ppa:x4121/ripgrep
sudo apt-get update
sudo apt install ripgrep
```

依次运行上边代码即可安装完成。

##### 安装 fd

`fd` 的话，我找到最简单的安装方法是使用 `npm` 直接全局安装，注意 `npm` 需要 `Node.js` 环境。

```
npm install -g fd-find
```

全部安装后，可以开始配置 `Telescope` 了。

#### nvim-treesitter

这玩意儿毛病很多。。

依赖 gcc

```sh
sudo apt install gcc
```

还需要安装 build-essential

```sh
sudo apt-get install build-essential
```

若报错，详见 https://blog.csdn.net/Caption_Coco/article/details/109258959

#### nvim-coc

官方安装文档：https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim

需要 `node` >= `14.14`

鉴于 Pakcer 始终下不下来，还是直接 `git clone` 吧。。

```sh
cd ~/.local/share/nvim/site/pack/packer/start
git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1
nvim -c "helptags coc.nvim/doc/ | q"
```

##### 一些插件

server language protocol

```sh
:CocInstall coc-sh
:CocInstall coc-go
:CocInstall coc-json
:CocInstall coc-html
:CocInstall coc-pyright # python
:CocInstall coc-eslint
:CocInstall coc-stylua
:CocInstall coc-markdownlint
:CocInstall xml
:CocInstall yaml
```

其他实用插件

```sh
:CocInstall coc-highlight
:CocInstall coc-snippets
:CocInstall coc-yank
```

##### 一些命令

查看已安装的插件

```sh
:CocList extensions
```

其中：
**`?`**：表示无效插件
**`\*`**：表示插件已激活
**`+`**：表示插件加载成功
**`-`**：表示插件已禁止

- 检查 NeoVim 状态：`:checkhealth`
    这里主要关注 [coc.nvim](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fneoclide%2Fcoc.nvim) 服务状态，如下图所示：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/2222997-f204a9ec1fb5c09c.png)

coc service

- 查看 [coc.nvim](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fneoclide%2Fcoc.nvim) 服务相关信息：`:CocInfo`
- 卸载插件：`:CocUninstall coc-css`

## 使用 LazyVim

> 官网：[🚀 Getting Started | LazyVim](https://www.lazyvim.org/)

