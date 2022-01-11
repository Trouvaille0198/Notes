# 实验三 请求页式存储管理

## 实验目的与要求

### 目的

近年来，由于大规模集成电路（LSI）和超大规模集成电路（VLSI）技术的发展，使存储器的容量不断扩大， 
价格大幅度下降。但从使用角度看，存储器的容量和成本总受到一定的限制。

所以，提高存储器的效率始终是操作 系统研究的重要课题之一。虚拟存储技术是用来扩大内存容量的一种重要方法。学生应独立地用高级语言编写几个常用的存储分配算法，并设计一个存储管理的模拟程序，对各种算法进行分析比较，评测其性能优劣，从而加深对 这些算法的了解。 

### 要求

为了比较真实地模拟存储管理，可预先生成一个大致符合实际情况的指令地址流。然后模拟这样一种指令序列的执行来计算和分析各种算法的访问命中率。

## 实验环境

- 操作系统：windows 10
- 编程语言：GoLang 1.17.5
- IDE：JetBrain GoLand 2021.3.1

## 实验内容及其设计与实现

### 指令地址流生成

#### 模拟生成

按以下规则模拟真实情况的指令地址流：

- 50% 的指令顺序执行。
- 25% 的指令均匀散布在前地址部分。
- 25% 的指令均匀散布在后地址部分

```go
//  getWeightedChooser
//  @Description: 获取指令地址分布权重表
//  @return *utils.Chooser
func getWeightedChooser() *utils.Chooser {
   chooser, _ := utils.NewChooser(
      utils.NewChoice("front", 25),
      utils.NewChoice("end", 25),
      utils.NewChoice("prev", 50),
   )
   return chooser
}

// AddressStream
// @description 地址流
type AddressStream struct {
   length    int
   addresses []int
}

// NewAddressStream
// @param addressNum 指令个数
// @param virtualMemorySize 虚存大小 以k为单位
func NewAddressStream(addressNum int, virtualMemorySize int) *AddressStream {
   virtualMemorySize *= 1024
   rs := rand.New(rand.NewSource(time.Now().UTC().UnixNano())) // 随机数种子
   addresses := make([]int, addressNum)
   chooser := getWeightedChooser()

   addresses[0] = rs.Intn(virtualMemorySize)
   for i := 1; i < addressNum; i++ {
      initForm := chooser.PickSource(rs) // 按照权重选择一项生成策略
      switch initForm {
      case "front":
         randAddress := rs.Intn(virtualMemorySize / 2)
         addresses[i] = randAddress
      case "end":
         randAddress := rs.Intn(virtualMemorySize/2) + virtualMemorySize/2
         addresses[i] = randAddress
      case "prev":
         addresses[i] = addresses[i-1] + 1
      }
   }
   return &AddressStream{length: addressNum, addresses: addresses}
}

// GetAddressPages
// @description 获取指令地址对应的页号
// @receiver a
// @param pageSize 页大小 以k为单位
// @return []int 指令的页号列表
func (a *AddressStream) GetAddressPages(pageSize int) []int {
	addressPages := make([]int, len(a.addresses))
	for i, address := range a.addresses {
		addressPages[i] = address/(pageSize*1024) + 1
	}
	return addressPages
}
```

顺序生成的指令地址流，大都处于同一页中，符合现实情况

#### 使用真实地址流

为了体现局部性原理，我们编写了 python 脚本，获取计算机中真实运行的进程地址

