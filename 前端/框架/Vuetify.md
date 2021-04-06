# 一、基本知识

## 1.1 简介

## 1.2 引入

### 1.2.1 CDN

```html
<!DOCTYPE html>
<html>
<head>
  <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/@mdi/font@4.x/css/materialdesignicons.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css" rel="stylesheet">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
</head>
<body>
  <div id="app">
    <v-app>
      <v-content>
        <v-container>Hello world</v-container>
      </v-content>
    </v-app>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/vue@2.x/dist/vue.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
  <script>
    new Vue({
      el: '#app',
      vuetify: new Vuetify(),
    })
  </script>
</body>
</html>
```

### 1.2.2 使用 Vue CLI

```bash
vue create my-app
# 切换到新项目目录
cd my-app
```

在项目目录中使用

```bash
vue add vuetify
```

或者使用Vue UI 安装

```bash
vue ui
```

### 1.2.3 Electron 用法

要在 Electron 中使用 Vuetify ，需通过 Vue CLI 添加 electron-builder 插件。

```bash
# 安装
vue add electron-builder

# 使用
yarn electron:build
yarn electron:serve
```

## 1.3 布局

Vuetify有两个主要布局组件， `v-app` 和 `v-main`

```html
<template>
  <v-app>
    <v-main>
      <!-- page content -->
      <router-view></router-view>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "App",

  data: () => ({
    //
  }),
};
</script>
```

### 1.3.1 v-app

`v-app` 组件是应用程序的根节点，直接替换默认的 Vue 入口 `<div id="app">`

在其中写入的元素，会**作为布局的一部分**

在组件或其他视图中，不需要引入 `v-app`

所有应用都**需要** `v-app` 组件。 这是许多 Vuetify 组件和功能的挂载点，而且它必须是**所有** Vuetify 组件的祖先节点

`v-app` 只应该在应用中渲染**一次**。

### 1.3.2 v-main

`v-main` 组件是替换 `main` HTML 元素和应用程序的根节点 **内容** 的语义替代

常常在其中切换路由

它会根据你指定的**应用**组件的结构而动态调整大小

### 1.3.3 默认应用标记

只要设置 **app** 属性，你可以将布局元素放在任何地方

## 1.4 通用属性

| Name  | Type   | Default   | Description                  |
| ----- | ------ | --------- | ---------------------------- |
| color | string | undefined | 详见 colors page             |
| app   |        |           | 相应的组件是应用布局的一部分 |
|       |        |           |                              |
|       |        |           |                              |
|       |        |           |                              |
|       |        |           |                              |

# 二、应用组件

这些组件通常被用作布局元素。它们可以混合和匹配，并且每个特定组件在任何时候都只能存在**一个**

每一个应用组件都有一个指定的位置和优先级，影响布局系统中的位置

- v-app-bar：总是放在应用顶部，优先级低于 `v-system-bar`。
- v-bottom-navigation：总是放在应用底部，优先级高于 `v-footer`。
- v-footer：总是放在应用底部，优先级低于 `v-bottom-navigation`。
- v-navigation-drawer：可以放置在应用的左边或右边，并且可以配置在 `v-app-bar` 的旁边或下面。
- v-system-bar：总是放在应用顶部，优先级高于 `v-app-bar`

## 2.1 v-app-bar

`v-app-bar` 组件对于任何图形用户界面（GUI）都至关重要，因为它通常是站点导航的主要来源

![image-20210406155012015](C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20210406155012015.png)

App-bar 组件与 `<a href=“/components/navigation drawers”>` ` v-navigation-drawer` 配合使用，可以在应用程序中提供站点导航

`v-app-bar` 组件用于应用程序范围内的操作和信息

### 2.1.1 API

| Name               | Type    | Default | Description                                                  |
| ------------------ | ------- | ------- | ------------------------------------------------------------ |
| **collapse**       | boolean | false   | 将工具栏置于折叠状态，以减小其最大宽度                       |
| collapse-on-scroll | boolean | false   | 滚动时将应用栏置于折叠状态                                   |
| dense              | boolean | false   | 将工具栏内容的高度降低到 48px（使用 **prominent** 属性时为 96px）。 |
|                    |         |         |                                                              |
|                    |         |         |                                                              |
|                    |         |         |                                                              |

