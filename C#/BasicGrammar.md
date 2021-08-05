# BasicGrammar

## 认识

### 简介

**C#**：是一个现代的、通用的、面向对象的编程语言

**.Net Framework**：是一个创新的平台，能编写出下面类型的应用程序：

- Windows 应用程序
- Web 应用程序
- Web 服务

## 程序结构

一个 C# 程序主要包括以下部分：

- 命名空间声明（Namespace declaration）
- 一个 class
- Class 方法
- Class 属性
- 一个 Main 方法
- 语句（Statements）& 表达式（Expressions）
- 注释

```C#
using System;
namespace HelloWorldApplication
{
    /* 类名为 HelloWorld */
    class HelloWorld
    {
        /* main 函数 */
        static void Main(string[] args)
        {
            /* 我的第一个 C# 程序 */
            Console.WriteLine("Hello World!");
            Console.ReadKey();
        }
    }
}
```

- 程序的第一行 **using System;**
    - **using** 关键字用于在程序中包含 **System** 命名空间。 一个程序一般有多个 **using** 语句。
- 下一行是 **namespace**（命名空间）声明
    - 一个 **namespace** 里包含了一系列的类。*HelloWorldApplication* 命名空间包含了类 *HelloWorld*。
- 下一行是 **class** 声明
    - 类 *HelloWorld* 包含了程序使用的数据和方法声明。
    - 类一般包含多个方法。方法定义了类的行为。
    - 在这里，*HelloWorld* 类只有一个 **Main** 方法。
- 下一行定义了 **Main** 方法，是所有 C# 程序的 **入口点**。
    - **Main** 方法说明当执行时 类将做什么动作。
- 下一行 `/*...*/ ` 为注释语句，将会被编译器忽略。
- Main 方法通过语句`Console.WriteLine("Hello World");` 指定了它的行为。
    - *WriteLine* 是一个定义在 *System* 命名空间中的 *Console* 类的一个方法。该语句会在屏幕上显示消息 "Hello World"。
- 最后一行 `Console.ReadKey();` 是针对 VS.NET 用户的。这使得程序会等待一个按键的动作，防止程序从 Visual Studio .NET 启动时屏幕会快速运行并关闭。

> 注意
>
> - C# 是大小写敏感的。
> - 所有的语句和表达式必须以分号（;）结尾。
> - 程序的执行从 Main 方法开始。
> - 与 Java 不同的是，文件名可以不同于类的名称

有例：

```c#
using System;
namespace RectangleApplication
{
    class Rectangle
    {
        // 成员变量
        double length;
        double width;
        public void Acceptdetails()
        {
            length = 4.5;    
            width = 3.5;
        }
        public double GetArea()
        {
            return length * width;
        }
        public void Display()
        {
            Console.WriteLine("Length: {0}", length);
            Console.WriteLine("Width: {0}", width);
            Console.WriteLine("Area: {0}", GetArea());
        }
    }
   
    class ExecuteRectangle
    {
        static void Main(string[] args)
        {
            Rectangle r = new Rectangle();
            r.Acceptdetails();
            r.Display();
            Console.ReadLine();
        }
    }
}
```

运行得

```shell
Length: 4.5
Width: 3.5
Area: 15.75
```

## 数据类型

### 值类型

(Value types)

值类型变量可以直接分配给一个值。它们是从类 **System.ValueType** 中派生的

