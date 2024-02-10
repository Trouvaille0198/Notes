---
title: "从零开始构建 Linux 开发环境"
date: 2023-09-20
author: MelonCholi
draft: false
tags: [Linux]
categories: [Linux]
---

# 从零开始构建 Linux 开发环境

我的 Linux 配置

## 一些常用文件的默认位置

zsh 配置文件：`~/.zshrc`

vscode server：`~/.vscode-server`

## 客户端配置 SSH 免密登录

在客户端 `.ssh` 目录中，打开 bash 配置私钥

```shell
ssh-keygen
```

将客户端的公钥放到服务端上

```sh
cat ~/.ssh/id_rsa.pub | ssh username@ip 'cat >> ~/.ssh/authorized_keys'
```

:star: 用 `ssh-copy-id` 命令更方便

```shell
ssh-copy-id username@ip 
```

此时，客户端的公钥会被添加到远程服务器上的 `~/.ssh/authorized_keys` 文件中

然后就可以使用私钥登录啦~

```shell
ssh username@ip [-p port] -i id_rsa
```

## Windows Terminal 配置

### 字体选择

https://www.nerdfonts.com/font-downloads 随便挑

推荐：

- CaskaydiaCove Nerd Font Mono（或者叫 CaskaydiaCove NFM）
- Hack Nerd Font，选 HackNerdFontMono-Regular.ttf

```sh
mkdir -p ~/dockers/data/wallabag/ && 
docker run -d --name wallabag wallabag/wallabag &&
docker cp wallabag:/var/www/wallabag/data ~/dockers/data/wallabag/ &&
docker rm -f wallabag && \
chmod -R 777 ~/dockers/data/wallabag/data/db
```

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
# 如果没有zsh，那就下一个！
sudo apt-get install zsh
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
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.opt/powerlevel10k
echo 'source ~/.opt/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
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
export PATH=$PATH:~/.local/bin/

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.opt/powerlevel10k/powerlevel10k.zsh-theme
```

此配置文件会根据文档的进展而逐渐完善

### 一些插件的下载

zsh-autosuggestions

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

zsh-syntax-highlighting

```sh
sudo apt install zsh-syntax-highlighting
cd ~/.opt

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

## git 配置

ssh-keygen 一下叭

```sh
cd ~/.ssh
ssh-keygen -t rsa
```

将 `id_rsa.pub` 公钥内容，添加到 github 之类的托管平台上

设置名字，邮箱

```sh
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
```

### 使用 LazyVim 配置 Vim

#### 安装 NeoVim

```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

#### 使用个人配置

```sh
git clone git@github.com:Trouvaille0198/neovim-config.git ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

运行 `vi`，等待插件下载完成

#### 添加 snippets

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

> **一切的软链接都装在 ~/.local**

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

### cheat

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
sudo apt install build-essential # gcc etc
sudo apt install libedit-dev liblzma-dev libreadline-dev libffi-dev
sudo apt install zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev
```

## Vim 配置

### 安装 NeoVim

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```

在 `~/.zshrc` 中添加别名，以替换默认的 vim 命令

```sh
alias vim='nvim'
alias vi='nvim'
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
pyenv install --list # 查看版本
pyenv install <version-name>
pyenv uninstall <version-name>
```

如果下的太慢，就用镜像把源码下到缓存目录：

```sh
export v=3.12.1; wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -P ~/.pyenv/cache/; pyenv install $v 
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
uname -m
# x86_64
```

> 之后所有的软件都安装在 `~/.opt/`（而非 `/opt/`，主要考虑到用户隔离）

```sh
cd ~/.opt
sudo wget https://golang.google.cn/dl/go1.21.6.linux-amd64.tar.gz
sudo tar -zxvf go1.21.6.linux-amd64.tar.gz
```

给予权限

```sh
mkdir gocode
sudo chmod -R 777 go/
sudo chmod -R 777 gocode/
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
sudo ln -s ~/.opt/node-v18.12.1-linux-x64/bin/node ~/.local/bin/node
sudo ln -s ~/.opt/node-v18.12.1-linux-x64/bin/npm ~/.local/bin/npm
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
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
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

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

安装 docker-compose（最新版本去[仓库](https://github.com/docker/compose/releases/)看）

```sh
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o ~/.local/bin/docker-compose
sudo chmod +x ~/.local/bin/docker-compose
```

修改设置（限制日志容量上限、启用 IPv6 等）

```sh
cat > /etc/docker/daemon.json <<EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "20m",
        "max-file": "3"
    },
    "ipv6": true,
    "fixed-cidr-v6": "fd00:dead:beef:c0::/80",
    "experimental":true,
    "ip6tables":true
}
EOF
```

## （可选）设置 swap 分区

查看 Linux 当前分区情况：

```text
free -m
```

如果是增加 swap 分区，则先把当前所有分区都关闭了：

```text
swapoff -a
```

创建要作为 Swap 分区文件（其中 `/var/swapfile` 是文件位置，`bs*count` 是文件大小，例如以下命令就会创建一个 4G 的文件）：

```text
dd if=/dev/zero of=/var/swapfile bs=1M count=4096
```

建立 Swap 的文件系统（格式化为 Swap 分区文件）：

```text
mkswap /var/swapfile
```

启用 Swap 分区：

```text
swapon /var/swapfile
```

设置开启启动。在 /etc/fstab 文件中加入一行代码：

```text
/var/swapfile swap swap defaults 0 0
```

### Code-Server

可以在浏览器中编辑代码

安装

```sh
curl -fsSL https://code-server.dev/install.sh | sh
```

To have systemd start code-server now and restart on boot:

```sh
sudo systemctl enable --now code-server@$USER
```

Or, if you don't want/need a background service you can run:

```sh
code-server
```

修改配置

```sh
vi ~/.config/code-server/config.yaml 
```

开启

```sh
sudo systemctl restart code-server@$USER
```

查看进程状态

```sh
sudo systemctl status --now code-server@$USER
```

## 最终的 `.zshrc`

```sh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.local/bin/
export GOROOT=~/.opt/go           # Golang 源代码目录，安装目录
export GOPATH=~/.opt/gocode       # Golang 项目代码目录
export GOBIN=$GOPATH/bin          # go install 后生成的可执行命令存放路径

export PATH=$GOROOT/bin:$GOBIN:$PATH    # Linux 环境变量
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
alias cat='batcat'
alias ls='exa'
alias vim='nvim'
alias vi='nvim'
alias pv='pyenv virtualenvwrapper'

# 以自己输入的所有内容为前缀，进行历史查找
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# 让 history 命令显示时间
HIST_STAMPS="yyyy-mm-dd"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.opt/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

