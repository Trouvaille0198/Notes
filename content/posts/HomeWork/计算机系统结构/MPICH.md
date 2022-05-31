---
title: "MPICH"
date: 2021-03-16
author: MelonCholi
draft: false
tags: [Linux]
categories: [Linux]
---

# MPICH

MPI（Message Passing Interface）是目前发展较快、使用面较广的一个公共的消息传递库，顾名思义，就是在现有机器的软硬件通信基础上，实现了并行应用程序中各并行任务之间的相互通信、协调和同步功能，并对这些并行任务进行管理。

MPI 具有可移植性、高效性、灵活性和易用性的特点，不仅适用于具有分布式内存的大型机、工作站机群，也可用于具有共享内存的大型机。

MPI 标准的常用实现有 OpenMPI 和 MPICH。

MPICH 是 MPI 的一种高效便携式实现标准，通过安装MPICH构建MPI编程环境，从而进行并行程序的开发。MPICH 是 MPI（Message-Passing Interface）的一个应用实现，支持最新的 MPI-2 接口标准（现在好像已经有MPI-3了），是用于并行运算的工具。

## 安装

```shell
sudo apt-get install mpich
```

如果需要卸载：

```shell
sudo apt-get --purge remove mpich
```

### 测试安装

随便找个地方新建一个测试文件，mpi_hello.cpp，代码如下：

```shell
#include <iostream>
#include <string.h>
#include <mpi.h>
using namespace std;

const int max_string = 100;

int main ()
{
	int comm_sz=0;
	int my_rank=0;
	char greeting[max_string];
	
	MPI_Init(NULL,NULL);
    MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
    MPI_Comm_size(MPI_COMM_WORLD,&comm_sz);

	 if(my_rank!=0){
		sprintf(greeting,"Greetings from process %d of %d!",my_rank,comm_sz);
		MPI_Send(greeting,strlen(greeting),MPI_CHAR,0,0,MPI_COMM_WORLD);
	}
	else{
		cout<<"Greetings from process "<<my_rank<<" of "<<comm_sz<<"!"<<endl;
		for(int i=1;i<comm_sz;i++){
			MPI_Recv(greeting,max_string,MPI_CHAR,i,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
			cout<<greeting<<endl;
		}
	}
	
	MPI_Finalize ();
	return 0;
}
```

编译

```shell
mpicxx -g -Wall -o mpi_hello.o mpi_hello.cpp
```

- mpicc：编译 C 程序
- mpicxx：是编译 C++ 程序
- -g：允许使用调试器
- -Wall：显示警告（W 大写）
- -o outfile.o：编译出可执行的文件，文件名为 outfile.o
- -02：告诉编译器对代码进行优化

编译完成后，开始运行，可由 -n 后面的数字来调节创建进程数。

```shell
mpirun -n 4 ./mpi_hello.o
```

最后得到的结果为，有可能顺序不一样

```shell
Greetings from process 0 of 4!
Greetings from process 1 of 4!
Greetings from process 2 of 4!
Greetings from process 3 of 4!
```

## 远程并行

