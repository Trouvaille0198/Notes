---
draft: true
---

# 计算机系统性能评价

实验目的：用正确的方法（或工具）评估计算机系统（单机）的主要性能指标。

回答下列问题：

1. 选择计算机系统的 1 个“主要”性能指标。

2. 这个指标怎么测量？解释测量原理。

3. 选择合适的工具或自编程序测出该指标值，并作出评价。

本实验选取了 CPU 主频这个指标进行测量。

CPU 的主频，即 CPU 内核工作的时钟频率（CPU Clock Frequency），它表示在 CPU 内数字脉冲信号震荡的速度。通常用由 MHz（兆赫，或者每秒百万脉冲）或者 GHz（千兆赫，每秒十亿脉冲）来表示。

计算方法：时钟频率（f）与周期（T）两者互为倒数：f=1/T

这个公式的意思是：时钟频率为时钟在 1 秒钟内重复的次数。

而目前的 CPU 普遍已经处于 GHz 级，也就是说每秒钟会产生 10 亿个脉冲信号。

一般 CPU 厂商会提供这个参数给用户参考，Windows 系统下，我们可以在任务管理器的性能栏下查看

![image-20220514152926070](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514152926070.png)

我们还可以借助一些性能测量工具，通过运行一段示例来查看 CPU 主频的实时变化。这里我们使用了 3DMark 工具

![image-20220514153052967](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514153052967.png)

可以看到 CPU 的主频不是一成不变的，我们再将其与实时温度曲线图做对比：

![image-20220514153259537](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220514153259537.png)

会发现当温度上升时，主频往往会降低。
