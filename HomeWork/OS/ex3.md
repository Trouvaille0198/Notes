# ex3

## T1

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

**思考：子进程是如何产生的？ 又是如何结束的？子进程被创建后它的运行环境是怎样建立的？ **

父进程调用 `fork()` 来创建子进程，此时两个进程同时进行；

- 在父进程中，`fork()` 返回子进程的 pid，故运行 `if` 语句内的代码块，`wait()` 函数使父进程阻塞（直到子进程结束）并且返回子进程 pid；
- 在子进程中，`fork()` 返回 0，故运行 `else` 语句内的代码块，`exit()` 函数终止子进程
- 父进程收到子进程结束的信号后，继续执行剩余的代码段

输出结果：

```test
It's a child process.
It's a parent process.
The child process, ID number -1, is finished.
```

`fork()` 调用后，内核会为子进程分配对应的虚拟内存空间，同时它的正文段，数据段，堆栈端都是指向了父进程的物理空间，实现物理空间共享，并且内容可读，一旦某个进程修改这个共享的物理空间的内容，就会复制到子线程自己的物理空间。

## T2

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
            printf("Loop %d: pid = %d ppid = %d\n", i + 1, getpid(), getppid());
}
```

输出结果：

```c
My pid is 191, my father’s pid is  9
Loop 1: pid = 192 ppid = 191
Loop 2: pid = 193 ppid = 192
Loop 3: pid = 194 ppid = 193
Pid 193: The child 194 is finished.
Pid 192: The child 193 is finished.
Loop 3: pid = 195 ppid = 192
Pid 192: The child 195 is finished.
Pid 191: The child 192 is finished.
Loop 2: pid = 196 ppid = 191
Loop 3: pid = 197 ppid = 196
Pid 196: The child 197 is finished.
Pid 191: The child 196 is finished.
Loop 3: pid = 198 ppid = 191
Pid 191: The child 198 is finished.
```

