## 一、基本语法

**apt-get [options] command**

### 1.1 参数

```
-h, --help              // 查看帮助文档
-v, --version           // 查看 apt-get 的版本
-y                      // 在需要确认的场景中回应 yes
-s, --dry-run           // 模拟执行并输出结果
-d, --download-only     // 把包下载到缓存中而不安装
--only-upgrade          // 更新当前版本的包而不是安装新的版本
--no-upgrade            // 在执行 install 命令时，不安装已安装包的更新
-q, --quiet             // 减少输出
--purge                 // 配合 remove 命令删除包的配置文件
--reinstall             // 重新安装已安装的包或其新版本
```

### 1.2 子命令

**update**
update 命令用于重新同步包索引文件，/etc/apt/sources.list 文件中的配置指定了包索引文件的来源。更新了包索引文件后就可以得到可用的包的更新信息和新的包信息。这样我们本地就有了这样的信息：有哪些软件的哪些版本可以从什么地方(源)安装。
update 命令应该总是在安装或升级包之前执行。

**install**
install 命令用来安装或者升级包。每个包都有一个包名，而不是一个完全限定的文件名(例如，在 Debian 系统中，提供的参数是 apt-utils，而不是 apt-utils_1.6.1_amd64.deb)。被安装的包依赖的包也将被安装。配置文件 /etc/apt/sources.list 中包含了用于获取包的源(服务器)。install 命令还可以用来更新指定的包。

**upgrade**
upgrade 命令用于从 /etc/apt/sources.list 中列出的源安装系统上当前安装的所有包的最新版本。在任何情况下，当前安装的软件包都不会被删除，尚未安装的软件包也不会被检索和安装。如果当前安装的包的新版本不能在不更改另一个包的安装状态的情况下升级，则将保留当前版本。必须提前执行 update 命令以便 apt-get 知道已安装的包是否有新版本可用。
注意 update 与 upgrade 的区别：
update 是更新软件列表，upgrade 是更新软件。

**dist-upgrade**
除执行升级功能外，dist-upgrade 还智能地处理与新版本包的依赖关系的变化。apt-get 有一个 "智能" 的冲突解决系统，如果有必要，它将尝试升级最重要的包，以牺牲不那么重要的包为代价。因此，distr -upgrade 命令可能会删除一些包。因此在更新系统中的包时，建议按顺序执行下面的命令：
\$ apt-get update
\$ apt-get upgrade -y
\$ apt-get dis-upgrade -y

**remove**
remove 与 install 类似，不同之处是删除包而不是安装包。注意，使用 remove 命令删除一个包会将其配置文件留在系统上。

**purge**
purge 命令与 remove 命令类似，purge 命令在删除包的同时也删除了包的配置文件。

**autoremove**
autoremove 命令用于删除自动安装的软件包，这些软件包当初是为了满足其他软件包对它的依赖关系而安装的，而现在已经不再需要了。

**download**
download 命令把指定包的二进制文件下载到当前目录中。注意，是类似 *.deb 这样的包文件。

**clean**
clean 命令清除在本地库中检索到的包。它从 /var/cache/apt/archives/ 和 /var/cache/apt/archives/partial/ 目录删除除锁文件之外的所有内容。

**autoclean**
与 clean 命令类似，autoclean 命令清除检索到的包文件的本地存储库。不同之处在于，它只删除不能再下载的软件包文件，而且这些文件在很大程度上是无用的。这允许长时间维护缓存，而不至于大小失控。

**source**
source 命令下载包的源代码。默认会下载最新可用版本的源代码到当前目录中。

**changelog**
changelog 命令尝试下载并显示包的更新日志。