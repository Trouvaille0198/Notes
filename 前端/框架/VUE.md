# 一、认识

## 1.1 概念

Vue.js 的核心是一个允许采用简洁的模板语法来声明式地将数据渲染进 DOM 的系统

```html
<div id="app">
  {{ message }}
</div>
```

```javascript
var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})
```

`v-` attribute 被称为**指令**。指令带有前缀 `v-`，以表示它们是 Vue 提供的特殊 attribute。

它们会在渲染的 DOM 上应用特殊的响应式行为

- JavaScript 框架
- 简化 Dom 操作
- 响应式数据驱动

## 1.2 核心

1. 数据绑定
2. 事件绑定
3. 用户输入获取
4. 组件定义和使用

## 1.3 引入

### 1.3.1 CDN

```html
<!-- 开发环境版本，包含了有帮助的命令行警告 -->
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

<!-- 生产环境版本，优化了尺寸和速度 -->
<script src="https://cdn.jsdelivr.net/npm/vue"></script>
```

### 1.3.2 Vue CLI

安装

```bash
npm install -g @vue/cli
```

升级

```bash
npm update -g @vue/cli
```

创建项目

```bash
vue create project-name
```

安装必要工具

```bash
npm install
```

开启本地端口

```bash
npm run serve
```

# 二、基础

## 2.1 Vue 实例

```javascript
var app = new Vue({
    el:"#app",
    data:{
        message:"Hello World",
        array:[],
		obj:{},
    }
})
```

- el：挂载点，
    - Vue 会管理 el 选项命中的元素及其内部的后代元素
    - 可以挂载到双标签上，不能使用 HTML 和 BODY
- data：数据对象
    - Vue 中用到的数据定义在 data 中
    - data 中可以写复杂类型的数据
    - 渲染复杂类型数据时,遵守 js 的语法即可

## 2.2 Vue 指令

Vue 指令指的是,以 v- 开头的一组特殊语法


### 2.2.1 v-text

设置标签的文本值 (textContent)

支持在内部写表达式，如 `v-text="message + '!'"`

v-text 指令无论内容是什么,只会解析为文本

```javascript
var app = new Vue({
    el: "#app",
    data: {
        message: "Hello"
    }
})
```

默认写法：在文本标签中添加 `v-text` 属性值，会替换全部内容
```html
<div id="app">
    <h2 v-text="message"></h2>
</div>
```

差值表达式 `{{}}` 可以替换指定内容
```html
<div id='app'>
        <p>{{message + '!'}}</p>
</div>
```

### 2.2.2 v-html

设置标签的 innerHTML

若内容中有 html 结构，会被解析为标签，如 `content:"<a href='#'>Hello World</a>"`

辨析：解析文本使用 v-text,需要解析 html 结构使用 v-html

```javascript
var app = new Vue({
    el:"#app",
    data:{
        content:"Hello World"
    }
})
```

```html
<div id="app">
    <p v-html="content"></p>
</div>
```

### 2.2.3 v-on

为元素绑定事件

- 事件名不需要写 on

- 指令可以简写为 @

- 绑定的方法定义在 methods 属性中

- 方法内部通过 this 关键字可以访问定义在 data 中数据

```javascript
var app = new Vue({
    el: "#app",
    methods: {
        doIt: function () {
            // ...
        }
    }
})
```

```HTML
<div id="app">
    <input type="button" value="bind1" v-on:click="doIt">
    <input type="button" value="bind2" v-on:monseenter="doIt">
    <input type="button" value="bind3" v-on:dblclick="doIt">
    <input type="button" value="bind4" @dblclick="doIt">
</div>
```

#### 1）例：计数器

```html
<div id="app">
    <input type='button' value='-' v-on:click='sub'>
    <span>{{value}}</span>
    <input type='button' value='+' v-on:click='add'>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script>
    var app = new Vue({
        el: "#app",
        data: {
            value: 1
        },
        methods: {
            sub: function () {
                this.value -= 1;
            },
            add: function () {
                this.value += 1;
            }
        },
    })
</script>
```

#### 2）修饰符

事件的后面跟上 `.修饰符` 可以对事件进行限制

