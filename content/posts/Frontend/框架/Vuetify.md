---
title: "Vuetify"
date: 2021-11-30
author: MelonCholi
draft: false
tags: [归档,前端,快速入门,Vue]
categories: [前端]
---

# Vuetify

## 基本知识

### 引入

#### CDN

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

#### 使用 Vue CLI

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

#### Electron 用法

要在 Electron 中使用 Vuetify ，需通过 Vue CLI 添加 electron-builder 插件。

```bash
# 安装
vue add electron-builder

# 使用
yarn electron:build
yarn electron:serve
```

### 布局

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

#### v-app

`v-app` 组件是应用程序的根节点，直接替换默认的 Vue 入口 `<div id="app">`

在其中写入的元素，会**作为布局的一部分**

在组件或其他视图中，不需要引入 `v-app`

所有应用都**需要** `v-app` 组件。 这是许多 Vuetify 组件和功能的挂载点，而且它必须是**所有** Vuetify 组件的祖先节点

`v-app` 只应该在应用中渲染**一次**。

#### v-main

`v-main` 组件是替换 `main` HTML 元素和应用程序的根节点 **内容** 的语义替代

常常在其中切换路由

它会根据你指定的**应用**组件的结构而动态调整大小

#### 默认应用标记

只要设置 **app** 属性，你可以将布局元素放在任何地方

### 通用属性

