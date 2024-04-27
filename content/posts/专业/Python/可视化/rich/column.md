---
title: "Python rich 库 - Column"
date: 2022-12-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Column

Rich 可以通过 `Columns` 类在整齐的列中渲染文本或其他 Rich 渲染物。

To use, construct a Columns instance with an iterable of renderables and print it to the Console.

The following example is a very basic clone of the `ls` command in OSX / Linux to list directory contents:

```py
import os
import sys

from rich import print
from rich.columns import Columns

if len(sys.argv) < 2:
    print("Usage: python columns.py DIRECTORY")
else:
    directory = os.listdir(sys.argv[1])
    columns = Columns(directory, equal=True, expand=True)
    print(columns)
```

See [columns.py](https://github.com/willmcgugan/rich/blob/master/examples/columns.py) for an example which outputs columns containing more than just text.