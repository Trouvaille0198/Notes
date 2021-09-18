# Petit-FM

## 简述

一个前后端分离的足球模拟经营游戏

扮演足球俱乐部的一名教练，按照自己的想法管理一切事物：训练麾下球员，培养青年才俊，与 AI 对手进行比赛，争夺冠军，带领俱乐部走向辉煌

### 核心玩法

- 自由选择俱乐部，体验一段独一无二的足球教练之旅
- **以文字与数据形式呈现比赛**，随时进行换人操作
- 建立适合球员的战术体系，在球场上运筹帷幄
- **回合制推进**，允许随时暂停和继续
- 培养青年才俊，打造球队未来之星，或是赚个盆满钵满
- 在转会市场大展身手，将心仪的球员收入麾下
- 真实的联赛与杯赛，同时可以自定义专属于你的特别赛制

### 项目特点

- 前后端分离，基于 Vue 和 FastAPI（Python）以及相关技术开发
- Vue3 配合 TypeScript 进行前端开发，可维护，规范性、复用性强
    - 使用 Vue3 新特性，体积更小、速度更快，加强对 TS 的支持
    - TS 提供数据类型检查功能，使代码可读、易维护
    - 采用 Vuex 管理组件的共享状态
    - 使用 Vue Router 构建网页路由，使用 axios 编写网络请求
- 使用 Naive UI 构建页面
    - 响应式布局
    - 多端页面自适应
    - 通过 treeshaking 打包优化，减小程序体积
- 使用 FastAPI 异步框架构建 API
    - 使用对象关系映射（ORM）模型完成面向对象编程语言与关系型数据库的衔接，数据库可自由更换
    - 自动生成标准化的交互性文档

#### 分工

- 前端：页面设计，向后端发送请求
- 后端：接收、处理前端请求，与数据库进行交互
- 核心：游戏核心的代码逻辑，暴露接口 (API) 供后端调用

#### 主要技术栈

- 前端
    - 语言：JavaScript（Typescript）
    - 前端框架：Vue（Vuex, axios, Vue Router），使用 vue-cli 进行项目架构 
    - UI 框架：Naive UI（或 Vuetify）

- 后端
    - 语言：Python
    - 后端框架：FastAPI
    - 数据库：Sqlite 或 MySQL

- 游戏核心逻辑
    - 语言：Python
    - 数据库：sqlalchemy（ORM 模型）

## 游戏介绍

### 比赛

比赛是本游戏的核心玩法，球队的一切荣誉围绕比赛展开。

#### 呈现方式

比赛以文字解说和数据分析的方式呈现，大到场上的正在发生的事件、伤病情况、每个球员的运动数据，小道教练的场边喊话，温度与天气，同时进行的其他比赛的实时比分，都可以一览无余。

#### 比赛模拟系统

我们从真实的足球比赛中汲取灵感，并且简化作战方式，打造了一套独特的比赛模拟系统

- 将教练布置的战术抽象为形形色色的进攻战术
- 将球员在球场上的每一次动作抽象为数值的判定与对抗
- 在本游戏中，比赛的胜负与多方面息息相关，天气、主客场、偶然而神奇的突发事件都可以对比赛的结局产生影响；当然，教练的战术计划以及球员的个人能力是左右比赛的两个最重要因素

##### 数值对抗

要判断这次射门、过人、传中成功与否，依靠进攻球员与防守球员对应能力的对抗结果

比如，将中锋的射门属性与守门员的防守属性进行一次概率上的计算，即可得出结果；同样的，边路的过人、接应球员的争顶，也用类似的机制进行判定。

比赛中，数值对抗还受到球员体能、天气、主客场等等因素的影响

##### 进攻战术

进攻战术是真实比赛战术的简化体现，主要分为中路进攻与边路进攻

本质上，进攻战术就是球员之间**数值对抗的组合**

进攻战术有以下几种

- 下底传中（wing cross）

- 内切（under_cutting）

- 倒三角（pull back）

- 中路渗透（middle attack）

- 防守反击（counter attack）

##### 进攻机会

比赛会制造一定数量的进攻机会（比如 50 次），球队根据预先制定的战术安排，执行特定的进攻战术。

一旦在战术执行过程中丢失球权，即停止进攻，在下一次进攻机会开始时交换球权。

达到进攻机会（50 次）上限，即停止比赛

#### 阵容

如何找到恰当的阵容是一门复杂深奥的学问

游戏允许你自由地排兵布阵，同时为你提供一些标准的阵型模板

#### 联赛与杯赛

你可以自由的选择联赛与杯赛系统进行游玩。既有严格遵循现实的五大联赛系统，也可以在世界超级联赛中体验局局都是豪门对决的精彩。

#### 评级

#### 换人

### 球员

球员整个游戏最核心的角色。

#### 基本数据

年龄、姓名、国籍、身高体重 ......

**身价**：球员在场上的良好表现会提高球员的身价，这使他在转会市场上变得炙手可热；反之，糟糕的表现会让球员的贬值。年龄同样是判断身价的重要标准。

**薪资**：每周需要支付给球员的薪水

#### 能力数值

射门

过人

速度

力量

抢断

体能

守门

惯用脚

#### 场上司职

### 资金

#### 收入来源

联赛、杯赛的奖金

广告收入

门票收入

#### 消费去向

球员薪资

