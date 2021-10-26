# 实验六

## 实验步骤

### 第一题

1. **三种工作方式各用在何时？**

    正常模式（转义命令模式）用于浏览文件、复制粘贴等操作

    命令模式（末行命令模式）用于执行一些特殊指令，如查找、定位等 	

    插入模式用于编辑文件

2. **用什么命令进入插入方式？**

    在命令模式下按下 `i` 就进入了插入模式

3. **怎样退出插入方式？**

    按 `<Esc>` 键进入正常模式

4. **文件怎样存盘？**

    `wq`：表示保存退出

    `wq!`：表示强制保存退出

    `x`：表示保存退出

### 第四题

显示参数个数、程序名字，并逐个显示参数

```shell
#!/bin/bash
# Name display program
echo "The program's name is $0"
if [ $# == 0 ]
then
    echo "Parameter not provided"
else
    echo "The number of parameters is $#"
    echo "Params are: $@"
fi
```

输出

```
$ ./t4.sh 1 2 3 4

The program's name is ./t4.sh
The number of parameters is 4
Params are: 1 2 3 4
```

### 第五题

用 read 命令接受键盘输入，用一个 while 循环来接受键盘输入

```shell
#!/bin/bash
echo "Type sth"
while read param
do
    if [ -z "$param" ] # 判断param是否为空串
    then 
        echo "You type nothing"
    else
        echo "Param you typed is $param"
    fi
done
```

输出

```
$ ./t5.sh

Type sth
hello
Param you typed is hello

You type nothing
```

### 第七题

在程序运行时随机输入字符串，进行字符串的比较

```shell
#!/bin/bash

compare(){
    string1=$1
    string2=$2
    if [ $string1 = $string2 ]
    then
        echo "string1 equal to string2"
    else
        echo "string1 not equal to string2"
    fi

    if [ $string1 ]
    then
        echo "string1 not empty"
    else
        echo "string1 is empty"
    fi

    if [ -n $string2 ]
    then 
        echo "string2 has a length greater than zero"
    else
        echo "string2 has a length equal to zero"
    fi
}



while [ 1 ]
do
    echo "Input str1: "
    read str1
    echo "Input str2: "
    read str2
    compare $str1 $str2
done
```

- 可以将字符比较逻辑封装到一个函数中
- 注意，函数参数不用写在定义里

### 第八题

随机输入文件名，然后进行文件属性判断

```shell
#!/bin/bash


compare(){
    dir=$1
    file=$2
    if [ -d $dir ]
    then
        echo "dir is a directory"
    else
        echo "dir is not a directory"
    fi

    if [ -f $file ]
    then 
        echo "file is a regular file"
    else
        echo "file is not a regular file"
    fi

    if [ -r $file ]
    then
        echo "file has read permissions"
    else
        echo "file does not have read permissions"
    fi

    if [ -w $file ]
    then
        echo "file has write permissions"
    else
        echo "file does not have write permissions"
    fi

    if [ -x $dir ]
    then
        echo "dir has execute permissions"
    else
        echo "dir does not have execute permissions"
    fi
}

while [ 1 ]
do
    echo "Input dir name: "
    read dir
    echo "Input file name: "
    read file
    compare $dir $file
done
```

### 第十一题

显示用户主目录名，命令搜索路径

> 什么叫 “显示由位置参数指定的文件类型和操作权限”？

```shell
#!/bin/bash

# 用户主目录
home=~
echo "HOME is $home"

# 环境变量
IFS=$IFS':'
IFS=':' # 将":"视为分隔符
echo "PATH are: "
for folder in $PATH
do
  echo "    $folder:"
done

judge_file_type(){
    if [ -d $1 ]
    then
        echo "$1 is a directory"
    else
        echo "$1 is not a directory"
    fi

    if [ -f $1 ]
    then 
        echo "$1 is a regular file"
    else
        echo "$1 is not a regular file"
    fi
}

judge_file_permission(){
    if [ -r $1 ]
    then
        echo "$1 has read permissions"
    else
        echo "$1 does not have read permissions"
    fi

    if [ -w $1 ]
    then
        echo "$1 has write permissions"
    else
        echo "$1 does not have write permissions"
    fi

    if [ -x $1 ]
    then
        echo "$1 has execute permissions"
    else
        echo "$1 does not have execute permissions"
    fi
}


for filename in $@
do
    echo "checking $filename..."
    if [ -e $filename ]
    then
        judge_file_type $filename
        judge_file_permission $filename
    else
        echo "$filename does not exist"
    fi
done
```

输出

