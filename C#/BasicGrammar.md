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
object obj; // 这是装箱
obj = 100; // 这是拆箱
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

假设变量 **A** 的值为 10，变量 **B** 的值为 20，则：

| 运算符 | 描述                                                         | 实例              |
| :----- | :----------------------------------------------------------- | :---------------- |
| ==     | 检查两个操作数的值是否相等，如果相等则条件为真。             | (A == B) 不为真。 |
| !=     | 检查两个操作数的值是否相等，如果不相等则条件为真。           | (A != B) 为真。   |
| >      | 检查左操作数的值是否大于右操作数的值，如果是则条件为真。     | (A > B) 不为真。  |
| <      | 检查左操作数的值是否小于右操作数的值，如果是则条件为真。     | (A < B) 为真。    |
| >=     | 检查左操作数的值是否大于或等于右操作数的值，如果是则条件为真。 | (A >= B) 不为真。 |
| <=     | 检查左操作数的值是否小于或等于右操作数的值，如果是则条件为真。 | (A <= B) 为真。   |

### 逻辑运算符

假设变量 **A** 为布尔值  true，变量 **B** 为布尔值 false，则：

| 运算符 | 描述                                                         | 实例              |
| :----- | :----------------------------------------------------------- | :---------------- |
| &&     | 称为逻辑与运算符。如果两个操作数都非零，则条件为真。         | (A && B) 为假。   |
| \|\|   | 称为逻辑或运算符。如果两个操作数中有任意一个非零，则条件为真。 | (A \|\| B) 为真。 |
| !      | 称为逻辑非运算符。用来逆转操作数的逻辑状态。如果条件为真则逻辑非运算符将使其为假。 |                   |

### 位运算符

位运算符作用于位，并逐位执行操作。&、 | 和 ^ 的真值表如下所示：

| p    | q    | p & q（与） | p \| q（或） | p ^ q（异或） |
| :--- | :--- | :---------- | :----------- | :------------ |
| 0    | 0    | 0           | 0            | 0             |
| 0    | 1    | 0           | 1            | 1             |
| 1    | 1    | 1           | 1            | 0             |
| 1    | 0    | 0           | 1            | 1             |

| 符号 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| ~    | 按位取反运算符是一元运算符，具有"翻转"位效果，即0变成1，1变成0，包括符号位。 |
| <<   | 二进制左移运算符。左操作数的值向左移动右操作数指定的位数。   |
| >>   | 二进制右移运算符。左操作数的值向右移动右操作数指定的位数。   |

### 赋值运算符

| 运算符 | 描述                                                         | 实例                            |
| :----- | :----------------------------------------------------------- | :------------------------------ |
| =      | 简单的赋值运算符，把右边操作数的值赋给左边操作数             | C = A + B 将把 A + B 的值赋给 C |
| +=     | 加且赋值运算符，把右边操作数加上左边操作数的结果赋值给左边操作数 | C += A 相当于 C = C + A         |
| -=     | 减且赋值运算符，把左边操作数减去右边操作数的结果赋值给左边操作数 | C -= A 相当于 C = C - A         |
| *=     | 乘且赋值运算符，把右边操作数乘以左边操作数的结果赋值给左边操作数 | C *= A 相当于 C = C * A         |
| /=     | 除且赋值运算符，把左边操作数除以右边操作数的结果赋值给左边操作数 | C /= A 相当于 C = C / A         |
| %=     | 求模且赋值运算符，求两个操作数的模赋值给左边操作数           | C %= A 相当于 C = C % A         |
| <<=    | 左移且赋值运算符                                             | C <<= 2 等同于 C = C << 2       |
| >>=    | 右移且赋值运算符                                             | C >>= 2 等同于 C = C >> 2       |
| &=     | 按位与且赋值运算符                                           | C &= 2 等同于 C = C & 2         |
| ^=     | 按位异或且赋值运算符                                         | C ^= 2 等同于 C = C ^ 2         |
| \|=    | 按位或且赋值运算符                                           | C \|= 2 等同于 C = C \| 2       |

