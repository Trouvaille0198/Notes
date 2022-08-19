---
title: "logging"
date: 2021-011-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# logging

## 认识

输出日志

### 导入

```python
import logging
```

### 初始化

#### 级别排序

**CRITICAL > ERROR > WARNING > INFO > DEBUG**

| 级别       | 何时使用                                                           |
| :--------- | :----------------------------------------------------------------- |
| `DEBUG`    | 细节信息，仅当诊断问题时适用。                                     |
| `INFO`     | 确认程序按预期运行                                                 |
| `WARNING`  | 表明有已经或即将发生的意外（例如：磁盘空间不足）。程序仍按预期进行 |
| `ERROR`    | 由于严重的问题，程序的某些功能已经不能正常执行                     |
| `CRITICAL` | 严重的错误，表明程序已不能继续执行                                 |

#### 创建实例

使用模块级记录器

`Logger` 是一个记录器类

```python
logger = logging.getLogger(__name__)
```

这意味着记录器名称跟踪包或模块的层次结构，并且直观地从记录器名称显示记录事件的位置。

## 配置

### 全局配置 ***basicConfig()***

默认情况下，没有为任何日志记录消息设置目标。 你可以使用 `basicConfig()` 指定目标

通过使用默认的 `Formatter` 创建一个 `StreamHandler` 并将其加入根日志记录器来为日志记录系统执行基本配置。 如果没有为根日志记录器定义处理程序则 debug(), info(), warning(), error() 和 critical() 等函数将自动调用 basicConfig()

**参数**

- *filename*：指定日志文件名
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

### 对实例的配置

对记录器类进行配置，实际上都是 `Logger` 类的成员函数
```python
import logging

# create logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# create formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# add formatter to ch
ch.setFormatter(formatter)

# add ch to logger
logger.addHandler(ch)

# 'application' code
logger.debug('debug message')
logger.info('info message')
logger.warning('warn message')
logger.error('error message')
logger.critical('critical message')
```


- ***setLevel(level)***

    设置记录器级别，高于 level 会被输出

    - *level*：级别，默认为 `logging.WARNING`

    | 级别       | 数值 |
    | :--------- | :--- |
    | `CRITICAL` | 50   |
    | `ERROR`    | 40   |
    | `WARNING`  | 30   |
    | `INFO`     | 20   |
    | `DEBUG`    | 10   |
    | `NOTSET`   | 0    |

- ***addHandler(hdlr)***

    将指定的处理器 hdlr 添加到此记录器

- ***removeHandler(hdlr)***

    移除指定处理器

- ***addFilter(filter)***

    将指定的过滤器 *filter* 添加到此记录器

- ***removeFilter(filter)***

    移除指定过滤器

### 调用外部配置文件 ***fileConfig()***

```python
import logging
import logging.config

logging.config.fileConfig('logging.conf')

# create logger
logger = logging.getLogger(__name__)

# 'application' code
logger.debug('debug message')
logger.info('info message')
logger.warning('warn message')
logger.error('error message')
logger.critical('critical message')
```

配置文件例 (.conf)

```conf
[loggers]
keys=root,simpleExample

[handlers]
keys=consoleHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=DEBUG
handlers=consoleHandler

[logger_simpleExample]
level=DEBUG
handlers=consoleHandler
qualname=simpleExample
propagate=0

[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)

[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt=
```

或使用 YAML 格式

```yaml
version: 1
formatters:
  simple:
    format: '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
handlers:
  console:
    class: logging.StreamHandler
    level: DEBUG
    formatter: simple
    stream: ext://sys.stdout
loggers:
  simpleExample:
    level: DEBUG
    handlers: [console]
    propagate: no
root:
  level: DEBUG
  handlers: [console]
```

也可以使用 json 格式

```python
{
    "version":1,
    "disable_existing_loggers":false,
    "formatters":{
        "simple":{
            "format":"%(asctime)s - %(name)s - %(levelname)s - %(message)s"
        }
    },
    "handlers":{
        "console":{
            "class":"logging.StreamHandler",
            "level":"DEBUG",
            "formatter":"simple",
            "stream":"ext://sys.stdout"
        },
        "info_file_handler":{
            "class":"logging.handlers.RotatingFileHandler",
            "level":"INFO",
            "formatter":"simple",
            "filename":"info.log",
            "maxBytes":"10485760",
            "backupCount":20,
            "encoding":"utf8"
        },
        "error_file_handler":{
            "class":"logging.handlers.RotatingFileHandler",
            "level":"ERROR",
            "formatter":"simple",
            "filename":"errors.log",
            "maxBytes":10485760,
            "backupCount":20,
            "encoding":"utf8"
        }
    },
    "loggers":{
        "my_module":{
            "level":"ERROR",
            "handlers":["info_file_handler"],
            "propagate":"no"
        }
    },
    "root":{
        "level":"INFO",
        "handlers":["console","info_file_handler","error_file_handler"]
    }
}
```

传入到程序中

```python
import json
import logging.config
import os
 
def setup_logging(default_path = "logging.json",default_level = logging.INFO,env_key = "LOG_CFG"):
    path = default_path
    value = os.getenv(env_key,None)
    if value:
        path = value
    if os.path.exists(path):
        with open(path,"r") as f:
            config = json.load(f)
            logging.config.dictConfig(config)
    else:
        logging.basicConfig(level = default_level)
 
def func():
    logging.info("start func")
 
    logging.info("exec func")
 
    logging.info("end func")
 
if __name__ == "__main__":
    setup_logging(default_path = "logging.json")
    func()
```

