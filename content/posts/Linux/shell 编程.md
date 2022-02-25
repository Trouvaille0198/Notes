# shell 编程

## 认识

### 环境

Shell 编程跟 JavaScript、php 编程一样，只要有一个能编写代码的文本编辑器和一个能解释执行的脚本解释器就可以了。

Linux 的 Shell 种类众多，常见的有：

- Bourne Shell（/usr/bin/sh或/bin/sh）
- Bourne Again Shell（/bin/bash）
- C Shell（/usr/bin/csh）
- K Shell（/usr/bin/ksh）
- Shell for Root（/sbin/sh）
- ……

Bash 是大多数Linux 系统默认的 Shell。

> 在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像 **#!/bin/sh**，它同样也可以改为 **#!/bin/bash**。

```shell
#!/bin/bash
echo "Hello World !"
```

`#!` 告诉系统其后路径所指定的程序即是解释此脚本文件的 Shell 程序。

Shebang（也称为 Hashbang）是一个由井号和叹号构成的字符串行（`#!`），其出现在文本文件的第一行的前两个字符。在文件中存在 Shebang 的情况下，类 Unix 操作系统的程序载入器会分析 Shebang 后的内容，将这些内容作为解释器指令，并调用该指令，并将载有 Shebang 的文件路径作为该解释器的参数

例如, 以指令 `#!/bin/sh` 开头的文件在执行时会实际调用 /bin/sh 程序

### 运行

#### 作为可执行程序

```shell
chmod +x ./test.sh  # 使脚本具有执行权限
./test.sh  # 执行脚本
```

在 linux 中，后缀名几乎是可以任意的或者没有后缀名，一般将 shell 保存为 xxx.sh 是为了看起来更直观

> ./test.sh 若写成 test.sh，系统会去 PATH 里寻找有没有叫 test.sh 的文件，而只有 /bin, /sbin, /usr/bin，/usr/sbin 等在 PATH 里

#### 作为解释器参数

这种运行方式是，直接运行解释器，其参数就是 shell 脚本的文件名

```shell
/bin/sh test.sh
/bin/php test.php
```

这种方式运行的脚本，不需要在第一行指定解释器信息，写了也没用。

## 变量

> 变量名和等号之间不能有空格

### 基本操作

#### 定义

```shell
your_name="Melon"
```

除了显式地直接赋值，还可以用语句给变量赋值，如：

```shell
for file in `ls /etc`
# 或
for file in $(ls /etc)
```

以上语句将 /etc 下目录的文件名循环出来。

#### 使用

使用一个定义过的变量，只要在变量名前面加美元符号即可，如：

```shell
your_name="qinjx"
echo $your_name
echo ${your_name}
```

> 变量名外面的花括号是可选的，加花括号是为了帮助解释器识别变量的边界

#### 只读变量

使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。

下面的例子尝试更改只读变量，结果报错：

```shell
#!/bin/bash
myUrl="https://www.google.com"
readonly myUrl
myUrl="https://www.baidu.com" # 此句将报错
```

报错信息：

```shell
/bin/sh: NAME: This variable is read only.
```

#### 删除变量

使用 unset 命令可以删除变量。

```shell
unset variable_name
```

unset 命令不能删除只读变量。

### 变量类型

运行 shell 时，会同时存在三种变量：

- **局部变量**（用户变量）：局部变量在脚本或命令中定义，仅在当前 shell 实例中有效，其他 shell 启动的程序不能访问局部变量。
- **环境变量**：所有的程序，包括 shell 启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候 shell 脚本也可以定义环境变量。
- **shell 变量**：shell 变量是由 shell 程序设置的特殊变量。shell 变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了 shell 的正常运行

### 数据类型

#### 字符串

##### 单引号

```shell
str='this is a string'
```

单引号字符串的限制：

- 其中任何字符都会原样输出，单引号字符串中的**变量是无效的**；
- 其中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。

##### 双引号

```shell
your_name="Melon"
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str
```

输出结果为：

```
Hello, I know you are "Melon"! 
```

优点：

- 双引号里可以有变量
- 双引号里可以出现转义字符

