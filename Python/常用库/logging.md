# 一、认识

输出日志

## 1.1 导入

```python
import logging
```

## 1.2 初始化

### 1.1.1 级别排序

**CRITICAL > ERROR > WARNING > INFO > DEBUG**

| 级别       | 何时使用                                                     |
| :--------- | :----------------------------------------------------------- |
| `DEBUG`    | 细节信息，仅当诊断问题时适用。                               |
| `INFO`     | 确认程序按预期运行                                           |
| `WARNING`  | 表明有已经或即将发生的意外（例如：磁盘空间不足）。程序仍按预期进行 |
| `ERROR`    | 由于严重的问题，程序的某些功能已经不能正常执行               |
| `CRITICAL` | 严重的错误，表明程序已不能继续执行                           |

### 1.1.2 创建实例

使用模块级记录器

```python
logger = logging.getLogger(__name__)
```

这意味着记录器名称跟踪包或模块的层次结构，并且直观地从记录器名称显示记录事件的位置。

### 1.1.3 配置

#### 1）***logging.basicConfig()***

**参数**

- *filename*：指定日志文件名，
- *filemode*：指定日志文件的打开模式，'w' 或者 'a'，默认为 'a'
- *format*：指定输出的格式和内容

| 参数           | 作用                                    |
| :------------- | --------------------------------------- |
| %(levelno)s    | 日志级别的数值                          |
| %(levelname)s  | 日志级别的名称                          |
| %(pathname)s   | 当前执行程序的路径，其实就是sys.argv[0] |
| %(filename)s   | 当前执行程序名                          |
| %(funcName)s   | 当前函数                                |
| %(lineno)d     | 当前行号                                |
| %(asctime)s    | 时间                                    |
| %(thread)d     | 线程 ID                                 |
| %(threadName)s | 线程名称                                |
| %(process)d    | 进程 ID                                 |
| %(message)s    | 日志信息                                |

- *datefmt*：指定时间格式，同 time.strftime()
- *level*：设置日志级别，默认为 logging.WARNNING
- *stream*：指定将日志的输出流，可以指定输出到 sys.stderr，sys.stdout 或者文件，默认输出到 sys.stderr，与 filename 不兼容

**例**

```python
import logging
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

logger.info("Start print log")
logger.debug("Do something")
logger.warning("Something maybe fail.")
logger.info("Finish")
```

输出

```shell
2021-04-27 11:23:53,973 - INFO - Start print log
2021-04-27 11:23:53,973 - DEBUG - Do something
2021-04-27 11:23:53,973 - WARNING - Something maybe fail.
2021-04-27 11:23:53,973 - INFO - Finish
```

对 [`basicConfig()`](https://docs.python.org/zh-cn/3/library/logging.html#logging.basicConfig) 的调用应该在 [`debug()`](https://docs.python.org/zh-cn/3/library/logging.html#logging.debug) ， [`info()`](https://docs.python.org/zh-cn/3/library/logging.html#logging.info) 等的前面。因为它被设计为一次性的配置，只有第一次调用会进行操作，随后的调用不会产生有效操作。