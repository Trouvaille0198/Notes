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
- ***Array.IndexOf(T[] array, object? value)***
    - 获取指定数组指定元素的索引
- ***Array.LastIndexOf(T[] array, object? value)***
    - 获取指定数组指定元素出现的**最后位置**的索引
- ***Array.Sort(T[] array)***
    - 顺序排序
- ***Array.Reverse(T[] array)***
    - 将数组倒置
- ***list.GetLength(int dimension)***
    - 查询数组指定秩的元素数量
- ***list.GetLongLength(int dimension)***
    - 查询数组指定秩的元素数量，64 位整数
- ***Array.FindIndex(T[] array, int startIndex, int count, Predicate\<T\> match)***
    - 搜索指定元素，返回索引（用法存疑）
- ***Array.Copy(Array sourceArray, Array destinationArray, int length)***
    - 将 `SourceArray` 拷贝到 `destinationArray` 上
- ***list.CopyTo(Array array, int index)***
    - 将 `list` 拷贝至 `array`（从 `array` 索引为 `index` 的位上开始）
- ***Clone()***
- ***ConstrainedCopy()***
- ***BinarySearch()***
- ***GetLowerBound()***
- ***GetUpperBound()***

```C#
using System;
namespace TypeConversionApplication
{
    class ExplicitConversion
    {
        static void Main(string[] args)
        {
            int[] list;

            Console.WriteLine("Sort");
            list = new int[] { 1, 5, 2, 6, 3 };
            Array.Sort(list);
            foreach (int x in list)
            {

                Console.WriteLine(x);
            }


            Console.WriteLine("Reverse");
            list = new int[] { 1, 5, 2, 6, 3 };
            Array.Reverse(list);
            foreach (int x in list)
            {

                Console.WriteLine(x);
            }


            Console.WriteLine("Clear");
            list = new int[] { 1, 5, 2, 6, 3 };
            Array.Clear(list, 0, list.Length);
            foreach (int x in list)
            {

                Console.WriteLine(x);
            }


            Console.WriteLine("GetValue");
            list = new int[] { 1, 5, 2, 6, 3 };
            Console.WriteLine(list.GetValue(0));


            Console.WriteLine("SetValue");
            list = new int[] { 1, 5, 2, 6, 3 };
            list.SetValue(100, 0);
            Console.WriteLine(list[0]);


            Console.WriteLine("IndexOf");
            list = new int[] { 1, 5, 2, 6, 3, 1 };
            Console.WriteLine(Array.IndexOf(list, 1));


            Console.WriteLine("LastIndexOf");
            list = new int[] { 1, 5, 2, 6, 3, 1 };
            Console.WriteLine(Array.LastIndexOf(list, 1));


            Console.WriteLine("GetLength");
            int[,] list2 = new int[,] { { 1, 2 }, { 3, 4 }, { 5, 6 } };
            Console.WriteLine(list2.GetLength(0)); // 秩为0的元素数量，为3
            Console.WriteLine(list2.GetLength(1)); // 秩为1的元素数量，为2

            Console.WriteLine("Copy");
            list = new int[] { 1, 5, 2, 6, 3, 1 };
            int[] listCopy = new int[10];
            Array.Copy(list, listCopy, 4);
            foreach (int i in listCopy)
            {
                Console.WriteLine(i);
            }

            Console.WriteLine("CopyTo");
            list = new int[] { 1, 5, 2, 6, 3, 1 };
            int[] listCopy2 = new int[10];
            list.CopyTo(listCopy2, 1);
            foreach (int i in listCopy2)
            {
                Console.WriteLine(i); //0 1 5 2 6 3 1 0 0 0
            }

            // Console.ReadKey();
        }
    }
}
```

## 字符串 String

可以使用字符数组来表示字符串，但是更常见的做法是使用 **string** 关键字来声明一个字符串变量。

string 关键字是 **System.String** 类的别名。

### 创建

可以使用以下方法之一来创建 string 对象：

- 通过给 String 变量指定一个字符串
- 通过使用 String 类构造函数
- 通过使用字符串串联运算符（ + ）
- 通过检索属性或调用一个返回字符串的方法
- 通过格式化方法来转换一个值或对象为它的字符串表示形式

