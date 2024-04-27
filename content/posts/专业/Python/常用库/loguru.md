---
title: "loguru"
date: 2021-04-17
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# loguru

比 logging 更加轻便简单的日志记录器

## 基本使用

```python
from loguru import logger
import os
import time

LOG_FOLDER = os.getcwd()+'\\logs'
if not os.path.exists(LOG_FOLDER):
    os.mkdir(LOG_FOLDER)
    t = time.strftime("%Y_%m_%d")
    logger = logger
    logger.add("{}\\log_{}.log".format(LOG_FOLDER, t),
               rotation="00:00", encoding="utf-8", retention="300 days")

```

