---
title: "sync"
date: 2023-02-16
draft: true
author: "MelonCholi"
tags: [未完工]
categories: [Golang]
---

# sync

## sync.map

Go 语言原生 map 并不是线程安全的，对它进行并发读写操作的时候，需要加锁。而 `sync.map` 则是一种并发安全的 map，在 Go 1.9 引入。

> `sync.map` 是线程安全的，读取，插入，删除也都保持着常数级的时间复杂度。
> `sync.map` 的零值是有效的，并且零值是一个空的 map。在第一次使用之后，不允许被拷贝。

一般情况下解决并发读写 map 的思路是加一把大锁，或者把一个 map 分成若干个小 map，对 key 进行哈希，只操作相应的小 map。前者锁的粒度比较大，影响效率；后者实现起来比较复杂，容易出错。

而使用 `sync.map` 之后，对 map 的读写，不需要加锁。并且它通过空间换时间的方式，使用 read 和 dirty 两个 map 来进行读写分离，降低锁时间来提高效率。

### 使用

```go
package main

import (
    "fmt"
    "sync"
)

func main()  {
    var m sync.Map
    // 1. 写入
    m.Store("qcrao", 18)
    m.Store("stefno", 20)

    // 2. 读取
    age, _ := m.Load("qcrao")
    fmt.Println(age.(int))

    // 3. 遍历 并打印
    m.Range(func(key, value interface{}) bool {
        name := key.(string)
        age := value.(int)
        fmt.Println(name, age)
        return true
    })

    // 4. 删除
    m.Delete("qcrao")
    age, ok := m.Load("qcrao")
    fmt.Println(age, ok) // nil

    // 5. 读取或写入
    m.LoadOrStore("stefno", 100)
    age, _ = m.Load("stefno")
    fmt.Println(age)
}
```

`sync.map` 适用于读多写少的场景。对于写多的场景，会导致 read map 缓存失效，需要加锁，导致冲突变多；而且由于未命中 read map 次数过多，导致 dirty map 提升为 read map，这是一个 O(N) 的操作，会进一步降低性能。

### 源码分析

#### 数据结构

先来看下 map 的数据结构。去掉大段的注释后：

```go
type Map struct {
    mu Mutex
    read atomic.Value // readOnly
    dirty map[interface{}]*entry
    misses int
}
```

互斥量 `mu` 保护 read 和 dirty。

`read` 是 atomic.Value 类型，可以并发地读。但如果需要更新 `read`，则需要加锁保护。对于 read 中存储的 entry 字段，可能会被并发地 CAS 更新。但是如果要更新一个之前已被删除的 entry，则需要先将其状态从 expunged 改为 nil，再拷贝到 dirty 中，然后再更新。

`dirty` 是一个非线程安全的原始 map。包含新写入的 key，并且包含 `read` 中的所有未被删除的 key。这样，可以快速地将 `dirty` 提升为 `read` 对外提供服务。

如果 `dirty` 为 nil，那么下一次写入时，会新建一个新的 `dirty`，这个初始的 `dirty` 是 `read` 的一个拷贝，但除掉了其中已被删除的 key。

每当从 read 中读取失败，都会将 `misses` 的计数值加 1，当加到一定阈值以后，需要将 dirty 提升为 read，以期减少 miss 的情形。

> `read map` 和 `dirty map` 的存储方式是不一致的。
> 前者使用 atomic.Value，后者只是单纯的使用 map。
> 原因是 read map 使用 lock free 操作，必须保证 load/store 的原子性；而 dirty map 的 load+store 操作是由 lock（就是 mu）来保护的。

真正存储 `key/value` 的是 read 和 dirty 字段。`read` 使用 atomic.Value，这是 lock-free 的基础，保证 load/store 的原子性。`dirty` 则直接用了一个原始的 map，对于它的 load/store 操作需要加锁。

`read` 字段里实际上是存储的是：

```go
// readOnly is an immutable struct stored atomically in the Map.read field.
type readOnly struct {
    m       map[interface{}]*entry
    amended bool // true if the dirty map contains some key not in m.
}
```

注意到 read 和 dirty 里存储的东西都包含 `entry`，来看一下：

