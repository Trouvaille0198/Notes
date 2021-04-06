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
<v-app>
    <!-- 必须有app属性 -->
    <v-app-bar app></v-app-bar>
  <v-main>
    Hello World
  </v-main>
</v-app>
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

## 2.2 v-bottom-navigation

## 2.3 v-footer

## 2.4 v-navition-drawer

## 2.5 v-system-bar

# 三、多功能组件

## 3.1 v-cards

### 3.1.1 API

### 3.1.2 子组件

# 四、小型组件

# 五、大型组件

