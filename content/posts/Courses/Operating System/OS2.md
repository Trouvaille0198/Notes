---
draft: true
---

判断题 20 分（F 和 T）

单选题 20 分

填空题 20 分

简答题 20 分 3 道（描述概念）

8 分：文件系统

7 分：地址映射变换

5 分：Linux

综合题（计算）3 道 20 分

页面置换算法

磁盘调度算法

增量式索引方式





程序（指可执行文件）装入内存才能运行，本质上装入是建立地址空间映射，    （判断）装入时不进行地址变换

分区分配算法不止用在内存空间，地址空间都可以，（判断）

动态分区分配算法

伙伴系统（）应该必考  分配时按需分配  需要看一遍

分页便于磁盘（硬件管理），分段方便用户程序管理

页大小由硬件决定（选择）

分页地址结构和分段地址结构，页的地址是一维的，段的地址是二维的，段页式也是二维的

地址映射过程（描述，大概率是简答题）两级页表  保存页目录的 CR3 寄存器

![image-20220302131338920](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220302131338920.png)

地址变换机构是由硬件做的（MMU 内存管理单元 ）必考

联想寄存器（快表，TLB）不会做很大，本质上也是页面置换

多级页表的目的页表太大，降低页表的存储空间，不是为了提高速度

反置页表 需要看一下，为每个物理块设置一个页表项，本质上还是逻辑页号到物理页号查询

逻辑地址是写到地址码里，段长





为什么要加虚存，因为不需要把进程中的所有页都掉进内存

状态位（存在位、P 位）的意思

缺页中断机构（重点看） 不是系统调用 是中断，是在指令执行中发生中断，中断结束后继续执行这一条指令

页面置换算法（计算）先进先出、LRU、

页面置换算法本质上是淘汰算法（判断）

抖动不考

对于 Linux 是段页式管理，Windows 既不是段也不是页也不是段页



图 6-1 （填空五个空）

设备驱动程序不属于操作系统

假脱机技术现在还在用，不过时（判断）

缓冲区不考

磁盘访问时间（寻道时间和旋转时间是主要的）（填空）

磁盘调度算法（计算）电梯算法 以及 寻道时间的计算



文件索引结点和文件目录

文件控制块的属性

文件的访问权限在 iNode 里

操作系统的文件结构都是无结构的

Unix 文件类型 正规文件、目录文件、块设备文件和字符设备文件（填空）

![image-20220303112434210](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220303112434210.png)



实验指导：访问文件用 open，读用 read，写用 write

返回文件描述符，是一个整数

文件共享软链接、硬链接，图 7-13（可能是简答题），主要是硬链接

ln-s 是硬链接，ln 没有-s 是软链接

软链接是增加一个链接文件 图 7-16 符号链接，不会触发中断异常

实现文件换名是 link，

改变文件权限

加载文件系统和卸载文件系统 mount unmount

Unix 文件系统是在块设备文件上



增量式索引方式（Unix）（必考大题）












