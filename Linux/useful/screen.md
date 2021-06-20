# 概述

Screen是一款由GNU计划开发的用于命令行终端切换的自由软件。用户可以通过该软件同时连接多个本地或远程的命令行会话，并在其间自由切换。GNU Screen可以看作是窗口管理器的命令行界面版本。它提供了统一的管理多个会话的界面和相应的功能。

在Screen环境下，所有的会话都独立的运行，并拥有各自的编号、输入、输出和窗口缓存。用户可以通过快捷键在不同的窗口下切换，并可以自由的重定向各个窗口的输入和输出。

# 语法

screen \[-AmRvx -ls -wipe] \[-d <作业名称>] \[-h <行数>] \[-r <作业名称>] \[-s ] \[-S <作业名称>]

## 参数说明

-A 　                       将所有的视窗都调整为目前终端机的大小。
-d <作业名称> 　  将指定的 screen 作业离线。
-h <行数>         　  指定视窗的缓冲区行数。
-m 　                      即使目前已在作业中的 screen 作业，仍强制建立新的 screen 作业。
-r <作业名称> 　   恢复离线的screen作业。
-R 　                       先试图恢复离线的作业。若找不到离线的作业，即建立新的screen作业。
-s 　                       指定建立新视窗时，所要执行的shell。
-S <作业名称> 　  指定screen作业的名称。
-v 　                       显示版本信息。
-x 　                       恢复之前离线的screen作业。
-ls 或 --list 　         显示目前所有的screen作业。
-wipe 　                 检查目前所有的screen作业，并删除已经无法使用的screen作业。

## 常用命令

`screen -S yourname`                 新建一个叫 yourname 的 session
`screen -ls`                                  列出当前所有的 session
`screen -r yourname`                  回到 yourname 这个 session
`screen -d yourname`                  远程 detach 某个 session
`screen -d -r yourname`            结束当前 session 并回到 yourname 这个 session

