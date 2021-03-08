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

### 2 4.1 时间复杂度

（Time Complexity）

时间开销$T(n)$与问题规模$n$之间的关系

1. 方法
   1. 频度统计法：确定$O(f(n))$
   2. 渐进时间复杂度：知晓级数即可
   
2. 依赖于数据的算法：采用平均复杂度

3. 常见的时间复杂度

   常对幂指阶
   
   $O(1)<O(\log_2n)<O(n)<O(n\log_2n)<O(n^2)<O(n^3)<O(2^n)<O(n!)<O(n^n)$

### 2.4.2 空间复杂度

（Space Complexity）

空间开销（内存开销）$S(n)$与问题规模$n$之间的关系

原地工作：算法所需内存空间为常量，即$S(n)=O(1)$

递归调用的空间复杂度=递归调用的深度

# 三、线性表

## 3.1 定义

n 个**相同类型**数据元素的**有限**序列，记为 $L=(a_1,a_2,\ldots,a_n)$

L 称为表名，n 称为表长，$a_i$：第 i 个称为位序，$a_1$ 称为首元素，$a_n$ 称为末元素

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
  2. 存储密度高（=1），每个结点只存储数据元素，不记录相对关系，节省空间
  3. 因为设置了最大容量，空间会有富余，较为浪费
  4. 扩展容量不方便
  5. 插入、删除操作不方便，需要移动大量元素

### 3.3.1 类模板定义

第$i$个元素的数组索引为$i-1$

```C++
template <class T>
class SeqList
{
protected:
    static const int DEFAULT_SIZE = 100;
    int _length;
    int _maxlen;
    T *_data;

public:
    SeqList(int maxlen = DEFAULT_SIZE);                   //建立空表
    SeqList(T *a, int length, int maxlen = DEFAULT_SIZE); //根据数组创建新表
    SeqList(const SeqList<T> &sa);                        //拷贝构造函数
    virtual ~SeqList();                                   //析构函数
    SeqList<T> &operator=(const SeqList<T> &sa);          //赋值运算符重载

    void ClearList();                 //清空顺序表，暂时不知道有啥用
    int GetLength() const;            //返回长度
    bool IsEmpty() const;             //判空
    bool IsFull() const;              //判满
    void DisplayList() const;         //遍历显示顺序表
    int LocateElem(const T &e) const; //元素定位，返回指定元素位置

    T GetElem(int i) const;             //查找元素，返回查找的元素
    void SetElem(int i, const T &e);    //修改i位置的元素值
    void InsertElem(int i, const T &e); //在i位置插入新元素
    void InsertElem(const T &e);        //在末尾插入新元素
    void DeleteElemByIndex(int i);      //删除i位置的元素
    void DeleteElemByValue(const T &e); //删除指定元素
};
```

### 3.3.2 具体实现

#### 1）构造函数

```python
template <class T>
SeqList<T>::SeqList(int maxlen) : _length(0), _maxlen(maxlen)
{
    _data = new T[_maxlen]; //申请存储空间
}
```

```python
template <class T>
SeqList<T>::SeqList(T *a, int length, int maxlen) : _length(length), _maxlen(maxlen)
{
    _data = new T[maxlen];
    for (int i = 0; i < length; i++)
        _data[i] = a[i];
}
```

#### 1）插入元素

```c++
template <class T>
void SeqList<T>::InsertElem(int i, const T &e)
{
    if (IsFull())
    {
        cout << "线性表已满,不可添加新元素!" << endl;
        return;
    }
    if (i < 1 || i > _length)
    {
        cout << "位置不合理！" << endl;
        return;
    }
    else
    {
        for (int j = _length; j >= i; j--) //i后的元素向后移动一格
        {
            _data[j] = _data[j - 1];
        }
        _data[i - 1] = e;
        _length++; //总长+1
    }
}
```

#### 3）删除元素

