---
title: "Linux 上的环境安装"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---

# 环境安装

端口无法访问的解决方案：

1. 设置安全组

2. ```sh
    iptables -I INPUT -p tcp --dport <port> -j ACCEPT
    ```

## 更换 apt 源

详见：https://blog.csdn.net/wangyijieonline/article/details/105360138

模板

```sh
Fdeb https://mirrors.aliyun.com/ubuntu/ TODO main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ TODO main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ TODO-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ TODO-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ TODO-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ TODO-updates main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ TODO-proposed main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ TODO-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ TODO-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ TODO-backports main restricted universe multiverse
```

原来的文件：

```sh
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu/ jammy main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ jammy main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ jammy universe
# deb-src http://archive.ubuntu.com/ubuntu/ jammy universe
deb http://archive.ubuntu.com/ubuntu/ jammy-updates universe
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu/ jammy multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-updates multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted
deb http://security.ubuntu.com/ubuntu/ jammy-security universe
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security universe
deb http://security.ubuntu.com/ubuntu/ jammy-security multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security multiverse
```

## 小工具安装

### 7z

```shell
sudo apt install p7zip-full p7zip-rar
```

### bashtop/btop

https://github.com/aristocratos/btop

https://github.com/aristocratos/bashtop

```shell
sudo apt install bashtop
```

总体来说 bashtop 更好看一些

### ifconfig

```shell
sudo apt install net-tools
```

### bat

```shell
sudo apt install bat
```