### 其他运算符

| 运算符   | 描述                                   | 实例                                                         |
| :------- | :------------------------------------- | :----------------------------------------------------------- |
| sizeof() | 返回数据类型的大小。                   | sizeof(int)，将返回 4.                                       |
| typeof() | 返回 class 的类型。                    | typeof(StreamReader);                                        |
| &        | 返回变量的地址。                       | &a; 将得到变量的实际地址。                                   |
| *        | 变量的指针。                           | *a; 将指向一个变量。                                         |
| ? :      | 条件表达式                             | 如果条件为真 ? 则为 X : 否则为 Y                             |
| is       | 判断对象是否为某一类型。               | If( Ford is Car) // 检查 Ford 是否是 Car 类的一个对象。      |
| as       | 强制转换，即使转换失败也不会抛出异常。 | Object obj = new StringReader("Hello"); StringReader r = obj as StringReader; |

### 运算优先级

| 类别       | 运算符                            | 结合性   |
| :--------- | :-------------------------------- | :------- |
| 后缀       | () [] -> . ++ - -                 | 从左到右 |
| 一元       | + - ! ~ ++ - - (type)* & sizeof   | 从右到左 |
| 乘除       | * / %                             | 从左到右 |
| 加减       | + -                               | 从左到右 |
| 移位       | << >>                             | 从左到右 |
| 关系       | < <= > >=                         | 从左到右 |
| 相等       | == !=                             | 从左到右 |
| 位与 AND   | &                                 | 从左到右 |
| 位异或 XOR | ^                                 | 从左到右 |
| 位或 OR    | \|                                | 从左到右 |
| 逻辑与 AND | &&                                | 从左到右 |
| 逻辑或 OR  | \|\|                              | 从左到右 |
| 条件       | ?:                                | 从右到左 |
| 赋值       | = += -= *= /= %=>>= <<= &= ^= \|= | 从右到左 |
| 逗号       | ,                                 | 从左到右 |

## 判断语句

### if 语句

```C#
if(boolean_expression)
{
   /* 如果布尔表达式为真将执行的语句 */
}
```

### if...else 语句

```C#
if(boolean_expression)
{
   /* 如果布尔表达式为真将执行的语句 */
}
else
{
  /* 如果布尔表达式为假将执行的语句 */
}
```

### switch 语句

```C#
switch(expression){
    case constant-expression  :
       statement(s);
       break; 
    case constant-expression  :
       statement(s);
       break; 
  
    /* 您可以有任意数量的 case 语句 */
    default : /* 可选的 */
       statement(s);
       break; 
}
```

- **switch** 语句中的 **expression** 必须是一个整型或枚举类型，或者是一个 class 类型（其中有一个单一的转换函数将其转换为整型或枚举类型）
- case 的 **constant-expression** 必须与 switch 中的变量具有相同的数据类型，且必须是一个常量
- 不是每一个 case 都需要包含 **break**。如果 case 语句为空，则可以不包含 **break**，控制流将会 *继续* 后续的 case，直到遇到 break 为止。
- 一个 **switch** 语句可以有一个可选的 **default** case，出现在 switch 的结尾。default case 可用于在上面所有 case 都不为真时执行一个任务。default case 中的 **break** 语句不是必需的。

```C#
using System;

namespace DecisionMaking
{
   
    class Program
    {
        static void Main(string[] args)
        {
            /* 局部变量定义 */
            char grade = 'B';

            switch (grade)
            {
                case 'A':
                    Console.WriteLine("很棒！");
                    break;
                case 'B':
                case 'C':
                    Console.WriteLine("做得好");
                    break;
                case 'D':
                    Console.WriteLine("您通过了");
                    break;
                case 'F':
                    Console.WriteLine("最好再试一下");
                    break;
                default:
                    Console.WriteLine("无效的成绩");
                    break;
            }
            Console.WriteLine("您的成绩是 {0}", grade);
            Console.ReadLine();
        }
    }
}
```

## 循环语句

C# 拥有 `break` 和 `continue` 两个循环控制语句