##### 拼接字符串

```shell
your_name="Melon"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1
# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3
```

输出结果为：

```
hello, Melon ! hello, Melon !
hello, Melon ! hello, ${your_name} !
```

##### 获取字符串长度

```shell
string="abcd"
echo ${#string} # 输出4
```

##### 提取子字符串

以下实例从字符串第 **2** 个字符开始截取 **4** 个字符：

```shell
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

> 第一个字符的索引值为 **0**

##### 查找子字符串

查找字符 **i** 或 **o** 的位置(哪个字母先出现就计算哪个)：

```shell
string="runoob is a great site"
echo `expr index "$string" io`  # 输出4
```

#### 数组

##### 定义

bash 支持一维数组（不支持多维数组），并且没有限定数组的大小

在 Shell 中，用括号来表示数组，数组元素用"空格"符号分割开。定义数组的一般形式为：

```shell
array_name=(value0 value1 value2 value3)
```

或者

```shell
array_name=(
value0
value1
value2
value3
)
```

还可以单独定义数组的各个分量：

```shell
array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen
```

可以不使用连续的下标，而且下标的范围没有限制。

##### 读取数组

读取数组元素值的一般格式是：

```shell
valuen=${array_name[n]}
```

使用 **@** 符号可以获取数组中的所有元素

```shell
echo ${array_name[@]}
# or
echo ${array_name[*]}
```

##### 获取数组的长度

获取数组长度的方法与获取字符串长度的方法相同，例如：

```shell
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```

### 环境变量

## 参数

脚本内获取参数的格式为：**$n**

```shell
#!/bin/bash

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```

```shell
$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

### 参数处理

| 参数处理 | 说明                                                         |
| :------- | :----------------------------------------------------------- |
| `$#`     | 传递到脚本的参数个数                                         |
| `$*`     | 命令行中所有参数。 如 `"$*"` 用「"」括起来的情况、以 `"$1 $2 … $n"` 的形式输出所有参数。 |
| `$$`     | 脚本运行的当前进程 ID 号                                     |
| `$!`     | 后台运行的最后一个进程的 ID 号                               |
| `$@`     | 与 `$*` 相同，但是使用时加引号，并在引号中返回每个参数。 如 `"$@"` 用「"」括起来的情况、以`"$1" "$2" … "$n"` 的形式输出所有参数。 |
| `$-`     | 显示 Shell 使用的当前选项，与 set 命令功能相同。             |
| `$?`     | 显示最后命令的退出状态。0 表示没有错误，其他任何值表明有错误。 |

```shell
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

echo "Shell 传递参数实例！";
echo "第一个参数为：$1";

echo "参数个数为：$#";
echo "传递的参数作为一个字符串显示：$*";
```

执行与输出

```shell
$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
第一个参数为：1
参数个数为：3
传递的参数作为一个字符串显示：1 2 3
```

### `$*` 与 `$@` 区别

```shell
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

echo "-- \$* 演示 ---"
for i in "$*"; do
    echo $i
done

echo "-- \$@ 演示 ---"
for i in "$@"; do
    echo $i
done
```

执行脚本，输出结果如下所示：

```
$ chmod +x test.sh 
$ ./test.sh 1 2 3
-- $* 演示 ---
1 2 3
-- $@ 演示 ---
1
2
3
```

## 操作符

原生 bash 不支持简单的数学运算，但是可以通过其他命令来实现，例如 awk 和 expr

- 原生的**运算式**格式：`$[ 运算式 ]`，注意中括号间用空格隔开

- expr 是一款表达式计算工具，使用它能完成表达式的求值操作。
    - 表达式和运算符之间要有空格，例如 2+2 是不对的，必须写成 2 + 2
    - 完整的表达式要被 `` 包含，注意这个字符不是常用的单引号，在 Esc 键下边。

```shell
# 第1种方式 $(()) 
echo $(((2+3)*4))   

# 第2种方式 $[]，推荐 
echo $[(2+3)*4]  

# 使用 expr 
TEMP=`expr 2 + 3` 
echo `expr $TEMP \* 4`
```

