# 配置 Windows Terminal

##  设置

### 主题

放在 `schemes` 中

https://windowsterminalthemes.dev/

```json
{
    "name": "Afterglow",
    "black": "#151515",
    "red": "#ac4142",
    "green": "#7e8e50",
    "yellow": "#e5b567",
    "blue": "#6c99bb",
    "purple": "#9f4e85",
    "cyan": "#7dd6cf",
    "white": "#d0d0d0",
    "brightBlack": "#505050",
    "brightRed": "#ac4142",
    "brightGreen": "#7e8e50",
    "brightYellow": "#e5b567",
    "brightBlue": "#6c99bb",
    "brightPurple": "#9f4e85",
    "brightCyan": "#7dd6cf",
    "brightWhite": "#f5f5f5",
    "background": "#212121",
    "foreground": "#d0d0d0",
    "selectionBackground": "#303030",
    "cursorColor": "#d0d0d0"
},
```

## 其他配置

放在 `defaults` 中

```json
"acrylicOpacity": 0.85, //背景透明度(0-1)
"useAcrylic": true, // 启用毛玻璃
//"backgroundImage": "D:/User/chuchur/OneDrive/图片/stack.jpg", //背景图片
//"backgroundImageOpacity": 0.1, //图片透明度（0-1）
//"experimental.retroTerminalEffect": true, //复古的CRT 效果
//"backgroundImageStretchMode": "uniformToFill", //填充模式
//"icon": "ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png", //图标
"fontFace": "MesloLGM NF",
//"fontSize": 12, //文字大小
//"fontWeight": "normal", //文字宽度，可设置加粗
"colorScheme": "Afterglow", //主题名字
//"cursorColor": "#FFFFFF", //光标颜色
"cursorShape": "bar", //光标形状
//"cursorHeight": 10,
"startingDirectory": "D://Repo", //起始目录
//"antialiasingMode": "cleartype" //消除文字锯齿
"showTabsInTitlebar": false
```

## 美化

### 字体

#### Nerd Fonts

下载：https://www.nerdfonts.com/font-downloads

修改配置

```json
"fontFace": "DejaVuSansMono Nerd Font" 
// Cousine Nerd Font
```

#### Meslo LGM NF

下载：https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip

### oh-my-posh

官网：https://ohmyposh.dev/docs/

#### 安装

- 第一条命令（绕过 power shell 执行策略，使其可以执行脚本文件<后面会用到>）

```text
Set-ExecutionPolicy Bypass
```

- 第二条命令（oh-my-posh 提供主题）

```powershell
Install-Module oh-my-posh -Scope CurrentUser
```

- 第三条命令（posh-git 将 git 信息添加到提示中）

```text
Install-Module posh-git -Scope CurrentUser
```

#### PowerShell 配置

- 第一条（启动编辑 power shell 配置文件的引擎）

```text
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
```

- 第二条（使用记事本打开配置文件）

```text
notepad $PROFILE
```

**2.在打开的记事本中写入如下内容**（脚本文件）**，并保存**

```text
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme  blueish
# Set-PoshPrompt -Theme  marcduiker
# Set-PoshPrompt -Theme  remk
# Set-PoshPrompt -Theme  powerlevel10k_rainbow
```

- 第一条命令表示导入 posh-git
- 第二条命令表示导入 oh-my-posh
- 第三条命令表示设置主题为 JanDeDobbeleer

**配置完后**，每次打开 Windows Terminal 中的 Power shell 都会执行脚本文件中的三条命令。

#### 查看操作

预览所有主题

```shell
Get-PoshThemes
```

### 在 vscode 中配置 power shell 样式

设置中查找 `Integrated:Font Family`

输入

```
Cousine Nerd Font
DejaVuSansMono Nerd Font
MesloLGM NF
```

## 添加 SSH

```json
{
    "guid": "{4cbd411b-c4a8-d899-abb1-e2f69c6be01c}",
    "hidden": false,
    "name": "CentOS",
    "commandline": "ssh u@ip"
 }
```

