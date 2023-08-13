---
title: "Python redis 库"
date: 2023-8-11
author: MelonCholi
draft: false
tags: [Python, 数据库交互]
categories: [Python]
---

# redis

## lock

redis 支持的数据结构比较丰富，自制一个锁也很方便，所以极少提到其原生锁的方法。但是在单机版 redis 的使用时，自带锁的使用还是非常方便的。

`使用场景`：

- 多线程资源抢占
- 关键变量锁定
- 防止重复执行代码

### 普通使用

```py
import redis

# redis 线程池
pool = redis.ConnectionPool(host='localhost', port=6379, decode_responses=True)
r = redis.Redis(connection_pool=pool)


# 创建一个锁
lock = r.lock('mylock')
try:
    # 获取锁
    lock.acquire()
    print('get lock')
except:
    pass
finally:
    # 释放锁
    lock.release()
```

因为获取了锁之后一定要释放锁，所以用 try except finally 的错误捕获方法保证不管在获取锁之后是否发生错误，最后都会释放锁，这是安全使用锁的一种姿势。

### with 使用

推荐的使用方法是 with

```py
with r.lock('mylock'):
    print('get lock')
```

with 语句在执行代码之前加锁，在退出之前释放锁。具体来说就是实现了 `__enter__` 和 `__exit__` 方法，这些都可以在最后的源码中找答案。

### 参数

```py
def lock(self, name, timeout=None, sleep=0.1, blocking=True, blocking_timeout=None,
             lock_class=None, thread_local=True):
```

- name: 锁的名字
- timeout: 锁的生命周期。如果不设置锁就不会过期，直到被释放。默认不设置
- sleep: 当获取锁阻塞时，尝试获取锁循环的间隔时间，默认是睡眠间隔 0.1s 尝试
- blocking：在 `acquire` 是否等待阻塞
- blocking_timeout：当获取锁阻塞时，最长的等待时间，默认一直等待
- lock_class：强制执行指定的锁实现
- thread_local：用来表示是否将 token 保存在线程本地。默认是保存在本地线程的，所以一个线程只能看到自己的 token，而不能被另一个线程使用。比如有如下例子：
    - 0s: 线程 1 获取到锁 `my-lock`,设置过期时间是 5s，token 是 abc。
    - 1s：线程 2 尝试获取锁。
    - 5s：线程 1 还没有完成，redis 释放了锁。同时线程 2 获取了锁，并设置 token 是 xyz
    - 6s: 线程 1 执行完成，然后调用 release() 释放锁。如果 token 不是保存在本地，那么线程 1 将拿到 token xyz，然后释放了线程 2 的锁
    - 在某些用例中，有必要禁用线程本地存储：例如，如果您有代码，其中一个线程获取一个锁，并将该锁实例传递给工作线程，以便稍后释放。如果在这种情况下未禁用线程本地存储，那么工作线程将看不到获取锁的线程设置的令牌。我们的假设是，这些情况并不常见，因此默认使用线程本地存储。

通过创建 lock 时传入参数来控制 lock 的一些属性。

### 常用方法

lock 拥有的方法并不是很多，所以用法不会花里胡哨。lock 主要的方法如下：

- acquire：获取锁
- release：释放锁
- owned：key 是否被该锁拥有，拥有返回 True
- locked：锁是否被任何一个线程锁住，锁住返回 True

#### acquire

acquire 就是获取锁的方法，原型如下：

```py
def acquire(self, blocking=None, blocking_timeout=None, token=None):
```

##### 最简单的使用

```py
lock.acquire()
```

当锁已经被占用时再次请求，acquire 默认会阻塞。
[![img](https://img2020.cnblogs.com/blog/1060878/202110/1060878-20211025221615734-1310337766.png)](https://img2020.cnblogs.com/blog/1060878/202110/1060878-20211025221615734-1310337766.png)

##### 非阻塞使用

当设置了 blocking=False 时，表示拿不到锁时不阻塞，直接返回 False

```py
lock.acquire(blocking=False)
```

[![img](https://img2020.cnblogs.com/blog/1060878/202110/1060878-20211025221733239-689708994.png)](https://img2020.cnblogs.com/blog/1060878/202110/1060878-20211025221733239-689708994.png)

##### 设置阻塞时长

当拿不到锁时可以设置阻塞的时长

```py
lock.acquire(blocking_timeout=5)
```

5s 之内拿不到锁的话，就会放弃尝试，返回 False

#### owned

owned 表示 key ：`mylock_one` 是不是被该锁 lock 作为关键字。被锁定返回 True，没有锁定返回 False

```py
>>> lock = r.lock('mylock_one')
>>> 
>>> lock.owned()
False
>>> 
>>> lock.acquire()
True
>>> 
>>> lock.owned()
True
>>> 
```

#### locked

是用来看锁是不是被占用，占用返回 True，没有被占用返回 False

```py
>>> lock = r.lock('mylock_two')
>>> 
>>> lock.locked()
False
>>> 
>>> lock.acquire()
True
>>> 
>>> lock.locked()
True
>>> 
```