| 类型    | 描述                                 | 范围                                                    | 默认值 |
| :------ | :----------------------------------- | :------------------------------------------------------ | :----- |
| bool    | 布尔值                               | True 或 False                                           | False  |
| byte    | 8 位无符号整数                       | 0 到 255                                                | 0      |
| char    | 16 位 Unicode 字符                   | U +0000 到 U +ffff                                      | '\0'   |
| decimal | 128 位精确的十进制值，28-29 有效位数 | (-7.9 x 1028 到 7.9 x 1028) / 100 到 28                 | 0.0M   |
| double  | 64 位双精度浮点型                    | (+/-)5.0 x 10-324 到 (+/-)1.7 x 10308                   | 0.0D   |
| float   | 32 位单精度浮点型                    | -3.4 x 1038 到 + 3.4 x 1038                             | 0.0F   |
| int     | 32 位有符号整数类型                  | -2,147,483,648 到 2,147,483,647                         | 0      |
| long    | 64 位有符号整数类型                  | -9,223,372,036,854,775,808 到 9,223,372,036,854,775,807 | 0L     |
| sbyte   | 8 位有符号整数类型                   | -128 到 127                                             | 0      |
| short   | 16 位有符号整数类型                  | -32,768 到 32,767                                       | 0      |
| uint    | 32 位无符号整数类型                  | 0 到 4,294,967,295                                      | 0      |
| ulong   | 64 位无符号整数类型                  | 0 到 18,446,744,073,709,551,615                         | 0      |
| ushort  | 16 位无符号整数类型                  | 0 到 65,535                                             | 0      |

### 引用类型

(Reference types)

引用类型不包含存储在变量中的实际数据，但它们包含对变量的引用。

换句话说，它们指的是一个内存位置。使用多个变量时，引用类型可以指向一个内存位置。如果内存位置的数据是由一个变量改变的，其他变量会自动反映这种值的变化。**内置的** 引用类型有：**object**、**dynamic** 和 **string**

#### 对象 `Object` 类型

**对象（Object）类型** 是 C# 通用类型系统（Common Type System - CTS）中所有数据类型的终极基类。Object 是 `System.Object` 类的别名。所以对象（Object）类型可以被分配任何其他类型（值类型、引用类型、预定义类型或用户自定义类型）的值。但是，在分配值之前，需要先进行类型转换。

当一个值类型转换为对象类型时，则被称为 **装箱**；另一方面，当一个对象类型转换为值类型时，则被称为 **拆箱**

```csharp
object obj;
obj = 100; // 这是装箱
```

#### 动态 `Dynamic` 类型

您可以存储任何类型的值在动态数据类型变量中。	

声明动态类型的语法：

```C#
dynamic <variable_name> = value;
```

例如：

```c#
dynamic d = 20;
```

> 动态类型与对象类型相似，但是对象类型变量的类型检查是在编译时发生的，而动态类型变量的类型检查是在运行时发生的

#### 字符串 `String` 类型

字符串类型允许您给变量分配任何字符串值。

- 字符串类型是 `System.String` 类的别名。

- 它是从对象类型派生的。

例如：

```C#
String str = "runoob.com";
```

字符串前面可以加 @（称作"逐字字符串"）将转义字符（\）当作普通字符对待，比如：

```C#
string str = @"C:\Windows";
```

等价于：

```C#
string str = "C:\\Windows";
```

@ 字符串中可以任意换行，换行符及缩进空格都计算在字符串长度之内。

```C#
string str = @"<script type=""text/javascript"">
    <!--
    -->
</script>";
```

用户自定义引用类型有：class、interface 或 delegate。我们将在以后的章节中讨论这些类型。

### 指针类型

(Pointer types)

指针类型变量存储另一种类型的内存地址。C# 中的指针与 C 或 C++ 中的指针有相同的功能

声明指针类型的语法：

```C#
type* identifier;
```

例如：

```C#
char* cptr;
int* iptr;
```

### 类型转换

类型转换从根本上说是**类型铸造**，或者说是把数据从一种类型转换为另一种类型

型铸造有两种形式：

- **隐式类型转换** - 这些转换是 C# 默认的以安全方式进行的转换, 不会导致数据丢失。例如，从小的整数类型转换为大的整数类型，从派生类转换为基类。
- **显式类型转换** - 显式类型转换，即**强制类型转换**。显式转换需要强制转换运算符，而且强制转换会造成数据丢失

```C#
namespace TypeConversionApplication
{
    class ExplicitConversion
    {
        static void Main(string[] args)
        {
            double d = 5673.74;
            int i;

            // 强制转换 double 为 int
            i = (int)d;
            Console.WriteLine(i);
            Console.ReadKey();
        }
    }
}
// 结果为 5673
```

#### 类型转换方法

