---
title: "threading"
date: 2021-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# threading

## 概念

```python
import threading
```

threading 模块中包含了关于线程操作的丰富功能，包括：常用线程函数，线程对象，锁对象，递归锁对象，事件对象，条件变量对象，信号量对象，定时器对象，栅栏对象

此类表示在单独的控制线程中运行的活动，有两种方法可以指定该活动，一是将**可调用对象传递给构造函数**，二是通过**覆盖子类中的 `run()` 方法**。

### 常用属性与方法

| Thread 对象数据属性 | 描述                                 |
| ------------------- | ------------------------------------ |
| name                | 线程名                               |
| ident               | 线程的标识符                         |
| daemon              | 布尔标志，表示这个线程是否是守护线程 |

| Thread 对象方法                                                                  | 描述                                                                      |
| -------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| **init**(group=None, tatget=None,args=(), kwargs ={}, verbose=None, daemon=None) | 实例化一个线程对象，需要有一个可调用的 target，以及其参数 args或 kwargs。 |
| start()                                                                          | 开始执行该线程                                                            |
| run()                                                                            | 定义线程功能的方法（通常在子类中被应用开发者重写）                        |
| join (timeout=None)                                                              | 直至启动的线程终止之前一直挂起；除非给出了 timeout（秒），否则会一直阻塞  |

### Thread 的生命周期

1. 创建对象时，代表 Thread 内部被初始化。
2. 调用 start() 方法后，thread 会开始运行。
3. thread 代码正常运行结束或者是遇到异常，线程会终止。

## 调用方法

### 直接创建对象

***threading.Thread(group=None, target=None, name=None, args=(), kwargs={}, \*, daemon=None)***

```python
import threading
import time

def test():

    for i in range(5):
        print('test ',i)
        time.sleep(1)


thread = threading.Thread(target=test, name='TestThread')
thread.start()

for i in range(5):
    print('main ', i)
    time.sleep(1)
```

### 子类覆盖

```python
import threading
import time

count = 0

# 这个MyThread类继承了threading模块的Thread类，对其下面的run方法进行了重写"""

class MyThread(threading.Thread):
    def __init__(self , threadName):
        super(MyThread,self).__init__(name=threadName)
    """一旦这个MyThread类被调用，自动的就会运行底下的run方法中的代码，
    因为这个run方法所属的的MyThread类继承了threading.Thread"""
    def run(self):
        global count
        for i in range(100):
            count += 1
            time.sleep(0.3)
            print(self.getName() , count)


for i in range(2):
    MyThread("MyThreadName:" + str(i)).start()
```