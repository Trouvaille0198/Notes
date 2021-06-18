# 一、客户端

## 1.1 配置私钥

```shell
ssh-keygen
```

## 1.2 连接服务端

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

