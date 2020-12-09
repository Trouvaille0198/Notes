# 一、数据结构

## 1.1 定义

- 数据元素（Data Element）：数据的基本单位
- 数据项（Data Item）：用来描述数据元素，是数据的最小单位
- 数据对象：具有相同性质的数据元素集合
- 数据结构（Data Structure） = 数据对象 + 结构

## 1.2 构成

- 逻辑结构
  - 集合
  - 线性结构
  - 树形结构
  - 图形结构（网状结构）

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201130131301667.png" alt="image-20201130131301667" style="zoom:67%;" />

- 物理结构（存储结构）

  - 顺序存储：将逻辑上相邻的元素存储在物理位置上也相邻的存储单元中
  - 链式存储
  - 索引存储
  - 散列存储（哈希存储）

- 数据运算

  运算描述针对逻辑结构，运算实现针对存储结构

# 二、算法

## 2.1 特质

- 有穷性：必须执行有限次运算来实现
- 确定性：对于同意输入只能得到相同输出
- 有效性：含义明确，规定严格
- 输入性：可以有零个或多个输入
- 输出性：可以由一个或多个输出

## 2.2 描述

- 自然语言（Natural Language）
- 流程图（FlowChart）

- 类程序设计语言（Similar-programming Language）

## 2.3 评估

- 正确性（Correctness）
- 可用性（Usability）
- 可读性（Readability）
- 健壮性（Robustness）
- 效率（Efficiency）：时间代价+空间代价，需要用算法分析（Analytic Method）进行评估
- 可移植性（Mobility）
- 可测试性（Testability）

## 2.4 复杂度

### 2 4.1 时间复杂度（Time Complexity）

时间开销$T(n)$与问题规模$n$之间的关系

1. 方法
   1. 频度统计法：确定$O(f(n))$
   2. 渐进时间复杂度：知晓级数即可
   
2. 依赖于数据的算法：采用平均复杂度

