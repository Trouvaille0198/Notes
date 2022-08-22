---
title: "配置 SSH"
date: 2022-04-25
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
---

# 配置 SSH

## 客户端

ubuntu ssh 配置：https://blog.csdn.net/netwalk/article/details/12952051

ubuntu ssh 实现无密码登录：https://blog.csdn.net/weixin_33725126/article/details/91726998

### 配置私钥

```shell
ssh-keygen
```

### 连接服务端

```ssh
ssh username@ip [-p port]
```

在 `.ssh` 目录中打开 bash，将客户端的公钥放到服务端上

```shell
ssh-copy-id username@ip 
```

然后就可以使用私钥登录

```shell
ssh username@ip [-p port] -i id_rsa
```

