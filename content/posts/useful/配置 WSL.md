---
title: "配置 WSL"
date: 2022-02-14
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
date created: 24-04-10 09:58
date modified: 24-04-10 13:44
---

# 配置 WSL

## 使用 ssh 远程 wsl

### 安装 ssh 服务

```shell
apt install openssh-server
```

修改 sshd 服务启动配置文件

```shell
vi /etc/ssh/sshd_config

# add
# 允许root用户登录
PermitRootLogin yes
# 服务端口，为了不和windows及其它wsl子系统冲突，手动指定一个
Port 12308
# 监听地址，如果需要远程机器连接
ListenAddress 0.0.0.0
```

#### 启动

ubuntu

```shell
service ssh restart
```

wsl

wsl 是无法用 `systemctl` 启动 ssh 的，因此，需要自己写脚本 `vi /etc/init.d/sshd`

```bash
#!/bin/sh
# Start/stop/restart the secure shell server:

sshd_start() {
  # Create host keys if needed.
  if [ ! -r /etc/ssh/ssh_host_key ]; then
    /usr/bin/ssh-keygen -t rsa1 -f /etc/ssh/ssh_host_key -N '' 
  fi
  if [ ! -f /etc/ssh/ssh_host_dsa_key ]; then
    /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
  fi
  if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
  fi
  if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    /usr/bin/ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key-N ''
  fi
  if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    /usr/bin/ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key-N ''
  fi
  /usr/sbin/sshd -f /etc/ssh/sshd_config
}

sshd_stop() {
  killall sshd
}

sshd_restart() {
  if [ -r /var/run/sshd.pid ]; then
    echo "WARNING: killing listener process only.  To kill every sshd process, you must"
    echo "         use 'rc.sshd stop'.  'rc.sshd restart' kills only the parent sshd to"
    echo "         allow an admin logged in through sshd to use 'rc.sshd restart' without"
    echo "         being cut off.  If sshd has been upgraded, new connections will now"
    echo "         use the new version, which should be a safe enough approach."
    kill `cat /var/run/sshd.pid`
  else
    killall sshd
  fi
  sleep 1
  sshd_start
}

case "$1" in
'start')
  sshd_start
  ;;
'stop')
  sshd_stop
  ;;
'restart')
  sshd_restart
  ;;
*)
  echo "usage $0 start|stop|restart"
esac
```

启动

```shell
/etc/init.d/sshd start
```

查看

```shell
ps -ef|grep ssh
```

windows 下面 `win+r` 打开 `cmd`，输 入 `netstat -ano|findstr "12308"` 查看端口，发现已经启动

到这个阶段，已经可以用本地 win 主机来 ssh 连接 wsl 了

```shell
ssh <name>@<wsl ip> -p 12308
```

### 远程 ssh 连接

如果防火墙开启，那我们需要配置防火墙规则同时需要配置端口转发规则

#### 配置端口转发规则

意思就是，访问到物理机的 2222 端口的请求，转发到 wsl 的 12308 端口，IP 为 wsl 的 ip

```powershell
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=[IP] connectport=[PORT]
```

#### 配置防火墙出入站规则

这是安全规则，如果防火墙关闭的话则不用配置，

```powershell
netsh advfirewall firewall add rule name=WSL2 dir=in action=allow protocol=TCP localport=2222
```

配置完以上两步后，我们则可以通过外网来访问我们的 wsl

（例如，本机 ip 是 1.2.3.4，wsl 地址是 172.16.12.1）

那么，远程访问时，通过

```shell
ssh jack@1.2.3.4 -p 2222
```

即使所有的命令行都关闭，只要 wsl 不是 shutdown 状态，ssh 服务正常开启，那么就可以通过 ssh 进行连接

其实，通过这一步可以自由的配置本地端口与 wsl 端口的映射，也就是可以通过物理机来进行网站或应用程序的访问，比如，我们再 wsl 部署一个网站，我们可以直接将该网站的端口 xxxx 映射到物理机的 8080（举例），那么我们通过本机 ip:8080 即可访问该网站，大大提高我们的易操作性。

### wsl “固定 IP” 配置

wsl 每次重启，ip 地址都会变化，也就是说通过以上步骤添加的映射规则再 wsl 重启后就失效了！

其实这种说法并不准确，因为严格意义上，固定 wsl ip 实现相当复杂，我们一般都是通过变相的操作来达到相同的目的。

这个方法就是，wsl 启动时，读取 ip 并将 ip 以及域名写入到 Windows 的 hosts 文件中，这样以来，我们映射规则中的 IP 就可以用域名来代替。

> 详见 https://zhuanlan.zhihu.com/p/372601715

## 转移 WSL 到其他盘

> 摘自：https://zhuanlan.zhihu.com/p/621873601

### 准备工作

打开 CMD，输入 `wsl -l -v` 查看 wsl 虚拟机的名称与状态。

![image-20230525223359817](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20230525223359817.png)

了解到本机的 WSL 全称为 Ubuntu，以下的操作都将围绕这个来进行。

输入 `wsl --shutdown` 使其停止运行，再次使用 `wsl -l -v` 确保其处于 stopped 状态。

### 导出 / 恢复备份

在 D 盘创建一个目录用来存放新的 WSL，比如 `D:\Ubuntu_WSL` 。

导出备份（比如命名为 Ubuntu.tar)

```sh
wsl --export Ubuntu D:\Ubuntu_WSL\Ubuntu.tar
```

确定在此目录下可以看见备份 Ubuntu.tar 文件之后，注销原有的 wsl

```sh
wsl --unregister Ubuntu
```

将备份文件恢复到 `D:\Ubuntu_WSL` 中去

```sh
wsl --import Ubuntu D:\Ubuntu_WSL D:\Ubuntu_WSL\Ubuntu.tar
```

这时候启动 WSL，发现好像已经恢复正常了，但是用户变成了 root，之前使用过的文件也看不见了。

### 恢复默认用户

在 CMD 中，输入 `Linux发行版名称 config --default-user 原本用户名`

例如：

```bash
Ubuntu config --default-user melon
```

请注意，这里的发行版名称的版本号是纯数字，比如 Ubuntu-22.04 就是 Ubuntu2204。

这时候再次打开 WSL，你会发现一切都恢复正常了。
