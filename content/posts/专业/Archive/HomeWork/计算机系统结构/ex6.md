---
draft: true
---

# 容器技术及其应用

实验目的：熟悉容器技术及其工具的使用，学会用容器来封装、迁移、部署应用环境。

实验任务：

- 选择一种容器技术及其工具，创建镜像，运行容器，要求容器内具备为某种明确用途（开发、学习、办公、测试、游戏等）配置好的软硬件环境。

- 测试并回答：

    1. 写出你创建镜像、运行容器的所有操作，要求可复现（即遵循这些操作步骤，可以达到与你相同的实验结果）

    2. 运行同一个镜像的多个容器，分析它们之间是否存在相互影响，如果有，怎么解决？你的机器上可以同时运行几个容器（同镜像）？怎么限制这些容器对宿主机资源（CPU、内存、磁盘等）的使用？

    3. 你的镜像多大？请精简，写出操作步骤。

    4. 你认为自己的镜像有共享价值吗？写出分享方法。



本实验选择 Docker 容器化技术作为实验环境。目标是使用 Docker 构建一个 Golang web 项目程序的镜像文件

## Docker 操作

### Docker 安装

Ubuntu 环境下使用 apt 安装：

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### 配置镜像

Docker 使用 Dockerfile 的配置文件来配置初始化镜像所需要的内容，涉及到程序运行的系统要求、编程语言的依赖、源代码文件的移动、编译和运行、端口绑定等一系列操作。具体配置如下：

```dockerfile
# Dockerfile
FROM golang:alpine

# 为我们的镜像设置必要的环境变量
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# 移动到工作目录：/build
WORKDIR /build

# 将代码复制到容器中
COPY . .

# 将我们的代码编译成二进制可执行文件app
RUN go build -o app .

# 移动到用于存放生成的二进制文件的 /dist 目录
WORKDIR /dist

# 将二进制文件从 /build 目录复制到这里
RUN cp /build/app .
RUN cp /build/setting.yml .

# 声明服务端口
EXPOSE 8080

# 启动容器时运行的命令
CMD ["/dist/app"]
```

FROM 命令指定了要依赖的基础镜像。这里我们选择了 `golang:alpine`，它是 alpine Linux 发行版，该发行版的大小很小并且内置了 Go，非常适合用来配置 Golang 程序。

ENV 命令指定了程序运行的系统环境，在这里我们打开了 go module 功能，能够比较方便地进行依赖库管理，并且指定了 Linux amd64 的编译环境。

Docker 有工作目录的概念，使用 WORKDIR 命令指定

RUN 命令运行指定的 shell 命令，这里我们直接将程序编译成一个可执行文件。

EXPOSE 命令声明服务器端口，程序监听此端口来提供对外服务。

### 创建镜像

在项目目录下，执行下面的命令创建镜像，并用 -t 参数指定镜像名称为 go_app

```shell
docker build . -t go_app
```

![image-20220514085943935](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514085943935.png)

在 Docker 客户端中可以看到完成构建的镜像：

![image-20220514090423027](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514090423027.png)

### 运行容器

```shell
docker run -p 8888:8080 go_app
```

使用 -p 参数将容器 8080 端口绑定到主机 8888 端口上，之后就可以用 8888 端口对程序进行访问了。

![image-20220514091508290](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514091508290.png)

访问 api 界面如下：

![image-20220514091530332](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514091530332.png)

## 运行多个容器

如果运行多个相同镜像，一般情况下不会有影响。但要注意的是，go web 项目需要监听一个端口以提供服务。我们需要为每个镜像配置绑定不同的系统端口，以避免端口占用的情况发生。

在一个需要挂在相同数据卷的镜像里，对于共享空间的文件读写可能会有限制

再次开启一个 8888 端口，会发生以下端口占用的报错：

![image-20220514091552990](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514091552990.png)

在不同端口下运行的三个相同容器：

![image-20220514091704756](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514091704756.png)

在请求量较少的情况下，一个 go web 容器占用的系统资源是非常少的

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514092821909.png" alt="image-20220514092821909" style="zoom:50%;" />

## 限制容器资源

Docker 提供了限制内存，CPU 或磁盘 IO 的方法， 可以对容器所占用的硬件资源大小以及多少进行限制

例如，限制容器运行内存不超过 512M：

```shell
docker run -m 512M -p 8888:8080 go_app 
```

运行 `docker stats` 命令，可以看到此容器拥有 512M 的内存限制

![image-20220514141230626](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514141230626.png)

我们可以设置每个容器进程的调度周期，以及在这个周期内各个容器最多能使用多少 CPU 时间。

- --cpu-period 设置每个容器进程的调度周期
- --cpu-quota 设置在每个周期内容器能使用的 CPU 时间

```shell
docker run --cpu-period=50000 --cpu-quota=25000 -p 8888:8080 go_app
```

## 精简镜像

docker 支持分层构建镜像。我们可以使用 `FROM scratch` 创建一个虚拟的空白镜像。对于 Linux 下静态编译的程序来说，并不需要有操作系统提供运行时支持，所需的一切库都已经在可执行文件里了，因此直接 `FROM scratch` 会让镜像体积更加小巧。使用 Golang 开发的应用很多会使用这种方式来制作镜像。

Dockerfile 如下：

```dockerfile
FROM golang:alpine AS builder

# 为我们的镜像设置必要的环境变量
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# 移动到工作目录：/build
WORKDIR /build

# 将代码复制到容器中
COPY . .

# 将我们的代码编译成二进制可执行文件app
RUN go build -o app .

# 创建小镜像
FROM scratch

# 拷贝配置文件
COPY ./setting.yml /

# 从builder镜像中把/dist/app 拷贝到当前目录
COPY --from=builder /build/app /

# 声明服务端口
EXPOSE 8080

# 启动容器时运行的命令
CMD ["/app"]
```

最后构建出来的镜像因为只包含了一个可执行文件和相应的配置文件，所以体积大大减小

![image-20220514091454793](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514091454793.png)

## 共享价值

构建出来的 Docker 镜像具有极大的共享价值。它可以不经环境配置、依赖下载等一系列复杂的操作就可以在任何机器上运行起来，操作简单。

我们可以将自己构建好的镜像分享到 Docker 官方的 Docker Hub 上，只需注册一个账号，并键入以下命令：

```shell
# 标注版本标签
docker tag go_app <username>/go_app:1.0

# 推送至 hub
docker push <username>/go_app:1.0
```

推送过程：

![image-20220514143351186](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514143351186.png)

最后，在 Docker Hub 就可以看到相应的镜像了。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514143519609.png" alt="image-20220514143519609" style="zoom:50%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514143525400.png" alt="image-20220514143525400" style="zoom:50%;" />

其他用户就可以使用 `docker pull 1375911011/go_app:1.1` 来下载 1.1 版本的 go_app 镜像，这样我们就实现了镜像共享。