```c++
template <class T>
void SeqList<T>::DeleteElemByIndex(int i)
{
    if (IsEmpty())
    {
        cout << "线性表已空,不可删除元素!" << endl;
        return;
    }
    if (i < 1 || i > _length)
    {
        cout << "位置不合理！" << endl;
        return;
    }
    for (int j = i - 1; j < _length - 1; j++)
    {
        _data[j] = _data[j + 1];
    }
    _length--;
}
```

### 3.3.3 复杂度分析

- 在任意位置插入、删除一个数据元素：$O(n)$
- 定位、遍历、构造函数、重载赋值：$O(n)$
- 其他函数：$O(1)$

## 3.4 链表

（Linked List）

采用链接存储方式存储的线性表称为线性链表（Linked List），信息域 + 指针域

- 特点
  1. 不要求连续空间，逻辑上相邻的元素，物理上不用相邻
  2. **顺序访问**，下标无助于访存
  3. 插入、删除元素无需大量移动
  4. 易于动态扩展
  5. 存储密度 >1

### 3.4.1 单链表

一个结点由两个域组成，data域存放数据元素，next域存放指向下一结点的指针

一般多用带有头结点的单链表（第一个结点为空）

欲得知已知结点的前结点，需要顺序访问；欲得知已知结点的后结点，仅需使用next指针

#### 1）结点类模板定义

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

#### 2）结点实现

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

（Double Circular List）

### 3.4.3 静态链表

（Static List）

用数组方式存储数据，但数据间关系模拟链式存储，适用于不支持指针的语言。

# 四、栈、队列和递归

栈和队列都是受限的线性表

## 4.1 栈

（Stack）

限制存取位置的顺序表，只可在表尾位置插入和删除，所谓后进先出（Last In First Out, LIFO）允许插入删除的一端称为栈顶（top），不允许的一端称为栈底（bottom）。

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201214080922294.png" alt="image-20201214080922294" style="zoom:67%;" />

- 基本操作
  - 初始化
  - 求长度
  - 取栈顶元素
  - 进栈（push，也叫压入）
  - 出栈（pop，也叫弹出）
  - 判断是否为空栈清空栈

### 4.1.1 顺序栈

#### 1）类模板定义

```c++
template <class T>
class SeqStack
{
protected:
    static const int DEFAULT_SIZE = 100;
    int _top; //_top从0开始
    int _maxlen;
    T *_data;

public:
    SeqStack(int maxlen = DEFAULT_SIZE);           //建立空栈
    SeqStack(const SeqStack<T> &sa);               //拷贝构造函数
    virtual ~SeqStack();                           //析构函数
    SeqStack<T> &operator=(const SeqStack<T> &sa); //赋值运算符重载

    void ClearStack();         //清空顺序表
    int GetLength() const;     //返回长度
    bool IsFull() const;       //判满
    bool IsEmpty() const;      //判空
    void DisplayStack() const; //遍历显示顺序表

    void PushElem(const T &e); //入栈
    T TopElem();               //取栈顶元素
    void PopElem();            //出栈
};
```

#### 2）具体定义

````c++
template <class T>
void SeqStack<T>::PushElem(const T &e)
//入栈
{
    if (IsFull())
        cout << "顺序栈已满！" << endl;
    else
        _data[++_top] = e;
}

template <class T>
T SeqStack<T>::TopElem()
//取栈顶元素
{
    if (IsEmpty())
    {
        cout << "顺序栈已空，无法取出栈顶元素！" << endl;
        //return NULL;
    }
    else
    {
        return _data[_top];
    }
}

template <class T>
void SeqStack<T>::PopElem()
//出栈
{
    if (IsEmpty())
    {
        cout << "顺序栈已空，无法继续出栈！" << endl;
        return;
    }
    else
    {
        _top--;
    }
}
````

#### 3）共享存储空间的双顺序栈

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201214083413534.png" alt="image-20201214083413534" style="zoom:67%;" />