```c#
using System;

namespace StringApplication
{
    class Program
    {
        static void Main(string[] args)
        {
           //字符串，字符串连接
            string fname, lname;
            fname = "Rowan";
            lname = "Atkinson";

            string fullname = fname + lname;
            Console.WriteLine("Full Name: {0}", fullname);

            //通过使用 string 构造函数
            char[] letters = { 'H', 'e', 'l', 'l','o' };
            string greetings = new string(letters);
            Console.WriteLine("Greetings: {0}", greetings);

            //方法返回字符串
            string[] sarray = { "Hello", "From", "Tutorials", "Point" };
            string message = String.Join(" ", sarray);
            Console.WriteLine("Message: {0}", message);

            //用于转化值的格式化方法
            DateTime waiting = new DateTime(2012, 10, 10, 17, 58, 1);
            string chat = String.Format("Message sent at {0:t} on {0:D}",
            waiting);
            Console.WriteLine("Message: {0}", chat);
            Console.ReadKey() ;
        }
    }
}
```

输出

```
Full Name: RowanAtkinson
Greetings: Hello
Message: Hello From Tutorials Point
Message: Message sent at 17:58 on Wednesday, 10 October 2012
```

### 属性

- ***Length***
    - 字符串长度

### 方法

- ***ToUpper()***
    - 小写转大写
- ***ToLower()***
    - 大写转小写
- ***Equals(String? value, StringComparison comparisonType)***
    - 是否与 `value`  相同
    - *StringComparison comparisonType*
        - `StringComparison.OrdinalIgnoreCase` 不区分大小写
        - `StringComparison.Ordinal` 区分大小写
- ***Spilt(String? separator, StringSplitOptions options = StringSplitOptions.None)***
    - 根据 `separator` 分割字符串，返回字符串类型的数组
    - *StringSplitOptions options*
        - `StringSplitOptions.RemoveEmptyEntries` 移除空字符串
- ***SubString(int startIndex)***
    - 截取字符串，在截取的时候包含截取的索引位置
    - 返回从 `startIndex` 后的字符串
- ***IndexOf(char value)***
    - 返回 `value` 在字符串中的位置索引
- ***LastIndexOf()(char value)***
    - 返回 `value` 在最后出现在字符串中的位置索引
- ***StartsWith(char value)***
    - 判断字符串是否以 `value` 开头
- ***Replace(char oldChar, char newChar)***
    - 替换指定字符串
- ***Contains(char value)***
    - 判断字符串是否包含指定的子字符串 `value`
- ***Trim()***
    - 掉字符串前后的空格
- ***TrimStart() 和 TrimEnd()***
    - 去掉字符串前面的空格，去掉字符串后面的空格
- ***IsNullOrEmpty()***
    - 判断字符串是否为空
- ***string.Join(char separator, string[] str)***
    - 数组 `str` 按照指定的字符串 `separator` 连接，并返回一个字符串

## 结构体 struct

### 定义

```C#
struct Books
{
   public string title;
   public string author;
   public string subject;
   public int book_id;
};  
```

有例：

```c#
public class testStructure
{
   public static void Main(string[] args)
   {

      Books Book1;        /* 声明 Book1，类型为 Books */
      Books Book2;        /* 声明 Book2，类型为 Books */

      /* book 1 详述 */
      Book1.title = "C Programming";
      Book1.author = "Nuha Ali";
      Book1.subject = "C Programming Tutorial";
      Book1.book_id = 6495407;

      /* book 2 详述 */
      Book2.title = "Telecom Billing";
      Book2.author = "Zara Ali";
      Book2.subject =  "Telecom Billing Tutorial";
      Book2.book_id = 6495700;

      Console.ReadKey();

   }
}
```

### 特点

- 结构可带有方法、字段、索引、属性、运算符方法和事件。
- 结构可定义构造函数，但不能定义析构函数。但是不能为结构定义无参构造函数。无参构造函数(默认)是自动定义的，且不能被改变。
- 与类不同，结构不能继承其他的结构或类。
- 结构不能作为其他结构或类的基础结构。
- 结构可实现一个或多个接口。
- 结构成员不能指定为 abstract、virtual 或 protected。
- 当您使用 **New** 操作符创建一个结构对象时，会调用适当的构造函数来创建结构。与类不同，结构可以不使用 New 操作符即可被实例化。
- 如果不使用 New 操作符，只有在所有的字段都被初始化之后，字段才被赋值，对象才被使用。

有例：

```c#
struct Books
{
   private string title;
   private string author;
   private string subject;
   private int book_id;
   public void setValues(string t, string a, string s, int id)
   {
      title = t;
      author = a;
      subject = s;
      book_id =id;
   }
   public void display()
   {
      Console.WriteLine("Title : {0}", title);
      Console.WriteLine("Author : {0}", author);
      Console.WriteLine("Subject : {0}", subject);
      Console.WriteLine("Book_id :{0}", book_id);
   }

}; 
```

