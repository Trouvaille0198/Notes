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
sudo apt-get install zsh # Ubuntu Linux记得先升级下 apt-get
sudo yum install zsh # Redhat Linux

chsh -s /bin/zsh # 安装完成后设置当前用户使用 zsh 并重启 wsl
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

开启方式

```sh
plugins=(
   git
   extract
   z
   zsh-syntax-highlighting
   zsh-autosuggestions
 )
```

### 第三方插件

#### autojump

自动跳转插件

```bash
git clone git://github.com/wting/autojump.git
cd autojump
./install.py
```

#### zsh-autosuggestions

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

#### zsh-syntax-highlighting

高亮插件，基于 zsh

```bash
cd ~/.oh-my-zsh/custom/plugins/ 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
```

在 `.zshrc` 上添加这个插件（记住要放在最后一个）

#### 集合脚本

```bash
cd ~/.oh-my-zsh/custom/plugins/
git clone git://github.com/wting/autojump.git
cd autojump
./install.py

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

然后加到 `~/.zshrc` 中即可

#### git-open

https://github.com/paulirish/git-open

提供一个 git-open 命令，在浏览器中打开当前所在 git 项目的远程仓库地址。

```bash
git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open
```

用法

```sh
git open [remote-name] [branch-name]
    # Open the page for this branch on the repo website

git open --commit
git open -c
    # Open the current commit in the repo website

git open --issue
git open -i
    # If this branch is named like issue/#123, this will open the corresponding
    # issue in the repo website

git open --print
git open -p
    # Only print the url at the terminal, but don't open it
```

### 内置插件

#### git

定义了有关 git 的 alias。常用的有

- gaa = git add --all
- gcmsg = git commit -m
- ga = git add
- gst = git status
- gp = git push

####  tmux

定义了有关 [tmux](https://www.zhihu.com/search?q=tmux&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A"617215298"}) 的 alias。常用的有

- tl = tmux list-sessions
- tkss = tmux kill-session -t
- ta = tmux attach -t
- ts = tmux new-session -s

#### extract

提供一个 extract 命令，以及它的别名 x。功能是**一键解压**

你知道 tar 的四种写法吗？我也不知道，所以我装了这个。从今以后 tar, gz, zip, rar 全部使用 extract 命令解压，再也不用天天查 cheatsheet 啦

#### rand-quote

提供一条 quote 命令，显示随机名言。和 fortune 的作用差不多，但是我感觉 fortune 上面大多是冷笑话，还是 quote 的内容比较有意思。

当然这种东西很少有人会主动去按的。所以你可以在你的 zshrc 里面的最后一行加上 quote，实现每次打开 shell 显示一条名言的效果～

再进一步，安装一个 [cowsay](https://www.zhihu.com/search?q=cowsay&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A"617215298"})，把 quote | cowsay 放到 [zshrc](https://www.zhihu.com/search?q=zshrc&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A"617215298"}) 的最后一行。于是每次打开终端你就可以看到一头牛对你说：

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-adfbc44c98d3a6b1137efa8a7abfda6c_1440w.webp)

#### themes

提供一条 `theme` 命令，用来随时手动切换主题。在想要尝试各种主题的时候很实用，不需要一直改 zshrc 然后重载。

#### gitignore

提供一条 gi 命令，用来查询 gitignore 模板。比如你新建了一个 python 项目，就可以用

```bash
 gi python > .gitignore 
```

来生成一份 gitignore 文件。

#### cp

提供一个 cpv 命令，这个命令使用 rsync 实现带进度条的复制功能。

感觉不是很对劲，我反正是没用

#### z

提供一个 z 命令，在常用目录之间跳转。类似 [autojump](https://www.zhihu.com/search?q=autojump&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A"617215298"})，但是不需要额外安装软件。

#### vi-mode

vim 输入模式

#### per-directory-history

开启之后在一个目录下只能查询到这个目录下的历史命令。按 `ctrl+g` 开启/关闭。

对我来说很实用，但是不一定所有人都喜欢，可以考虑一下自己是否真的需要。

#### command-not-found

当你输入一条不存在的命令时，会自动查询这条命令可以如何获得。

#### safe-paste

当你往 zsh 粘贴脚本时，它**不会被立刻运行**

#### colored-man-pages

给你带颜色的 man 命令。

#### sudo

apt 忘了加 sudo？开启这个插件，双击 Esc，zsh 会把上一条命令加上 sudo 给你。

#### history-substring-search

一般人会在 zsh 中绑定 history-search-backward 与 histor-search-forward 两个功能。

```sh
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
```

这样子，就可以在输入一个命令，比如 git 之后，按 Ctrl-P 与 Ctrl-N 在以 git 为前缀的历史记录中浏览，非常方便。

但是这个做法有一个问题，就是这个功能只考虑输入的第一个单词。也就是说，如果之前输入了 git status, git commit, git push 等等命令，那么我输入 "git s" 再 Ctrl-P，并不会锁定到 "git status", 而是会在所有以 git 开头的历史命令中循环。

这个插件的功能就是实现了一对更好用的 history-search-backward 与 histor-search-forward ，解决了上面所说的问题。开启之后，需要绑定按键：

```sh
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
```

这样子就可以以自己输入的所有内容为前缀，进行历史查找了。

## powerlevel10k

这是一个巨牛逼的第三方主题

### 安装

```sh
https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

连不上的话用这个：

```sh
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```

Set `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`.
