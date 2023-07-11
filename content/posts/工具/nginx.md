---
title: "Nginx"
date: 2023-07-11
draft: false
author: "MelonCholi"
tags: [快速入门]
categories: [工具]
---

# Nginx

> 中文文档：https://blog.redis.com.cn/doc/

- Nginx (**engine x**) 是一个**高性能的 HTTP 和反向代理 web 服务器**，同时也提供了 IMAP/POP3/SMTP 服务。
- Nginx 是由伊戈尔·赛索耶夫为俄罗斯访问量第二的 Rambler.ru 站点（俄文：Рамблер）开发的，第一个公开版本 0.1.0 发布于 2004 年 10 月 4 日。其将源代码以类 BSD 许可证的形式发布，因它的稳定性、丰富的功能集、简单的配置文件和低系统资源的消耗而闻名。2011 年 6 月 1 日，nginx 1.0.4 发布。
- Nginx 支持热部署，启动简单，可以做到 7*24 不间断运行。几个月都不需要重新启动。

## 概念

### 反向代理

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/619d428416b44f538d3da146bd5c52fc.png)

**正向代理**

- 平时直接用国内的服务器总是无法访问国外的服务器。所以需要在本地搭建一个服务器来帮助去访问。那这种就是正向代理。（浏览器中配置代理服务器）

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-c8ac111c267ae0745f984e326ef0c47f_1440w.webp)

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/171864e773f05fe7~tplv-t2oaga2asx-zoom-in-crop-mark:1512:0:0:0.awebp)

**反向代理**

- 比如访问淘宝的时候，淘宝内部肯定有很多台服务器，其间 session 不共享，那我们是不是在服务器之间访问需要频繁登录；这个时候淘宝搭建一个过渡服务器，对客户端是没有任何感知的，“登录一次，但是访问所有”，这就是反向代理。
- **客户端对代理是无感知的**，客户端不需要任何配置就可以访问，我们只需要把请求发送给反向代理服务器，由反向代理服务器去选择目标服务器获取数据后，再返回给客户端
- 此时反向代理服务器和目标服务器**对外就是一个服务器**，暴露的是代理服务器地址，隐藏了真实服务器的地址。（在服务器中配置代理服务器）

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-4787a512240b238ebf928cd0651e1d99_1440w.webp)

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/17183720f7a66978~tplv-t2oaga2asx-zoom-in-crop-mark:1512:0:0:0.awebp)

**正向代理代表客户端发送请求给目标服务器，而反向代理则代表目标服务器接收客户端请求。**

反向代理的主要功能包括：

1. **负载均衡**：反向代理服务器可以分发客户端请求到多个目标服务器上，以平衡服务器负载。它可以根据服务器的性能、负载情况、响应时间等因素来智能地分配请求，提高整体系统的性能和可用性。
2. **缓存加速**：反向代理服务器可以缓存目标服务器返回的响应数据，当下次有相同请求时，可以直接从缓存中返回响应，减少对目标服务器的访问，提高响应速度和网络带宽利用率。
3. **安全性**：反向代理可以作为网络边界的一道防火墙，保护后端服务器免受恶意请求、攻击和未经授权的访问。它可以屏蔽目标服务器的真实 IP 地址，增加系统的安全性。
4. **SSL/TLS 终结**：反向代理服务器可以处理客户端与服务器之间的加密通信。它可以负责对客户端请求进行 SSL/TLS 加密和解密操作，然后将非加密的请求转发给后端服务器，提供更高的安全性。

### 负载均衡

负载均衡（Load Balance）就是将请求分摊到多个操作单元上进行执行，例如 Web 服务器、FTP 服务器、企业关键应用服务器和其它关键任务服务器等，从而共同完成工作任务。

