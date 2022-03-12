---
title: "Docker"
date: 2022-03-07
draft: false
author: "MelonCholi"
tags: []
categories: [Golang]
featuredImage: https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/Moby-share.png
---

# Docker

摘自：https://yeasy.gitbook.io/docker_practice/

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/Moby-share.png)

## 什么是 Docker

摘自：https://zhuanlan.zhihu.com/p/187505981

### 容器技术 vs 虚拟机

和一个单纯的应用程序相比，**操作系统是一个很重而且很笨的程序**

操作系统运行起来是需要占用很多资源的，刚装好的系统还什么都没有部署，单纯的操作系统其磁盘占用至少几十 G 起步，内存要几个 G 起步。

假设我有一台机器，16G 内存，需要部署三个应用，那么使用虚拟机技术可以这样划分：

![img](https://pic4.zhimg.com/v2-c20cb49c88034e73e09059668b8cecfb_b.jpg)

在这台机器上开启三个虚拟机，每个虚拟机上部署一个应用，其中 VM1 占用 2G 内存，VM2 占用 1G 内存，VM3 占用了 4G 内存。

我们可以看到虚拟本身就占据了总共 7G 内存，因此**我们没有办法划分出更多虚拟机从而部署更多的应用程序**，可是我们部署的是应用程序，要用的也是应用程序而**不是操作系统**。

如果有一种技术可以让我们避免把**内存浪费**在“无用”的操作系统上岂不是太香？这是问题一，主要原因在于操作系统太重了。

还有另一个问题，那就是**启动时间**问题，我们知道操作系统重启是非常慢的，因为操作系统要从头到尾把该检测的都检测了该加载的都加载上，这个过程非常缓慢，动辄数分钟，因此操作系统还是太笨了。

那么有没有一种技术可以让我们获得虚拟机的好处又能克服这些缺点从而一举实现鱼和熊掌的兼得呢？

答案是肯定的，这就是容器技术。

### 什么是容器

容器一词的英文是 container，其实 container 还有集装箱的意思，而容器和集装箱在概念上是很相似的。

现代软件开发的一大目的就是**隔离**，应用程序在运行时相互独立互不干扰，这种隔离实现起来是很不容易的，其中一种解决方案就是上面提到的虚拟机技术，通过将应用程序部署在不同的虚拟机中从而实现隔离。

<img src="https://pic1.zhimg.com/v2-0f6ede7f0b920b5d0d5571c937a04838_b.jpg" alt="img" style="zoom:67%;" />

但是虚拟机技术有上述提到的各种缺点，那么容器技术又怎么样呢？

与虚拟机通过操作系统实现隔离不同，容器技术

- **只隔离应用程序的运行时环境**
- **容器之间可以共享同一个操作系统**

> 这里的运行时环境指的是程序运行依赖的**各种库以及配置**。

<img src="https://pic2.zhimg.com/v2-907214eadd65987e84a0751c08143f91_b.jpg" alt="img" style="zoom:67%;" />

从图中我们可以看到容器更加的**轻量级且占用的资源更少**，与操作系统动辄几 G 的内存占用相比，容器技术只需数 M 空间，因此我们可以在同样规格的硬件上**大量部署容器**，这是虚拟机所不能比拟的，而且不同于操作系统数分钟的启动时间容器几乎瞬时启动，容器技术为**打包服务栈**提供了一种更加高效的方式，So cool。

那么我们该怎么使用容器呢？这就要讲到 docker 了。

注意，**容器是一种通用技术，docker 只是其中的一种实现。**

### 什么是 docker

docker 是一个用 Go 语言实现的开源项目，可以让我们方便的创建和使用容器，docker 将程序以及程序所有的依赖都打包到 docker container，这样你的程序可以在任何环境都会有一致的表现，这里程序运行的依赖也就是容器。

就好比集装箱，容器所处的操作系统环境就好比货船或港口，**程序的表现只和集装箱有关系(容器)，和集装箱放在哪个货船或者哪个港口(操作系统)没有关系**。

因此我们可以看到 docker 可以**屏蔽环境差异**，也就是说，只要你的程序打包到了 docker 中，那么无论运行在什么环境下程序的行为都是一致的，程序员再也无法施展表演才华了，不会再有 “在我的环境上可以运行”，真正实现 “build once, run everywhere”。

此外 docker 的另一个好处就是**快速部署**，这是当前互联网公司最常见的一个应用场景，一个原因在于容器启动速度非常快，另一个原因在于只要确保一个容器中的程序正确运行，那么你就能确信无论在生产环境部署多少都能正确运行。

### 如何使用 docker

docker 中有这样几个概念：

- **dockerfile**
- **image**
- **container**

实际上你可以简单的把

- dockerfile 理解为源代码
- image 理解为可执行程序
- container 就是运行起来的进程
- docker 就是 "编译器"。

官方文档的术语解释：

> - A **Dockerfile** is simply a text-based script of instructions that is used to create a container image. 
>
> - A **container** is a sandboxed process on your machine that is isolated from all other processes on the host machine.
>
> 

因此我们只需要在 dockerfile 中指定需要哪些程序、依赖什么样的配置，之后把 dockerfile 交给“编译器” docker 进行“编译”，也就是 `docker build` 命令，生成的可执行程序就是 image，之后就可以运行这个 image 了，这就是 `docker run` 命令，image运行起来后就是 docker container。

### docker 是如何工作的

实际上 docker 使用了常见的 CS 架构，也就是 client-server 模式，docker client 负责处理用户输入的各种命令，比如 docker build、docker run，真正工作的其实是 server，也就是 docker demon

> 值得注意的是，docker client 和 docker demon 可以运行在同一台机器上。

接下来我们用几个命令来讲解一下 docker 的工作流程：

#### `docker build`

当我们写完 dockerfile 交给 docker “编译” 时使用这个命令，那么 client 在接收到请求后转发给 docker daemon，接着 docker daemon 根据 dockerfile 创建出“可执行程序” image。

![img](https://pic3.zhimg.com/v2-f16577a98471b4c4b5b1af1036882caa_b.jpg)



#### `docker run`

有了“可执行程序” image 后就可以运行程序了，接下来使用命令 `docker run`，docker daemon 接收到该命令后找到具体的 image，然后加载到内存开始执行，image 执行起来就是所谓的 container。

![img](https://pic4.zhimg.com/v2-672b29e2d53d2ab044269b026c6bc473_b.jpg)



#### `docker pull`

其实 `docker build` 和 `docker run` 是两个最核心的命令，会用这两个命令基本上 docker 就可以用起来了，剩下的就是一些补充。

那么 `docker pull` 是什么意思呢？

我们之前说过，docker 中 image 的概念就类似于“可执行程序”，我们可以从哪里下载到别人写好的应用程序呢？很简单，就是 **Docker Hub**，docker 官方的“应用商店”，你可以在这里下载到别人编写好的 image，这样你就不用自己编写 dockerfile 了。

**docker registry 可以用来存放各种 image**，公共的可以供任何人下载 image 的仓库就是 docker Hub。那么该怎么从 Docker Hub 中下载 image 呢，就是这里的 docker pull 命令了。

因此，这个命令的实现也很简单，那就是用户通过 docker client 发送命令，docker daemon 接收到命令后向 docker registry 发送 image 下载请求，下载后存放在本地，这样我们就可以使用 image 了。

![img](https://pic3.zhimg.com/v2-dac570abcf7e1776cc266a60c4b19e5e_b.jpg)

最后，让我们来看一下 docker 的底层实现。

### docker 的底层实现

docker 基于 Linux 内核提供这样几项功能实现的：

- **NameSpace**
    我们知道 Linux 中的 PID、IPC、网络等资源是全局的，而 NameSpace 机制是一种资源隔离方案，在该机制下这些资源就不再是全局的了，而是属于某个特定的 NameSpace，各个 NameSpace 下的资源互不干扰，这就使得每个 NameSpace 看上去就像一个独立的操作系统一样，但是只有 NameSpace 是不够。
- **Control groups**
    虽然有了 NameSpace 技术可以实现资源隔离，但进程还是可以不受控的访问**系统资源**，比如 CPU、内存、磁盘、网络等，为了控制容器中进程对资源的访问，Docker 采用 control groups 技术（也就是 cgroup），有了 cgroup 就可以控制容器中进程对系统资源的消耗了，比如你可以限制某个容器使用内存的上限、可以在哪些 CPU 上运行等等。

有了这两项技术，容器看起来就真的像是独立的操作系统了。

## 安装

### Ubuntu

#### 使用 APT 安装

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
# $ echo \
#   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> 以上命令会添加稳定版本的 Docker APT 镜像源，如果需要测试版本的 Docker 请将 stable 改为 test。

更新 apt 软件包缓存，并安装 `docker-ce`：

```shell
$ sudo apt-get update

$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

#### 启动 Docker

```shell
$ sudo systemctl enable docker
$ sudo systemctl start docker
```

#### 测试

```shell
$ docker run --rm hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
b8dfde127a29: Pull complete
Digest: sha256:308866a43596e83578c7dfa15e27a73011bdd402185a84c5cd7f32a88b501a24
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

若能正常输出以上信息，则说明安装成功。

#### 建立 docker 用户组

默认情况下，`docker` 命令会使用 [Unix socket](https://en.wikipedia.org/wiki/Unix_domain_socket) 与 Docker 引擎通讯。而只有 `root` 用户和 `docker` 组的用户才可以访问 Docker 引擎的 Unix socket。出于安全考虑，一般 Linux 系统上不会直接使用 `root` 用户。因此，更好地做法是将需要使用 `docker` 的用户加入 `docker` 用户组。

建立 `docker` 组：

```shell
$ sudo groupadd docker
```

将当前用户加入 `docker` 组：

```shell
$ sudo usermod -aG docker $USER
```

## 使用镜像

**Docker 镜像** 是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。镜像 **不包含** 任何动态数据，其内容在构建之后也不会被改变。

### 获取镜像 `docker pull`

从 Docker 镜像仓库获取镜像的命令是 `docker pull`。其命令格式为：
```shell
$ docker pull [选项] 仓库名[:标签]
# 更具体地
$ docker pull [选项] [Docker Registry 地址[:端口号]]仓库名[:标签]
```

具体的选项可以通过 `docker pull --help` 命令看到，这里我们说一下镜像名称的格式。

- Docker 镜像仓库地址：地址的格式一般是 `<域名/IP>[:端口号]`。
    - 默认地址是 Docker Hub (`docker.io`)
- 仓库名：两段式名称，即 <用户名>/<软件名>。
    - 对于 Docker Hub，如果不给出用户名，则默认为 `library`，也就是官方镜像。

#### 例

```shell
$ docker pull ubuntu:18.04
# 更具体地
$ docker pull docker.io/library/ubuntu:18.04
```

上面的命令中没有给出 Docker 镜像仓库地址，因此将会从 Docker Hub （`docker.io`）获取镜像。镜像名称是 `ubuntu:18.04`，因此将会获取官方镜像 `library/ubuntu` 仓库中标签为 `18.04` 的镜像。

下载过程：

```shell
18.04: Pulling from library/ubuntu
92dc2a97ff99: Pull complete
be13a9d27eb8: Pull complete
c8299583700a: Pull complete
Digest: sha256:4bc3ae6596938cb0d9e5ac51a1152ec9dcac2a1c50829c74abd9c4361e321b26
Status: Downloaded newer image for ubuntu:18.04
docker.io/library/ubuntu:18.04
```

从下载过程中可以看到我们之前提及的分层存储的概念，镜像是由多层存储所构成。下载也是一层层的去下载，并非单一文件。

下载过程中给出了每一层的 ID 的前 12 位。并且下载结束后，给出该镜像完整的 `sha256` 的摘要，以确保下载一致性。

#### 试运行

以上面的 `ubuntu:18.04` 为例，如果我们打算启动里面的 `bash` 并且进行交互式操作的话，可以执行下面的命令。

```shell
$ docker run -it --rm ubuntu:18.04 bash
```

- `-it`：这是两个参数
    - `-i`：交互式操作
    - `-t` 终端。我们这里打算进入 `bash` 执行一些命令并查看返回结果，因此我们需要交互式终端。

- `--rm`：这个参数是说容器退出后随之将其删除。
    - 默认情况下，为了排障需求，退出的容器并不会立即删除，除非手动 `docker rm`。
    - 我们这里只是随便执行个命令，看看结果，不需要排障和保留结果，因此使用 `--rm` 可以避免浪费空间。

- `ubuntu:18.04`：这是指用 `ubuntu:18.04` 镜像为基础来启动容器。

- `bash`：放在镜像名后的是 **命令**，这里我们希望有个交互式 Shell，因此用的是 `bash`。

### 列出镜像 `docker image ls`

要想列出已经下载下来的镜像，可以使用 `docker image ls` 命令。

```shell
$ docker image ls
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
redis                latest              5f515359c7f8        5 days ago          183 MB
nginx                latest              05a60462f8ba        5 days ago          181 MB
mongo                3.2                 fe9198c04d62        5 days ago          342 MB
<none>               <none>              00285df0df87        5 days ago          342 MB
ubuntu               18.04               329ed837d508        3 days ago          63.3MB
ubuntu               bionic              329ed837d508        3 days ago          63.3MB
```

列表包含了 `仓库名`、`标签`、`镜像 ID`、`创建时间` 以及 `所占用的空间`。

**镜像 ID** 则是镜像的唯一标识，一个镜像可以对应多个 **标签**。因此，在上面的例子中，我们可以看到 `ubuntu:18.04` 和 `ubuntu:bionic` 拥有相同的 ID，因为它们对应的是同一个镜像。

#### 镜像体积

如果仔细观察，会注意到，这里标识的所占用空间和在 Docker Hub 上看到的镜像大小不同。比如，`ubuntu:18.04` 镜像大小，在这里是 `63.3MB`，但是在 [Docker Hub](https://hub.docker.com/layers/ubuntu/library/ubuntu/bionic/images/sha256-32776cc92b5810ce72e77aca1d949de1f348e1d281d3f00ebcc22a3adcdc9f42?context=explore) 显示的却是 `25.47 MB`。

这是因为 Docker Hub 中显示的体积是压缩后的体积。在镜像下载和上传过程中镜像是保持着压缩状态的，**因此 Docker Hub 所显示的大小是网络传输中更关心的流量大小。**

而 `docker image ls` 显示的是镜像下载到本地后，展开的大小，准确说，是展开后的各层所占空间的总和，**因为镜像到本地后，查看空间的时候，更关心的是本地磁盘空间占用的大小。**

另外一个需要注意的问题是，`docker image ls` 列表中的镜像体积总和并非是所有镜像实际硬盘消耗。由于 Docker 镜像是多层存储结构，并且可以继承、复用，因此不同镜像可能会因为使用相同的基础镜像，从而拥有共同的层。由于 Docker 使用 Union FS，相同的层只需要保存一份即可，因此**实际镜像硬盘占用空间很可能要比这个列表镜像大小的总和要小的多。**

你可以通过 `docker system df` 命令来便捷的查看镜像、容器、数据卷所占用的空间。

```shell
$ docker system df

TYPE                TOTAL           ACTIVE           SIZE              RECLAIMABLE
Images              24              0                1.992GB           1.992GB (100%)
Containers          1               0                62.82MB           62.82MB (100%)
Local Volumes       9               0                652.2MB           652.2MB (100%)
Build Cache                                          0B                0B
```

#### 虚悬镜像

上面的镜像列表中，还可以看到一个特殊的镜像，这个镜像既没有仓库名，也没有标签，均为 `<none>`。

```shell
<none>          <none>         00285df0df87      5 days ago        342 MB
```

这个镜像原本是有镜像名和标签的，原来为 `mongo:3.2`，随着官方镜像维护，发布了新版本后，重新 `docker pull mongo:3.2` 时，`mongo:3.2` 这个镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了 `<none>`。

除了 `docker pull` 可能导致这种情况，`docker build` 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 `<none>` 的镜像。这类无标签镜像也被称为 **虚悬镜像(dangling image)** ，可以用下面的命令专门显示这类镜像：

```shell
$ docker image ls -f dangling=true
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              00285df0df87        5 days ago          342 MB
```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的，可以用下面的命令删除。

```shell
$ docker image prune
```

#### 中间层镜像

为了加速镜像构建、重复利用资源，Docker 会利用 **中间层镜像**。所以在使用一段时间后，可能会看到一些依赖的中间层镜像。默认的 `docker image ls` 列表中只会显示顶层镜像，如果希望显示包括中间层镜像在内的所有镜像的话，需要加 `-a` 参数。

```shell
$ docker image ls -a
```

这样会看到很多无标签的镜像，与之前的虚悬镜像不同，这些无标签的镜像很多都是中间层镜像，是其它镜像所依赖的镜像。

这些无标签镜像不应该删除，否则会导致上层镜像因为依赖丢失而出错。

实际上，这些镜像也没必要删除，因为之前说过，相同的层只会存一遍，而这些镜像是别的镜像的依赖，因此并不会因为它们被列出来而多存了一份，无论如何你也会需要它们。只要删除那些依赖它们的镜像后，这些依赖的中间层镜像也会被连带删除。

#### 列出部分镜像

不加任何参数的情况下，`docker image ls` 会列出所有顶层镜像，但是有时候我们只希望列出部分镜像。`docker image ls` 有好几个参数可以帮助做到这个事情。

**根据仓库名列出镜像**

```shell
$ docker image ls ubuntu
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              18.04               329ed837d508        3 days ago          63.3MB
ubuntu              bionic              329ed837d508        3 days ago          63.3MB
```

列出特定的某个镜像，也就是说**指定仓库名和标签**

```shell
$ docker image ls ubuntu:18.04
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              18.04               329ed837d508        3 days ago          63.3MB
```

除此以外，`docker image ls` 还支持强大的过滤器参数 `--filter`，或者简写 `-f`。

之前我们已经看到了使用过滤器来列出虚悬镜像的用法，它还有更多的用法。比如，我们希望看到在 `mongo:3.2` 之后建立的镜像，可以用下面的命令：

```shell
$ docker image ls -f since=mongo:3.2
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
redis               latest              5f515359c7f8        5 days ago          183 MB
nginx               latest              05a60462f8ba        5 days ago          181 MB
```

想查看某个位置之前的镜像也可以，只需要把 `since` 换成 `before` 即可。

此外，如果镜像构建时，定义了 `LABEL`，还可以通过 `LABEL` 来过滤。

```shell
$ docker image ls -f label=com.example.version=0.1
...
```

### 删除本地镜像 `docker image rm`

如果要删除本地的镜像，可以使用 `docker image rm` 命令，其格式为：

```shell
$ docker image rm [选项] <镜像1> [<镜像2> ...]
```

#### 用 ID、镜像名、摘要删除镜像

其中，`<镜像>` 可以是 `镜像短 ID`、`镜像长 ID`、`镜像名` 或者 `镜像摘要`。

比如我们有这么一些镜像：

```shell
$ docker image ls
REPOSITORY             TAG              IMAGE ID            CREATED             SIZE
centos                 latest           0584b3d2cf6d        3 weeks ago         196.5 MB
redis                  alpine           501ad78535f0        3 weeks ago         21.03 MB
docker                 latest           cf693ec9b5c7        3 weeks ago         105.1 MB
nginx                  latest           e43d811ce2f4        5 weeks ago         181.5 MB
```

我们可以用镜像的完整 ID，也称为 `长 ID`，来删除镜像。使用脚本的时候可能会用长 ID，但是人工输入就太累了，所以更多的时候是用 `短 ID` 来删除镜像。

`docker image ls` 默认列出的就已经是短 ID 了，一般取前 3 个字符以上，只要足够区分于别的镜像就可以了。

比如这里，如果我们要删除 `redis:alpine` 镜像，可以执行：

```shell
$ docker image rm 501
```

我们也可以用`镜像名`，也就是 `<仓库名>:<标签>`，来删除镜像。

```shell
$ docker image rm centos
```

> 当然，更精确的是使用 `镜像摘要` 删除镜像。

#### Untagged 和 Deleted

如果观察上面这几个命令的运行输出信息的话，你会注意到删除行为分为两类，一类是 `Untagged`，另一类是 `Deleted`。我们之前介绍过，镜像的唯一标识是其 ID 和摘要，而一个镜像可以有多个标签。

因此当我们使用上面命令删除镜像的时候，实际上是在**要求删除某个标签的镜像**。所以首先需要做的是将满足我们要求的所有镜像标签都取消，这就是我们看到的 `Untagged` 的信息。

因为一个镜像可以对应多个标签，因此当我们删除了所指定的标签后，可能还有别的标签指向了这个镜像，如果是这种情况，那么 `Delete` 行为就不会发生。所以并非所有的 `docker image rm` 都会产生删除镜像的行为，有可能仅仅是取消了某个标签而已。

当该镜像所有的标签都被取消了，该镜像很可能会失去了存在的意义，因此会触发删除行为。

镜像是多层存储结构，因此在删除的时候也是从上层向基础层方向依次进行判断删除。镜像的多层结构让镜像复用变得非常容易，因此很有可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。**直到没有任何层依赖当前层时，才会真实的删除当前层。**这就是为什么，有时候会奇怪，为什么明明没有别的标签指向这个镜像，但是它还是存在的原因，也是为什么有时候会发现所删除的层数和自己 `docker pull` 看到的层数不一样的原因。

除了镜像依赖以外，还需要注意的是容器对镜像的依赖。如果有用这个镜像启动的容器存在（即使容器没有运行），那么同样不可以删除这个镜像。之前讲过，容器是以镜像为基础，再加一层容器存储层，组成这样的多层存储结构去运行的。因此该镜像如果被这个容器所依赖的，那么删除必然会导致故障。如果这些容器是不需要的，应该先将它们删除，然后再来删除镜像。

#### 用 docker image ls 命令来配合

像其它可以承接多个实体的命令一样，可以使用 `docker image ls -q` 来配合使用 `docker image rm`，这样可以成批的删除希望删除的镜像。

比如，我们需要删除所有仓库名为 `redis` 的镜像：

```shell
$ docker image rm $(docker image ls -q redis)
```

或者删除所有在 `mongo:3.2` 之前的镜像：

```shell
$ docker image rm $(docker image ls -q -f before=mongo:3.2)
```

## 操作容器

镜像（`Image`）和容器（`Container`）的关系，就像是面向对象程序设计中的 `类` 和 `实例` 一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。

容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的 [命名空间](https://en.wikipedia.org/wiki/Linux_namespaces)。因此容器可以拥有自己的 `root` 文件系统、自己的网络配置、自己的进程空间，甚至自己的用户 ID 空间。

容器内的进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。

这种特性使得容器封装的应用比直接在宿主运行更加安全。也因为这种隔离的特性，很多人初学 Docker 时常常会混淆容器和虚拟机。

按照 Docker 最佳实践的要求，容器不应该向其存储层内写入任何数据，容器存储层要保持无状态化。所有的文件写入操作，都应该使用 [数据卷（Volume）]()、或者 [绑定宿主目录]()，在这些位置的读写会跳过容器存储层，直接对宿主（或网络存储）发生读写，其性能和稳定性更高。

数据卷的生存周期独立于容器，容器消亡，数据卷不会消亡。因此，使用数据卷后，容器删除或者重新运行之后，数据却不会丢失。

### 启动

启动容器有两种方式，一种是基于镜像新建一个容器并启动，另外一个是将在终止状态（`exited`）的容器重新启动。

因为 Docker 的容器实在太轻量级了，很多时候用户都是随时删除和新创建容器。

#### 新建并启动 `docker run`

所需要的命令主要为 `docker run`。

例如，下面的命令输出一个 “Hello World”，之后终止容器。

```shell
$ docker run ubuntu:18.04 /bin/echo 'Hello world'
Hello world
```

这跟在本地直接执行 `/bin/echo 'hello world'` 几乎感觉不出任何区别。

下面的命令则启动一个 bash 终端，允许用户进行交互。

```shell
$ docker run -t -i ubuntu:18.04 /bin/bash
root@af8bae53bdd3:/#
```

其中，`-t` 选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， `-i` 则让容器的标准输入保持打开。

当利用 `docker run` 来创建容器时，Docker 在后台运行的标准操作包括：

- 检查本地是否存在指定的镜像，不存在就从 [registry]() 下载
- 利用镜像创建并启动一个容器
- 分配一个文件系统，并在只读的镜像层外面挂载一层可读写层
- 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
- 从地址池配置一个 ip 地址给容器
- 执行用户指定的应用程序
- 执行完毕后容器被终止

容器的核心为所执行的应用程序，所需要的资源都是应用程序运行所必需的。除此之外，并没有其它的资源。可以在伪终端中利用 `ps` 或 `top` 来查看进程信息。

```shell
root@ba267838cc1b:/# ps
  PID TTY          TIME CMD
    1 ?        00:00:00 bash
   11 ?        00:00:00 ps
```

可见，容器中仅运行了指定的 bash 应用。这种特点使得 Docker 对资源的利用率极高，是货真价实的轻量级虚拟化。

#### 守护态运行 `-d`

更多的时候，需要让 Docker 在后台运行而不是直接把执行命令的结果输出在当前宿主机下。此时，可以通过添加 `-d` 参数来实现。

下面举两个例子来说明一下。

如果不使用 `-d` 参数运行容器。

```shell
$ docker run ubuntu:18.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
hello world
hello world
hello world
hello world
```

容器会把输出的结果 (STDOUT) 打印到宿主机上面

如果使用了 `-d` 参数运行容器。

```shell
$ docker run -d ubuntu:18.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
77b2dc01fe0f3f1265df143181e7b9af5e05279a884f4776ee75350ea9d8017a
```

此时容器会在后台运行并不会把输出的结果 (STDOUT) 打印到宿主机上面 (输出结果可以用 `docker logs` 查看)。

**注：** 容器是否会长久运行，是和 `docker run` 指定的命令有关，和 `-d` 参数无关。

使用 `-d` 参数启动后会返回一个唯一的 id，也可以通过 `docker container ls` 命令来查看容器信息。

```shell
$ docker container ls
CONTAINER ID  IMAGE         COMMAND               CREATED        STATUS       PORTS NAMES
77b2dc01fe0f  ubuntu:18.04  /bin/sh -c 'while tr  2 minutes ago  Up 1 minute        agitated_wright
```

要获取容器的输出信息，可以通过 `docker container logs` 命令。

```shell
$ docker container logs [container ID or NAMES]
hello world
hello world
hello world
. . .
```

### 终止 `docker container stop`

可以使用 `docker container stop` 来终止一个运行中的容器。

此外，当 Docker 容器中指定的应用终结时，容器也自动终止。

例如对于上一章节中只启动了一个终端的容器，用户通过 `exit` 命令或 `Ctrl+d` 来退出终端时，所创建的容器立刻终止。

终止状态的容器可以用 `docker container ls -a` 命令看到。例如

```shell
$ docker container ls -a
CONTAINER ID        IMAGE                    COMMAND                CREATED             STATUS                          PORTS               NAMES
ba267838cc1b        ubuntu:18.04             "/bin/bash"            30 minutes ago      Exited (0) About a minute ago                       trusting_newton
```

**处于终止状态的容器，可以通过 `docker container start` 命令来重新启动。**

**此外，`docker container restart` 命令会将一个运行态的容器终止，然后再重新启动它。**

### 进入容器

在使用 `-d` 参数时，容器启动后会进入后台。

某些时候需要进入容器进行操作，包括使用 `docker attach` 命令或 `docker exec` 命令，推荐大家使用 `docker exec` 命令，原因会在下面说明。

#### `docker attach`

下面示例如何使用 `docker attach` 命令。

```shell
$ docker run -dit ubuntu
243c32535da7d142fb0e6df616a3c3ada0b8ab417937c853a9e1c251f499f550

$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
243c32535da7        ubuntu:latest       "/bin/bash"         18 seconds ago      Up 17 seconds                           nostalgic_hypatia

$ docker attach 243c
root@243c32535da7:/#
```

> *注意：* 如果从这个 stdin 中 exit，会导致容器的停止。

#### `docker exec`

`docker exec` 后边可以跟多个参数，这里主要说明 `-i` `-t` 参数。

只用 `-i` 参数时，由于没有分配伪终端，界面没有我们熟悉的 Linux 命令提示符，但命令执行结果仍然可以返回。

当 `-i` `-t` 参数一起使用时，则可以看到我们熟悉的 Linux 命令提示符。

```shell
$ docker run -dit ubuntu
69d137adef7a8a689cbcb059e94da5489d3cddd240ff675c640c8d96e84fe1f6

$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
69d137adef7a        ubuntu:latest       "/bin/bash"         18 seconds ago      Up 17 seconds                           zealous_swirles

$ docker exec -i 69d1 bash
ls
bin
boot
dev
...

$ docker exec -it 69d1 bash
root@69d137adef7a:/#
```

如果从这个 stdin 中 exit，不会导致容器的停止。这就是为什么推荐大家使用 `docker exec` 的原因。

### 导出和导入

#### 导出容器 `docker export`

如果要导出本地某个容器，可以使用 `docker export` 命令。

```shell
$ docker container ls -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS               NAMES
7691a814370e        ubuntu:18.04        "/bin/bash"         36 hours ago        Exited (0) 21 hours ago                       test

$ docker export 7691a814370e > ubuntu.tar
```

这样将导出容器快照到本地文件。

#### 导入容器快照 `docker import`

可以使用 `docker import` 从容器快照文件中再导入为镜像，例如

```shell
$ cat ubuntu.tar | docker import - test/ubuntu:v1.0

$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
test/ubuntu         v1.0                9d37a6082e97        About a minute ago   171.3 MB
```

此外，也可以通过指定 URL 或者某个目录来导入，例如

```shell
$ docker import http://example.com/exampleimage.tgz example/imagerepo
```

> *用户既可以使用*  `docker load` 来导入镜像存储文件到本地镜像库，也可以使用 `docker import` 来导入一个容器快照到本地镜像库。
>
> 这两者的区别在于容器快照文件将丢弃所有的历史记录和元数据信息（即仅保存容器当时的快照状态），而镜像存储文件将保存完整记录，体积也要大。
>
> 此外，从容器快照文件导入时可以重新指定标签等元数据信息。

### 删除

#### 删除容器 `docker container rm`

可以使用 `docker container rm` 来删除一个**处于终止状态**的容器。例如

```shell
$ docker container rm trusting_newton
trusting_newton
```

如果要删除一个运行中的容器，可以添加 `-f` 参数。Docker 会发送 `SIGKILL` 信号给容器。

#### 清理所有处于终止状态的容器

用 `docker container ls -a` 命令可以查看所有已经创建的包括终止状态的容器，如果数量太多要一个个删除可能会很麻烦，用下面的命令可以清理掉所有处于终止状态的容器。

```shell
$ docker container prune
```



## 访问仓库

镜像构建完成后，可以很容易的在当前宿主机上运行，但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，[Docker Registry]() 就是这样的服务。

一个 **Docker Registry** 中可以包含多个 **仓库**（`Repository`）；每个仓库可以包含多个 **标签**（`Tag`）；每个标签对应一个镜像。

通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。我们可以通过 `<仓库名>:<标签>` 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 `latest` 作为默认标签。

仓库（`Repository`）是集中存放镜像的地方。

一个容易混淆的概念是注册服务器（`Registry`）。实际上注册服务器是管理仓库的具体服务器，每个服务器上可以有多个仓库，而每个仓库下面有多个镜像。从这方面来说，仓库可以被认为是一个具体的项目或目录。例如对于仓库地址 `docker.io/ubuntu` 来说，`docker.io` 是注册服务器地址，`ubuntu` 是仓库名。

大部分时候，并不需要严格区分这两者的概念。

### Docker Hub

目前 Docker 官方维护了一个公共仓库 [Docker Hub](https://hub.docker.com/)，其中已经包括了数量超过 [2,650,000](https://hub.docker.com/search/?type=image) 的镜像。大部分需求都可以通过在 Docker Hub 中直接下载镜像来实现。

#### 登录 `docker login`

可以通过执行 `docker login` 命令交互式的输入用户名及密码来完成在命令行界面登录 Docker Hub。

你可以通过 `docker logout` 退出登录。

#### 拉取镜像 `docker pull`

你可以通过 **`docker search`** 命令来查找官方仓库中的镜像，并利用 `docker pull` 命令来将它下载到本地。

例如以 `centos` 为关键词进行搜索：

```shell
$ docker search centos
NAME                     DESCRIPTION                        STARS     OFFICIAL  AUTOMATED
centos                   The official build of CentOS.      6449        [OK]
ansible/centos7-ansible  Ansible on Centos7                 132                   [OK]
consol/centos-xfce-vnc   Centos container with …            126                   [OK]
jdeathe/centos-ssh       OpenSSH / Supervisor …             117                   [OK]
centos/systemd           systemd enabled base container.     96                   [OK]
```

可以看到返回了很多包含关键字的镜像，其中包括镜像名字、描述、收藏数（表示该镜像的受关注程度）、是否官方创建（`OFFICIAL`）、是否自动构建 （`AUTOMATED`）。

根据是否是官方提供，可将镜像分为两类。

- 一种是类似 `centos` 这样的镜像，被称为基础镜像或根镜像。这些基础镜像由 Docker 公司创建、验证、支持、提供。这样的镜像往往使用单个单词作为名字。

- 还有一种类型，比如 `ansible/centos7-ansible` 镜像，它是由 Docker Hub 的注册用户创建并维护的，往往带有用户名称前缀。可以通过前缀 `username/` 来指定使用某个用户提供的镜像，比如 ansible 用户。

另外，在查找的时候通过 `--filter=stars=N` 参数可以指定仅显示收藏数量为 `N` 以上的镜像。

下载官方 `centos` 镜像到本地。

```shell
$ docker pull centos
Using default tag: latest
latest: Pulling from library/centos
7a0437f04f83: Pull complete
Digest: sha256:5528e8b1b1719d34604c87e11dcd1c0a20bedf46e83b5632cdeac91b8c04efc1
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest
```

#### 推送镜像 `docker push`

用户也可以在登录后通过 `docker push` 命令来将自己的镜像推送到 Docker Hub。

以下命令中的 `username` 请替换为你的 Docker 账号用户名。

```shell
$ docker tag ubuntu:18.04 username/ubuntu:18.04

$ docker image ls
REPOSITORY            TAG              IMAGE ID            CREATED             SIZE
ubuntu                18.04            275d79972a86        6 days ago          94.6MB
username/ubuntu       18.04            275d79972a86        6 days ago          94.6MB

$ docker push username/ubuntu:18.04

$ docker search username

NAME             DESCRIPTION         STARS           OFFICIAL        AUTOMATED
username/ubuntu
```

## 数据管理

![img](https://3503645665-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-M5xTVjmK7ax94c8ZQcm%2Fuploads%2Fgit-blob-5950036bba1c30c0b1ab52a73a94b59bbdd5f57c%2Ftypes-of-mounts.png?alt=media)

这一章介绍如何在 Docker 内部以及容器之间管理数据，在容器中管理数据主要有两种方式：

- 数据卷（Volumes）
- 挂载主机目录 (Bind mounts)

实际上，Docker 提供了三种不同的方式用于将宿主的数据挂载到容器中：volumes，bind mounts，tmpfs volumes。当你不知道该选择哪种方式时，记住，volumes 总是正确的选择。

### 数据卷 volumn

`数据卷` 是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，可以提供很多有用的特性：

- `数据卷` 可以在容器之间**共享和重用**
- 对 `数据卷` 的修改会立马生效
- 对 `数据卷` 的更新，不会影响镜像
- `数据卷` 默认会**一直存在**，即使容器被删除

> 注意：`数据卷` 的使用，类似于 Linux 下对目录或文件进行 mount，镜像中的被指定为挂载点的目录中的文件会复制到数据卷中（仅数据卷为空时会复制）。

#### 创建一个数据卷

```shell
$ docker volume create my-vol
```

查看所有的 `数据卷`

```shell
$ docker volume ls

DRIVER              VOLUME NAME
local               my-vol
```

在主机里使用以下命令可以**查看指定 `数据卷` 的信息**

```shell
$ docker volume inspect my-vol
[
    {
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
        "Name": "my-vol",
        "Options": {},
        "Scope": "local"
    }
]
```

#### 启动一个挂载数据卷的容器

在用 `docker run` 命令的时候，使用 `--mount` 标记来将 `数据卷` 挂载到容器里。在一次 `docker run` 中可以挂载多个 `数据卷`。

下面创建一个名为 `web` 的容器，并加载一个 `数据卷` 到容器的 `/usr/share/nginx/html` 目录。

```shell
$ docker run -d -P \
    --name web \
    # -v my-vol:/usr/share/nginx/html \
    --mount source=my-vol,target=/usr/share/nginx/html \
    nginx:alpine
```

#### 查看数据卷的具体信息

在主机里使用以下命令可以查看 `web` 容器的信息

```shell
$ docker inspect web
```

`数据卷` 信息在 "Mounts" Key 下面

```shell
"Mounts": [
    {
        "Type": "volume",
        "Name": "my-vol",
        "Source": "/var/lib/docker/volumes/my-vol/_data",
        "Destination": "/usr/share/nginx/html",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
    }
],
```

#### 删除数据卷

```shell
$ docker volume rm my-vol
```

`数据卷` 是被设计用来持久化数据的，它的生命周期独立于容器，Docker 不会在容器被删除后自动删除 `数据卷`，并且也不存在垃圾回收这样的机制来处理没有任何容器引用的 `数据卷`。

如果需要在删除容器的同时移除数据卷。可以在删除容器的时候使用 `docker rm -v` 这个命令。

无主的数据卷可能会占据很多空间，要清理请使用以下命令

```shell
$ docker volume prune
```

### 挂载主机目录 bind mount

#### 挂载一个主机目录作为数据卷

使用 `--mount` 标记可以指定挂载一个本地主机的目录到容器中去。

```shell
$ docker run -d -P \
    --name web \
    # -v /src/webapp:/usr/share/nginx/html \
    --mount type=bind,source=/src/webapp,target=/usr/share/nginx/html \
    nginx:alpine
```

上面的命令加载主机的 `/src/webapp` 目录到容器的 `/usr/share/nginx/html`目录。

这个功能在进行测试的时候十分方便，比如用户可以放置一些程序到本地目录中，来查看容器是否正常工作。本地目录的路径必须是**绝对路径**，以前使用 `-v` 参数时如果本地目录不存在 Docker 会自动为你创建一个文件夹，现在使用 `--mount` 参数时如果本地目录不存在，Docker 会报错。

Docker 挂载主机目录的默认权限是 `读写`，用户也可以通过增加 `readonly` 指定为 `只读`。

```shell
$ docker run -d -P \
    --name web \
    # -v /src/webapp:/usr/share/nginx/html:ro \
    --mount type=bind,source=/src/webapp,target=/usr/share/nginx/html,readonly \
    nginx:alpine
```

加了 `readonly` 之后，就挂载为 `只读` 了。如果你在容器内 `/usr/share/nginx/html` 目录新建文件，会显示如下错误

```shell
/usr/share/nginx/html # touch new.txt
touch: new.txt: Read-only file system
```

#### 查看数据卷的具体信息

在主机里使用以下命令可以查看 `web` 容器的信息

```shell
$ docker inspect web
```

`挂载主机目录` 的配置信息在 "Mounts" Key 下面

```shell
"Mounts": [
    {
        "Type": "bind",
        "Source": "/src/webapp",
        "Destination": "/usr/share/nginx/html",
        "Mode": "",
        "RW": true,
        "Propagation": "rprivate"
    }
],
```

#### 挂载一个本地主机文件作为数据卷

`--mount` 标记也可以从主机挂载单个文件到容器中

```shell
$ docker run --rm -it \
   # -v $HOME/.bash_history:/root/.bash_history \
   --mount type=bind,source=$HOME/.bash_history,target=/root/.bash_history \
   ubuntu:18.04 \
   bash

root@2affd44b4667:/# history
1  ls
2  diskutil list
```

这样就可以记录在容器输入过的命令了。

### volume 和 bind 的区别

- volume：如果 volume 是空的而 container 中的目录有内容，那么 docker 会将 container 目录中的内容拷贝到 volume 中，但是如果 volume 中已经有内容，则会将 container 中的目录覆盖。

- bind mount :不管 host 目录是否有值，都会覆盖 container 映射的目录

## 使用网络

Docker 允许通过外部访问容器或容器互联的方式来提供网络服务。

### 外部访问容器

容器中可以运行一些网络应用，要让外部也可以访问这些应用，可以通过 `-P` 或 `-p` 参数来指定端口映射。

当使用 `-P` 标记时，Docker 会**随机**映射一个端口到内部容器开放的网络端口。

使用 `docker container ls` 可以看到，本地主机的 32768 被映射到了容器的 80 端口。此时访问本机的 32768 端口即可访问容器内 NGINX 默认页面。

```shell
$ docker run -d -P nginx:alpine

$ docker container ls -l
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
fae320d08268        nginx:alpine        "/docker-entrypoint.…"   24 seconds ago      Up 20 seconds       0.0.0.0:32768->80/tcp   bold_mcnulty
```

同样的，可以通过 `docker logs` 命令来查看访问记录。

```shell
$ docker logs fa
172.17.0.1 - - [25/Aug/2020:08:34:04 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0" "-"
```

`-p` 则可以指定要映射的端口，并且，在一个指定端口上只可以绑定一个容器。

支持的格式有 `ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort`。

#### 映射所有接口地址

使用 `hostPort:containerPort` 格式本地的 80 端口映射到容器的 80 端口，可以执行

```shell
$ docker run -d -p 80:80 nginx:alpine
```

此时默认会**绑定本地所有接口上的所有地址**。

#### 映射到指定地址的指定端口

可以使用 `ip:hostPort:containerPort` 格式指定映射使用一个特定地址，比如 localhost 地址 127.0.0.1

```shell
$ docker run -d -p 127.0.0.1:80:80 nginx:alpine
```

#### 映射到指定地址的任意端口

使用 `ip::containerPort` 绑定 localhost 的任意端口到容器的 80 端口，本地主机会自动分配一个端口。

```shell
$ docker run -d -p 127.0.0.1::80 nginx:alpine
```

还可以使用 `udp` 标记来指定 `udp` 端口

```shell
$ docker run -d -p 127.0.0.1:80:80/udp nginx:alpine
```

#### 查看映射端口配置 `docker port`

使用 `docker port` 来查看当前映射的端口配置，也可以查看到绑定的地址

```shell
$ docker port fa 80
0.0.0.0:32768
```

注意：

- 容器有自己的内部网络和 ip 地址（使用 `docker inspect` 查看，Docker 还可以有一个可变的网络配置。）
- `-p` 标记可以多次使用来绑定多个端口

例如

```shell
$ docker run -d \
    -p 80:80 \
    -p 443:443 \
    nginx:alpine
```

### 容器互联

如果你之前有 `Docker` 使用经验，你可能已经习惯了使用 `--link` 参数来使容器互联。

随着 Docker 网络的完善，强烈建议大家将容器加入自定义的 Docker 网络来连接多个容器，而不是使用 `--link` 参数。

#### 新建网络 `docker network create`

下面先创建一个新的 Docker 网络。

```shell
$ docker network create -d bridge my-net
```

`-d` 参数指定 Docker 网络类型，有 `bridge` 和 `overlay`。其中 `overlay` 网络类型用于 [Swarm mode]()，在本小节中你可以忽略它。

#### 连接容器

运行一个容器并连接到新建的 `my-net` 网络

```shell
$ docker run -it --rm --name busybox1 --network my-net busybox sh
```

打开新的终端，再运行一个容器并加入到 `my-net` 网络

```shell
$ docker run -it --rm --name busybox2 --network my-net busybox sh
```

再打开一个新的终端查看容器信息

```shell
$ docker container ls

CONTAINER ID    IMAGE         COMMAND   CREATED     STATUS  PORTS           NAMES
b47060aca56b    busybox       "sh"      11 minutes  ago     Up 11 minutes   busybox2
8720575823ec    busybox       "sh"      16 minutes  ago     Up 16 minutes   busybox1
```

下面通过 `ping` 来证明 `busybox1` 容器和 `busybox2` 容器建立了互联关系。

在 `busybox1` 容器输入以下命令

```shell
/ # ping busybox2
PING busybox2 (172.19.0.3): 56 data bytes
64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.072 ms
64 bytes from 172.19.0.3: seq=1 ttl=64 time=0.118 ms
```

用 ping 来测试连接 `busybox2` 容器，它会解析成 `172.19.0.3`。

同理在 `busybox2` 容器执行 `ping busybox1`，也会成功连接到。

```shell
/ # ping busybox1
PING busybox1 (172.19.0.2): 56 data bytes
64 bytes from 172.19.0.2: seq=0 ttl=64 time=0.064 ms
64 bytes from 172.19.0.2: seq=1 ttl=64 time=0.143 ms
```

这样，`busybox1` 容器和 `busybox2` 容器建立了互联关系。

#### Docker Compose

如果你有多个容器之间需要互相连接，推荐使用 [Docker Compose]()。

## 常用命令

https://zhuanlan.zhihu.com/p/150951927#:~:text=Docker%20%28%E4%B8%80%29-%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4%E5%A4%A7%E5%85%A8%201%201.%E6%9C%AC%E5%9C%B0%E9%95%9C%E5%83%8F%E4%BF%A1%E6%81%AF%E6%9F%A5%E8%AF%A2%EF%BC%9A%20docker%20images%202%202.%E4%BB%93%E5%BA%93%E9%95%9C%E5%83%8F%E4%BF%A1%E6%81%AF%E6%9F%A5%E8%AF%A2%EF%BC%9A,5.%E9%87%8D%E5%90%AF%E5%AE%B9%E5%99%A8%EF%BC%9A%20docker%20restart%20mysql01%2010%206.%E5%81%9C%E6%AD%A2%E5%AE%B9%E5%99%A8%20%E6%9B%B4%E5%A4%9A%E7%BB%93%E6%9E%9C...%20

## 使用 Dockerfile 定制镜像

镜像的定制实际上就是定制每一层所添加的配置、文件。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个**脚本**，用这个脚本来构建、定制镜像，那么一些无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是 Dockerfile。

Dockerfile 是一个文本文件，其内包含了一条条的**指令(Instruction)**，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。

还以之前定制 `nginx` 镜像为例，这次我们使用 Dockerfile 来定制。

在一个空白目录中，建立一个文本文件，并命名为 `Dockerfile`：

```shell
$ mkdir mynginx
$ cd mynginx
$ touch Dockerfile
```

其内容为：

```shell
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

这个 Dockerfile 很简单，一共就两行。涉及到了两条指令，`FROM` 和 `RUN`。
