---
title: "k8s"
date: 2022-06-22
draft: false
author: "MelonCholi"
tags: []
categories: [工具]
---

# Kubernetes

k8s 是基于容器的**集群编排引擎**，具备扩展集群、滚动升级回滚、弹性伸缩、自动治愈、服务发现等多种特性能力。

- 快速部署应用
- 快速扩展应用
- 无缝对接新的应用功能
- 节省资源，优化硬件资源的使用

![kubernetes 整体架构示意图](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kubernetes-whole-arch.png)

| 对比项   | Linux           | Kubernetes                |
| :------- | :-------------- | :------------------------ |
| 隔离单元 | 进程            | Pod                       |
| 硬件     | 单机            | 数据中心                  |
| 并发     | 线程            | 容器                      |
| 资源管理 | 进程内存&CPU    | 内存、CPU Limit/Request   |
| 存储     | 文件            | ConfigMap、Secret、Volume |
| 网络     | 端口绑定        | Service                   |
| 终端     | tty、pty、shell | kubectl exec              |
| 网络安全 | IPtables        | NetworkPolicy             |
| 权限     | 用户、文件权限  | ServiceAccount、RBAC      |

## 认识

### 集群设计

Kubernetes 可以管理大规模的集群，使集群中的每一个节点彼此连接，能够像控制一台单一的计算机一样控制整个集群。

集群有两种角色，一种是 **master** ，一种是 **Node**（也叫 worker）。 

- **master** 是集群的"大脑"，负责管理整个集群：应用的调度、更新、扩缩容等。
- **Node** 就是具体"干活"的
  - 一个 Node 一般是**一个虚拟机或物理机**，它上面事先运行着 docker 服务和 kubelet 服务（ Kubernetes 的一个组件）
  - 当接收到 master 下发的 "任务" 后，Node 就要去完成任务（用 docker 运行一个指定的应用）

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-ae36c2d33d5afb5215f9e746c6a9bbd4_1440w.jpg" alt="img" style="zoom: 50%;" />

### Deployment - 应用管理者

当我们拥有一个 Kubernetes 集群后，就可以在上面跑我们的应用了，前提是我们的应用必须支持在 docker 中运行，也就是我们要事先准备好 docker 镜像。

有了镜像之后，一般我们会通过 Kubernetes 的 **Deployment** 的**配置文件**去描述应用，比如应用叫什么名字、使用的镜像名字、要运行几个实例、需要多少的内存资源、cpu 资源等等。

有了配置文件就可以通过 Kubernetes 提供的命令行客户端 - **kubectl** 去管理这个应用了。kubectl 会跟 Kubernetes 的 master 通过 RestAPI 通信，最终完成应用的管理。 

比如我们刚才配置好的 Deployment 配置文件叫 app.yaml，我们就可以通过 "kubectl create -f app.yaml" 来创建这个应用，之后就由 Kubernetes 来保证我们的应用处于运行状态。

当某个实例运行失败了或者运行着应用的 Node 突然宕机了，Kubernetes 会自动发现并在新的 Node 上调度一个新的实例，保证我们的应用始终达到我们预期的结果。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-de389c70f77d3ade07a9e5f6e2dadcfc_1440w.jpg" alt="img" style="zoom: 50%;" />

### Pod - Kubernetes 最小调度单位

其实在上一步创建完 Deployment 之后，Kubernetes 的 Node 做的事情并不是简单的 docker run 一个容器。出于像易用性、灵活性、稳定性等的考虑，Kubernetes 提出了一个叫做 Pod 的东西，作为 Kubernetes 的最小调度单位。所以我们的应用在每个 Node 上运行的其实是一个 Pod。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-2d769a56fc687409da9151779adafc7f_1440w.jpg" alt="img" style="zoom:50%;" />

Pod 是一组容器（当然也可以只有一个）。容器本身就是一个小盒子了，Pod 相当于在容器上又包了一层小盒子。这个盒子里面的容器有什么特点呢？ 

