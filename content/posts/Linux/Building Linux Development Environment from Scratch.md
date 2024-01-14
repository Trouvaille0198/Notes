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

> 可选，未经验证！

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

此配置文件会根据文档的进展而逐渐完善

## 工具安装

### snap

包管理器，你总会用到的

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

> 一切的软连接都装在 ~/.local

并在配置中添加

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

### bashtop

> https://github.com/aristocratos/bashtop

top 的替代品

```sh
sudo apt install bashtop
```

### ifconfig

```sh
sudo apt install net-tools
```

## cheat

一本常用命令说明书：https://github.com/cheat/cheat

```sh
# cd /tmp \
#   && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
#   && gunzip cheat-linux-amd64.gz \
#   && chmod +x cheat-linux-amd64 \
#   && sudo mv cheat-linux-amd64 /usr/local/bin/cheat
  
cd ~/.opt \
  && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && ln -s ~/.opt/cheat-linux-amd64 ~/.local/bin/cheat
```

👆 最新版本号随时从官方仓库看

### 其他

```sh
sudo apt install unzip
```

## 编程环境配置

### Python

#### 安装 pyenv

> https://github.com/pyenv/pyenv#installation

```sh
curl https://pyenv.run | bash
# 或者去文档选用其他方法
```

添加环境变量

```sh
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

安装 / 卸载任意版本

```sh
pyenv install <version-name>
pyenv uninstall <version-name>
```

#### 安装 pyenv-virtualenvwrapper

这样就能在 `pyenv` 中使用 `virtualenv` 啦，依赖分离

```sh
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper
```

在 `~/.zshrc` 中补充指令缩写

```sh
alias pv='pyenv virtualenvwrapper'
```



### Go

#### 安装

官网下载：https://golang.org/dl/

下载 go 源码包

版本随时从官网取，确认当前 linux 系统版本是 32 位还是 64 位，再选择 go 源码包

```sh
# 查看linux多少位
[root@pyyuc /opt 21:59:02]# uname -m
x86_64
```

> 之后所有的软件都安装在 `~/.opt/`（而非 `/opt/`，主要考虑到用户隔离）

```sh
mkdir ~/.opt
cd ~/.opt
sudo wget https://golang.google.cn/dl/go1.18.3.linux-amd64.tar.gz
sudo tar -zxvf go1.18.3.linux-amd64.tar.gz
```

给予权限

```sh
sudo chmod -R 777 go/
sudo chmod -R 777 gocode/ # gocode 会在后面生成
```

#### 配置环境变量

##### 配置 go 的工作空间（配置 GOPATH），以及 go 的环境变量

创建 ~/.opt/gocode/{src,bin,pkg}，用于设置 GOPATH 为 ~/.opt/godocer

```sh
mkdir -p ~/.opt/gocode/{src,bin,pkg}

~/.opt/gocode/
├── bin
├── pkg
└── src
```

##### 设置 GOPATH 环境变量

在 `~/zshrc` 中写入 GOPATH 信息以及 go sdk 路径

```sh
export GOROOT=~/.opt/go           # Golang 源代码目录，安装目录
export GOPATH=~/.opt/gocode       # Golang 项目代码目录
export GOBIN=$GOPATH/bin          # go install 后生成的可执行命令存放路径

export PATH=$GOROOT/bin:$GOBIN:$PATH    # Linux 环境变量
```

##### go install 配置代理（可选）

```sh
go env -w GOPROXY=https://goproxy.cn
```

### Node.js

官网下载：https://nodejs.org/en/download/

> 都给我装在 `~/.opt/`！

下载、解压 Node.js Linux 64 位二进制安装包

```sh
cd ~/.opt
wget https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.xz
tar xvf node-v18.12.1-linux-x64.tar.xz
```

👆 版本随时从官网取

创建软链接

```sh
sudo ln -s ~/download/node-v18.12.1-linux-x64/bin/node ~/.opt/bin/node
sudo ln -s ~/download/node-v18.12.1-linux-x64/bin/npm ~/.opt/bin/npm
```

### Docker

由于 `apt` 源使用 HTTPS 以确保软件下载过程中不被篡改。因此，我们首先需要添加使用 HTTPS 传输的软件包以及 CA 证书。

```sh
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

为了确认所下载软件包的合法性，需要添加软件源的 `GPG` 密钥。

```sh
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


# 官方源
# $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

然后，我们需要向 `sources.list` 中添加 Docker 软件源

```sh
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# 官方源
echo \
   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> 以上命令会添加稳定版本的 Docker APT 镜像源，如果需要测试版本的 Docker 请将 stable 改为 test。

更新 apt 软件包缓存，并安装 `docker-ce`：

```sh
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io
```



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
