---
title: "Gerrit"
date: 2023-8-3
draft: false
author: "MelonCholi"
tags: [快速入门]
categories: [工具]
---

# Gerrit

Gerrit 是建立在Git版本控制系统之上并且基于Web的一个免费开源的轻量级代码审查工具。

作为开发者和Git之间的一层屏障，不允许直接将本地修改内容同步到远程仓库中。

与Jenkins集成后，可以在每次提交代码后，人工审核代码前，通过Jenkins任务自动运行单元测试、构建以及自动化测试，如果Jenkins任务失败，会自动打回本次提交。

一般Git、Gerrit和Jenkins集成后的使用流程

1. 开发者提交代码到Gerrit
2. 触发对应的Jenkins任务，通过以后Verified加1
3. 人工审核，审核通过后code review加2，触发对应的Jenkins任务
4. 通过以后确认本次提交，Gerrit执行与Git仓库的代码同步操作
5. 代码进入Git仓库

<img src="https://pic1.zhimg.com/80/40789f16211f2aa28b3fe5491dc8ce04_1440w.webp" alt="img" style="zoom:50%;" />