### 4.1.2 链式栈

与顺序栈相比，链式栈对于同时使用多个栈的情况下可以共享存储

用不带头结点的的单链表示链式栈，且头指针表示top

#### 1）类模板定义

```c++
template <class T>
class LinkStack
{
protected:
    //不设头结点，_top为第一个节点
    Node<T> *_top;

public:
    LinkStack();
    virtual ~LinkStack();
    LinkStack(const LinkStack<T> &la);
    LinkStack<T> &operator=(const LinkStack<T> &la);

    void ClearStack();
    bool IsEmpty() const;
    int GetLength() const;
    void DisplayStack() const;

    void PushElem(const T &e);
    T TopElem();
    void PopElem();
};
```

#### 1）具体实现

```c++
template <class T>
void LinkStack<T>::PushElem(const T &e)
//入栈
{
    Node<T> *p = new Node<T>(e, _top);
    if (p == NULL)
        cout << "动态内存耗尽！" << endl;
    else
        _top = p;
}

template <class T>
T LinkStack<T>::TopElem()
//取栈顶元素
{
    if (IsEmpty())
        cout << "链式栈已空" << endl;
    else
        return _top->data;
}

template <class T>
void LinkStack<T>::PopElem()
//出栈
{
    if (IsEmpty())
        cout << "链式栈已空，无法出栈！" << endl;
    else
    {
        Node<T> *p = _top; //取旧栈顶
        _top = _top->next; //_top指向新栈顶
        delete p;          //释放旧栈顶空间
    }
}
```

## 4.2 队列

（Queue）

队列允许在表的一端插入元素，在另一端删除元素，所谓先进先出（First In First Out, FIFO）。允许插入的一端称为队尾（rear），允许删除的一端称为队头（front）。

- 操作
  - 初始化
  - 求长度
  - 取队头元素
  - 进队
  - 出队
  - 判空
  - 清空队列

约定：front指向队头元素，rear指向队尾元素后一个位置

### 4.2.1 循环队列

为了避免假溢出问题，把顺序队列所使用的存储空间构造成一个逻辑上首尾相连的循环队列，称为循环队列。

- 假溢出问题的解决方法（主要是判空判满的问题）
  - 少用一个存储空间，队满即 `(rear + 1) % maxlen == front`
  - 不设rear，改设length，队空 `length == 0`；队满 `length == maxlen`
  - 新增数据成员flag，队空 `flag == 0`；队满 `flag == maxlen`

### 4.2.2 链式队列

链式队列完全避免了假溢出的问题。

## 4.3 递归

（Recursion）

若一个对象部分地包含自己，或用它自己给自己定义，则此对象是递归的。

若一个过程直接或间接地调用自己，则此过程是递归的过程

对任意一个递归，需要有**出口**和**同一形式**

步骤

- 保留调用信息（返回地址和实参信息）
- 分配调用过程所需的数据空间
- 将控制转到被调用的子过程

特点

- 不节省时间，也不节省空间
- 容易根据定义进行编程
- 结构清晰，便于阅读

### 4.3.1 递归转换为非递归

原因

- 递归的时间效率通常比较差
- 有些计算机语言不支持递归

方法

- 对于尾递归和单项递归，可用循环结构的算法替代。
- 自己用栈来模拟系统运行时的栈（工作记录），保存有关信息。

#### 1）尾递归和单项递归的消除

尾递归：递归调用语句只有一个，且在函数最后。（如阶乘）

单项递归：所有递归调用彼此间参数无关（不套娃），且均在函数最后。（如斐波那契数列）

#### 2）用栈模拟系统运行时的栈

# 五、串、数组和广义表

## 5.1 字符串

### 5.1.1 定义

$$
s=“a_0a_1\ldots a_{n-1}”
$$

- 空格符也是字符，空格串不是空串

