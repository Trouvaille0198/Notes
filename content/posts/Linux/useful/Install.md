---
title: "Linux 上的环境安装"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---

# 环境安装

## Node.js

1. 执行以下命令，下载 Node.js Linux 64位二进制安装包。

    ```
    wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz
    ```

2. 执行以下命令，解压安装包。

    ```
    tar xvf node-v10.16.3-linux-x64.tar.xz
    ```

3. 依次执行以下命令，创建软链接。

    ```
    ln -s /root/node-v10.16.3-linux-x64/bin/node /usr/local/bin/node
    ```

    ```
    ln -s /root/node-v10.16.3-linux-x64/bin/npm /usr/local/bin/npm
    ```

    成功创建软链接后，即可在云服务器任意目录下使用 node 及 npm 命令。

4. 依次执行以下命令，查看 Node.js 及 npm 版本信息。

    ```
    node -v
    ```

    ```
    npm -v
    ```

## Go

### 安装

下载 go 源码包

```bash
//下载地址 go官网 https://golang.org/dl/
cd /opt/
sudo wget https://golang.google.cn/dl/go1.18.3.linux-amd64.tar.gz
```

解压缩 go 源码包，确认当前 linux 系统版本是 32 位还是 64 位，再选择 go 源码包

```csharp
//查看linux多少位
[root@pyyuc /opt 21:59:02]#uname -m
x86_64

//决定下载64位
sudo tar -zxvf go1.18.3.linux-amd64.tar.gz

//解压缩后go源码路径确保为
/opt/go/
```

给予 go 目录权限

```shell
sudo chmod -R 777 go/
sudo chmod -R 777 gocode/ # gocode 会在后面生成
```

### 配置环境变量

配置go的工作空间(配置GOPATH)，以及go的环境变量

go的代码必须在GOPATH中，也就是一个工作目录，目录包含三个子目录

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
export GOROOT=/opt/go           #Golang源代码目录，安装目录
export GOPATH=/opt/gocode        #Golang项目代码目录
export PATH=$GOROOT/bin:$PATH    #Linux环境变量
export PATH=$GOPATH/bin:$PATH    #Linux环境变量 s
export GOBIN=$GOPATH/bin        #go install后生成的可执行命令存放路径
```

读取/etc/profile，立即生效

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