- 可以直接通过 volume 共享存储。 
- 有相同的网络空间，通俗点说就是有一样的 ip 地址，有一样的网卡和网络设置。
- 多个容器之间可以“了解”对方，比如知道其他人的镜像，知道别人定义的端口等。



![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-244c75b316d49205ce86776ddb4c1d37_1440w.jpg)

### Service - 服务发现 - 找到每个 Pod

上面的 Deployment 创建了，Pod 也运行起来了。如何才能访问到我们的应用呢？

最直接想到的方法就是直接通过 Pod-ip+port 去访问，但如果实例数很多呢？好，拿到所有的 Pod-ip 列表，配置到负载均衡器中，轮询访问。

但上面我们说过，Pod 可能会死掉，甚至 Pod 所在的 Node 也可能宕机，Kubernetes 会自动帮我们重新创建新的 Pod。再者每次更新服务的时候也会重建 Pod。而每个 Pod 都有自己的 ip。所以 Pod 的 ip 是**不稳定**的，会经常变化的。

面对这种变化我们就要借助另一个概念：**Service**。它就是来专门解决这个问题的。不管 Deployment 的 Pod 有多少个，不管它是更新、销毁还是重建，Service 总是能发现并维护好它的 ip 列表。

Service 对外也提供了多种入口： 

1. **ClusterIP**：Service 在集群内的唯一 ip 地址，我们可以通过这个 ip，均衡的访问到后端的 Pod，而无须关心具体的 Pod
2. **NodePort**：Service 会在集群的每个 Node 上都启动一个端口，我们可以通过任意 Node 的这个端口来访问到 Pod
3. **LoadBalancer**：在 NodePort 的基础上，借助公有云环境创建一个外部的负载均衡器，并将请求转发到 `NodeIP:NodePort`。
4. **ExternalName**：将服务通过 DNS CNAME 记录方式转发到指定的域名（通过 spec.externlName 设定）

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-f0e6d59bb179f1293986625c98fa593f_1440w.jpg" alt="img" style="zoom:50%;" />

好，看似服务访问的问题解决了。但大家有没有想过，Service 是如何知道它负责哪些 Pod 呢？是如何跟踪这些 Pod 变化的？

最容易想到的方法是使用 Deployment 的名字。一个 Service 对应一个 Deployment 。当然这样确实可以实现。但 kubernetes 使用了一个更加灵活、通用的设计 - Label 标签；通过给 Pod 打标签，Service 可以只负责一个 Deployment 的 Pod 也可以负责多个 Deployment 的 Pod 了。Deployment 和 Service 就可以通过 Label 解耦了。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-3d4c14f108b08a6f05b03a0f46546063_1440w.jpg" alt="img" style="zoom:50%;" />

### RollingUpdate - 滚动升级

滚动升级是 Kubernetes 中最典型的服务升级方案，主要思路是一边增加新版本应用的实例数，一边减少旧版本应用的实例数，直到新版本的实例数达到预期，旧版本的实例数减少为 0，滚动升级结束。

在整个升级过程中，服务一直处于可用状态。并且可以在任意时刻回滚到旧版本。

![动图](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-232d0bd7f74bbf380e0d4f83f4a3bbc9_b.webp)

## 简介

### Kubernetes (K8S) 是什么

它是一个为 **容器化** 应用提供**集群部署和管理**的开源工具，由 Google 开发。

**Kubernetes** 这个名字源于希腊语，意为 “舵手” 或 “飞行员”。k8s 这个缩写是因为 k 和 s 之间有八个字符的关系。 

Google 在 2014 年开源了 Kubernetes 项目

**主要特性：**

- 高可用，不宕机，自动灾难恢复
- 灰度更新，不影响业务正常运转
- 一键回滚到历史版本
- 方便的伸缩扩展（应用伸缩，机器加减）、提供负载均衡
- 有一个完善的生态