| 序号 | 方法 & 描述                                                  |
| :--- | :----------------------------------------------------------- |
| 1    | **ToBoolean** 如果可能的话，把类型转换为布尔型。             |
| 2    | **ToByte** 把类型转换为字节类型。                            |
| 3    | **ToChar** 如果可能的话，把类型转换为单个 Unicode 字符类型。 |
| 4    | **ToDateTime** 把类型（整数或字符串类型）转换为 日期-时间 结构。 |
| 5    | **ToDecimal** 把浮点型或整数类型转换为十进制类型。           |
| 6    | **ToDouble** 把类型转换为双精度浮点型。                      |
| 7    | **ToInt16** 把类型转换为 16 位整数类型。                     |
| 8    | **ToInt32** 把类型转换为 32 位整数类型。                     |
| 9    | **ToInt64** 把类型转换为 64 位整数类型。                     |
| 10   | **ToSbyte** 把类型转换为有符号字节类型。                     |
| 11   | **ToSingle** 把类型转换为小浮点数类型。                      |
| 12   | **ToString** 把类型转换为字符串类型。                        |
| 13   | **ToType** 把类型转换为指定类型。                            |
| 14   | **ToUInt16** 把类型转换为 16 位无符号整数类型。              |
| 15   | **ToUInt32** 把类型转换为 32 位无符号整数类型。              |
| 16   | **ToUInt64** 把类型转换为 64 位无符号整数类型。              |

```C#
namespace TypeConversionApplication
{
    class StringConversion
    {
        static void Main(string[] args)
        {
            int i = 75;
            float f = 53.005f;
            double d = 2345.7652;
            bool b = true;

            Console.WriteLine(i.ToString());
            Console.WriteLine(f.ToString());
            Console.WriteLine(d.ToString());
            Console.WriteLine(b.ToString());
            Console.ReadKey();
        }
    }
}
```

输出

```C#
75
53.005
2345.7652
True
```

## 变量

| 类型       | 举例                                                       |
| :--------- | :--------------------------------------------------------- |
| 整数类型   | sbyte、byte、short、ushort、int、uint、long、ulong 和 char |
| 浮点型     | float 和 double                                            |
| 十进制类型 | decimal                                                    |
| 布尔类型   | true 或 false 值，指定的值                                 |
| 空类型     | 可为空值的数据类型                                         |

C# 允许定义其他值类型的变量，比如 **enum**，也允许定义引用类型变量，比如 **class**

### 基本操作

#### 定义

```c#
<data_type> <variable_list>;
```

```C#
// 定义
int i, j, k;
char c, ch;
float f, salary;
double d;   
```

#### 初始化

```c#
<data_type> <variable_name> = value;
```

```C#
// 初始化
int d = 3, f = 5;    
byte z = 22;         
double pi = 3.14159; 
char x = 'x';   
```

#### 接受来自用户的值

```c#
int num;
num = Convert.ToInt32(Console.ReadLine());
```

## 常量

常量是固定值，程序执行期间不会改变。常量可以是任何基本数据类型。

### 定义

常量是使用 **const** 关键字来定义的 。定义一个常量的语法如下：

```c#
const <data_type> <constant_name> = value;
```

```c#
using System;

public class ConstTest
{
    class SampleClass
    {
        public int x;
        public int y;
        public const int c1 = 5;
        public const int c2 = c1 + 5;

        public SampleClass(int p1, int p2)
        {
            x = p1;
            y = p2;
        }
    }

    static void Main()
    {
        SampleClass mC = new SampleClass(11, 22);
        Console.WriteLine("x = {0}, y = {1}", mC.x, mC.y);
        Console.WriteLine("c1 = {0}, c2 = {1}",
                          SampleClass.c1, SampleClass.c2);
    }
}
```

输出

```c#
x = 11, y = 22
c1 = 5, c2 = 10
```

### 类型

#### 整数常量

```c#
85         // 十进制 
0213       // 八进制 
0x4b       // 十六进制 
30         // int 
30u        // 无符号 int 
30l        // long 
30ul       // 无符号 long 
```

#### 浮点常量

```c#
3.14159       // 合法 
314159E-5L    // 合法 
    
510E          // 非法：不完全指数 
210f          // 非法：没有小数或指数 
.e55          // 非法：缺少整数或小数 
```

使用浮点形式表示时，必须包含小数点、指数或同时包含两者。

使用指数形式表示时，必须包含整数部分、小数部分或同时包含两者。

有符号的指数是用 e 或 E 表示的。

#### 字符常量

一个字符常量可以是一个普通字符（例如 `'x'`）、一个转义序列（例如 `'\t'`）或者一个通用字符（例如 `'\u02C0'`）

| 转义序列   | 含义                       |
| :--------- | :------------------------- |
| \\         | \ 字符                     |
| \'         | ' 字符                     |
| \"         | " 字符                     |
| \?         | ? 字符                     |
| \a         | Alert 或 bell              |
| \b         | 退格键（Backspace）        |
| \f         | 换页符（Form feed）        |
| \n         | 换行符（Newline）          |
| \r         | 回车                       |
| \t         | 水平制表符 tab             |
| \v         | 垂直制表符 tab             |
| \ooo       | 一到三位的八进制数         |
| \xhh . . . | 一个或多个数字的十六进制数 |

#### 字符串常量

字符串常量是括在双引号 `""` 里，或者是括在 `@""` 里

```c#
string a = "hello, world";                  // hello, world
string b = @"hello, world";               // hello, world
string c = "hello \t world";               // hello     world
string d = @"hello \t world";               // hello \t world
string e = "Joe said \"Hello\" to me";      // Joe said "Hello" to me
string f = @"Joe said ""Hello"" to me";   // Joe said "Hello" to me
string g = "\\\\server\\share\\file.txt";   // \\server\share\file.txt
string h = @"\\server\share\file.txt";      // \\server\share\file.txt
string i = "one\r\ntwo\r\nthree";
string j = @"one
two
three";
```

## 运算符

运算符是一种告诉编译器执行特定的数学或逻辑操作的符号。

### 算术运算符

下表显示了 C# 支持的所有算术运算符。假设变量 **A** 的值为 10，变量 **B** 的值为 20，则：

| 运算符 | 描述                             | 实例             |
| :----- | :------------------------------- | :--------------- |
| +      | 把两个操作数相加                 | A + B 将得到 30  |
| -      | 从第一个操作数中减去第二个操作数 | A - B 将得到 -10 |
| *      | 把两个操作数相乘                 | A * B 将得到 200 |
| /      | 分子除以分母                     | B / A 将得到 2   |
| %      | 取模运算符，整除后的余数         | B % A 将得到 0   |
| ++     | 自增运算符，整数值增加 1         | A++ 将得到 11    |
| --     | 自减运算符，整数值减少 1         | A-- 将得到 9     |

```c#
using System;

namespace OperatorsAppl
{
    class Program
    {
        static void Main(string[] args)
        {
            int a = 21;
            int b = 10;
            int c;

            c = a + b;
            Console.WriteLine("Line 1 - c 的值是 {0}", c);
            c = a - b;
            Console.WriteLine("Line 2 - c 的值是 {0}", c);
            c = a * b;
            Console.WriteLine("Line 3 - c 的值是 {0}", c);
            c = a / b;
            Console.WriteLine("Line 4 - c 的值是 {0}", c);
            c = a % b;
            Console.WriteLine("Line 5 - c 的值是 {0}", c);

            // ++a 先进行自增运算再赋值
            c = ++a;
            Console.WriteLine("Line 6 - c 的值是 {0}", c);

            // 此时 a 的值为 22
            // --a 先进行自减运算再赋值
            c = --a;
            Console.WriteLine("Line 7 - c 的值是 {0}", c);
            Console.ReadLine();
        }
    }
}
```

输出

```c#
Line 1 - c 的值是 31
Line 2 - c 的值是 11
Line 3 - c 的值是 210
Line 4 - c 的值是 2
Line 5 - c 的值是 1
Line 6 - c 的值是 22
Line 7 - c 的值是 21
```



### 关系运算符

- 逻辑运算符
- 位运算符
- 赋值运算符
- 其他运算符
