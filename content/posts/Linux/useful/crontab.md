---
title: "crontab"
date: 2021-10-23
author: MelonCholi
draft: false
tags: [Linux,快速入门]
categories: [Linux]
---



# crontab

```shell
crontab -e
```

## 时间语法

```text
# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed 
```
