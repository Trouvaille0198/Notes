---
title: "Git 教程"
date: 2021-12-09
draft: false
author: "MelonCholi"
tags: [Git, 快速入门]
categories: [工具]
---

# Git

```shell
git config --global user.email "suntianye@gocyber.world"
```

## 安装

### 设置名字、邮箱

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

### 创建版本库（**repository**）

- 创建空目录

```shell
$ mkdir <repo name>
$ cd <repo name>
$ pwd
```

`pwd`命令用于显示当前目录

- 把这个目录变成 Git 可以管理的仓库

```shell
$ git init
```

## 文件操作

### 添加文件

把文件往 Git 版本库里添加的时候，是分两步执行的：

第一步是用 `git add` 把文件添加进去，实际上就是把文件修改添加到暂存区；

第二步是用 `git commit` 提交更改，实际上就是把暂存区的所有内容提交到当前分支。

1. 将工作区文件添加到暂存区

```shell
$ git add <filename>
```

2. 将暂存区文件添加到本地仓库

```shell
$ git commit -m <message>
```

### 查看信息

1. 查看仓库当前状态

```shell
$ git status
```

2. 查看文件修改

```shell
$ git diff <filename>
```

查看工作区和版本库里文件的区别

```shell
$ git diff HEAD -- <filename> 
```

3. 查看文件内容

```shell
$ cat <filename>
```

4. 查看版本库状态

```shell
$ git log
$ git log --pretty=oneline //简单显示
```

### 修改文件

1. 退回上一版本

```shell
$ git reset --hard HEAD^
```

上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上 100 个版本写 100 个^比较容易数不过来，所以写成`HEAD~100`

2. 退回某一版本

```shell
$ git reset --hard <id>
```

3. 显示所有历史命令

```shell
$ git reflog
```

4. 清除工作区的修改

```shell
$ git checkout -- <filename>
```

实质：用版本库里的版本替换工作区的版本

5. 清除暂存区的修改

```shell
$ git reset HEAD <filename>
```

6. 从工作区中删除文件

```shell7. 
$ rm <filename>
```

7. 从版本库中删除文件

```shell
$ git rm <filename>
```

别忘了`git commit`

## 远程仓库操作

### 创建SSH Key

```shell
$ ssh-keygen -t rsa -C "youremail@example.com"
```

可以在用户主目录里找到`.ssh`目录，里面有`id_rsa`和`id_rsa.pub`两个文件，这两个就是 SSH Key 的秘钥对，`id_rsa`是私钥，不能泄露出去，`id_rsa.pub`是公钥，可以放心地告诉任何人

### 关联远程仓库

```shell
$ git remote add origin git@github.com:GitHub-name/Repo-name.git
```

### 初次推送

```shell
$ git push -u origin master
```

### 将本地库推送至远程库

```shell
$ git push origin master
```

若要强制推送覆盖远程文件

```shell
$ git push -f origin master
```

### 将远程库克隆至本地库

```shell
$ git clone git@github.com:GitHub-name/Repo-name.git
```

## 分支操作

分支共有 5 种类型

1. master/main，最终发布版本，整个项目中有且只有一个
2. develop，项目的开发分支，原则上项目中有且只有一个
3. feature，功能分支，用于开发一个新的功能
4. release，预发布版本，介于 develop 和 master 之间的一个版本，主要用于测试
5. hotfix，修复补丁，用于修复 master 上的 bug，直接作用于 master

### 创建并切换到新的分支

```shell
$ git switch -c <name>
```

### 创建新的分支

```shell
$ git branch <name>
```

### 切换到已有的分支

```shell
$ git switch <name>
```

### 查看分支

```shell
$ git branch
```

### 合并某分支到当前分支

```shell
$ git merge <name>
```

### 删除分支

```shell
$ git branch -d <name>
```

若要强行删除

```shell
$ git branch -D <name>
```

### 查看分支的合并情况

```shell
$ git log --graph --pretty=oneline --abbrev-commit
```

### 分支策略

在实际开发中，我们应该按照几个基本原则进行分支管理：