简单来说就是：现有的请求使服务器压力太大无法承受，所有我们需要搭建一个服务器**集群**，去分担原先一个服务器所承受的压力，那现在我们有 ABCD 等等多台服务器，我们需要把请求分给这些服务器，但是服务器可能大小也有自己的不同，所以怎么分？如何分配更好？又是一个问题。

Nginx 提供三种负载均衡方式：

1. **轮询法**（默认方法）
    - 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器 down 掉，能自动剔除。
    - 适合服务器配置相当，无状态且短平快的服务使用。也适用于图片服务器集群和纯静态页面服务器集群。
2. **weight 权重模式**（加权轮询）
    - 指定轮询几率，weight 和访问比率成正比，权重越高，被访问的概率越大
    - 用于后端服务器性能不均的情况。
    - 这种方式比较灵活，当后端服务器性能存在差异的时候，通过配置权重，可以让服务器的性能得到充分发挥，有效利用资源。
3. **ip_hash**
    - 上述方式存在一个：假如用户在某台服务器上登录了，那么该用户第二次请求的时候，因为我们是负载均衡系统，每次请求都会重新定位到服务器集群中的某一个，那么已经登录某一个服务器的用户再重新定位到另一个服务器，其登录信息将会丢失，这样显然是不妥的。
    - 我们可以采用 ip_hash 指令解决这个问题，如果客户已经访问了某个服务器，当用户再次访问时，会将该请求通过哈希算法，自动定位到该服务器。每个请求按访问 ip 的 hash 结果分配，这样每个访客固定访问一个后端服务器，可以解决 session 的问题。
    - 严格意义上来说，ip_hash 算是 nginx 负载均衡的一个优化方案

### 动静分离

Nginx 的动静分离是一种使用 Nginx 服务器进行网站优化的策略，旨在提高网站性能和并发处理能力。它通过将动态内容和静态内容分开处理，使得 Nginx 专注于处理静态资源，而将动态请求转发给后端应用服务器。

在动静分离的架构中，通常将**静态资源**（如 HTML、CSS、JavaScript、图像文件等）存储在 Nginx 服务器的本地文件系统中，并由 Nginx 直接提供这些静态文件的访问。这样可以充分利用 Nginx 的高性能、高并发处理能力和缓存机制，提供快速响应和高吞吐量的静态资源服务。

而**动态请求**（如 PHP、Python、Java 等动态脚本的执行）则会被 Nginx 转发到后端的应用服务器（如 PHP-FPM、uWSGI、Tomcat 等）进行处理。后端应用服务器负责执行动态脚本，并将结果返回给 Nginx，然后由 Nginx 再将响应返回给客户端。

通过这种方式，Nginx 可以专注于处理静态资源，充分发挥其高效的静态文件服务能力，减轻后端应用服务器的负担。同时，通过合理的缓存配置，可以提高网站的访问速度、降低后端服务器的负载，提供更好的用户体验。

![在这里插入图片描述](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/1e5c3b57b3cd42ebb5ca79b0e3bfb099.png)

```nginx
server {  
        listen       8080;        
        server_name  localhost;

        location / {
            root   html; # Nginx默认值
            index  index.html index.htm;
        }
        
        # 静态化配置，所有静态请求都转发给 nginx 处理，存放目录为 my-project
        location ~ .*\.(html|htm|gif|jpg|jpeg|bmp|png|ico|js|css)$ {
            root /usr/local/var/www/my-project; # 静态请求所代理到的根目录
        }
        
        # 动态请求匹配到path为'node'的就转发到8002端口处理
        location /node/ {  
            proxy_pass http://localhost:8002; # 充当服务代理
        }
}
```

如上例：

1. 访问静态资源 nginx 服务器会返回 my-project 里面的文件，如获取 index.html
2. 访问动态请求 nginx 服务器会将它从 8002 端口请求到的内容，原封不动的返回回去

### Master-Worker 模式

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-0951372e22a6314b1e9b520b3cd6b3b6_1440w.webp)

启动 Nginx 后，其实就是在 80 端口启动了 Socket 服务进行监听，如图所示，Nginx 涉及 Master 进程和 Worker 进程。

![](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-0951372e22a6314b1e9b520b3cd6b3b6_1440w.webp)

Master 进程：读取并验证配置文件 nginx.conf；管理 worker 进程；

Worker 进程：每一个 Worker 进程都维护一个线程（避免线程切换），处理连接和请求；注意 Worker 进程的个数由配置文件决定，一般和 CPU 个数相关（有利于进程切换），配置几个就有几个 Worker 进程。

## 快速入门

### 安装

```sh
sudo apt install nginx
```

### 命令

启动 Nginx：

```sh
sudo nginx
```

停止 Nginx：

```sh
sudo nginx -s stop
```

热重启 Nginx：

```sh
sudo nginx -s reload
```

强制停止 Nginx：

```sh
sudo pkill -9 nginx
```

### 配置

经常要用到的几个文件路径：

1. `/usr/local/etc/nginx/nginx.conf` （nginx 配置文件路径）
2. `/usr/local/var/www` （nginx 服务器默认的根目录）
3. `/usr/local/Cellar/nginx/1.17.9` （nginx 的安装路径）
4. `/usr/local/var/log/nginx/error.log` (nginx 默认的日志路径)

nginx 默认配置文件简介：

```nginx
# 首尾配置暂时忽略
server {  
        # 当nginx接到请求后，会匹配其配置中的service模块
        # 匹配方法就是将请求携带的host和port去跟配置中的server_name和listen相匹配
        listen       8080;        
        server_name  localhost; # 定义当前虚拟主机（站点）匹配请求的主机名

        location / {
            root   html; # Nginx默认值
            # 设定Nginx服务器返回的文档名
            index  index.html index.htm; # 先找根目录下的index.html，如果没有再找index.htm
        }
}
# 首尾配置暂时忽略
```

server{} 其实是包含在 http{} 内部的。每一个 server{} 是一个虚拟主机（站点）。

上面代码块的意思是：当一个请求叫做`localhost:8080`请求 nginx 服务器时，该请求就会被匹配进该代码块的 server{} 中执行。

#### 配置反向代理

配置一个简单的反向代理是很容易的，代码如下：

```nginx
server {  
        listen       8080;        
        server_name  localhost;

        location / {
            root   html; # Nginx默认值
            index  index.html index.htm;
        }
        
        proxy_pass http://localhost:8000; # 反向代理配置，请求会被转发到8000端口
}
```

反向代理的表现很简单。那上面的代码块来说，其实就是向 nginx 请求 `localhost:8080` 跟请求 `http://localhost:8000` 是一样的效果。

这是一个反向代理最简单的模型，只是为了说明反向代理的配置。但是现实中反向代理多数是用在负载均衡中。示意图如下：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/17183720f7a66978~tplv-t2oaga2asx-zoom-in-crop-mark:1512:0:0:0.awebp)

nginx 就是充当图中的 proxy。左边的 3 个 client 在请求时向 nginx 获取内容，是感受不到 3 台 server 存在的。此时，proxy 就充当了 3 个 server 的反向代理。

#### 配置负载均衡

配置一个简单的负载均衡并不复杂，代码如下：

```nginx
# 负载均衡：设置domain
upstream domain {
    server localhost:8000;
    server localhost:8001;
}
server {  
        listen       8080;        
        server_name  localhost;

        location / {
            # root   html; # Nginx默认值
            # index  index.html index.htm;
            
            proxy_pass http://domain; # 负载均衡配置，请求会被平均分配到8000和8001端口
            proxy_set_header Host $host:$server_port;
        }
}
```

比如 8000 和 8001 是我本地用 Node.js 起的两个服务，负载均衡成功后可以看到访问 `localhost:8080` 有时会访问到 8000 端口的页面，有时会访问到 8001 端口的页面。
