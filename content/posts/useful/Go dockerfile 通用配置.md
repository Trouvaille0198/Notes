---
title: "Go Dockerfile 通用配置"
date: 2022-06-25
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
---

# Go Dockerfile 通用配置

```dockerfile
FROM golang:alpine AS builder
RUN apk add --no-cache git

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPROXY=https://goproxy.cn \ # 使用国内镜像源，如果要在actions里跑的话就不用
    GOPRIVATE=github.com/<org_name> # 私有组织

WORKDIR /build

COPY . .

# 如果要go get私人仓库
RUN git config \
    --global \
    url."https://<github_name>:<github_access_token>@github.com".insteadOf \
    "https://github.com"
RUN go get github.com/<org_or_name>/<repo_name>


# 编译成二进制可执行文件server
RUN go build -o server .

# 创建小镜像
FROM scratch


# 拷贝配置文件
COPY ./configs/server.yml /
# 从builder镜像中把/build/server 拷贝到当前目录
COPY --from=builder /build/server /

# 声明服务端口
EXPOSE 8080

# 启动容器时运行的命令
CMD ["/server", "--config", "/server.yml"]
```