### 类与结构体的不同点

- 类是引用类型，结构是值类型。
- 结构不支持继承。
- 结构不能声明默认的构造函数。
- 结构体中声明的字段无法赋予初值，类可以

## 枚举 enum

枚举是一组命名整型常量。枚举类型是使用 **enum** 关键字声明的

### 声明

```c#
enum <enum_name>
{ 
    enumeration list 
};
```

- *enum_name* 指定枚举的类型名称。
- *enumeration list* 是一个用逗号分隔的标识符列表。

枚举列表中的每个符号代表一个整数值，一个比它前面的符号大的整数值。

默认情况下，第一个枚举符号的值是 0

```C#
enum Days { Sun, Mon, tue, Wed, thu, Fri, Sat };
```

有例：

```c#
using System;

public class EnumTest
{
    enum Day { Sun, Mon, Tue, Wed, Thu, Fri, Sat };

    static void Main()
    {
        int x = (int)Day.Sun;
        int y = (int)Day.Fri;
        Console.WriteLine("Sun = {0}", x);
        Console.WriteLine("Fri = {0}", y);
    }
}
```

## 类 class

你定义一个类时，你定义了一个数据类型的蓝图

## 定义

```c#
<access specifier> class  class_name
{
    // member variables
    <access specifier> <data type> variable1;
    <access specifier> <data type> variable2;
    ...
    <access specifier> <data type> variableN;
    // member methods
    <access specifier> <return type> method1(parameter_list)
    {
        // method body
    }
    <access specifier> <return type> method2(parameter_list)
    {
        // method body
    }
    ...
    <access specifier> <return type> methodN(parameter_list)
    {
        // method body
    }
}
```

- 访问标识符 `<access specifier>` 指定了对类及其成员的访问规则。如果没有指定，则使用默认的访问标识符。类的默认访问标识符是 **internal**，成员的默认访问标识符是 **private**。
- 数据类型 `<data type>` 指定了变量的类型，返回类型 `<return type>` 指定了返回的方法返回的数据类型。
- 如果要访问类的成员，你要使用点（.）运算符。点运算符链接了对象的名称和成员的名称

### 构造函数

构造函数是类的一个特殊的成员函数，当创建类的新对象时执行。

构造函数的名称与类的名称完全相同，它没有任何返回类型

```c#
using System;
namespace LineApplication
{
   class Line
   {
      private double length;   // 线条的长度
      public Line()
      {
         Console.WriteLine("对象已创建");
      }

      public void setLength( double len )
      {
         length = len;
      }
      public double getLength()
      {
         return length;
      }

      static void Main(string[] args)
      {
         Line line = new Line();    
         // 设置线条长度
         line.setLength(6.0);
         Console.WriteLine("线条的长度： {0}", line.getLength());
         Console.ReadKey();
      }
   }
}
```

默认的构造函数没有任何参数。有参数的构造函数叫做参数化构造函数

```C#
public Line(double len)  // 参数化构造函数
{
    Console.WriteLine("对象已创建，length = {0}", len);
    length = len;
}
```

### 析构函数

当类的对象超出范围时，析构函数执行

析构函数的名称是在类的名称前加上一个波浪形（~）作为前缀，它不返回值，也不带任何参数

析构函数用于在结束程序（比如关闭文件、释放内存等）之前释放资源。析构函数不能继承或重载。

```c#
~Line() //析构函数
{
    Console.WriteLine("对象已删除");
}
```

### 静态成员

使用 **static** 关键字把类成员定义为静态的

当我们声明一个类成员为静态时，意味着无论有多少个类的对象被创建，只会有一个该静态成员的副本。

静态变量用于定义常量，因为它们的值可以通过直接调用类而不需要创建类的实例来获取

静态变量可在成员函数或类的定义外部进行初始化，也可以在类的定义内部初始化

```c#
class StaticVar
{
    public static int num;
    public void count()
    {
        num++;
    }
    public int getNum()
    {
        return num;
    }
}
// 调用 count() 时，所有实例的 num 都会 ++
```

### 继承

```c#
<访问修饰符符> class <基类>
{
 ...
}

class <派生类> : <基类>
{
 ...
}
```

有例：