```go
type entry struct {
    p unsafe.Pointer // *interface{}
}
```

很简单，它是一个指针，指向 value。看来，read 和 dirty 各自维护一套 key，key 指向的都是同一个 value。也就是说，只要修改了这个 entry，对 read 和 dirty 都是可见的。这个指针的状态有三种：



<img src="https://pic3.zhimg.com/80/v2-4f119d4b0545bab02e5e49fbc3034a3a_720w.webp" alt="img" style="zoom:50%;" />



- 当 `p == nil` 时，说明这条键值对已被删除，并且 m.dirty == nil，或 m.dirty[k] 指向该 entry。

- 当 `p == expunged` 时，说明这条键值对已被删除，并且 m.dirty != nil，且 m.dirty 中没有这个 key。

其他情况，p 指向一个正常的值，表示实际 `interface{}` 的地址，并且被记录在 m.read.m[key] 中。如果这时 m.dirty 不为 nil，那么它也被记录在 m.dirty[key] 中。两者实际上指向的是同一个值。

当删除 key 时，并不实际删除。一个 entry 可以通过原子地（CAS 操作）设置 p 为 nil 被删除。如果之后创建 m.dirty，nil 又会被原子地设置为 expunged，且不会拷贝到 dirty 中。

如果 p 不为 expunged，和 entry 相关联的这个 value 可以被原子地更新；如果 `p == expunged`，那么仅当它初次被设置到 m.dirty 之后，才可以被更新。

整体用一张图来表示：



<img src="https://pic1.zhimg.com/80/v2-e96c8332e9451c5fc701fc914e2bf238_720w.webp" alt="img" style="zoom: 80%;" />



#### Store

先来看 expunged：

```text
var expunged = unsafe.Pointer(new(interface{}))
```

它是一个指向任意类型的指针，用来标记从 dirty map 中删除的 entry。

```text
// Store sets the value for a key.
func (m *Map) Store(key, value interface{}) {
    // 如果 read map 中存在该 key  则尝试直接更改(由于修改的是 entry 内部的 pointer，因此 dirty map 也可见)
    read, _ := m.read.Load().(readOnly)
    if e, ok := read.m[key]; ok && e.tryStore(&value) {
        return
    }

    m.mu.Lock()
    read, _ = m.read.Load().(readOnly)
    if e, ok := read.m[key]; ok {
        if e.unexpungeLocked() {
            // 如果 read map 中存在该 key，但 p == expunged，则说明 m.dirty != nil 并且 m.dirty 中不存在该 key 值 此时:
            //    a. 将 p 的状态由 expunged  更改为 nil
            //    b. dirty map 插入 key
            m.dirty[key] = e
        }
        // 更新 entry.p = value (read map 和 dirty map 指向同一个 entry)
        e.storeLocked(&value)
    } else if e, ok := m.dirty[key]; ok {
        // 如果 read map 中不存在该 key，但 dirty map 中存在该 key，直接写入更新 entry(read map 中仍然没有这个 key)
        e.storeLocked(&value)
    } else {
        // 如果 read map 和 dirty map 中都不存在该 key，则：
        //    a. 如果 dirty map 为空，则需要创建 dirty map，并从 read map 中拷贝未删除的元素到新创建的 dirty map
        //    b. 更新 amended 字段，标识 dirty map 中存在 read map 中没有的 key
        //    c. 将 kv 写入 dirty map 中，read 不变
        if !read.amended {
            // 到这里就意味着，当前的 key 是第一次被加到 dirty map 中。
            // store 之前先判断一下 dirty map 是否为空，如果为空，就把 read map 浅拷贝一次。
            m.dirtyLocked()
            m.read.Store(readOnly{m: read.m, amended: true})
        }
        // 写入新 key，在 dirty 中存储 value
        m.dirty[key] = newEntry(value)
    }
    m.mu.Unlock()
}
```

整体流程：