- 当串采用顺序存储时，存储串的数组名指出了串在内存中的首地址
- C++中存储串的末尾会添加一个结束标识符NULL（编码值为0）

### 5.1.2 模式匹配

（Pattern Matching）

设 ob 为主串，pat 为模式串，查找 pat 在 ob 的匹配位置的操作称为模式匹配

#### 1）Brute-Force算法

从主串首字符开始依次匹配，若匹配失败，从第二个字符位开始匹配，以此类推。它是一种带回溯的算法。

```c++
int BF_find(const string &ob, const string &pat, const int p = 0)
//查找pat在ob中从位置p开始子串
{
    int i = p, j = 0;
    while (i < ob.length() && j < pat.length() && pat.length() - j <= ob.length() - i)
    {
        if (ob[i] == pat[j])//匹配成功，继续匹配下个字符
        {
            i++;
            j++;
        }
        else //匹配失败
        {
            i = i - j + 1; //i退回到上趟匹配的下个字符位置
            j = 0;         //j从头开始
        }
    }
    if (j >= pat.length())
        return i - j;
    else
    {
        return -1;
    }
}
```

时间复杂度（最坏）：$O(m\sdot n)$

#### 2）KMP算法

```c++
int KMP(const string &ob, const string &pat, const int start = 0)
{
    int *next = new int[pat.length()];
    GetNext(pat, next);
    int i = start, j = 0;
    while ((j == -1) || (ob[i] != '\0' && pat[j] != '\0'))
    {
        if (j == -1 || ob[i] == pat[j])
        {
            i++; //继续对下一个字符比较
            j++; //模式串向右滑动
        }
        else
            j = next[j]; //寻找新的匹配字符位置，模式串尽可能向右滑动
    }
    delete[] next;
    if (pat[j] == '\0')
        return (i - j); //匹配成功返回下标
    else
        return -1; //匹配失败返回-1
}
```

```c++
void GetNext(const string &pat, int *next)
//p[k]表示前缀，p[j]表示后缀
{
    int j = 0, k = -1;
    next[0] = -1; //设next[0]的初始值为-1
    while (pat[j] != '\0')
    {
        if (k == -1 || pat[j] == pat[k])
        {
            j++;
            k++;         //j,k向后走
            next[j] = k; //记录到此索引前字符串真子串的长度
        }
        else
            k = next[k]; //寻求新的匹配字符
    }
}
```

## 5.2 数组

数组将线性关系进行扩展（一维变多维）

数据类型受限

## 5.3 稀疏矩阵

### 5.3.1 矩阵的压缩存储

- 对称矩阵 （$a_{ij} == a_{ji}$）：记录三角及对角线
- 三对角矩阵（除主对角线及其相邻两条斜线，其余元素均为0）：行列号插值不为1的为0
- 稀疏矩阵 （大部分元素为0的矩阵）

### 5.3.2 三元组

用（行、列、值）来记录稀疏矩阵中的非零元素

```c++
template <class DataType>
class Triple
{
    int _row, _col;
    DataType _value;

    Triple(){};
    Triple(int row, int col, DataType value) _row(row), _col(col), _value(value){};
};
```

### 5.3.3 三元组顺序表

### 5.3.4 三元组的十字链表

当非零元素经常变动时，不适合用顺序表。

十字链表由行链表和列链表组成（不带头结点的循环表），每个非零元素既处于行链表又处于列链表中

#### 1）非零元素结点类模板

## 5.4 广义表

即列表（List），元素可以是一个数据也可以是一个表
$$
LS=(a_1,a_2,\ldots,a_n)
$$

- 表头：$a_1$
- 表尾：$(a_2,a_3,\ldots,a_n)$

- 深度：广义表中括号的深度；空表的深度为1

### 5.4.1 广义链表

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20201228093515706.png" alt="image-20201228093515706" style="zoom:67%;" /><img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210104080520301.png" alt="image-20210104080520301" style="zoom:67%;" />

