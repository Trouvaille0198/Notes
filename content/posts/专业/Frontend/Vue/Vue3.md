---
title: "Vue3"
date: 2021-12-22
author: MelonCholi
draft: false
tags: [前端,快速入门,Vue]
categories: [前端]
---

# Vue3

官方文档是最好的教程：https://v3.cn.vuejs.org/guide/

## 认识

```html
<div id="counter">
  Counter: {{ counter }}
</div>
```

```js
const Counter = {
  data() {
    return {
      counter: 0
    }
  },
  mounted() {
    setInterval(() => {
      this.counter++
    }, 1000)
  }
}

Vue.createApp(Counter).mount('#counter')
```

另一个例子

```ts
const app = Vue.createApp({
  data() {
    return { count: 4 }
  },
  methods: {
    increment() {
      // `this` 指向该组件实例
      this.count++
    }
  }
})
const vm = app.mount('#app')
```

### 不成熟的认知习惯

- 在 OptionsAPI 中

    - data 写成函数形式，里面 return 一个对象

    - methods 写成对象形式
    - computed 写成对象形式，里面的计算属性写成函数形式

    - mounted 写成函数形式

### 新特性

- 树摇（Tree shacking）
- 组合式 API（Composition API）

### 安装

- `vue-cli` 基于 `webpack` 封装，生态非常强大，可配置性也非常高，几乎能够满足前端工程化的所有要求。缺点就是配置复杂，甚至有公司有专门的 webpack 工程师专门做配置，另外就是 webpack 由于开发环境需要打包编译，开发体验实际上不如 `vite`。
- `vite` 开发模式基于 `esbuild`，打包使用的是 `rollup`。急速的 `冷启动` 和无缝的 `hmr` 在开发模式下获得极大的体验提升。缺点就是该脚手架刚起步，生态上还不及 `webpack`

#### Vite

vite 是伴随这 Vue3.0 诞生的单文件组件的非打包开发服务器，用来进行 3.0 的编译

安装 vite 命令

```shell
# yarn 安装
yarn global add create-vite-app
# npm 全局安装
npm i -g create-vite-app
```

创建项目

```shell
# 完整命令
create-vite-app <project-name>
# 缩写命令
cva <project-name>

# or 推荐
npm init vite@latest <project-name> -- --template vue
```

配置 `vite.config.ts`

```ts
// vite.config.ts
module.exports = {
  port: 8077, // 服务端口
  proxy: { // 代理
    // string shorthand
    "/foo": "http://localhost:4567/foo",
    // with options
    "/api": {
      target: "http://jsonplaceholder.typicode.com",
      changeOrigin: true,
      rewrite: (path) => path.replace(/^\/api/, ""),
    },
  },
};
```

#### Vue CLI

安装

```shell
npm install -g @vue/cli
```

创建项目

```shell
vue create my-vue3-demo
# 通过可视化工具创建
vue ui
```

启动

```shell
npm run serve
```

` vue.config.js` 配置

```js
// vue.config.js
module.exports = {
  outputDir: 'dist', // 打包的目录
  lintOnSave: true, // 在保存时校验格式
  productionSourceMap: false, // 生产环境是否生成 SourceMap
  devServer: {
    open: true, // 启动服务后是否打开浏览器
    overlay: { // 错误信息展示到页面
      warnings: true,
      errors: true
    },
    host: '0.0.0.0',
    port: 8066, // 服务端口
    https: false,
    hotOnly: false,
    // proxy: { // 设置代理
    //   '/api': {
    //     target: host,
    //     changeOrigin: true,
    //     pathRewrite: {
    //       '/api': '/',
    //     }
    //   },
    // },
  },
}
```

### 一些思想

- 对于任何包含响应式数据的复杂逻辑，都应该使用**计算属性**
    - 我们可以将同一函数定义为一个方法而不是一个计算属性。两种方式的最终结果确实是完全相同的。然而，不同的是**计算属性是基于它们的响应依赖关系缓存的**。计算属性只在相关响应式依赖发生改变时它们才会重新求值。这就意味着只要 `author.books` 还没有发生改变，多次访问 `publishedBookMessage` 计算属性会立即返回之前的计算结果，而不必再次执行函数
    - 但是如果你不希望有缓存，请用 `method` 来替代
    - 当需要在数据变化时执行异步或开销较大的操作时，使用侦听器更为合适。
- 因为 `v-if` 是一个指令，所以必须将它添加到一个元素上。但是如果想切换多个元素呢？此时可以把一个 `<template>` 元素当做不可见的包裹元素，并在上面使用 `v-if`。最终的渲染结果将不包含 `<template>` 元素
- 一般来说，`v-if` 有更高的切换开销，而 `v-show` 有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用 `v-show` 较好；如果在运行时条件很少改变，则使用 `v-if` 较好。
- 建议尽可能在使用 `v-for` 时提供 `key` attribute，如 `v-for="item in items" :key="item.id"`
- 有时，我们想要显示一个数组经过过滤或排序后的版本，而不实际变更或重置原始数据。在这种情况下，可以创建一个计算属性，来返回过滤或排序后的数组
- 类似于 `v-if`，你也可以利用带有 `v-for` 的 `<template>` 来循环渲染一段包含多个元素的内容

### TS 支持

#### 配置文件

```js
// tsconfig.json
{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    // 这样就可以对 `this` 上的数据属性进行更严格的推断
    "strict": true,
    "jsx": "preserve",
    "moduleResolution": "node"
  }
}
```

请注意，必须包含 `strict: true` (或至少包含 `noImplicitThis: true`，它是 `strict` 标志的一部分) 才能在组件方法中利用 `this` 的类型检查，否则它总是被视为 `any` 类型。

如果你使用自定义 Webpack 配置，需要配置 ' ts-loader ' 来解析 vue 文件里的 `<script lang="ts">` 代码块：

