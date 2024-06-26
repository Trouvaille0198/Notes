---
title: "Java 基础语法"
date: 2021-10-23
author: MelonCholi
draft: true
tags: [Java]
categories: [Java]
---

# 程序基础

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/662E827A-FA32-4464-B0BD-40087F429E98.jpg" alt="img" style="zoom:77%;" />

## 程序基本结构

```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, world!");
    }
}
```

1. 因为 Java 是面向对象的语言，一个程序的基本单位就是 `class`，`class` 是关键字。
2. 注意到 `public` 是访问修饰符，表示该 `class` 是公开的。不写 `public`，也能正确编译，但是这个类将无法从命令行执行。
3. 在 `class` 内部，可以定义若干方法（method）
4. 关键字 `static` 是另一个修饰符，它表示静态方法
5. Java 规定，某个类定义的 `public static void main(String[] args)` 是 Java 程序的固定入口方法，因此，Java 程序总是从 `main` 方法开始执行。

## 数据类型

基本数据类型是 CPU 可以直接进行运算的类型。Java 定义了以下几种基本数据类型：

- 整数类型：byte，short，int，long
- 浮点数类型：float，double
- 字符类型：char
- 布尔类型：boolean

### 整型 

- byte：-128 ~ 127
- short: -32768 ~ 32767
- int: -2147483648 ~ 2147483647
- long: -9223372036854775808 ~ 9223372036854775807

```java
public class Main {
    public static void main(String[] args) {
        int i = 2147483647;
        int i2 = -2147483648;
        int i3 = 2_000_000_000; // 加下划线更容易识别
        int i4 = 0xff0000; // 十六进制表示的16711680
        int i5 = 0b1000000000; // 二进制表示的512
        long l = 9000000000000000000L; // long型的结尾需要加L
    }
}
```

### 浮点型

浮点类型的数就是小数

```java
float f1 = 3.14f;
float f2 = 3.14e38f; // 科学计数法表示的3.14x10^38
double d = 1.79e308;
double d2 = -1.79e308;
double d3 = 4.9e-324; // 科学计数法表示的4.9x10^-324
```

对于 `float` 类型，需要加上 `f` 后缀

### 布尔类型

布尔类型 `boolean` 只有 `true` 和 `false` 两个值，布尔类型总是关系运算的计算结果

```java
boolean b1 = true;
boolean b2 = false;
boolean isGreater = 5 > 3; // 计算结果为true
int age = 12;
boolean isAdult = age >= 18; // 计算结果为false
```

### 字符类型

Java 的 `char` 类型除了可表示标准的 ASCII 外，还可以表示一个 Unicode 字符

```Java
char a = 'A';
char zh = '中';
```

### 引用类型

除了上述基本类型的变量，剩下的都是引用类型

引用类型的变量类似于 C 语言的指针，它内部存储一个“地址”，指向某个对象在内存的位置

### 常量

定义变量的时候，如果加上 `final` 修饰符，这个变量就变成了常量：

```java
final double PI = 3.14; // PI是一个常量
double r = 5.0;
double area = PI * r * r;
PI = 300; // compile error!
```

作用：用有意义的变量名来避免魔术数字（Magic number），例如，不要在代码中到处写 `3.14`，而是定义一个常量。如果将来需要提高计算精度，我们只需要在常量的定义处修改。

根据习惯，常量名通常全部大写。

### var 关键字

如果想省略变量类型，可以使用 `var`关键字，编译器会根据赋值语句自动推断出变量类型

```java
StringBuilder sb = new StringBuilder();
// is euqal to
var sb = new StringBuilder();
```

## 运算

### 移位运算

在计算机中，整数总是以二进制的形式表示。例如，`int` 类型的整数 `7` 使用 4 字节表示的二进制如下：

```ascii
00000000 0000000 0000000 00000111
```

左移实际上就是不断地 ×2，右移实际上就是不断地 ÷2

#### 左移 <<

可以对整数进行移位运算。对整数 `7` 左移 1 位将得到整数 `14`，左移两位将得到整数 `28`：

```java
int n = 7;       // 00000000 00000000 00000000 00000111 = 7
int a = n << 1;  // 00000000 00000000 00000000 00001110 = 14
int b = n << 2;  // 00000000 00000000 00000000 00011100 = 28
int c = n << 28; // 01110000 00000000 00000000 00000000 = 1879048192
int d = n << 29; // 11100000 00000000 00000000 00000000 = -536870912
```

左移 29 位时，由于最高位变成 `1`，因此结果变成了负数。

#### 右移 >> 

类似的，对整数 28 进行右移，结果如下：

```java
int n = 7;       // 00000000 00000000 00000000 00000111 = 7
int a = n >> 1;  // 00000000 00000000 00000000 00000011 = 3
int b = n >> 2;  // 00000000 00000000 00000000 00000001 = 1
int c = n >> 3;  // 00000000 00000000 00000000 00000000 = 0
```

如果对一个负数进行右移，最高位的  `1`  不动，结果仍然是一个负数：

```java
int n = -536870912;
int a = n >> 1;  // 11110000 00000000 00000000 00000000 = -268435456
int b = n >> 2;  // 11111000 00000000 00000000 00000000 = -134217728
int c = n >> 28; // 11111111 11111111 11111111 11111110 = -2
int d = n >> 29; // 11111111 11111111 11111111 11111111 = -1
```

#### 无符号右移 >>>

还有一种无符号的右移运算，使用 `>>>`，它的特点是不管符号位，右移后高位总是补`0`，因此，对一个负数进行`>>>`右移，它会变成正数，原因是最高位的`1`变成了`0`：

```java
int n = -536870912;
int a = n >>> 1;  // 01110000 00000000 00000000 00000000 = 1879048192
int b = n >>> 2;  // 00111000 00000000 00000000 00000000 = 939524096
int c = n >>> 29; // 00000000 00000000 00000000 00000111 = 7
int d = n >>> 31; // 00000000 00000000 00000000 00000001 = 1
```

对 `byte` 和 `short` 类型进行移位时，会首先转换为 `int` 再进行位移。

