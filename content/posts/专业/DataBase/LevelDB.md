---
title: "LevelDB"
date: 2023-02-17
author: MelonCholi
draft: false
tags: [数据库,快速入门]
categories: [数据库]
---

# LevelDB

LevelDB 是 Google 开源的持久化 KV 单机数据库，具有很高的随机写，顺序读/写性能，但是随机读的性能很一般，也就是说，**LevelDB很适合应用在查询较少，而写很多的场景**

LevelDB 是一个 C++ 语言编写的高效键-值嵌入式数据库，目前对亿级的数据也有着非常好的读写性能。虽然 LevelDB 有着许多键-值数据库所不具备的优秀特性，但是与 Redis 等一些主流键-值数据库相比也有缺陷。

优点

- key 与 value 采用字符串形式，且长度没有限制；
- 数据能持久化存储，同时也能将数据缓存到内存，实现快速读取；
- 基于 key 按序存放数据，并且 key 的排序比较函数可以根据用户需求进行定制；
- 支持简易的操作接口 API，如 Put、Get、Delete，并支持批量写入；
- 可以针对数据创建数据内存快照；
- 支持前向、后向的迭代器；
- 采用 Google 的 Snappy 压缩算法对数据进行压缩，以减少存储空间；
- 基本不依赖其他第三方模块，可非常容易地移植到 Windows、Linux、UNIX、Android、iOS。

缺点

- 不是传统的关系数据库，不支持 SQL 查询与索引；
- 只支持单进程，不支持多进程；
- 不支持多种数据类型；
- 不支持客户端-服务器的访问模式。用户在应用时，需要自己进行网络服务的封装。

## 基本概念

leveldb 是一个写性能十分优秀的存储引擎，是典型的 LSM 树(Log Structured-Merge Tree)实现。LSM 树的核心思想就是放弃部分读的性能，换取最大的写入能力。

LSM 树写性能极高的原理，简单地来说就是尽量减少随机写的次数。对于每次写入操作，并不是直接将最新的数据驻留在磁盘中，而是将其拆分成（1）一次日志文件的顺序写（2）一次内存中的数据插入。leveldb 正是实践了这种思想，将数据首先更新在内存中，当内存中的数据达到一定的阈值，将这部分数据真正刷新到磁盘文件中，因而获得了极高的写性能（顺序写 60MB/s, 随机写 45MB/s）。

### 整体架构

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/leveldb_arch.jpeg" style="zoom: 80%;" />

leveldb 中主要由以下几个重要的部件构成：

- memtable
- immutable memtable
- log(journal)
- sstable
- manifest
- current

#### memtable

