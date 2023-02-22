---
title: "Linux 上的环境安装"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---

# 环境安装

## 更换 apt 源

详见：https://blog.csdn.net/wangyijieonline/article/details/105360138

模板

```sh
deb http://mirrors.aliyun.com/ubuntu/ TODO main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ TODO main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ TODO-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ TODO-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ TODO-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ TODO-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ TODO-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ TODO-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ TODO-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ TODO-backports main restricted universe multiverse
```

## 小工具安装

7z

```shell
sudo apt install p7zip-full p7zip-rar
```

btop

https://github.com/aristocratos/btop

ifconfig

```shell
sudo apt install net-tools
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
[root@pyyuc ~ 22:59:05]#go version
go version go1.11.4 linux/amd64
```

### 其他

go install 配置代理

```sh
go env -w GOPROXY=https://goproxy.cn
```

## Python

这里采用直接从 Python 官网下载的方法

详见：https://zhuanlan.zhihu.com/p/506491209

### 安装相关依赖

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

### 选择安装包

下载地址：https://www.python.org/downloads/

以 `https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz` 为例

```sh
# 下载
wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
# 解压
tar -zxvf Python-3.11.1.tgz
```

### 配置

```text
# 检查依赖与配置编译
sudo ./configure --enable-optimizations --with-lto --enable-shared
```

此处使用了三个可选配置项，含义如下：

- --enable-optimizations：用 [PROFILE_TASK](https://link.zhihu.com/?target=https%3A//docs.python.org/zh-cn/3/using/configure.html%23envvar-PROFILE_TASK) 启用以配置文件主导的优化（PGO）
- --with-lto：在编译过程中启用链接时间优化（LTO）
- --enable-shared：启用共享 Python 库 libpython 的编译

更多可用配置项的信息，请参阅 [Python 官方文档](https://link.zhihu.com/?target=https%3A//docs.python.org/zh-cn/3/using/configure.html)。

经过一系列检查无误之后，会自动生成 Makefile，即可进行下一步的编译了。

### 编译

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

### 安装

```sh
# 安装二进制文件
sudo make altinstall
```

在 Makefile 中有如下提示：

> If you have a previous version of Python installed that you don't want to overwrite, you can use "make altinstall" instead of "make install".

故应使用 `altinstall` 而不是 `install` 。二者的一个重要区别在于，后者会创建符号链接，将 `python3` 等命令链接到正在安装的新版本 Python 3 上，这可能会破坏系统。更多信息请参阅当前目录下的 `README.rst` 文件。

### 链接动态库

由于[编译配置](https://zhuanlan.zhihu.com/write#配置)中有 `--enable-shared` 的选项，故此时直接使用命令 `python3.11` 会提示无法找到 `libpython3.11.so.1.0` 的错误。只需找到该 `so` 文件，复制（或创建符号链接）到 `/usr/lib/` 目录下即可：

```bash
# 找到 libpython 的位置
$ whereis libpython3.11.so.1.0
libpython3.11.so.1: /usr/local/lib/libpython3.11.so.1.0
# 在 /usr/lib/ 下创建 libpython 的符号链接
$ sudo ln -s /usr/local/lib/libpython3.11.so.1.0 /usr/lib/
```

### 使用 Python 3.11

完成安装后，Python 3.11 会与系统原有的 Python 3.10 共存。由于 Ubuntu 系统、安装的其他软件等很可能会依赖于系统原有的 3.10，所以不要移除原有 Python 环境，也不要对 `python3` 等命令进行修改。

直接在命令行使用 `python3.11` 命令即可调用新安装的解释器：

类似的，使用 `python 3.11` 的 `pip` 的命令为 `pip3.11`

### 建立软链接

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