### 2.1.2 子组件

#### 1）v-app-bar-nav-icon

专门为与 `v-toolbar` 和 `v-app-bar` 一起使用而创建的样式化图标按钮组件

#### 2）v-app-bar-title

## 2.2 v-bottom-navigation

## 2.3 v-footer

`v-footer` 组件用于显示用户可能想要从网站中的任何页面都能访问到的公共信息

## 2.4 v-navition-drawer

`v-navigation-drawer` （导航抽屉）是您的用户用于导航应用程序的组件

## 2.5 v-system-bar

# 三、多功能组件

## 3.1 v-cards

### 3.1.1 API

### 3.1.2 子组件

## 3.2 v-tool-bar

`v-toolbar `组件对于任何 gui 都是至关重要的，因为它通常是站点导航的主要来源。 工具栏组件与 `<a href="/components/navigation drawers">, v-navigation-drawer` 和 `v-card` 配合使用非常有效

### 3.2.1 子组件

#### 1）v-toolbar-items
#### 2）v-toolbar-title

# 四、小型组件

# 五、大型组件

# 六、表单组件

# 七、网格系统

（Grid System）

##  7. v-container

`v-container` 提供了将你的网站内容居中和水平填充的功能

## 7. v-row

`v-col` 包裹内容，它必须是 `v-row` 的直接子代

## 7. v-col

`v-row` 是 `v-col` 的容器组件。 它使用 flex 属性来控制其内栏的布局和流

## 7. v-spacer

`v-spacer` 是一个基本而又通用的间隔组件，用于分配父子组件之间的剩余宽度

# 八、组

# 九、样式

## 9.1 颜色

每种颜色都会被转换为 **background** 和 **text** 变体

```html
<template>
  <div class="purple darken-2 text-center">
    <span class="white--text">Lorem ipsum</span>
  </div>
</template>
```

改变背景颜色 `red`

改变文本颜色 `text--red`

改变背景明暗 `lighten-4`

改变文本明暗 `text--darken-2`

## 9.2 文本

### 9.2.1 字体强调

```html
<template>
  <div>
    <p class="font-weight-black">
      Black text.
    </p>
    <p class="font-weight-bold">
      Bold text.
    </p>
    <p class="font-weight-medium">
      Medium weight text.
    </p>
    <p class="font-weight-regular">
      Normal weight text.
    </p>
    <p class="font-weight-light">
      Light weight text.
    </p>
    <p class="font-weight-thin">
      Thin weight text.
    </p>
    <p class="font-italic">
      Italic text.
    </p>
  </div>
</template>
```