首先，master 分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；

那在哪干活呢？干活都在 dev 分支上，也就是说，dev 分支是不稳定的，到某个时候，比如 1.0 版本发布时，再把 dev 分支合并到 master 上，在 master 分支发布 1.0 版本；

你和你的小伙伴们每个人都在 dev 分支上干活，每个人都有自己的分支，时不时地往 dev 分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/111.png" alt="111" style="zoom:150%;" />

### 暂存工作现场

```shell
$ git stash
```

### 查看暂存的工作现场

```shell
$ git stash list
```

### 恢复暂存现场

```shell
$ git stash pop
```

若要恢复指定的 stash

```shell
$ git stash apply stash@{0}
```

### 复制一个特定的提交到当前分支

```shell
$ git cherry-pick <id>
```

### 整理分支

```shell
$ git rebase
```

rebase 操作可以把本地未 push 的分叉提交历史整理成直线；

rebase 的目的是使得我们在查看历史提交的变化时更容易，因为分叉的提交需要三方对比

## 多人协作

### 查看远程库的信息

```shell
$ git remote
```

若要查看更详细的信息

```shell
$ git remote -v
```

### 推送分支

```shell
$ git push origin <branch-name>
```

### 在本地创建和远程分支对应的分支

```shell
$ git checkout -b <branch-name> origin/<branch-name>
```

分支名字最好一样

### 将远程库最新的提交抓下来

```shell
$ git pull
```

若提示 no tracking information，则说明本地分支和远程分支的链接关系没有创建，用命令

```shell
$ git branch --set-upstream-to <branch-name> origin/<branch-name>
或
$ git pull origin <branch-name>
```

### 主要步骤

多人协作的工作模式通常是这样：

1. 首先，可以试图用`git push origin <branch-name>`推送自己的修改；

1. 如果推送失败，则因为远程分支比你的本地更新，需要先用`git pull`试图合并；
2. 如果合并有冲突，则解决冲突，并在本地提交；
3. 没有冲突或者解决掉冲突后，再用`git push origin <branch-name>`推送就能成功！

### fork 相关操作

添加一个将被同步给 fork 远程的上游仓库

```bash
git remote add upstream git@github.com:GitHub-name/Repo-name.git
```

从上游仓库拉取更新

```bash
git fetch upstream
```

与自己的分支合并

```bash
git merge upstream/master
```

## 标签操作

### 创建标签

切换到需要打标签的分支上，然后用以下命令创建标签

```shell
$ git tag <tag-name>
```

若要根据 commit id 打标签

```shell
$ git tag <tag-name> <id>
```

若要创建带有说明的标签

```shell
$ git tag -a <tag-name> -m "message" <id>
```

### 查看标签

```shell
$ git tag
```

### 查看标签详细信息

```shell
$ git show <tag-name>
```

### 删除标签

```shell 
$ git tag -d <tag-name>
```

若要删除远程库标签，先从本地删除，然后

```shell 
$ git push origin :refs/tags/<tag-name>
```

### 推送标签至远程库

```shell
$ git push origin <tag-name>
```

若要一次性全部推送

```shell
$ git push origin --tags
```

## 个性化

### 显示更丰富的颜色

```shell
$ git config --global color.ui true
```

### 配置别名

```bash
$ git config --global alias.<simple-name> <origin-name>
```

### 忽略特殊文件

```shell
$ touch .gitignore
```

或直接创建一个`.gitignore`文件

别忘了提交`.gitignore`

### 删库跑路

```shell
$ rm .git -rf
```

## 规范

### GitFlow

![img](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/o_git-workflow-release-cycle-4maintenance.png)

#### 分支命名规范

- master：也称 main，存储正式发布的产品。
    - 这个分支上的产品要求随时处于可部署状态。
    - 它只能通过与其他分支合并来更新内容，禁止直接在 `master || main` 分支进行修改。
- develop：汇总开发者完成的工作成果
    - `develop` 分支上的产品可以是缺失功能模块的半成品，但是已有的功能模块不能是半成品
    - `develop` 分支只能通过与其他分支合并来更新内容，禁止直接在 `develop` 分支进行修改。