员工薪资

球员奖金

转会费用

青训设施提升

### 训练

### 转会

## 开发蓝图

## 技术栈学习路线

### 前端

#### 语言基础

##### HTML + CSS

简单，也用得不深，混个眼熟即可

- 黑马的基础教程，两倍速过，不用太仔细：https://www.bilibili.com/video/BV1pE411q7FU?spm_id_from=333.999.0.0 

##### JavaScript

走马观花即可，到时候用着用着就熟了

- 黑马的基础教程，两倍速过：https://www.bilibili.com/video/BV1ux411d75J 

##### TypeScript

js 的超集，看完 js 就可以看这个

- JS 转到 TS（先看这个！）：https://muyunyun.cn/posts/66a54fc2/

- TS 中文手册（看不懂就跳过）：https://typescript.bootcss.com/
- 一个 TS 入门教程（看不懂就跳过）：https://juejin.cn/post/6844904182843965453?share_token=838edeb2-89c0-4f11-be5d-0598100ff7b1#heading-56

#### Vue

##### Vue2 基础

- 黑马的 Vue2 基础教程，两倍速过：https://www.bilibili.com/video/BV12J411m7MG?from=search&seid=11414460699659749889&spm_id_from=333.337.0.0

- Vue2 的官方 Tutorial，可以一看：https://cn.vuejs.org/v2/guide/

- 关注 Vue-cli 脚手架的使用！可以看我的笔记：https://trouvaille0198.github.io/Notes/Frontend/%E6%A1%86%E6%9E%B6/VUE.html#%E8%84%9A%E6%89%8B%E6%9E%B6

##### Vue-Router

路由管理器

- 官方文档，大致瞄一眼怎么用就行：https://router.vuejs.org/zh/installation.html
- 我的笔记：https://trouvaille0198.github.io/Notes/Frontend/%E6%A1%86%E6%9E%B6/VUE.html#router

##### axios

一个网络请求库，发 request 就靠它了

- 官方文档：https://axios-http.com/zh/docs/intro
- 我的笔记：https://trouvaille0198.github.io/Notes/Frontend/%E6%A1%86%E6%9E%B6/VUE.html#axios

这玩意儿也是大致看懂就行，具体在项目中的用法看我的 Demo：https://github.com/Trouvaille0198/littttle-site

##### Vuex

一个状态管理库，管理全局变量用的。

- 官方文档：https://vuex.vuejs.org/zh/guide/
- 我的笔记：https://trouvaille0198.github.io/Notes/Frontend/%E6%A1%86%E6%9E%B6/VUE.html#vuex

##### Pinia

也是一个状态管理库，考虑可以替代 Vuex

- 快速入门：https://segmentfault.com/a/1190000040373313?utm_source=sf-similar-article

- 官方文档：https://pinia.esm.dev/introduction.html

##### Vue3

重点是与 Vue2 的不同之处

- 官方文档，讲得很清楚，多看看：https://v3.cn.vuejs.org/guide/introduction.html
- Composition API 的用法（官方文档里也有，也去看看）：https://segmentfault.com/a/1190000040319089

##### 其他

关于到底要不要在 Vue3 中使用 Vuex，以及如果不用的话，用什么来代替它？

- https://zhuanlan.zhihu.com/p/309371894
- https://developer.51cto.com/art/202007/622439.htm
- 这是专门适配 Vue3 的 Vuex 新版本文档：https://next.vuex.vuejs.org/zh/index.html
- Vue3中如何使用vuex语法糖：https://blog.csdn.net/qq_19788257/article/details/118963756

#### Naive UI

一个蛮好看的 UI 框架库

- 官方文档（很好玩）：https://www.naiveui.com/zh-CN/light
- 一个模板，值得好好看看：https://github.com/zce/fearless

### 后端

#### Python

Python 小意思，写着写着就熟了

懂基本语法就 ok

#### FastApi

后端框架，用来写 API 的

- 官方文档，写的蛮好，看它就足够了：https://fastapi.tiangolo.com/zh/
- 我的笔记（与官方文档相似度 98%）：https://trouvaille0198.github.io/Notes/Python/WEB%20backend/FastAPI.html

#### sqlalchemy

这玩意儿的官方文档跟一坨屎一样，不要看

一直没找到好的资料，你们加油

- 可以瞅一瞅我的笔记玩玩（也不是很完善）：https://trouvaille0198.github.io/Notes/Python/WEB%20backend/sqlalchemy.html

### 其他

- 我之前写的前后端分离小 Demo（Vue2 + Vuex + vue-router + axios + Vuetify，FastAPI + sqlalchemy）：https://github.com/Trouvaille0198/littttle-site，主要看后端部分，前端是Vue2，可以不看
- vue-blog 项目，感觉还行：https://github.com/biaochenxuying/blog-vue-typescript
- vue-admin 项目（Vue3 + Vite + TS + vue-router + Pinia），有点复杂看不懂。。：https://github.com/anncwb/vue-vben-admin
- naive-ui
    - https://github.com/zmtlwzy/vue3-api-demo
    - https://github.com/zhizouvip/ok-admin-vue/

## 开发规范

### 前端

#### Vue

- 组件化

- **必须**使用小驼峰命名法，以免在父组件传递 `prop` 或 `emit` 给子组件时发生错误

- 使用 Composition API