3. 常见的时间复杂度

   常对幂指阶
   
   $O(1)<O(\log_2n<O(n)<O(n\log_2n)<O(n^2)<O(n^3)<O(2^n)<O(n!)<O(n^n)$

### 2.4.2 空间复杂度（Space Complexity）

空间开销（内存开销）$S(n)$与问题规模$n$之间的关系

原地工作：算法所需内存空间为常量，即$S(n)=O(1)$

递归调用的空间复杂度=递归调用的深度

# 三、线性表

## 3.1 定义

n个**相同类型**数据元素的**有限**序列，记为$L=(a_1,a_2,\ldots,a_n)$

L称为表名，n称为表长，$a_i$：第i个称为位序，$a_1$称为首元素，$a_n$称为末元素

除首元素，其他元素拥有一个直接前驱；除末元素，其他元素拥有一个直接后继

## 3.2 基本操作

1. 初始化 InitList(&L)

2. 求长度 Length(L)

3. 取指定元素的值 GetElem(i, &e)

4. 元素定位 Locate(&e)

5. 修改指定元素的值 SetElem(i, &e)

6. 插入 ListInsert(&L,i,e)

7. 删除 ListDelete(&L,i,&e)

8. 判断是否是空表 Empty(L)

9. 表清空 Clear()

## 3.3 顺序表（Sequential List）

顺序表是用顺序存储的方式来实现的线性表

若用静态数组，表长一旦确定便不可更改，建议使用动态数组

- 特点
  1. **随机访问**，在$O(1)$时间内找到第i个元素
  2. 存储密度高（=1），每个节点只存储数据元素，不记录相对关系，节省空间
  3. 因为设置了最大容量，空间会有富余，较为浪费
  4. 扩展容量不方便
  5. 插入、删除操作不方便，需要移动大量元素

### 3.3.1 类模板定义

第$i$个元素的数组索引为$i-1$

```C++
template <class ElemType>
class SeqList
{
protected:
	// 顺序表的数据成员
	int length;		 // 顺序表的当前长度
	int maxLength;	 // 顺序表的最大容量
	ElemType *elems; // 元素存储空间的首地址

public:
	// 顺序表的函数成员
	SeqList(int size = DEFAULT_SIZE);						   // 构造一个空表
	SeqList(ElemType v[], int n, int size = DEFAULT_SIZE);	   // 根据数组v的内容构造顺序表
	virtual ~SeqList();										   // 析构函数
	int GetLength() const;									   // 取顺序表长度
	bool IsEmpty() const;									   // 判断顺序表是否为空
	void Clear();											   // 将顺序表清空
	void Traverse(void (*Visit)(const ElemType &)) const;	   // 遍历顺序表
	int LocateElem(const ElemType &e) const;				   // 元素定位，求指定元素在顺序表中的位置
	Status GetElem(int i, ElemType &e) const;				   // 取顺序表中第i个元素的值
	Status SetElem(int i, const ElemType &e);				   // 修改顺序表中第i个元素的值
	Status DeleteElem(int i, ElemType &e);					   // 删除顺序表中第i个元素
	Status InsertElem(int i, const ElemType &e);			   // 在顺序表第i个位置插入元素
	Status InsertElem(const ElemType &e);					   // 在顺序表表尾插入元素
	SeqList(const SeqList<ElemType> &sa);					   // 复制构造函数
	SeqList<ElemType> &operator=(const SeqList<ElemType> &sa); // 赋值语句重载
}
```

### 3.3.2 具体实现

### 3.3.3 复杂度分析

- 在任意位置插入、删除一个数据元素：$O(n)$
- 定位、遍历、构造函数、重载赋值：$O(n)$
- 其他函数：$O(1)$

## 3.4 链表（Linked List）

采用链接存储方式存储的线性表称为线性链表（Linked List），信息域+指针域

- 特点
  1. 不要求连续空间，逻辑上相邻的元素，物理上不用相邻
  2. **顺序访问**，下标无助于访存
  3. 插入、删除元素无需大量移动
  4. 易于动态扩展
  5. 存储密度>1

### 3.4.1 单链表

一个节点由两个域组成，data域存放数据元素，next域存放指向下一节点的指针

一般多用带有头节点的单链表（第一个节点为空）

欲得知已知节点的前节点，需要顺序访问；欲得知已知节点的后节点，仅需使用next指针

#### 1）节点类模板定义

```c++
template <class ElemType>
struct Node
{
	// 数据成员:
	ElemType data;		  // 数据域
	Node<ElemType> *next; // 指针域

	// 构造函数:
	Node();										   // 无参数的构造函数
	Node(ElemType e, Node<ElemType> *link = NULL); // 已知数数据元素值和指针建立结构
}
```

#### 2）节点实现

```c++
// 结点类的实现部分
template <class ElemType>
Node<ElemType>::Node()
// 操作结果：构造指针域为空的结点
{
	next = NULL;
}

template <class ElemType>
Node<ElemType>::Node(ElemType e, Node<ElemType> *link)
// 操作结果：构造一个数据域为e和指针域为link的结点
{
	data = e;
	next = link;
}
```

#### 2）链表类模板定义

```c++
template <class ElemType>
class LinkList
{
protected:
	//  单链表的数据成员
	Node<ElemType> *head; // 头结点指针
	int length;			  // 单链表长度

public:
	//  单链表的函数成员
	LinkList();													 // 无参数的构造函数
	LinkList(ElemType v[], int n);								 // 有参数的构造函数
	virtual ~LinkList();										 // 析构函数
	int GetLength() const;										 // 求单链表长度
	bool IsEmpty() const;										 // 判断单链表是否为空
	void Clear();												 // 将单链表清空
	void Traverse(void (*Visit)(const ElemType &)) const;		 // 遍历单链表
	int LocateElem(const ElemType &e) const;					 // 元素定位
	Status GetElem(int position, ElemType &e) const;			 // 求指定位置的元素
	Status SetElem(int position, const ElemType &e);			 // 设置指定位置的元素值
	Status DeleteElem(int position, ElemType &e);				 // 删除元素
	Status InsertElem(int position, const ElemType &e);			 // 在制定位置插入元素
	Status InsertElem(const ElemType &e);						 // 在表尾插入元素
	LinkList(const LinkList<ElemType> &la);						 // 复制构造函数
	LinkList<ElemType> &operator=(const LinkList<ElemType> &la); // 重载赋值运算
}
```

### 3.4.2 双向循环链表

### 3.4.3 静态链表

用数组方式存储数据，但数据间关系模拟链式存储