### 字符串比较操作符

| 运算符 | 说明                                         | 举例                       |
| :----- | :------------------------------------------- | :------------------------- |
| =      | 检测两个字符串是否相等，相等返回 true。      | `[ $a = $b ]` 返回 false。 |
| !=     | 检测两个字符串是否不相等，不相等返回 true。  | `[ $a != $b ]` 返回 true。 |
| -z     | 检测字符串长度是否为 0，为 0 返回 true。     | `[ -z $a ]` 返回 false。   |
| -n     | 检测字符串长度是否不为 0，不为 0 返回 true。 | `[ -n "$a" ]` 返回 true。  |
| $      | 检测字符串是否为空，不为空返回 true。        |                            |

### 数字比较操作符

#### 关系运算符

| 运算符 | 说明                                                  | 举例                         |
| :----- | :---------------------------------------------------- | :--------------------------- |
| -eq    | 检测两个数是否相等，相等返回 true。                   | `[ $a -eq $b ]` 返回 false。 |
| -ne    | 检测两个数是否不相等，不相等返回 true。               | `[ $a -ne $b ]` 返回 true。  |
| -gt    | 检测左边的数是否大于右边的，如果是，则返回 true。     | `[ $a -gt $b ]` 返回 false。 |
| -lt    | 检测左边的数是否小于右边的，如果是，则返回 true。     | `[ $a -lt $b ]` 返回 true。  |
| -ge    | 检测左边的数是否大于等于右边的，如果是，则返回 true。 | `[ $a -ge $b ]` 返回 false。 |
| -le    | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | `[ $a -le $b ]` 返回 true。  |

#### expr

```shell
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

a=10
b=20

val=`expr $a + $b`
echo "a + b : $val"

val=`expr $a - $b`
echo "a - b : $val"

val=`expr $a \* $b`
echo "a * b : $val"

val=`expr $b / $a`
echo "b / a : $val"

val=`expr $b % $a`
echo "b % a : $val"

if [ $a == $b ]
then
   echo "a 等于 b"
fi
if [ $a != $b ]
then
   echo "a 不等于 b"
fi
```

> 乘号(*)前边必须加反斜杠(\)才能实现乘法运算

### 文件操作符

| 操作符      | 说明                                                         | 举例           |
| :---------- | :----------------------------------------------------------- | :------------- |
| -b file     | 检测文件是否是**块设备文件**，如果是，则返回 true            | `[ -b $file ]` |
| -c file     | 检测文件是否是**字符设备文件**，如果是，则返回 true          | `[ -c $file ]` |
| **-d file** | 检测文件是否是**目录**，如果是，则返回 true                  | `[ -d $file ]` |
| **-f file** | 检测文件是否是**普通文件**（非目录，非设备文件），若是，则返回 true | `[ -f $file ]` |
| -g file     | 检测文件是否**设置了 SGID 位**，如果是，则返回 true          | `[ -g $file ]` |
| -k file     | 检测文件是否**设置了粘着位 (Sticky Bit)**，如果是，则返回 true | `[ -k $file ]` |
| -p file     | 检测文件是否是**有名管道**，如果是，则返回 true              | `[ -p $file ]` |
| -u file     | 检测文件是否**设置了 SUID 位**，如果是，则返回 true          | `[ -u $file ]` |
| **-r file** | 检测文件是否**可读**，如果是，则返回 true                    | `[ -r $file ]` |
| **-w file** | 检测文件是否**可写**，如果是，则返回 true                    | `[ -w $file ]` |
| **-x file** | 检测文件是否**可执行**，如果是，则返回 true                  | `[ -x $file ]` |
| **-s file** | 检测文件是否**为空**（文件大小是否大于 0），不为空返回 true  | `[ -s $file ]` |
| -e file     | 检测文件（包括目录）是否**存在**，如果是，则返回 true        | `[ -e $file ]` |

其他检查符：

- **-S**：判断某文件是否 socket。
- **-L**：检测文件是否存在并且是一个符号链接。