- `.stop` - 调用 `event.stopPropagation()`。
- `.prevent` - 调用 `event.preventDefault()`。
- `.capture` - 添加事件侦听器时使用 capture 模式。
- `.self` - 只当事件是从侦听器绑定的元素本身触发时才触发回调。
- `.{keyCode | keyAlias}` - 只当事件是从特定键触发时才触发回调。
- `.native` - 监听组件根元素的原生事件。
- `.once` - 只触发一次回调。
- `.left` - (2.2.0) 只当点击鼠标左键时触发。
- `.right` - (2.2.0) 只当点击鼠标右键时触发。
- `.middle` - (2.2.0) 只当点击鼠标中键时触发。
- `.passive` - (2.3.0) 以 `{ passive: true }` 模式添加侦听器

```html
<!-- 方法处理器 -->
<button v-on:click="doThis"></button>

<!-- 动态事件 (2.6.0+) -->
<button v-on:[event]="doThis"></button>

<!-- 内联语句 -->
<button v-on:click="doThat('hello', $event)"></button>

<!-- 缩写 -->
<button @click="doThis"></button>

<!-- 动态事件缩写 (2.6.0+) -->
<button @[event]="doThis"></button>

<!-- 停止冒泡 -->
<button @click.stop="doThis"></button>

<!-- 阻止默认行为 -->
<button @click.prevent="doThis"></button>

<!-- 阻止默认行为，没有表达式 -->
<form @submit.prevent></form>

<!--  串联修饰符 -->
<button @click.stop.prevent="doThis"></button>

<!-- 键修饰符，键别名 -->
<input @keyup.enter="onEnter">

<!-- 键修饰符，键代码 -->
<input @keyup.13="onEnter">

<!-- 点击回调只会触发一次 -->
<button v-on:click.once="doThis"></button>

<!-- 对象语法 (2.4.0+) -->
<button v-on="{ mousedown: doThis, mouseup: doThat }"></button>
```

### 2.2.4 v-show

根据表达值的真假，切换元素的显示和隐藏

- 原理是修改元素的 display，实现显示隐藏
- 指令后面的内容，最终都会解析为布尔值 

```javascript
var app = new Vue({
    el:"#app",
    data:{
        isShow:false,
        age:16
    }
})
```

```html
<div id="app">
    <img src="地址" v-show="true">
    <img src="地址" v-show="isShow">
    <img src="地址" v-show="age>=18">
</div>
```

### 2.2.5 v-if

根据表达值的真假,切换元素的显示和隐藏 (操纵 dom 元素)

- 本质是通过操纵 dom 元素来切换显示状态
- 表达式的值为 true,元素存在于 dom 树中,为 false，从 dom 树中移除
- 辨析：频繁的切换使用 v-show，偶尔切换使用v-if，前者的切换消耗小

```javascript
var app = new Vue({
    el:"#app",
    data:{
        isShow:false,
    }
})
```

```html
    <div id="app">
      <p v-if="true">我是一个p标签</p>
      <p v-if="isShow">我是一个p标签</p>
      <p v-if="表达式">我是一个p标签</p>
    </div>
```

### 2.2.6 v-bind

设置元素的属性：`v-bind:属性名=表达式`

- 可以用 `:` 简写
- 需要动态的增删 class 建议使用对象的方式

```javascript
var app = new Vue({
    el:"#app",
    data:{
        imgSrc:"picture-path",
        imgTitle:"text",
        isActive:false
    }
})
```

```html
<div id="app">
    <img v-bind:src= "imgSrc" >
    <img v-bind:title="imgTitle+'!'">
    <img v-bind:class="isActive?'active':''">
    <img v-bind:class="{active:isActive}">
</div>
```

### 2.2.7 v-for

根据数据生成列表结构

- 语法：`(item, index) in array`
- item 和 index 可以结合其他指令一起使用
- 数组长度的更新会同步到页面上,是响应式的

```javascript
var app = new Vue({
    el: "#app",
    data: {
        arr: ['a', 'b', 'c', 'd', 'e'],
        objArr: [
            { name: 'Mike' },
            { name: 'Jack' }
        ]
    }
})
```

```html
<div id="app">
    <ul>
        <li v-for="(item,index) in arr" :title='item'>
            {{index}} -> {{ item }}
        </li>

        <li v-for="item in objArr">
            {{ item.name }}
        </li>
    </ul>
</div>
```

