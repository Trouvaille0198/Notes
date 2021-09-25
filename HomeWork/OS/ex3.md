# ex3

https://wenku.baidu.com/view/126ff5c473fe910ef12d2af90242a8956becaa1f.html

## 函数详解

### fork()

创建一个子进程

返回

- 在子进程中，返回 0
- 在父进程中，返回新创建子进程的进程 ID
- 创建失败则返回 -1

### wait()

```c
pid_t wait(int *stat_loc); // 获取子进程退出状态并返回死掉的子进程ID
```

父进程调用 `wait()` 后，将发生堵塞，直到它的一个子进程退出或收到信号为止

- 如果只有一个子进程被终止，那么 `wait()` 返回被终止的子进程的进程 ID。
- 如果多个子进程被终止，那么 `wait()` 将获取任意子进程的进程 ID

子进程可能由于以下原因而终止：

- 调用 `exit()`；
- 接收到 main 进程的 return 值；
- 接收一个信号（来自操作系统或另一个进程），该信号的默认操作是终止。

![](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20210209165024692.png)

父进程调用 `wait()` 时传一个整型变量地址给函数。内核将子进程的退出状态保存在这个变量中。

- 如果子进程调用 `exit()` 退出，那么内核把 `exit()` 的返回值存放到这个整数变量中；
- 如果进程是被杀死的，那么内核将**信号序号**存放在这个变量中。
- 这个整数由 3 部分组成，8 个 bit 记录子进程 `exit()` 值，7 个 bit 记录信号序号，另一个 bit 用来指明发生错误并产生了内核映像（core dump）
- 如果进程没有子进程，那么 `wait()` 返回 `-1`

```c
// C program to demonstrate working of wait() 
#include<stdio.h>
#include<stdlib.h>
#include<sys/wait.h>
#include<unistd.h>

int main()
{
    pid_t cpid;
    int status;
    int high_8, low_7, bit_7;

    if (fork()== 0)
    {   
        printf("this is child process, the id is %d\n", getpid());
        exit(18);                                       /* terminate child */
    }
    else
    {
        printf("status is %d\n", status);
        cpid = wait(&status);                           /* reaping parent */
        high_8 = status >> 8;                           /* 1111 1111 0000 0000 */
        low_7  = status & 0x7F;                         /* 0000 0000 0111 1111 */
        bit_7  = status & 0x80;                         /* 0000 0000 1000 0000 */

        printf("status is %d\n", status);
        printf("high_8 is %d, low_7 is %d, bit_7 is %d\n", high_8, low_7, bit_7);
    }
    printf("Parent pid = %d\n", getpid()); 
    printf("Child pid = %d\n", cpid); 
  
    return 0; 
}
```

输出

```text
status is 0
this is child process, the id is 5412
status is 4608
high_8 is 18, low_7 is 0, bit_7 is 0
Parent pid = 5411
Child pid = 5412
```

### setbuf()

```c
void setbuf(FILE *stream, char *buffer)
```

定义流 stream 应如何缓冲。该函数应在与流 stream 相关的文件被打开时，且还未发生任何输入或输出操作之前被调用一次。

### perror()

```c
void perror ( const char * str );
```

头文件 `#include<stdio.h>`

将上一个函数发生错误的原因输出到标准设备

### exec

头文件 `<unistd.h>`

#### execl()

```c
int execl(const char *path, const char *arg, ...);
```

参数

- *path*：要启动程序的名称，包括路径名

- *arg*：启动程序所带的参数，一般第一个参数为要执行命令名，不是带路径且 arg 必须以 NULL 结束（`(char *)0)` 也可）

返回值

- 成功返回 0，失败返回 -1

```c
execl("/bin/ls", "ls", "-l", NULL);
```

#### execlp()

多了个 p，表示第一个参数 path 不用输入完整路径，只有给出命令名即可，它会在环境变量 PATH 当中查找命令