要点：

1. 带头结点

2. 单元素深度为0，空表深度为一

3. 几乎所有操作都是递归，因为广义表本身的定义即是递归的

4. 求深度公式

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210104083030427.png" alt="image-20210104083030427" style="zoom:67%;" />

#### 1）结点类模板定义

#### 2）链表类模板定义

# 六、数和森林

一个数据可能有多个直接前驱（或后继），需要用非线性数据结构去表示，本章讲解树形结构的定义与实现

## 6.1 树

(tree)

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210104090947185.png" alt="image-20210104090947185" style="zoom:67%;" />

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210104092654359.png" alt="image-20210104092654359" style="zoom:67%;" />

### 6.1.1 定义

树$T$是一个包含$n$个数据元素的有限集合，每个数据元素用一个结点表示，且有

1. $n=0$时，$T$为空树
2. $n>0$时，$T$有且只有一个根（root），根结点只有后继，没有前驱
3. $n>1$时，根以外的其余结点又是$m$个互不受限的非空有限集，它们是根结点的子树（subtree）

### 6.1.2 术语

- 结点（node）：每个数据元素及指向其子树根的分支
- 结点的度（degree of node）：一个结点的分支个数（子树数目）
- 终端结点（terminal tree）：度为0的结点，也叫叶子（leaf）
- 非终端结点（nonterminal tree）：度不为0的结点，也叫分支结点
- 树的度（degree of tree）：树的结点中最大的度
- 孩子（child）和双亲（parent）：结点p的子树称为p的孩子，p是其子树的双亲
- 兄弟（sibling）：双亲相同的结点
- 祖先（ancestor）：从根结点到结点x所经分支上的所有结点是x的祖先
- 子孙（descendant）：以结点p为根的所有字数中的所有结点都是p的子孙
- 结点的层次（level）：根为第一层，根的孩子第二层，以此类推；树中任意结点的level是其双亲结点level+1
- 树的深度（depth）：书中结点的最大层次（根的层次），也叫高度（height）
- 堂兄弟：双亲在同一层的结点
- 有序树：树中结点p的子树都是有顺序的
- 无序树：树中结点p的子树没有顺序
- 森林（forest）：m颗互不相交的的树的集合；对树中每个结点而言，其子树的集合即为森林（子树森林）

## 6.2 二叉树

（Binary Tree）

### 6.2.1 定义

二叉树是特殊的有序树，每个结点的度最多为2

非空时，有根结点BT，余下的结点最多被组成两颗互不相交的、分别被称为BT的左子树（left subtree）和右子树（right subtree）的二叉树

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210104093053829.png" alt="image-20210104093053829" style="zoom:67%;" />

### 6.2.2 性质

### 6.2.3 遍历

（Traversing Binary Tree, TBT）

定义：按某种顺序访问每个结点，并使每个结点只被访问一次

方法：规定$L,D,R$为访问左子树，根，右子树，有：（规定先左再右）

1. $DLR$：先序遍历
2. $LDR$：中序遍历
3. $LRD$：后序遍历

先序+中序（or 后序+中序）的遍历结果可以反向推导出二叉树

#### 1）先序遍历

```c++
template <class T>
void BinaryTree<T>::PreOrder(BinTreeNode<T> *&root)
{
    if (root != NULL)
    {
        cout << root->_data << " ";
        PreOrder(root->_leftChild);
        PreOrder(root->_rightChild);
    }
}
```

```c++
template <class T>
void BinaryTree<T>::PreOrder_NoRecurve(BinTreeNode<T> *&root)
//DLR 节点不为空时即打印
{
    if (root == NULL)
        return;
    LinkStack<BinTreeNode<T> *> Stack;
    BinTreeNode<T> *p = root;
    while (!Stack.IsEmpty())
    {
        if (p != NULL)
        {
            cout << p->_data << " "; //先打印父节点
            Stack.PushElem(p);       //父节点入栈
            p = p->_leftChild;       //转到左节点
        }
        else
        {
            p = Stack.TopElem(); //回溯到父节点
            Stack.PopElem();     //父节点出栈
            p = p->_rightChild;  //转到右节点
        }
    }
}
```

