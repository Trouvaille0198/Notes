---
title: svn
date: 2023-02-13
draft: false
author: MelonCholi
tags:
  - 快速入门
  - 版本管理
  - CS/工具
categories:
  - 工具
aliases:
  - SVN
date created: 24-04-10 09:59
date modified: 24-04-10 16:56
---

# SVN

Apache Subversion 通常被缩写成 SVN，是一个开放源代码的版本控制系统，Subversion 在 2000 年由 CollabNet Inc 开发，现在发展成为 Apache 软件基金会的一个项目，同样是一个丰富的开发者和用户社区的一部分。

SVN 相对于的 RCS、CVS，采用了分支管理系统，它的设计目标就是取代 CVS。互联网上免费的版本控制服务多基于 Subversion。

## 简介

### SVN 的一些概念

- **repository（源代码库）：**源代码统一存放的地方
- **Checkout（提取）：**当你手上没有源代码的时候，你需要从 repository checkout 一份
- **Commit（提交）：**当你已经修改了代码，你就需要 Commit 到 repository
- **Update (更新)：**当你已经 checkout 了一份源代码， update 一下你就可以和 Repository 上的源代码同步，你手上的代码就会有最新的变更

日常开发过程其实就是这样的（假设你已经 Checkout 并且已经工作了几天）：Update(获得最新的代码) --> 作出自己的修改并调试成功 --> Commit(大家就可以看到你的修改了)

如果两个程序员同时修改了同一个文件呢, SVN 可以合并这两个程序员的改动，实际上 SVN 管理源代码是以行为单位的，就是说两个程序员只要不是修改了同一行程序，SVN 都会自动合并两种修改。如果是同一行，SVN 会提示文件 Conflict, 冲突，需要手动确认。

### 生命周期

#### 创建版本库 create

版本库相当于一个集中的空间，用于存放开发者所有的工作成果。版本库不仅能存放文件，还包括了每次修改的历史，即每个文件的变动历史。

Create 操作是用来创建一个新的版本库。大多数情况下这个操作只会执行一次。当你创建一个新的版本库的时候，你的版本控制系统会让你提供一些信息来标识版本库，例如创建的位置和版本库的名字。

#### 检出 checkout

Checkout 操作是用来从版本库创建一个工作副本。工作副本是开发者私人的工作空间，可以进行内容的修改，然后提交到版本库中。

#### 更新 update

顾名思义，update 操作是用来更新版本库的。这个操作将工作副本与版本库进行同步。由于版本库是由整个团队共用的，当其他人提交了他们的改动之后，你的工作副本就会过期。

让我们假设 Tom 和 Jerry 是一个项目的两个开发者。他们同时从版本库中检出了最新的版本并开始工作。此时，工作副本是与版本库完全同步的。然后，Jerry 很高效的完成了他的工作并提交了更改到版本库中。

此时 Tom 的工作副本就过期了。更新操作将会从版本库中拉取 Jerry 的最新改动并将 Tom 的工作副本进行更新。

#### 执行变更

当检出之后，你就可以做很多操作来执行变更。编辑是最常用的操作。你可以编辑已存在的文件，例如进行文件的添加/删除操作。

你可以添加文件 / 目录。但是这些添加的文件目录不会立刻成为版本库的一部分，而是被添加进待变更列表中，直到执行了 commit 操作后才会成为版本库的一部分。

同样地你可以删除文件 / 目录。删除操作立刻将文件从工作副本中删除掉，但该文件的实际删除只是被添加到了待变更列表中，直到执行了 commit 操作后才会真正删除。

Rename 操作可以更改文件/目录的名字。" 移动 " 操作用来将文件/目录从一处移动到版本库中的另一处。

#### 复查变化 status

当你检出工作副本或者更新工作副本后，你的工作副本就跟版本库完全同步了。但是当你对工作副本进行一些修改之后，你的工作副本会比版本库要新。在 commit 操作之前复查下你的修改是一个很好的习惯。

