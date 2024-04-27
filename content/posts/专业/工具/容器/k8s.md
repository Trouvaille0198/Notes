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
| 资源管理 | 进程内存 & CPU  | 内存、CPU Limit/Request   |
| 存储     | 文件            | ConfigMap、Secret、Volume |
| 网络     | 端口绑定        | Service                   |
| 终端     | tty、pty、shell | kubectl exec              |
| 网络安全 | IPtables        | NetworkPolicy             |
| 权限     | 用户、文件权限  | ServiceAccount、RBAC      |

## 认识

### 简介

#### Kubernetes (K8S) 是什么

它是一个为 **容器化** 应用提供**集群部署和管理**的开源工具，由 Google 开发。

**Kubernetes** 这个名字源于希腊语，意为 “舵手” 或 “飞行员”。k8s 这个缩写是因为 k 和 s 之间有八个字符的关系。 

Google 在 2014 年开源了 Kubernetes 项目

**主要特性：**

- 高可用，不宕机，自动灾难恢复
- 灰度更新，不影响业务正常运转
- 一键回滚到历史版本
- 方便的伸缩扩展（应用伸缩，机器加减）、提供负载均衡
- 有一个完善的生态

#### 不同的应用部署方案

![container_evolution.svg](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwmxgxwp.svg)

##### 传统部署方式：

应用直接在物理机上部署，机器资源分配不好控制，出现 Bug 时，可能机器的大部分资源被某个应用占用，导致其他应用无法正常运行，无法做到应用隔离。

##### 虚拟机部署

在单个物理机上运行多个虚拟机，每个虚拟机都是完整独立的系统，性能损耗大。

##### 容器部署

所有容器共享主机的系统，轻量级的虚拟机，性能损耗小，资源隔离，CPU 和内存可按需分配

#### 什么时候需要 Kubernetes

当你的应用只是跑在一台机器，直接一个 docker + docker-compose 就够了，方便轻松；

当你的应用需要跑在 3，4 台机器上，你依旧可以每台机器单独配置运行环境 + 负载均衡器；

当你应用访问数不断增加，机器逐渐增加到十几台、上百台、上千台时，每次加机器、软件更新、版本回滚，都会变得非常麻烦、痛不欲生，再也不能好好的摸鱼了，人生浪费在那些没技术含量的重复性工作上。

Kubernetes 可以为你提供集中式的管理集群机器和应用，加机器、版本升级、版本回滚，那都是一个命令就搞定的事，不停机的灰度更新，确保高可用、高性能、高扩展。

### Kubernetes 集群架构

![部署示意图](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwob90mh.png)

##### master

主节点，控制平台，不需要很高性能，不跑任务，通常一个就行了，也可以开多个主节点来提高集群可用度。

##### worker / node

工作节点，可以是虚拟机或物理计算机，任务都在这里跑，机器性能需要好点；通常都有很多个，可以不断加机器扩大集群；每个工作节点由主节点管理

##### 重要概念 Pod

豆荚，K8S 调度、管理的最小单位，一个 Pod 可以包含一个或多个容器，每个 Pod 有自己的虚拟 IP。一个工作节点可以有多个 pod，主节点会考量负载自动调度 pod 到哪个节点运行。

![集群示意图.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwoccq7d)

##### Kubernetes 组件

- `kube-apiserver` API 服务器，公开了 Kubernetes API
- `etcd` 键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库
- `kube-scheduler` 调度 Pod 到哪个节点运行
- `kube-controller` 集群控制器
- `cloud-controller` 与云服务商交互
  ![Kubernetes组件](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwonmx7e.png)

## 设计

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

## 快速上手

### 配置集群

安装方式

- **minikube**
  只是一个 K8S 集群模拟器，只有一个节点的集群，只为测试用，master 和 worker 都在一起
- **直接用云平台 Kubernetes**
  可视化搭建，只需简单几步就可以创建好一个集群。
  优点：安装简单，生态齐全，负载均衡器、存储等都给你配套好，简单操作就搞定