#### 2）中序遍历

```c++
template <class T>
void BinaryTree<T>::InOrder(BinTreeNode<T> *&root)
{
    if (root != NULL)
    {
        InOrder(root->_leftChild);
        cout << root->_data << " ";
        InOrder(root->_rightChild);
    }
}
```

```c++
template <class T>
void BinaryTree<T>::InOrder_NoRecurve(BinTreeNode<T> *&root)
//LDR 左节点为空时访问（或 即将转到右节点时访问）
{
    if (root == NULL)
        return;
    LinkStack<BinTreeNode<T> *> Stack;
    BinTreeNode<T> *p = root;
    while (!Stack.IsEmpty())
    {
        if (p != NULL)
        {
            Stack.PushElem(p); //入栈
            p = p->_leftChild; //转到左节点
        }
        else
        {
            p = Stack.TopElem();
            Stack.PopElem();         //栈顶出栈
            cout << p->_data << " "; //即将转到右节点时，打印栈顶
            p = p->_rightChild;      //转到右节点
        }
    }
}
```



#### 3）后序遍历

```c++
template <class T>
void BinaryTree<T>::PostOrder(BinTreeNode<T> *&root)
{
    if (root != NULL)
    {
        PostOrder(root->_leftChild);
        PostOrder(root->_rightChild);
        cout << root->_data << " ";
    }
}
```

```c++
template <class T>
void BinaryTree<T>::PostOrder_NoRecurve(BinTreeNode<T> *&root)
//LRD 出栈时，需要判定左右节点遍历的完成情况
{
    if (_root == NULL)
        return;
    LinkStack<BinTreeNode<T> *> Stack;
    LinkStack<BinTreeNode<T> *> Tag;
    BinTreeNode<T> *p = root;
    Stack.PushElem(p);
    Tag.PushElem(0);
    while (!Stack.IsEmpty())
    {
        if (p != NULL)
        {
            Stack.PushElem(p);
            Tag.PushElem(0);
            p = p->_leftChild;
        }
        else
        {
            if (Tag.TopElem() == 0) //此时左节点已经遍历完
            {
                p = Stack.TopElem(); //预出栈
                Tag.PopElem();
                Tag.PushElem(1); //将Tag栈顶改为1，表示已经遍历完左节点
                p = p->_rightChild;
            }
            else //此时右节点已经遍历完
            {
                p = Stack.TopElem();
                Stack.PopElem(); //真正出栈
                Tag.PopElem();
                cout << p->_data << " ";
                p = p->_rightChild;
            }
        }
    }
}
```

#### 4）层序遍历

```c++
template <class T>
void BinaryTree<T>::LevelOrder(BinTreeNode<T> *&root)
//层序遍历
{
    LinkQueue<BinTreeNode<T> *> Queue;
    BinTreeNode<T> *p;
    if (root != NULL)
        Queue.EnterQueue(root); //若根非空，则入队
    while (!Queue.IsEmpty())
    {
        p = Queue.GetFront();    //取队头
        Queue.DeleteQueue();     //出队
        cout << p->_data << " "; //打印打印！

        if (p->_leftChild != NULL) //若左节点非空，入队
        {
            Queue.EnterQueue(p->_leftChild);
        }
        if (p->_rightChild != NULL) //若右节点非空，入队
        {
            Queue.EnterQueue(p->_rightChild);
        }
    }
}
```

#### 5）遍历的用途

1. 打印内容
2. 知晓层数
3. 统计结点
4. 使非线性结构线性化

#### 6）遍历的C++写法