```js
// webpack.config.js
module.exports = {
  ...
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: 'ts-loader',
        options: {
          appendTsSuffixTo: [/\.vue$/],
        },
        exclude: /node_modules/,
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader',
      }
      ...
```

#### 定义 Vue 组件

```vue
<script lang="ts">
import { defineComponent } from 'vue'
export default defineComponent({
  // 已启用类型推断
})
</script>
```

## 基本知识

### 组件化

组件系统是 Vue 的另一个重要概念，因为它是一种抽象，允许我们使用小型、独立和通常可复用的组件构建大型应用。仔细想想，几乎任意类型的应用界面都可以抽象为一个组件树：

![Component Tree](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/components.png)

在 Vue 中，组件本质上是一个具有预定义选项的实例。在 Vue 中注册组件很简单：如对 `App` 对象所做的那样创建一个组件对象，并将其定义在父级组件的 `components` 选项中：

```js
// 创建 Vue 应用
const app = Vue.createApp(...)

// 定义名为 todo-item 的新组件
app.component('todo-item', {
  template: `<li>This is a todo</li>`
})

// 挂载 Vue 应用
app.mount(...)
```

现在，你可以将其放到到另一个组件的模板中：

```html
<ol>
  <!-- 创建一个 todo-item 组件实例 -->
  <todo-item></todo-item>
</ol>
```

但是这样会为每个待办项渲染同样的文本。我们应该能将数据从父组件传入子组件才对。让我们来修改一下组件的定义，使之能够接受一个 prop；然后使用 `v-bind` 指令将待办项传到循环输出的每个组件中：

```html
<div id="todo-list-app">
  <ol>
     <!--
      现在我们为每个 todo-item 提供 todo 对象
      todo 对象是变量，即其内容可以是动态的。
      我们也需要为每个组件提供一个“key”，稍后再
      作详细解释。
    -->
    <todo-item
      v-for="item in groceryList"
      v-bind:todo="item"
      v-bind:key="item.id"
    ></todo-item>
  </ol>
</div>
```

```js
const TodoList = {
  data() {
    return {
      groceryList: [
        { id: 0, text: 'Vegetables' },
        { id: 1, text: 'Cheese' },
        { id: 2, text: 'Whatever else humans are supposed to eat' }
      ]
    }
  }
}

const app = Vue.createApp(TodoList)

app.component('todo-item', {
  props: ['todo'],
  template: `<li>{{ todo.text }}</li>`
})

app.mount('#todo-list-app')
```

在一个大型应用中，有必要将整个应用程序划分为多个组件，以使开发更易管理。不过这里有一个 (假想的) 例子，以展示使用了组件的应用模板是什么样的：

```html
<div id="app">
  <app-nav></app-nav>
  <app-view>
    <app-sidebar></app-sidebar>
    <app-content></app-content>
  </app-view>
</div>
```

#### 单个文件组件

在典型的 Vue 应用中，我们使用单个文件组件而不是字符串模板。

#### 在模块系统中局部注册

如果你使用了诸如 Babel 和 webpack 的模块系统。在这些情况下，我们推荐创建一个 `components` 目录，并将每个组件放置在其各自的文件中。

然后你需要在局部注册之前导入每个你想使用的组件。例如，在一个假设的 `ComponentB.js` 或 `ComponentB.vue` 文件中：

```js
import ComponentA from './ComponentA'
import ComponentC from './ComponentC'

export default {
  components: {
    ComponentA,
    ComponentC
  }
  // ...
}
```

现在 `ComponentA` 和 `ComponentC` 都可以在 `ComponentB` 的模板中使用了。

#### 字母不分大小写

另外，HTML attribute 名不区分大小写，因此浏览器将所有大写字符解释为小写。这意味着当你在 DOM 模板中使用时，驼峰 prop 名称和 event 处理器参数需要使用它们的 kebab-cased (横线字符分隔) 等效值：

```js
//  在JavaScript中的驼峰

app.component('blog-post', {
  props: ['postTitle'],
  template: `
    <h3>{{ postTitle }}</h3>
  `
})
```

```html
<!-- 在HTML则是横线字符分割 -->

<blog-post post-title="hello!"></blog-post>
```

### 应用实例

每个 Vue 应用都是通过用 `createApp` 函数创建一个新的**应用实例**开始的：

```js
const app = Vue.createApp({
  /* 选项 */
})
```

该应用实例是用来在应用中注册“全局”组件的。简单的例子：

```js
const app = Vue.createApp({})
app.component('SearchInput', SearchInputComponent)
app.directive('focus', FocusDirective)
app.use(LocalePlugin)
```

应用实例暴露的大多数方法都会返回该同一实例，允许链式：

```js
Vue.createApp({})
  .component('SearchInput', SearchInputComponent)
  .directive('focus', FocusDirective)
  .use(LocalePlugin)
```

#### 根组件与挂载

传递给 `createApp` 的选项用于配置**根组件**。当我们**挂载**应用时，该组件被用作渲染的起点。

一个应用需要被挂载到一个 DOM 元素中。例如，如果你想把一个 Vue 应用挂载到 `<div id="app"></div>`，应该传入 `#app`：

```js
const RootComponent = { 
  /* 选项 */ 
}
const app = Vue.createApp(RootComponent)
const vm = app.mount('#app')
```

> `mount` 不返回应用本身，它返回的是根组件实例

大多数的真实应用都是被组织成一个嵌套的、可重用的组件树。举个例子，一个 todo 应用组件树可能是这样的：

```text
Root Component
└─ TodoList
   ├─ TodoItem
   │  ├─ DeleteTodoButton
   │  └─ EditTodoButton
   └─ TodoListFooter
      ├─ ClearTodosButton
      └─ TodoListStatistics
```