```python
# made by 王启隆
import os
import re
import time
import string
import psutil

# 统计某一个进程名所占用的内存，同一个进程名，可能有多个进程
def countProcessMemoey(processName):
    pattern = re.compile(r'([^\s]+)\s+(\d+)\s.*\s([^\s]+\sK)')
    cmd = 'tasklist /fi "imagename eq ' + processName + \
        '"' + ' | findstr.exe ' + '"' + processName + '"'
    # findstr后面的程序名加上引号防止出现程序带有空格
    result = os.popen(cmd).read()
    resultList = result.split("\n")
    pids = []
    for srcLine in resultList:
        srcLine = "".join(srcLine.split('\n'))
        if len(srcLine) == 0:
            break
        m = pattern.search(srcLine)
        if m == None:
            continue
        # 由于是查看python进程所占内存，因此通过pid将本程序过滤掉
        if str(os.getpid()) == m.group(2):
            continue
        ori_mem = m.group(3).replace(',', '')
        ori_mem = ori_mem.replace(' K', '')
        ori_mem = ori_mem.replace(r'\sK', '')
        memEach = int(ori_mem)
        pids.append(m.group(2))
    return pids


if __name__ == '__main__':
    lis = []
    pids = psutil.pids()
    for pid in pids:
        p = psutil.Process(pid)
        lis.append(str(p.name()))
    results = []
    for i in lis[:50]:
        ProcessName = i  # 进程名
        results.extend(countProcessMemoey(ProcessName))
    with open("./addrs.txt", "w") as f_b:
        f_b.write(",".join(results))
```

脚本最终将进程地址流保存到文件里，以便在 Go 中读取

```go
// 采用真实地址流
f, err := ioutil.ReadFile("./as.txt")
if err != nil {
   return &AddressStream{}, err
}
for i, addr := range strings.Split(string(f), ",")[:addressNum] {
   addresses[i], err = strconv.Atoi(addr)
   if err != nil {
      panic("error when reading address file")
   }
}
```

### 页面置换算法

#### 事先准备

定义一个页式管理器，接收指定的指令个数、虚存大小、页大小和内存容量，生成指令地址流

```go
// PageReplacer
// @description 请求页式管理 其中实现了多种页面置换算法
type PageReplacer struct {
   pageSize     int
   internalSize int
   addressPage  []int
}

// NewPageReplacer
// @param addressNum 指令个数
// @param virtualMemorySize 虚存大小 以k为单位
// @param pageSize 页大小 以k为单位
// @param internalSize 内存能容纳页的个数
func NewPageReplacer(
   addressNum int, virtualMemorySize int, pageSize int, internalSize int) *PageReplacer {
   addressStream := NewAddressStream(addressNum, virtualMemorySize)
   addressPage := addressStream.GetAddressPages(pageSize)
   return &PageReplacer{pageSize: pageSize, addressPage: addressPage, internalSize: internalSize}
}
```

#### OPT 算法

最佳置换算法，发生缺页时，淘汰以后永不使用或是在未来最迟被访问到的页面。OPT 算法要求事先知晓未来所有的指令流顺序，是一种最优算法，但是在实际情况中不可能实现。

模拟实现下，发生缺页且内存已满时，程序将遍历之后的地址流，在驻留内存页号中选择一个于未来最迟被访问（或永不访问）的页号，将其置换出内存。

```go
func (r PageReplacer) OPT() float32 {
	internalPages := make([]int, 0) // 记录内存中的页面
	failCount := 0                  // 未命中次数
	for i, pageNo := range r.addressPage {
		if !utils.IsContainInt(internalPages, pageNo) {
			// 未命中
			failCount++
			if len(internalPages) == r.internalSize {
				// 内存已满 欲淘汰一页
				latestPageIndex := -1 // 记录内存页号列表中在未来最迟访问的页号索引

				internalPagesCopy := make([]int, r.internalSize)
				copy(internalPagesCopy, internalPages)
				for _, afterPageNo := range r.addressPage[i+1:] {
					if utils.IsContainInt(internalPagesCopy, afterPageNo) {
						latestPageIndex, _ = utils.GetIndexInt(internalPages, afterPageNo) // 记录当前最迟访问到的页号索引
						internalPagesCopy, _ = utils.DeleteByElemInt(internalPagesCopy, afterPageNo)
					}
				}
				if len(internalPagesCopy) != 0 {
					// 内存中存在一页 其之后都不会被访问到
					internalPages, _ = utils.DeleteByElemInt(internalPages, internalPagesCopy[0])
				} else {
					internalPages, _ = utils.DeleteByIndexInt(internalPages, latestPageIndex)
				}
			}
			internalPages = append(internalPages, pageNo)
		}
	}
	return 1 - float32(failCount)/float32(len(r.addressPage))
}
```