之前提到，leveldb 的一次写入操作并不是直接将数据刷新到磁盘文件，而是首先写入到内存中作为代替，memtable 就是一个在内存中进行数据组织与维护的结构。memtable 中，所有的数据按**用户定义的排序方法**排序之后按序存储，等到其存储内容的容量达到阈值时（默认为 4MB），便将其转换成一个**不可修改**的 memtable，与此同时创建一个新的 memtable，供用户继续进行读写操作。memtable 底层使用了一种[跳表](https://zh.wikipedia.org/wiki/跳跃列表)数据结构，这种数据结构效率可以比拟二叉查找树，绝大多数操作的时间复杂度为 O(log n)。

#### immutable memtable

memtable 的容量到达阈值时，便会转换成一个不可修改的 memtable，也称为 immutable memtable。这两者的结构定义完全一样，区别只是 immutable memtable 是**只读**的。当一个 immutable memtable 被创建时，leveldb 的后台压缩进程便会将利用其中的内容，创建一个 sstable，持久化到磁盘文件中。

#### log

leveldb 的写操作并不是直接写入磁盘的，而是首先写入到内存。假设写入到内存的数据还未来得及持久化，leveldb 进程发生了异常，抑或是宿主机器发生了宕机，会造成用户的写入发生丢失。因此 leveldb 在写内存之前会首先将所有的写操作写到日志文件中，也就是 log 文件。当以下异常情况发生时，均可以通过日志文件进行恢复：

1. 写 log 期间进程异常；
2. 写 log 完成，写内存未完成；
3. write 动作完成（即 log、内存写入都完成）后，进程异常；
4. Immutable memtable 持久化过程中进程异常；
5. 其他压缩异常（较为复杂，首先不在这里介绍）；

当第一类情况发生时，数据库重启读取 log 时，发现异常日志数据，抛弃该条日志数据，即视作这次用户写入失败，保障了数据库的一致性；

当第二类，第三类，第四类情况发生了，均可以通过 redo 日志文件中记录的写入操作完成数据库的恢复。

每次日志的写操作都是一次顺序写，因此写效率高，整体写入性能较好。

此外，leveldb 的**用户写操作的原子性**同样通过日志来实现。

#### sstable

虽然 leveldb 采用了先写内存的方式来提高写入效率，但是内存中数据不可能无限增长，且日志中记录的写入操作过多，会导致异常发生时，恢复时间过长。因此内存中的数据达到一定容量，就需要将数据持久化到磁盘中。除了某些元数据文件，leveldb 的数据主要都是通过 sstable 来进行存储。

虽然在内存中，所有的数据都是按序排列的，但是当多个 memetable 数据持久化到磁盘后，对应的不同的 sstable 之间是存在交集的，在读操作时，需要对所有的 sstable 文件进行遍历，严重影响了读取效率。因此 leveldb 后台会“定期“整合这些 sstable 文件，该过程也称为 **compaction**。

随着 compaction 的进行，sstable 文件在逻辑上被分成若干层，由内存数据直接 dump 出来的文件称为 level 0 层文件，后期整合而成的文件为 level i 层文件，这也是 leveldb 这个名字的由来。

注意，所有的 sstable 文件本身的内容是不可修改的，这种设计哲学为 leveldb 带来了许多优势，简化了很多设计。具体将在接下来的文章中具体解释。

#### manifest

leveldb 中有个版本的概念，一个版本中主要记录了每一层中所有文件的元数据，元数据包括

1. 文件大小
2. 最大 key 值
3. 最小 key 值

该版本信息十分关键，除了在查找数据时，利用维护的每个文件的最大／小 key 值来加快查找，还在其中维护了一些进行 compaction 的统计值，来控制 compaction 的进行。

以 goleveldb 为例，一个文件的元数据主要包括了最大最小 key，文件大小等信息；

```go
// tFile holds basic information about a table.
type tFile struct {
    fd         storage.FileDesc
    seekLeft   int32
    size       int64
    imin, imax internalKey
}
```

一个版本信息主要维护了每一层所有文件的元数据。

```go
type version struct {
    s *session // session - version

    levels []tFiles // file meta

    // Level that should be compacted next and its compaction score.
    // Score < 1 means compaction is not strictly needed. These fields
    // are initialized by computeCompaction()
    cLevel int // next level
    cScore float64 // current score

    cSeek unsafe.Pointer

    closing  bool
    ref      int
    released bool
}
```

当每次 **compaction 完成**（或者换一种更容易理解的说法，当每次 sstable 文件有新增或者减少），leveldb 都会创建一个新的 version，创建的规则是:

```
versionNew = versionOld + versionEdit
```

versionEdit 指代的是基于旧版本的基础上，变化的内容（例如新增或删除了某些 sstable 文件）。

**manifest 文件就是用来记录这些 versionEdit 信息的**。

一个 versionEdit 数据，会被编码成一条记录，写入 manifest 文件中。例如下图便是一个 manifest 文件的示意图，其中包含了 3 条 versionEdit 记录，每条记录包括

1. 新增哪些 sst 文件
2. 删除哪些 sst 文件
3. 当前 compaction 的下标
4. 日志文件编号
5. 操作 seqNumber

等等信息。通过这些信息，leveldb 便可以在启动时，基于一个空的 version，不断 apply 这些记录，最终得到一个上次运行结束时的版本信息。

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/manifest.jpeg" alt="img" style="zoom:67%;" />

#### current

这个文件的内容只有一个信息，就是记载当前的 manifest 文件名。

因为每次 leveldb 启动时，都会创建一个新的 Manifest 文件。因此数据目录可能会存在多个 Manifest 文件。Current 则用来指出哪个 Manifest 文件才是我们关心的那个 Manifest 文件。

## 读写操作

### 写操作

leveldb 以其优秀的写性能著名，在本文中就先来分析一下 leveldb 整个写入的流程，底层数据结构的支持以及为何能够获取极高的写入性能。

#### 整体流程

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/write_op.jpeg" alt="img" style="zoom: 50%;" />

leveldb 的一次写入分为两部分：

1. 将写操作写入日志；
2. 将写操作应用到内存数据库中；

之前已经阐述过为何这样的操作可以获得极高的写入性能，以及通过先写日志的方法能够保障用户的写入不丢失。

> 其实leveldb仍然存在写入丢失的隐患。在写设置为非同步的情况下，在写完日志文件以后，操作系统并不是直接将这些日志文件数据真正落到磁盘中，而是暂时留在操作系统缓存中，因此当用户写入操作完成，操作系统还未来得及落盘的情况下，发生系统宕机，就会造成写丢失；但是若只是进程异常退出，则不存在该问题。

#### 写类型

leveldb 对外提供的写入接口有 Put 和 Delete 两种。**这两种本质对应同一种操作，Delete操作同样会被转换成一个value为空的Put操作。**

除此以外，leveldb 还提供了一个批量处理的工具 Batch，用户可以依据 Batch 来完成批量的数据库更新操作，且这些操作是原子性的。

#### batch结构

无论是 Put/Del 操作，还是批量操作，底层都会为这些操作创建一个 batch 实例作为一个数据库操作的最小执行单元。因此首先介绍一下 batch 的组织结构。

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/batch.jpeg" alt="img" style="zoom: 67%;" />

在 batch 中，每一条数据项都按照上图格式进行编码。每条数据项编码后的第一位是这条数据项的类型（更新还是删除），之后是数据项 key 的长度，数据项 key 的内容；若该数据项不是删除操作，则再加上 value 的长度，value 的内容。

batch 中会维护一个 size 值，用于表示其中包含的数据量的大小。该 size 值为所有数据项 key 与 value 长度的累加，以及每条数据项额外的 8 个字节。这 8 个字节用于存储一条数据项额外的一些信息。

#### key 值编码 internalKey

当数据项从 batch 中写入到内存数据库中时，需要将一个 key 值的转换，即在 leveldb 内部，所有数据项的 key 是经过特殊编码的，这种格式称为 internalKey。

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/internalkey.jpeg" alt="img" style="zoom:67%;" />

internalkey 在用户 key 的基础上，尾部追加了 8 个字节，用于存储：

1. 该操作对应的 sequence number
2. 该操作的类型。

其中，每一个操作都会被赋予一个 sequence number。该计数器是在 leveldb 内部维护，每进行一次操作就做一个累加。由于在 leveldb 中，一次更新或者一次删除，采用的是 append 的方式，并非直接更新原数据。因此对应同样一个 key，会有多个版本的数据记录，而最大的 sequence number 对应的数据记录就是最新的。

此外，leveldb 的快照（snapshot）也是基于这个 sequence number 实现的，即每一个 sequence number 代表着数据库的一个版本。

#### 合并写

leveldb 中，在面对并发写入时，做了一个处理的优化。**在同一个时刻，只允许一个写入操作将内容写入到日志文件以及内存数据库中**。

不过为了在写入进程较多的情况下，减少日志文件的小写入，增加整体的写入性能，**leveldb 将一些“小写入”合并成一个“大写入”。**

流程如下：

**第一个获取到写锁的写操作**

- 第一个写入操作获取到写入锁；
- 在当前写操作的数据量未超过合并上限，且有其他写操作 pending 的情况下，将其他写操作的内容合并到自身；
- 若本次写操作的数据量超过上限，或者无其他 pending 的写操作了，将所有内容统一写入日志文件，并写入到内存数据库中；
- 通知每一个被合并的写操作最终的写入结果，释放或移交写锁；

**其他写操作**：

- 等待获取写锁或者被合并；
- 若被合并，判断是否合并成功，若成功，则等待最终写入结果；反之，则表明获取锁的写操作已经 oversize 了，此时，该操作直接从上个占有锁的写操作中接过写锁进行写入；
- 若未被合并，则继续等待写锁或者等待被合并；

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/write_merge.jpeg" alt="_images/write_merge.jpeg" style="zoom:50%;" />

#### 原子性

leveldb 的任意一个写操作（无论包含了多少次写），**其原子性都是由日志文件实现的**。一个写操作中所有的内容会以一个日志中的一条记录，作为最小单位写入。

考虑以下两种异常情况：

1. 写日志未开始，或写日志完成一半，进程异常退出；
    - 存储一个写操作的部分写已经被记载到日志文件中了，但仍然有部分写未被记录，这种情况下，当数据库重新启动恢复时，读到这条日志记录时，发现数据异常，直接丢弃或退出，实现了写入的原子性保障。
2. 写日志完成，进程异常退出；
    - 写日志已经完成，写入日志的数据未真正持久化，数据库启动恢复时通过 redo 日志实现数据写入，仍然保障了原子性。

### 读操作

leveldb 提供给用户两种进行读取数据的接口：

1. 直接通过 `Get` 接口读取数据；
2. 首先创建一个 snapshot，基于该 snapshot 调用 Get 接口读取数据；

**两者的本质是一样的，只不过第一种调用方式默认地以当前数据库的状态创建了一个snapshot，并基于此snapshot进行读取。**

读者可能不了解 snapshot（快照）到底是什么？简单地来说，就是数据库在某一个时刻的状态。基于一个快照进行数据的读取，读到的内容不会因为后续数据的更改而改变。

由于两种方式本质都是基于快照进行读取的，因此在介绍读操作之前，首先介绍快照。

#### 快照

快照代表着数据库某一个时刻的状态，在 leveldb 中，作者巧妙地用一个整型数来代表一个数据库状态。

在 leveldb 中，用户对同一个 key 的若干次修改（包括删除）是以维护多条数据项的方式进行存储的（直至进行 compaction 时才会合并成同一条记录），每条数据项都会被赋予一个序列号，代表这条数据项的新旧状态。一条数据项的序列号越大，表示其中代表的内容为最新值。

**因此，每一个序列号，其实就代表着 leveldb 的一个状态**。换句话说，每一个序列号都可以作为一个状态快照。

当用户主动或者被动地创建一个快照时，leveldb 会以当前最新的序列号对其赋值。例如图中用户在序列号为 98 的时刻创建了一个快照，并且基于该快照读取 key 为“name”的数据时，即便此刻用户将"name"的值修改为"dog"，再删除，用户读取到的内容仍然是“cat”。

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/snapshot.jpeg" alt="img" style="zoom:50%;" />

所以，利用快照能够保证数据库进行并发的读写操作。

在获取到一个快照之后，leveldb 会为本次查询的 key 构建一个 internalKey（格式如上文所述），其中 internalKey 的 seq 字段使用的便是快照对应的 seq。通过这种方式可以过滤掉**所有 seq 大于快照号的数据项**。

### 读取

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/readop.jpeg" alt="img" style="zoom:50%;" />

leveldb 读取分为三步：

1. 在 memory db 中查找指定的 key，若搜索到符合条件的数据项，结束查找；
2. 在冻结的 memory db 中查找指定的 key，若搜索到符合条件的数据项，结束查找；
3. 按**低层至高**层的顺序在 level i 层的 sstable 文件中查找指定的 key，若搜索到符合条件的数据项，结束查找，否则返回 Not Found 错误，表示数据库中不存在指定的数据；

> 注意 leveldb 在每一层 sstable 中查找数据时，都是按序依次查找 sstable 的。
>
> 0 层的文件比较特殊。由于 0 层的文件中可能存在 key 重合的情况，因此在 0 层中，文件编号大的 sstable 优先查找。理由是文件编号较大的 sstable 中存储的总是最新的数据。
>
> 非 0 层文件，一层中所有文件之间的 key 不重合，因此 leveldb 可以借助 sstable 的元数据（一个文件中最小与最大的 key 值）进行快速定位，每一层只需要查找一个 sstable 文件的内容。

在 memory db 或者 sstable 的查找过程中，需要根据指定的序列号拼接一个 internalKey，查找用户 key 一致，且 seq 号**不大于**指定 seq 的数据，具体的查找过程可见 “内存数据库”和 “sstable” 两篇章。

## 日志

为了防止写入内存的数据库因为进程异常、系统掉电等情况发生丢失，leveldb 在写内存之前会将本次写操作的内容写入日志文件中。

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/two_log.jpeg" alt="img" style="zoom: 50%;" />

在 leveldb 中，有两个 memory db，以及对应的两份日志文件。其中一个 memory db 是可读写的，当这个 db 的数据量超过预定的上限时，便会转换成一个不可写的 memory db，与此同时，与之对应的日志文件也变成一份 frozen log。

而新生成的 immutable memory db 则会由后台的 minor compaction 进程将其转换成一个 sstable 文件进行持久化，持久化完成，与之对应的 frozen log 被删除。

在本文中主要分析日志的结构、写入读取操作。

### 日志结构

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/journal.jpeg" alt="img" style="zoom:50%;" />

为了增加读取效率，日志文件中按照 block 进行划分，每个 block 的大小为 32KiB。每个 block 中包含了若干个完整的 chunk。

一条日志记录包含一个或多个 chunk。每个 chunk 包含了一个 7 字节大小的 header，前 4 字节是该 chunk 的校验码，紧接的 2 字节是该 chunk 数据的长度，以及最后一个字节是该 chunk 的类型。其中 checksum 校验的范围包括 chunk 的类型以及随后的 data 数据。

chunk 共有四种类型：full，first，middle，last。一条日志记录若只包含一个 chunk，则该 chunk 的类型为 full。若一条日志记录包含多个 chunk，则这些 chunk 的第一个类型为 first, 最后一个类型为 last，中间包含大于等于 0 个 middle 类型的 chunk。

由于一个 block 的大小为 32KiB，因此当一条日志文件过大时，会将第一部分数据写在第一个 block 中，且类型为 first，若剩余的数据仍然超过一个 block 的大小，则第二部分数据写在第二个 block 中，类型为 middle，最后剩余的数据写在最后一个 block 中，类型为 last。

### 日志内容

日志的内容为**写入的 batch 编码后的信息**。

具体的格式为：

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/journal_content.jpeg" alt="img" style="zoom:50%;" />

一条日志记录的内容包含：

- Header
- Data

其中 header 中有

- 当前 db 的 sequence number
- 本次日志记录中所包含的 put/del 操作的个数。

紧接着写入所有 batch 编码后的内容。

### 日志写

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/journal_write.jpeg" alt="img" style="zoom: 33%;" />

日志写入流程较为简单，在 leveldb 内部，实现了一个 journal 的 writer。首先调用 Next 函数获取一个 singleWriter，这个 singleWriter 的作用就是写入**一条journal记录**。

singleWriter 开始写入时，标志着第一个 chunk 开始写入。在写入的过程中，不断判断 writer 中 buffer 的大小，若超过 32KiB，将 chunk 开始到现在做为一个完整的 chunk，为其计算 header 之后将整个 chunk 写入文件。与此同时 reset buffer，开始新的 chunk 的写入。

若一条 journal 记录较大，则可能会分成几个 chunk 存储在若干个 block 中。

### 日志读

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/journal_read.jpeg" alt="img" style="zoom: 67%;" />

同样，日志读取也较为简单。为了避免频繁的 IO 读取，每次从文件中读取数据时，按 block（32KiB）进行块读取。

每次读取一条日志记录，reader 调用 Next 函数返回一个 singleReader。singleReader 每次调用 Read 函数就返回一个 chunk 的数据。每次读取一个 chunk，都会检查这批数据的校验码、数据类型、数据长度等信息是否正确，若不正确，且用户要求严格的正确性，则返回错误，否则丢弃整个 chunk 的数据。

循环调用 singleReader 的 read 函数，直至读取到一个类型为 Last 的 chunk，表示整条日志记录都读取完毕，返回。

## 内存数据库

leveldb 中内存数据库用来维护有序的 key-value 对，其底层是利用跳表实现，绝大多数操作（读／写）的时间复杂度均为 O(log n)，有着与平衡树相媲美的操作效率，但是从实现的角度来说简单许多，因此在本文中将介绍一下内存数据库的实现细节。

### 跳表

#### 概述

跳表（SkipList）是由 William Pugh 提出的。他在论文《Skip lists: a probabilistic alternative to balanced trees》中详细地介绍了有关跳表结构、插入删除操作的细节。

这种数据结构是利用**概率均衡**技术，加快简化插入、删除操作，且保证绝大大多操作均拥有 O(log n)的良好效率。

作者在他的论文中这样介绍跳表：

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/skiplist_effect.jpeg" alt="img" style="zoom: 67%;" />

平衡树（以红黑树为代表）是一种非常复杂的数据结构，为了维持树结构的平衡，获取稳定的查询效率，平衡树每次插入可能会涉及到较为复杂的节点旋转等操作。作者设计跳表的目的就是借助**概率平衡**，来构建一个快速且简单的数据结构，取代平衡树。

<img src="https://leveldb-handbook.readthedocs.io/zh/latest/_images/skiplist_intro.jpeg" alt="img" style="zoom: 67%;" />

作者从链表讲起，一步步引出了跳表这种结构的由来。

- 图 a 中，所有元素按序排列，被存储在一个链表中，则一次查询之多需要比较 N 个链表节点；

- 图 b 中，每隔 2 个链表节点，新增一个额外的指针，该指针指向间距为 2 的下一个节点，如此以来，借助这些额外的指针，一次查询至多只需要⌈n/2⌉ + 1 次比较；

- 图 c 中，在图 b 的基础上，每隔 4 个链表节点，新增一个额外的指针，指向间距为 4 的下一个节点，一次查询至多需要⌈n/4⌉ + 2 次比较；

作者推论，若每隔 2^ i 个节点，新增一个辅助指针，最终一次节点的查询效率为 O(log n)。但是这样不断地新增指针，使得一次插入、删除操作将会变得非常复杂。

一个拥有*k*个指针的结点称为一个*k*层结点（*level k node*）。按照上面的逻辑，50%的结点为 1 层节点，25%的结点为 2 层节点，12.5%的结点为 3 层节点。若保证每层节点的分布如上述概率所示，则仍然能够相同的查询效率。图 e 便是一个示例。

维护这些辅助指针将会带来较大的复杂度，因此作者将每一层中，每个节点的辅助指针指向该层中下一个节点。故在插入删除操作时，只需跟操作链表一样，修改相关的前后两个节点的内容即可完成，作者将这种数据结构称为跳表。

### 结构

![img](https://leveldb-handbook.readthedocs.io/zh/latest/_images/skiplist_arch.png)

一个跳表的结构示意图如上所示。

跳跃列表是按层建造的。底层是一个普通的**有序**链表。每个更高层都充当下面链表的"快速通道"，这里在层 *i* 中的元素按某个固定的概率 *p* (通常为 0.5 或 0.25)出现在层 *i*+1 中。平均起来，每个元素都在 1/(1-*p*) 个列表中出现，而最高层的元素（通常是在跳跃列表前端的一个特殊的头元素）在 O(log1/*p* *n*) 个列表中出现。

### 查找

![img](https://leveldb-handbook.readthedocs.io/zh/latest/_images/skiplist_search.jpeg)

在介绍插入和删除操作之前，我们首先介绍查找操作，该操作是上述两个操作的基础。

例如图中，需要查找一个值为 17 的链表节点，查找的过程为：

- 首先根据跳表的高度选取最高层的头节点；
- 若跳表中的节点内容小于查找节点的内容，则取该层的下一个节点继续比较；
- 若跳表中的节点内容等于查找节点的内容，则直接返回；
- 若跳表中的节点内容大于查找节点的内容，且层高不为 0，则降低层高，且从前一个节点开始，重新查找低一层中的节点信息；若层高为 0，则返回当前节点，该节点的 key 大于所查找节点的 key。

综合来说，就是利用稀疏的高层节点，快速定位到所需要查找节点的大致位置，再利用密集的底层节点，具体比较节点的内容。

### 插入

插入操作借助于查找操作实现。

![img](https://leveldb-handbook.readthedocs.io/zh/latest/_images/skiplist_insert.jpeg)

- 在查找的过程中，不断记录**每一层**的**前任节点**，如图中红色圆圈所表示的；
- 为新插入的节点随机产生层高（随机产生层高的算法较为简单，依赖最高层数和概率值 p，可见下文中的代码实现）；
- 在合适的位置插入新节点（例如图中节点 12 与节点 19 之间），并依据查找时记录的前任节点信息，在每一层中，**以链表插入**的方式，将该节点插入到每一层的链接中。

**链表插入**指：将当前节点的 Next 值置为前任节点的 Next 值，将前任节点的 Next 值替换为当前节点。

```
func (p *DB) randHeight() (h int) {
    const branching = 4
    h = 1
    for h < tMaxHeight && p.rnd.Int()%branching == 0 {
        h++
    }
    return
}
```

### 删除

跳表的删除操作较为简单，依赖查找过程找到该节点在整个跳表中的位置后，**以链表删除**的方式，在每一层中，删除该节点的信息。

**链表删除**指：将前任节点的 Next 值替换为当前节点的 Next 值，并将当前节点所占的资源释放。

### 迭代

*向后遍历*

- 若迭代器刚被创建，则根据用户指定的查找范围[Start, Limit)找到一个符合条件的跳表节点；
- 若迭代器处于中部，则取出上一次访问的跳表节点的后继节点，作为本次访问的跳表节点（后继节点为最底层的后继节点）；
- 利用跳表节点信息（keyvalue 数据偏移量，key，value 值长度等），获取 keyvalue 数据；

*向前遍历*

- 若迭代器刚被创建，则根据用户指定的查找范围[Start, Limit）在跳表中找到最后一个符合条件的跳表节点；
- 若迭代器处于中部，则利用上一次访问的节点的 key 值，查找比该 key 值更小的跳表节点；
- 利用跳表节点信息（keyvalue 数据偏移量，key，value 值长度等），获取 keyvalue 数据；

## 内存数据库

在介绍完跳表这种数据结构的组织原理以后，我们介绍 leveldb 如何利用跳表来构建一个高效的内存数据库。

### 键值编码

在介绍内存数据库之前，首先介绍一下内存数据库的键值编码规则。由于内存数据库本质是一个 kv 集合，且所有的数据项都是依据 key 值排序的，因此键值的编码规则尤为关键。

内存数据库中，key 称为 internalKey，其由三部分组成：

- 用户定义的 key：这个 key 值也就是原生的 key 值；
- 序列号：leveldb 中，每一次写操作都有一个 sequence number，标志着写入操作的先后顺序。由于在 leveldb 中，可能会有多条相同 key 的数据项同时存储在数据库中，因此需要有一个序列号来标识这些数据项的新旧情况。序列号最大的数据项为最新值；
- 类型：标志本条数据项的类型，为更新还是删除；

![img](https://leveldb-handbook.readthedocs.io/zh/latest/_images/internalkey.jpeg)

### 键值比较

内存数据库中所有的数据项都是按照键值比较规则进行排序的。这个比较规则可以由用户自己定制，也可以使用系统默认的。在这里介绍一下系统默认的比较规则。

默认的比较规则：

- 首先按照字典序比较用户定义的 key（ukey），若用户定义 key 值大，整个 internalKey 就大；
- 若用户定义的 key 相同，则序列号大的 internalKey 值就小；

通过这样的比较规则，则所有的数据项首先按照用户 key 进行升序排列；当用户 key 一致时，按照序列号进行降序排列，这样可以保证首先读到序列号大的数据项。

### 数据组织

以 goleveldb 为示例，内存数据库的定义如下：

```
type DB struct {
    cmp comparer.BasicComparer
    rnd *rand.Rand

    mu     sync.RWMutex
    kvData []byte
    // Node data:
    // [0]         : KV offset
    // [1]         : Key length
    // [2]         : Value length
    // [3]         : Height
    // [3..height] : Next nodes
    nodeData  []int
    prevNode  [tMaxHeight]int
    maxHeight int
    n         int
    kvSize    int
}
```

其中 kvData 用来存储每一条数据项的 key-value 数据，nodeData 用来存储每个跳表节点的**链接信息**。

nodeData 中，每个跳表节点占用一段连续的存储空间，每一个字节分别用来存储特定的跳表节点信息。

- 第一个字节用来存储本节点 key-value 数据在 kvData 中对应的偏移量；
- 第二个字节用来存储本节点 key 值长度；
- 第三个字节用来存储本节点 value 值长度；
- 第四个字节用来存储本节点的层高；
- 第五个字节开始，用来存储每一层对应的下一个节点的索引值；

### 基本操作

*Put*、*Get*、*Delete*、*Iterator*等操作均依赖于底层的跳表的基本操作实现，不再赘述。