#### 组件实例 property

在 `data` 中定义的 property 是通过组件实例暴露的：

```js
const app = Vue.createApp({
  data() {
    return { count: 4 }
  }
})

const vm = app.mount('#app')

console.log(vm.count) // => 4
```

有各种其他的组件选项，可以将用户定义的 property 添加到组件实例中，例如 `methods`，`props`，`computed`，`inject` 和 `setup`。组件实例的所有 property，无论如何定义，都可以在组件的模板中访问。

Vue 还通过组件实例暴露了一些内置 property，如 `$attrs` 和 `$emit`。这些 property 都有一个 `$` 前缀，以避免与用户定义的 property 名冲突。

####  生命周期钩子

每个组件在被创建时都要经过一系列的初始化过程——例如，需要设置数据监听、编译模板、将实例挂载到 DOM 并在数据变化时更新 DOM 等。同时在这个过程中也会运行一些叫做**生命周期钩子**的函数，这给了用户在不同阶段添加自己的代码的机会。

![实例的生命周期](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/lifecycle.svg)生命周期钩子的 `this` 上下文指向调用它的当前活动实例。

> 不要在选项 property 或回调上使用箭头函数，因为他们没有 `this`

### 模板语法

部分内容详见 [Vue2](../框架/Vue2.md)

#### 动态参数

也可以在指令参数中使用 JavaScript 表达式，方法是用方括号括起来：

```html
<!--
注意，参数表达式的写法存在一些约束，如之后的“对动态参数表达式的约束”章节所述。
-->
<a v-bind:[attributeName]="url"> ... </a>
```

这里的 `attributeName` 会被作为一个 JavaScript 表达式进行动态求值，求得的值将会作为最终的参数来使用。

例如，如果你的组件实例有一个 data property 为 `attributeName`，其值为 `"href"`，那么这个绑定将等价于 `v-bind:href`。

同样地，你可以使用动态参数为一个动态的事件名绑定处理函数：

```html
<a v-on:[eventName]="doSomething"> ... </a>
```

在这个示例中，当 `eventName` 的值为 `"focus"` 时，`v-on:[eventName]` 将等价于 `v-on:focus`

#### 对动态参数表达式约定

动态参数表达式有一些语法约束，因为某些字符，如空格和引号，放在 HTML attribute 名里是无效的。例如：

```html
<!-- 这会触发一个编译警告 -->
<a v-bind:['foo' + bar]="value"> ... </a>
```

变通的办法是使用没有空格或引号的表达式，或用计算属性替代这种复杂表达式。

在 DOM 中使用模板时 (直接在一个 HTML 文件里撰写模板)，还需要避免使用大写字符来命名键名，因为浏览器会把 attribute 名全部强制转为小写：

```html
<!--
在 DOM 中使用模板时这段代码会被转换为 `v-bind:[someattr]`。
除非在实例中有一个名为“someattr”的 property，否则代码不会工作。
-->
<a v-bind:[someAttr]="value"> ... </a>
```

#### 修饰符

修饰符 (modifier) 是以半角句号 `.` 指明的特殊后缀，用于指出一个指令应该以特殊方式绑定。例如，`.prevent` 修饰符告诉 `v-on` 指令对于触发的事件调用 `event.preventDefault()`：

```html
<form v-on:submit.prevent="onSubmit">...</form>
```

在接下来对 `v-on` 和 `v-for`等功能的探索中，将会看到修饰符的其它例子

### Data Property

组件的 `data` 选项是一个函数。Vue 会在创建新组件实例的过程中调用此函数。它应该返回一个对象，然后 Vue 会通过响应性系统将其包裹起来，并以 `$data` 的形式存储在组件实例中。为方便起见，该对象的任何顶级 property 也会直接通过组件实例暴露出来：

```js
const app = Vue.createApp({
  data() {
    return { count: 4 }
  }
})

const vm = app.mount('#app')

console.log(vm.$data.count) // => 4
console.log(vm.count)       // => 4

// 修改 vm.count 的值也会更新 $data.count
vm.count = 5
console.log(vm.$data.count) // => 5

// 反之亦然
vm.$data.count = 6
console.log(vm.count) // => 6
```

直接将不包含在 `data` 中的新 property 添加到组件实例是可行的。但由于该 property 不在背后的响应式 `$data` 对象内，所以 Vue 的响应性系统不会自动跟踪它。

Vue 使用 `$` 前缀通过组件实例暴露自己的内置 API。它还为内部 property 保留 `_` 前缀。你应该避免使用这两个字符开头的的顶级 `data` property 名称

### 防抖和节流