| Name                                                                   | Type             | Default   | Description                       |
| ---------------------------------------------------------------------- | ---------------- | --------- | --------------------------------- |
| color                                                                  | string           | undefined | 详见 colors page                  |
| app                                                                    |                  |           | 相应的组件是应用布局的一部分      |
| dense                                                                  | boolean          | flase     | 使组件更小                        |
| [elevation](https://vuetifyjs.com/zh-Hans/api/v-card/#props-elevation) | number \| string | undefined | 组件的海拔可接受 0 到 24 之间的值 |
| [disabled](https://vuetifyjs.com/zh-Hans/api/v-card/#props-disabled)   | boolean          | false     | 移除组件的单击或 target 功能      |
|                                                                        |                  |           |                                   |
|                                                                        |                  |           |                                   |
|                                                                        |                  |           |                                   |
|                                                                        |                  |           |                                   |

## 应用组件

这些组件通常被用作布局元素。它们可以混合和匹配，并且每个特定组件在任何时候都只能存在**一个**

每一个应用组件都有一个指定的位置和优先级，影响布局系统中的位置

- v-app-bar：总是放在应用顶部，优先级低于 `v-system-bar`。
- v-bottom-navigation：总是放在应用底部，优先级高于 `v-footer`。
- v-footer：总是放在应用底部，优先级低于 `v-bottom-navigation`。
- v-navigation-drawer：可以放置在应用的左边或右边，并且可以配置在 `v-app-bar` 的旁边或下面。
- v-system-bar：总是放在应用顶部，优先级高于 `v-app-bar`

### v-app-bar

`v-app-bar` 组件对于任何图形用户界面（GUI）都至关重要，因为它通常是站点导航的主要来源

![image-20210406155012015](C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20210406155012015.png)

App-bar 组件与 `<a href=“/components/navigation drawers”>` ` v-navigation-drawer` 配合使用，可以在应用程序中提供站点导航

`v-app-bar` 组件用于应用程序范围内的操作和信息

#### API

| Name               | Type    | Default | Description                                                         |
| ------------------ | ------- | ------- | ------------------------------------------------------------------- |
| **collapse**       | boolean | false   | 将工具栏置于折叠状态，以减小其最大宽度                              |
| collapse-on-scroll | boolean | false   | 滚动时将应用栏置于折叠状态                                          |
| dense              | boolean | false   | 将工具栏内容的高度降低到 48px（使用 **prominent** 属性时为 96px）。 |
|                    |         |         |                                                                     |
|                    |         |         |                                                                     |
|                    |         |         |                                                                     |

#### 子组件

##### v-app-bar-nav-icon

专门为与 `v-toolbar` 和 `v-app-bar` 一起使用而创建的样式化图标按钮组件

在工具栏的左侧显示为汉堡菜单，它通常用于控制导航抽屉的状态

```html
<v-app-bar-nav-icon></v-app-bar-nav-icon>
```

##### v-app-bar-title

修改过的 v-toolbar-title 组件 ，用于配合 `shrink-on-scroll` 属性使用

### v-bottom-navigation

### v-footer

`v-footer` 组件用于显示用户可能想要从网站中的任何页面都能访问到的公共信息

### v-navition-drawer

（导航抽屉）

用于导航应用程序的组件

为了显示的目的，一些示例被包装在 `v-card` 元素中。 

通常会把 `v-navigation-drawer` 组件作为 `v-app` 的直接子组件

使用 `null` 作为其 **v-model 的初始值** 将会将抽屉初始化为在移动设备上关闭，在桌面环境下打开。 

通常使用 **nav** 属性将抽屉与 [v-list](https://vuetifyjs.com/zh-Hans/components/lists/) 组件配对

#### API

| Name                                                                                            | Type             | Default   | Description                                                          |
| ----------------------------------------------------------------------------------------------- | ---------------- | --------- | -------------------------------------------------------------------- |
| [expand-on-hover](https://vuetifyjs.com/zh-Hans/api/v-navigation-drawer/#props-expand-on-hover) | boolean          | false     | 将抽屉折叠成 **mini-variant**，直到用鼠标悬停                        |
| [temporary](https://vuetifyjs.com/zh-Hans/api/v-navigation-drawer/#props-temporary)             | boolean          | false     | 临时抽屉位于其应用之上，并使用稀松布（叠加）来使背景变暗             |
| [permanent](https://vuetifyjs.com/zh-Hans/api/v-navigation-drawer/#props-permanent)             | boolean          | false     | 不管屏幕尺寸如何，抽屉都可以看到                                     |
| [src](https://vuetifyjs.com/zh-Hans/api/v-navigation-drawer/#props-src)                         | string \| object | undefined | 指定 [v-img](https://vuetifyjs.com/components/images) 作为组件背景。 |

### v-system-bar

## 多功能组件

### v-cards

卡中有4个基本组件。 `v-card-title`, `v-card-subtitle`, `v-card-text` 和 `v-card-actions`

#### API

| Name                                                                 | Type              | Default   | Description                                                                                                                                                                                                                                                           |
| -------------------------------------------------------------------- | ----------------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [hover](https://vuetifyjs.com/zh-Hans/api/v-card/#props-hover)       | boolean           | false     | 悬停时将应用 4dp 的海拔（默认值为 2dp）                                                                                                                                                                                                                               |
| [img](https://vuetifyjs.com/zh-Hans/api/v-card/#props-img)           | string            | undefined | 指定卡片的背景图。对于更高级的实现，建议您使用 [v-img](https://vuetifyjs.com/components/images) 组件                                                                                                                                                                  |
| [to](https://vuetifyjs.com/zh-Hans/api/v-card/#props-to)             | string \| object  | undefined | 表示链接的目标路由                                                                                                                                                                                                                                                    |
| [dense](https://vuetifyjs.com/zh-Hans/api/v-toolbar/#props-dense)    | boolean           | false     | 将工具栏内容的高度降低到 48px                                                                                                                                                                                                                                         |
| [rounded](https://vuetifyjs.com/zh-Hans/api/v-card/#props-rounded)   | boolean \| string | undefined | 对指定的组件应用 **border-radius** 样式                                                                                                                                                                                                                               |
| [outlined](https://vuetifyjs.com/zh-Hans/api/v-card/#props-outlined) | boolean           | false     | 去除卡片的实心颜色并添加细边框                                                                                                                                                                                                                                        |
| [loading](https://vuetifyjs.com/zh-Hans/api/v-card/#props-loading)   | boolean \| string | false     | 显示线性进度条。可以是指定将哪种颜色应用于进度条的字符串（任何 material 色彩——主要（primary）, 次要（secondary）, 成功（success）, 信息（info），警告（warning），错误（error）），或者使用组件的布尔值 **color**（由色彩属性设置——如果它被组件支持的话）还可以是原色 |
|                                                                      |                   |           |                                                                                                                                                                                                                                                                       |

#### 子组件

##### v-card-actions

用于为卡片放置 **动作** 的容器，如 v-btn 或 v-menu

##### v-card-text

主要用于卡片中的 **文本内容**

##### v-card-subtitle

为卡片字幕提供默认的 **字体大小** 和 **填充**

##### v-card-title

为卡片字幕提供默认的 **字体大小** 和 **填充**

### v-tool-bar

`v-toolbar `组件对于任何 gui 都是至关重要的，因为它通常是站点导航的主要来源。 工具栏组件与 `<a href="/components/navigation drawers">, v-navigation-drawer` 和 `v-card` 配合使用非常有效

```html
<template>
  <div>
    <v-toolbar>
      <v-app-bar-nav-icon></v-app-bar-nav-icon>
      <v-toolbar-title>Vuetify</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon>
        <v-icon>mdi-export</v-icon>
      </v-btn>
    </v-toolbar>
  </div>
</template>
```

#### API

| Name                                                                      | Type             | Default   | Description                                                        |
| ------------------------------------------------------------------------- | ---------------- | --------- | ------------------------------------------------------------------ |
| [prominent](https://vuetifyjs.com/zh-Hans/api/v-toolbar/#props-prominent) | boolean          | false     | 将工具栏内容的高度增加到 128px                                     |
| [src](https://vuetifyjs.com/zh-Hans/api/v-toolbar/#props-src)             | string \| object | undefined | 指定 [v-img](https://vuetifyjs.com/components/images) 作为组件背景 |
| [collapse](https://vuetifyjs.com/zh-Hans/api/v-toolbar/#props-collapse)   | boolean          | false     | 将工具栏置于折叠状态，以减小其最大宽度                             |
| [dense](https://vuetifyjs.com/zh-Hans/api/v-toolbar/#props-dense)         | boolean          | false     | 将工具栏内容的高度降低到 48px                                      |

#### 子组件

##### v-toolbar-items

允许 `v-btn` 扩展全高度

##### v-toolbar-title

用于显示标题

### v-list

`v-list` 组件用于显示信息。 它可以包含头像、内容、操作、列表组标题等等。 列表以易于在集合中识别特定项目的方式显示内容。 它们为组织一组文本和图像提供了一致的样式

列表有三种基本形式。 **单行** (默认), **双行** 和 **三行**. 行声明指定了项目的最小高度，也可以使用相同的属性从 `v-list` 中进行控制

```html
<template>
  <v-card
    class="mx-auto"
    max-width="300"
    tile
  >
    <v-list dense>
      <v-subheader>REPORTS</v-subheader>
      <v-list-item-group
        v-model="selectedItem"
        color="primary"
      >
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
        >
          <v-list-item-icon>
            <v-icon v-text="item.icon"></v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title v-text="item.text"></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-card>
</template>
```

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210407125112331.png" alt="image-20210407125112331" style="zoom:80%;" />

#### API

| Name                                                       | Type    | Default | Description                                                                                                                                      |
| ---------------------------------------------------------- | ------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| disabled                                                   | boolean | false   | 禁用所有子级的 `v-list-item` 组件                                                                                                                |
| flat                                                       | boolean | false   | 删除活动的 `v-list-item` 上突出显示的背景                                                                                                        |
| dense                                                      | boolean | false   | 减小列表块的最大宽度                                                                                                                             |
| rounded                                                    | boolean | false   | 圆角 `v-list-item` 边                                                                                                                            |
| three-line / two-line                                      | boolean | false   | 增加三 \ 两行的列表项高度                                                                                                                        |
| [nav](https://vuetifyjs.com/zh-Hans/api/v-list/#props-nav) | boolean | false   | 另一种样式可以减小 `v-list-item` 的宽度并圆角化。 通常与 **[v-navigation-drawer](https://vuetifyjs.com/components/navigation-drawers)** 一起使用 |
|                                                            |         |         |                                                                                                                                                  |

#### 子组件

##### v-list-item

装载列表项子组件

| Name                                                              | Type             | Default   | Description                                                         |
| ----------------------------------------------------------------- | ---------------- | --------- | ------------------------------------------------------------------- |
| link                                                              | boolean          | false     | 指定组件为链接。当使用 **href** 或 **to**属性时，这是自动的设置的。 |
| [to](https://vuetifyjs.com/zh-Hans/api/v-list-item/#props-to)     | string \| object | undefined | 表示链接的目标路由                                                  |
| [href](https://vuetifyjs.com/zh-Hans/api/v-list-item/#props-href) | string \| object | undefined | 指定组件为锚点并应用 **href** 属性。                                |
|                                                                   |                  |           |                                                                     |
|                                                                   |                  |           |                                                                     |

##### v-list-item-content

装载文字组件

##### v-list-item-icon

装载图标组件

##### v-list-item-title

列表元素标题

##### v-list-item-subtitle

列表元素副标题

##### v-list-item-action

装载动作组件

##### v-list-item-avatar

装载头像类型的图片组件 img

## 小型组件

### v-btn

#### API

| Name                                                                  | Type             | Default   | Description                                                                             |
| --------------------------------------------------------------------- | ---------------- | --------- | --------------------------------------------------------------------------------------- |
| [outlined](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-outlined)   | boolean          | false     | 使背景透明并使用薄边框                                                                  |
| [block](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-block)         | boolean          | false     | 将按钮扩大到可用空间的 100％。                                                          |
| [depressed](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-depressed) | boolean          | false     | 移除按钮的阴影效果                                                                      |
| [disabled](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-disabled)   | boolean          | false     | 移除组件的单击或 target 功能                                                            |
| [elevation](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-elevation) | number \| string | undefined | 组件的海拔可接受 0 到 24 之间的值                                                       |
| [exact](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-exact)         | boolean          | false     | 完全匹配链接。如果没有这个链接，‘/’ 将匹配每个路由                                      |
| [append](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-append)       | boolean          | false     | 设置 **append** 属性总是会附加到当前路径的相对路径上。                                  |
| [fab](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-fab)             | boolean          | false     | Designates the button as a floating-action-button. Button will become *round*           |
| [href](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-href)           | string \| object | undefined | 指定组件为锚点并应用 **href** 属性                                                      |
| [icon](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-icon)           | boolean          | false     | Designates the button as icon. Button will become *round* and applies the **text** prop |
| [link](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-link)           | boolean          | false     | 指定组件为链接。当使用 **href** 或 **to** 属性时，这是自动的设置的                      |
| [plain](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-plain)         | boolean          | false     | 移除悬停在按钮上时应用的默认背景变化                                                    |
| [value](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-value)         | any              | undefined | 控制组件可见还是隐藏                                                                    |
| [text](https://vuetifyjs.com/zh-Hans/api/v-btn/#props-text)           | boolean          | false     | Makes the background transparent                                                        |

### v-icon

可以在按钮内部使用

```html
<v-btn
       class="ma-2"
       color="red"
       dark
       >
    Decline
    <v-icon
            dark
            right
            >
        mdi-cancel
    </v-icon>
</v-btn>
```

#### API

| Name                                                               | Type    | Default | Description                                                            |
| ------------------------------------------------------------------ | ------- | ------- | ---------------------------------------------------------------------- |
| [small](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-small)     | boolean | false   | 使组件尺寸变的小                                                       |
| [large](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-large)     | boolean | false   | 使组件尺寸变的巨大                                                     |
| [x-small](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-x-small) | boolean | false   | 使组件尺寸变的更小                                                     |
| [x-large](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-x-large) | boolean | false   | 使组件尺寸变的无比巨大                                                 |
| [right](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-right)     | boolean | false   | 当按钮放置在另一个元素或文本的**右边**时，对按钮内的图标应用适当的间距 |
| [left](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-left)       | boolean | false   | 当按钮放置在另一个元素或文本的**左边**时，对按钮内的图标应用适当的间距 |

### v-img

#### API

| Name                                                                        | Type             | Default   | Description                                                          |
| --------------------------------------------------------------------------- | ---------------- | --------- | -------------------------------------------------------------------- |
| [alt](https://vuetifyjs.com/zh-Hans/api/v-img/#props-alt)                   | string           | undefined | 屏幕阅读器的备用文本。 留空以装饰图像                                |
| [aspect-ratio](https://vuetifyjs.com/zh-Hans/api/v-img/#props-aspect-ratio) | string \| number | undefined | 计算为`width/height`，因此对于 1920x1080px 的图片，其值为 `1.7778`。 |
| [contain](https://vuetifyjs.com/zh-Hans/api/v-img/#props-contain)           | boolean          | false     | 防止图像不合适时被裁剪                                               |
| [x-large](https://vuetifyjs.com/zh-Hans/api/v-icon/#props-x-large)          | boolean          | false     | 使组件尺寸变的无比巨大                                               |
| [max-height](https://vuetifyjs.com/zh-Hans/api/v-img/#props-max-height)     | number \| string | undefined | 设定组件的最大高度                                                   |
| [min-width](https://vuetifyjs.com/zh-Hans/api/v-img/#props-min-width)       | number \| string | undefined | 设定组件的最小宽度                                                   |
| [src](https://vuetifyjs.com/zh-Hans/api/v-img/#props-src)                   | string \| object | undefined | 图像的 URL。这个属性是强制性的                                       |
|                                                                             |                  |           |                                                                      |
|                                                                             |                  |           |                                                                      |

### v-pagination

`v-pagination` 组件用于分离长数据集，以便用户消化信息。 根据提供的数据量，分页组件将自动缩放

分页默认根据设置的 **length** 属性显示页数，两边有 **prev** 和 **next** 按钮帮助导航

#### API

| Name                                                                         | Type   | Default | Description              |
| ---------------------------------------------------------------------------- | ------ | ------- | ------------------------ |
| [length](https://vuetifyjs.com/zh-Hans/api/v-pagination/#props-length)       | number | 0       | 分页组件的长度           |
| [prev-icon](https://vuetifyjs.com/zh-Hans/api/v-pagination/#props-prev-icon) | string | '$prev' | 指定用于上一个图标的图标 |
| [next-icon](https://vuetifyjs.com/zh-Hans/api/v-pagination/#props-next-icon) | string | '$next' | 指定用于下一个图标的图标 |
|                                                                              |        |         |                          |
|                                                                              |        |         |                          |
|                                                                              |        |         |                          |

### v-snackbar

`v-snackbar` 以最简单的形式向用户显示一个临时且可关闭的通知

#### API

| Name                                                                   | Type             | Default | Description                                                                                                                                      |
| ---------------------------------------------------------------------- | ---------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| [timeout](https://vuetifyjs.com/zh-Hans/api/v-snackbar/#props-timeout) | number \| string | 5000    | 等待snackbar 自动隐藏的时间 (毫秒) 。使用 “-1” 保持无限期打开 (版本 < 2 的 `0` )。 建议这个数字在 `4000` 和 `10000` 之间。此属性的更改将重置超时 |
|                                                                        |                  |         |                                                                                                                                                  |
|                                                                        |                  |         |                                                                                                                                                  |

## 大型组件

### v-date-picker

#### API

| Name                                                                              | Type    | Default   | Description                                                 |
| --------------------------------------------------------------------------------- | ------- | --------- | ----------------------------------------------------------- |
| [max](https://vuetifyjs.com/zh-Hans/api/v-date-picker/#props-max)                 | string  | undefined | 允许的最大 日期/月份（ISO 8601格式）                        |
| [min](https://vuetifyjs.com/zh-Hans/api/v-date-picker/#props-min)                 | string  | undefined | 允许的最小 日期/月份（ISO 8601格式）                        |
| [multiple](https://vuetifyjs.com/zh-Hans/api/v-date-picker/#props-multiple)       | boolean | false     | 允许选择多个日期                                            |
| [picker-date](https://vuetifyjs.com/zh-Hans/api/v-date-picker/#props-picker-date) | string  | undefined | 显示 年/月                                                  |
| [type](https://vuetifyjs.com/zh-Hans/api/v-date-picker/#props-type)               | string  | 'date'    | 确定选择器的类型 - 日期选择器的 `date` ，月选择器的 `month` |
| [scrollable](https://vuetifyjs.com/zh-Hans/api/v-date-picker/#props-scrollable)   | boolean | false     | 允许通过鼠标滚动更改显示的月份                              |
|                                                                                   |         |           |                                                             |
|                                                                                   |         |           |                                                             |

### v-time-picker

#### API

| Name                                                                            | Type    | Default | Description                                                 |
| ------------------------------------------------------------------------------- | ------- | ------- | ----------------------------------------------------------- |
| [format](https://vuetifyjs.com/zh-Hans/api/v-time-picker/#props-format)         | string  | 'ampm'  | 定义在选择器中显示的时间格式。可用的选项是 `ampm` 和 `24hr` |
| [scrollable](https://vuetifyjs.com/zh-Hans/api/v-time-picker/#props-scrollable) | boolean | false   | 允许通过鼠标滚动更改 小时/分钟                              |
|                                                                                 |         |         |                                                             |

## 表单组件

### v-text-field

使用 v-model 绑定输入值，同时可以设置默认值

#### API

| Name                                                                                           | Type                        | Default   | Description                                                                                                                                                                                                       |
| ---------------------------------------------------------------------------------------------- | --------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [label](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-label)                           | string                      | undefined | 设置输入标签                                                                                                                                                                                                      |
| [filled](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-filled)                         | boolean                     | false     | 应用替代填充输入样式                                                                                                                                                                                              |
| [placeholder](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-placeholder)               | string                      | undefined | 设置输入的占位符文本                                                                                                                                                                                              |
| [hint](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-hint)                             | string                      | undefined | 提示文本                                                                                                                                                                                                          |
| [counter](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-counter)                       | boolean \| number \| string | undefined | 为输入长度创建一个计数器，如果未指定数字，则默认为25，不会应用任何验证                                                                                                                                            |
| [rules](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-rules)                           | array                       | []        | 接受不同类型的 `function`, `boolean` 和 `string` 。 函数传递输入值作为参数，必须返回 `true` / `false` 或包含错误消息的 `string` 。 如果函数返回 (或数组包含的任何值) `false` 或 `string` ，输入字段将输入错误状态 |
| [value](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-value)                           | any                         | undefined | 输入的值                                                                                                                                                                                                          |
| [disabled](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-disabled)                     | boolean                     | false     | 禁用输入                                                                                                                                                                                                          |
| [rounded](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-rounded)                       | boolean                     | false     | 向输入添加边框半径                                                                                                                                                                                                |
| [readonly](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-readonly)                     | boolean                     | false     | 将输入设置为只读状态                                                                                                                                                                                              |
| [hide-details](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-hide-details)             | boolean \| string           | undefined | 隐藏提示和验证错误。当设置为 `auto` 时，只有在有信息（提示、错误信息、计数器值等）要显示时，才会显示信息                                                                                                          |
| [persistent-hint](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-persistent-hint)       | boolean                     | false     | 强制提示总是可见的                                                                                                                                                                                                |
| [prepend-icon](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-prepend-icon)             | string                      | undefined | 在组件前添加一个图标，使用与 `v-icon` 相同的语法                                                                                                                                                                  |
| [prepend-inner-icon](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-prepend-inner-icon) | string                      | undefined | 在组件的输入中添加一个图标，使用与 `v-icon` 相同的语法                                                                                                                                                            |
| [prefix](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-prefix)                         | string                      | undefined | 显示前缀                                                                                                                                                                                                          |
| [suffix](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-suffix)                         | string                      | undefined | 显示后缀                                                                                                                                                                                                          |
| [single-line](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-single-line)               | boolean                     | false     | 标签在 focus/dirty 上不移动                                                                                                                                                                                       |
| [type](https://vuetifyjs.com/zh-Hans/api/v-text-field/#props-type)                             | string                      | 'text'    | 设置输入类型                                                                                                                                                                                                      |
|                                                                                                |                             |           |                                                                                                                                                                                                                   |

### v-radio

单选按钮。虽然 `v-radio` 可以单独使用，但它最好与 `v-radio-group` 一起使用。 在 `v-radio-group` 上使用 **v-model**，可以访问组内所选单选按钮的值

![image-20210411174334808](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210411174334808.png)

####  API

| Name                                                                  | Type    | Default   | Description                                          |
| --------------------------------------------------------------------- | ------- | --------- | ---------------------------------------------------- |
| [disabled](https://vuetifyjs.com/zh-Hans/api/v-radio/#props-disabled) | boolean | false     | 移除组件的单击或 target 功能                         |
| [readonly](https://vuetifyjs.com/zh-Hans/api/v-radio/#props-readonly) | boolean | false     | 将输入设置为只读状态                                 |
| [value](https://vuetifyjs.com/zh-Hans/api/v-radio/#props-value)       | any     | undefined | 在组中选择组件时使用的值。如果没有提供，则使用 index |
| [label](https://vuetifyjs.com/zh-Hans/api/v-radio/#props-label)       | string  | undefined | 设置输入标签                                         |
|                                                                       |         |           |                                                      |

### v-checbox

`v-checbox` 组件为用户提供了在两个不同的值之间选择的能力。 它们与开关(switch) 非常相似，可用于复杂的表格和核对清单

#### API

| Name                                                                           | Type    | Default   | Description                                      |
| ------------------------------------------------------------------------------ | ------- | --------- | ------------------------------------------------ |
| [append-icon](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-append-icon) | string  | undefined | 在组件上附加一个图标，使用与 `v-icon` 相同的语法 |
| [disabled](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-disabled)       | boolean | false     | 禁用输入                                         |
| [hint](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-hint)               | string  | undefined | 提示文本                                         |
| [label](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-label)             | string  | undefined | 设置输入标签                                     |
| [input-value](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-input-value) | any     | undefined | **v-model** 的绑定值                             |
|                                                                                |         |           |                                                  |
|                                                                                |         |           |                                                  |
|                                                                                |         |           |                                                  |
|                                                                                |         |           |                                                  |

#### v-simple-checbox

### v-select

下拉框

#### API

| Name                                                                           | Type                        | Default   | Description                                                                                                          |
| ------------------------------------------------------------------------------ | --------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------- |
| [items](https://vuetifyjs.com/zh-Hans/api/v-select/#props-items)               | array                       | []        | 可以是对象数组或字符串数组。当使用对象时，将寻找文本和值字段。 这可以使用 **item-text** 和 **item-value** 属性来更改 |
| [disabled](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-disabled)       | boolean                     | false     | 禁用输入                                                                                                             |
| [hint](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-hint)               | string                      | undefined | 提示文本                                                                                                             |
| [label](https://vuetifyjs.com/zh-Hans/api/v-checkbox/#props-label)             | string                      | undefined | 设置输入标签                                                                                                         |
| [item-text](https://vuetifyjs.com/zh-Hans/api/v-select/#props-item-text)       | string \| array \| function | text      | 设置**items**’属性的文本值                                                                                           |
| [item-value](https://vuetifyjs.com/zh-Hans/api/v-select/#props-item-value)     | string \| array \| function | value     | 设置 **items** 的值的属性                                                                                            |
| [prepend-icon](https://vuetifyjs.com/zh-Hans/api/v-select/#props-prepend-icon) | string                      | undefined | 在组件前添加一个图标，使用与 `v-icon` 相同的语法                                                                     |
| [multiple](https://vuetifyjs.com/zh-Hans/api/v-select/#props-multiple)         | boolean                     | false     | 多选，接受数组作为值                                                                                                 |
|                                                                                |                             |           |                                                                                                                      |
|                                                                                |                             |           |                                                                                                                      |
|                                                                                |                             |           |                                                                                                                      |

### v-switch

#### API

| Name                                                                         | Type    | Default   | Description                      |
| ---------------------------------------------------------------------------- | ------- | --------- | -------------------------------- |
| [input-value](https://vuetifyjs.com/zh-Hans/api/v-switch/#props-input-value) | any     | undefined | **v-model** 的绑定值             |
| [flat](https://vuetifyjs.com/zh-Hans/api/v-switch/#props-flat)               | boolean | false     | 显示没有海拔的组件               |
| [inset](https://vuetifyjs.com/zh-Hans/api/v-switch/#props-inset)             | boolean | false     | 扩展 `v-switch` 轨迹以包含缩略图 |
| [value](https://vuetifyjs.com/zh-Hans/api/v-switch/#props-value)             | any     | undefined | 输入的值                         |
|                                                                              |         |           |                                  |
|                                                                              |         |           |                                  |

### v-slider

#### API

| Name                                                                             | Type              | Default   | Description                                                                                |
| -------------------------------------------------------------------------------- | ----------------- | --------- | ------------------------------------------------------------------------------------------ |
| [max](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-max)                     | number \| string  | 100       | 设置允许的最大值                                                                           |
| [min](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-min)                     | number \| string  | 0         | 设置允许的最小值                                                                           |
| [prepend-icon](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-prepend-icon)   | string            | undefined | 在组件前添加一个图标，使用与 `v-icon` 相同的语法                                           |
| [step](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-step)                   | number \| string  | 1         | 如果大于0，则为滑块上的点设置步骤间隔                                                      |
| [track-color](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-track-color)     | string            | undefined | 设置刻度线颜色                                                                             |
| [thumb-color](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-thumb-color)     | string            | undefined | 设置拇指和拇指标签颜色                                                                     |
| [thumb-label](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-thumb-label)     | boolean \| string | undefined | 显示拇指标签                                                                               |
| [label](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-label)                 | string            | undefined | 设置输入标签                                                                               |
| [value](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-value)                 | any               | undefined | 输入的值                                                                                   |
| [thumb-label](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-thumb-label)     | boolean \| string | undefined | 显示拇指标签                                                                               |
| [ticks](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-ticks)                 | boolean \| string | false     | 显示刻度线。如果 `true` ，使用滑块时将显示刻度线。如果设置为 `'always'` ，它总是显示刻度线 |
| [inverse-label](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-inverse-label) | boolean           | false     | 使用 **rtl** 反转标签位置                                                                  |
| [tick-labels](https://vuetifyjs.com/zh-Hans/api/v-slider/#props-tick-labels)     | array             | []        | 与 Array 一起提供时，将尝试按索引顺序将标签映射到每个步骤                                  |
|                                                                                  |                   |           |                                                                                            |

### v-file-input

`v-file-input`组件的核心是一个基于` v-text-field` 拓展的基本容器

使用 **accpect** 属性，`v-file-input`组件可以选择接收你想要的媒体格式/文件类型，如 `accept="image/png, image/jpeg"`

当 **show-size** 属性和 **counter** 一同启用时，会下输入框下方显示文件总数和大小

#### API

| Name                                                                                     | Type              | Default   | Description                                                                                                                                                                     |
| ---------------------------------------------------------------------------------------- | ----------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [append-icon](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-append-icon)         | string            | undefined | 在组件上附加一个图标，使用与 `v-icon` 相同的语法                                                                                                                                |
| [clearable](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-clearable)             | boolean           | true      | 添加清除已输入内容功能，默认图标是Material Design Icons **mdi-clear**                                                                                                           |
| [truncate-length](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-truncate-length) | number \| string  | 22        | 在用省略号截断之前的文件名的长度                                                                                                                                                |
| [label](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-label)                     | string            | undefined | 设置输入标签                                                                                                                                                                    |
| [loading](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-loading)                 | boolean \| string | false     | 显示线性进度条。可以是指定将哪种颜色应用于进度条的字符串（任何 material 色彩——主要（primary）, 次要（secondary）, 成功（success）, 信息（info），警告（warning），错误（error） |
| [multiple](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-multiple)               | boolean           | false     | 将 **multiple** 属性添加到输入中，允许选择多个文件                                                                                                                              |
| [chips](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-chips)                     | boolean           | false     | 改变一个已选择项为小纸片（chips）的显示方式                                                                                                                                     |
| [show-size](https://vuetifyjs.com/zh-Hans/api/v-file-input/#props-show-size)             | boolean \| number | false     | 设置所选文件的显示大小                                                                                                                                                          |

### v-textarea

`v-textarea ` 最简单的形式是多行文本字段，对于大量文本非常有用

#### API

与 `v-text-feild` 类似

| Name                                                                       | Type             | Default | Description        |
| -------------------------------------------------------------------------- | ---------------- | ------- | ------------------ |
| [no-resize](https://vuetifyjs.com/zh-Hans/api/v-textarea/#props-no-resize) | boolean          | false   | 移除调整大小的句柄 |
| [rows](https://vuetifyjs.com/zh-Hans/api/v-textarea/#props-rows)           | number \| string | 5       | 默认行数           |
|                                                                            |                  |         |                    |

### v-form



## 网格系统

（Grid System）

###  7.1 v-container

`v-container` 提供了将你的网站内容居中和水平填充的功能。 你还可以使用 **fluid** 属性将容器在所有视口和设备尺寸上完全扩展。 

- **fill-height** 将使整个内容 **相对于 page** 居中

### v-row

`v-row` 是 `v-col` 的容器组件。 它使用 flex 属性来控制其内栏的布局和流

| Name                                                              | Type   | Default   | Description                                                                                                                                                                         |
| ----------------------------------------------------------------- | ------ | --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|                                                                   |        |           |                                                                                                                                                                                     |
|                                                                   |        |           |                                                                                                                                                                                     |
| [align](https://vuetifyjs.com/zh-Hans/api/v-row/#props-align)     | string | undefined | 应用 [align-items](https://developer.mozilla.org/en-US/docs/Web/CSS/align-items) css 属性。可用的选项是 **start**, **center**, **end**, **baseline** 和 **stretch**                 |
| [justify](https://vuetifyjs.com/zh-Hans/api/v-row/#props-justify) | string | undefined | 应用 [justify-content](https://developer.mozilla.org/en-US/docs/Web/CSS/justify-content) css 属性。可用选项是 **start**, **center**, **end**, **space-between** 和 **space-around** |
|                                                                   |        |           |                                                                                                                                                                                     |

### v-col

`v-col` 包裹内容，它必须是 `v-row` 的直接子代

| Name                                                          | Type                        | Default | Description                                                     |
| ------------------------------------------------------------- | --------------------------- | ------- | --------------------------------------------------------------- |
| [dense](https://vuetifyjs.com/zh-Hans/api/v-row/#props-dense) | boolean                     | false   | 减少 `v-col` 之间的距离。                                       |
| [cols](https://vuetifyjs.com/zh-Hans/api/v-col/#props-cols)   | boolean \| string \| number | false   | 设置组件扩展的默认列数。可用的选项是 **1 -> 12** 和 **auto** 。 |
| [md](https://vuetifyjs.com/zh-Hans/api/v-col/#props-md)       | boolean \| string \| number | false   | 更改中等和更大断点上的列数，其他断点同理                        |
|                                                               |                             |         |                                                                 |
|                                                               |                             |         |                                                                 |

### v-spacer

`v-spacer` 是一个基本而又通用的间隔组件，用于分配父子组件之间的剩余宽度

## 组

## 样式

### 颜色

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

### 文本

#### 字体强调

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

![image-20210406170957036](http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210406170957036.png)

#### 字体大小

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

#### 文本对齐

**自动对齐**

`.text-justify` 

**指定方向对齐**

`.text-left`

`.text-right`

`.text-center`

`.text-{breakpoint}-{direction}`

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210406214448457.png" alt="image-20210406214448457" style="zoom: 80%;" />

#### 不透明度

`text--primary` 与默认文本具有相同的不透明度。

`text--secondary` 用于提示和辅助文本。 

`text--disabled` 用于去除强调文本

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210406214558337.png" alt="image-20210406214558337" style="zoom: 80%;" />

#### 装饰线

移除文本装饰线

`.text-decoration-none` 

添加上划线

`.text-decoration-overline`

添加下划线线

``.text-decoration-underline`

添加删除线

``.text-decoration-line-through` 

#### 转换大小写

`.text-lowercase`：小写

`.text-uppercase`：大写

`.text-capitalize`：单词首字母大写

### 间距

**格式**：**{property}{direction}-{size}**

<img src="http://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20210406170240133.png" alt="image-20210406170240133" style="zoom: 80%;" />

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

### 显示辅助

#### 设置显示元素

**格式：hidden-{breakpoint}-{condition}**

**condition：**

- `only` - 只在某个指定断点隐藏元素
- `and down` - 在指定的断点和以下隐藏元素, 从 `sm` 到 `lg` 断点
- `and up` - 在指定的断点和以上隐藏元素, 从 `sm` 到 `lg` 断点

https://vuetifyjs.com/zh-Hans/styles/display/#section-53ef89c16027