# ex2

https://stackoverflow.com/questions/35931736/mpich-cluster-test-error-unable-to-change-wdir

安装 ssh 客户端

```shell
sudo apt-get install openssh-server
```



安装 mpich

```shell
sudo apt-get install mpich
```

实现 ssh 无密登录：https://blog.csdn.net/weixin_33725126/article/details/91726998



多节点测试用例

```cpp
/*
 * Copyright (C) by Argonne National Laboratory
 *     See COPYRIGHT in top-level directory
 */

#include "mpi.h"
#include <stdio.h>
#include <math.h>

double f(double);

double f(double a)
{
    return (4.0 / (1.0 + a * a));
}

int main(int argc, char *argv[])
{
    int n, myid, numprocs, i;
    double PI25DT = 3.141592653589793238462643;
    double mypi, pi, h, sum, x;
    double startwtime = 0.0, endwtime;
    int namelen;
    char processor_name[MPI_MAX_PROCESSOR_NAME];

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);
    MPI_Get_processor_name(processor_name, &namelen);

    fprintf(stdout, "Process %d of %d is on %s\n", myid, numprocs, processor_name);
    fflush(stdout);

    n = 10000;  /* default # of rectangles */
    if (myid == 0)
        startwtime = MPI_Wtime();

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    h = 1.0 / (double) n;
    sum = 0.0;
    /* A slightly better approach starts from large i and works back */
    for (i = myid + 1; i <= n; i += numprocs) {
        x = h * ((double) i - 0.5);
        sum += f(x);
    }
    mypi = h * sum;

    MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    if (myid == 0) {
        endwtime = MPI_Wtime();
        printf("pi is approximately %.16f, Error is %.16f\n", pi, fabs(pi - PI25DT));
        printf("wall clock time = %f\n", endwtime - startwtime);
        fflush(stdout);
    }

    MPI_Finalize();
    return 0;
}
```

编译

```shell
mpicxx -g -Wall -o mpi_hello.o mpi_hello.cpp
```

将编译文件通过 rcp 传递给其他主机

```shell
rcp mpi_hello.o melon@192.168.163.129:~/src
rcp mpi_hello.o melon@192.168.163.130:~/src
```

运行多节点

```shell
mpirun --machinefile ./hostlist -np 6 ./mpi_hello.o
```

运行单节点

```shell
mpirun -np 6 ./mpi_hello.o
```

![image-20220322194921527](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220322194921527.png)



```cpp
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <mpi.h>
 
void read_num(long long int *num_point,int my_rank,MPI_Comm comm);
void compute_pi(long long int num_point,long long int* num_in_cycle,long long int* local_num_point,int comm_sz,long long int *total_num_in_cycle,MPI_Comm comm,int my_rank);
 
int main(int argc,char** argv){
    long long int num_in_cycle,num_point,total_num_in_cycle,local_num_point;
    int my_rank,comm_sz;
	double begin,end;
    MPI_Comm comm;
    MPI_Init(NULL,NULL);//初始化
    comm=MPI_COMM_WORLD;
    MPI_Comm_size(comm,&comm_sz);//得到进程总数
    MPI_Comm_rank(comm,&my_rank);//得到进程编号
    read_num(&num_point,my_rank,comm);//读取输入数据
	begin=MPI_Wtime();
    compute_pi(num_point,&num_in_cycle,&local_num_point,comm_sz,&total_num_in_cycle,comm,my_rank);
	end=MPI_Wtime();
	if(my_rank==0){
		printf("Elapsing time: %fs\n",end-begin);
	}
    MPI_Finalize();
    return 0;
}
 
void read_num(long long int* num_point,int my_rank,MPI_Comm comm){
    if(my_rank==0){
        printf("please input num in sqaure \n");
        scanf("%lld",num_point);
    }
    MPI_Bcast(num_point,1,MPI_LONG_LONG,0,comm);
 
}
 
void compute_pi(long long int num_point,long long int* num_in_cycle,long long int* local_num_point,int comm_sz,long long int *total_num_in_cycle,MPI_Comm comm,int my_rank){
    *num_in_cycle=0;
    *local_num_point=num_point/comm_sz;
    double x,y,distance_squared; 
    srand(time(NULL));
    for(long long int i=0;i< *local_num_point;i++){     
        x=(double)rand()/(double)RAND_MAX;
        x=x*2-1;
        y=(double)rand()/(double)RAND_MAX;
        y=y*2-1;
        distance_squared=x*x+y*y;
        if(distance_squared<=1)
        *num_in_cycle=*num_in_cycle+1;
    }
      MPI_Reduce(num_in_cycle,total_num_in_cycle,1,MPI_LONG_LONG,MPI_SUM,0,comm);
    if(my_rank==0){
        double pi=(double)*total_num_in_cycle/(double)num_point*4;
        printf("the estimate value of pi is %lf\n",pi);
    }
}
```