![image-20210406170957036](http://image.trouvaille0198.top/image-20210406170957036.png)

### 9.2.2 字体大小

**格式**

- `.text-{value}` 用于 `xs`
- `.text-{breakpoint}-{value}` 用于 `sm`, `md`, `lg` 和 `xl`

**value**

- `h1`
- `h2`
- `h3`
- `h4`
- `h5`
- `h6`
- `subtitle-1`
- `subtitle-2`
- `body-1`
- `body-2`
- `button`
- `caption`
- `overline`

### 9.2.3 文本对齐

**自动对齐**

`.text-justify` 

**指定方向对齐**

`.text-left`

`.text-right`

`.text-center`

`.text-{breakpoint}-{direction}`

<img src="http://image.trouvaille0198.top/image-20210406214448457.png" alt="image-20210406214448457" style="zoom: 80%;" />

### 9.2.4 不透明度

`text--primary` 与默认文本具有相同的不透明度。

 `text--secondary` 用于提示和辅助文本。 

`text--disabled` 用于去除强调文本

<img src="http://image.trouvaille0198.top/image-20210406214558337.png" alt="image-20210406214558337" style="zoom: 80%;" />

### 9.2.5 装饰线

移除文本装饰线

`.text-decoration-none` 

添加上划线

`.text-decoration-overline`

添加下划线线

``.text-decoration-underline`

添加删除线

``.text-decoration-line-through` 

### 9.2.6 转换大小写

`.text-lowercase`：小写

`.text-uppercase`：大写

`.text-capitalize`：单词首字母大写

## 9.3 间距

**格式**：**{property}{direction}-{size}**

<img src="http://image.trouvaille0198.top/image-20210406170240133.png" alt="image-20210406170240133" style="zoom: 80%;" />

**property** 应用间距类型:

- `m` - 应用 `margin`
- `p` - 应用 `padding`

**direction** 指定了该属性所应用的侧边:

- `t` - 应用 `margin-top` 和 `padding-top` 的间距
- `b` - 应用 `margin-bottom` 和 `padding-bottom` 的间距
- `l` - 应用 `margin-left` 和 `padding-left` 的间距
- `r` - 应用 `margin-right` 和 `padding-right` 的间距
- `s` - 应用 `margin-left`/`padding-left` (LTR模式) 和 `margin-right`/`padding-right`(RTL模式) 的间距
- `e` - 应用 `margin-right`/`padding-right` (LTR模式) 和 `margin-left`/`padding-left`(RTL模式) 的间距
- `x` - 应用 `*-left` 和 `*-right` 的间距
- `y` - 应用 `*-top` 和 `*-bottom` 的间距
- `a` - 在所有方向应用该间距

**size** 以4px增量控制间距属性:

- `0` - 通过设置为 `0` 来消除所有 `margin` 或 `padding`.
- `1` - 设置 `margin` 或 `padding` 为 4px
- `2` - 设置 `margin` 或 `padding` 为 8px
- `3` - 设置 `margin` 或 `padding` 为 12px
- `4` - 设置 `margin` 或 `padding` 为 16px
- `5` - 设置 `margin` 或 `padding` 为 20px
- `6` - 设置 `margin` 或 `padding` 为 24px
- `7` - 设置 `margin` 或 `padding` 为 28px
- `8` - 设置 `margin` 或 `padding` 为 32px
- `9` - 设置 `margin` 或 `padding` 为 36px
- `10` - 设置 `margin` 或 `padding` 为 40px
- `11` - 设置 `margin` 或 `padding` 为 44px
- `12` - 设置 `margin` 或 `padding` 为 48px
- `13` - 设置 `margin` 或 `padding` 为 52px
- `14` - 设置 `margin` 或 `padding` 为 56px
- `15` - 设置 `margin` 或 `padding` 为 60px
- `16` - 设置 `margin` 或 `padding` 为 64px
- `n1` - 设置 `margin` 为 -4px
- `n2` - 设置 `margin` 为 -8px
- `n3` - 设置 `margin` 为 -12px
- `n4` - 设置 `margin` 为 -16px
- `n5` - 设置 `margin` 为 -20px
- `n6` - 设置 `margin` 为 -24px
- `n7` - 设置 `margin` 为 -28px
- `n8` - 设置 `margin` 为 -32px
- `n9` - 设置 `margin` 为 -36px
- `n10` - 设置 `margin` 为 -40px
- `n11` - 设置 `margin` 为 -44px
- `n12` - 设置 `margin` 为 -48px
- `n13` - 设置 `margin` 为 -52px
- `n14` - 设置 `margin` 为 -56px
- `n15` - 设置 `margin` 为 -60px
- `n16` - 设置 `margin` 为 -64px
- `auto` - 设置间距为 **auto**

## 9.4 显示辅助

### 9.4.1 设置显示元素

**格式：hidden-{breakpoint}-{condition}**

**condition：**

- `only` - 只在某个指定断点隐藏元素
- `and down` - 在指定的断点和以下隐藏元素, 从 `sm` 到 `lg` 断点
- `and down` - 在指定的断点和以上隐藏元素, 从 `sm` 到 `lg` 断点