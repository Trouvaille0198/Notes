---
title: "oh-my-zsh"
date: 2022-11-29
author: MelonCholi
draft: false
tags: [Linux]
categories: [Linux]
---

# oh-my-zsh

这里以在 WSL 中安装为例

## 安装

### 安装 zsh

先看下自己有哪一些 shell

```bash
cat /etc/shells
```

如果没有 zsh 需要安装

```bash
sudo apt-get install zsh #Ubuntu Linux记得先升级下 apt-get
sudo yum install zsh #Redhat Linux

chsh -s /bin/zsh #安装完成后设置当前用户使用 zsh 并重启 wsl
```

### 安装 oh-my-zsh

https://github.com/ohmyzsh/ohmyzsh

| Method    | Command                                                      |
| --------- | ------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |

> *Note that any previous `.zshrc` will be renamed to `.zshrc.pre-oh-my-zsh`. After installation, you can move the configuration you want to preserve into the new `.zshrc`.*

此时我们可以根据该项目 readme 切换主题

```bash
vi ~/.zshrc
```

修改

```text
ZSH_THEME="agnoster"
```

保存后

```bash
source ~/.zshrc
```

记得下一款适配的字体哦

## 插件

### autojump

自动跳转插件

```bash
git clone git://github.com/wting/autojump.git
cd autojump
./install.py
```

### zsh-autosuggestions

命令自动补全插件

```bash
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-autosuggestions
```

在 `.zshrc` 上添加这个插件

```bash
plugins=(git
zsh-autosuggestions
autojump
zsh-syntax-highlighting
)
```

### zsh-syntax-highlighting

高亮插件，基于 zsh

```bash
cd ~/.oh-my-zsh/custom/plugins/ 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
```

在 `.zshrc` 上添加这个插件（记住要放在最后一个）

### 集合脚本

```bash
cd ~/.oh-my-zsh/custom/plugins/
git clone git://github.com/wting/autojump.git
cd autojump
./install.py

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

然后加到 `~/.zshrc` 中即可
