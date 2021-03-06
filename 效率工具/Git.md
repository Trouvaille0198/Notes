# 一、安装

## 1.1 设置名字、邮箱

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

## 1.2 创建版本库（**repository**）

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

# 二、文件操作

## 2.1 添加文件

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

## 2.2 查看信息

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

## 2.3 修改文件

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

# 三、远程仓库操作

## 3.1 创建SSH Key

```shell
$ ssh-keygen -t rsa -C "youremail@example.com"
```

可以在用户主目录里找到`.ssh`目录，里面有`id_rsa`和`id_rsa.pub`两个文件，这两个就是SSH Key的秘钥对，`id_rsa`是私钥，不能泄露出去，`id_rsa.pub`是公钥，可以放心地告诉任何人

## 3.2 关联远程仓库

```shell
$ git remote add origin git@github.com:GitHub-name/Repo-name.git
```

## 3.3 初次推送

```shell
$ git push -u origin master
```

## 3.4 将本地库推送至远程库

```shell
$ git push origin master
```

若要强制推送覆盖远程文件

```shell
$ git push -f origin master
```

## 3.5 将远程库克隆至本地库

```shell
$ git clone git@github.com:GitHub-name/Repo-name.git
```

# 四、分支操作

分支共有5种类型

1. master/main，最终发布版本，整个项目中有且只有一个
2. develop，项目的开发分支，原则上项目中有且只有一个
3. feature，功能分支，用于开发一个新的功能
4. release，预发布版本，介于develop和master之间的一个版本，主要用于测试
5. hotfix，修复补丁，用于修复master上的bug，直接作用于master

## 4.1 创建并切换到新的分支

```shell
$ git switch -c <name>
```

## 4.2 创建新的分支

```shell
$ git branch <name>
```

## 4.3 切换到已有的分支

```shell
$ git switch <name>
```

## 4.4 查看分支

```shell
$ git branch
```

## 4.5 合并某分支到当前分支

```shell
$ git merge <name>
```

## 4.6 删除分支

```shell
$ git branch -d <name>
```

若要强行删除

```shell
$ git branch -D <name>
```

## 4.7 查看分支的合并情况

```shell
$ git log --graph --pretty=oneline --abbrev-commit
```

## 4.8 分支策略

在实际开发中，我们应该按照几个基本原则进行分支管理：

首先，master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；

那在哪干活呢？干活都在dev分支上，也就是说，dev分支是不稳定的，到某个时候，比如1.0版本发布时，再把dev分支合并到master上，在master分支发布1.0版本；

你和你的小伙伴们每个人都在dev分支上干活，每个人都有自己的分支，时不时地往dev分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/111.png" alt="111" style="zoom:150%;" />

## 4.9 暂存工作现场

```shell
$ git stash
```

## 4.10 查看暂存的工作现场

```shell
$ git stash list
```

## 4.11 恢复暂存现场

```shell
$ git stash pop
```

若要恢复指定的stash

```shell
$ git stash apply stash@{0}
```

## 4.12 复制一个特定的提交到当前分支

```shell
$ git cherry-pick <id>
```

## 4.13 整理分支

```shell
$ git rebase
```

rebase操作可以把本地未push的分叉提交历史整理成直线；

rebase的目的是使得我们在查看历史提交的变化时更容易，因为分叉的提交需要三方对比

# 五、多人协作

## 5.1 查看远程库的信息

```shell
$ git remote
```

若要查看更详细的信息

```shell
$ git remote -v
```

## 5.2 推送分支

```shell
$ git push origin <branch-name>
```

## 5.3 在本地创建和远程分支对应的分支

```shell
$ git checkout -b <branch-name> origin/<branch-name>
```

分支名字最好一样

## 5.4 将远程库最新的提交抓下来

```shell
$ git pull
```

若提示no tracking information，则说明本地分支和远程分支的链接关系没有创建，用命令

```shell
$ git branch --set-upstream-to <branch-name> origin/<branch-name>
或
$ git pull origin <branch-name>
```

## 5.5 主要步骤

多人协作的工作模式通常是这样：

1. 首先，可以试图用`git push origin <branch-name>`推送自己的修改；

1. 如果推送失败，则因为远程分支比你的本地更新，需要先用`git pull`试图合并；
2. 如果合并有冲突，则解决冲突，并在本地提交；
3. 没有冲突或者解决掉冲突后，再用`git push origin <branch-name>`推送就能成功！

# 六、标签操作

## 6.1 创建标签

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

## 6.2 查看标签

```shell
$ git tag
```

## 6.3 查看标签详细信息

```shell
$ git show <tag-name>
```

## 6.4 删除标签

```shell 
$ git tag -d <tag-name>
```

若要删除远程库标签，先从本地删除，然后

```shell 
$ git push origin :refs/tags/<tag-name>
```

## 6.5 推送标签至远程库

```shell
$ git push origin <tag-name>
```

若要一次性全部推送

```shell
$ git push origin --tags
```

# 七、个性化

## 7.1 显示更丰富的颜色

```shell
$ git config --global color.ui true
```

## 7.2 配置别名

$ git config --global alias.<simple-name> <origin-name>

## 7.3 忽略特殊文件

```shell
$ touch .gitignore
```

或直接创建一个`.gitignore`文件

别忘了提交`.gitignore`

## 7.4 删库跑路

```shell
$ rm .git -rf
```



```javascript
module.exports = function () {
    StructureSpawn.prototype.spawnCustomCreep =
        function (energy, roleName) {

            var body = [];
            if (roleName == 'carrier') {
                var numOfParts = Math.floor(energy / 100);
                for (let i = 0; i < numOfParts; i++) {
                    body.push(CARRY);
                }
                for (let i = 0; i < numOfParts; i++) {
                    body.push(MOVE);
                }
            }

            return this.spawnCreep(body, roleName + Game.time, { memory: { role: roleName, working: false } });
        };
    StructureSpawn.prototype.clearMemory =
        function () {
            for (let name in Memory.creeps) {
                if (Game.creeps[name] == undefined) {
                    delete Memory.creeps[name];
                }
            }
        };
};
```