```c#
using System;
namespace InheritanceApplication
{
   class Shape
   {
      public void setWidth(int w)
      {
         width = w;
      }
      public void setHeight(int h)
      {
         height = h;
      }
      protected int width;
      protected int height;
   }

   // 派生类
   class Rectangle: Shape
   {
      public int getArea()
      {
         return (width * height);
      }
   }
   
   class RectangleTester
   {
      static void Main(string[] args)
      {
         Rectangle Rect = new Rectangle();

         Rect.setWidth(5);
         Rect.setHeight(7);

         // 打印对象的面积
         Console.WriteLine("总面积： {0}",  Rect.getArea());
         Console.ReadKey();
      }
   }
}
```

#### 要点

- 父类对象应在子类对象创建之前被创建

#### 多重继承

多重继承指的是一个类别可以同时从多于一个父类继承行为与特征的功能。而单一继承指一个类别只可以继承自一个父类。

```c#
using System;
namespace InheritanceApplication
{
   class Shape
   {
      public void setWidth(int w)
      {
         width = w;
      }
      public void setHeight(int h)
      {
         height = h;
      }
      protected int width;
      protected int height;
   }

   // 基类 PaintCost
   public interface PaintCost
   {
      int getCost(int area);

   }
   // 派生类
   class Rectangle : Shape, PaintCost
   {
      public int getArea()
      {
         return (width * height);
      }
      public int getCost(int area)
      {
         return area * 70;
      }
   }
   class RectangleTester
   {
      static void Main(string[] args)
      {
         Rectangle Rect = new Rectangle();
         int area;
         Rect.setWidth(5);
         Rect.setHeight(7);
         area = Rect.getArea();
         // 打印对象的面积
         Console.WriteLine("总面积： {0}",  Rect.getArea());
         Console.WriteLine("油漆总成本： ${0}" , Rect.getCost(area));
         Console.ReadKey();
      }
   }
}
```

### 多态

多态是同一个行为具有多个不同表现形式或形态的能力，往往表现为“一个接口，多个功能”

多态性可以是静态的或动态的。

- 在**静态多态性**中，函数的响应是在编译时发生的。
- 在**动态多态性**中，函数的响应是在运行时发生的。

#### 静态多态性

在编译时，函数和对象的连接机制被称为早期绑定，也被称为静态绑定

##### 函数重载

可以在同一个范围内对相同的函数名有多个定义

函数的定义必须彼此不同，可以是参数列表中的参数类型不同，也可以是参数个数不同。

不能重载只有返回类型不同的函数声明

```c#
public class TestData  
{  
    public int Add(int a, int b, int c)  
    {  
        return a + b + c;  
    }  
    public int Add(int a, int b)  
    {  
        return a + b;  
    }  
}
```

##### 运算符重载

重载运算符是具有特殊名称的函数，是通过关键字 **operator** 后跟运算符的符号来定义的。

与其他函数一样，重载运算符有返回类型和参数列表。

```c#
public static Box operator+ (Box b, Box c)
{
   Box box = new Box();
   box.length = b.length + c.length;
   box.breadth = b.breadth + c.breadth;
   box.height = b.height + c.height;
   return box;
}
// 此函数为用户自定义的类 Box 实现了加法运算符（+）。它把两个 Box 对象的属性相加，并返回相加后的 Box 对象。
```

有例：

```c#
using System;

namespace OperatorOvlApplication
{
   class Box
   {
      private double length;      // 长度
      private double breadth;     // 宽度
      private double height;      // 高度

      public double getVolume()
      {
         return length * breadth * height;
      }
      public void setLength( double len )
      {
         length = len;
      }

      public void setBreadth( double bre )
      {
         breadth = bre;
      }

      public void setHeight( double hei )
      {
         height = hei;
      }
      // 重载 + 运算符来把两个 Box 对象相加
      public static Box operator+ (Box b, Box c)
      {
         Box box = new Box();
         box.length = b.length + c.length;
         box.breadth = b.breadth + c.breadth;
         box.height = b.height + c.height;
         return box;
      }

   }

   class Tester
   {
      static void Main(string[] args)
      {
         Box Box1 = new Box();         // 声明 Box1，类型为 Box
         Box Box2 = new Box();         // 声明 Box2，类型为 Box
         Box Box3 = new Box();         // 声明 Box3，类型为 Box
         double volume = 0.0;          // 体积

         // Box1 详述
         Box1.setLength(6.0);
         Box1.setBreadth(7.0);
         Box1.setHeight(5.0);

         // Box2 详述
         Box2.setLength(12.0);
         Box2.setBreadth(13.0);
         Box2.setHeight(10.0);

         // Box1 的体积
         volume = Box1.getVolume();
         Console.WriteLine("Box1 的体积： {0}", volume);

         // Box2 的体积
         volume = Box2.getVolume();
         Console.WriteLine("Box2 的体积： {0}", volume);

         // 把两个对象相加
         Box3 = Box1 + Box2;

         // Box3 的体积
         volume = Box3.getVolume();
         Console.WriteLine("Box3 的体积： {0}", volume);
         Console.ReadKey();
      }
   }
}
```

