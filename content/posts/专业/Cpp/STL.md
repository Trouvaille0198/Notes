---
title: "STL"
date: 2022-01-25
author: MelonCholi
draft: false
tags: [C++]
categories: [CPP]
---

# STL

## list

### 概述

list 由双向链表（doubly linked list）实现而成，元素也存放在堆中，每个元素都是放在一块内存中，他的内存空间可以是不连续的，通过指针来进行数据的访问，这个特点使得它的随机存取变得非常没有效率，因此它没有提供 [] 操作符的重载。但是由于链表的特点，它可以很有效率的支持任意地方的插入和删除操作。

### 定义及初始化

使用之前必须加相应容器的头文件：

```c++
#include <list> // list属于std命名域的，因此需要通过命名限定，例如using std::list;
```

定义的代码如下：

```c++
list<int> a; // 定义一个int类型的列表a
list<int> a(10); // 定义一个int类型的列表a，并设置初始大小为10
list<int> a(10, 1); // 定义一个int类型的列表a，并设置初始大小为10且初始值都为1
list<int> b(a); // 定义并用列表a初始化列表b
deque<int> b(a.begin(), ++a.end()); // 将列表a中的第1个元素作为列表b的初始值
```

除此之外，还可以直接使用数组来初始化向量：

```c++
int n[] = { 1, 2, 3, 4, 5 };
list<int> a(n, n + 5); // 将数组n的前5个元素作为列表a的初值
```

### 基本操作

#### 容量函数

- 容器大小：`lst.size();`
- 容器最大容量：`lst.max_size();`
- 更改容器大小：`lst.resize();`
- 容器判空：`lst.empty();`

```c++
#include <iostream>
#include <list>

using namespace std;

int main(int argc, char* argv[])
{
	list<int> lst;
	for (int i = 0; i<6; i++)
	{
		lst.push_back(i);
	}

	cout << lst.size() << endl; // 输出：6
	cout << lst.max_size() << endl; // 输出：357913941
	lst.resize(0); // 更改元素大小
	cout << lst.size() << endl; // 输出：0
	if (lst.empty())
		cout << "元素为空" << endl; // 输出：元素为空

	return 0;
}
```

#### 添加函数

- 头部添加元素：`lst.push_front(const T& x);`
- 末尾添加元素：`lst.push_back(const T& x);`
- 任意位置插入一个元素：`lst.insert(iterator it, const T& x);`
- 任意位置插入 n 个相同元素：`lst.insert(iterator it, int n, const T& x);`
- 插入另一个向量的 [forst,last] 间的数据：`lst.insert(iterator it, iterator first, iterator last);`

```c++
#include <iostream>
#include <list>

using namespace std;

int main(int argc, char* argv[])
{
	list<int> lst;

	// 头部增加元素
	lst.push_front(4);
	// 末尾添加元素
	lst.push_back(5);
	// 任意位置插入一个元素
	list<int>::iterator it = lst.begin();
	lst.insert(it, 2);
	// 任意位置插入n个相同元素
	lst.insert(lst.begin(), 3, 9);
	// 插入另一个向量的[forst,last]间的数据
	list<int> lst2(5, 8);
	lst.insert(lst.begin(), lst2.begin(), ++lst2.begin());

	// 遍历显示
	for (it = lst.begin(); it != lst.end(); it++)
		cout << *it << " "; // 输出：8 9 9 9 2 4 5
	cout << endl;

	return 0;
}
```

#### 删除函数

- 头部删除元素：`lst.pop_front();`
- 末尾删除元素：`lst.pop_back();`
- 任意位置删除一个元素：`lst.erase(iterator it);`
- 删除 [first,last] 之间的元素：`lst.erase(iterator first, iterator last);`
- 清空所有元素：`lst.clear();`

```c++
#include <iostream>
#include <list>

using namespace std;

int main(int argc, char* argv[])
{
	list<int> lst;
	for (int i = 0; i < 8; i++)
		lst.push_back(i);

	// 头部删除元素
	lst.pop_front();
	// 末尾删除元素
	lst.pop_back();
	// 任意位置删除一个元素
	list<int>::iterator it = lst.begin();
	lst.erase(it);
	// 删除[first,last]之间的元素
	lst.erase(lst.begin(), ++lst.begin());

	// 遍历显示
	for (it = lst.begin(); it != lst.end(); it++)
		cout << *it << " "; // 输出：3 4 5 6
	cout << endl;

	// 清空所有元素
	lst.clear();

	// 判断list是否为空
	if (lst.empty())
	cout << "元素为空" << endl; // 输出：元素为空

	return 0;
}
```



#### 访问函数

- 访问第一个元素：`lst.front();`
- 访问最后一个元素：`lst.back();`

```c++
#include <iostream>
#include <list>

using namespace std;

int main(int argc, char* argv[])
{
	list<int> lst;
	for (int i = 0; i < 6; i++)
		lst.push_back(i);

	// 访问第一个元素
	cout << lst.front() << endl; // 输出：0
	// 访问最后一个元素
	cout << lst.back() << endl; // 输出：5

	return 0;
}
```

