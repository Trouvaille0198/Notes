---
draft: true
---

# Tie Breaker

## 后端架构

- TieBreaker 游戏架构
    - 比赛模块
        - 备战管理
        - 比赛进程状态展示
        - 比赛结果保存
    - 实例生成模块
        - 联赛生成
        - 俱乐部生成
        - 球员生成
        - 日程表生成与更新
    - 转会模块
        - 球员买入
        - 球员卖出
        - 球员薪资谈判
    - 财政模块
        - 奖金收入
        - 比赛票务收入
        - 人事工资支出
        - 转会利润统计
    - 用户管理
        - 登录鉴权
        - 存档管理

## 界面特点

主色辅色：在保持清爽简洁的同时，使整体界面富于变化

- 用户可以自由选择喜爱的主色

以卡片为信息载体：清晰明了

- 圆角设计降低突兀感
- 阴影设计突出信息区块的独立性

瀑布流

- 灵动

丰富的图表

- 提供多样的数据可视化呈现

导航栏、侧边栏设计

- 侧边栏设计：便于路由跳转
- 导航栏设计：将常用操作放置在导航栏部分，快捷方便

转移动画、滚动条重绘

- 使整体风格趋于统一

## 功能模块设计

![image-20220404135450853](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404135450853.png)

代码结构

- assets：静态文件，如人名库、国家名库
- core：数据库与ORM框架的相关配置
- crud：使用对象关系映射模型构建的原子性数据库操作集合
- game_configs：游戏的参数配置和算法权重配置文件
    - 如头像生成概率、能力值的地域修正、联赛和俱乐部的初始数据、各个职责能力值的计算公式、token生成密钥等
    - ![image-20220404135825016](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404135825016.png)

- logs：日志文件
- models：ORM模型定义
    - 负责与对象关系映射模型与数据库的交互转换
    - ![image-20220404140159339](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404140159339.png)

- modules：游戏运行的核心模块集合

    - ![image-20220404140339337](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404140339337.png)

    - computed_data_app：数据对象的计算属性统计模块，负责将数据库中的初始数据构建为成体系的结构化数据，便于展示给用户
    - game_app：比赛逻辑模块
        - AI 之间的比赛逻辑和人机比赛逻辑
            - 数十种动作对抗的函数定义
            - 五种进攻战术的脚本
            - 比赛实时数据的记录
        - 两种球员挑选算法
        - 根据对手特性调整战术比重的算法

    - generate_app：生成联赛、俱乐部、球、日程表的工厂类模块

    - next_turn_app：推动游戏行进的消息转发模块，负责接受前端请求调用相应的功能

    - transfer_app：球员市场转会模块
        - AI 间的球员交易、玩家和 AI 俱乐部间的球员交易
        - 球员合同谈判过程模拟

- routers：提供 API，负责前后端的通信和数据交换

- schemas：数据交换格式的规范化模块，定义了每个数据实体的数据类型

- utils：工具模块

    - ![image-20220404142251723](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404142251723.png)

    - date：日期生成和计算工具
    - dependencies 与 token_validator：用户鉴权工具
    - logger：日志记录类
    - utils：提供常用的工具函数，如时间序列生成算法、随机数生成算法等

## 机器学习的引入

游戏核心架构引入了机器学习方法，便于对游戏参数进行调整和优化。

**球员在某位置的综合能力值算法**通过确定各项能力对于此位置的重要程度来实现。举个例子，前锋对于射门素质要求相当之高，故射门属性权重自然就高；相反，防守拦截能力也就相对不重要。

在游戏设计之初，这些权重都由编程设计人员凭借对于比赛逻辑和战术思想的了解估算而出。这样的估计有着一定的误差。在游戏构建到一定程度时，不准确的综合能力值权重参数给球员生成算法、球队选人算法、转会推荐算法和玩家的评估标准等一系列功能造成了不小的麻烦。后来，我们使用了机器学习中的回归算法，准确快速地揭示了各项属性和位置之间的联系。

我们模拟了数十万场比赛，生成了一个庞大的数据集：在每场比赛中，只有一位球员的属性是随机生成的，其余球员均设置为默认值，这样我们就能通过比赛的最终比分，评估这位球员的能力强弱。通过线性回归算法，对这些样本进行训练，最后得出了一个稳定准确的权重系数。

![image-20220410163357091](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410163357091.png)

![image-20220410163406434](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410163406434.png)

当前，这些样本还可以做更多的事情：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410170011621.png" alt="image-20220410170011621" style="zoom:50%;" />

前锋的综合能力与射门属性之间的关系，可以看出有明显的正比关系

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410170139800.png" alt="image-20220410170139800" style="zoom:50%;" />

前锋的综合能力与射门属性之间的关系，曲线斜率较之前略小

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410170225581.png" alt="image-20220410170225581" style="zoom:50%;" />

前锋的综合能力与防守属性之间的关系，可以看出两者没有关系

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410203051063.png" alt="image-20220410203051063" style="zoom: 80%;" />

各个阵型失球数分布图，可以看出 4-4-2 阵型的进攻能力冠绝群雄，4-1-4-1 阵型的进攻能力相对不足

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410203228718.png" alt="image-20220410203228718" style="zoom:80%;" />

各个阵型进球数分布图，也印证了进攻与防守难以兼得

以下的箱线图更为清晰：

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410203512367.png" alt="image-20220410203512367" style="zoom:67%;" />

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410203521930.png" alt="image-20220410203521930" style="zoom:67%;" />

最后是各个阵型与净胜球的点估计图

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220410204119847.png" alt="image-20220410204119847" style="zoom:67%;" />

可以看到估计值极为接近。只有 0.1 左右的差距，侧面证明了六大阵型设计的合理性。

## 功能模块设计

![image-20220404135450853](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404135450853.png)

代码结构

- assets：静态文件，如人名库、国家名库
- core：数据库与ORM框架的相关配置
- crud：使用对象关系映射模型构建的原子性数据库操作集合
- game_configs：游戏的参数配置和算法权重配置文件
    - 如头像生成概率、能力值的地域修正、联赛和俱乐部的初始数据、各个职责能力值的计算公式、token生成密钥等
    - ![image-20220404135825016](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404135825016.png)

- logs：日志文件
- models：ORM模型定义
    - 负责与对象关系映射模型与数据库的交互转换
    - ![image-20220404140159339](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404140159339.png)

- modules：游戏运行的核心模块集合

    - ![image-20220404140339337](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404140339337.png)

    - computed_data_app：数据对象的计算属性统计模块，负责将数据库中的初始数据构建为成体系的结构化数据，便于展示给用户
    - game_app：比赛逻辑模块
        - AI 之间的比赛逻辑和人机比赛逻辑
            - 数十种动作对抗的函数定义
            - 五种进攻战术的脚本
            - 比赛实时数据的记录
        - 两种球员挑选算法
        - 根据对手特性调整战术比重的算法

    - generate_app：生成联赛、俱乐部、球、日程表的工厂类模块

    - next_turn_app：推动游戏行进的消息转发模块，负责接受前端请求调用相应的功能

    - transfer_app：球员市场转会模块
        - AI 间的球员交易、玩家和 AI 俱乐部间的球员交易
        - 球员合同谈判过程模拟

- routers：提供 API，负责前后端的通信和数据交换

- schemas：数据交换格式的规范化模块，定义了每个数据实体的数据类型

- utils：工具模块

    - ![image-20220404142251723](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20220404142251723.png)

    - date：日期生成和计算工具
    - dependencies 与 token_validator：用户鉴权工具
    - logger：日志记录类
    - utils：提供常用的工具函数，如时间序列生成算法、随机数生成算法等