```c
execlp("ls", "ls", NULL);
```

### 宏

`WEXITSTATUS(status)`：子级退出时的返回代码

### 管道操作

头文件 `#include<unistd.h>`

#### pipe()

```c
int pipe(int fd[2]);
```

用于创建一个管道，以实现进程间的通信

参数

- *fd*：大小为 2 的一个数组类型的指针

返回

- 成功时返回 0，并将一对打开的文件描述符值填入 fd 参数指向的数组
- 失败时返回 -1 并设置 errno

通过 pipe 函数创建的这两个文件描述符 fd[0] 和 fd[1] 分别构成管道的两端，往 fd[1] 写入的数据可以从 fd[0] 读出。并且 fd[1] 一端只能进行写操作，fd[0] 一端只能进行读操作，不能反过来使用。要实现双向数据传输，可以使用两个管道。

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/20190109183935451.png" style="zoom: 50%;" />

#### wirte()

```c
char buf[] = "I am mike";
// 往管道写端写数据
write(fd[1], buf, strlen(buf));
```

#### read()

```c
char str[50] = {0};
// 从管道里读数据
read(fd_pipe[0], str, sizeof(str));
```

#### lockf()

```c
int lockf(int fd, int cmd, off_t len);
```

参数

- *fd*：打开文件的文件描述符
- *cmd*：指定要采取的操作的控制值
    - \# define F_ULOCK 0 //解锁
    - \# define F_LOCK 1 //互斥锁定区域
    - \# define F_TLOCK 2 //测试互斥锁定区域
    - \# define F_TEST 3 //测试区域
- *len*：要锁定或解锁的连续字节数

## 第一题

显示进程标识、组标识、用户标识

```c
#include <stdio.h>
#include <unistd.h>

int main()
{
    printf("Pid: %d.\n", getpid());
    printf("Gid: %d.\n", getgid());
    printf("Uid: %d.\n", getuid());
}
```

输出

```text
Pid: 1075
Gid: 1000
Uid: 1000
```

## 第二题

创建子进程

### 实现

```c
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
main()
{
    int i;
    if (fork())
    {
        i = wait();
        printf("It's a parent process.\n");
        printf("The child process, ID number %d, is finished.\n", i);
    }
    else
    {
        printf("It's a child process.\n");
        sleep(10);
        exit(i);
    }
}
```

输出：

```test
It's a child process.
It's a parent process.
The child process, ID number -1, is finished.
```

### 思考

**子进程是如何产生的？ 又是如何结束的？**

父进程调用 `fork()` 来创建子进程，此时两个进程同时进行；

- 在父进程中，`fork()` 返回子进程的 pid，故运行 `if` 语句内的代码块，`wait()` 函数使父进程阻塞（直到子进程结束）并且返回子进程 pid；
- 在子进程中，`fork()` 返回 0，故运行 `else` 语句内的代码块，`exit()` 函数终止子进程
- 父进程收到子进程结束的信号后，继续执行剩余的代码段

**子进程被创建后它的运行环境是怎样建立的？** 

`fork()` 调用后，内核会为子进程分配对应的虚拟内存空间，同时它的正文段，数据段，堆栈端都是指向了父进程的物理空间，实现物理空间共享，并且内容可读，一旦某个进程修改这个共享的物理空间的内容，就会复制到子进程自己的物理空间。

## 第三题

循环创建子进程

### 实现

```c
#include <unistd.h>
int main()
{
    int i, j, status;
    printf("My pid is %d, my father’s pid is % d\n", getpid(), getppid());
    for (i = 0; i < 3; i++)
        if (fork())
        {
            j = wait(&status);
            printf("Pid %d: The child %d is finished.\n", getpid(), j);
        }
        else
        {
            printf("Loop %d: pid = %d ppid = %d\n", i + 1, getpid(), getppid());
            exit(0); //如果只想通过循环建立三个子进程，加上这句话
        }
}
```