### 2.2.8 v-model

获取和设置表单元素的值 (双向数据绑定)

- 绑定的数据会和表单元素值相关联

```html
<div id="app">
    <input type="text" v-model="message" />
</div>
```

# 三、axios

## 3.1 介绍

Axios 是一个基于 promise 的 HTTP 库，可以用在浏览器和 node.js 中。

### 3.1.1 引入

使用 npm:

```
$ npm install axios
```

使用 bower:

```
$ bower install axios
```

使用 cdn:

```
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
```

### 3.1.2 样例

```javascript
axios({
    method: 'GET',
    url: url,
})
.then(res => {console.log(res)})
.catch(err => {console.log(err)})

axios.post('/user', {
    firstName: 'Mike',
    lastName: 'Allen'
}).then( res => {
    console.info(res)
}).catch( e => {
    console.info(e)
})
```

## 3.2 使用

### 3.2.1 axios(config)

```javascript
// 发送 POST 请求
axios({
  method: 'post',
  url: 'www.google.com',
  data: {
    firstName: 'Fred',
    lastName: 'Flintstone'
  }
});
```

### 3.2.2 axios(url[, config])

```javascript
// 发送 GET 请求（默认的方法）
axios('/user/12345');
```

### 3.2.3 别名

***axios.get(url[, config])***

***axios.post(url[, data[, config]])***

## 3.3 配置项

```javascript
{
  // `url` 是用于请求的服务器 URL
  url: '/user',

  // `method` 是创建请求时使用的方法
  method: 'get', // 默认是 get

  // `baseURL` 将自动加在 `url` 前面，除非 `url` 是一个绝对 URL。
  // 它可以通过设置一个 `baseURL` 便于为 axios 实例的方法传递相对 URL
  baseURL: 'https://some-domain.com/api/',

  // `transformRequest` 允许在向服务器发送前，修改请求数据
  // 只能用在 'PUT', 'POST' 和 'PATCH' 这几个请求方法
  // 后面数组中的函数必须返回一个字符串，或 ArrayBuffer，或 Stream
  transformRequest: [function (data) {
    // 对 data 进行任意转换处理

    return data;
  }],

  // `transformResponse` 在传递给 then/catch 前，允许修改响应数据
  transformResponse: [function (data) {
    // 对 data 进行任意转换处理

    return data;
  }],

  // `headers` 是即将被发送的自定义请求头
  headers: {'X-Requested-With': 'XMLHttpRequest'},

  // `params` 是即将与请求一起发送的 URL 参数
  // 必须是一个无格式对象(plain object)或 URLSearchParams 对象
  params: {
    ID: 12345
  },

  // `paramsSerializer` 是一个负责 `params` 序列化的函数
  // (e.g. https://www.npmjs.com/package/qs, http://api.jquery.com/jquery.param/)
  paramsSerializer: function(params) {
    return Qs.stringify(params, {arrayFormat: 'brackets'})
  },

  // `data` 是作为请求主体被发送的数据
  // 只适用于这些请求方法 'PUT', 'POST', 和 'PATCH'
  // 在没有设置 `transformRequest` 时，必须是以下类型之一：
  // - string, plain object, ArrayBuffer, ArrayBufferView, URLSearchParams
  // - 浏览器专属：FormData, File, Blob
  // - Node 专属： Stream
  data: {
    firstName: 'Fred'
  },

  // `timeout` 指定请求超时的毫秒数(0 表示无超时时间)
  // 如果请求话费了超过 `timeout` 的时间，请求将被中断
  timeout: 1000,

  // `withCredentials` 表示跨域请求时是否需要使用凭证
  withCredentials: false, // 默认的

  // `adapter` 允许自定义处理请求，以使测试更轻松
  // 返回一个 promise 并应用一个有效的响应 (查阅 [response docs](#response-api)).
  adapter: function (config) {
    /* ... */
  },

  // `auth` 表示应该使用 HTTP 基础验证，并提供凭据
  // 这将设置一个 `Authorization` 头，覆写掉现有的任意使用 `headers` 设置的自定义 `Authorization`头
  auth: {
    username: 'janedoe',
    password: 's00pers3cret'
  },

  // `responseType` 表示服务器响应的数据类型，可以是 'arraybuffer', 'blob', 'document', 'json', 'text', 'stream'
  responseType: 'json', // 默认的

  // `xsrfCookieName` 是用作 xsrf token 的值的cookie的名称
  xsrfCookieName: 'XSRF-TOKEN', // default

  // `xsrfHeaderName` 是承载 xsrf token 的值的 HTTP 头的名称
  xsrfHeaderName: 'X-XSRF-TOKEN', // 默认的

  // `onUploadProgress` 允许为上传处理进度事件
  onUploadProgress: function (progressEvent) {
    // 对原生进度事件的处理
  },

  // `onDownloadProgress` 允许为下载处理进度事件
  onDownloadProgress: function (progressEvent) {
    // 对原生进度事件的处理
  },

  // `maxContentLength` 定义允许的响应内容的最大尺寸
  maxContentLength: 2000,

  // `validateStatus` 定义对于给定的HTTP 响应状态码是 resolve 或 reject  promise 。如果 `validateStatus` 返回 `true` (或者设置为 `null` 或 `undefined`)，promise 将被 resolve; 否则，promise 将被 rejecte
  validateStatus: function (status) {
    return status >= 200 && status < 300; // 默认的
  },

  // `maxRedirects` 定义在 node.js 中 follow 的最大重定向数目
  // 如果设置为0，将不会 follow 任何重定向
  maxRedirects: 5, // 默认的

  // `httpAgent` 和 `httpsAgent` 分别在 node.js 中用于定义在执行 http 和 https 时使用的自定义代理。允许像这样配置选项：
  // `keepAlive` 默认没有启用
  httpAgent: new http.Agent({ keepAlive: true }),
  httpsAgent: new https.Agent({ keepAlive: true }),

  // 'proxy' 定义代理服务器的主机名称和端口
  // `auth` 表示 HTTP 基础验证应当用于连接代理，并提供凭据
  // 这将会设置一个 `Proxy-Authorization` 头，覆写掉已有的通过使用 `header` 设置的自定义 `Proxy-Authorization` 头。
  proxy: {
    host: '127.0.0.1',
    port: 9000,
    auth: : {
      username: 'mikeymike',
      password: 'rapunz3l'
    }
  },

  // `cancelToken` 指定用于取消请求的 cancel token
  // （查看后面的 Cancellation 这节了解更多）
  cancelToken: new CancelToken(function (cancel) {
  })
}
```