Status 操作列出了工作副本中所进行的变动。正如我们之前提到的，你对工作副本的任何改动都会成为待变更列表的一部分。Status 操作就是用来查看这个待变更列表。

Status 操作只是提供了一个变动列表，但并不提供变动的详细信息。你可以用 diff 操作来查看这些变动的详细信息。

#### 修复错误 revert

我们来假设你对工作副本做了许多修改，但是现在你不想要这些修改了，这时候 revert 操作将会帮助你。

Revert 操作重置了对工作副本的修改。它可以重置一个或多个文件/目录。当然它也可以重置整个工作副本。在这种情况下，revert 操作将会销毁待变更列表并将工作副本恢复到原始状态。

#### 解决冲突 merge / resolve

合并的时候可能会发生冲突。**Merge 操作会自动处理可以安全合并的东西，其它的会被当做冲突**。例如，"hello.c" 文件在一个分支上被修改，在另一个分支上被删除了。这种情况就需要人为处理。Resolve 操作就是用来帮助用户找出冲突并告诉版本库如何处理这些冲突。

#### 提交更改 commit

Commit 操作是用来将更改从工作副本到版本库。这个操作会修改版本库的内容，其它开发者可以通过更新他们的工作副本来查看这些修改。

在提交之前，你必须将文件/目录添加到待变更列表中。列表中记录了将会被提交的改动。当提交的时候，我们通常会提供一个注释来说明为什么会进行这些改动。这个注释也会成为版本库历史记录的一部分。Commit 是一个原子操作，也就是说要么完全提交成功，要么失败回滚。用户不会看到成功提交一半的情况。

## 启动模式

首先,在服务端进行 SVN 版本库的相关配置

手动新建版本库目录

```shell
mkdir /opt/svn
```

利用 svn 命令创建版本库

```shell
svnadmin create /opt/svn/runoob
```

使用命令 svnserve 启动服务

```py
svnserve -d -r <目录> --listen-port <端口号>
```

- **-r:** 配置方式决定了版本库访问方式。
- **--listen-port:** 指定 SVN 监听端口，不加此参数，SVN 默认监听 3690

由于 -r 配置方式的不一样，SVN 启动就可以有两种不同的访问方式

方式一：-r 直接指定到版本库 (称之为单库 svnserve 方式)

```py
svnserve -d -r /opt/svn/runoob
```

在这种情况下，一个 svnserve 只能为一个版本库工作。

authz 配置文件中对版本库权限的配置应这样写：

```py
[groups]
admin=user1
dev=user2
[/]
@admin=rw
user2=r
```

使用类似这样的 URL：svn://192.168.0.1/　即可访问 runoob 版本库

- 方式二：指定到版本库的上级目录 (称之为多库 svnserve 方式)

```py
svnserve -d -r /opt/svn
```

这种情况，一个 svnserve 可以为多个版本库工作

authz 配置文件中对版本库权限的配置应这样写：

```py
[groups]
admin=user1
dev=user2
[runoob:/]
@admin=rw
user2=r
    
[runoob01:/]
@admin=rw
user2=r
```

如果此时你还用 [/]，则表示所有库的根目录，同理，[/src] 表示所有库的根目录下的 src 目录。

使用类似这样的 URL：svn://192.168.0.1/runoob　即可访问 runoob 版本库。

## SVN 创建版本库

使用 svn 命令创建资源库：

```bash
[runoob@centos6 ~]svnadmin create /opt/svn/runoob01
[runoob@centos6 ~]ll /opt/svn/runoob01/
total 24
drwxr-xr-x 2 root root 4096 2016/08/23 16:31:06 conf
drwxr-sr-x 6 root root 4096 2016/08/23 16:31:06 db
-r--r--r-- 1 root root    2 2016/08/23 16:31:06 format
drwxr-xr-x 2 root root 4096 2016/08/23 16:31:06 hooks
drwxr-xr-x 2 root root 4096 2016/08/23 16:31:06 locks
-rw-r--r-- 1 root root  229 2016/08/23 16:31:06 README.txt
```