输出结果：

```c
My pid is 9690, my father’s pid is  296
Loop 1: pid = 9691 ppid = 9690
Pid 9690: The child 9691 is finished.
Loop 2: pid = 9692 ppid = 9690
Pid 9690: The child 9692 is finished.
Loop 3: pid = 9693 ppid = 9690
Pid 9690: The child 9693 is finished.
```

### 思考

**画出进程家族树**

> ```text
> 296───9690─┬─9691─┬─9692───9693
> 		   │      └─9694       
> 		   ├─9695───9696
> 		   │	  
> 		   └─9697	  		  
> ```

```text
296───9690─┬─9691
           │            
           ├─9692
           │	  
           └─9693
```

**子进程的运行环境是怎样建立的？**

（TBD）`fork()` 调用后，内核会为子进程分配对应的虚拟内存空间，同时它的正文段，数据段，堆栈端都是指向了父进程的物理空间，实现物理空间共享，并且内容可读，一旦某个进程修改这个共享的物理空间的内容，就会复制到子进程自己的物理空间。

**反复运行此程序会出现什么情况？**

进程号将递增

原因：（TBD）Linux 有缓存机制

**修改程序，是运行结果呈单分支结构**

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
int main()
{
    int i, j, status;
    printf("My pid is %d, my father’s pid is % d\n", getpid(), getppid());
    i = 0;
    for (i = 0; i < 3; i++)
    {
        if (fork())
        {
            j = wait(&status);
            i = WEXITSTATUS(status);
            printf("Pid %d: The child %d is finished.\n", getpid(), j);
        }
        else
        {
            printf("Loop %d: pid = %d ppid = %d\n", i + 1, getpid(), getppid());
        }
    }
    exit(i);
}
```

输出

```text
My pid is 9690, my father’s pid is  296
Loop 1: pid = 9691 ppid = 9690
Loop 2: pid = 9692 ppid = 9691
Loop 3: pid = 9693 ppid = 9692
Pid 9692: The child 29003 is finished.
Pid 9691: The child 29002 is finished.
Pid 9690: The child 29001 is finished.
```

进程树

```text
296───9690───9691───9692───9693
```

解释：

- `exit(i);` 语句使得子进程结束时，将循环次数标志 `i` 返回

- `i = WEXITSTATUS(status);` 接收了子进程的 `i` 值，帮助父进程跳出循环

## 第四题

子进程系统调用执行不同程序

### 实现

```c
#include <stdio.h>
#include <unistd.h>

int main()
{
    int childPid1, childPid2, childPid3;
    int pid, status;
    setbuf(stdout, NULL);
    // 创建子进程1
    childPid1 = fork();
    if (childPid1 == 0)
    // 运行子进程1的内容
    {
        execlp("echo", "echo", "Child process 1 is running~", NULL); // 启动其他程序
        perror("exec1 error.\n");
        exit(1);
    }
    // 创建子进程2
    childPid2 = fork();
    if (childPid2 == 0)
    // 运行子进程2的内容
    {
        execlp("date", "date", NULL); // 启动其他程序
        perror("exec2 error.\n");
        exit(2);
    }
    // 创建子进程3
    childPid3 = fork();
    if (childPid3 == 0)
    // 运行子进程2的内容
    {
        execlp("ls", "ls", "-l", NULL); // 启动其他程序
        perror("exec3 error.\n");
        exit(3);
    }
    puts("Parent process is waiting for child process return!");
    while ((pid = wait(&status)) != -1) // 等待子进程结束
    {
        if (childPid1 == pid)
            // 若子进程1结束
            printf("Child process 1 terminated with status %d\n", (status >> 8));
        else if (childPid2 == pid)
            // 若子进程2结束
            printf("Child process 2 terminated with status %d\n", (status >> 8));
        else if (childPid3 == pid)
            // 若子进程3结束
            printf("Child process 3 terminated with status %d\n", (status >> 8));
        else
            printf("Wrong!\n");
    }
    puts("All child processes terminated.");
    puts("Parent proccess terminated.");
    exit(0);
}