Vue 没有内置支持防抖和节流，但可以使用 [Lodash](https://lodash.com/) 等库来实现。

如果某个组件仅使用一次，可以在 `methods` 中直接应用防抖：

```html
<script src="https://unpkg.com/lodash@4.17.20/lodash.min.js"></script>
<script>
  Vue.createApp({
    methods: {
      // 用 Lodash 的防抖函数
      click: _.debounce(function() {
        // ... 响应点击 ...
      }, 500)
    }
  }).mount('#app')
</script>
```

但是，这种方法对于可复用组件有潜在的问题，因为它们都共享相同的防抖函数。为了使组件实例彼此独立，可以在生命周期钩子的 `created` 里添加该防抖函数:

```js
app.component('save-button', {
  created() {
    // 用 Lodash 的防抖函数
    this.debouncedClick = _.debounce(this.click, 500)
  },
  unmounted() {
    // 移除组件时，取消定时器
    this.debouncedClick.cancel()
  },
  methods: {
    click() {
      // ... 响应点击 ...
    }
  },
  template: `
    <button @click="debouncedClick">
      Save
    </button>
  `
})
```

### 计算属性的 Setter

计算属性默认只有 getter，不过在需要时你也可以提供一个 setter：

```js
// ...
computed: {
  fullName: {
    // getter
    get() {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set(newValue) {
      const names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  } 
}
// ...
```

现在再运行 `vm.fullName = 'John Doe'` 时，setter 会被调用，`vm.firstName` 和 `vm.lastName` 也会相应地被更新。

### 侦听器

虽然计算属性在大多数情况下更合适，但有时也需要一个自定义的侦听器。这就是为什么 Vue 通过 `watch` 选项提供了一个更通用的方法，来响应数据的变化。当需要在数据变化时执行异步或开销较大的操作时，这个方式是最有用的。

例如：

```html
<div id="watch-example">
  <p>
    Ask a yes/no question:
    <input v-model="question" />
  </p>
  <p>{{ answer }}</p>
</div>
```

```html
<!-- 因为 AJAX 库和通用工具的生态已经相当丰富，Vue 核心代码没有重复 -->
<!-- 提供这些功能以保持精简。这也可以让你自由选择自己更熟悉的工具。 -->
<script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script>
  const watchExampleVM = Vue.createApp({
    data() {
      return {
        question: '',
        answer: 'Questions usually contain a question mark. ;-)'
      }
    },
    watch: {
      // whenever question changes, this function will run
      question(newQuestion, oldQuestion) {
        if (newQuestion.indexOf('?') > -1) {
          this.getAnswer()
        }
      }
    },
    methods: {
      getAnswer() {
        this.answer = 'Thinking...'
        axios
          .get('https://yesno.wtf/api')
          .then(response => {
            this.answer = response.data.answer
          })
          .catch(error => {
            this.answer = 'Error! Could not reach the API. ' + error
          })
      }
    }
  }).mount('#watch-example')
</script>
```

在这个示例中，使用 `watch` 选项允许我们执行异步操作 (访问一个 API)，限制我们执行该操作的频率，并在我们得到最终结果前，设置中间状态。这些都是计算属性无法做到的。

### 计算属性 vs 侦听器

Vue 提供了一种更通用的方式来观察和响应当前活动的实例上的数据变动：**侦听属性**。当你有一些数据需要随着其它数据变动而变动时，`watch` 很容易被滥用——特别是如果你之前使用过 AngularJS。然而，通常更好的做法是使用计算属性而不是命令式的 `watch` 回调。细想一下这个例子：

```html
<div id="demo">{{ fullName }}</div>
```

```js
const vm = Vue.createApp({
  data() {
    return {
      firstName: 'Foo',
      lastName: 'Bar',
      fullName: 'Foo Bar'
    }
  },
  watch: {
    firstName(val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName(val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
}).mount('#demo')
```

上面代码是命令式且重复的。将它与计算属性的版本进行比较：

```js
const vm = Vue.createApp({
  data() {
    return {
      firstName: 'Foo',
      lastName: 'Bar'
    }
  },
  computed: {
    fullName() {
      return this.firstName + ' ' + this.lastName
    }
  }
}).mount('#demo')
```

好很多了，不是吗？

### class 的对象语法

#### 在模板里定义对象

我们可以传给 `:class` (`v-bind:class` 的简写) 一个对象，以动态地切换 class：

```html
<div
  class="static"
  :class="{ active: isActive, 'text-danger': hasError }"
></div>
```

```js
data() {
  return {
    isActive: true,
    hasError: false
  }
}
```

渲染的结果为：

```html
<div class="static active"></div>
```

#### 在 data 中定义对象

绑定的数据对象不必内联定义在模板里

```html
<div :class="classObject"></div>
```

```js
data() {
  return {
    classObject: {
      active: true,
      'text-danger': false
    }
  }
}
```

#### 在计算属性里定义对象

我们也可以在这里绑定一个返回对象的计算属性。这是一个常用且强大的模式：

```html
<div :class="classObject"></div>
```

```js
data() {
  return {
    isActive: true,
    error: null
  }
},
computed: {
  classObject() {
    return {
      active: this.isActive && !this.error,
      'text-danger': this.error && this.error.type === 'fatal'
    }
  }
}
```

`style` 也可以用：

```html
<div :style="styleObject"></div>
```

```js
data() {
  return {
    styleObject: {
      color: 'red',
      fontSize: '13px'
    }
  }
}
```

#### 数组语法

我们也可以把一个数组传给 `:class`，以应用一个 class 列表：

```html
<div :class="[activeClass, errorClass]"></div>
```

```js
data() {
  return {
    activeClass: 'active',
    errorClass: 'text-danger'
  }
}
```

渲染的结果为：

```html
<div class="active text-danger"></div>
```

如果你想根据条件切换列表中的 class，可以使用三元表达式：

```html
<div :class="[isActive ? activeClass : '', errorClass]"></div>
```

这样写将始终添加 `errorClass`，但是只有在 `isActive` 为 truthy 时才添加 `activeClass`

不过，当有多个条件 class 时这样写有些繁琐。所以在数组语法中也可以使用对象语法：

```html
<div :class="[{ active: isActive }, errorClass]"></div>
```

### 关于 `v-on` 

#### 事件修饰符

Vue.js 为 `v-on` 提供了**事件修饰符**。之前提过，修饰符是由点开头的指令后缀来表示的。

- `.stop`
- `.prevent`
- `.capture`
- `.self`
- `.once`
- `.passive`

```html
<!-- 阻止单击事件继续传播 -->
<a @click.stop="doThis"></a>

<!-- 提交事件不再重载页面 -->
<form @submit.prevent="onSubmit"></form>

<!-- 修饰符可以串联 -->
<a @click.stop.prevent="doThat"></a>

<!-- 只有修饰符 -->
<form @submit.prevent></form>

<!-- 添加事件监听器时使用事件捕获模式 -->
<!-- 即内部元素触发的事件先在此处理，然后才交由内部元素进行处理 -->
<div @click.capture="doThis">...</div>

<!-- 只当在 event.target 是当前元素自身时触发处理函数 -->
<!-- 即事件不是从内部元素触发的 -->
<div @click.self="doThat">...</div>

<!-- 点击事件将只会触发一次 -->
<a @click.once="doThis"></a>
```

#### 按键修饰符

在监听键盘事件时，我们经常需要检查详细的按键。Vue 允许为 `v-on` 或者 `@` 在监听键盘事件时添加按键修饰符：

```html
<!-- 只有在 `key` 是 `Enter` 时调用 `vm.submit()` -->
<input @keyup.enter="submit" />
```

你可以直接将 [`KeyboardEvent.key`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values) 暴露的任意有效按键名转换为 kebab-case 来作为修饰符。

```html
<input @keyup.page-down="onPageDown" />
```

在上述示例中，处理函数只会在 `$event.key` 等于 `'PageDown'` 时被调用。

##### 按键别名

Vue 为最常用的键提供了别名：

- `.enter`
- `.tab`
- `.delete` (捕获“删除”和“退格”键)
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

##### 系统修饰键

可以用如下修饰符来实现仅在按下相应按键时才触发鼠标或键盘事件的监听器。

- `.ctrl`
- `.alt`
- `.shift`
- `.meta`

```html
<!-- Alt + Enter -->
<input @keyup.alt.enter="clear" />

<!-- Ctrl + Click -->
<div @click.ctrl="doSomething">Do something</div>
```

##### `.exact` 修饰符

`.exact` 修饰符允许你控制由精确的系统修饰符组合触发的事件。

```html
<!-- 即使 Alt 或 Shift 被一同按下时也会触发 -->
<button @click.ctrl="onClick">A</button>

<!-- 有且只有 Ctrl 被按下的时候才触发 -->
<button @click.ctrl.exact="onCtrlClick">A</button>

<!-- 没有任何系统修饰符被按下的时候才触发 -->
<button @click.exact="onClick">A</button>
```

##### 鼠标按钮修饰符

- `.left`
- `.right`
- `.middle`

这些修饰符会限制处理函数仅响应特定的鼠标按钮。

### 关于 `v-model`

#### 修饰符

##### `.lazy`

在默认情况下，`v-model` 在每次 `input` 事件触发后将输入框的值与数据进行同步 (除了输入法组织文字时)。你可以添加 `lazy` 修饰符，从而转为在 `change` 事件_之后_进行同步：

```html
<!-- 在“change”时而非“input”时更新 -->
<input v-model.lazy="msg" />
```

##### `.number`

如果想自动将用户的输入值转为数值类型，可以给 `v-model` 添加 `number` 修饰符：

```html
<input v-model.number="age" type="number" />
```

这通常很有用，因为即使在 `type="number"` 时，HTML 输入元素的值也总会返回字符串。如果这个值无法被 `parseFloat()` 解析，则会返回原始的值。

##### `.trim`

如果要自动过滤用户输入的首尾空白字符，可以给 `v-model` 添加 `trim` 修饰符：

```html
<input v-model.trim="msg" />
```

## Composition API

### 结构示例

#### OptionAPI

```vue
<template>
  <div>
  </div>
</template>

<script>
export default {
  name: '',
  components: {},
  props: {},
  data() {
    return {}
  },
  watch: {},
  created() {},
  mounted() {},
  methods: {}
}
</script>

<style  lang="scss" scoped></style>
```

#### CompositionAPI

```vue
<template> </template>
<script lang="ts">
  import { defineComponent, onMounted, reactive, UnwrapRef, watch } from 'vue';

  interface State {}
  export default defineComponent({
    name: 'components name',
    props: {},
    setup(props) {
      console.log('props: ', props);
      //data
      const state: UnwrapRef<State> = reactive({});

      //Lifecycle Hooks
      onMounted(() => {});
      //watch
      watch(
        () => props,
        (_count, _prevCount) => {},
        {
          deep: true,
          immediate: true,
        }
      );
      //methods
      const getList = () => {};
      
      return {
        state,
        getList
      };
    },
  });
</script>
<style lang="scss" scoped></style>
```

（组合式 API）

一些基础性的总结：https://juejin.cn/post/7008063765585330207

https://segmentfault.com/a/1190000040319089

https://www.jianshu.com/p/5996f611c990

![img](https://pic1.zhimg.com/80/v2-b72736d77cfceecc80a2b1497c649e54_1440w.jpg?source=1940ef5c)

### setup

`setup` 是一个组件选项，所以像别的组件选项一样，写在组件导出的对象里。

```xml
<script>
  export default {
    name: "App",
    setup() {
      // ...

      return {
        // ...
      }
    },
  }
</script>
```

1. `setup` 选项应该为一个函数
2. `setup` 选项函数接受两个参数： `props` 和 `context`
3. `setup` 选项函数需要返回要暴露给组件的内容

#### 参数

##### props

正如在一个标准组件中所期望的那样，`setup` 函数中的 `props` 是响应式的，当传入新的 prop 时，它将被更新。

```jsx
// MyBook.vue

export default {
  props: {
    title: String
  },
  setup(props) {
    console.log(props.title)
  }
}
```

但是，因为 `props` 是响应式的，你**不能使用 ES6 解构**，因为它会消除 prop 的响应性。
如果需要解构 prop，可以通过使用 `setup` 函数中的 `toRefs` 来安全地完成此操作。

```jsx
import { toRefs } from 'vue'

setup(props) {
    const { title } = toRefs(props)

    console.log(title.value)
}
```

##### context

`context` 上下文是一个普通的 JavaScript 对象，它暴露三个组件的 property：

```ts
// MyBook.vue
export default {
  setup(props, context) {
    // Attribute (非响应式对象)
    console.log(context.attrs)

    // 插槽 (非响应式对象)
    console.log(context.slots)

    // 触发事件 (方法)
    console.log(context.emit)
  }
}
```

`context` 是一个普通的 JavaScript 对象，也就是说，它不是响应式的，这意味着你可以安全地对 `context` 使用 ES6 解构。

```ts
// MyBook.vue
export default {
  setup(props, { attrs, slots, emit }) {
    ...
  }
}
```

`attrs` 和 `slots` 是有状态的对象，它们总是会随组件本身的更新而更新。这意味着你应该避免对它们进行解构，并始终以 `attrs.x` 或 `slots.x` 的方式引用 property。请注意，与 `props` 不同，`attrs` 和 `slots` 是非响应式的。如果你打算根据 `attrs` 或 `slots` 更改应用副作用，那么应该在 `onUpdated` 生命周期钩子中执行此操作。

#### 返回值

##### 对象

如果 `setup` 返回一个对象，则可以在组件的模板中像传递给 `setup` 的 `props` property 一样访问该对象的 property：

```html
<!-- MyBook.vue -->
<template>
  <!-- 模板中使用会被自动解开，所以不需要 .value  -->
  <div>{{ readersNumber }} {{ book.title }}</div>
</template>

<script>
  import { ref, reactive } from 'vue'

  export default {
    setup() {
      const readersNumber = ref(0)
      const book = reactive({ title: 'Vue 3 Guide' })

      // expose to template
      return {
        readersNumber,
        book
      }
    }
  }
</script>
```

> 注意，从 `setup` 返回的 [refs](https://links.jianshu.com/go?to=https%3A%2F%2Fvue3js.cn%2Fdocs%2Fzh%2Fapi%2Frefs-api.html%23ref) 在模板中访问时是[被自动解开](https://links.jianshu.com/go?to=https%3A%2F%2Fvue3js.cn%2Fdocs%2Fzh%2Fguide%2Freactivity-fundamentals.html%23ref-%E8%A7%A3%E5%BC%80)的，因此不应在模板中使用 `.value`。

##### 渲染函数

`setup` 还可以返回一个渲染函数，该函数可以直接使用在同一作用域中声明的响应式状态：

```jsx
// MyBook.vue

import { h, ref, reactive } from 'vue'

export default {
  setup() {
    const readersNumber = ref(0)
    const book = reactive({ title: 'Vue 3 Guide' })
    // Please note that we need to explicitly expose ref value here
    return () => h('div', [readersNumber.value, book.title])
  }
}
```

新的 `setup` 组件选项在**创建组件之前**执行，一旦 `props` 被解析，并充当合成 API 的入口点。

#### 不用 this

在 `setup()` 内部，`this` 不会是该活跃实例的引用，因为 `setup()` 是在解析其它组件选项之前被调用的，所以 `setup()` 内部的 `this` 的行为与其它选项中的 `this` 完全不同。这在和其它选项式 API 一起使用 `setup()` 时可能会导致混淆。

### ref 与 reactive

reactive 和 ref 都是用来定义响应式数据的

reactive 更推荐去定义复杂的数据类型，ref 更推荐定义基本类型

可以简单的理解为：ref 是对 reactive 的二次包装，ref 定义的数据访问的时候要多一个 `.value`

> toRefs API 提供了一个方法可以把 reactive 的值处理为 ref

#### reactive

`reactive()` 接收一个普通对象然后返回该普通对象的响应式代理。等同于 2.x 的 `Vue.observable()`

```ts
const obj = reactive({ count: 0 })
```

响应式转换是“深层的”：会影响对象内部所有嵌套的属性。基于 ES2015 的 Proxy 实现，返回的代理对象**不等于**原始对象。建议仅使用代理对象而避免依赖原始对象。

```html
<template>
  <div id="app">{ state.count }</div>
</template>

<script>
import { reactive } from 'vue'
export default {
  setup() {
    // state 现在是一个响应式的状态
    const state = reactive({
      count: 0,
    })
  }
}
</script>
```

#### ref

接受一个参数值并返回一个响应式且可改变的 ref 对象。ref 对象拥有一个指向内部值的单一属性 `.value`

```ts
const count = ref(0)
console.log(count.value) // 0

count.value++
console.log(count.value) // 1
```

如果传入 ref 的是一个对象，将调用 `reactive` 方法进行深层响应转换。

##### **模板中访问**

当 ref 作为渲染上下文的属性返回（即在`setup()` 返回的对象中）并在模板中使用时，它会自动解套，无需在模板内额外书写 `.value`：

```html
<template>
  <div>{{ count }}</div>
</template>

<script>
  export default {
    setup() {
      return {
        count: ref(0),
      }
    },
  }
</script>
```

##### **作为响应式对象的属性访问**

当 ref 作为 reactive 对象的 property 被访问或修改时，也将自动解套 value 值，其行为类似普通属性：

```ts
const count = ref(0)
const state = reactive({
  count,
})

console.log(state.count) // 0

state.count = 1
console.log(count.value) // 1
```

注意如果将一个新的 ref 分配给现有的 ref， 将替换旧的 ref：

```ts
const otherCount = ref(2)

state.count = otherCount
console.log(state.count) // 2
console.log(count.value) // 1
```

注意当嵌套在 reactive `Object` 中时，ref 才会解套。从 `Array` 或者 `Map` 等原生集合类中访问 ref 时，不会自动解套：

```ts
const arr = reactive([ref(0)])
// 这里需要 .value
console.log(arr[0].value)

const map = reactive(new Map([['foo', ref(0)]]))
// 这里需要 .value
console.log(map.get('foo').value)
```

##### **类型定义**

```ts 
interface Ref<T> {
  value: T
}

function ref<T>(value: T): Ref<T>
```

有时我们可能需要为 ref 做一个较为复杂的类型标注。我们可以通过在调用 `ref` 时传递泛型参数来覆盖默认推导：

```ts
const foo = ref<string | number>('foo') // foo 的类型: Ref<string | number>

foo.value = 123 // 能够通过！
```

#### 例

```vue
<template>
  <div>{{count}}
    <button @click="changeCount">添加</button>
  </div>
  <div>学生的姓名是:{{student.name}}</div>
  <div>学生的年龄是:{{student.age}}
    <button @click="changeStudentAge(20)">添加</button>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, reactive } from 'vue';

export default defineComponent({
  name: 'Home',
  setup () {
    const count = ref(0)
    const changeCount = () => {
      count.value = count.value + 1
    }
    const student = reactive({
      name: 'Bob',
      age: 12
    })
    const changeStudentAge = (age: number) => {
      student.age = age
    }
    return {
      count,
      changeCount,
      student,
      changeStudentAge
    }
  }
});
</script>
```

### computed

使用响应式 `computed` API 有两种方式：

1. 传入一个 getter 函数，返回一个默认不可手动修改的 ref 对象。

```csharp
const count = ref(1)
const plusOne = computed(() => count.value + 1)

console.log(plusOne.value) // 2

plusOne.value++ // 错误！
```

2. 传入一个拥有 `get` 和 `set` 函数的对象，创建一个可手动修改的计算状态。

```csharp
const count = ref(1)
const plusOne = computed({
  get: () => count.value + 1,
  set: (val) => {
    count.value = val - 1
  },
})

plusOne.value = 1
console.log(count.value) // 0
```

### watch

- 引入 watch， `import { watch } from 'vue'`

- 直接使用 watch，watch 接受 3 个参数

    1. 要监听更新的响应式引用或者 getter 函数

    2. 一个回调用来做更新后的操作

    3. 可选配置项

```ts
 setup() {
     const count = ref(0)
     //监听count
     watch(
         () = > count, (_count, _prevCount) = > {}, {
             deep: true,
             immediate: true
         }
     );
 }
```

```vue
<template>
  <div>{{count}}</div>
  <div>{{doubleCount}}</div>
  <button @click="addCount">添加</button>
</template>

<script lang="ts">
import { defineComponent, ref, computed, watchEffect, watch } from 'vue';

export default defineComponent({
  name: 'App',
  setup () {
    const count = ref(0)
    watch(count, (newValue, oldValue) => { // 如多个则用数组的方式传入[count, count1]
      console.log(`newValue为：${newValue},--------oldValue为：${oldValue}`)
    })
    watchEffect(() => {
      console.log('watchEffect', count.value)
    })
    const addCount = () => {
      count.value++
    }
    const doubleCount = computed(() => {
      return count.value * 2
    })
    return {
      count,
      doubleCount,
      addCount
    }
  }
});
</script>
```

### props/$emit

父子组件传值的写法

- 父组件

```elixir
<Search @searchData="searchData" :quaryParams="quaryParams"/>
```

父组件的写法和`vue`还是一样的，只是子组件需要作一些改变

- 子组件

```typescript
<script lang="ts">
import { defineComponent } from 'vue';
interface GetUserListParams {
    pageNum: number;
    pageSize: number;
    roleName: string;
}
export default defineComponent({
    name: 'Search',
    props: {
        quaryParams: {
            type: Object as PropType<GetUserListParams> ,
            default: () = > ({
                pageNum: 1,
                pageSize: 10,
                roleName: ''
            })
        }
    },
    emits: ['searchData'],//需要声明emits
    setup(_props, context) {
    
      const onSubmit = () => {
        context.emit('searchData', "我是子节点传递给父节点的值");
      }
      
      return {
        getData
      }
    }
});
</script>
```

### 跨组件传值

在 `Vue 2` 中，我们可以使用 `Provide/Inject` 跨组件传值，在 Vue 3 中也可以。

在 `setup` 中 使用，必须从 `vue` 中导入使用。

使用 `Provide` 时，一般设置为 响应式更新的，这样的话，父组件变更，子组件，子孙组件也跟着更新。

#### 怎么设置为响应式更新呢？

> 1. 使用 `ref` / `reactive` 创建响应式变量
> 2. 使用 `provide('name', '要传递的响应式变量')`
> 3. 最后添加一个更新 响应式变量的事件，这样响应式变量更新，` provide` 中的变量也跟着更新

#### 父组件

```vue
<template>
  
  <Son/>
  
</template>


<script>
    import { provide, defineComponent, ref, reactive } from "vue";
    export default defineComponent({
    setup() {
            const father = ref("我父组件");
    const info = reactive({
      id: 23,
      message: "前端自学社区",
    });
    function changeProvide(){
      info.message = '测试'
    }
    provide('father',father)
    provide('info',info)
    return {changeProvide};
    }
    
})
</script>
```

#### 子组件

```vue
<template>
    <div>
        <h1>{{info.message}}</h1>
        <h1>{{fatherData}}</h1>
    </div>
</template>

<script>
import {provide, defineComponent,ref,reactive, inject} from 'vue'
export default defineComponent({
    setup () {
        const fatherData = inject('father')
        const info = inject('info')
        
        return {fatherData,info}
    }
})
</script>
```



### 模块化

往往是把一个功能的所有状态、方法、都封装到一个函数里面，方便统一管理

将相关功能提取到一个独立的组合式函数中

```js
// src/composables/useUserRepositories.js

import { fetchUserRepositories } from '@/api/repositories'
import { ref, onMounted, watch } from 'vue'

export default function useUserRepositories(user) {
  const repositories = ref([])
  const getUserRepositories = async () => {
    repositories.value = await fetchUserRepositories(user.value)
  }

  onMounted(getUserRepositories)
  watch(user, getUserRepositories)

  return {
    repositories,
    getUserRepositories
  }
}
```

当我们哪个功能需要再其他组件被复用的时候，直接把相关的方法提取出去，然后再引用进来就可以了

```js
// src/components/UserRepositories.vue
import { toRefs } from 'vue'
import useUserRepositories from '@/composables/useUserRepositories'
import useRepositoryNameSearch from '@/composables/useRepositoryNameSearch'
import useRepositoryFilters from '@/composables/useRepositoryFilters'

export default {
  components: { RepositoriesFilters, RepositoriesSortBy, RepositoriesList },
  props: {
    user: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const { user } = toRefs(props)

    const { repositories, getUserRepositories } = useUserRepositories(user)

    const {
      searchQuery,
      repositoriesMatchingSearchQuery
    } = useRepositoryNameSearch(repositories)

    const {
      filters,
      updateFilters,
      filteredRepositories
    } = useRepositoryFilters(repositoriesMatchingSearchQuery)

    return {
      // 因为我们并不关心未经过滤的仓库
      // 我们可以在 `repositories` 名称下暴露过滤后的结果
      repositories: filteredRepositories,
      getUserRepositories,
      searchQuery,
      filters,
      updateFilters
    }
  }
}
```

### defineComponent

最主要的功能是为了 ts 下的类型推导

如果我们直接写

```ts
export default {}
```

这个时候，对于编辑器而言，{} 只是一个 Object 的类型，无法有针对性的提示我们对于 vue 组件来说 {} 里应该有哪些属性。但是增加一层 defineComponet 的话，

```ts
export default defineComponent({})
```

这时，{} 就变成了 defineComponent 的参数，那么对参数类型的提示，就可以实现对 {} 中属性的提示，外还可以进行对参数的一些类型推导等操作。

### 与 TS 的结合

#### 接口约束约束属性

> 采用 `TypeScirpt` 的特性， 类型断言 + 接口 完美的对 属性进行了 约束

##### `interface`

```javascript
分页查询 字段属性类型验证
export default  interface queryType{
    page: Number,
    size: Number,
    name: String,
    age:  Number
}
```

##### 组件中使用

```typescript
import queryType from '../interface/Home'


    data() {
        return {
            query:{
                page:0,
                size:10,
                name:'测试',
                age: 2
            } as queryType
        }
    },
```

#### 组件使用 `defineComponent` 来定义

> 这样 `TypeScript` 正确推断 `Vue` 组件选项中的类型

```javascript
import { defineComponent } from 'vue'

export default defineComponent({
    setup(){
        return{ }
    }
})
```

#### 类型声明 `reactive`

```javascript
export default  interface Product {
    name:String,
    price:Number,
    address:String
}



import  Product from '@/interface/Product' 
import {reactive} from 'vue'
const product = reactive({name:'xiaomi 11',price:5999,address:'北京'}) as Product
       
return {fatherData,info,product}
```

### setup script

setup script 是 vue3 新出的一个语法糖，使用方法就是在书写 script 标签的时候在其后面加上一个 `setup` 修饰。

```vue
<script setup></script>
```

#### 自动注册子组件

普通语法

```vue
<template>
  <div>
    <h2>我是父组件!</h2>
    <Child />
  </div>
</template>

<script>
import { defineComponent, ref } from 'vue';
import Child from './Child.vue'

export default defineComponent({
  components: {
      Child
  },
  setup() {

    return {
      
    }
  }
});
</script>
```

vue3 语法在引入 Child 组件后，需要在 components 中注册对应的组件才可使用。

setup script 写法

```vue
<template>
  <div>
    <h2>我是父组件!-setup script</h2>
    <Child />
  </div>
</template>

<script setup>
import Child from './Child.vue'

</script>
```

#### 属性和方法无需返回

```vue
<template>
  <div>
    <h2 @click="ageInc">{{ name }} is {{ age }}</h2>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const name = ref('CoCoyY1')
const age = ref(18)

const ageInc = () => {
  age.value++
}

</script>
```

#### 支持 props、emit 和 context

普通语法

```vue
//Father.vue
<template>
  <div >
    <h2 >我是父组件！</h2>
    <Child msg="hello" @child-click="childCtx" />
  </div>
</template>

<script>
import { defineComponent, ref } from 'vue';
import Child from './Child.vue';

export default defineComponent({
  components: {
    Child
  },
  setup(props, context) {
    const childCtx = (ctx) => {
      console.log(ctx);
    }

    return {
      childCtx
    }
  }
})
</script>


//Child.vue
<template>
  <span @click="handleClick">我是子组件! -- msg: {{ props.msg }}</span>
</template>

<script>
import { defineComponent, ref } from 'vue'

export default defineComponent({
  emits: [
    'child-click'
  ],
  props: {
    msg: String
  },
  setup(props, context) {
    const handleClick = () => {
      context.emit('child-click', context)
    }

    return {
      props,
      handleClick
    }
  },
})
</script>
```

setup script 语法

```vue
<script setup>
const props = defineProps({
  foo: String
})

const emit = defineEmits(['change', 'delete'])
// setup code
</script>
```

setup script 语法糖提供了三个新的 API 来供我们使用：`defineProps`、`defineEmits`和 `useContext`。

其中 `defineProps` 用来接收父组件传来的值 props。`defineEmits` 用来声明触发的事件表。`useContext` 用来获取组件上下文 context。

- `defineProps` 和 `defineEmits` 都是只在 `<script setup>` 中才能使用的**编译器宏**。他们不需要导入且会随着 `<script setup>` 处理过程一同被编译掉。
- `defineProps` 接收与 `props` 选项相同的值，`defineEmits` 也接收 `emits` 选项相同的值。
- `defineProps` 和 `defineEmits` 在选项传入后，会提供恰当的类型推断。

# 技巧