- feature 分支：feature/<功能名>，例如：feature/login
    - 当要开发新功能时，从 master 分支创建一个新的 `feature` 分支，并在 `feature` 分支上进行开发。
    - 开发完成后，需要将该 `feature` 分支合并到 `develop` 分支，最后删除该 `feature` 分支
- release 分支
    - 当 `develop` 分支上的项目准备发布时，从 `develop` 分支上创建一个新的 `release` 分支，新建的 `release` 分支只能进行质量测试、bug 修复、文档生成等面向发布的任务，不能再添加功能。
    - 这一系列发布任务完成后，需要将 `release` 分支合并到 `master` 分支上，并根据版本号为 `master` 分支添加 `tag`，然后将 `release` 分支创建以来的修改合并回 `develop` 分支，最后删除 `release` 分支
- hotfix 分支：hotfix/日期，例如：hotfix/0104
    - 当 `master` 分支中的产品出现需要立即修复的 bug 时，从 `master` 分支上创建一个新的 `hotfix` 分支，并在 `hotfix` 分支上进行 BUG 修复。
    - 修复完成后，需要将 `hotfix` 分支合并到 `master` 分支和 `develop` 分支，并为 `master` 分支添加新的版本号 `tag`，最后删除 `hotfix` 分支。

![](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/21810c5662374b2bb10e11e307e83d7c~tplv-k3u1fbpfcp-watermark.image)

### commit 规范

```
<type>(<scope>): <subject>
```

**type**

- feat：新功能（feature）
- fix：问题修复
- docs：文档
- style：调整格式（不影响代码运行 white-space, formatting, missing semi colons, etc）
- perf：优化**性能**或体验
- refactor：重构（既不是新增功能，也不是修補 bug 的程式碼變動）
- test：增加测试
- chore：构建过程或辅助工具的变动
- merge：代码合并。
- revert：撤销以前的提交
- sync：同步主线或分支的 Bug

scope：用于说明提交的影响范围，内容根据具体项目而定

subject：概括提交内容

详见：https://www.cnblogs.com/daysme/p/7722474.html

## git 命令补全配置

配置该功能时，只要下载 `git-bash-completion.git` 文件，无需下载所有的 `git` 源码。

所需文件是 `github` 上的开源文件

下载

```bash
root@ubuntu:~ git clone https://github.com/markgandolfo/git-bash-completion.git
root@ubuntu:~ cp git-bash-completion/git-completion.bash ~/.git-completion.bash
root@ubuntu:~ ll .git-completion.bash
-rwxr-xr-x 1 root root 27704 Feb 18 06:16 .git-completion.bash*
```

修改 `~/.bashrc`，在文件结尾增加：

```bash
if [ -f ~/.git-completion.bash ]; then
        . ~/.git-completion.bash
fi
```

执行 `.bashrc` 文件，在同一个窗口执行 `git` 命令，命令后续部分使用 `tab` 键补全。

```bash
root@ubuntu:~ source ~/.bashrc
root@ubuntu:~ git sta
stage    stash    status
```

> 上述是 `git` 命令补全功能。不要和 `linux` 命令补全功能混淆。`linux` 命令补全安装方法：`apt-get install bash-completion`。
>
> 可以使用 `git config` 命令配置 `git` 命令别名，减少命令输入。

## git rebase

- `git merge`：当需要保留详细的合并信息的时候建议使用，特别是需要将分支合并进入 `master` 分支时
- `git rebase`：当发现自己修改某个功能时，频繁进行了`git commit`提交时，发现其实过多的提交信息没有必要时使用，分支多，内容多时也可以考虑使用

**与 `git merge` 一致，`git rebase` 的目的也是将一个分支的更改并入到另外一个分支中去。**主要特点如下：

- 改变当前分支从 `master` 上拉出分支的位置
- **没有多余的合并历史的记录**，且合并后的 `commit` 顺序不一定按照 `commit` 的提交时间排列，同一个`commit`的 SHA 值会发生变化