# 四、脚手架

![img](http://image.trouvaille0198.top/image.png)

## 4.1 架构

### 4.1.1 main.js

程序入口

### 4.1.2 App.vue

主视图

```html
<template>
  <div id="app">
    <div>
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view />
  </div>
</template>

<script>
export default {};
</script>
<style lang="scss">
</style>
```

结构：`<template>`

脚本： `<script>`

样式：`<style>`

页面中放入一个路由视图容器：

```html
<router-view></router-view>
```

引用路由链接：

```html
<router-link to="/">Home</router-link> |
<router-link to="/about">About</router-link>
```
### 4.1.3 router

路由配置例

```js
import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/About.vue')
  }
]
```

用 Vue.js + Vue Router 创建单页应用

使用 Vue.js ，我们已经可以通过组合组件来组成应用程序；当你要把 Vue Router 添加进来，我们需要做的是，将组件 (components) 映射到路由 (routes)，然后告诉 Vue Router 在哪里渲染它们。

```html
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/vue-router/dist/vue-router.js"></script>

<div id="app">
  <h1>Hello App!</h1>
  <p>
    <!-- 使用 router-link 组件来导航. -->
    <!-- 通过传入 `to` 属性指定链接. -->
    <!-- <router-link> 默认会被渲染成一个 `<a>` 标签 -->
    <router-link to="/foo">Go to Foo</router-link>
    <router-link to="/bar">Go to Bar</router-link>
  </p>
  <!-- 路由出口 -->
  <!-- 路由匹配到的组件将渲染在这里 -->
  <router-view></router-view>
</div> 
```

## 4.2 单文件组件

<img src="http://image.trouvaille0198.top/vue-component.png" style="zoom: 67%;" />