### while 循环

```C#
while(condition)
{
   statement(s);
}
```

### for 循环

```C#
for ( init; condition; increment )
{
   statement(s);
}
```

### foreach 循环

使用 foreach 可以迭代数组或者一个集合对象。

以下实例有三个部分：

- 通过 foreach 循环输出整型数组中的元素。
- 通过 for 循环输出整型数组中的元素。
- foreach 循环设置数组元素的计算器。

```C#
class ForEachTest
{
    static void Main(string[] args)
    {
        int[] fibarray = new int[] { 0, 1, 1, 2, 3, 5, 8, 13 };
        foreach (int element in fibarray)
        {
            System.Console.WriteLine(element);
        }
        System.Console.WriteLine();


        // 类似 foreach 循环
        for (int i = 0; i < fibarray.Length; i++)
        {
            System.Console.WriteLine(fibarray[i]);
        }
        System.Console.WriteLine();


        // 设置集合中元素的计算器
        int count = 0;
        foreach (int element in fibarray)
        {
            count += 1;
            System.Console.WriteLine("Element #{0}: {1}", count, element);
        }
        System.Console.WriteLine("Number of elements in the array: {0}", count);
    }
}
```

### do...while 循环

**do...while** 循环在循环的尾部检查它的条件，所以它确保至少执行一次循环。

```c#
do
{
   statement(s);

} while( condition );
```

## 封装

**封装** 被定义为"把一个或多个项目封闭在一个物理的或者逻辑的包中"。在面向对象程序设计方法论中，封装是为了防止对实现细节的访问

C# 封装根据具体的需要，设置使用者的访问权限，并通过 **访问修饰符** 来实现

一个 **访问修饰符** 定义了一个类成员的范围和可见性。C# 支持的访问修饰符如下所示：

- public：所有对象都可以访问；
- private：对象本身在对象内部可以访问；
- protected：只有该类对象及其子类对象可以访问
- internal：同一个程序集的对象可以访问；
- protected internal：访问限于当前程序集或派生自包含类的类型

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/csharp-public.png)

### Public 访问修饰符

Public 访问修饰符允许一个类将其成员变量和成员函数暴露给其他的函数和对象。任何公有成员可以被外部的类访问

```C#
using System;

namespace RectangleApplication
{
    class Rectangle
    {
        //成员变量
        public double length;
        public double width;

        public double GetArea()
        {
            return length * width;
        }
        public void Display()
        {
            Console.WriteLine("长度： {0}", length);
            Console.WriteLine("宽度： {0}", width);
            Console.WriteLine("面积： {0}", GetArea());
        }
    }// Rectangle 结束

    class ExecuteRectangle
    {
        static void Main(string[] args)
        {
            Rectangle r = new Rectangle();
            r.length = 4.5;
            r.width = 3.5;
            r.Display();
            Console.ReadLine();
        }
    }
}
```

### Protected 访问修饰符

Protected 访问修饰符允许子类访问它的基类的成员变量和成员函数。这样有助于实现继承。

### Private 访问修饰符

如果没有指定访问修饰符，则使用类成员的默认访问修饰符，即为 **private**。

### Internal 访问修饰符

Internal 访问说明符限于当前**命名空间**

换句话说，带有 internal 访问修饰符的任何成员可以被定义在该成员所定义的应用程序内的任何类或方法访问。

### Protected Internal 访问修饰符

Protected Internal 访问修饰符允许在本类,派生类或者包含该类的程序集中访问。这也被用于实现继承。

## 方法

一个方法是把一些相关的语句组织在一起，用来执行一个任务的语句块。每一个 C# 程序至少有一个带有 Main 方法的类

### 定义方法

```c#
<Access Specifier> <Return Type> <Method Name>(Parameter List)
{
   // Method Body
}
```