##### 可重载和不可重载的运算符

| 运算符                                | 描述                                         |
| :------------------------------------ | :------------------------------------------- |
| +, -, !, ~, ++, --                    | 这些一元运算符只有一个操作数，且可以被重载。 |
| +, -, *, /, %                         | 这些二元运算符带有两个操作数，且可以被重载。 |
| ==, !=, <, >, <=, >=                  | 这些比较运算符可以被重载。                   |
| &&, \|\|                              | 这些条件逻辑运算符不能被直接重载。           |
| +=, -=, *=, /=, %=                    | 这些赋值运算符不能被重载。                   |
| =, ., ?:, ->, new, is, sizeof, typeof | 这些运算符不能被重载。                       |

有例：

```c#
public static Box operator+ (Box b, Box c)
{
    Box box = new Box();
    box.length = b.length + c.length;
    box.breadth = b.breadth + c.breadth;
    box.height = b.height + c.height;
    return box;
}

public static bool operator == (Box lhs, Box rhs)
{
    bool status = false;
    if (lhs.length == rhs.length && lhs.height == rhs.height
        && lhs.breadth == rhs.breadth)
    {
        status = true;
    }
    return status;
}
public static bool operator !=(Box lhs, Box rhs)
{
    bool status = false;
    if (lhs.length != rhs.length || lhs.height != rhs.height
        || lhs.breadth != rhs.breadth)
    {
        status = true;
    }
    return status;
}
public static bool operator <(Box lhs, Box rhs)
{
    bool status = false;
    if (lhs.length < rhs.length && lhs.height
        < rhs.height && lhs.breadth < rhs.breadth)
    {
        status = true;
    }
    return status;
}

public static bool operator >(Box lhs, Box rhs)
{
    bool status = false;
    if (lhs.length > rhs.length && lhs.height
        > rhs.height && lhs.breadth > rhs.breadth)
    {
        status = true;
    }
    return status;
}

public static bool operator <=(Box lhs, Box rhs)
{
    bool status = false;
    if (lhs.length <= rhs.length && lhs.height
        <= rhs.height && lhs.breadth <= rhs.breadth)
    {
        status = true;
    }
    return status;
}

public static bool operator >=(Box lhs, Box rhs)
{
    bool status = false;
    if (lhs.length >= rhs.length && lhs.height
        >= rhs.height && lhs.breadth >= rhs.breadth)
    {
        status = true;
    }
    return status;
}
```



#### 动态多态性

动态多态性是通过 **抽象类** 和 **虚方法** 实现的。

##### abstract

使用关键字 **abstract** 创建抽象类，用于提供接口的部分类的实现

当一个派生类继承自该抽象类时，实现即完成。

**抽象类**包含抽象方法，抽象方法可被派生类实现。派生类具有更专业的功能。

抽象类不能直接实例化，但允许派生出具体的，具有实际功能的类。

**规则**

- 不能创建一个抽象类的实例。
- 不能在一个抽象类外部声明一个抽象方法。
- 通过在类定义前面放置关键字 **sealed**，可以将类声明为**密封类**。当一个类被声明为 **sealed** 时，它不能被继承。抽象类不能被声明为 sealed。

有例：

```c#
using System;
namespace PolymorphismApplication
{
   abstract class Shape
   {
       abstract public int area();
   }
   class Rectangle:  Shape
   {
      private int length;
      private int width;
      public Rectangle( int a=0, int b=0)
      {
         length = a;
         width = b;
      }
      public override int area()
      {
         Console.WriteLine("Rectangle 类的面积：");
         return (width * length);
      }
   }

   class RectangleTester
   {
      static void Main(string[] args)
      {
         Rectangle r = new Rectangle(10, 7);
         double a = r.area();
         Console.WriteLine("面积： {0}",a);
         Console.ReadKey();
      }
   }
}
```

##### virtual

- 当有一个定义在类中的函数需要在继承类中实现时，可以使用**虚方法**。

- 虚方法是使用关键字 **virtual** 声明的。

- 虚方法可以在不同的继承类中有不同的实现。

- 对虚方法的调用是在运行时发生的。