```shell
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

file="/var/www/runoob/test.sh"
if [ -r $file ]
then
   echo "文件可读"
else
   echo "文件不可读"
fi
if [ -w $file ]
then
   echo "文件可写"
else
   echo "文件不可写"
fi
if [ -x $file ]
then
   echo "文件可执行"
else
   echo "文件不可执行"
fi
if [ -f $file ]
then
   echo "文件为普通文件"
else
   echo "文件为特殊文件"
fi
if [ -d $file ]
then
   echo "文件是个目录"
else
   echo "文件不是个目录"
fi
if [ -s $file ]
then
   echo "文件不为空"
else
   echo "文件为空"
fi
if [ -e $file ]
then
   echo "文件存在"
else
   echo "文件不存在"
fi
```

### 逻辑操作符

| 运算符 | 说明                                                | 举例                                       |
| :----- | :-------------------------------------------------- | :----------------------------------------- |
| !      | 非运算，表达式为 true 则返回 false，否则返回 true。 | `[ ! false ]` 返回 true。                  |
| -o     | 或运算，有一个表达式为 true 则返回 true。           | `[ $a -lt 20 -o $b -gt 100 ]` 返回 true。  |
| -a     | 与运算，两个表达式都为 true 才返回 true。           | `[ $a -lt 20 -a $b -gt 100 ]` 返回 false。 |

| 运算符 | 说明       | 举例                                        |
| :----- | :--------- | :------------------------------------------ |
| &&     | 逻辑的 AND | `[[ $a -lt 100 && $b -gt 100 ]]` 返回 false |
| \|\|   | 逻辑的 OR  | `[[ $a -lt 100 || $b -gt 100 ]]` 返回 true  |

## 循环

### for 语句

#### 一般格式

```shell
for((assignment;condition:next));do
    command_1;
    command_2;
    commond_..;
done;
```

```shell
#!/bin/bash
for((i=1;i<=5;i++));do
    echo "这是第 $i 次调用";
done;
```

#### in

```shell
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

写成一行：

```shell
for var in item1 item2 ... itemN; do command1; command2… done;
```

### while 语句

```shell
while condition
do
    command
done
```

```shell
#!/bin/bash
int=1
while(( $int<=5 ))
do
    echo $int
    let "int++"
done
```

> 以上实例使用了 Bash let 命令，它用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量

#### 读取键盘信息

while 循环可用于读取键盘信息。下面的例子中，输入信息被设置为变量 FILM，按 \<Ctrl-D\>结束循环

```shell
echo '按下 <CTRL-D> 退出'
echo -n '输入你最喜欢的电影名: '
while read FILM
do
    echo "是的！$FILM 是一部好电影"
done
```

#### 无限循环

```shell
while :
do
    command
done
```

或者

```shell
while true
do
    command
done
```

或者

```shell
for (( ; ; ))
```

### util 语句

until 循环执行一系列命令直至条件为 true 时停止。

until 循环与 while 循环在处理方式上刚好相反。

一般 while 循环优于 until 循环，但在某些时候—也只是极少数情况下，until 循环更加有用。

```shell
until condition
do
    command
done
```

condition 一般为条件表达式，如果返回值为 false，则继续执行循环体内的语句，否则跳出循环。

使用 until 命令来输出 0 ~ 9 的数字：

```shell
#!/bin/bash

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done
```

### repeat 语句

repeat 语句用来执行一个只要重复固定次数的语句

```shell
# 显示连字符60次
repeat 60 echo '-'
```

### select 语句

select 语句用来生成一个菜单列表

```shell
select item in itemlist
do
	statement
done
```

```shell
#!/bin/bash
echo "What is your favourite OS?"
select name in "Linux" "Windows" "Mac OS" "UNIX" "Android"
do
    echo $name