- **Access Specifier**：访问修饰符，这个决定了变量或方法对于另一个类的可见性。
- **Return type**：返回类型，一个方法可以返回一个值。返回类型是方法返回的值的数据类型。如果方法不返回任何值，则返回类型为 **void**。
- **Method name**：方法名称，是一个唯一的标识符，且是大小写敏感的。它不能与类中声明的其他标识符相同。
- **Parameter list**：参数列表，使用圆括号括起来，该参数是用来传递和接收方法的数据。参数列表是指方法的参数类型、顺序和数量。参数是可选的，也就是说，一个方法可能不包含参数。
- **Method body**：方法主体，包含了完成任务所需的指令集。

有例

```C#
class NumberManipulator
{
   public int FindMax(int num1, int num2)
   {
      /* 局部变量声明 */
      int result;

      if (num1 > num2)
         result = num1;
      else
         result = num2;

      return result;
   }
   ...
}
```

### 引用方法

```c#
using System;

namespace CalculatorApplication
{
   class NumberManipulator
   {
      public int FindMax(int num1, int num2)
      {
         /* 局部变量声明 */
         int result;

         if (num1 > num2)
            result = num1;
         else
            result = num2;

         return result;
      }
      static void Main(string[] args)
      {
         /* 局部变量定义 */
         int a = 100;
         int b = 200;
         int ret;
         NumberManipulator n = new NumberManipulator();

         //调用 FindMax 方法
         ret = n.FindMax(a, b);
         Console.WriteLine("最大值是： {0}", ret );
         Console.ReadLine();
      }
   }
}
```

### 参数传递

| 方式     | 描述                                                         |
| :------- | :----------------------------------------------------------- |
| 值参数   | 这种方式复制参数的实际值给函数的形式参数，实参和形参使用的是**两个不同内存中的值**，这保证了实参数据的安全。 |
| 引用参数 | 这种方式复制参数的内存位置的引用给形式参数。这意味着，当形参的值发生改变时，同时也改变实参的值。 |
| 输出参数 | 这种方式可以返回多个值。                                     |

```c#
// 值参数，这个函数屁用没有
public void swap(int x, int y)
{
    int temp;

    temp = x; /* 保存 x 的值 */
    x = y;    /* 把 y 赋值给 x */
    y = temp; /* 把 temp 赋值给 y */
}
// 调用时
int a = 100;
int b = 200;
n.swap(a, b);

// 引用参数，使用 ref 修饰
public void swap(ref int x, ref int y)
{
    int temp;

    temp = x; /* 保存 x 的值 */
    x = y;    /* 把 y 赋值给 x */
    y = temp; /* 把 temp 赋值给 y */
}
// 调用时
int a = 100;
int b = 200;
n.swap(ref a, ref b);

// 输出参数
public void getValue(out int x )
{
    int temp = 5;
    x = temp;
}
// 调用时
int a = 100;
n.swap(out a);
```

提供给输出参数的变量不需要赋值（只需要声明即可）。当需要从一个参数没有指定初始值的方法中返回值时，输出参数特别有用

```c#
using System;

namespace CalculatorApplication
{
   class NumberManipulator
   {
      public void getValues(out int x, out int y )
      {
          Console.WriteLine("请输入第一个值： ");
          x = Convert.ToInt32(Console.ReadLine());
          Console.WriteLine("请输入第二个值： ");
          y = Convert.ToInt32(Console.ReadLine());
      }
   
      static void Main(string[] args)
      {
         NumberManipulator n = new NumberManipulator();
         /* 局部变量定义 */
         int a , b;
         
         /* 调用函数来获取值 */
         n.getValues(out a, out b);

         Console.WriteLine("在方法调用之后，a 的值： {0}", a);
         Console.WriteLine("在方法调用之后，b 的值： {0}", b);
         Console.ReadLine();
      }
   }
}
```

## 可空类型 nullable

可空类型可以表示其基础值类型正常范围内的值，再加上一个 null 值。

例如，Nullable< Int32 >，读作"可空的 Int32"，可以被赋值为 -2,147,483,648 到 2,147,483,647 之间的任意值，也可以被赋值为 null 值。

```C#
<data_type> ? <variable_name> = null;、

int i;   //默认值0
int? ii; //默认值null
```

```c#
using System;
namespace CalculatorApplication
{
   class NullablesAtShow
   {
      static void Main(string[] args)
      {
         int? num1 = null;
         int? num2 = 45;
         double? num3 = new double?();
         double? num4 = 3.14157;
         
         bool? boolval = new bool?();

         // 显示值
         Console.WriteLine("显示可空类型的值： {0}, {1}, {2}, {3}",
                            num1, num2, num3, num4);
         Console.WriteLine("一个可空的布尔值： {0}", boolval);
         Console.ReadLine();

      }
   }
}
```

输出

```
显示可空类型的值： , 45,  , 3.14157
一个可空的布尔值：
```

### Null 合并运算符（ ?? ）

Null 合并运算符为类型转换定义了一个预设值，以防可空类型的值为 Null。

```c#
using System;
namespace CalculatorApplication
{
   class NullablesAtShow
   {
         
      static void Main(string[] args)
      {
         
         double? num1 = null;
         double? num2 = 3.14157;
         double num3;
         num3 = num1 ?? 5.34;      // num1 如果为空值则返回 5.34
         Console.WriteLine("num3 的值： {0}", num3);
         num3 = num2 ?? 5.34;
         Console.WriteLine("num3 的值： {0}", num3);
         Console.ReadLine();

      }
   }
}
```

## 数组 Array

### 基本操作

#### 声明

```C#
datatype[] arrayName;
//如
double[] balance;
```

#### 初始化

数组是一个引用类型，需要使用 **new** 关键字来创建数组的实例

```C#
double[] balance = new double[10];
```

#### 赋值

给单个元素赋值

```C#
double[] balance = new double[10];
balance[0] = 4500.0;
```

在声明数组的同时赋值

```C#
double[] balance = { 2340.0, 4523.69, 3421.0};
```

创建并初始化一个数组

```c#
int[] marks = new int[5]  { 99,  98, 92, 97, 95};
```

省略数组的大小

```c#
int[] marks = new int[]  { 99,  98, 92, 97, 95};
```

赋值一个数组变量到另一个目标数组变量中。在这种情况下，目标和源会指向相同的内存位置

```c#
int 、[] marks = new int[]  { 99,  98, 92, 97, 95};
int[] score = marks;
```

当创建一个数组时，C# 编译器会根据数组类型隐式初始化每个数组元素为一个默认值。例如，int 数组的所有元素都会被初始化为 0

#### 访问

```c#
double salary = balance[9];
```

### 多维数组

多维数组又称为矩形数组

声明一个 string 变量的二维数组，如下：

```c#
string [,] names;
```