#### 其他函数

- 多个元素赋值：`lst.assign(int nSize, const T& x); // 类似于初始化时用数组进行赋值`
- 交换两个同类型容器的元素：`swap(list&, list&); 或 lst.swap(list&);`
- 合并两个列表的元素（默认升序排列）：`lst.merge();`
- 在任意位置拼接入另一个 list：`lst.splice(iterator it, list&);`
- 删除容器中相邻的重复元素：`lst.unique();`

```c++
#include <iostream>
#include <list>

using namespace std;

int main(int argc, char* argv[])
{
	// 多个元素赋值s
	list<int> lst1;
	lst1.assign(3, 1);
	list<int> lst2;
	lst2.assign(3, 2);
    
	// 交换两个容器的元素
	// swap(lst1, lst2); // ok
	lst1.swap(lst2);
	// 遍历显示
	cout << "交换后的lst1: ";
	list<int>::iterator it;
	for (it = lst1.begin(); it!=lst1.end(); it++)
		cout << *it << " "; // 输出：2 2 2
	cout << endl;
    
	// 遍历显示
	cout << "交换后的lst2: ";
	for (it = lst2.begin(); it != lst2.end(); it++)
		cout << *it << " "; // 输出：1 1 1
	cout << endl;

	list<int> lst3;
	lst3.assign(3, 3);
	list<int> lst4;
	lst4.assign(3, 4);
	// 合并两个列表的元素
	lst4.merge(lst3); // 不是简单的拼接，而是会升序排列
	cout << "合并后的lst4: ";
	for (it = lst4.begin(); it != lst4.end(); it++)
		cout << *it << " "; // 输出：3 3 3 4 4 4
	cout << endl;

	list<int> lst5;
	lst5.assign(3, 5);
	list<int> lst6;
	lst6.assign(3, 6);
	// 在lst6的第2个元素处，拼接入lst5
	lst6.splice(++lst6.begin(), lst5);
	cout << "拼接后的lst6: ";
	for (it = lst6.begin(); it != lst6.end(); it++)
		cout << *it << " "; // 输出：6 5 5 5 6 6
	cout << endl;

	// 删除容器中相邻的重复元素
	list<int> lst7;
	lst7.push_back(1);
	lst7.push_back(1);
	lst7.push_back(2);
	lst7.push_back(2);
	lst7.push_back(3);
	lst7.push_back(2);
	lst7.unique();
	cout << "删除容器中相邻的重复元素后的lst7: ";
	for (it = lst7.begin(); it != lst7.end(); it++)
		cout << *it << " "; // 输出：1 2 3 2
	cout << endl;

	return 0;
}
```

### 迭代器与算法

**1. 迭代器**

- 开始迭代器指针：`lst.begin();`
- 末尾迭代器指针：`lst.end();` // 指向最后一个元素的下一个位置
- 指向常量的开始迭代器指针：`lst.cbegin();` // 意思就是不能通过这个指针来修改所指的内容，但还是可以通过其他方式修改的，而且指针也是可以移动的。
- 指向常量的末尾迭代器指针：`lst.cend();`
- 反向迭代器指针，指向最后一个元素：`lst.rbegin();`
- 反向迭代器指针，指向第一个元素的前一个元素：`lst.rend();`

```c++
#include <iostream>
#include <list>

using namespace std;

int main(int argc, char* argv[])
{
	list<int> lst;
	lst.push_back(1);
	lst.push_back(2);
	lst.push_back(3);

	cout << *(lst.begin()) << endl; // 输出：1
	cout << *(--lst.end()) << endl; // 输出：3
	cout << *(lst.cbegin()) << endl; // 输出：1
	cout << *(--lst.cend()) << endl; // 输出：3
	cout << *(lst.rbegin()) << endl; // 输出：3
	cout << *(--lst.rend()) << endl; // 输出：1
	cout << endl;

	return 0;
}
```

**2. 算法**

- 遍历元素

```c++
list<int>::iterator it;
for (it = lst.begin(); it != lst.end(); it++)
    cout << *it << endl;
```

- 元素翻转

```c++
#include <algorithm>
reverse(lst.begin(), lst.end());
```

- 元素排序

```c++
#include <algorithm>
sort(lst.begin(), lst.end()); // 采用的是从小到大的排序

// 如果想从大到小排序，可以采用先排序后反转的方式，也可以采用下面方法:
// 自定义从大到小的比较器，用来改变排序方式
bool Comp(const int& a, const int& b) 
{
    return a > b;
}

sort(lst.begin(), lst.end(), Comp);
```

### 总结

可以看到，list 与 vector、deque 的用法基本一致，除了以下几处不同：

- list 为双向迭代器，故不支持`it+=i`；
- list 不支持下标访问和 at 方法访问。