1. 如果在 read 里能够找到待存储的 key，并且对应的 entry 的 p 值不为 expunged，也就是没被删除时，直接更新对应的 entry 即可。
2. 第一步没有成功：要么 read 中没有这个 key，要么 key 被标记为删除。则先加锁，再进行后续的操作。
3. 再次在 read 中查找是否存在这个 key，也就是 double check 一下，这也是 lock-free 编程里的常见套路。如果 read 中存在该 key，但 `p == expunged`，说明 m.dirty != nil 并且 m.dirty 中不存在该 key 值 此时: a. 将 p 的状态由 expunged 更改为 nil；b. dirty map 插入 key。然后，直接更新对应的 value。
4. 如果 read 中没有此 key，那就查看 dirty 中是否有此 key，如果有，则直接更新对应的 value，这时 read 中还是没有此 key。
5. 最后一步，如果 read 和 dirty 中都不存在该 key，则：a. 如果 dirty 为空，则需要创建 dirty，并从 read 中拷贝未被删除的元素；b. 更新 amended 字段，标识 dirty map 中存在 read map 中没有的 key；c. 将 k-v 写入 dirty map 中，read.m 不变。最后，更新此 key 对应的 value。

再来看一些子函数：

```text
// 如果 entry 没被删，tryStore 存储值到 entry 中。如果 p == expunged，即 entry 被删，那么返回 false。
func (e *entry) tryStore(i *interface{}) bool {
    for {
        p := atomic.LoadPointer(&e.p)
        if p == expunged {
            return false
        }
        if atomic.CompareAndSwapPointer(&e.p, p, unsafe.Pointer(i)) {
            return true
        }
    }
}
```

`tryStore` 在 Store 函数最开始的时候就会调用，是比较常见的 `for` 循环加 CAS 操作，尝试更新 entry，让 p 指向新的值。

`unexpungeLocked` 函数确保了 entry 没有被标记成已被清除：

```text
// unexpungeLocked 函数确保了 entry 没有被标记成已被清除。
// 如果 entry 先前被清除过了，那么在 mutex 解锁之前，它一定要被加入到 dirty map 中
func (e *entry) unexpungeLocked() (wasExpunged bool) {
    return atomic.CompareAndSwapPointer(&e.p, expunged, nil)
}
```

#### Load

```text
func (m *Map) Load(key interface{}) (value interface{}, ok bool) {
    read, _ := m.read.Load().(readOnly)
    e, ok := read.m[key]
    // 如果没在 read 中找到，并且 amended 为 true，即 dirty 中存在 read 中没有的 key
    if !ok && read.amended {
        m.mu.Lock() // dirty map 不是线程安全的，所以需要加上互斥锁
        // double check。避免在上锁的过程中 dirty map 提升为 read map。
        read, _ = m.read.Load().(readOnly)
        e, ok = read.m[key]
        // 仍然没有在 read 中找到这个 key，并且 amended 为 true
        if !ok && read.amended {
            e, ok = m.dirty[key] // 从 dirty 中找
            // 不管 dirty 中有没有找到，都要"记一笔"，因为在 dirty 提升为 read 之前，都会进入这条路径
            m.missLocked()
        }
        m.mu.Unlock()
    }
    if !ok { // 如果没找到，返回空，false
        return nil, false
    }
    return e.load()
}
```

处理路径分为 fast path 和 slow path，整体流程如下：

1. 首先是 fast path，直接在 read 中找，如果找到了直接调用 entry 的 load 方法，取出其中的值。
2. 如果 read 中没有这个 key，且 amended 为 fase，说明 dirty 为空，那直接返回 空和 false。
3. 如果 read 中没有这个 key，且 amended 为 true，说明 dirty 中可能存在我们要找的 key。当然要先上锁，再尝试去 dirty 中查找。在这之前，仍然有一个 double check 的操作。若还是没有在 read 中找到，那么就从 dirty 中找。不管 dirty 中有没有找到，都要"记一笔"，因为在 dirty 被提升为 read 之前，都会进入这条路径

这里主要看下 `missLocked` 的函数的实现：

```text
func (m *Map) missLocked() {
    m.misses++
    if m.misses < len(m.dirty) {
        return
    }
    // dirty map 晋升
    m.read.Store(readOnly{m: m.dirty})
    m.dirty = nil
    m.misses = 0
}
```