![C# 中的二维数组](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/two_dimensional_arrays.jpg)

或者，声明一个 int 变量的三维数组，如下：

```c#
int [ , , ] m;
```

#### 初始化二维数组

多维数组可以通过在括号内为每行指定值来进行初始化。下面是一个带有 3 行 4 列的数组。

```c#
int [,] a = new int [3,4] {
 {0, 1, 2, 3} ,   /*  初始化索引号为 0 的行 */
 {4, 5, 6, 7} ,   /*  初始化索引号为 1 的行 */
 {8, 9, 10, 11}   /*  初始化索引号为 2 的行 */
};
```

#### 访问二维数组元素

二维数组中的元素是通过使用下标（即数组的行索引和列索引）来访问的。例如：

```c#
int val = a[2,3];
```

### 交错数组

交错数组就是数组的数组

可以声明一个带有 **int** 值的交错数组 *scores*，如下所示：

```c#
int [][] scores;
```

第一个中括号中的数字为数组的长度

声明一个数组不会在内存中创建数组。

创建上面的数组：

```C#
int[][] scores = new int[5][];
for (int i = 0; i < scores.Length; i++) 
{
   scores[i] = new int[4];
}
```

初始化一个交错数组，如下所示：

```c#
int[][] scores = new int[2][]{new int[]{92,93,94},new int[]{85,66,87,88}};
```

其中，scores 是一个由两个整型数组组成的数组 -- scores[0] 是一个带有 3 个整数的数组，scores[1] 是一个带有 4 个整数的数组。

有例：

```c#
using System;

namespace ArrayApplication
{
    class MyArray
    {
        static void Main(string[] args)
        {
            /* 一个由 5 个整型数组组成的交错数组 */
            int[][] a = new int[][]{new int[]{0,0},new int[]{1,2},
            new int[]{2,4},new int[]{ 3, 6 }, new int[]{ 4, 8 } };

            int i, j;

            /* 输出数组中每个元素的值 */
            for (i = 0; i < 5; i++)
            {
                for (j = 0; j < 2; j++)
                {
                    Console.WriteLine("a[{0}][{1}] = {2}", i, j, a[i][j]);
                }
            }
           Console.ReadKey();
        }
    }
}
```

### Array 类

Array 类是 C# 中所有数组的基类，它是在 System 命名空间中定义。Array 类提供了各种用于数组的属性和方法。

#### 属性

- ***Length***
    - 数组长度，32 位整数
- ***LongLength***
    - 数组长度，64 位整数
- ***Rank***
    - 数组的秩，即维度数
- ***IsReadOnly***
    - 数组是否为只读
- ***IsFixedSize***
    - 数组大小是否固定

#### 方法

`list` 代表数组实例

- ***list.GetValue(int index)***
    - 获取一维数组中指定位置的元素值
- ***list.SetValue(object? value, int index)***
    - 给一维数组中指定位置的元素设置值。索引由一个 32 位整数指定
- ***Array.Clear(Array array, int startIndex, int length)***
    - 删除数组中的所有元素
- ***list.IndexOf(Array array, object? value)***
    - 获取指定数组指定元素的索引
- ***list.LastIndexOf(Array array, object? value)***
    - 获取指定数组指定元素出现的**最后位置**的索引
- ***Array.Sort(Array array)***
    - 顺序排序
- ***Array.Reverse(Array array)***
    - 将数组倒置
- ***list.GetLength(int dimension)***
    - 查询数组指定秩的元素数量
- ***GetLongLength()***
- ***FindIndex()***
- ***Copy()***
- ***CopyTo()***
- ***Clone()***
- ***ConstrainedCopy()***
- ***BinarySearch()***
- ***GetLowerBound()***
- ***GetUpperBound()***


| 序号 | 方法 & 描述                                                  |
| :--- | :----------------------------------------------------------- |
| 1    | **Clear()** 根据元素的类型，设置数组中某个范围的元素为零、为 false 或者为 null。 |
| 2    | **Copy(Array, Array, Int32)** 从数组的第一个元素开始复制某个范围的元素到另一个数组的第一个元素位置。长度由一个 32 位整数指定。 |
| 3    | **CopyTo(Array, Int32)** 从当前的一维数组中复制所有的元素到一个指定的一维数组的指定索引位置。索引由一个 32 位整数指定。 |
| 4    | **GetLength** 获取一个 32 位整数，该值表示指定维度的数组中的元素总数。 |
| 5    | **GetLongLength** 获取一个 64 位整数，该值表示指定维度的数组中的元素总数。 |
| 6    | **GetLowerBound** 获取数组中指定维度的下界。                 |
| 7    | **GetType** 获取当前实例的类型。从对象（Object）继承。       |
| 8    | **GetUpperBound** 获取数组中指定维度的上界。                 |
| 9    | **GetValue(Int32)** 获取一维数组中指定位置的值。索引由一个 32 位整数指定。 |
| 10   | **IndexOf(Array, Object)** 搜索指定的对象，返回整个一维数组中第一次出现的索引。 |
| 11   | **Reverse(Array)** 逆转整个一维数组中元素的顺序。            |
| 12   | **SetValue(Object, Int32)** 给一维数组中指定位置的元素设置值。索引由一个 32 位整数指定。 |
| 13   | **Sort(Array)** 使用数组的每个元素的 IComparable 实现来排序整个一维数组中的元素。 |
| 14   | **ToString** 返回一个表示当前对象的字符串。从对象（Object）继承。 |