#### LRU 算法

最近最久未使用算法，该算法选择最近最久未使用的页面予以淘汰。

模拟程序采用栈来实现页面的置换。命中时，将命中页从栈中移出（这显然不符合严格的栈操作），放入栈顶；当缺页发生且栈满时，将栈底页弹出，放入新页面至栈顶。

```go
func (r PageReplacer) LRU() float32 {
	internalPages := make([]int, 0) // 记录内存中的页面
	failCount := 0                  // 未命中次数
	for _, pageNo := range r.addressPage {
		if !utils.IsContainInt(internalPages, pageNo) {
			// 未命中
			failCount++
			if len(internalPages) == r.internalSize {
				// 内存已满 将栈底页面淘汰
				internalPages, _ = utils.DeleteByIndexInt(internalPages, 0)
			}
			internalPages = append(internalPages, pageNo)
		} else {
			// 命中 将命中页面提升至栈顶
			internalPages, _ = utils.DeleteByElemInt(internalPages, pageNo)
			internalPages = append(internalPages, pageNo)
		}
	}
	return 1 - float32(failCount)/float32(len(r.addressPage))
}
```

#### FIFO 算法

先进先出方法，比较简单，使用队列实现即可

```go
func (r PageReplacer) FIFO() float32 {
	internalPages := make([]int, 0) // 记录内存中的页面
	failCount := 0                  // 未命中次数
	for _, pageNo := range r.addressPage {
		if !utils.IsContainInt(internalPages, pageNo) {
			// 未命中
			failCount++
			if len(internalPages) == r.internalSize {
				// 内存已满 将队头页面淘汰
				internalPages, _ = utils.DeleteByIndexInt(internalPages, 0)
			}
			internalPages = append(internalPages, pageNo)
		}
	}
	return 1 - float32(failCount)/float32(len(r.addressPage))
}
```

### 算法命中率比较

内存容量从 4 页到 32 页，页面尺寸从 1k 到 8k，模拟页面置换的过程，得出三种算法的命中率

```go
func TestAlphaReader(t *testing.T) {
   virtualMemorySize := 32
   addressNum := 255
   fmt.Printf(
      "%-10s %-12s %-10s %-10s %-10s \n",
      "PageSize", "MemorySize", "OPT", "LRU", "FIFO")
   for i := 0; i < 7; i++ {
      internalSize := (i + 1) * 4 // 每次翻四倍
      for j := 0; j < 8; j++ {
         pageSize := j + 1
         r := NewPageReplacer(
            addressNum, virtualMemorySize, pageSize, internalSize)
         r.DisplayResult()
      }
      fmt.Println()
   }
}
```

![image-20211224162505095](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211224162505095.png)

![image-20211224162528844](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211224162528844.png)

![image-20211224162534586](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211224162534586.png)

![image-20211224162541724](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211224162541724.png)

可以看到，LRU 算法的命中率代表了算法上限，LRU 与 FIFO 算法效率相近。

随着内存容量和单页大小的增大，命中率通常也是越来越高的。

## 收获与体会

本次实验模拟了三种页面置换算法，我对请求页式管理的原理内容有了进一步的理解与体会。我首先使用 Python 编写程序，随后尝试使用 GoLang 重构代码。GoLang 相对来说更加精简，但是不那么“面向对象”，同时缺乏优质的语法糖，许多细节（如切片的查询、插入、删除，根据权重选择条目的算法）需要自己来实现，这花了我不少精力，这也对这门语言有了更深刻的理解。