如果你通过这种方法安装`bat`，请留意你所安装的可执行文件是否为`batcat`（由[其他包的可执行文件名冲突](https://github.com/sharkdp/bat/issues/982)造成）。你可以创建一个`bat -> batcat`的符号链接(symlink)或别名来避免因为可执行文件不同带来的问题并与其他发行版保持一致性。

```
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

## Node.js

官网下载：https://nodejs.org/en/download/

比如你在 `~/download`

1. 执行以下命令，下载 Node.js Linux 64 位二进制安装包。

    ```sh
    wget https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.xz
    ```

2. 执行以下命令，解压安装包。

    ```sh
    tar xvf node-v18.12.1-linux-x64.tar.xz
    ```

3. 依次执行以下命令，创建软链接。

    ```sh
    sudo ln -s ~/download/node-v18.12.1-linux-x64/bin/node /usr/local/bin/node
    ```

    ```sh
    sudo ln -s ~/download/node-v18.12.1-linux-x64/bin/npm /usr/local/bin/npm
    ```

    成功创建软链接后，即可在云服务器任意目录下使用 node 及 npm 命令。

4. 依次执行以下命令，查看 Node.js 及 npm 版本信息。

    ```sh
    node -v
    ```

    ```sh
    npm -v
    ```

5. 要使 npm 全局安装的软件命令行可用，需要添加环境变量

    ```sh
    export PATH=~/download/node-v18.12.1-linux-x64/bin:$PATH # 很丑就是了……
    ```

## Go

### 安装

下载 go 源码包

```shell
# 下载地址 go官网 https://golang.org/dl/
cd /opt/
sudo wget https://golang.google.cn/dl/go1.18.3.linux-amd64.tar.gz
```

解压缩 go 源码包，确认当前 linux 系统版本是 32 位还是 64 位，再选择 go 源码包

```shell
# 查看linux多少位
[root@pyyuc /opt 21:59:02]# uname -m
x86_64

# 决定下载64位
sudo tar -zxvf go1.18.3.linux-amd64.tar.gz

# 解压缩后go源码路径确保为
/opt/go/
```

给予 go 目录权限

```shell
sudo chmod -R 777 go/
sudo chmod -R 777 gocode/ # gocode 会在后面生成
```

### 配置环境变量

配置 go 的工作空间（配置 GOPATH），以及 go 的环境变量

go 的代码必须在 GOPATH 中，也就是一个工作目录，目录包含三个子目录

```scss
$GOPATH
    src        存放go源代码的目录,存放golang项目的目录，所有项目都放到gopath的src目录下
    bin        在go install后生成的可执行文件的目录
    pkg        编译后生成的，源码文件，如.a
```

创建 /opt/gocode/{src,bin,pkg}，用于设置 GOPATH 为 /opt/godocer

```bash
mkdir -p /opt/gocode/{src,bin,pkg}

/opt/gocode/
├── bin
├── pkg
└── src
```

6.设置 GOPATH 环境变量

修改 /etc/profile 系统环境变量文件，写入 GOPATH 信息以及 go sdk 路径

```bash
export GOROOT=/opt/go           # Golang 源代码目录，安装目录
export GOPATH=/opt/gocode       # Golang 项目代码目录
export GOBIN=$GOPATH/bin        # go install 后生成的可执行命令存放路径

export PATH=$GOROOT/bin:$GOBIN:$PATH    # Linux 环境变量
```

读取 /etc/profile，立即生效

```bash
source /etc/profile     #读取环境变量
```

查看 go 环境是否生效

```go
//查看go环境变量路径
which go
//查看go语言环境信息
go env
//查看go版本，查看是否安装成功
[root@pyyuc ~ 22:59:05]# go version
go version go1.11.4 linux/amd64
```

### 其他

go install 配置代理

```sh
go env -w GOPROXY=https://goproxy.cn
```

## Python

### 使用 pyenv 来实现多版本安装（推荐）

> https://github.com/pyenv/pyenv#installation

安装 pyenv 

```shell
curl https://pyenv.run | bash
# 或者去文档选用其他方法
```

添加环境变量

```shell
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

安装任意版本

```shell
pyenv install <version-name>
pyenv uninstall <version-name>
```

获取所有可安装版本信息

```shell
pyenv install -l
```

获取本地已安装版本

```shell
pyenv versions
```

选用指定版本

To select a Pyenv-installed Python as the version to use, run one of the following commands:

- [`pyenv shell `](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-shell) -- select just for current shell session
- [`pyenv local `](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-local) -- automatically select whenever you are in the current directory (or its subdirectories)
- [`pyenv global `](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-shell) -- select globally for your user account

#### 与 pyenv-virtualenvwrapper 配合使用

> https://github.com/pyenv/pyenv-virtualenvwrapper

这样就能在 `pyenv` 中使用 `virtualenv` 啦，依赖分离

```shell
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper
```

每次打开 shell，运行

```shell
pyenv virtualenvwrapper
```

之后就能在 pyenv 当前版本的 Python 中使用诸如 `mkvirtualenv` 或 `workon` 的指令啦

### Miniconda

从官网下载安装脚本 https://docs.conda.io/en/latest/miniconda.html

```shell
wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

然后添加到系统环境变量中

```shell
export PATH="~/miniconda3/bin:$PATH"
```

### 官网

#### apt

建议使用 apt，自己编译坑比较多。。

#### 编译安装

这里采用直接从 Python 官网下载的方法

详见：https://zhuanlan.zhihu.com/p/506491209

##### 安装相关依赖

先安装 gcc

```sh
# 安装 GCC 编译器
sudo apt install gcc

# 检查安装是否成功
gcc -v
# 若显示出 GCC 版本则成功
```

再安装相关依赖

```bash
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libbz2-dev liblzma-dev sqlite3 libsqlite3-dev tk-dev uuid-dev libgdbm-compat-dev
```

> 注意，Python 的部分功能依赖于对应的库（如 OpenSSL、SQLite3、LZMA 等），如果在编译时未能找到这些库，仍然可能完成编译。此时的 Python 解释器看似可以工作，但在需要使用特定功能时就会出问题。例如 OpenSSL 出现问题会导致无法正常使用 pip

##### 选择安装包

下载地址：https://www.python.org/downloads/

以 `https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz` 为例

```sh
# 下载
wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
# 解压
tar -zxvf Python-3.11.1.tgz
```

##### 配置

进入 Python 文件夹，运行

```shell
# 检查依赖与配置编译
sudo ./configure --enable-optimizations --with-lto --enable-shared
```

此处使用了三个可选配置项，含义如下：

- --enable-optimizations：用 [PROFILE_TASK](https://link.zhihu.com/?target=https%3A//docs.python.org/zh-cn/3/using/configure.html%23envvar-PROFILE_TASK) 启用以配置文件主导的优化（PGO）
- --with-lto：在编译过程中启用链接时间优化（LTO）
- --enable-shared：启用共享 Python 库 libpython 的编译

更多可用配置项的信息，请参阅 [Python 官方文档](https://link.zhihu.com/?target=https%3A//docs.python.org/zh-cn/3/using/configure.html)。

经过一系列检查无误之后，会自动生成 Makefile，即可进行下一步的编译了。

##### 编译

完成配置，生成 Makefile 后，就可以开始编译了。**编译耗时较长**，可以使用 `-j` 选项指定参与编译的 CPU 核心数，例如此机器为 6 核 CPU：

```bash
# 编译，-j 后面的数字为参与编译的 CPU 核心数，根据个人机器配置调整
sudo make -j 6
```

编译结束后，注意仔细查看一下输出，检查可能存在的错误：

```bash
# 一种可能出现的问题：
$ sudo make
# ......省略部分输出......
Python build finished successfully!
The necessary bits to build these optional modules were not found:
_dbm                  _tkinter              _uuid              
To find the necessary bits, look in setup.py in detect_modules() for the module's name.
```

如果出现类似如上的警告，说明编译时有部分软件包不可用，导致编译出的 Python 有部分可选模块不可用。检查中提到的依赖是否都已安装，或求助于网络搜索引擎，安装对应软件包后再次编译即可。

##### 安装

```sh
# 安装二进制文件
sudo make altinstall
```

在 Makefile 中有如下提示：

> If you have a previous version of Python installed that you don't want to overwrite, you can use "make altinstall" instead of "make install".

故应使用 `altinstall` 而不是 `install` 。二者的一个重要区别在于，后者会创建符号链接，将 `python3` 等命令链接到正在安装的新版本 Python 3 上，这可能会破坏系统。更多信息请参阅当前目录下的 `README.rst` 文件。

##### 链接动态库

由于[编译配置](https://zhuanlan.zhihu.com/write#配置)中有 `--enable-shared` 的选项，故此时直接使用命令 `python3.11` 会提示无法找到 `libpython3.11.so.1.0` 的错误。只需找到该 `so` 文件，复制（或创建符号链接）到 `/usr/lib/` 目录下即可：

```bash
# 找到 libpython 的位置
$ whereis libpython3.11.so.1.0
libpython3.11.so.1: /usr/local/lib/libpython3.11.so.1.0
# 在 /usr/lib/ 下创建 libpython 的符号链接
$ sudo ln -s /usr/local/lib/libpython3.11.so.1.0 /usr/lib/
```

##### 使用 Python 3.11

完成安装后，Python 3.11 会与系统原有的 Python 3.10 共存。由于 Ubuntu 系统、安装的其他软件等很可能会依赖于系统原有的 3.10，所以不要移除原有 Python 环境，也不要对 `python3` 等命令进行修改。

直接在命令行使用 `python3.11` 命令即可调用新安装的解释器：

类似的，使用 `python 3.11` 的 `pip` 的命令为 `pip3.11`

##### 建立软链接

一个是连接 python 运行位置，另一个则连接着 pip 的运行位置

```sh
ln -s /usr/local/bin/python3.11 /usr/bin/python
ln -s /usr/local/bin/pip3.11 /usr/bin/pip
```

一般机器都是这两个位置 `/usr/bin/python` `/usr/bin/pip`

查看对应的 python 和 pip 的软连接状态：

```sh
where python
where pip
```

以后切换版本时，只要修改这两个软连接即可，可以到对应的运行位置下使用 `la python*` 来查看软连接信息

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/992deeb1835a492795a497890679d062.png)

## Docker

由于 `apt` 源使用 HTTPS 以确保软件下载过程中不被篡改。因此，我们首先需要添加使用 HTTPS 传输的软件包以及 CA 证书。

```shell
$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

为了确认所下载软件包的合法性，需要添加软件源的 `GPG` 密钥。

```shell
$ curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


# 官方源
# $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

然后，我们需要向 `sources.list` 中添加 Docker 软件源

```shell
$ echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# 官方源
$ echo \
   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> 以上命令会添加稳定版本的 Docker APT 镜像源，如果需要测试版本的 Docker 请将 stable 改为 test。

更新 apt 软件包缓存，并安装 `docker-ce`：

```shell
$ sudo apt-get update

$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```