直接将 misses 的值加 1，表示一次未命中，如果 misses 值小于 m.dirty 的长度，就直接返回。否则，将 m.dirty 晋升为 read，并清空 dirty，清空 misses 计数值。这样，之前一段时间新加入的 key 都会进入到 read 中，从而能够提升 read 的命中率。

再来看下 entry 的 load 方法：

```text
func (e *entry) load() (value interface{}, ok bool) {
    p := atomic.LoadPointer(&e.p)
    if p == nil || p == expunged {
        return nil, false
    }
    return *(*interface{})(p), true
}
```

对于 nil 和 expunged 状态的 entry，直接返回 `ok=false`；否则，将 p 转成 `interface{}` 返回。

#### Delete

```text
// Delete deletes the value for a key.
func (m *Map) Delete(key interface{}) {
    read, _ := m.read.Load().(readOnly)
    e, ok := read.m[key]
    // 如果 read 中没有这个 key，且 dirty map 不为空
    if !ok && read.amended {
        m.mu.Lock()
        read, _ = m.read.Load().(readOnly)
        e, ok = read.m[key]
        if !ok && read.amended {
            delete(m.dirty, key) // 直接从 dirty 中删除这个 key
        }
        m.mu.Unlock()
    }
    if ok {
        e.delete() // 如果在 read 中找到了这个 key，将 p 置为 nil
    }
}
```

可以看到，基本套路还是和 Load，Store 类似，都是先从 read 里查是否有这个 key，如果有则执行 `entry.delete` 方法，将 p 置为 nil，这样 read 和 dirty 都能看到这个变化。

如果没在 read 中找到这个 key，并且 dirty 不为空，那么就要操作 dirty 了，操作之前，还是要先上锁。然后进行 double check，如果仍然没有在 read 里找到此 key，则从 dirty 中删掉这个 key。但不是真正地从 dirty 中删除，而是更新 entry 的状态。

来看下 `entry.delete` 方法：

```text
func (e *entry) delete() (hadValue bool) {
    for {
        p := atomic.LoadPointer(&e.p)
        if p == nil || p == expunged {
            return false
        }
        if atomic.CompareAndSwapPointer(&e.p, p, nil) {
            return true
        }
    }
}
```

它真正做的事情是将正常状态（指向一个 interface{}）的 p 设置成 nil。没有设置成 expunged 的原因是，当 p 为 expunged 时，表示它已经不在 dirty 中了。这是 p 的状态机决定的，在 `tryExpungeLocked` 函数中，会将 nil 原子地设置成 expunged。

`tryExpungeLocked` 是在新创建 dirty 时调用的，会将已被删除的 entry.p 从 nil 改成 expunged，这个 entry 就不会写入 dirty 了。

```text
func (e *entry) tryExpungeLocked() (isExpunged bool) {
    p := atomic.LoadPointer(&e.p)
    for p == nil {
        // 如果原来是 nil，说明原 key 已被删除，则将其转为 expunged。
        if atomic.CompareAndSwapPointer(&e.p, nil, expunged) {
            return true
        }
        p = atomic.LoadPointer(&e.p)
    }
    return p == expunged
}
```

注意到如果 key 同时存在于 read 和 dirty 中时，删除只是做了一个标记，将 p 置为 nil；而如果仅在 dirty 中含有这个 key 时，会直接删除这个 key。原因在于，若两者都存在这个 key，仅做标记删除，可以在下次查找这个 key 时，命中 read，提升效率。若只有在 dirty 中存在时，read 起不到“缓存”的作用，直接删除。

#### LoadOrStore

这个函数结合了 Load 和 Store 的功能，如果 map 中存在这个 key，那么返回这个 key 对应的 value；否则，将 key-value 存入 map。这在需要先执行 Load 查看某个 key 是否存在，之后再更新此 key 对应的 value 时很有效，因为 LoadOrStore 可以并发执行。

具体的过程不再一一分析了，可参考 Load 和 Store 的源码分析。

#### Range

Range 的参数是一个函数：

```text
f func(key, value interface{}) bool
```

由使用者提供实现，Range 将遍历调用时刻 map 中的所有 k-v 对，将它们传给 f 函数，如果 f 返回 false，将停止遍历。

