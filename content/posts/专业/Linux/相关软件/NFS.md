---
title: "NFS"
date: 2021-03-16
author: MelonCholi
draft: false
tags: [Linux]
categories: [Linux]
---

# NFS

NFS 即网络文件系统（Network File-System），可以通过网络让不同机器、不同系统之间可以实现文件共享。通过 NFS，可以访问远程共享目录，就像访问本地磁盘一样。NFS 只是一种文件系统，本身并没有传输功能，是基于 RPC（远程过程调用）协议实现的，采用 C/S 架构。

## 搭建 NFS Server

安装 NFS 软件包
```shell
sudo apt-get install nfs-kernel-server  # 安装 NFS服务器端
```

添加 NFS 共享目录

```shell
sudo vim /etc/exports
```

添加一行，把 “/nfsroot” 目录设置为 NFS 共享目录

```shell
/nfsroot *(rw,sync,no_root_squash)     # * 表示允许任何网段 IP 的系统访问该 NFS 目录
```

新建“/nfsroot”目录，并为该目录设置最宽松的权限：

```shell
sudo mkdir /nfsroot
sudo chmod -R 777 /nfsroot
sudo chown ipual:ipual /nfsroot/ -R   # ipual 为当前用户，-R 表示递归更改该目录下所有文件
```

启动 NFS 服务

```shell
sudo /etc/init.d/nfs-kernel-server start    
# or
sudo /etc/init.d/nfs-kernel-server restart
```

在 NFS 服务已经启动的情况下，如果修改了 “/etc/exports” 文件，需要重启 NFS 服务，以刷新 NFS 的共享目录。

## NFS Client 配置

安装客户端

```shell
sudo apt-get install nfs-common         # 安装 NFS客户端
```

挂载

```shell
sudo mount -t nfs 192.168.163.128:/nfsroot /mnt -o nolock
```

192.168.12.123 为主机 ip，/nfsroot 为主机共享目录，/mnt 为设备挂载目录，如果指令运行没有出错，则 NFS 挂载成功，在主机的 /mnt 目录下应该可以看到 /nfsroot 目录下的内容（可先在 nfsroot 目录下新建测试目录），

卸载：

```shell
umount /mnt
```

若要开机自动挂载，在 /etc/fstab 里添加

```shell
192.168.12.123:/nfsroot   /mnt   nfs  rw 0 0
```