进入 /opt/svn/runoob01/conf 目录，修改默认配置文件配置，包括 svnserve.conf、passwd、authz 配置相关用户和权限。

### svn 服务配置文件 svnserve.conf

svn 服务配置文件为版本库目录中的文件 conf/svnserve.conf。该文件仅由一个 [general] 配置段组成。

```toml
[general]
anon-access = none
auth-access = write
password-db = /home/svn/passwd
authz-db = /home/svn/authz
realm = tiku 
```

- **anon-access:** 控制非鉴权用户访问版本库的权限，取值范围为 "write"、"read" 和 "none"。 即 "write" 为可读可写，"read" 为只读，"none" 表示无访问权限，默认值：read。
- **auth-access:** 控制鉴权用户访问版本库的权限。取值范围为 "write"、"read" 和 "none"。 即 "write" 为可读可写，"read" 为只读，"none" 表示无访问权限，默认值：write。
- **authz-db:** 指定权限配置文件名，通过该文件可以实现以路径为基础的访问控制。 除非指定绝对路径，否则文件位置为相对 conf 目录的相对路径，默认值：authz。
- **realm:** 指定版本库的认证域，即在登录时提示的认证域名称。若两个版本库的认证域相同，建议使用相同的用户名口令数据文件。默认值：一个 UUID(Universal Unique IDentifier，全局唯一标示)。

### 用户名口令文件 passwd

用户名口令文件由 svnserve.conf 的配置项 password-db 指定，默认为 conf 目录中的 passwd。该文件仅由一个 [users] 配置段组成。

[users] 配置段的配置行格式如下：

```toml
<用户名> = <口令>
[users]
admin = admin
thinker = 123456
```

### 权限配置文件

权限配置文件由 svnserve.conf 的配置项 authz-db 指定，默认为 conf 目录中的 authz。该配置文件由一个 [groups] 配置段和若干个版本库路径权限段组成。

[groups] 配置段中配置行格式如下：

```toml
<用户组> = <用户列表>
```

版本库路径权限段的段名格式如下：

```toml
[<版本库名>:<路径>] 
[groups]
g_admin = admin,thinker

[admintools:/]
@g_admin = rw
* =

[test:/home/thinker]
thinker = rw
* = r
```

本例是使用 **svnserve -d -r /opt/svn** 以多库 svnserve 方式启动 SVN，所以 URL：**svn://192.168.0.1/runoob01**。

## 检出操作

上一章中，我们创建了版本库 runoob01，URL 为 svn://192.168.0.1/runoob01，svn 用户 user01 有读写权限。

我们就可以通过这个 URL 在客户端对版本库进行检出操作。

```shell
svn checkout http://svn.server.com/svn/project_repo --username=user01
```

以上命令将产生如下结果：

```shell
svn checkout svn://192.168.0.1/runoob01 --username=user01
A    runoob01/trunk
A    runoob01/branches
A    runoob01/tags
Checked out revision 1.
```

检出成功后在当前目录下生成 runoob01 副本目录。查看检出的内容

```shell
ll runoob01/

total 24
drwxr-xr-x 6 root root 4096 Jul 21 19:19 ./
drwxr-xr-x 3 root root 4096 Jul 21 19:10 ../
drwxr-xr-x 2 root root 4096 Jul 21 19:19 branches/
drwxr-xr-x 4 root root 4096 Jul 21 19:19 .svn/
drwxr-xr-x 2 root root 4096 Jul 21 19:19 tags/
drwxr-xr-x 2 root root 4096 Jul 21 19:19 trunk/
```

你想查看更多关于版本库的信息，执行 info 命令。

## 解决冲突

