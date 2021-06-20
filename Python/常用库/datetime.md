# 认识

## 类

| 类名          | 功能说明                                                    |
| ------------- | ----------------------------------------------------------- |
| date          | 日期对象,常用的属性有 year, month, day                      |
| time          | 时间对象                                                    |
| datetime      | 日期时间对象,常用的属性有 hour, minute, second, microsecond |
| datetime_CAPI | 日期时间对象 C 语言接口                                     |
| timedelta     | 时间间隔，即两个时间点之间的长度                            |
| tzinfo        | 时区信息对象                                                |

## 常量

| 常量    | 功能说明             | 用法             | 返回值 |
| ------- | -------------------- | ---------------- | ------ |
| MAXYEAR | 返回能表示的最大年份 | datetime.MAXYEAR | 9999   |
| MINYEAR | 返回能表示的最小年份 | datetime.MINYEAR | 1      |

# date

***date（year，month，day)***

```python
>>> a = datetime.date.today()
>>> a
datetime.date(2021, 5, 11)
>>> a.year
2021
>>> a.month
5
>>> a.day
11 
```

可以进行大小比较，加减运算

```python
a = datetime.date.today()
b = datetime.date(2021,4,5)

print(a-b)
print(a<b)
# days, 0:00:00
# False
```

## 方法

- ***.isoformat()***
    - 返回 ISO 格式字符串

- ***.isocalendar()***
    - 返回 ISO 格式元组
    
- ***.isoweekday***
    - 返回所在的星期数，周一为1…周日为7
    
- ***.timetuple()***
    - 该方法为了兼容 `time.localtime(...)`
    - 返回一个类型为 `time.struct_time` 的数组，但有关时间的部分元素值为 0
    
- ***.toordinal()***
    - 返回公元公历开始到现在的天数。公元 1 年 1 月 1 日为 1

- ***.fromtimestamp(time_float)***

    - 根据给定的时间戮，返回一个 date 对象

    ```python
    datetime.date.fromtimestamp(time.time())
    ```

- ***.today()***

    - 返回当前日期

- ***.strftime(format)***

    - 将日期对象转化为字符串对象

    ```python
    a.strftime("%Y%m%d")
    ```

# time

***time([hour[, minute[, second[, microsecond[, tzinfo]]]]])***

方法与 `date` 类似

# datetime

`datetime` 类其实是可以看做是 `date` 类和 `time` 类的合体，其大部分的方法和属性都继承于这二个类

***datetime(year, month, day[, hour[, minute[, second[, microsecond[,tzinfo]]]]])***

```python
a = datetime.datetime.now()
print(a)
# 2021-05-11 11:35:00.048964
```

## 专属属性

- ***.date()***
    - 返回日期部分
- ***.time()***
    - 返回时间部分
- ***.utctimetuple()***
    - 返回 UTC 时间元组
    - 例：`time.struct_time(tm_year=2021, tm_mon=5, tm_mday=11, tm_hour=11, tm_min=35, tm_sec=0, tm_wday=1, tm_yday=131, tm_isdst=0)`
- ***.combine(date,time)***
    - 将一个 date 对象和一个 time 对象合并生成一个 datetime 对象
- ***.now()***
    - 返回当前日期时间的 datetime 对象