---
title: Gerrit
date: 2023-8-3
draft: false
author: MelonCholi
tags:
  - 快速入门
  - 版本管理
  - CS
categories:
  - 工具
aliases:
  - Gerrit
date created: 24-04-10 09:58
date modified: 24-04-10 16:56
---

# Gerrit

Gerrit 是建立在 Git 版本控制系统之上并且基于 Web 的一个免费开源的轻量级代码审查工具。

作为开发者和 Git 之间的一层屏障，不允许直接将本地修改内容同步到远程仓库中。

与 Jenkins 集成后，可以在每次提交代码后，人工审核代码前，通过 Jenkins 任务自动运行单元测试、构建以及自动化测试，如果 Jenkins 任务失败，会自动打回本次提交。

一般 Git、Gerrit 和 Jenkins 集成后的使用流程

1. 开发者提交代码到 Gerrit
2. 触发对应的 Jenkins 任务，通过以后 Verified 加 1
3. 人工审核，审核通过后 code review 加 2，触发对应的 Jenkins 任务
4. 通过以后确认本次提交，Gerrit 执行与 Git 仓库的代码同步操作
5. 代码进入 Git 仓库

<img src="https://pic1.zhimg.com/80/40789f16211f2aa28b3fe5491dc8ce04_1440w.webp" alt="img" style="zoom:50%;" />
