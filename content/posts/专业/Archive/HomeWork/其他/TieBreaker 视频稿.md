---
draft: true
---

# 稿

Tie Breaker 《平分决胜》是一款足球模拟经营类的网页游戏。在游戏中，你将化身一位足球俱乐部教头，训练麾下球员，培养青年才俊；赢得比赛，争夺荣誉。

游戏的主页面涵盖了玩家俱乐部本赛季的基本情况。下一场比赛、球员的表现展示、俱乐部的财政概况和联赛积分榜等等信息，都直观地展示出来，让玩家对球队的当前情况有一个全方面的了解。

（点球员）球员无疑是这款游戏的灵魂所在。我们为球员定制了多维度的能力属性，保证每一位球员都是独一无二的存在。在**卡片页面**中，我们能够总览俱乐部的所有球员及其概况；（翻页）射门、传球、过人等九项属性是判断球员好坏的硬性指标，我们用条形图和醒目的渐变色来直观地展示球员的能力维度。我们还用机器学习中的回归算法计算出最适合球员的场上职责及其对应的综合评估能力值，用浅色的字母缩写展示在了卡片背景上。

（点 LM/RM）点开卡片，我们来到了**球员的个人主页**，这里记录着球员更加详细的信息。不仅给出了球员擅长的场上位置，球员的身价、薪水，还有赛季比赛数据也可以供玩家参考。除此之外，我们还为每位球员定制了多样的可视化图表，能力条形图、最近五场比赛的综合评分，以及球员各位置的出场次数占比，可以让玩家全方面地了解自己的球员状态。

（点数据）游戏还拥有丰富的数据供玩家参考。我们来到**球员数据中心页面**

- 在**球员能力表格**中，你可以方便地对球员的能力数值进行横向对比，通过**升降序排列**来分析每位球员的优势与不足；
- 在球员表现表格中，涵盖了俱乐部球员本赛季所有比赛的数据统计，我们可以清晰地查看和比较每位球员的出场次数、进球助攻次数、平均评分，还有各种详细的动作统计；玩家可以根据这些丰富详实的数据来判断球员的比赛状态和优势位置，这也是游戏策略性的体现。

游戏以一天为一回合，每一次点击下一天的按钮，（下一天）后端都会根据日程表对新一天的各项事务进行处理。当下一场比赛即将到来之时，界面会弹出信息框来提醒玩家进行赛前阵容布置的操作。（点击现在开始）

在**赛前准备页面**，玩家可以拖动右边的球员头像到左边的战术面板中，游戏拥有多达 12 个各具特色的场上位置供玩家选择，玩家也可以点击头像来查看球员的擅长位置，尽量发挥每个球员的长处。

完成排兵布阵之后，我们点击开始比赛按钮，便来到了**比赛页面**。

我们从真实的足球比赛中汲取灵感，并且简化作战方式，打造了一套独特的比赛模拟系统：我们将球员间的进攻配合抽象为形形色色的进攻战术；将球员在球场上的每一次动作抽象为数值之间的判定与对抗

而玩家的任务就是通过场上局势的变化，选择最适合的进攻战术，取得进球。

我们手动选择几个战术（选），发现场上的各种数据都在实时发生着变化，我们可以根据这些实时的变化，灵活地选取战术；通过分析球员的场上位置、体力、评分来决定下一次的进攻思路。当然，游戏提供了自动比赛选项（自动化），你可以设置每种战术的占比，系统每回合就会按概率选取一个战术来自动比赛。

（自动的过程中）比赛界面呈对称布局，左右上方的战术板是两队球员在场上的实时位置，每一回合都会有动态变化，下方的表格呢记录着两队球员的实时数据；中间的卡片流依次记录着比赛时间与比分，战术选择按钮组、解说和数据对抗图。

我们手动完成剩余的比赛

90 分钟比赛结束，便跳转到**比赛结束页面**，在这里我们可以对整场比赛进行完整的回顾。我们有丰富的图表信息给到玩家，便于做一个详实的赛后分析和总结。

其中包括了两队的雷达图、进攻战术柱状图、MVP 展示，和完整的比赛解说。

值得一提的是，我们用机器学习中的聚类算法，提取出每支俱乐部 logo 的主色调，运用到这个界面上，使左右两边的颜色分别对应两支俱乐部的颜色，清晰又美观。

球员转会是另一项富有乐趣和策略的玩法，是挥金如土、引进大牌球员，还是挖掘潜力之星、培养青年才俊，一切由玩家决定。在转会大名单中，我们可以总览来自各个俱乐部的挂牌球员，货比三家，找到最适合球队阵容的新星。左键点击心仪的球员即可发起交易。在弹出的交易框中，你可以尝试做出报价，所有报价将在第二天被处理。这就是转会的基本流程。

以上就是 Tie Breaker 这款游戏的基本介绍。
