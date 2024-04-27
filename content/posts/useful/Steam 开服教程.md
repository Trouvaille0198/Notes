---
title: "Steam 开服教程"
date: 2022-03-25
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
date created: 24-04-10 09:58
date modified: 24-04-25 18:39
---

# Steam 开服教程

> 官房教程 https://developer.valvesoftware.com/wiki/SteamCMD:zh-c

Linux 系统：ubuntu 20.04 LTS

支持创建服务器的游戏：https://steamdb.info/search/?a=app&q=server

| 游戏名   | 编号    |
| -------- | ------- |
| Palworld | 2394010 |
| Unturned | 1110390 |
| V Rising | 1604030 |
| 英灵神殿 | 892970  |

注意事项

- 关闭 Linux 防火墙
- 在控制台开启相应端口 n 与 n+1

## 准备

### 下载 SteamCMD

另一种方法是直接用官网的安装包

```shell
sudo apt install lib32gcc-s1

cd ~
mkdir SteamCMD
cd SteamCMD

wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz # 下载
tar -xvzf steamcmd_linux.tar.gz # 解压 
```

## 配置

### 启动 SteamCMD

```shell
steamcmd
```

手动安装的话

```sh
cd ~/SteamCMD
./steamcmd.sh
```

> 出现 `steamservice.so: cannot open shared object file: No such file or directory` 错误不要紧

### 设置安装目录

注意：在 login 前执行

```shell
force_install_dir ./GameServer/<name> # 这里是相对路径
```

### 登录 SteamCMD

```shell
login <username> <password> 
# or
login anonymous # 匿名登陆
```

### 安装游戏

```shell
App_update <game_id> validate
```

### 退出

```shell
quit
```

### 删除游戏

在终端运行

```sh
steamcmd +app_uninstall <game_id> +quit
```

## 设置自动更新

### 编写脚本

```sh
cd ~/SteamCMD
./steamcmd.sh +force_install_dir ./GameServer/<game_dir> +login anonymous  +App_update <game_id> validate +quit
```

### 设置自动执行

```shell
crontab -e  # 打开自动执行设置

# * * * * * <执行对象>   用法: *(min) *(hour) *(day) *(month) *(year) 
* * 1 * * sh ~/SteamCMD/update.sh
```

## 启动服务器

**各种游戏启动服务器的方法不同，可以查阅相应的官方文档**

```shell
cd ~/SteamCMD/GameServer/<name>

# 用法: ./ServerHelper.sh +InternetServer/<名称> 
./ServerHelper.sh +InternetServer/ApparentServer-UN
```

`save` 保存，`shutdown` 关闭

## 游戏配置

### Unturned

> App_update 892970 validate

配置文件为 `Servers/ApparentServer-UN/Server/Commands.dat`

```txt
Name <服务器名称>  #设置服务器名称
Port <端口号>  #设置服务器端口
Password <密码>  #设置服务器密码
Maxplayers <最大人数>  #设置服务器最大人数  
Map <地图（英文名）>  #设置服务器地图
Mode Easy | Normal | Hard  #设置服务器难度（简单 | 普通 | 困难）
Perspective first-person | third-person | both  #设置服务器视角（第一人称 | 第三人称 | 全部）
pve|pvp  #设置服务器模式（pve 关闭队友伤害， pvp 打开队友伤害）
Welcome <欢迎语>  #设置服务器欢迎语
cheats disable | on  #设置服务器作弊（关闭 | 打开）
loadout <ID/ID/ID...>  #设置出生装备
Owner <ID>  #服务器所有者
```

### PalWorld

> App_update 2394010 validate

官方文档：https://tech.palworldgame.com/dedicated-server-guide

运行

```sh
cd ~/SteamCMD/GameServer/Pal
./PalServer.sh
```

如果报了以下错误：

```py
.steam/sdk64/steamclient.so: cannot open shared object file: No such file or directory
```

To resolve this issue

```sh
mkdir -p ~/.steam/sdk64/
~/SteamCMD/steamcmd.sh +login anonymous +app_update 1007 +quit
cp ~/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so ~/.steam/sdk64/
```

> If this procedure is performed after the server is operational, the game will start from character re-creation. We recommend that you do not perform this on servers that are already in play.

Error is displayed once at startup. if [.steam/sdk64/steamclient.so OK. (First tried local 'steamclient.so')] is displayed, there is no problem.