### 版本冲突原因：

假设 A、B 两个用户都在版本号为 100 的时候，更新了 kingtuns.txt 这个文件，A 用户在修改完成之后提交 kingtuns.txt 到服务器， 这个时候提交成功，这个时候 kingtuns.txt 文件的版本号已经变成 101 了。同时 B 用户在版本号为 100 的 kingtuns.txt 文件上作修改， 修改完成之后提交到服务器时，由于不是在当前最新的 101 版本上作的修改，所以导致提交失败。

我们已在本地检出 runoob01 库，下面我们将实现版本冲突的解决方法。

我们发现 HelloWorld.html 文件存在错误，需要修改文件并提交到版本库中。

我们将 HelloWorld.html 的内容修改为 "HelloWorld! https://www.runoob.com/"。

```bash
root@runoob:~/svn/runoob01/trunk# cat HelloWorld.html 
HelloWorld! http://www.runoob.com/
```

用下面的命令查看更改：

```bash
root@runoob:~/svn/runoob01/trunk# svn diff 
Index: HelloWorld.html
===================================================================
--- HelloWorld.html     (revision 5)
+++ HelloWorld.html     (working copy)
@@ -1,2 +1 @@
-HelloWorld! http://www.runoob.com/
+HelloWorld! http://www.runoob.com/!
```

尝试使用下面的命令来提交他的更改：

```bash
root@runoob:~/svn/runoob01/trunk# svn commit -m "change HelloWorld.html first"

Sending        HelloWorld.html
Transmitting file data .svn: E160028: Commit failed (details follow):
svn: E160028: File '/trunk/HelloWorld.html' is out of date
```

这时我发现提交失败了。

因为此时，HelloWorld.html 已经被 user02 修改并提交到了仓库。Subversion 不会允许 user01(本例使用的 svn 账号) 提交更改，因为 user02 已经修改了仓库，所以我们的工作副本已经失效。

为了避免两人的代码被互相覆盖，Subversion 不允许我们进行这样的操作。所以我们在提交更改之前必须先更新工作副本。所以使用 update 命令，如下：

```bash
root@runoob:~/svn/runoob01/trunk# svn update

Updating '.':
C    HelloWorld.html
Updated to revision 6.
Conflict discovered in file 'HelloWorld.html'.
Select: (p) postpone, (df) show diff, (e) edit file, (m) merge,
        (mc) my side of conflict, (tc) their side of conflict,
        (s) show all options: mc
Resolved conflicted state of 'HelloWorld.html'
Summary of conflicts:
  Text conflicts: 0 remaining (and 1 already resolved)
```

这边输入 "mc",以本地的文件为主。你也可以使用其选项对冲突的文件进行不同的操作。

默认是更新到最新的版本，我们也可以指定更新到哪个版本

```bash
svn update -r6
```

此时工作副本是和仓库已经同步，可以安全地提交更改了

```bash
root@runoob:~/svn/runoob01/trunk# svn commit -m "change HelloWorld.html second"

Sending        HelloWorld.html
Transmitting file data .
Committed revision 7.
```

## 提交操作

在上一章中，我们检出了版本库 runoob01，对应的目录放在/home/user01/runoob01 中，下面我们针对这个库进行版本控制。

------

我们在库本版中需要增加一个 readme 的说明文件。

```bash
root@runoob:~/svn/runoob01/trunk# cat readme 
this is SVN tutorial.
```

查看工作副本中的状态。

```bash
root@runoob:~/svn/runoob01/trunk# svn status
?       readme
```

此时 readme 的状态为？，说明它还未加到版本控制中。

将文件 readme 加到版本控制，等待提交到版本库。

```bash
root@runoob:~/svn/runoob01/trunk# svn add readme 
A         readme
```

查看工作副本中的状态

```bash
root@runoob:~/svn/runoob01/trunk# svn status     
A       readme
```

