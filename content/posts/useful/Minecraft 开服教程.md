---
title: "Minecraft 开服教程"
date: 2022-06-26
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
---

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

## 物品分类思路

搭配储物抽屉 mod

### 矿石

金、铁、红石：压缩

钻石、青金石、煤、木炭：1*1

留空

### 食物

马铃薯（1\*1）、猪排、牛排、鸡肉、兔肉、羊肉、鲑鱼、鳕鱼：生熟 1*2

### 种子

南瓜、苹果、蘑菇煲、河豚、蛋糕：2*2

西瓜片、小麦、干海带、面包、胡萝卜、甜菜根

### 木材

橡木、白桦、深色橡木、云杉、丛林、金合欢的原木：1*1

橡木、白桦、深色橡木、云杉、丛林、金合欢的木板：1*1

橡木、白桦、深色橡木、云杉、丛林、金合欢的树苗：2*2

橡木、白桦、深色橡木、云杉、丛林、金合欢的楼梯：2*2

橡木、白桦、深色橡木、云杉、丛林、金合欢的台阶：2*2

（不重要）橡木、白桦、深色橡木、云杉、丛林、金合欢的原木的栅栏:2*2

（不重要）橡木、白桦、深色橡木、云杉、丛林、金合欢的原木的栅栏门：2*2

### 合成材料

木棒、皮革、海草：1*2

燃料 15、幻翼膜、恶魂泪：2*2

萤石粉、烈焰棒、末影珍珠：1*1

各种其他植物（包括染料植物）：留出 9 个 2*2

腐肉：1*1

骨头：压缩

### 多色物品

羊毛 15、混凝土 15、玻璃、玻璃板 15：2*2

### 武器装备

钓鱼竿、打火石、剪刀

锹、镐、斧、锄

剑、弓

箭

盔、甲、腿、靴

### 工具

火把

梯子、工作台、熔炉、箱子、展示框、活塞、铁轨、充能铁轨、命名牌、拴绳、鞍等等：预留 9 个 2*2

### 建筑材料

部分建筑材料归类到多色物品中

玻璃、石英块：1*2

（不重要）原石墙

### 其他方块

书架、灵魂沙、菌丝、末地石、TNT、冰：2*2

（不重要）泥土、圆石、花岗岩、闪长岩、安山岩：1*2

沙子、沙砾、砂土：1*1

### 载具

仪表盘

### 不做分类的物品

床、铁栏杆、告示牌、压力板、按钮、门、船