以下实例创建了 Shape 基类，并创建派生类 Circle、 Rectangle、Triangle， Shape 类提供一个名为 Draw 的虚拟方法，在每个派生类中重写该方法以绘制该类的指定形状。

```C#
using System;
using System.Collections.Generic;

public class Shape
{
    public int X { get; private set; }
    public int Y { get; private set; }
    public int Height { get; set; }
    public int Width { get; set; }
   
    // 虚方法
    public virtual void Draw()
    {
        Console.WriteLine("执行基类的画图任务");
    }
}

class Circle : Shape
{
    public override void Draw()
    {
        Console.WriteLine("画一个圆形");
        base.Draw();
    }
}
class Rectangle : Shape
{
    public override void Draw()
    {
        Console.WriteLine("画一个长方形");
        base.Draw();
    }
}
class Triangle : Shape
{
    public override void Draw()
    {
        Console.WriteLine("画一个三角形");
        base.Draw();
    }
}
```

## 接口 interface

接口定义了所有类继承接口时应遵循的语法合同。

接口定义了语法合同 **"是什么"** 部分，派生类定义了语法合同 **"怎么做"** 部分。

接口使得实现接口的类或结构**在形式上保持一致**。

抽象类在某种程度上与接口类似，但是，它们大多只是用在当只有少数方法由基类声明由派生类实现时。

接口本身并不实现任何功能，它只是和声明实现该接口的对象订立一个必须实现哪些行为的契约。

### 定义
使用 **interface** 关键字声明，它与类的声明类似。接口声明默认是 public 的
```C#
using System;  
  
interface IMyInterface  
{  
 // 接口成员  
 void MethodToImplement();  
}  
```

以上代码定义了接口 `IMyInterface`。通常接口命令以 **I** 字母开头，这个接口只有一个方法 `MethodToImplement()`，没有参数和返回值，当然可以按照需求设置参数和返回值
```c#
class InterfaceImplementer : IMyInterface  
{  
 static void Main()  
 {  
 InterfaceImplementer iImp = new InterfaceImplementer();  
 iImp.MethodToImplement();  
 }  
  
 public void MethodToImplement()  
 {  
 Console.WriteLine("MethodToImplement() called.");  
 }  
}
```
`InterfaceImplementer` 类实现了 `IMyInterface` 接口，接口的实现与类的继承语法格式类似：

```C#
class InterfaceImplementer : IMyInterface
```

继承接口后，我们需要实现接口的方法 `MethodToImplement()` , 方法名必须与接口定义的方法名一致

### 继承

以下实例定义了两个接口 IMyInterface 和 IParentInterface。

如果一个接口继承其他接口，那么实现类或结构就需要实现所有接口的成员。

以下实例 IMyInterface 继承了 IParentInterface 接口，因此接口实现类必须实现 MethodToImplement() 和 ParentInterfaceMethod() 方法：

## 实例

以下实例定义了两个接口 IMyInterface 和 IParentInterface。

如果一个接口继承其他接口，那么实现类或结构就需要实现所有接口的成员。

以下实例 IMyInterface 继承了 IParentInterface 接口，因此接口实现类必须实现 MethodToImplement() 和 ParentInterfaceMethod() 方法：

```c#
using System;

interface IParentInterface
{
    void ParentInterfaceMethod();
}

interface IMyInterface : IParentInterface
{
    void MethodToImplement();
}

class InterfaceImplementer : IMyInterface
{
    static void Main()
    {
        InterfaceImplementer iImp = new InterfaceImplementer();
        iImp.MethodToImplement();
        iImp.ParentInterfaceMethod();
    }

    public void MethodToImplement()
    {
        Console.WriteLine("MethodToImplement() called.");
    }

    public void ParentInterfaceMethod()
    {
        Console.WriteLine("ParentInterfaceMethod() called.");
    }
}
```

实例输出结果为：

```C#
MethodToImplement() called.
ParentInterfaceMethod() called.
```

## 命名空间

命名空间的设计目的是提供一种让一组名称与其他名称分隔开的方式。

在一个命名空间中声明的类的名称与另一个命名空间中声明的相同的类的名称不冲突

## 定义

以关键字 **namespace** 开始，后跟命名空间的名称

```c#
namespace namespace_name
{
   // 代码声明
}
```

为了调用支持命名空间版本的函数或变量，会把命名空间的名称置于前面，如下所示：

```C#
namespace_name.item_name;
```

有例：