### 例子

**假设现在有基于远程分支“origin/master”，更新至本地最新“master”，创建一个叫“feature/mywork”的分支**进行说明

```bash
$ git checkout -b feature/mywork
```

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ef541cf035374f0b83973a199c2c6ea1~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="1.jpg" style="zoom: 33%;" />

现在 在分支`feature/mywork`做一些修改，然后生成**两个commit**

```bash
$ vim README.md
$ git commit -am "xxxA"

$ vim CHANGELOG.md
$ git commit -am "xxxB"
...
```

与此同时，有些人在`master`分支上做了一些变更，如合并了 release 分支代码准备发布等。这时意味着`master`和`feature/mywork`这两个分支各自"前进"了，它们之间"分叉"了。 

<img src="https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e1088600f61e44e1b2d0e2bd7f49ca7c~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="2.jpg" style="zoom: 33%;" />

你可以用`pull`命令把`master`分支上的修改拉下来并且和你的修改合并；结果看起来就像一个新的"合并的提交"(merge commit)

<img src="https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/35d9c22941ea42c9abbf91b73802d7c4~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="3.jpg" style="zoom:33%;" />

这时 `feature/mywork` 分支历史看起来已经有分叉了，这还只是两个分支的，试想下有一个大型项目，有 20 个分支，同时迭代一些功能模块或者修改相同的代码块，分支树将会变成什么样？那能避免这种情况吗？答案当然是可以的，**如果你想让 `feature/mywork` 分支历史看起来像没有经过任何合并一样，可以用 `git rebase`**

```bash
$ git checkout feature/mywork
$ git rebase master
```

先来看下效果：

<img src="https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/98679c766a0c464b81ca1c0bc0cfa7b9~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="4.jpg" style="zoom:33%;" />

解释：**`git rebase` 会把 `feature/mywork` 分支里的每个提交 (commit) 取消掉，并且把它们临时保存为补丁 (patch)，然后把 `feature/mywork` 分支更新到最新的 `master` 分支，最后把保存的这些补丁应用到 `feature/mywork` 分支上**

当 `feature/mywork` 分支更新之后，它会指向这些新创建的提交 (commit)，而那些老的提交会被丢弃。 如果运行垃圾收集命令 (pruning garbage collection)，这些被丢弃的提交就会删除。

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5c352046c07f45ee95729ca6a5edefaa~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="5.jpg" style="zoom:33%;" />

现在我们可以看一下用 merge 和用 rebase 所产生的历史的区别：

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0d935bcca7af4fbf8d194cb31d8e565f~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="6.jpg" style="zoom:33%;" />

<img src="https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/206a02f937aa43b1ad53454a39585275~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp" alt="7.jpg" style="zoom:33%;" />

### 解决冲突 CONFLICT

在 rebase 的过程中，也许会出现冲突 (conflict)。在这种情况，Git 会停止 rebase 并会让你去解决冲突；在解决完冲突后，用 `git add` 命令去更新这些内容的索引 (index)，然后，你无需执行 `git commit`，只要执行：

```bash
$ git rebase --continue
```

这样 git 会继续应用 (apply) 余下的补丁。

在任何时候，你可以终止 rebase 的行动，并且 `feature/mywork` 分支会回到 rebase 开始前的状态。

```bash
$ git rebase --abort
```

在命令行使用 `git rebase` 存在多个 commit、多个冲突时需要我们**多次解决同一个地方的冲突**，然后执行 `git rebase --continue`，反复，直到冲突解决为止，稍显麻烦，可以使用 IDE 辅助进行，如 JetBrains 家族的 IDE 系列对 VCS 都有很好的支持，最新版的更是直接将 VCS 变为 Git

### 合并历史 commit

```bash
# 从HEAD版本开始往过去数3个版本
$ git rebase -i HEAD~3

# 合并指定版本号（不包含此版本）
$ git rebase -i [commitid]
```

- `-i（--interactive）`：弹出交互式的界面进行编辑合并
- `[commitid]`：要合并多个版本之前的版本号，注意：`[commitid]` 本身不参与合并