此时 readme 的状态为 A,它意味着这个文件已经被成功地添加到了版本控制中。

为了把 readme 存储到版本库中，使用 commit -m 加上注释信息来提交。

如果你忽略了 -m 选项， SVN 会打开一个可以输入多行的文本编辑器来让你输入提交信息。

```bash
root@runoob:~/svn/runoob01/trunk# svn commit -m "SVN readme."
Adding         readme
Transmitting file data .
Committed revision 8.
svn commit -m "SVN readme."
```

现在 readme 被成功地添加到了版本库中，并且修订版本号自动增加了 1。

## 版本回退

当我们想放弃对文件的修改，可以使用 **SVN revert** 命令。

**svn revert 操作将撤销任何文件或目录里的局部更改。**

我们对文件 readme 进行修改,查看文件状态。

```bash
root@runoob:~/svn/runoob01/trunk# svn status
M       readme
```

这时我们发现修改错误，要撤销修改，通过 svn revert 文件 readme 回归到未修改状态。

```bash
root@runoob:~/svn/runoob01/trunk# svn revert readme 
Reverted 'readme'
```

再查看状态。

```bash
root@runoob:~/svn/runoob01/trunk# svn status 
root@runoob:~/svn/runoob01/trunk# 
```

进行 revert 操作之后，readme 文件恢复了原始的状态。 revert 操作不单单可以使单个文件恢复原状， 而且可以使整个目录恢复原状。恢复目录用 -R 命令，如下。

```bash
svn revert -R trunk
```

但是，假如我们想恢复一个已经提交的版本怎么办。

为了消除一个旧版本，我们必须撤销旧版本里的所有更改然后提交一个新版本。这种操作叫做 reverse merge。

首先，找到仓库的当前版本，现在是版本 22，我们要撤销回之前的版本，比如版本 21。

```bash
svn merge -r 22:21 readme 
```

## 查看历史信息

通过 svn 命令可以根据时间或修订号去除过去的版本，或者某一版本所做的具体的修改。以下四个命令可以用来查看 svn 的历史：

- **svn log:** 用来展示 svn 的版本作者、日期、路径等等。
- **svn diff:** 用来显示特定修改的行级详细信息。
- **svn cat:** 取得在特定版本的某文件显示在当前屏幕。
- **svn list:** 显示一个目录或某一版本存在的文件。

### svn log

可以显示所有的信息，如果只希望查看特定的某两个版本之间的信息，可以使用：

```bash
root@runoob:~/svn/runoob01/trunk# svn log -r 6:8

------------------------------------------------------------------------
r6 | user02 | 2016-11-07 02:01:26 +0800 (Mon, 07 Nov 2016) | 1 line

change HelloWorld.html first.
------------------------------------------------------------------------
r7 | user01 | 2016-11-07 02:23:26 +0800 (Mon, 07 Nov 2016) | 1 line

change HelloWorld.html second
------------------------------------------------------------------------
r8 | user01 | 2016-11-07 02:53:13 +0800 (Mon, 07 Nov 2016) | 1 line

SVN readme.
------------------------------------------------------------------------
```

如果只想查看某一个文件的版本修改信息，可以使用 **svn log** 文件路径。

```bash
root@runoob:~/svn/runoob01# svn log trunk/HelloWorld.html 

------------------------------------------------------------------------
r7 | user01 | 2016-11-07 02:23:26 +0800 (Mon, 07 Nov 2016) | 1 line

change HelloWorld.html second
------------------------------------------------------------------------
r6 | user02 | 2016-11-07 02:01:26 +0800 (Mon, 07 Nov 2016) | 1 line

change HelloWorld.html first.
------------------------------------------------------------------------
r5 | user01 | 2016-11-07 01:50:03 +0800 (Mon, 07 Nov 2016) | 1 line


------------------------------------------------------------------------
r4 | user01 | 2016-11-07 01:45:43 +0800 (Mon, 07 Nov 2016) | 1 line

Add function to accept input and to display array contents
------------------------------------------------------------------------
r3 | user01 | 2016-11-07 01:42:35 +0800 (Mon, 07 Nov 2016) | 1 line


------------------------------------------------------------------------
r2 | user01 | 2016-08-23 17:29:02 +0800 (Tue, 23 Aug 2016) | 1 line

first file
------------------------------------------------------------------------
```

