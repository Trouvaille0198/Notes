---
draft: true
---

# 实验三

第八组  19120198  孙天野

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
    printf("Pid: %d\n", getpid());
    printf("Gid: %d\n", getgid());
    printf("Uid: %d\n", getuid());
    sleep(2);
    char ch;
    while (1)
    {
        printf("quit? [Y/N]\n");
        fflush(stdin);
        scanf("%c", &ch);
        if (ch == 'Y' || ch == 'y')
        {
            break;
        }
    }
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
int main()
{
    int status;
    int ppid;
    if (fork())
    {
        pid = wait(&status);
        printf("It's a parent process.\n");
        printf("The child process, ID number %d, is finished.\n", pid);
    }
    else
    {
        printf("It's a child process.\n");
        sleep(2);
        exit(0);
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

父进程**调用 `fork()` 来创建子进程**，此时两个进程同时进行；

- 在父进程中，`fork()` 返回子进程的 pid，故运行 `if` 语句内的代码块，`wait()` 函数使父进程阻塞（直到子进程结束）并且返回子进程 pid；
- 在子进程中，`fork()` 返回 0，故运行 `else` 语句内的代码块，**`exit()` 函数终止子进程**
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

```text
296───9690─┬─9691─┬─9692───9693
		   │      └─9694       
		   ├─9695───9696
		   │	  
		   └─9697	  		  
```

**子进程的运行环境是怎样建立的？**

父进程调用`fork()` 后，内核会为子进程分配对应的虚拟内存空间。

**反复运行此程序会出现什么情况？**

进程号在递增

原因：Linux 的缓存机制。但是 pid 不会一直递增下去，通常在 `/proc/sys/kernel/pid_max` 里会存储一个最大值；如果达到这个最大值，系统会重复使用较小的 pid

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

三个子进程结束的顺序不确定；尽管子进程的开始顺序是写死在代码里的，它们的结束顺序却由程序运行时间所决定

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
        printf("Parent %d did not change the vari and global.\n", getpid());
    }
    printf("pid=%d, global=%d, vari=%d\n", getpid(), global, vari);
    exit(0);
}
```

输出

```text
Before fork.
Parent 1463 did not change the vari and global.
pid=1463, global=4, vari=5
Child 1464 changed the vari and gobal.
pid=1464, global=5, vari=4
```

### 思考

**子进程被创建后，对父进程的运行环境有影响吗？**

没有影响。子进程在创建时，从父进程复制了代码段与数据段，相互独立。可以看到子进程的局部变量和全局变量修改后，父进程并没有发生相应的改动

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

父子进程利用管道通信；父进程撤销进程，先于子进程结束

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
        exit(0); // 撤销父进程
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

孤儿进程将被 init 进程（进程号为 1）所收养，并由 init 进程对它们完成状态收集工作

## 第八题

客户进程向服务器进程发出信号，服务器进程接受作出应答，再向客户返回消息

### Client

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#define MSGKEY 75
struct msgform
{
    long mtype;
    char mtext[256];
} msg;

void main()
{
    struct msgform msg;
    int msgqid, pid, *pint;

    msgqid = msgget(MSGKEY, 0777);
    pid = getpid();
    pint = (int *)msg.mtext;
    *pint = pid;
    msg.mtype = 1;
    msgsnd(msgqid, &msg, sizeof(int), 0);

    msgrcv(msgqid, &msg, 256, pid, 0);

    printf("Client: receive from pid %d.\n", *pint);
}
```

### Server

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#define MSGKEY 75
struct msgform
{
    long mtype;
    char mtext[256];
} msg;

int msgqid;

void main()
{
    int i, pid, *pint;
    extern cleanup();
    for (i = 0; i < 20; i++) // 设置软中断信号的处理程序
        signal(i, cleanup);
    msgqid = msgget(MSGKEY, 0777 | IPC_CREAT);
    for (;;)
    {
        msgrcv(msgqid, &msg, 256, 1, 0);
        pint = (int *)msg.mtext;
        pid = *pint;
        printf("Server: receive from pid %d.\n", pid);
        msg.mtype = pid;
        *pint = getpid();
        msgsnd(msgqid, &msg, sizeof(int), 0);
    }
}

cleanup()
{
    msgctl(msgqid, IPC_RMID, 0);
    exit(0);
}
```

### 思考

**服务者程序和客户程序还可以用什么机制来实现？**

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

`signal` 函数将 18 号处理程序与 `func` 函数绑定；在父进程调用 `j = kill(i, 18);`，表示向子进程发送 18 号处理程序的中断信号，子进程响应信号，直接打断 `sleep()` 并执行相应 `func` 程序

### 思考

**软中断与硬中断有什么区别？**

硬中断由外部硬件产生；软中断由执行中断指令产生的

硬中断可以直接中断 CPU，它会引起内核中相关的代码被触发；软中断并不会直接的中断 CPU，也只有当前正在运行的代码（或者是进程）才会产生软中断

硬中断可以被屏蔽；软中断不可被屏蔽

Linux 内核将中断函数需要处理的任务分为两部分，一部分在中断处理函数中执行，此时系统关闭中断；另外一部分在软件中断中执行，此时开启中断，允许系统响应外部中断。当中断发生时，使用硬中断处理那些短时间就可以完成的工作，而将那些处理事件比较长的工作，放到中断之后来完成，也就是软中断来完成。

## 第十题

用信号量机制编写一个解决生产者——消费者问题的程序

```c
#include <stdio.h>
#include <windows.h>