```c#
using System;
namespace first_space
{
   class namespace_cl
   {
      public void func()
      {
         Console.WriteLine("Inside first_space");
      }
   }
}
namespace second_space
{
   class namespace_cl
   {
      public void func()
      {
         Console.WriteLine("Inside second_space");
      }
   }
}  
class TestClass
{
   static void Main(string[] args)
   {
      first_space.namespace_cl fc = new first_space.namespace_cl();
      second_space.namespace_cl sc = new second_space.namespace_cl();
      fc.func();
      sc.func();
      Console.ReadKey();
   }
}
```

### using 关键字

**using** 关键字表明程序使用的是给定命名空间中的名称

```c#
using System;
using first_space;
using second_space;

namespace first_space
{
   class abc
   {
      public void func()
      {
         Console.WriteLine("Inside first_space");
      }
   }
}
namespace second_space
{
   class efg
   {
      public void func()
      {
         Console.WriteLine("Inside second_space");
      }
   }
}  
class TestClass
{
   static void Main(string[] args)
   {
      abc fc = new abc();
      efg sc = new efg();
      fc.func();
      sc.func();
      Console.ReadKey();
   }
}
```

#### 嵌套命名空间

命名空间可以被嵌套

```C#
namespace namespace_name1 
{
   // 代码声明
   namespace namespace_name2 
   {
     // 代码声明
   }
}
```

有例：

```C#
using System;
using SomeNameSpace;
using SomeNameSpace.Nested;

namespace SomeNameSpace
{
    public class MyClass
    {
        static void Main()
        {
            Console.WriteLine("In SomeNameSpace");
            Nested.NestedNameSpaceClass.SayHello();
        }
    }

    // 内嵌命名空间
    namespace Nested  
    {
        public class NestedNameSpaceClass
        {
            public static void SayHello()
            {
                Console.WriteLine("In Nested");
            }
        }
    }
}
```

#### 用处

**1. using指令：引入命名空间**

这是最常见的用法，例如：

```C#
using System;
using Namespace1.SubNameSpace;
```

**2. using static 指令：指定无需指定类型名称即可访问其静态成员的类型**

```C#
using static System.Math;var = PI; // 直接使用System.Math.PI
```

**3. 起别名**

```C#
using Project = PC.MyCompany.Project;
```

**4. using语句：将实例与代码绑定**

```C#
using (Font font3 = new Font("Arial", 10.0f),
            font4 = new Font("Arial", 10.0f))
{
    // Use font3 and font4.
}
```

代码段结束时，自动调用font3和font4的Dispose方法，释放实例。

## 预处理指令

预处理器指令指导编译器在实际编译开始之前对信息进行预处理

所有的预处理器指令都是以 # 开始。且在一行上，只有空白字符可以出现在预处理器指令之前。预处理器指令不是语句，所以它们不以分号 `;` 结束。

| 预处理器指令 | 描述                                                         |
| :----------- | :----------------------------------------------------------- |
| #define      | 用于定义一系列成为符号的字符。                               |
| #undef       | 用于取消定义符号。                                           |
| #if          | 用于测试符号是否为真。                                       |
| #else        | 用于创建复合条件指令，与 #if 一起使用。                      |
| #elif        | 用于创建复合条件指令。                                       |
| #endif       | 定一个条件指令的结束。                                       |
| #line        | 允许修改编译器的行数以及（可选地）输出错误和警告的文件名。   |
| #error       | 允许从代码的指定位置生成一个错误。                           |
| #warning     | 允许从代码的指定位置生成一级警告。                           |
| #region      | 允许在使用 Visual Studio Code Editor 的大纲特性时，指定一个可展开或折叠的代码块。 |
| #endregion   | 标识着 #region 块的结束。                                    |

### #define 指令

\#define 预处理器指令创建符号常量

```C#
#define symbol
```

有例：

```C#
#define PI
using System;
namespace PreprocessorDAppl
{
   class Program
   {
      static void Main(string[] args)
      {
         #if (PI)
            Console.WriteLine("PI is defined");
         #else
            Console.WriteLine("PI is not defined");
         #endif
         Console.ReadKey();
      }
   }
}
```

输出

```C#
PI is defined
```

### 条件指令

条件指令用于测试符号是否为真。如果为真，编译器会执行 #if 和下一个指令之间的代码

```c#
#if symbol [operator symbol]...
```

其中，*symbol* 是要测试的符号名称。也可以使用 true 和 false，或在符号前放置否定运算符。

常见运算符有：

- == (等于)
- != (不等于)
- && (与)
- || (或)

您也可以用括号把符号和运算符进行分组。条件指令用于在调试版本或编译指定配置时编译代码。一个以 **#if** 指令开始的条件指令，必须显示地以一个 **#endif** 指令终止。