如果希望得到目录的信息要加 **-v**。

如果希望显示限定 N 条记录的目录信息，使用 **svn log -l N -v**。

```bash
root@runoob:~/svn/runoob01/trunk# svn log -l 5 -v 

------------------------------------------------------------------------
r6 | user02 | 2016-11-07 02:01:26 +0800 (Mon, 07 Nov 2016) | 1 line
Changed paths:
   M /trunk/HelloWorld.html

change HelloWorld.html first.
------------------------------------------------------------------------
r5 | user01 | 2016-11-07 01:50:03 +0800 (Mon, 07 Nov 2016) | 1 line
Changed paths:
   M /trunk/HelloWorld.html


------------------------------------------------------------------------
r4 | user01 | 2016-11-07 01:45:43 +0800 (Mon, 07 Nov 2016) | 1 line
Changed paths:
   M /trunk/HelloWorld.html

Add function to accept input and to display array contents
------------------------------------------------------------------------
r3 | user01 | 2016-11-07 01:42:35 +0800 (Mon, 07 Nov 2016) | 1 line
Changed paths:
   A /trunk/HelloWorld.html (from /trunk/helloworld.html:2)
   D /trunk/helloworld.html


------------------------------------------------------------------------
r2 | user01 | 2016-08-23 17:29:02 +0800 (Tue, 23 Aug 2016) | 1 line
Changed paths:
   A /trunk/helloworld.html

first file
------------------------------------------------------------------------
```

### svn diff

用来检查历史修改的详情。

- 检查本地修改
- 比较工作拷贝与版本库
- 比较版本库与版本库

**如果用 svn diff，不带任何参数，它将会比较你的工作文件与缓存在 .svn 的 " 原始 " 拷贝。**

```bash
root@runoob:~/svn/runoob01/trunk# svn diff

Index: rules.txt
===================================================================
--- rules.txt (revision 3)
+++ rules.txt (working copy)
@@ -1,4 +1,5 @@
Be kind to others
Freedom = Responsibility
Everything in moderation
-Chew with your mouth open
```

**比较工作拷贝和版本库**

比较你的工作拷贝和版本库中版本号为 3 的文件 rule.txt。

```bash
svn diff -r 3 rule.txt
```

**比较版本库与版本库**

通过 -r (revision) 传递两个通过冒号分开的版本号，这两个版本会进行比较。

比较 svn 工作版本中版本号 2 和 3 的这个文件的变化。

```bash
svn diff -r 2:3 rule.txt
```

### svn cat

如果只是希望检查一个过去版本，不希望查看他们的区别，可使用 svn cat

```bash
svn cat -r 版本号 rule.txt
```

这个命令会显示在该版本号下的该文件内容

### svn list

**svn list** 可以在不下载文件到本地目录的情况下来察看目录中的文件：

```bash
$ svn list http://192.168.0.1/runoob01
README
branches/
clients/
tags/
```

## 分支

Branch 选项会给开发者创建出另外一条线路。当有人希望开发进程分开成两条不同的线路时，这个选项会非常有用。

比如项目 demo 下有两个小组，svn 下有一个 trunk 版。

由于客户需求突然变化，导致项目需要做较大改动，此时项目组决定由小组 1 继续完成原来正进行到一半的工作（某个模块），小组 2 进行新需求的开发。