```shell
$ ./t11.sh t4.sh t8.sh abc
HOME is /home/ubuntu
PATH are: 
    /home/ubuntu/.vscode-server/bin/6cba118ac49a1b88332f312a8f67186f7f3c1643/bin:
    /home/ubuntu/.local/bin:
    /home/ubuntu/.vscode-server/bin/6cba118ac49a1b88332f312a8f67186f7f3c1643/bin:
    /usr/local/sbin:
    /usr/local/bin:
    /usr/sbin:
    /usr/bin:
    /sbin:
    /bin:
    /usr/games:
    /usr/local/games:
checking t4.sh...
t4.sh is not a directory
t4.sh is a regular file
t4.sh has read permissions
t4.sh has write permissions
t4.sh has execute permissions
checking t8.sh...
t8.sh is not a directory
t8.sh is a regular file
t8.sh has read permissions
t8.sh has write permissions
t8.sh has execute permissions
checking abc...
abc does not exist
```

## 讨论

### 第一题

1. **Linux 的 shell 有什么特点？**

    Shell 是一种弱类型的脚本语言，需要一个能解释执行的脚本解释器

    Shell 提供了顺序流程控制、条件控制、循环控制等功能，可以把已有命令组合构成新的命令

    Shell 提供了许多内置命令，不需要创建新的进程

### 第二题

2. **怎样进行 shell 编程？如何运行？有什么条件？**

    Shell 编程只要有一个能编写代码的文本编辑器和一个能解释执行的脚本解释器就可以进行

    运行 shell 脚本前，需要设置脚本的运行权限

    ```shell
    chmod +x ./test.sh  # 使脚本具有执行权限
    ./test.sh  # 执行脚本
    ```

    或者作为解释器的一个参数运行解释器

    ```shell
    /bin/sh test.sh
    ```

    shell 脚本的后缀名几乎是可以任意的或者没有后缀名，一般命名为 xxx.sh 是为了看起来更直观

### 第三题

**vi 编辑程序有几种工作方式？查找有关的详细资料，熟练掌握屏幕编辑方式、转移命令方式以及末行命令的操作。学习搜索、替换字符、字和行，行的复制、移动以及在 vi 中执行 Shell 命令的方式**

#### 工作方式

**正常模式**（Normal-mode)

正常模式一般用于浏览文件，也包括一些复制、粘贴、删除等操作

**插入模式**（Insert-mode)

在命令模式下按下 `i` 就进入了插入模式，进入编辑状态，通过键盘输入内容

**可视模式**（Visual-mode）

在正常模式按下 `v, V, <Ctrl>+v`，可以进入可视模式。

可视模式中的操作有点像拿鼠标进行操作，选择文本的时候有一种鼠标选择的即视感，有时候会很方便

#### 操作

**命令操作整理**：https://trouvaille0198.github.io/Notes/%E6%95%88%E7%8E%87%E5%B7%A5%E5%85%B7/Vim.html

#### 在 vi 中执行 shell 命令

`:!command`

`:r !command`（将命令结果插入到当前行的下一行）

### 第四题

**编写一个具有以下功能的 Shell 程序**

1. 把当前目录下的文件目录信息输出到文件 filedir.txt 中；
2. 在当前目录下建立一个子目录，目录名为 testdir2 ；
3. 把当前目录下的所有扩展名为 c 的文件以原文件名复制到子目录 testdir2 中；
4. 把子目录中的所有文件的存取权限改为不可读。（提示：用 for 循环控制语句实现，循环的控制列表用 ’ls’ 产生。）
5. 再把子目录 testdir2 中所有文件的目录信息追加到文件 filedir.txt 中；
6. 把你的用户信息追加到文件 filedir.txt 中；
7. 分屏显示文件 filedir.txt

```shell
#!/bin/bash

# 创建filedir.txt
if [ -f "filedir.txt" ]
then
    rm -f filedir.txt
fi
touch filedir.txt

# 把当前目录下的文件目录信息输出到文件 filedir.txt 中 
echo "current files: " >> filedir.txt
ls -l >> filedir.txt

# 创建testdir2
if [ -d "testdir2" ]
then
    rm -rf testdir2
fi
mkdir testdir2

# 把当前目录下的所有扩展名为c的文件以原文件名复制到子目录testdir2中
cp ./*c testdir2/

# 把子目录中的所有文件的存取权限改为不可读
for filename in `ls testdir2`
do
    chmod -r "testdir2/$filename"
done
# echo "Check file permissions"
# ls -lh testdir2/

# 把子目录testdir2中所有文件的目录信息追加到文件filedir.txt中
echo -e "\nfiles in testdir2: " >> filedir.txt
ls -l testdir2/ >> filedir.txt


# 把用户信息追加到文件 filedir.txt 中
echo -e "\nUser info: " >> filedir.txt
who -a >> filedir.txt

# 分页显示
cat filedir.txt | less
```