#define BUFFER_SIZE 10
int buffer[BUFFER_SIZE];
int in = 0;
int out = 0;
typedef int Semaphore;
Semaphore   full = 0;
Semaphore   empty = BUFFER_SIZE;
Semaphore   mutex = 1;
#define PRODUCER    0
#define CONSUMER    1
int count=0;
//记录型信号量的wait操作
void waitS(int type, Semaphore *s)
{
    while (*s == 0)
    {
        if (type == PRODUCER)
        {
            printf("Producer is waiting for empty\n\n");
        }
        else if (type == CONSUMER)
        {
            printf("Consumer is waiting for full\n\n");
        }
        Sleep(30);
    }
    (*s)--;
}

//互斥型信号量的wait操作，number用于指示是生产者还是消费者
void waitM(int type, Semaphore *s)
{
    if (*s == 1)
    {
        (*s) = 0;
    }
    else
    {
        if (type == PRODUCER)
        {
            printf("Producer is waiting for mutex\n\n");
        }
        else if (type == CONSUMER)
        {
            printf("Consumer is waiting for mutex\n\n");
        }
        Sleep(30);
    }
}

//记录型信号量的signal操作
void signalS(Semaphore *s)
{
    (*s)++;
}

//互斥型信号量的signal操作
void signalM(Semaphore *s)
{
    *s = 1;
}

//生产者
int  producer(LPVOID lpThreadParameter)
{
    int nextp;
    while(1)
    {
        nextp = count++;
        printf("Produce an item.\n");
        waitS(PRODUCER,&empty);
        waitM(PRODUCER,&mutex);
        printf("Producer write to buffer.\n");
        buffer[in] = nextp;
        in = (++in) % BUFFER_SIZE;
        printf("After producing: in = %d, out = %d, full = %d, empty = %d.\n",in,out,full+1,empty);
        signalM(&mutex);
        signalS(&full);
        printf("Producer left critical section.\n\n");
    }
    return 0;
}

//消费者
int consumer(LPVOID lpThreadParameter)
{
    int nextc;
    while(1)
    {
        waitS(CONSUMER,&full);
        waitM(CONSUMER,&mutex);
        printf("Consumer read from buffer.\n");
        nextc = buffer[out];
        out = (++out) % BUFFER_SIZE;
        printf("After consemer leaves critical section in = %d, out = %d, full = %d, empty = %d.\n",in,out,full,empty+1);
        signalM(&mutex);
        signalS(&empty);
        printf("Consume an item: %d.\n\n",nextc);
    }
    return 0;
}

int main()
{
    HANDLE  hProducer,hConsumer;

    //创建生产者和消费者线程并立即运行
    hProducer = CreateThread(NULL,0,producer,NULL,0,NULL);

    hConsumer = CreateThread(NULL,0,consumer,NULL,0,NULL);

    Sleep(500);

    TerminateThread(hProducer,0);
    TerminateThread(hConsumer,0);


    return 0;
}
```

## 研究并讨论

**讨论 Linux 系统进程运行时的机制和特点，系统通过什么来管理进程？**

Linux 中将进程抽象为文件，一个进程被描述为一类数据结构；系统通过优先级决定进程运行顺序，通过 pid 标记所有进程，提供 `ps`、`top` 等命令接口供用户修改进程状态，使用用户堆栈和系统堆栈控制用户态和核心态之间的互相转换，使用管道、信号量等传统的进程通信方式

**C 语言中是如何使用 Linux 提供的功能的？**

Linux 在 C 语言中提供了一系列**系统调用**接口给编程人员使用

如 `fork()` 函数用来创建子进程；`execl()` 函数用来使用 shell 命令等

**什么是进程？它是如何产生的？**

进程是**进程实体**的运行过程，是系统进行资源分配和调度的一个独立单位

执行程序时，会产生相应的进程

**进程控制如何实现？**

系统为了控制进程，设计出一种数据结构——进程控制块 PCB，其中记录了操作系统所需的、用于描述进程当前情况以及控制进程运行的全部信息。

**进程通信方式各有什么特点？**

- 共享存储器系统
    - 基于共享数据结构、共享存储区的通信方式
    - 仅适用于传递相对少量的数据，通信效率低，属于低级通信）
- 管道通信系统
    - 互斥：当一个进程正在对 pipe 执行读/写操作时，其它进程必须等待
    - 同步，当一个进程将一定数量的数据写入，然后就去睡眠等待，直到读进程将数据取走，再去唤醒。读进程与之类似
    - 需要确定对方是否存在
- 消息传递系统
    - 进程间的数据交换以格式化的消息为单位
- 客户机服务器系统
    - 基于 socket 协议

**管道通信如何实现？该通信方式可以用在何处？**

管道的实质是一个内核缓冲区，进程以先进先出的方式从缓冲区存取数据：管道一端的进程顺序地将进程数据写入缓冲区，另一端的进程则顺序地读取数据。

管道通信通常用于两个进程之间的相互通信

**什么是软中断？软中断信号通信如何实现？**

软中断是 CPU 根据软件的某条指令或者软件对标志寄存器的某个标志位的设置而产生

## 实验一题目

### 思考题

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

### 讨论题

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