- **裸机安装（Bare Metal）**
  至少需要两台机器（主节点、工作节点个一台），需要自己安装 Kubernetes 组件，配置会稍微麻烦点。
  可以到各云厂商按时租用服务器，费用低，用完就销毁。
  缺点：配置麻烦，缺少生态支持，例如负载均衡器、云存储。

#### minikube

官方文档：https://minikube.sigs.k8s.io/docs/start/

```shell
# 启动集群
minikube start
# 查看节点。kubectl 是一个用来跟 K8S 集群进行交互的命令行工具
kubectl get node
# 停止集群
minikube stop
# 清空集群
minikube delete --all
# 安装集群可视化 Web UI 控制台
minikube dashboard
```

#### 裸机搭建

> Bare Metal

**主节点需要组件**

- docker（也可以是其他容器运行时）
- kubectl 集群命令行交互工具
- kubeadm 集群初始化工具

**工作节点需要组件** [文档](https://kubernetes.io/zh/docs/concepts/overview/components/#node-components)

- docker（也可以是其他容器运行时）
- kubelet：管理 Pod 和容器，确保他们健康稳定运行。
- kube-proxy：网络代理，负责网络相关的工作

> 你也可以试下 [这个项目](https://github.com/lework/kainstall)，用脚本快速搭建 K8S 裸机集群
> 当然，为了更好的理解，你应该先手动搭建一次

```shell
# 每个节点分别设置对应主机名
hostnamectl set-hostname master
hostnamectl set-hostname node1
hostnamectl set-hostname node2
# 所有节点都修改 hosts
vim /etc/hosts
172.16.32.2 node1
172.16.32.6 node2
172.16.0.4 master
# 所有节点关闭 SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

所有节点确保防火墙关闭
```shell
systemctl stop firewalld
systemctl disable firewalld
```

所有节点添加安装源

```shell
# 添加 k8s 安装源
cat <<EOF > kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
mv kubernetes.repo /etc/yum.repos.d/

# 添加 Docker 安装源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

所有节点安装所需组件
```shell
# CentOS
yum install -y kubelet-1.22.4 kubectl-1.22.4 kubeadm-1.22.4 docker-ce
# ubuntu 没试过
apt-get install -y kubelet-1.22.4 kubectl-1.22.4 kubeadm-1.22.4 docker-ce
```



> 1.24 以上的版本会报错，因为默认不主持 Docker 了 T T

所有节点启动 kubelet、docker，并设置开机启动

```shell
systemctl enable kubelet
systemctl start kubelet

systemctl enable docker
systemctl start docker
```

所有节点修改 docker 配置

```shell
# kubernetes 官方推荐 docker 等使用 systemd 作为 cgroupdriver，否则 kubelet 启动不了
cat <<EOF > daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://ud6340vz.mirror.aliyuncs.com"]
}
EOF
mv daemon.json /etc/docker/

# 重启生效
systemctl daemon-reload
systemctl restart docker
```

**主节点**用 [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) 初始化集群

```shell
# 初始化集群控制台 Control plane
# 失败了可以用 kubeadm reset 重置
kubeadm init --image-repository=registry.aliyuncs.com/google_containers

# 记得把 kubeadm join xxx 保存起来
# 忘记了重新获取：kubeadm token create --print-join-command

# 复制授权文件，以便 kubectl 可以有权限访问集群
# 如果你其他节点需要访问集群，需要从主节点复制这个文件过去其他节点
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 在其他机器上创建 ~/.kube/config 文件也能通过 kubectl 访问到集群
```

> 有兴趣了解 kubeadm init 具体做了什么的，可以 [查看文档](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/)

**工作节点**加入集群

```shell
kubeadm join <master_ip>:6443 --token xxx --discovery-token-ca-cert-hash xxx
```

**主节点**安装网络插件，否则 node 是 NotReady 状态

```shell
# 很有可能国内网络访问不到这个资源，你可以网上找找国内的源安装 flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

查看节点，要在主节点查看（其他节点有安装 kubectl 也可以查看）

![image.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kw8x2qdf.png)

### 部署应用

#### 使用 YAML 文件

部署示例应用

```shell
kubectl run testapp --image=ccr.ccs.tencentyun.com/k8s-tutorial/test-k8s:v1
```

##### Pod

直接部署一个 pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  # 定义容器，可以多个
  containers:
    - name: test-k8s # 容器名字
      image: ccr.ccs.tencentyun.com/k8s-tutorial/test-k8s:v1 # 镜像
```

##### Deployment

使用 Deployment 来部署多个 pod

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  # 部署名字
  name: test-k8s
spec:
  replicas: 2
  # 用来查找关联的 Pod，所有标签都匹配才行
  selector:
    matchLabels:
      app: test-k8s
  # 定义 Pod 相关数据
  template:
    metadata:
      labels:
        app: test-k8s
    spec:
      # 定义容器，可以多个
      containers:
      - name: test-k8s # 容器名字
        image: ccr.ccs.tencentyun.com/k8s-tutorial/test-k8s:v1 # 镜像
```

Deployment 通过 label 关联起来 Pods

![deployment.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwpt8p8o.png)

#### 相关指令

部署一个 nodejs web 应用，源码地址：[Github](https://github.com/gzyunke/test-k8s)

```shell
# 部署应用
kubectl apply -f app.yaml
# 查看 deployment
kubectl get deployment
# 查看 pod
kubectl get pod -o wide
# 查看 pod 详情
kubectl describe pod <pod-name>
# 查看 log
kubectl logs <pod-name>
# 进入 Pod 容器终端， -c container-name 可以指定进入哪个容器。
kubectl exec -it <pod-name> -- bash
# 伸缩扩展副本
kubectl scale deployment <deployment-name> --replicas=5
# 把集群内端口映射到节点，这个命令的进程要一直开着
kubectl port-forward <pod-name> 8090:8080
# 查看历史
kubectl rollout history deployment <deployment-name>
# 回到上个版本
kubectl rollout undo deployment <deployment-name>
# 回到指定版本
kubectl rollout undo deployment <deployment-name> --to-revision=2
# 删除部署
kubectl delete deployment test-k8s
```

> **Pod 报错解决**
>
> 如果你运行 `kubectl describe pod/pod-name` 发现 Events 中有下面这个错误
>
> ```
> networkPlugin cni failed to set up pod "test-k8s-68bb74d654-mc6b9_default" network: open /run/flannel/subnet.env: no such file or directory
> ```
>
> 在每个节点创建文件`/run/flannel/subnet.env`写入以下内容，配置后等待一会就好了
>
> ```
> FLANNEL_NETWORK=10.244.0.0/16
> FLANNEL_SUBNET=10.244.0.1/24
> FLANNEL_MTU=1450
> FLANNEL_IPMASQ=true
> ```

**更多命令**

```shell
# 查看全部
kubectl get all
# 重新部署
kubectl rollout restart deployment test-k8s
# 命令修改镜像，--record 表示把这个命令记录到操作历史中
kubectl set image deployment test-k8s test-k8s=ccr.ccs.tencentyun.com/k8s-tutorial/test-k8s:v2-with-error --record
# 暂停运行，暂停后，对 deployment 的修改不会立刻生效，恢复后才应用设置
kubectl rollout pause deployment test-k8s
# 恢复
kubectl rollout resume deployment test-k8s
# 输出到文件
kubectl get deployment test-k8s -o yaml >> app2.yaml
# 删除全部资源
kubectl delete all --all
```

将 Pod 指定到某个节点运行：[nodeselector](https://kubernetes.io/zh/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)

限定 CPU、内存总量：[文档](https://kubernetes.io/zh/docs/concepts/policy/resource-quotas/#计算资源配额)

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    disktype: ssd
```

#### 工作负载分类

详见 [文档](https://kubernetes.io/zh/docs/concepts/workloads/)

- Deployment
  - 适合无状态应用，所有 pod 等价，可替代
- StatefulSet
  - 有状态的应用，适合数据库这种类型。
- DaemonSet
  - 在每个节点上跑一个 Pod，可以用来做节点监控、节点日志收集等
- Job & CronJob
  - Job 用来表达的是一次性的任务，而 CronJob 会根据其时间规划反复运行。

#### 现存问题

- 每次只能访问一个 pod，没有负载均衡自动转发到不同 pod
- 访问还需要端口转发
- Pod 重创后 IP 变了，名字也变了

### service

**特性**

- Service 通过 label 关联对应的 Pod
- Servcie 生命周期不跟 Pod 绑定，不会因为 Pod 重创改变 IP
- 提供了负载均衡功能，自动转发流量到不同 Pod
- 可对集群外部提供访问端口
- 集群内部可通过服务名字访问

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwpuoh0h.png)

#### 创建 Service

创建 一个 Service，通过标签 `test-k8s` 跟对应的 Pod 关联上

`service.yaml`

```yml
apiVersion: v1
kind: Service
metadata:
  name: test-k8s
spec:
  selector:
    app: test-k8s
  type: ClusterIP
  ports:
    - port: 8080        # 本 Service 的端口
      targetPort: 8080  # 容器端口
```

应用配置

```shell
kubectl apply -f service.yaml
```

查看服务

```shell
kubectl get svc
```

![kubernetes service](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwvie6pw.png)

查看服务详情

```shell
kubectl describe svc test-k8s
```

可以发现 Endpoints 是各个 Pod 的 IP，也就是他会把流量转发到这些节点。

![kubernetes endpoints](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwvifqes.png)

服务的默认类型是 `ClusterIP`，**只能在集群内部访问**，我们可以进入到 Pod 里面访问：

```shell
kubectl exec -it <pod-name> -- bash
curl http://<service-name>:8080 # 通过service的名字作为域名去访问
curl http://<service-ip>:8080 # 用service的ip也能访问
```

如果要在集群外部访问，可以通过端口转发实现（只适合临时测试用）

```shell
kubectl port-forward service/test-k8s 8888:8080 # 将8080转发到8888
```

> 如果你用 minikube，也可以运行 `minikube service test-k8s`

#### 对外暴露服务

上面我们是通过端口转发的方式可以在外面访问到集群里的服务，如果想要直接把集群服务暴露出来，我们可以使用`NodePort` 和 `Loadbalancer` 类型的 Service

```yml
apiVersion: v1
kind: Service
metadata:
  name: test-k8s
spec:
  selector:
    app: test-k8s
  # 默认 ClusterIP 集群内可访问，NodePort 节点可访问，LoadBalancer 负载均衡模式（需要负载均衡器才可用）
  type: NodePort
  ports:
    - port: 8080        # 本 Service 的端口
      targetPort: 8080  # 容器端口
      nodePort: 31000   # 节点端口，范围固定 30000 ~ 32767
```

应用配置

```shell
kubectl apply -f service.yaml
```

**在节点上**，我们可以 `curl http://localhost:31000/hello/easydoc` 访问到应用

并且是有负载均衡的，网页的信息可以看到被转发到了不同的 Pod

```shell
hello easydoc 

IP lo172.17.0.8, hostname: test-k8s-68bb74d654-962lh
```

> 如果你是用 minikube，因为是模拟集群，你的电脑并不是节点，节点是 minikube 模拟出来的，所以你并不能直接在电脑上访问到服务

`Loadbalancer` 也可以对外提供服务，这需要一个负载均衡器的支持，因为它需要生成一个新的 IP 对外服务，否则状态就一直是 pendding，这个很少用了，后面我们会讲更高端的 Ingress 来代替它。

#### 多端口

多端口时必须配置 name， [文档](https://kubernetes.io/zh/docs/concepts/services-networking/service/#multi-port-services)

```yml
apiVersion: v1
kind: Service
metadata:
  name: test-k8s
spec:
  selector:
    app: test-k8s
  type: NodePort
  ports:
    - port: 8080        # 本 Service 的端口
      name: test-k8s    # 必须配置
      targetPort: 8080  # 容器端口
      nodePort: 31000   # 节点端口，范围固定 30000 ~ 32767
    - port: 8090
      name: test-other
      targetPort: 8090
      nodePort: 32000
```

#### 总结

- **ClusterIP**
  - 默认的，仅在集群内可用
- **NodePort**
  - 暴露端口到节点，提供了集群外部访问的入口
    端口范围固定 30000 ~ 32767
- **LoadBalancer**
  - 需要负载均衡器（通常都需要云服务商提供，裸机可以安装 [METALLB](https://metallb.universe.tf/) 测试）
    会额外生成一个 IP 对外服务
    K8S 支持的负载均衡器：[负载均衡器](https://kubernetes.io/zh/docs/concepts/services-networking/service/#internal-load-balancer)

- **Headless**
  - 适合数据库
  - clusterIp 设置为 None 就变成 Headless 了，不会再分配 IP，后面会再讲到具体用法
  - [官网文档](https://kubernetes.io/zh/docs/concepts/services-networking/service/#headless-services)

### StatefulSet

#### 什么是 StatefulSet

StatefulSet 是用来管理**有状态**的应用，例如数据库。

前面我们部署的应用，都是不需要存储数据，不需要记住状态的，可以随意扩充副本，每个副本都是一样的，可替代的。

而像数据库、Redis 这类有状态的，则不能随意扩充副本。

StatefulSet 会固定每个 Pod 的名字

#### 部署 StatefulSet 类型的 Mongodb

```yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  # serviceName: mongodb
  replicas: 3
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongo
          image: mongo:4.4
          # IfNotPresent 仅本地没有镜像时才远程拉，Always 永远都是从远程拉，Never 永远只用本地镜像，本地没有则报错
          imagePullPolicy: IfNotPresent
---
#  对应的 service
apiVersion: v1
kind: Service
metadata:
  name: mongodb
spec:
  selector:
    app: mongodb # 跟pod对应上
  type: ClusterIP
  clusterIP: None # HeadLess，不分配ip
  ports:
    - port: 27017
      targetPort: 27017
```

#### StatefulSet 特性

- Service 的 `CLUSTER-IP` 是空的，Pod 名字也是固定的。
- Pod 创建和销毁是有序的，创建是顺序的，销毁是逆序的。
- Pod 重建不会改变名字，但是 IP 还是会变的，所以不要用 IP 直连

![statefulset.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwrhzaku.png)

Endpoints 会多一个 hostname

![endpoints](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwri1g2g.png)

访问时，如果直接使用 Service 名字连接，会随机转发请求

要连接指定 Pod，可以这样`pod-name.service-name`

运行一个临时 Pod 连接数据测试下
```shell
kubectl run mongodb-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mongodb:4.4.10-debian-10-r20 --command -- bash
```

#### Web 应用连接 Mongodb

在集群内部，我们可以通过服务名字访问到不同的服务

指定连接第一个：`mongodb-0.mongodb`

![mongodbweb.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwriial2)

![image.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwripe9o.png)

#### 问题

**pod 重建后，数据库的内容丢失了**

下节，我们讲解如何解决这个问题。

### 数据持久化

#### 介绍

kubernetes 集群不会为你处理数据的存储，我们可以为数据库挂载一个磁盘来确保数据的安全。

你可以选择云存储、本地磁盘、NFS。

- 本地磁盘：可以挂载某个节点上的目录，但是这需要限定 pod 在这个节点上运行
- 云存储：不限定节点，不受集群影响，安全稳定；需要云服务商提供，裸机集群是没有的。
- NFS：不限定节点，不受集群影响

#### hostPath 挂载示例

把节点上的一个目录挂载到 Pod，但是已经**不推荐使用了**，[文档](https://kubernetes.io/zh/docs/concepts/storage/volumes/#hostpath)

配置方式简单，需要手动指定 Pod 跑在某个固定的节点。

仅供单节点测试使用；不适用于多节点集群。

> minikube 提供了 hostPath 存储，[文档](https://minikube.sigs.k8s.io/docs/handbook/persistent_volumes/)

```yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  serviceName: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongo
          image: mongo:4.4
          # IfNotPresent 仅本地没有镜像时才远程拉，Always 永远都是从远程拉，Never 永远只用本地镜像，本地没有则报错
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: /data/db # 容器里面的挂载路径
              name: mongo-data    # 卷名字，必须跟下面定义的名字一致
      volumes:
        - name: mongo-data              # 卷名字
          hostPath:
            path: /data/mongo-data      # 节点上的路径
            type: DirectoryOrCreate     # 指向一个目录，不存在时自动创建
```

#### 更高级的抽象

![持久卷](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwrmidne.png)

##### Storage Class (SC)

将存储卷划分为不同的种类，例如：SSD，普通磁盘，本地磁盘，按需使用。[文档](https://kubernetes.io/zh/docs/concepts/storage/storage-classes/)

```yml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  iopsPerGB: "10"
  fsType: ext4
```

##### Persistent Volume (PV)

描述卷的具体信息，例如磁盘大小，[访问模式](https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/#access-modes)。[文档](https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/)，[类型](https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes)，[Local 示例](https://kubernetes.io/zh/docs/concepts/storage/volumes/#local)

```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodata
spec:
  capacity:
    storage: 2Gi
  volumeMode: Filesystem  # Filesystem（文件系统） Block（块）
  accessModes:
    - ReadWriteOnce       # 卷可以被一个节点以读写方式挂载
  persistentVolumeReclaimPolicy: Delete
  storageClassName: local-storage
  local:
    path: /root/data
  nodeAffinity:
    required:
      # 通过 hostname 限定在某个节点创建存储卷
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - node2
```

##### Persistent Volume Claim (PVC)

对存储需求的一个申明，可以理解为一个申请单，系统根据这个申请单去找一个合适的 PV
还可以根据 PVC 自动创建 PV。

```yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodata
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: "local-storage"
  resources:
    requests:
      storage: 2Gi
```

##### 为什么要这么多层抽象

- 更好的分工，运维人员负责提供好存储，开发人员不需要关注磁盘细节，只需要写一个申请单。
- 方便云服务商提供不同类型的，配置细节不需要开发者关注，只需要一个申请单。
- [动态创建](https://kubernetes.io/zh/docs/concepts/storage/dynamic-provisioning/)，开发人员写好申请单后，供应商可以根据需求自动创建所需存储卷。

#### 腾讯云示例

配置可视化操作，最后还会生成 yml 文件，很棒

![腾讯云创建kubernetes pvc](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwvrj64s.png)

#### 本地磁盘示例

不支持动态创建，需要提前创建好

```yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        image: mongo:5.0
        imagePullPolicy: IfNotPresent
        name: mongo
        volumeMounts:
          - mountPath: /data/db
            name: mongo-data
      volumes:
        - name: mongo-data
          persistentVolumeClaim: # pvc
             claimName: mongodata
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb
spec:
  clusterIP: None
  ports:
  - port: 27017
    protocol: TCP
    targetPort: 27017
  selector:
    app: mongodb
  type: ClusterIP
---
# sc
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
---
# pv
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodata
spec:
  capacity:
    storage: 2Gi
  volumeMode: Filesystem  # Filesystem（文件系统） Block（块）
  accessModes:
    - ReadWriteOnce       # 卷可以被一个节点以读写方式挂载
  persistentVolumeReclaimPolicy: Delete
  storageClassName: local-storage
  local:
    path: /root/data
  nodeAffinity:
    required:
      # 通过 hostname 限定在某个节点创建存储卷
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - node2
---
# pvc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodata
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: "local-storage"
  resources:
    requests:
      storage: 2Gi
```

#### 问题

当前数据库的连接地址是写死在代码里的，另外还有数据库的密码需要配置。

下节，我们讲解如何解决。

### 配置文件

#### ConfigMap

数据库连接地址，这种可能根据部署环境变化的，我们不应该写死在代码里。
Kubernetes 为我们提供了 ConfigMap，可以方便的配置一些变量。[文档](https://kubernetes.io/zh/docs/concepts/configuration/configmap/)

```yml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongo-config
data:
  mongoHost: mongodb-0.mongodb
```

```shell
# 应用
kubectl apply -f configmap.yaml
# 查看
kubectl get configmap mongo-config -o yaml
```

![configmap.png](https://sjwx.easydoc.xyz/46901064/files/kwubdzyw.png)

#### Secret

一些重要数据，例如密码、TOKEN，我们可以放到 secret 中。[文档](https://kubernetes.io/zh/docs/concepts/configuration/secret/)，[配置证书](https://kubernetes.io/zh/docs/concepts/configuration/secret/#tls-secret)

> 注意，数据要进行 Base64 编码。[Base64 工具](https://tools.fun/base64.html)

```yml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
# Opaque 用户定义的任意数据，更多类型介绍 https://kubernetes.io/zh/docs/concepts/configuration/secret/#secret-types
type: Opaque
data:
  # 数据要 base64。https://tools.fun/base64.html
  mongo-username: bW9uZ291c2Vy
  mongo-password: bW9uZ29wYXNz
```

```shell
# 应用
kubectl apply -f secret.yaml
# 查看
kubectl get secret mongo-secret -o yaml
```

![image.png](https://sjwx.easydoc.xyz/46901064/files/kwub4een.png)

#### 使用方法

##### 作为环境变量使用

```yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongo
          image: mongo:4.4
          # IfNotPresent 仅本地没有镜像时才远程拉，Always 永远都是从远程拉，Never 永远只用本地镜像，本地没有则报错
          imagePullPolicy: IfNotPresent
          env:
          - name: MONGO_INITDB_ROOT_USERNAME
            valueFrom:
              secretKeyRef:
                name: mongo-secret
                key: mongo-username
          - name: MONGO_INITDB_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mongo-secret
                key: mongo-password
          # Secret 的所有数据定义为容器的环境变量，Secret 中的键名称为 Pod 中的环境变量名称
          # envFrom:
          # - secretRef:
          #     name: mongo-secret
```

##### 挂载为文件（更适合证书文件）

挂载后，会在容器中对应路径生成文件，一个 key 一个文件，内容就是 value，[文档](https://kubernetes.io/zh/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)

```yml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```

### Helm & 命名空间

#### 介绍

`Helm` 类似 npm，pip，docker hub, 可以理解为是一个软件库，可以方便快速的为我们的集群安装一些第三方软件。
使用 Helm 我们可以非常方便的就搭建出来 MongoDB / MySQL 副本集群，YAML 文件别人都给我们写好了，直接使用。[官网](https://helm.sh/zh/)，[应用中心](https://artifacthub.io/)

#### 安装 Helm

安装 [文档](https://helm.sh/zh/docs/intro/install/)
```shell
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

#### 安装 MongoDB 示例

一个主从 mongo

```yml
# 安装
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-mongo bitnami/mongodb

# 指定密码和架构
helm install my-mongo bitnami/mongodb --set architecture="replicaset",auth.rootPassword="mongopass"

# 删除
helm ls
heml delete my-mongo

# 查看密码
kubectl get secret my-mongo-mongodb -o json
kubectl get secret my-mongo-mongodb -o yaml > secret.yaml

# 临时运行一个包含 mongo client 的 debian 系统
kubectl run mongodb-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mongodb:4.4.10-debian-10-r20 --command -- bash

# 进去 mongodb
mongo --host "my-mongo-mongodb" -u root -p mongopass

# 也可以转发集群里的端口到宿主机访问 mongodb
kubectl port-forward svc/my-mongo-mongodb 27017:27018
```

#### 命名空间

如果一个集群中部署了多个应用，所有应用都在一起，就不太好管理，也可以导致名字冲突等。
我们可以使用 namespace 把应用划分到不同的命名空间，跟代码里的 namespace 是一个概念，只是为了划分空间。

```shell
# 打印命名空间
kubectl get ns
# 创建命名空间
kubectl create namespace testapp
# 部署应用到指定的命名空间
kubectl apply -f app.yml --namespace testapp
# 查询
kubectl get pod --namespace kube-system
```

##### kubens

可以用 [kubens](https://github.com/ahmetb/kubectx) 快速切换 namespace

```shell
# 切换命名空间
kubens kube-system
# 回到上个命名空间
kubens -
# 切换集群
kubectx minikube
```

![image.png](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwudup5z.png)

###  Ingress

Ingress 为外部访问集群提供了一个 **统一** 入口，避免了对外暴露集群端口；

功能类似 Nginx，可以根据域名、路径把请求转发到不同的 Service。

可以配置 https

> **跟 LoadBalancer 有什么区别？**
>
> LoadBalancer 需要对外暴露端口，不安全；
>
> 无法根据域名、路径转发流量到不同 Service，多个 Service 则需要开多个 LoadBalancer；
>
> 功能单一，无法配置 https

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwhd6dc8.png" alt="img" style="zoom: 80%;" />

#### 使用

要使用 Ingress，需要一个负载均衡器 + Ingress Controller

- 如果是裸机（bare metal）搭建的集群，你需要自己安装一个负载均衡插件，可以安装 [METALLB](https://metallb.universe.tf/)

- 如果是云服务商，会自动给你配置，否则你的外部 IP 会是 “pending” 状态，无法使用。

> 文档：[Ingress](https://kubernetes.io/zh/docs/concepts/services-networking/ingress/)
>
> Minikube 中部署 Ingress Controller：[nginx](https://kubernetes.io/zh/docs/tasks/access-application-cluster/ingress-minikube/)
>
> Helm 安装： [Nginx](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start)

```yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-example
spec:
  ingressClassName: nginx
  rules:
  - host: tools.fun
    http:
      paths:
      - path: /easydoc
        pathType: Prefix
        backend:
          service:
            name: service1
            port:
              number: 4200
      - path: /svnbucket
        pathType: Prefix
        backend:
          service:
            name: service2
            port:
              number: 8080
```

#### 腾讯云配置 Ingress 演示

![腾讯云 ingress](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/kwvrrepn.png)

### 其他

kubernetes 可以管理大量的容器化应用，方便的进行伸缩扩展集群，随时回退版本。
kubernetes 需要云厂商的支持才是完整的，好在当前各大云厂商都已经提供了 k8s 集群服务，生态很完善，非常方便。
我们自己搭建的叫裸机，用来做测试、学习很好，可以把自己淘汰的电脑用起来搭建出一个集群玩玩。

#### WEB 可视化管理集群

如果你觉得命令行管理集群太麻烦，你可以用 Helm 快速搭建一个 [kubernetes-dashboard](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard)，这样你就有了一个 WEB 界面，可以可视化的进行一些操作和管理。
如果是 minikube 更加简单，一个命令`minikube dashboard`就好了。

#### 数据库更好的做法

数据库这种有状态的应用，更好的做法是直接使用云厂商提供的数据库，运行会更加稳定，也有完善的数据备份。

#### 用脚本搭建集群

Github 上有用户已经把裸机搭建需要做的工作写成了脚本，一个脚本就帮你初始化好集群工作：[kainstall](https://github.com/lework/kainstall)

#### 公网搭建 K8S 集群

网友提供的：[参考文档](https://ilep2pm1ty.feishu.cn/docs/doccnah39IMGdW3sY5uZWvJaX3X)
