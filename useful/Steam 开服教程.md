# Steam 开服教程

Linux 系统：ubuntu 20.04 LTS

支持创建服务器的游戏：https://steamdb.info/search/?a=app&q=server

| 游戏名   | 编号    |
| -------- | ------- |
| Unturned | 1110390 |

## 准备

### 安装依赖

```shell
apt-get install lib32gcc1 -y
```

### 下载 SteamCMD

```shell
cd ~
mkdir SteamCMD
cd SteamCMD

wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz # 下载
tar -xvzf steamcmd_linux.tar.gz # 解压 
```

## 配置

### 启动 SteamCMD

```shell
cd ~/SteamCMD
./steamcmd.sh
```

### 登录 SteamCMD

```shell
login <username> <password> 
# or
login anonymous # 匿名登陆
```

### 设置安装目录

```shell
# force_install_dir <安装目录> 

force_install_dir GameServer/UnturnedServer  # 这是相对路径
```

### 安装游戏

```shell
App_update <game_id> validate
```

### 退出

```shell
quit
```

## 设置自动更新

### 创建脚本文件

```shell
cd ~
mkdir sh
cd sh
```

```shell
vi updateUnturned.sh
```

### 编写脚本

内容如下例：

```sh
~/SteamCMD/steamcmd.sh +login anonymous +force_install_dir GameServer/UnturnedServer +App_update 1110390 validate +quit
```

### 设置自动执行

```shell
corntab -e  # 打开自动执行设置

# * * * * * <执行对象>   用法: *(min) *(hour) *(day) *(month) *(year) 
* * 1 * * ~/sh/updateUnturned.sh
```

## 启动服务器

```shell
cd ~/GameServer/UnturnedServer 

# 用法: ./ServerHelper.sh +InternetServer/<名称> 
./ServerHelper.sh +InternetServer/ApparentServer-UN
```

`save` 保存，`shutdown` 关闭

## 游戏配置

### Unturned

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