实际上将 json 格式转化为字典，借用了字典的配置

### 字典配置 ***dictConfig()***

## 处理器 Handler

`Handler` 对象负责将适当的日志消息（基于日志消息的严重性）分派给处理程序的指定目标

### API

- ***setLevel(level)***

    为处理器设置等级

- ***setFormatter(fmt)***

- ***addFilter(filter)***

    将指定的过滤器 *filter* 添加到处理器

- ***removeFilter(filter)***

    移除指定过滤器

### FileHandler

要将日志打印到文件中，使用 `basicConfig` 中的 `filename` 参数指定日志文件

更建议使用 `FileHandler` 实现

生成实例时，传入日志文件名即可

```python
import logging
logger = logging.getLogger(__name__)
logger.setLevel(level = logging.INFO)

handler = logging.FileHandler("log.txt")
handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

logger.addHandler(handler)
```

### StreamHandler

默认的 `basicConfig` 配置即支持打印日志

但更建议使用 `StreamHandler` 实现

以下例为**同时输出到控制台与文件**

```python
import logging
logger = logging.getLogger(__name__)
logger.setLevel(level = logging.INFO)

fileHdlr = logging.FileHandler("log.txt")
fileHdlr.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fileHdlr.setFormatter(formatter)
 
consoleHdlr = logging.StreamHandler()
consoleHdlr.setLevel(logging.INFO)
 
logger.addHandler(fileHdlr)
logger.addHandler(consoleHdlr)
```

## 过滤器 Filter

格式化程序对象配置日志消息的最终顺序、结构和内容

其构造函数有三个可选参数 —— 消息格式字符串、日期格式字符串和样式指示符

```python
logging.Formatter.__init__(fmt=None, datefmt=None, style='%')
```

参数形式与 `basicConfig` 中的 foramt 参数相同

```python
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
```

## 样本

```python
import logging
import sys
from os import makedirs
from os.path import dirname, exists

from cmreslogging.handlers import CMRESHandler

loggers = {}

LOG_ENABLED = True  # 是否开启日志
LOG_TO_CONSOLE = True  # 是否输出到控制台
LOG_TO_FILE = True  # 是否输出到文件
LOG_TO_ES = True  # 是否输出到 Elasticsearch

LOG_PATH = './runtime.log'  # 日志文件路径
LOG_LEVEL = 'DEBUG'  # 日志级别
LOG_FORMAT = '%(levelname)s - %(asctime)s - process: %(process)d - %(filename)s - %(name)s - %(lineno)d - %(module)s - %(message)s'  # 每条日志输出格式
ELASTIC_SEARCH_HOST = 'eshost'  # Elasticsearch Host
ELASTIC_SEARCH_PORT = 9200  # Elasticsearch Port
ELASTIC_SEARCH_INDEX = 'runtime'  # Elasticsearch Index Name
APP_ENVIRONMENT = 'dev'  # 运行环境，如测试环境还是生产环境

def get_logger(name=None):
    """
    get logger by name
    :param name: name of logger
    :return: logger
    """
    global loggers

    if not name: name = __name__

    if loggers.get(name):
        return loggers.get(name)

    logger = logging.getLogger(name)
    logger.setLevel(LOG_LEVEL)

    # 输出到控制台
    if LOG_ENABLED and LOG_TO_CONSOLE:
        stream_handler = logging.StreamHandler(sys.stdout)
        stream_handler.setLevel(level=LOG_LEVEL)
        formatter = logging.Formatter(LOG_FORMAT)
        stream_handler.setFormatter(formatter)
        logger.addHandler(stream_handler)

    # 输出到文件
    if LOG_ENABLED and LOG_TO_FILE:
        # 如果路径不存在，创建日志文件文件夹
        log_dir = dirname(log_path)
        if not exists(log_dir): makedirs(log_dir)
        # 添加 FileHandler
        file_handler = logging.FileHandler(log_path, encoding='utf-8')
        file_handler.setLevel(level=LOG_LEVEL)
        formatter = logging.Formatter(LOG_FORMAT)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    # 输出到 Elasticsearch
    if LOG_ENABLED and LOG_TO_ES:
        # 添加 CMRESHandler
        es_handler = CMRESHandler(hosts=[{'host': ELASTIC_SEARCH_HOST, 'port': ELASTIC_SEARCH_PORT}],
                                  # 可以配置对应的认证权限
                                  auth_type=CMRESHandler.AuthType.NO_AUTH,  
                                  es_index_name=ELASTIC_SEARCH_INDEX,
                                  # 一个月分一个 Index
                                  index_name_frequency=CMRESHandler.IndexNameFrequency.MONTHLY,
                                  # 额外增加环境标识
                                  es_additional_fields={'environment': APP_ENVIRONMENT}  
                                  )
        es_handler.setLevel(level=LOG_LEVEL)
        formatter = logging.Formatter(LOG_FORMAT)
        es_handler.setFormatter(formatter)
        logger.addHandler(es_handler)

    # 保存到全局 loggers
    loggers[name] = logger
    return logger
```

使用时，调用定义的方法获取一个 logger，然后 log 对应的内容即可

```python
logger = get_logger()
logger.debug('this is a message')
```

简单的配置方式

```python
import logging
logging.basicConfig(level = logging.INFO,format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)
```



