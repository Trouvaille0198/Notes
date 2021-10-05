# 安装

## 设置名字、邮箱

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

## 创建版本库（**repository**）

- 创建空目录

```shell
$ mkdir <repo name>
$ cd <repo name>
$ pwd
```

`pwd`命令用于显示当前目录

- 把这个目录变成Git可以管理的仓库

```shell
$ git init
```

# 文件操作

## 添加文件

把文件往Git版本库里添加的时候，是分两步执行的：

第一步是用`git add`把文件添加进去，实际上就是把文件修改添加到暂存区；

第二步是用`git commit`提交更改，实际上就是把暂存区的所有内容提交到当前分支。

1. 将工作区文件添加到暂存区

```shell
$ git add <filename>
```

2. 将暂存区文件添加到本地仓库

```shell
$ git commit -m <message>
```

## 查看信息

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

## 修改文件

1. 退回上一版本

```shell
$ git reset --hard HEAD^
```

上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本写100个^比较容易数不过来，所以写成`HEAD~100`

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

# 远程仓库操作

## 创建SSH Key

```shell
$ ssh-keygen -t rsa -C "youremail@example.com"
```

可以在用户主目录里找到`.ssh`目录，里面有`id_rsa`和`id_rsa.pub`两个文件，这两个就是SSH Key的秘钥对，`id_rsa`是私钥，不能泄露出去，`id_rsa.pub`是公钥，可以放心地告诉任何人

## 关联远程仓库

```shell
$ git remote add origin git@github.com:GitHub-name/Repo-name.git
```

## 初次推送

```shell
$ git push -u origin master
```

## 将本地库推送至远程库

```shell
$ git push origin master
```

若要强制推送覆盖远程文件

```shell
$ git push -f origin master
```

## 将远程库克隆至本地库

```shell
$ git clone git@github.com:GitHub-name/Repo-name.git
```

# 分支操作

分支共有5种类型

1. master/main，最终发布版本，整个项目中有且只有一个
2. develop，项目的开发分支，原则上项目中有且只有一个
3. feature，功能分支，用于开发一个新的功能
4. release，预发布版本，介于develop和master之间的一个版本，主要用于测试
5. hotfix，修复补丁，用于修复master上的bug，直接作用于master

## 创建并切换到新的分支

```shell
$ git switch -c <name>
```

## 创建新的分支

```shell
$ git branch <name>
```

## 切换到已有的分支

```shell
$ git switch <name>
```

## 查看分支

```shell
$ git branch
```

## 合并某分支到当前分支

```shell
$ git merge <name>
```

## 删除分支

```shell
$ git branch -d <name>
```

若要强行删除

```shell
$ git branch -D <name>
```

## 查看分支的合并情况

```shell
$ git log --graph --pretty=oneline --abbrev-commit
```

## 分支策略

在实际开发中，我们应该按照几个基本原则进行分支管理：

首先，master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；

那在哪干活呢？干活都在dev分支上，也就是说，dev分支是不稳定的，到某个时候，比如1.0版本发布时，再把dev分支合并到master上，在master分支发布1.0版本；

你和你的小伙伴们每个人都在dev分支上干活，每个人都有自己的分支，时不时地往dev分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/111.png" alt="111" style="zoom:150%;" />

## 暂存工作现场

```shell
$ git stash
```

## 查看暂存的工作现场

```shell
$ git stash list
```

## 恢复暂存现场

```shell
$ git stash pop
```

若要恢复指定的stash

```shell
$ git stash apply stash@{0}
```

## 复制一个特定的提交到当前分支

```shell
$ git cherry-pick <id>
```

## 整理分支

```shell
$ git rebase
```

rebase操作可以把本地未push的分叉提交历史整理成直线；

rebase的目的是使得我们在查看历史提交的变化时更容易，因为分叉的提交需要三方对比

# 多人协作

## 查看远程库的信息

```shell
$ git remote
```

若要查看更详细的信息

```shell
$ git remote -v
```

## 推送分支

```shell
$ git push origin <branch-name>
```

## 在本地创建和远程分支对应的分支

```shell
$ git checkout -b <branch-name> origin/<branch-name>
```

分支名字最好一样

## 将远程库最新的提交抓下来

```shell
$ git pull
```

若提示no tracking information，则说明本地分支和远程分支的链接关系没有创建，用命令

```shell
$ git branch --set-upstream-to <branch-name> origin/<branch-name>
或
$ git pull origin <branch-name>
```

## 主要步骤

多人协作的工作模式通常是这样：

1. 首先，可以试图用`git push origin <branch-name>`推送自己的修改；

1. 如果推送失败，则因为远程分支比你的本地更新，需要先用`git pull`试图合并；
2. 如果合并有冲突，则解决冲突，并在本地提交；
3. 没有冲突或者解决掉冲突后，再用`git push origin <branch-name>`推送就能成功！

## fork 相关操作

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

# 标签操作

## 创建标签

切换到需要打标签的分支上，然后用以下命令创建标签

```shell
$ git tag <tag-name>
```

若要根据commit id打标签

```shell
$ git tag <tag-name> <id>
```

若要创建带有说明的标签

```shell
$ git tag -a <tag-name> -m "message" <id>
```

## 查看标签

```shell
$ git tag
```

## 查看标签详细信息

```shell
$ git show <tag-name>
```

## 删除标签

```shell 
$ git tag -d <tag-name>
```

若要删除远程库标签，先从本地删除，然后

```shell 
$ git push origin :refs/tags/<tag-name>
```

## 推送标签至远程库

```shell
$ git push origin <tag-name>
```

若要一次性全部推送

```shell
$ git push origin --tags
```

# 个性化

## 显示更丰富的颜色

```shell
$ git config --global color.ui true
```

## 配置别名

$ git config --global alias.<simple-name> <origin-name>

## 忽略特殊文件

```shell
$ touch .gitignore
```

或直接创建一个`.gitignore`文件

别忘了提交`.gitignore`

## 删库跑路

```shell
$ rm .git -rf
```

# 规范

## GitFlow

![img](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/o_git-workflow-release-cycle-4maintenance.png)

### 分支命名规范

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

## commit 规范

```
<type>(<scope>): <subject>
```

type

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