```text
func (m *Map) Range(f func(key, value interface{}) bool) {
    read, _ := m.read.Load().(readOnly)
    if read.amended {
        m.mu.Lock()
        read, _ = m.read.Load().(readOnly)
        if read.amended {
            read = readOnly{m: m.dirty}
            m.read.Store(read)
            m.dirty = nil
            m.misses = 0
        }
        m.mu.Unlock()
    }

    for k, e := range read.m {
        v, ok := e.load()
        if !ok {
            continue
        }
        if !f(k, v) {
            break
        }
    }
}
```

当 amended 为 true 时，说明 dirty 中含有 read 中没有的 key，因为 Range 会遍历所有的 key，是一个 O(n) 操作。将 dirty 提升为 read，会将开销分摊开来，所以这里直接就提升了。

之后，遍历 read，取出 entry 中的值，调用 f(k, v)。

#### 其他

关于为何 `sync.map` 没有 Len 方法，参考资料里给出了 [issue](https://link.zhihu.com/?target=https%3A//github.com/golang/go/issues/20680)，`bcmills` 认为对于并发的数据结构和非并发的数据结构并不一定要有相同的方法。例如，map 有 Len 方法，sync.map 却不一定要有。就像 sync.map 有 LoadOrStore 方法，map 就没有一样。

有些实现增加了一个计数器，并原子地增加或减少它，以此来表示 sync.map 中元素的个数。但 `bcmills` 提出这会引入竞争：`atomic` 并不是 `contention-free` 的，它只是把竞争下沉到了 CPU 层级。这会给其他不需要 Len 方法的场景带来负担。

#### 总结

1. `sync.map` 是线程安全的，读取，插入，删除也都保持着常数级的时间复杂度。
2. 通过读写分离，降低锁时间来提高效率，适用于读多写少的场景。
3. Range 操作需要提供一个函数，参数是 `k,v`，返回值是一个布尔值：`f func(key, value interface{}) bool`。
4. 调用 Load 或 LoadOrStore 函数时，如果在 read 中没有找到 key，则会将 misses 值原子地增加 1，当 misses 增加到和 dirty 的长度相等时，会将 dirty 提升为 read。以期减少“读 miss”。
5. 新写入的 key 会保存到 dirty 中，如果这时 dirty 为 nil，就会先新创建一个 dirty，并将 read 中未被删除的元素拷贝到 dirty。
6. 当 dirty 为 nil 的时候，read 就代表 map 所有的数据；当 dirty 不为 nil 的时候，dirty 才代表 map 所有的数据。

## sync.Mutex

`sync.Mutex` 可能是 `sync` 包中使用最广泛的原语。它允许在共享资源上互斥访问（不能同时访问）：

```go
mutex := &sync.Mutex{}

mutex.Lock()
// Update共享变量 (比如切片，结构体指针等)
mutex.Unlock()
```

必须指出的是，在第一次被使用后，不能再对 `sync.Mutex` 进行复制。（`sync` 包的所有原语都一样）。如果结构体具有同步原语字段，则必须**通过指针传递**它。

## sync.RWMutex

互斥锁是完全互斥的，但是有很多实际的场景下是读多写少的，当我们并发的去读取一个资源不涉及资源修改的时候是没有必要加锁的，这种场景下使用读写锁是更好的一种选择。

`sync.RWMutex` 是一个读写互斥锁，它提供了我们上面的刚刚看到的 `sync.Mutex` 的 `Lock` 和 `UnLock` 方法（因为这两个结构都实现了 `sync.Locker` 接口）。但是，它还允许使用 `RLock` 和 `RUnlock` 方法进行并发读取

读写锁分为两种：读锁和写锁。当一个 goroutine 获取读锁之后，其他的 goroutine 如果是获取读锁会继续获得锁，如果是获取写锁就会等待；当一个 goroutine 获取写锁之后，其他的 goroutine 无论是获取读锁还是写锁都会等待。

```go
mutex := &sync.RWMutex{}

mutex.Lock()
// Update 共享变量
mutex.Unlock()

mutex.RLock()
// Read 共享变量
mutex.RUnlock()
```

示例：

```go
var (
    x      int64
    wg     sync.WaitGroup
    lock   sync.Mutex
    rwlock sync.RWMutex
)

func write() {
    rwlock.Lock() // 加写锁
    x = x + 1
    time.Sleep(10 * time.Millisecond) // 假设读操作耗时10毫秒
    rwlock.Unlock()                   // 解写锁
    wg.Done()
}

func read() {
    rwlock.RLock()               // 加读锁
    time.Sleep(time.Millisecond) // 假设读操作耗时1毫秒
    rwlock.RUnlock()             // 解读锁
    wg.Done()
}

func main() {
    start := time.Now()
    for i := 0; i < 10; i++ {
        wg.Add(1)
        go write()
    }

    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go read()
    }

    wg.Wait()
    end := time.Now()
    fmt.Println(end.Sub(start))
}
```

`sync.RWMutex` 允许多个读锁或一个写锁存在，而 `sync.Mutex` 允许一个读锁或一个写锁存在。

通过基准测试来比较这几个方法的性能：

```text
BenchmarkMutexLock-4       83497579         17.7 ns/op
BenchmarkRWMutexLock-4     35286374         44.3 ns/op
BenchmarkRWMutexRLock-4    89403342         15.3 ns/op
```

可以看到锁定/解锁 `sync.RWMutex` 读锁的速度比锁定/解锁 `sync.Mutex` 更快，另一方面，在 `sync.RWMutex` 上调用 `Lock()` /  `Unlock()` 是最慢的操作。

可以看到读写锁非常适合读多写少的场景，如果读和写的操作差别不大，读写锁的优势就发挥不出来。

## sync.WaitGroup

`sync.WaitGroup` 也是一个经常会用到的同步原语，它的使用场景是在一个 `goroutine` 等待一组 `goroutine` 执行完成。

`sync.WaitGroup` 拥有一个内部计数器。当计数器等于 `0` 时，则 `Wait()` 方法会立即返回。否则它将阻塞执行 `Wait()` 方法的 `goroutine` 直到计数器等于 `0` 时为止。

要增加计数器，我们必须使用 `Add(int)` 方法。要减少它，我们可以使用 `Done()`（将计数器减 `1`），也可以传递负数给 `Add` 方法把计数器减少指定大小，`Done()` 方法底层就是通过 `Add(-1)` 实现的。

在以下示例中，我们将启动八个 `goroutine`，并等待他们完成：

```go
wg := &sync.WaitGroup{}

for i := 0; i < 8; i++ {
  wg.Add(1)
  go func() {
    // Do something
    wg.Done()
  }()
}

wg.Wait()
// 继续往下执行...
```

每次创建 `goroutine` 时，我们都会使用 `wg.Add(1)` 来增加 `wg` 的内部计数器。我们也可以在 `for` 循环之前调用 `wg.Add(8)`。

与此同时，每个 `goroutine` 完成时，都会使用 `wg.Done()` 减少 `wg` 的内部计数器。

`main goroutine` 会在八个 `goroutine` 都执行 `wg.Done()` 将计数器变为 `0` 后才能继续执行。

## sync.Pool

`sync.Pool` 是一个并发池，负责安全地保存一组对象。它有两个导出方法：

- `Get() interface{}` 用来从并发池中取出元素。
- `Put(interface{})` 将一个对象加入并发池。

```go
pool := &sync.Pool{}

pool.Put(NewConnection(1))
pool.Put(NewConnection(2))
pool.Put(NewConnection(3))

connection := pool.Get().(*Connection)
fmt.Printf("%d\n", connection.id)
connection = pool.Get().(*Connection)
fmt.Printf("%d\n", connection.id)
connection = pool.Get().(*Connection)
fmt.Printf("%d\n", connection.id)
```

输出：

```text
1
3
2
```

需要注意的是 `Get()` 方法会从并发池中**随机**取出对象，无法保证以固定的顺序获取并发池中存储的对象。

还可以为 `sync.Pool` 指定一个创建者方法：

```go
pool := &sync.Pool{
  New: func() interface{} {
    return NewConnection()
  },
}

connection := pool.Get().(*Connection)
```

这样每次调用 `Get()`时，将返回由在 `pool.New` 中指定的函数创建的对象（在本例中为指针）。

那么什么时候使用 sync.Pool？有两个用例：

第一个是当我们必须重用共享的和长期存在的对象（例如，数据库连接）时。第二个是用于优化内存分配。

让我们考虑一个写入缓冲区并将结果持久保存到文件中的函数示例。使用 `sync.Pool`，我们可以通过在不同的函数调用之间重用同一对象来重用为缓冲区分配的空间。 第一步是检索先前分配的缓冲区（如果是第一个调用，则创建一个缓冲区，但这是抽象的）。然后，`defer` 操作是将缓冲区放回 `sync.Pool` 中。

```go
func writeFile(pool *sync.Pool, filename string) error {
    buf := pool.Get().(*bytes.Buffer)
	
    defer pool.Put(buf)

    // Reset 缓存区，不然会连接上次调用时保存在缓存区里的字符串foo
    // 编程foofoo 以此类推
    buf.Reset()

    buf.WriteString("foo")

    return ioutil.WriteFile(filename, buf.Bytes(), 0644)
}
```

## sync.Once

`sync.Once` 是一个简单而强大的原语，**确保一个函数仅执行一次**。在下面的示例中，只有一个 `goroutine` 会显示输出消息：

```go
once := &sync.Once{}
for i := 0; i < 4; i++ {
    i := i
    go func() {
        once.Do(func() {
            fmt.Printf("first %d\n", i)
        })
    }()
}
```

我们使用了 `Do(func ())` 方法来指定只能被调用一次的部分。

## sync.Cond

`sync.Cond` 可能是 `sync` 包提供的同步原语中最不常用的一个，它用于发出信号（一对一）或广播信号（一对多）到 `goroutine`

让我们考虑一个场景，我们必须向一个 `goroutine` 指示共享切片的第一个元素已更新。创建 `sync.Cond` 需要 `sync.Locker` 对象（`sync.Mutex` 或 `sync.RWMutex`）：

```go
cond := sync.NewCond(&sync.Mutex{})
```

然后，让我们编写负责显示切片的第一个元素的函数：

```go
func printFirstElement(s []int, cond *sync.Cond) {
    cond.L.Lock()
    cond.Wait()
    fmt.Printf("%d\n", s[0])
    cond.L.Unlock()
}
```

我们可以使用 `cond.L` 访问内部的互斥锁。一旦获得了锁，我们将调用 `cond.Wait()`，这会让当前 `goroutine` 在收到信号前一直处于阻塞状态。

让我们回到 `main goroutine`。我们将通过传递共享切片和先前创建的 `sync.Cond` 来创建 `printFirstElement` 池。然后我们调用 `get()` 函数，将结果存储在 `s[0]` 中并发出信号：

```go
s := make([]int, 1)
for i := 0; i < runtime.NumCPU(); i++ {
    go printFirstElement(s, cond)
}

i := get()
cond.L.Lock()
s[0] = i
cond.Signal()
cond.L.Unlock()
```

这个信号会解除一个 `goroutine` 的阻塞状态，解除阻塞的 `goroutine` 将会显示 `s[0]` 中存储的值。

但是，有的人可能会争辩说我们的代码破坏了 `Go` 的最基本原则之一：

> 不要通过共享内存进行通信；而是通过通信共享内存。

确实，在这个示例中，最好使用 `channel` 来传递 `get()` 返回的值。但是我们也提到了 `sync.Cond` 也可以用于广播信号。我们修改一下上面的示例，把`Signal()` 调用改为调用 `Broadcast()`。

```go
i := get()
cond.L.Lock()
s[0] = i
cond.Broadcast()
cond.L.Unlock()
```

在这种情况下，所有 goroutine 都将被触发。 众所周知，`channel` 里的元素只会由一个 `goroutine` 接收到。**通过 `channel` 模拟广播的唯一方法是关闭 `channel`。**

> 当一个 channel 被关闭后，channel 中已经发送的数据都被成功接收后，后续的接收操作将不再阻塞，它们会立即返回一个零值。

但是这种方式只能广播一次。因此，尽管存在很大争议，但这无疑是`sync.Cond`的一个有趣的功能。