```

输出：

```text
Parent process is waiting for child process return!
Child process 1 is running~
Sat Sep 25 13:18:42 CST 2021
Child process 1 terminated with status 0
Child process 2 terminated with status 0
total 40
-rw-r--r-- 1 loulou loulou   176 Sep 24 15:25 t1.c
-rw-r--r-- 1 loulou loulou   377 Sep 24 15:25 t2.c
-rw-r--r-- 1 loulou loulou   505 Sep 24 17:38 t3.c
-rw-r--r-- 1 loulou loulou   552 Sep 24 17:44 t3_1.c
-rw-r--r-- 1 loulou loulou  1606 Sep 25 13:18 t4.c
-rwxr-xr-x 1 loulou loulou 17040 Sep 25 13:18 t4.o
Child process 3 terminated with status 0
All child processes terminated.
Parent proccess terminated.
```

### 思考

**子进程运行其他程序后，进程运行环境怎样变化？**

子进程运行其他程序后，此进程被程序替代，因此进程号不会改变

**反复运行程序的情况？**

输出次序**不确定**，因为三个子进程异步运行，具有不确定性

## 第五题

子进程继承父进程

### 实现

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
int global = 4;
void main()
{
    pid_t pid;
    int vari = 5;
    printf("Before fork.\n");
    if ((pid = fork()) < 0)
    // 若创建失败
    {
        printf("Fork error!\n");
        exit(0);
    }
    else if (pid == 0)
    // 子进程执行
    {
        global++;
        vari--;
        printf("Child %d changed the vari and gobal.\n", getpid());
    }
    else
    // 父进程执行
    {
        printf("Parent %d did not changed the vari and global.\n", getpid());
    }
    printf("pid=%d, global=%d, vari=%d\n", getpid(), global, vari);
    exit(0);
}
```

输出

```text
Before fork.
Parent 1463 did not changed the vari and global.
pid=1463, global=4, vari=5
Child 1464 changed the vari and gobal.
pid=1464, global=5, vari=4
```

### 思考

**子进程被创建后，对父进程的运行环境有影响吗？**

没有影响。子进程在创建时，从父进程复制了代码段与数据段，相互独立。

## 第六题

父进程创建两个子进程，父子之间利用管道进行通信

### 实现

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
void main()
{
    int i, r, j, k, l, p1, p2, fd[2];
    char buf[50], s[50];
    pipe(fd);                   // 建立一个管道fd
    while ((p1 = fork()) == -1) // 创建子进程1
        ;
    if (p1 == 0)
    // 子进程1执行
    {
        lockf(fd[1], 1, 0); // 管道写入端加锁
        sprintf(buf, "Child process p1 is sending messages!\n");
        printf("Child process p1!\n");
        write(fd[1], buf, 50); // 写入管道
        lockf(fd[1], 0, 0);    // 管道写入端解锁
        sleep(4);
        j = getpid();
        k = getppid();
        printf("P1 %d is waken up. My parent procees ID is %d.\n", j, k);
        exit(0);
    }
    else
    {
        while ((p2 = fork()) == -1)
            ;
        if (p2 == 0)
        {
            lockf(fd[1], 1, 0); // 管道写入端加锁
            sprintf(buf, "Child process p2 is sending messages!\n");
            printf("Child process p2!\n");
            write(fd[1], buf, 50); // 写入管道
            lockf(fd[1], 0, 0);    // 管道写入端解锁
            sleep(4);
            j = getpid();
            k = getppid();
            printf("P2 %d is waken up. My parent procees ID is %d.\n", j, k);
            exit(0);
        }
        else
        {
            l = getpid();
            wait(0); // 父进程等待被唤醒
            if ((r = read(fd[0], s, 50)) == -1)
                printf("Can't read pipe.\n");
            else
                printf("Parent %d: %s \n", l, s);
            wait(0);
            if ((r = read(fd[0], s, 50)) == -1)
                printf("Can't read pipe.\n");
            else
                printf("Parent %d: %s \n", l, s);
            exit(0);
        }
    }
}
```

输出：

```text
Child process p1!
Child process p2!
P1 2186 is waken up. My parent procees ID is 2185.
P2 2187 is waken up. My parent procees ID is 2185.
Parent 2185: Child process p1 is sending messages!
 
Parent 2185: Child process p2 is sending messages!
 
```

### 思考

**什么是管道？**

能够连接一个写进程和一个读进程，并允许他们能够互相通信的一个共享文件

**进程如何利用管道进行通信？**

用写进程从管道的入端将数据写入管道，用读进程从管道的出端读取数据

**修改睡眠时机、睡眠长度，会有什么变化？**

进程唤醒的时间会被改变。因为睡眠时机、睡眠长度影响进程开始与结束时间

**加锁、解锁起什么作用？不用它行吗？**

加锁、解锁避免资源共享冲突问题，不用它会导致数据读写发生冲突

## 第七题

（TBD）

### 实现

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
void main()
{
    int i, r, j, k, l, p1, p2, fd[2];
    char buf[50], s[50];
    pipe(fd);           // 建立一个管道fd
    lockf(fd[1], 1, 0); // 管道写入端加锁
    sprintf(buf, "Parent process is sending messages!\n");
    printf("Parent process!\n");
    write(fd[1], buf, 50); // 写入管道
    lockf(fd[1], 0, 0);    // 管道写入端解锁

    while ((p1 = fork()) == -1) // 创建子进程1
        ;
    if (p1 == 0)
    // 子进程1执行
    {
        l = getpid();
        if ((r = read(fd[0], s, 50)) == -1)
            printf("Can't read pipe.\n");
        else
            printf("Child %d: %s \n", l, s);
        sleep(5);
        printf("Child process terminated!");
        exit(0);
    }
    else
    // 父进程
    {
        printf("Parent process terminated!");
        exit(0);
    }
}
```

输出

```text
Parent process!
Child 2542: Parent process is sending messages!
Parent process terminated! 
Child process terminated!
```

### 思考

**系统如何处理孤儿进程？**

孤儿进程将被 init 进程(进程号为 1)所收养，并由 init 进程对它们完成状态收集工作

## 第八题

客户进程向服务器进程发出信号，服务器进程接受作出应答，再向客户返回消息

### 思考

服务者程序和客户程序还可以利用 socket 进行通信

## 第九题

父进程设定软中断信号处理程序，向子进程发软中断信号；子进程收到信号后执行相应处理程序。

### 实现

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main()
{
    int i, j, k;
    int func();
    signal(18, func()); // 设置18号信号的处理程序
    if (i = fork())
    // 父进程
    {
        j = kill(i, 18); // 向子进程发送信号

        printf("Parent: signal 18 has been sent to child %d,returned %d.\n", i, j);
        k = wait(0);
        printf("After wait %d,Parent %d: finished.\n", k, getpid());
    }
    else
    // 子进程
    {
        sleep(10);
        printf("Child %d: A signal from my parent is received.\n", getpid());
    }
}

func() /*处理程序*/
{
    int m;
    m = getpid();
    printf("I am Process %d: This is signal 18 processing function.\n", m);
}
```

输出

```text
I am Process 4465: This is signal 18 processing function.
Parent: signal 18 has been sent to child 4466,returned 0.
After wait 4466,Parent 4465: finished.
```

### 思考

**软中断与硬中断有什么区别？**

硬中断由外部硬件产生，软中断由执行中断指令产生的

## 第十题

用信号量机制编写一个解决生产者——消费者问题的程序

## 研究并讨论

