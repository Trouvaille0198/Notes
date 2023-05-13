---
title: "containerd"
date: 2023-04-35
draft: false
author: "MelonCholi"
tags: [快速入门]
categories: [工具]
---

# containerd

> 摘自：https://zhuanlan.zhihu.com/p/356037350

containerd 是一个工业级标准的容器运行时，它强调简单性、健壮性和可移植性。containerd 可以在宿主机中管理完整的容器生命周期，包括容器镜像的传输和存储、容器的执行和管理、存储和网络等。

## 简介

### Docker vs containerd

containerd 是从 Docker 中分离出来的一个项目，可以作为一个底层容器运行时，现在它成了 Kubernete 容器运行时更好的选择。

不仅仅是 Docker，还有很多云平台也支持 containerd 作为底层容器运行时：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-9c5d921877a12472a32733332624fb9e_1440w.webp)

### K8S CRI

K8S 发布 CRI（Container Runtime Interface），统一了容器运行时接口，凡是支持 CRI 的容器运行时，皆可作为 K8S 的底层容器运行时。

K8S 为什么要放弃使用 Docker 作为容器运行时，而使用 containerd 呢？

如果你使用 Docker 作为 K8S 容器运行时的话，kubelet 需要先要通过 `dockershim` 去调用 Docker，再通过 Docker 去调用 containerd。



![img](https://pic1.zhimg.com/80/v2-a33f47493cfe8214d910367353851ef8_1440w.webp)



如果你使用 containerd 作为 K8S 容器运行时的话，由于 containerd 内置了 `CRI` 插件，kubelet 可以直接调用 containerd。



![img](https://pic2.zhimg.com/80/v2-55b30b651d8ed158ef08b254b11590b5_1440w.webp)



使用 containerd 不仅性能提高了（调用链变短了），而且资源占用也会变小（Docker 不是一个纯粹的容器运行时，具有大量其他功能）。

## 快速入门

> 如果你之前用过 Docker，你只要稍微花 5 分钟就可以学会 containerd 了

- 其实只要把我们之前使用的 `docker` 命令改为 `crictl` 命令即可操作 containerd，比如查看所有运行中的容器；

```bash
crictl ps
CONTAINER           IMAGE               CREATED                  STATE               NAME                ATTEMPT             POD ID
4ca73ded41bb6       3b0b04aa3473f       Less than a second ago   Running             helm                20                  21103f0058872
3bb5767a81954       296a6d5035e2d       About a minute ago       Running             coredns             1                   af887263bd869
a5e34c24be371       0346349a1a640       About a minute ago       Running             nginx               1                   89defc6008501
```

- 查看所有镜像；

```bash
crictl images
IMAGE                                      TAG                 IMAGE ID            SIZE
docker.io/library/nginx                    1.10                0346349a1a640       71.4MB
docker.io/rancher/coredns-coredns          1.8.0               296a6d5035e2d       12.9MB
docker.io/rancher/klipper-helm             v0.4.3              3b0b04aa3473f       50.7MB
docker.io/rancher/local-path-provisioner   v0.0.14             e422121c9c5f9       13.4MB
docker.io/rancher/metrics-server           v0.3.6              9dd718864ce61       10.5MB
docker.io/rancher/pause                    3.1                 da86e6ba6ca19       327kB
```

- 进入容器内部执行 bash 命令，这里需要注意的是只能使用容器 ID，不支持使用容器名称；

```bash
crictl exec -it a5e34c24be371 /bin/bash
```

- 查看容器中应用资源占用情况，可以发现占用非常低。

```bash
crictl stats

CONTAINER           CPU %               MEM                 DISK                INODES
3bb5767a81954       0.54                14.27MB             254B                14
a5e34c24be371       0.00                2.441MB             339B                16
```