```c#
#define DEBUG
#define VC_V10
using System;
public class TestClass
{
   public static void Main()
   {

      #if (DEBUG && !VC_V10)
         Console.WriteLine("DEBUG is defined");
      #elif (!DEBUG && VC_V10)
         Console.WriteLine("VC_V10 is defined");
      #elif (DEBUG && VC_V10)
         Console.WriteLine("DEBUG and VC_V10 are defined");
      #else
         Console.WriteLine("DEBUG and VC_V10 are not defined");
      #endif
      Console.ReadKey();
   }
}
```

输出

```c#
DEBUG and VC_V10 are defined
```

## 异常处理

关键词

- **try**：一个 try 块标识了一个将被激活的特定的异常的代码块。后跟一个或多个 catch 块。
- **catch**：程序通过异常处理程序捕获异常。catch 关键字表示异常的捕获。
- **finally**：finally 块用于执行给定的语句，不管异常是否被抛出都会执行。例如，如果您打开一个文件，不管是否出现异常文件都要被关闭。
- **throw**：当问题出现时，程序抛出一个异常。使用 throw 关键字来完成。

### 语法

可以列出多个 catch 语句捕获不同类型的异常，以防 try 块在不同的情况下生成多个异常

```c#
try
{
   // 引起异常的语句
}
catch( ExceptionName e1 )
{
   // 错误处理代码
}
catch( ExceptionName e2 )
{
   // 错误处理代码
}
catch( ExceptionName eN )
{
   // 错误处理代码
}
finally
{
   // 要执行的语句
}
```

### 异常类

C# 异常是使用类来表示的，他们主要是直接或间接地派生于 **System.Exception** 类

**System.ApplicationException** 和 **System.SystemException** 类是派生于 System.Exception 类的异常类。

- **System.ApplicationException** 类支持由应用程序生成的异常。所以程序员定义的异常都应派生自该类。

- **System.SystemException** 类是所有预定义的系统异常的基类。

    - | 异常类                            | 描述                                           |
        | :-------------------------------- | :--------------------------------------------- |
        | System.IO.IOException             | 处理 I/O 错误。                                |
        | System.IndexOutOfRangeException   | 处理当方法指向超出范围的数组索引时生成的错误。 |
        | System.ArrayTypeMismatchException | 处理当数组类型不匹配时生成的错误。             |
        | System.NullReferenceException     | 处理当依从一个空对象时生成的错误。             |
        | System.DivideByZeroException      | 处理当除以零时生成的错误。                     |
        | System.InvalidCastException       | 处理在类型转换期间生成的错误。                 |
        | System.OutOfMemoryException       | 处理空闲内存不足生成的错误。                   |
        | System.StackOverflowException     | 处理栈溢出生成的错误。                         |

有例：

```c#
using System;
namespace ErrorHandlingApplication
{
    class DivNumbers
    {
        int result;
        DivNumbers()
        {
            result = 0;
        }
        public void division(int num1, int num2)
        {
            try
            {
                result = num1 / num2;
            }
            catch (DivideByZeroException e)
            {
                Console.WriteLine("Exception caught: {0}", e);
            }
            finally
            {
                Console.WriteLine("Result: {0}", result);
            }

        }
        static void Main(string[] args)
        {
            DivNumbers d = new DivNumbers();
            d.division(25, 0);
            Console.ReadKey();
        }
    }
}
```

### 创建自定义异常

用户自定义的异常类是派生自 **ApplicationException** 类

```C#
using System;
namespace UserDefinedException
{
   class TestTemperature
   {
      static void Main(string[] args)
      {
         Temperature temp = new Temperature();
         try
         {
            temp.showTemp();
         }
         catch(TempIsZeroException e)
         {
            Console.WriteLine("TempIsZeroException: {0}", e.Message);
         }
         Console.ReadKey();
      }
   }
}
public class TempIsZeroException: ApplicationException
{
   public TempIsZeroException(string message): base(message)
   {
   }
}
public class Temperature
{
   int temperature = 0;
   public void showTemp()
   {
      if(temperature == 0)
      {
         throw (new TempIsZeroException("Zero Temperature found"));
      }
      else
      {
         Console.WriteLine("Temperature: {0}", temperature);
      }
   }
}
```

### 抛出对象

如果异常是直接或间接派生自 **System.Exception** 类，您可以抛出一个对象。

您可以在 catch 块中使用 throw 语句来抛出当前的对象

```C#
Catch(Exception e)
{
   // ...
   Throw e
}
```

