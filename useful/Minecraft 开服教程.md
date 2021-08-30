# Minecraft 开服教程

## 开服步骤

### 前置步骤

在云服务器的安全组中放行 25565 的 TCP 端口

### 服务端选择

官方服务器：https://www.minecraft.net/zh-hans/download/server，下载核心

### 搭建 Java 环境

1.16 及之前版本，需要安装 Java8

```shell
sudo apt install openjdk-8-jdk
```

1.17 及之后版本，需要安装 Java16

```shell
sudo apt install openjdk-16-jdk
```

检查 Java 环境是否安装正确。

```text
java -version
```

如果出现以下情况，说明安装成功：

```text
openjdk version "1.8.0_265"
OpenJDK Runtime Environment (build 1.8.0_265-8u265-b01-0ubuntu2~18.04-b01)
OpenJDK 64-Bit Server VM (build 25.265-b01, mixed mode)
```

### 运行服务端

#### 官方服务端

运行核心

```shell
java -Xms512M -Xmx1024M -jar <服务器核心的文件名> nogui
```

将会收到如下的报错信息，需要我们同意相关协议：

```shell
[14:58:23] [main/ERROR]: Failed to load properties from file: server.properties
[14:58:23] [main/WARN]: Failed to load eula.txt
[14:58:23] [main/INFO]: You need to agree to the EULA in order to run the server. Go to eula.
```

同意相关协议

```shell
vim eula.txt
```

把最后一行的 `false` 修改为 `true`

### 修改配置

```shell
vim server.properties
```

## 安装 Mod

下载对应版本的 forge，拷贝到服务端根目录

运行命令：

```shell
java -jar <forge_name> --install
```

等待下载完成，出现如下提示：

```shell
The server installed successfully
You can delete this installer file now if you wish
```

失败就多来几次

之后开服都用这个命令：

```shell
java -jar -Xms512M -Xmx1024M <forge_name 去掉 installer> 
```

## 优化

```shell
java -server -Xincgc -Xmx最大内存M -Xms最小内存M -Xss512K -XX:+AggressiveOpts -XX:+UseCompressedOops -XX:+UseCMSCompactAtFullCollection -XX:+UseFastAccessorMethods -XX:ParallelGCThreads=4 -XX:+UseConcMarkSweepGC -XX:CMSFullGCsBeforeCompaction=2 -XX:CMSInitiatingOccupancyFraction=70 -XX:-DisableExplicitGC -XX:TargetSurvivorRatio=90 -jar 服务端核心.jar
```

详见：https://www.mcbbs.net/thread-839828-1-1.html

## 优质 Mod

动物谷：https://www.mcmod.cn/class/1467.html

魔戒：https://www.mcmod.cn/class/2525.html

矿物树：https://www.mcmod.cn/class/4106.html

水产养殖：https://www.mcmod.cn/class/281.html