done
echo "You have selected $name"
```

### shift 语句

位置参数可以用 `shift` 命令左移。比如 `shift 3` 表示原来的 `$4` 现在变成 `$1`，原来的 `$5` 现在变成 `$2` 等等，原来的 `$1`、`$2`、`$3` 丢弃，`$0` 不移动。不带参数的 `shift` 命令相当于 `shift 1`。

```shell
#!/bin/bash
until [ $# -eq 0 ]
do
	echo "第一个参数为: $1 参数个数为: $#"
	shift
done
```

```shell
执行以上程序x_shift.sh：
$./x_shift.sh 1 2 3 4

第一个参数为: 1 参数个数为: 4
第一个参数为: 2 参数个数为: 3
第一个参数为: 3 参数个数为: 2
第一个参数为: 4 参数个数为: 1
```

## 条件

### if 语句

```shell
a=10
b=20
if [ $a == $b ]
then
   echo "a 等于 b"
elif [ $a -gt $b ]
then
   echo "a 大于 b"
elif [ $a -lt $b ]
then
   echo "a 小于 b"
else
   echo "没有符合的条件"
fi
```

#### if

```shell
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```

写成一行

```shell
if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
```

#### if else

```shell
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```

#### if elif else

```shell
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

### case 语句

**case ... esac** 为多选择语句，与其他语言中的 switch ... case 语句类似，是一种多分枝选择结构

- 每个 case 分支用右圆括号开始
- 用两个分号 **;;** 表示 break，即执行结束，跳出整个 case ... esac 语句
- esac（就是 case 反过来）作为结束标记。

可以用 case 语句匹配一个值与一个模式，如果匹配成功，执行相匹配的命令。

```shell
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```

> 如果无一匹配模式，使用星号 * 捕获该值，再执行后面的命令。

#### 例

```shell
echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```

```shell
#!/bin/sh

site="github"

case "$site" in
   "github") echo "GitHub"
   ;;
   "google") echo "Google 搜索"
   ;;
   "taobao") echo "淘宝网"
   ;;
esac
```

## 杂项语句

### break 和 continue

break命令允许跳出所有循环

```shell
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
            break
        ;;
    esac
done
```

continue 仅仅跳出当前循环

### exit 语句

exit 命令用于退出目前的 shell

若不设置状态值参数，则 shell 以预设值退出。状态值 0 代表执行成功，其他值代表执行失败

## 函数

linux shell 允许用户定义函数，然后在 shell 脚本中可以随便调用。

```shell
[ function ] funname [()]

{

    action;

    [return int;]

}
```

- 可以带 function fun() 定义，也可以直接 fun() 定义，不带任何参数。
- 加 return 返回；如果不加，将以最后一条命令运行结果，作为返回值。 return 后跟数值 n（0-255）

```shell
#!/bin/bash

demoFun(){
    echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demoFun
echo "-----函数执行完毕-----"
```

```shell
#!/bin/bash

funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"
```

> 所有函数在使用前必须定义。这意味着必须将函数放在脚本开始部分，直至shell解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。

### 函数参数

在Shell中，调用函数时可以向其传递参数。在函数体内部，通过 `$n` 的形式来获取参数的值，例如，`$1` 表示第一个参数，`$2` 表示第二个参数...

```shell
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```

输出

```shell
第一个参数为 1 !
第二个参数为 2 !
第十个参数为 10 !
第十个参数为 34 !
第十一个参数为 73 !
参数总数有 11 个!
作为一个字符串输出所有参数 1 2 3 4 5 6 7 8 9 34 73 !
```

注意，`$10` 不能获取第十个参数，获取第十个参数需要`${10}`。当 n>=10 时，需要使用 `${n}` 来获取参数。

## 常用命令

### echo

#### 显示普通字符串:

```shell
echo "It is a test"
```

这里的双引号完全可以省略

```shell
echo It is a test
```

#### 显示转义字符

```shell
echo "\"It is a test\""
```

结果将是:

```shell
"It is a test"
```

同样，双引号也可以省略

#### 显示变量

read 命令从标准输入中读取一行,并把输入行的每个字段的值指定给 shell 变量

```shell
#!/bin/sh
read name 
echo "$name It is a test"
```

以上代码保存为 test.sh，name 接收标准输入的变量，结果将是:

```shell
[root@www ~]# sh test.sh
OK                     #标准输入
OK It is a test        #输出
```

#### 显示换行

```shell
echo -e "OK! \n"  # -e 开启转义
echo "It is a test"
```

输出结果：

```shell
OK!

It is a test
```

#### 显示不换行

```shell
#!/bin/sh
echo -e "OK! \c" # -e 开启转义 \c 不换行
echo "It is a test"
```

输出结果：

```shell
OK! It is a test
```

#### 显示结果定向至文件

```shell
echo "It is a test" > myfile
```

#### 原样输出字符串，不进行转义或取变量(用单引号)

```shell
echo '$name\"'
```

输出结果：

```
$name\"
```

#### 显示命令执行结果

```shell
echo `date`
```

> 这里使用的是反引号 **`**, 而不是单引号 **'**

结果将显示当前日期

```
Sun 24 Oct 2021 08:44:45 PM CST
```

### printf

printf 命令模仿 C 程序库（library）里的 printf() 程序。

- printf 使用引用文本或空格分隔的参数
- 默认的 printf 不会像 echo 自动添加换行符

```
printf  format-string  [arguments...]
```

参数

- *format-string*：格式控制字符串
- *arguments*：参数列表

```shell
$ echo "Hello, Shell"
Hello, Shell

$ printf "Hello, Shell\n"
Hello, Shell
```

#### 格式化

```shell
#!/bin/bash
 
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876
```

执行脚本，输出结果如下所示：

```
姓名     性别   体重kg
郭靖     男      66.12
杨过     男      48.65
郭芙     女      47.99
```

**%s %c %d %f** 都是格式替代符

- **％s** 输出一个字符串
- **％d** 整型输出
- **％c** 输出一个字符
- **％f** 输出实数，以小数形式输出。

**%-10s** 指一个宽度为 10 个字符（ **-** 表示左对齐，没有则表示右对齐），任何字符都会被显示在 10 个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。

**%-4.2f** 指格式化为小数，其中 **.2** 指保留 2 位小数。

#### 多种格式

```shell
#!/bin/bash
 
# format-string 为双引号
printf "%d %s\n" 1 "abc"

# 单引号与双引号效果一样
printf '%d %s\n' 1 "abc"

# 没有引号也可以输出
printf %s abcdef

# 格式只指定了一个参数，但多出的参数仍然会按照该格式输出，format-string 被重用
printf %s abc def

printf "%s\n" abc def

printf "%s %s %s\n" a b c d e f g h i j

# 如果没有 arguments，那么 %s 用 NULL代替，%d 用 0 代替
printf "%s and %d \n"
```

输出

```
1 abc
1 abc
abcdefabcdefabc
def
a b c
d e f
g h i
j  
 and 0
```

#### 转义序列

| 序列  | 说明                                                         |
| :---- | :----------------------------------------------------------- |
| \a    | 警告字符，通常为ASCII的BEL字符                               |
| \b    | 后退                                                         |
| \c    | 抑制（不显示）输出结果中任何结尾的换行字符（只在 %b 格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略 |
| \f    | 换页（formfeed）                                             |
| \n    | 换行                                                         |
| \r    | 回车（Carriage return）                                      |
| \t    | 水平制表符                                                   |
| \v    | 垂直制表符                                                   |
| \\    | 一个字面上的反斜杠字符                                       |
| \ddd  | 表示1到3位数八进制值的字符。仅在格式字符串中有效             |
| \0ddd | 表示1到3位的八进制值字符                                     |

## 输入 / 输出重定向

大多数 UNIX 系统命令从你的终端接受输入并将所产生的输出发送回到您的终端。

一个命令通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是你的终端。

同样，一个命令通常将其输出写入到标准输出，默认情况下，这也是你的终端。

重定向命令列表如下：

| 命令            | 说明                                               |
| :-------------- | :------------------------------------------------- |
| command > file  | 将输出重定向到 file。                              |
| command < file  | 将输入重定向到 file。                              |
| command >> file | 将输出以追加的方式重定向到 file。                  |
| n > file        | 将文件描述符为 n 的文件重定向到 file。             |
| n >> file       | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
| n >& m          | 将输出文件 m 和 n 合并。                           |
| n <& m          | 将输入文件 m 和 n 合并。                           |
| << tag          | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |
