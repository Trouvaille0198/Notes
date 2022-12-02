---
title: "autojump"
date: 2022-11-29
author: MelonCholi
draft: false
tags: [Linux]
categories: [Linux]
---

# autojump

autojump 是通过记录进入过的目录到数据库来实现**快速跳转**，所以必须是曾经进入过的目录才能跳转

## 安装

```php
git clone git://github.com/joelthelion/autojump.git
```

```bash
cd autojump
./install.py or ./uninstall.py
```

由于Linux 下 Shell 启动会自动读取 ~/.bashrc 文件，所以将下面一行添加到该文件中（注意修改一下路径）

```ruby
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh
```

然后，运行`source ~/.bashrc`即可。

## 用法

只有打开过的目录 autojump 才会记录，所以使用时间越长，autojump 越智能。

可以使用 `autojump` 命令，或者使用短命令 `j`.

### 跳转到指定目录 j

```bash
j directoryName
```

如果不知道目录全名，输入一部分，按 Tab 键就好，输错了也没关系，可以自动识别，非常强大。

```bash
# j csm
/data/www/xxx/cms
```

Tab 键效果

```tsx
vagrant@homestead:~$ pwd
/home/vagrant
vagrant@homestead:~$ j --stat
10.0:   /etc/nginx/conf.d
20.0:   /home/vagrant/www/xxx/doc_api
34.6:   /home/vagrant/www/xxx
40.0:   /var/log/nginx
Total key weight: 104. Number of stored dirs: 4
vagrant@homestead:~$ j n__ (Tab 键自动添加了下划线)
/var/log/nginx
vagrant@homestead:/var/log/nginx$
```

### 使用系统工具打开目录 jo 

系统工具如 Mac Finder, Windows Explorer, GNOME

类似 Mac OS terminal 下的 `open` 命令，但 `open` 命令需要指定路径（Mac 中还算实用，Ubuntu 下不好用）

```undefined
jo directoryName
```

### 查看权重 `j --stat`

```jsx
$ j --stat
10.0:   /etc/nginx/conf.d
10.0:   /home/vagrant/www/caijing/doc_api
10.0:   /var/log/nginx
30.0:   /home/vagrant/www/caijing
Total key weight: 59. Number of stored dirs: 4
```

权重越高，说明目录使用的越频繁。

感觉 Mac 中的显示效果更好，还可以自己去调整权重值。

```tsx
$ j --stat
10.0:   /Users/xxx/xxx/xxxx/xxxx/xxxx/vendor
22.4:   /Users/xxx/xxx/xxxx/xxxx/xxxx/log

32:     total weight
2:       number of entries
10.00:   current directory weight

data:    /Users/xxx/Library/autojump/autojump.txt
```

