# 一、概念

```python
import time
```

- **时间戳：**格林威治时间1970年01月01日00分00秒（北京时间1970年01月01日08时00分00秒）起至现在的总秒数，是个数字。
- Python中获取时间的常用方法是，先得到时间戳，再将其转换成想要的时间格式。
- **元组struct_time：**日期、时间是包含许多变量的，所以在Python中定义了一个元组struct_time将所有这些变量组合在一起，包括：年、月、日、小时、分钟、秒等。

# 二、**时间获取函数**

## 2.1 time()

获取当前时间戳，返回浮点数

```python
time.time()

<<
	1610015368.4228694
```

## 2.2 ctime()

获取当前时间并以易读方式表示，返回字符串

```python
time.ctime()

<<
	'Thu Jan  7 18:30:37 2021'
```

## 2.3 gmtime()

获取当前时间并以计算机可处理的格式表示，返回元组struct_time

```python
time.gmtime()

<<
	time.struct_time(tm_year=2021, tm_mon=1, tm_mday=7, tm_hour=10, tm_min=32, tm_sec=36, tm_wday=3, tm_yday=7, tm_isdst=0)
```

## 2.4 .mktime()

把时间元组，转换为秒

```python
time.mktime(time.gmtime()) 
<<
	1609986979.0
```

## 2.5 .asctime()

 把时间元组，转换为易读形式

```python
time.asctime(time.gmtime()) 

<<
	'Thu Jan  7 10:36:57 2021'
```

# 二、时间格式化

## 2.1 .strftime(tpl, ts) 

- *tpl*：时间格式化模板字符串，用来定义输出效果

| 形式 | 解释              |
| ---- | ----------------- |
| %Y   | 年份              |
| %m   | 月份              |
| %B   | 月份名称 January  |
| %b   | 月份名称缩写  Jan |
| %d   | 日期              |
| %A   | 星期 Monday       |
| %a   | 星期缩写 Mon      |
| %H   | 小时 24           |
| %h   | 小时 12           |
| %p   | 上下午            |
| %M   | 分钟              |
| %S   | 秒                |

- *ts*：是计算机内部时间类型变量。

```python
t=time.gmtime()
time.strftime("%Y-%m-%d %H:%M:%S", t)
<<
	'2021-01-07 10:40:34'
    
time.strftime("%Y-%B-%d-%A-%H-%p-%S")
<<
	'2021-January-07-Thursday-18-PM-57'

time.strftime("%A-%p")
<<
	'Thursday-PM'

time.strftime("%M:%S")
<<
    '48:37'
```

如果strftime没有第二个参数，则默认获取当前时间

## 2.2 .strptime(timestr, tpl)

根据时间字符串以及格式化输出，转换成结构体。

- *timestr*：时间字符串

- *tpl*：时间格式化模板字符串，用来定义输出效果

```python
timestr = '2018-01-26 12:55:33'
time.strptime(timestr, "%Y-%m-%d %H:%M:%S")
<<
	time.struct_time(tm_year=2018, tm_mon=1, tm_mday=26, tm_hour=12, tm_min=55, tm_sec=33, tm_wday=4, tm_yday=26, tm_isdst=-1)
```

# 三、程序计时

## 3.1 .perf_counter()

测量时间，返回一个CPU级别的精确时间计数值，单位为秒

由于这个计数值起点不确定，连续调用差值才有意义

```python
start = time.perf_counter 	()
end = time.perf_counter()
end - start

<<
	4.5900000259280205e-05
```

## 3.2 .sleep(s)

产生时间，s为单位为秒的休眠时间，可以是浮点数，如`time.sleep(3.5)`

```python
time.sleep(10)
```

# 四、例

## 4.1 秒数化为时间元组

```python
second_a = 1610524866.1898422
struct_a = time.localtime(second_a)

time.asctime(struct_a)
<<
	'Wed Jan 13 16:01:06 2021'
 
time.strftime("%Y-%m-%d %H:%M:%S", struct_a)
<<
	'2021-01-13 16:01:06'
```

