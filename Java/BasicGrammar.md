# 一、程序基础

<img src="http://image.trouvaille0198.top/662E827A-FA32-4464-B0BD-40087F429E98.jpg" alt="img" style="zoom:77%;" />

## 1.1 程序基本结构

```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, world!");
    }
}
```

1. 因为 Java 是面向对象的语言，一个程序的基本单位就是 `class`，`class` 是关键字。
2. 注意到 `public` 是访问修饰符，表示该 `class` 是公开的。不写 `public`，也能正确编译，但是这个类将无法从命令行执行。
3. 在`class`内部，可以定义若干方法（method）
4. 关键字`static`是另一个修饰符，它表示静态方法
5. Java 规定，某个类定义的 `public static void main(String[] args)` 是 Java 程序的固定入口方法，因此，Java 程序总是从 `main` 方法开始执行。

## 1.2 数据类型

基本数据类型是 CPU 可以直接进行运算的类型。Java 定义了以下几种基本数据类型：

- 整数类型：byte，short，int，long
- 浮点数类型：float，double
- 字符类型：char
- 布尔类型：boolean

### 1.2.1 整型 

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

### 1.2.2 浮点型

浮点类型的数就是小数

```java
float f1 = 3.14f;
float f2 = 3.14e38f; // 科学计数法表示的3.14x10^38
double d = 1.79e308;
double d2 = -1.79e308;
double d3 = 4.9e-324; // 科学计数法表示的4.9x10^-324
```

对于 `float` 类型，需要加上 `f` 后缀

### 1.2.3 布尔类型

布尔类型 `boolean `只有 `true` 和 `false` 两个值，布尔类型总是关系运算的计算结果

```java
boolean b1 = true;
boolean b2 = false;
boolean isGreater = 5 > 3; // 计算结果为true
int age = 12;
boolean isAdult = age >= 18; // 计算结果为false
```