指令解释（交互编辑时使用）：

- p, pick = use commit
- r, reword = use commit, but edit the commit message
- e, edit = use commit, but stop for amending
- s, squash = use commit, but meld into previous commit
- f, fixup = like "squash", but discard this commit's log message
- x, exec = run command (the rest of the line) using shell
- d, drop = remove commit

## git checkout

### 基础

checkout 最常用的用法莫过于对于工作分支的切换了：

```shell
git checkout branchName
```

该命令会将当前工作分支切换到 branchName。另外，可以通过下面的命令在新分支创建的同时切换分支：

```shell
git checkout -b newBranch
```

该命令相当于下面这两条命令的执行结果：

```shell
1. git branch newBranch 
2. git checkout newBranch
```

该命令的完全体为：

```xml
  git checkout -b|-B <new_branch> [<start point>]
```

该命令的一个应用场景为：当我们刚从 git 上 clone 一个项目后，我们可以查看该项目的分支情况

![img](https:////upload-images.jianshu.io/upload_images/2147642-72217d4e0d491915.png?imageMogr2/auto-orient/strip|imageView2/2/w/454/format/webp)

可以看到，克隆完后，只会默认创建一个 master 本地分支，其他都是远程分支，此时如果我们想切换到 newBranch 的远程分支该怎么操作呢？

方法一：使用 `git checkout -b`

```shell
git checkout -b newBranch  origin/newBranch
```

方法二：使用 `git branch <branchname> [<start-point>]`

```shell
git branch newBranch origin/newBranch
git checkout newBranch
```

方法一其实是方法二的简化版

### 深入

要想更深入的了解 checkout，我们需要了解 checkout 的作用机制。该命令的主要关联目标其实是.git 文件夹下的 HEAD 文件，我们可以查看工程下面的.git 文件夹：

![img](https:////upload-images.jianshu.io/upload_images/2147642-70674478b9866791.jpeg?imageMogr2/auto-orient/strip|imageView2/2/w/631/format/webp)

该文件夹下 HEAD 文件记录了当前 HEAD 的信息，继续查看 HEAD 文件：

![img](https:////upload-images.jianshu.io/upload_images/2147642-9e5096caf64ba235.jpeg?imageMogr2/auto-orient/strip|imageView2/2/w/620/format/webp)

可以看到当前 HEAD 文件指向了 refs/heads 路径下的 master 文件，该文件记录了 master 分支最近的一次 commit id,说明当前 HEAD 指向了 master 分支。如果我们将当前分支切换到 newBranch 分支，我们再看 HEAD 文件：

![img](https:////upload-images.jianshu.io/upload_images/2147642-11092d89be549ea9.jpeg?imageMogr2/auto-orient/strip|imageView2/2/w/468/format/webp)

可以看到 HEAD 文件内容指向了 newBranch 分支

### 拓展

#### 检出某文件

```shell
git checkout [<commit id>] [--] <paths>
```

该命令主要用于检出某一个指定文件。

如果不填写 commit id，则**默认会从暂存区检出该文件**，如果暂存区为空，则该文件会回滚到最近一次的提交状态。

例如：当暂存区为空，如果我们想要放弃对某一个文件的修改，可以用这个命令进行撤销：

```shell
git checkout  [--] <paths>
```

如果填写 commit id（既可以是 commit hash 也可以是分支名称还可以说 tag，其本质上都是 commit hash），则会从指定 commit hash 中检出该文件。用于恢复某一个文件到某一个提交状态。

#### 创建并切换分支

```shell
 git checkout -b <new_branch> [<start_point>]
```

该命令是文章开头部分所说的 checkout 常见用法的扩展，我们可以指定某一个分支或者某一次提交来创建新的分支，并且切换到该分支下，该命令相当于下面两条命令的执行结果：

```shell
1. git branch  <new_branch> [<start_point>]
2. git checkout <new_branch>
```

#### 强制创建并覆盖原同名分支

```shell
git checkout -B <new_branch>
```

该命令主要加了一个可选参数 B，如果已经存在了同名的分支，使用 git checkout -b <new_branch>会提示错误，加入-B 可选参数后会强制创建新分支，并且会覆盖原来存在的同名分支。

#### 分出一个没有 commit 历史的干净分支

```shell
git checkout --orphan <new_branch>
```

假如你的某个分支上，积累了无数次的提交，你也懒得去打理，打印出的 log 也让你无力吐槽，那么这个命令将是你的神器，它会基于当前所在分支新建一个赤裸裸的分支，没有任何的提交历史，但是当前分支的内容一一俱全。新建的分支，严格意义上说，还不是一个分支，因为 HEAD 指向的引用中没有 commit 值，只有在进行一次提交后，它才算得上真正的分支。

#### 切换分支时带走修改的内容

```shell
git checkout --merge <branch>
```

这个命令适用于在切换分支的时候，将当前分支修改的内容一起打包带走，同步到切换的分支下。
有两个需要注意的问题。

1. 如果当前分支和切换分支间的内容不同的话，容易造成冲突。
2. 第二，切换到新分支后，当前分支修改过的内容就丢失了。

所以这个命令，慎用

#### 比较两个分支的差异

```shell
git checkout -p <branch>
```

这个命令可以用来打补丁。这个命令主要用来比较两个分支间的差异内容，并提供交互式的界面来选择进一步的操作。这个命令不仅可以比较两个分支间的差异，还可以比较单个文件的差异哦！

## git stash

使用git的时候，我们往往使用分支（branch）解决任务切换问题。

例如，我们往往会建一个自己的分支去修改和调试代码；如果别人或者自己发现原有的分支上有个不得不修改的bug，我们往往会把完成一半的代码`commit`提交到本地仓库，然后切换分支去修改bug，改好之后再切换回来。这样的话往往log上会有大量不必要的记录。

其实如果我们不想提交完成一半或者不完善的代码，但是却不得不去修改一个紧急Bug，那么使用 `git stash` 就可以将你当前未提交到本地（和服务器）的代码推入到Git的栈中。

这时候你的工作区间和上一次提交的内容是完全一样的，所以你可以放心的修Bug；等到修完Bug，提交到服务器上后，再使用`git stash apply`将以前一半的工作应用回来。

> 经常有这样的事情发生，当你正在进行项目中某一部分的工作，里面的东西处于一个比较杂乱的状态，而你想转到其他分支上进行一些工作。
>
> 问题是，你不想提交进行了一半的工作，否则以后你无法回到这个工作点。
>
> 解决这个问题的办法就是 `git stash` 命令。
>
> 储藏 (stash) 可以获取你工作目录的中间状态——也就是你修改过的被追踪的文件和暂存的变更——并将它保存到一个未完结变更的堆栈中，随时可以重新应用。

### stash 当前修改

`git stash` 会把所有未提交的修改（包括暂存的和非暂存的）都保存起来，用于后续恢复当前工作目录。
比如下面的中间状态，通过 `git stash` 命令推送一个新的储藏，当前的工作目录就干净了。

```bash
$ git status
On branch master
Changes to be committed:

new file:   style.css

Changes not staged for commit:

modified:   index.html

$ git stash
Saved working directory and index state WIP on master: 5002d47 our new homepage
HEAD is now at 5002d47 our new homepage

$ git status
On branch master
nothing to commit, working tree clean
```

需要说明一点，stash 是本地的，不会通过 `git push` 命令上传到 git server 上。

实际应用中推荐给每个 stash 加一个message，用于记录版本，**使用 `git stash save` 取代 `git stash` 命令。**示例如下：

```bash
$ git stash save "test-cmd-stash"
Saved working directory and index state On autoswitch: test-cmd-stash
HEAD 现在位于 296e8d4 remove unnecessary postion reset in onResume function
$ git stash list
stash@{0}: On autoswitch: test-cmd-stash
```

### 重新应用缓存的 stash

可以通过 `git stash pop` 命令恢复之前缓存的工作目录，输出如下：

```bash
$ git status
On branch master
nothing to commit, working tree clean
$ git stash pop
On branch master
Changes to be committed:

    new file:   style.css

Changes not staged for commit:

    modified:   index.html

Dropped refs/stash@{0} (32b3aa1d185dfe6d57b3c3cc3b32cbf3e380cc6a)
```

这个指令将缓存堆栈中的第一个 stash 删除，并将对应修改应用到当前的工作目录下。

你也可以使用 **`git stash apply`** 命令，将缓存堆栈中的 stash 多次应用到工作目录中，但**并不删除 stash 拷贝**。

命令输出如下：

```bash
$ git stash apply
On branch master
Changes to be committed:

    new file:   style.css

Changes not staged for commit:

    modified:   index.html
```

### 查看现有 stash

可以使用 `git stash list` 命令，一个典型的输出如下：

```bash
$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log
```

在使用 `git stash apply` 命令时可以通过名字指定使用哪个 stash，默认使用最近的stash（ 即 `stash@{0`} ）

### 删除 stash

可以使用 `git stash drop` 命令，后面可以跟着 stash 名字。下面是一个示例：

```perl
$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log
$ git stash drop stash@{0}
Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)
```

或者使用 `git stash clear` 命令，删除所有缓存的 stash。

### 查看指定 stash 的 diff

可以使用 `git stash show` 命令，后面可以跟着 stash 名字。示例如下：

```ruby
$ git stash show
 index.html | 1 +
 style.css | 3 +++
 2 files changed, 4 insertions(+)
```

在该命令后面添加 `-p` 或 `--patch` 可以查看特定 stash 的全部 diff，如下：

```diff
$ git stash show -p
diff --git a/style.css b/style.css
new file mode 100644
index 0000000..d92368b
--- /dev/null
+++ b/style.css
@@ -0,0 +1,3 @@
+* {
+  text-decoration: blink;
+}
diff --git a/index.html b/index.html
index 9daeafb..ebdcbd2 100644
--- a/index.html
+++ b/index.html
@@ -1 +1,2 @@
+<link rel="stylesheet" href="style.css"/>
```

### 从 stash 创建分支

如果你储藏了一些工作，暂时不去理会，然后继续在你储藏工作的分支上工作，你在重新应用工作时可能会碰到一些问题：如果尝试应用的变更是针对一个你那之后修改过的文件，你会碰到一个归并冲突并且必须去化解它。

如果你想用更方便的方法来重新检验你储藏的变更，你可以运行 `git stash branch`，这会创建一个新的分支，检出你储藏工作时的所处的提交，重新应用你的工作，如果成功，将会丢弃储藏。

```shell
$ git stash branch testchanges
Switched to a new branch "testchanges"
# On branch testchanges
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)
```

这是一个很棒的捷径来恢复储藏的工作然后在新的分支上继续当时的工作。

### 暂存指定文件

```bash
git stash push <file_path>
```

### 暂存未跟踪或忽略的文件

默认情况下，`git stash` 会缓存下列文件：

- 添加到暂存区的修改（staged changes）
- Git 跟踪的但并未添加到暂存区的修改（unstaged changes）

但不会缓存以下文件：

- **在工作目录中新的文件**（untracked files）
- 被忽略的文件（ignored files）

`git stash` 命令提供了参数用于缓存上面两种类型的文件。

- 使用 `-u` 或者 `--include-untracked` 可以 stash untracked 文件。
- 使用 `-a` 或者 `--all` 命令可以 stash 当前目录下的所有修改。

## git cherry-pick

### 基本用法

`git cherry-pick` 命令的作用，就是将指定的提交（commit）应用于其他分支。

```bash
$ git cherry-pick <commitHash>
```

上面命令就会将指定的提交 `commitHash`，应用于当前分支。这会在当前分支产生一个新的提交，当然它们的哈希值会不一样。

举例来说，代码仓库有 `master` 和 `feature` 两个分支。

```
a - b - c - d   Master
         \
           e - f - g Feature
```

现在将提交 `f` 应用到 `master` 分支。

```bash
# 切换到 master 分支
$ git checkout master

# Cherry pick 操作
$ git cherry-pick f
```

上面的操作完成以后，代码库就变成了下面的样子。

```
a - b - c - d - f   Master
         \
           e - f - g Feature
```

从上面可以看到，`master` 分支的末尾增加了一个提交 `f`。

`git cherry-pick` 命令的参数，不一定是提交的哈希值，分支名也是可以的，表示转移该分支的最新提交。

```bash
git cherry-pick feature
```

上面代码表示将 `feature` 分支的最近一次提交，转移到当前分支。

### 转移多个提交

Cherry pick 支持一次转移多个提交。

```bash
$ git cherry-pick <HashA> <HashB>
```

上面的命令将 A 和 B 两个提交应用到当前分支。这会在当前分支生成两个对应的新提交。

如果想要转移一系列的连续提交，可以使用下面的简便语法。

```bash
$ git cherry-pick A..B 
```

上面的命令可以转移从 A 到 B（**除了 A**）的所有提交。它们必须按照正确的顺序放置：提交 A 必须早于提交 B，否则命令将失败，但不会报错。

注意，使用上面的命令，提交 A 将不会包含在 Cherry pick 中。如果要包含提交 A，可以使用下面的语法。

```bash
$ git cherry-pick A^..B 
```

### 配置项

`git cherry-pick`命令的常用配置项如下。

- `-e`，`--edit`
    - 打开外部编辑器，编辑提交信息。

- `-n`，`--no-commit`
    - 只更新工作区和暂存区，不产生新的提交。

- `-x`
    - 在提交信息的末尾追加一行`(cherry picked from commit ...)`，方便以后查到这个提交是如何产生的。

- `-s`，`--signoff`
    - 在提交信息的末尾追加一行操作者的签名，表示是谁进行了这个操作。

- `-m parent-number`，`--mainline parent-number`

    - 如果原始提交是一个合并节点，来自于两个分支的合并，那么 Cherry pick 默认将失败，因为它不知道应该采用哪个分支的代码变动。

    - `-m` 配置项告诉 Git，应该采用哪个分支的变动。它的参数 `parent-number` 是一个从 `1` 开始的整数，代表原始提交的父分支编号。

    - ```bash
        $ git cherry-pick -m 1 <commitHash>
        ```

    - 面命令表示，Cherry pick 采用提交 `commitHash` 来自编号 1 的父分支的变动。

        一般来说，1号父分支是接受变动的分支（the branch being merged into），2号父分支是作为变动来源的分支（the branch being merged from）

### 代码冲突

如果操作过程中发生代码冲突，Cherry pick 会停下来，让用户决定如何继续操作。

- `--continue`

    - 用户解决代码冲突后，第一步将修改的文件重新加入暂存区（`git add .`），第二步使用下面的命令，让 Cherry pick 过程继续执行。

    - ```bash
        $ git cherry-pick --continue
        ```

- `--abort`
    - 发生代码冲突后，放弃合并，回到操作前的样子。

- `--quit`
    - 发生代码冲突后，退出 Cherry pick，但是不回到操作前的样子。

### 转移到另一个代码库

Cherry pick 也支持转移另一个代码库的提交，方法是先将该库加为远程仓库。

```bash
$ git remote add target git://gitUrl
```

上面命令添加了一个远程仓库`target`。

然后，将远程代码抓取到本地。

```bash
$ git fetch target
```

上面命令将远程代码仓库抓取到本地。

接着，检查一下要从远程仓库转移的提交，获取它的哈希值。

```bash
$ git log target/master
```

最后，使用`git cherry-pick`命令转移提交。

```bash
$ git cherry-pick <commitHash>
```

## 其他

- 不建议使用 `git push --force`，推荐 `--force-with-lease` 参数

- 识别大小写

```bash
git config core.ignorecase false
```

- 修改上一次的 commit 记录

```bash
git commit --amend
```

- 比较文件

```bash
git diff <branch_name1> <branch_name2> --stat
git diff <branch_name1> --stat # 比较当前文件与 branch_name1
```