```c++
void PreOrder(BinTreeNode<T> *root);
void PreOrder(BinTreeNode<T> *root) const;
void PreOrder(const BinTreeNode<T> *root);
void PreOrder(const BinTreeNode<T> *root) const;
void PreOrder(BinTreeNode<T> *&root);
```

## 6.3 线索二叉树

(Threaded Binary Tree)

利用结点的空链，记录遍历的前驱和后继

规定

- 结点左指针为空，记前驱；结点右指针为空，记后继
- 为了区分指针指的式孩子还是线索关系，加标记，为0记录孩子，为1记录线索
- 添加一个数据域为空的头结点，左指针指向根结点，标记0；右指针记录遍历时第一个访问的结点，标记1

| leftChild    | leftTag | data   | rightTag | rightChild   |
| ------------ | ------- | ------ | -------- | ------------ |
| 左孩子或前驱 | 0或1    | 数据域 | 0或1     | 右孩子或后继 |



<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210111093250495.png" alt="image-20210111093250495" style="zoom:67%;" />

### 6.3.1 查找结点的前驱和后继算法

1. 中序线索二叉树

查找p的前驱：查左线索；若无左线索，结点的前驱是遍历左子树时访问的最后一个结点。

查找p的后继：查右线索；若无右线索，结点的后继是遍历右子树时访问的第一个结点。

2. 先序线索二叉树

查找p的前驱：查左线索；若无左线索，结点的前驱是结点的双亲结点，或是先序遍历其双亲结点左子树时最后访问的结点。

查找p的后继：查右线索；若无右线索，结点的后继必为结点的左子树（若存在）或右子树根结点。

3. 后序线索二叉树

查找p的前驱：查左线索；若无左线索，且无右线索时，结点的前驱是右子树根结点；若无左线索，但是有右线索时，结点的前驱是左子树根结点。

查找p的后继，这种查找比较复杂，分4类情况讨论：

​	若p为二叉树的根结点，后继为空；
​	若p为右子树根结点，后继为双亲结点；
​	若p为左子树根结点，且无右兄弟，后继为双亲结点；
​	若p为左子树根结点，且有右兄弟，后继为后序遍历双亲结点右子树时访问的第一个结点。

## 6.4 堆

（Heap）

### 6.4.1 定义

在完全二叉树中任何非终端节点的关键字均不大于（或不小于）其左、右孩子结点的关键字

堆的本质是线性关系，但写成完全二叉树形式更为直观

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210115092512720.png" alt="image-20210115092512720" style="zoom:67%;" />

称根节点为堆顶，称堆顶最小为小顶堆（最小堆）；堆顶最大为大顶堆（最大堆）

使用顺序存储来构建堆

## 6.5 哈夫曼树

### 6.5.1 术语

- 路径（Path）：从根结点到某个结点经过的分支序列
- （根到结点的）路径长度：路径中的分支数
- 树的路径长度（Path Length，PL）：从根结点到所有叶子结点的路径长度和
- 带权路径长度（WPL）：设一颗有n个带权值叶结点的二叉树，$W_k$为第k个叶结点的权值，$L_k$为第k个叶结点的路径长度

$$
WPL=\sum\limits_{k=1}^nW_k*L_k
$$

### 6.5.2 定义

对于一组确定权值的结点，所构造出不同形态二叉树的带权路径长度并不相同。将其中具有最小带权路径长度的二叉树称为**哈夫曼树**（最优二叉树）

构造方法：取最小的两个结点构树（左小右大），重复

### 6.5.3 哈夫曼编码

哈夫曼编码是一种前缀码，解码时没有歧义，相比于等长编码可以节省空间

- 计算字母频率作为权值，构造哈夫曼树，
- 叶子结点具有哈夫曼编码
- 规定左子树为0，右子树为1，写出字母编码

<img src="https://trou.oss-cn-shanghai.aliyuncs.com/img/image-20210118092851997.png" alt="image-20210118092851997" style="zoom:67%;" />