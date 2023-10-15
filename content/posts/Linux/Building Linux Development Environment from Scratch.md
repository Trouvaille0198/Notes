---
title: "Building Linux Development Environment from Scratch"
date: 2023-09-20
author: MelonCholi
draft: false
tags: [Linux]
categories: [Linux]
---

# Building Linux Development Environment from Scratch

我的 Linux 配置

## Windows Terminal 配置

### 字体选择

https://www.nerdfonts.com/font-downloads 随便挑

推荐：

- CaskaydiaCove Nerd Font Mono（或者叫 CaskaydiaCove NFM）
- Hack Nerd Font，选 HackNerdFontMono-Regular.ttf

## 网络配置

> 可选，未经验证

备份原有软件源文件

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak_yyyymmdd
```

修改 sources.list 文件

```bash
# 修改为如下地址：
sudo vi /etc/apt/sources.list
```

```sh
# 163源
deb http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
```

更新系统软件源

```bash
# 执行命令，更新系统软件源地址：
sudo apt-get update
sudo apt-get upgrade
```

```sh
# 安装lrzsz tree
sudo apt-get -y install lrzsz tree
# 安装 build-essential 软件包集合 （其中就包括 gcc、G ++ 和 make 等）
sudo apt install build-essential
```

## zsh 配置

更改默认 shell 为 zsh

```sh
# 查看系统当前使用的shell
echo $SHELL
# 设置默认zsh
chsh -s /bin/zsh
```

### oh-my-zsh 配置

#### 安装 oh-my-zsh

> https://github.com/ohmyzsh/ohmyzsh/wiki

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 安装 Powerlevel10k 主题

> https://github.com/romkatv/powerlevel10k#installation

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

`source ~/.zshrc`，就会进入 P10k 的配置界面

若要重置 P10k 配置，运行 `p10k configure` 或者直接修改 `~/.p10k.zsh`

> 这是手动安装方案，所以不需要在 `~/.zshrc` 里配置 `ZSH_THEME="powerlevel9k/powerlevel9k"` 这句话

#### 更改配置文件 `.zshrc`

```sh
vi ~/.zshrc
```

内容如下：

```sh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="random"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    extract
    rand-quote
    themes
    z
    per-directory-history
    history-substring-search
    command-not-found
    safe-paste
    colored-man-pages
    sudo
    zsh-autosuggestions
    #  history
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


alias :vrc="vi ~/.zshrc"
alias :src="source ~/.zshrc"
alias -s ttt='tar zxvf'
alias cp="cp -i" # 防止 copy 的时候覆盖已存在的文件, 带上 i 选项，文件已存在的时候，会提示，需要确认才能 copy
alias gcm='git checkout master'

# 以自己输入的所有内容为前缀，进行历史查找
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# 让 history 命令显示时间
HIST_STAMPS="yyyy-mm-dd"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```



## 工具安装

### snap

包管理器，会用到的

```sh
sudo apt install snapd -y
```

### bat

cat 的美化替代品

```sh
sudo apt install bat
```

使用软链接

```sh
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

在配置中添加

```sh
alias cat='batcat'
```

### exa

ls 的替代品

```sh
sudo apt install exa
```

在配置中添加

```sh
alias ls='exa'
```

项目地址：https://github.com/sharkdp/fd

### fd

一个命令行搜索工具

```sh
sudo apt install fd-find
```

使用软链接

```sh
ln -s $(which fdfind) ~/.local/bin/fd
```

### 其他

```sh
sudo apt install unzip

```

## 编程环境配置

### Python

### Go

## Vim 配置

### 安装 NeoVim

### 安装 NeoVide

> [Installation - Neovide](https://neovide.dev/installation.html)

```sh
snap install neovide
```

### 使用 LazyVim 配置 Vim

#### 添加 snippets

## git 配置

## 最终的 `.zshrc`
