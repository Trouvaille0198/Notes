---
draft: true
---

# ex1

## 思考题

1. **思考：你的用户名、用户标识、组名、组标识是什么？当前你处在系统的哪个位置中？现在有哪些用户和你一块儿共享系统？**

![image-20210914100008892](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210914100008892.png)

​	当前处于 `/mnt/d/Repo` 目录下。loulou 与 root 用户一起共享系统文件操作命令

2. **思考：文件链接是什么意思？有什么作用？**

    文件链接指在文件之间创建链接。以此来给某个文件指定一个可以访问它的名称。对于这个新文件名，我们可以指定不同的访问权限来控制对信息的共享和安全性的问题。如果是目录链接，用户则可以直接进入被链接的目录，省去路径操作。此外，删除链接也不会破坏原先的目录

3. **思考：Linux 文件类型有哪几种？文件的存取控制模式如何描述？**

    主要有普通文件（~）、目录文件（d）、块设备特别文件（b）、字符设备特别文件（c）、命令管道文件（p）这几类。存取控制模式指对不同用户分配不同的操作权。分为三种：写、读、执行。

4. **思考：执行了上述操作后，若想再修该文件，看能不能执行。为什么？**

    不能执行。因为文件所属用户不是当前登录的用户。

5. **思考：系统如何管理系统中的多个进程？进程的家族关系是怎样体现的？有什么用？**

    Linux 使用 task_struct 数据结构表示每个进程，利用任务向量这个指针数组来指向每一个 task。进程的家族关系是进程家族树来体现，通过继承体系从系统的任何一个进程发现并查找到指定的其它进程，通过不断指向子进程即可遍历所有进程。

## 讨论

1. **Linux 系统命令很多，在手头资料不全时，如何查看命令格式？**

    `命令名 --help` 或 `man 命令名`

2. **Linux 系统用什么方式管理多个用户操作？如何管理用户文件，隔离用户空间？用命令及结果举例说明。**

    用户是 Linux 系统最底层的安全设备，属于权限问题，系统要回收权力。系统用户即系统的使用者，用户管理是对文件进行管理，用户的存在是为了回收权力。利用用户和用户组管理实现不同用户分配不同权限

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211022110012624.png" alt="image-20211022110012624" style="zoom:50%;" />

    利用 chown 来修改文件权限，使得只有指定的用户才可以访问。

3. **用什么方式查看你的进程的管理参数？这些参数怎样体现父子关系？当结束一个父 进程后其子进程如何处理？用命令及结果举例说明。** 

    一个父进程后其子进程如何处理？用命令及结果举例说明。

    `ps -ef` 根据 PID 和 PPID 可以得知其父子关系。若父进程比子进程先终止，则该父进程的所有子进程的父进程都变为 init 进程。其执行顺序大致如下：在一个进程终止时，内核逐个检查所有活动进程，以判断它是否是正要终止的进程的子进程，如果是，则该进程的父进程 ID 就更改为 1（init 进程的 ID)

4. **Linux 系统“文件”的含义是什么？它的文件有几种类型？如何标识的？** 

    Linux 世界中的所有、任意、一切东西都可以通过文件的方式访问、管理，这种文件的设计是一种面向对象的设计思想。普通文件（~）、目录文件（d）、块设备特别文件（b）、字符设备特别文件（c）、命令管道文件（p）、链接文件（l）、套接字文件（s）等。

5. **Linux 系统的可执行命令主要放在什么地方？找出你的计算机中所有存放系统的可 执行命令的目录位置。** 

    /bin 一般用户即可使用

    /usr/bin   /usr/sbin/  /usr/local/sbin 管理员可以使用

6. **Linux 系统得设备是如何管理的？在什么地方可以找到描述设备的信息？** 

    ```shell
    fdisk  -l                  ##列出磁盘分区信息(真实存在的设备)
    blkid                      ##列出系统中可以使用的设备id
    cat /proc/partition        ##系统内核可以识别的设备
    df                         ##系统正在挂载的设备（显示挂载点）
    ```

7. **画出 Linux 根文件系统的框架结构。描述各目录的主要作用。你的用户主目录在哪里？** 

    ![image-20210620204722807](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210620204722807.png)

    - `/` ：linux 系统目录树的起点 
    - `bin`：命令文件目录，也称二进制目录 
    - `boot`：存放系统的内核文件和引导装载程序文件 
    - `dev`：设备文件目录，存放所有的设备文件，例如 cdrom 为光盘设备 

    - `etc`：存放系统配置文件，如 password 文件

    - `home`：包含系统中各个用户的主目录，子目录名即为各用户名 

    - `lib`：存放各种编程语言库 

    - `media`：系统设置的自动挂载点，如 u 盘的自动挂载点 
    - `opt`：表示可选择的意思，有些软件包会被安装在这里; 

    - `usr`：最大的目录之一，很多系统中，该目录是作为独立的分区挂载的，该目录中主要存放不经常变化的数据，以及系统下安装的应用程序目录 

    - `mnt`：主要用来临时挂载文件系统，为某些设备默认提供挂载点 （WSL 中 windows 系统的文件会被挂载在这个目录）

    - `proc`：虚拟文件系统，该目录中的文件是内存中的映像。 

    - `sbin`：保存系统管理员或者 root 用户的命令文件。 

    - `tmp`：存放临时文件 

    - `var`：通常保存经常变化的内容，如系统日志、邮件文件等 

    - `root`：系统管理员主目录

8. **Linux 系统的 Shell 是什么？请查找这方面的资料，说明不同版本的Shell的特点。 下面每一项说明的是哪类文件。**

    Shell 是脚本中命令的解释器，Linux 系统的 shell 作为操作系统的外壳，为用户提供使用操作系统的接口。它是命令语言、命令解释程序及程序设计语言的统称。shell 是用户和 Linux 内核之间的接口程序，当从 shell 或其他程序向 Linux 传递命令时，内核会做出相应的反应。shell 是一个命令语言解释器，它拥有自己内建的 shell 命令集，shell 也能被系统中其他应用程序所调用。用户在提示符下输入的命令都由 shell 先解释然后传给 Linux 核心。

    ① bash 是 Linux 标准默认的 shell，内部命令一共有 40 个。它可以使用类似 DOS 下面的 doskey 的功能，用方向键查阅和快速输入并修改命令。自动通过查找匹配的方式给出以某字符串开头的命令。包含了自身的帮助功能，你只要在提示符下面键入 help 就可以得到相关的帮助。

    ② sh 是 Unix 标准默认的 shell。

    ③ ash 是 Linux 中 占用系统资源最少的一个小 shell，它只包含 24 个内部命令，因而使用起来很不方便。

    ④ csh 是 Linux 比较大的内核，共有 52 个内部命令。该 shell 其实是指向 /bin/tcsh 这样的一个 shell，也就是说，csh 其实就是 tcsh。

    ⑤ ksh 共有 42 条内部命令。该 shell 最大的优点是几乎和商业发行版的 ksh 完全兼容，这样就可以在不用花钱购买商业版本的情况下尝试商业版本的性能了。

    ![image-20210914100201952](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210914100201952.png)

    目录文件：5、7

    字设备特别文件：3、6

    块设备特别文件：4

    普通文件：1、8

    链接文件：2