那么此时，我们就可以为小组 2 建立一个分支，分支其实就是 trunk 版（主干线）的一个 copy 版，不过分支也是具有版本控制功能的，而且是和主干线相互独立的，当然，到最后我们可以通过（合并）功能，将分支合并到 trunk 上来，从而最后合并为一个项目。

我们在本地副本中创建一个 **my_branch** 分支。

```bash
root@runoob:~/svn/runoob01# ls
branches  tags  trunk

root@runoob:~/svn/runoob01# svn copy trunk/ branches/my_branch
A         branches/my_branch
root@runoob:~/svn/runoob01# 
```

查看状态：

```bash
root@runoob:~/svn/runoob01# svn status

A  +    branches/my_branch
A  +    branches/my_branch/HelloWorld.html
A  +    branches/my_branch/readme
```

提交新增的分支到版本库。

```bash
root@runoob:~/svn/runoob01# svn commit -m "add my_branch" 
Adding         branches/my_branch
Replacing      branches/my_branch/HelloWorld.html
Adding         branches/my_branch/readme

Committed revision 9.
```

接着我们就到 my_branch 分支进行开发，**切换**到分支路径并创建 index.html 文件。

```bash
root@runoob:~/svn/runoob01# cd branches/my_branch/

root@runoob:~/svn/runoob01/branches/my_branch# ls
HelloWorld.html  index.html  readme
```

将 index.html 加入版本控制，并提交到版本库中。

```bash
root@runoob:~/svn/runoob01/branches/my_branch# svn status
?       index.html
root@runoob:~/svn/runoob01/branches/my_branch# svn add index.html 
A         index.html
root@runoob:~/svn/runoob01/branches/my_branch# svn commit -m "add index.html"
Adding         index.html
Transmitting file data .
Committed revision 10.
```

切换到 trunk，执行 svn update，然后将 my_branch 分支合并到 trunk 中。

```bash
root@runoob:~/svn/runoob01/trunk# svn merge ../branches/my_branch/

--- Merging r10 into '.':
A    index.html
--- Recording mergeinfo for merge of r10 into '.':
 G   .
```

此时查看目录，可以看到 trunk 中已经多了 my_branch 分支创建的 index.html 文件。

```bash
root@runoob:~/svn/runoob01/trunk# ll

total 16
drwxr-xr-x 2 root root 4096 Nov  7 03:52 ./
drwxr-xr-x 6 root root 4096 Jul 21 19:19 ../
-rw-r--r-- 1 root root   36 Nov  7 02:23 HelloWorld.html
-rw-r--r-- 1 root root    0 Nov  7 03:52 index.html
-rw-r--r-- 1 root root   22 Nov  7 03:06 readme
```

将合并好的 trunk 提交到版本库中。

```bash
root@runoob:~/svn/runoob01/trunk# svn commit -m "add index.html"

Adding         index.html
Transmitting file data .
Committed revision 11.
```

## 标签（tag）

------

版本管理系统支持 tag 选项，通过使用 tag 的概念，我们可以给某一个具体版本的代码一个更加有意义的名字。

Tags 即标签主要用于项目开发中的里程碑，比如开发到一定阶段可以单独一个版本作为发布等，它往往代表一个可以固定的完整的版本，这跟 VSS 中的 Tag 大致相同。

我们在本地工作副本创建一个 tag。

```bash
root@runoob:~/svn/runoob01# svn copy trunk/ tags/v1.0
A         tags/v1.0
```

上面的代码成功完成，新的目录将会被创建在 tags 目录下。

```bash
root@runoob:~/svn/runoob01# ls tags/
v1.0
root@runoob:~/svn/runoob01# ls tags/v1.0/
HelloWorld.html  readme
```

查看状态。

```bash
root@runoob:~/svn/runoob01# svn status
A  +    tags/v1.0
```

提交 tag 内容。

```bash
root@runoob:~/svn/runoob01# svn commit -m "tags v1.0" 
Adding         tags/v1.0
Transmitting file data ..
Committed revision 14.
```
