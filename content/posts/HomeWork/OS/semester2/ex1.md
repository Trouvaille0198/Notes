---
draft: true
---

# 实验一

```python
import enum
import random
from typing import List


class State(str, enum.Enum):
    W = 'W'
    R = 'R'
    F = 'F'


class PCB():
    def __init__(self, pid):
        self.pid: int = pid  # 进程标识数
        self.priority: int = random.randint(1, 10)  # 优先数/轮转时间片数，越大越优先
        self.run_time: int = 0  # 已占用CPU的时间片数
        self.total_time: int = random.randint(1, 20)  # 总共需要的时间片数
        self.state: State = State.W  # 进程状态

    @property
    def need_time(self) -> int:
        return self.total_time - self.run_time


class Dispatcher():
    def __init__(self, process_num: int):
        self.process_num = process_num
        self.processes: List[PCB] = [PCB(i+1) for i in range(process_num)]

    @property
    def active_processes(self):
        return [p for p in self.processes if p.state != State.F]

    @property
    def active_processes_sort_by_pid(self):
        """
        进程按pid升序排序
        """
        return sorted(self.active_processes, key=lambda p: p.pid)

    @property
    def active_processes_sort_by_priority(self):
        """
        进程按优先级降序排序
        """
        return sorted(self.active_processes, key=lambda p: p.priority, reverse=True)

    def show_table_PSA(self):
        if not self.active_processes:
            return
        print('-----------------------------------------------------')
        print("{:15}\t{}".format('ID',
                                 '\t'.join([str(p.pid) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Priority',
                                 '\t'.join([str(p.priority) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Run time',
                                 '\t'.join([str(p.run_time) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Need time',
                                 '\t'.join([str(p.need_time) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('State',
                                 '\t'.join([p.state for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Next',
                                 '\t'.join([str(p.pid) for p in self.active_processes_sort_by_priority])))

    def show_table_RR(self):
        if not self.active_processes:
            return
        print('-----------------------------------------------------')
        print("{:15}\t{}".format('ID',
                                 '\t'.join([str(p.pid) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Priority',
                                 '\t'.join([str(p.priority) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Run time',
                                 '\t'.join([str(p.run_time) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Need time',
                                 '\t'.join([str(p.need_time) for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('State',
                                 '\t'.join([p.state for p in self.active_processes_sort_by_pid])))
        print("{:15}\t{}".format('Next',
                                 '\t'.join([str(p.pid) for p in self.active_processes])))

    def PSA_dispatch(self):
        """
        可抢占优先级调度，每运行一个时间片优先数减3
        """
        print("{:15}\t{}".format('Waiting queue',
                                 '\t'.join([str(p.pid) for p in self.active_processes_sort_by_priority])))
        time_chip: int = 0
        while self.active_processes:
            time_chip += 1
            p: PCB = self.active_processes_sort_by_priority[0]  # 取优先级最高者
            p.state = State.R
            p.run_time += 1
            p.priority -= 3  # 运行次数越多优先级越小
            self.show_table_PSA()
            if p.need_time == 0:
                p.state = State.F
            else:
                p.state = State.W

    def RR_dispatch(self):
        """
        轮转调度
        """
        print("{:15}\t{}".format('Waiting queue',
                                 '\t'.join([str(p.pid) for p in self.active_processes_sort_by_pid])))
        time_chip: int = 0
        while self.active_processes:
            p: PCB = self.active_processes[0]  # 取优先级最高者
            p.state = State.R
            time_chip += 1
            p.run_time += 1
            if p.need_time == 0:
                p.state = State.F
            elif len(self.active_processes) != 1 and p.run_time % p.priority == 0:
                p.state = State.W
                self.processes.remove(p)
                self.processes.append(p)
            self.show_table_RR()


if __name__ == "__main__":
    dispatcher = Dispatcher(3)
    dispatcher.PSA_dispatch()
    dispatcher.RR_dispatch()
```

```cpp
// PSA'n RR
// How to compile: g++ -o ex1.o ex1.cpp
#include <cstdio>
#include <cstdlib>
#include <list>
#include <iostream>

using namespace std;

enum Status
{
    W,
    R,
    F
};

struct PCB
{
    int pid;       //进程标识数
    int priority;  //优先数/轮转时间片数
    int runTime;   //已占用CPU的时间片数
    int needTime;  //需要的时间片数
    Status status; //进程状态
};

list<PCB> init(int n)
{
    list<PCB> proList;
    for (int i = 1; i <= n; i++)
    {
        // 随机生成进程
        PCB process;
        process.pid = i;
        process.priority = rand() % 10 + 1;
        process.runTime = 0;                //已运行的时间
        process.needTime = rand() % 20 + 1; // 还需运行的时间
        process.status = W;
        proList.push_back(process);
    }
    return proList;
}

bool cmp_pri_down(const PCB &p1, const PCB &p2)
// 优先级降序排序的预判定函数
{
    return p1.priority > p2.priority ? true : false;
}

void PSA(int n)
// 可抢占优先级调度，每运行一个时间片优先数减3
{
    list<PCB> proList = init(n);
    proList.sort(cmp_pri_down); // 按优先级大小排序
    int time = 0;
    while (!proList.empty())
    {
        time++;
        PCB &p = proList.front();
        if (p.status == W)
            cout << time << ": Process " << p.pid << " running" << endl;
        p.status = R;
        p.runTime += 1;
        p.needTime -= 1;
        p.priority -= 3; // 运行次数越多优先级越小
        cout << "pri: " << p.priority << endl;
        if (p.needTime == 0)
        // 撤销进程，暂时表现为将进程删除
        {
            cout << time << ": Process " << p.pid << " finished" << endl;
            p.status = F;
            proList.pop_front();
        }

        // 重新按优先级排序
        proList.sort(cmp_pri_down);
        if (p.status == R && p.pid != proList.front().pid)
        {
            cout << time << ": Process " << p.pid << " being preempted" << endl;
            p.status = W;
        }
    }
}

void RoundRobin(int n)
{
    list<PCB> proList = init(n);
    int time = 0;
    while (!proList.empty())
    {
        time++;
        PCB &p = proList.front();
        if (p.status == W)
            cout << time << ": Process " << p.pid << " running" << endl;
        p.status = R;
        p.runTime++;
        p.needTime--;
        if (p.needTime == 0)
        // 撤销进程，暂时表现为将进程删除
        {
            cout << time << ": Process " << p.pid << " finished" << endl;
            p.status = F;
            proList.pop_front();
        }
        else if (proList.size() != 1 && p.runTime % p.priority == 0)
        // 到轮转时间
        {
            cout << time << ": Process " << p.pid << " back to tail" << endl;
                p.status = W;
            proList.pop_front();
            proList.push_back(p);
        }
    }
}

int main()
{
    PSA(5);
    RoundRobin(5);
}
```

