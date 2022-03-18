---
title: "Pinia"
date: 2021-12-08
author: MelonCholi
draft: false
tags: [前端,快速入门]
categories: [前端]
---

# Pinia

Pinia (pronounced like `/peenya/` in English) is the closest word to *piña* (*pineapple* in Spanish) that is a valid package name. A pineapple is in reality a group of individual flowers that join together to create a multiple fruit. Similar to stores, each one is born individually, but they are all connected at the end. It's also a delicious tropical fruit indigenous to South America.

Not all applications need access to a global state, but if yours need one, Pinia will make your life easier.

```ts
import { defineStore } from 'pinia'

export const todos = defineStore('todos', {
  state: () => ({
    /** @type { text: string, id: number, isFinished: boolean }[] */
    todos: [],
    /** @type {'all' | 'finished' | 'unfinished'} */
    filter: 'all',
    // type will be automatically inferred to number
    nextId: 0,
  }),
  getters: {
    finishedTodos(state) {
      // autocompletion! ✨
      return state.todos.filter((todo) => todo.isFinished)
    },
    unfinishedTodos(state) {
      return state.todos.filter((todo) => !todo.isFinished)
    },
    /**
     * @returns { text: string, id: number, isFinished: boolean }[]
     */
    filteredTodos(state) {
      if (this.filter === 'finished') {
        // call other getters with autocompletion ✨
        return this.finishedTodos
      } else if (this.filter === 'unfinished') {
        return this.unfinishedTodos
      }
      return this.todos
    },
  },
  actions: {
    // any amount of arguments, return a promise or not
    addTodo(text) {
      // you can directly mutate the state
      this.todos.push({ text, id: this.nextId++, isFinished: false })
    },
  },
})
```

## 认识

```ts
import { createPinia } from 'pinia';

app.use(createPinia());
```

start by creating a store

```ts
// stores/counter.js
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({ count: 0 })
  
  actions: {
    increment() {
      this.count++
    },
  },
})
```

use it in a component

```ts
import { useCounterStore } from '@/stores/counter'

export default {
  setup() {
    const counter = useCounterStore()

    counter.count++
    // with autocompletion ✨
    counter.$patch({ count: counter.count + 1 })
    // or using an action instead
    counter.increment()
  },
}
```

You can even use a function (similar to a component `setup()`) to define a Store for more advanced use cases:

```ts
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  function increment() {
    count.value++
  }

  return { count, increment }
})
```

### 安装

安装需要 @next 因为 Pinia 2 处于 beta 阶段, Pinia 2 是对应 Vue3 的版本

```shell
# 使用 npm
npm install pinia@next
# 使用 yarn
yarn add pinia@next
```

## Store

A Store (like Pinia) is an entity holding state and business logic that isn't bound to your Component tree. 

In other words, it hosts global state. 

It's a bit like a component that is always there and that everybody can read off and write to. 

It has three concepts, the **state, getters and actions** and it's safe to assume these concepts are the equivalent of **data, computed and methods** in components.

### Defining a Store

```ts
import { defineStore } from 'pinia'

// useStore could be anything like useUser, useCart
// the first argument is a unique id of the store across your application
export const useStore = defineStore('main', {
  // other options...
})
```

### Using the store

We are *defining* a store because the store won't be created until `useStore()` is called inside of `setup()`:

```ts
import { useStore } from '@/stores/counter'

export default {
  setup() {
    const store = useStore()

    return {
      // you can return the whole store instance to use it in the template
      store,
    }
  },
}
```

Note that `store` is an object wrapped with `reactive`, meaning there is no need to write `.value` after getters but, like `props` in `setup`, **we cannot destructure (解构) it**:

```ts
export default defineComponent({
  setup() {
    const store = useStore()
    // ❌ This won't work because it breaks reactivity
    // it's the same as destructuring from `props`
    const { name, doubleCount } = store

    name // "eduardo"
    doubleCount // 2

    return {
      // will always be "eduardo"
      name,
      // will always be 2
      doubleCount,
      // this one will be reactive
      doubleValue: computed(() => store.doubleCount),
      }
  },
})
```

In order to extract properties from the store while keeping its reactivity, you need to use `storeToRefs()`. It will create refs for any reactive property. This is useful when you are only using state from the store but not calling any action:

```ts
import { storeToRefs } from 'pinia'

export default defineComponent({
  setup() {
    const store = useStore()
    // `name` and `doubleCount` are reactive refs
    // This will also create refs for properties added by plugins
    // but skip any action or non reactive (non ref/reactive) property
    const { name, doubleCount } = storeToRefs(store)

    return {
      name,
      doubleCount
    }
  },
})
```

## State

```ts
import { defineStore } from 'pinia'

const useStore = defineStore('storeId', {
  // arrow function recommended for full type inference
  state: () => {
    return {
      // all these properties will have their type inferred automatically
      counter: 0,
      name: 'Eduardo',
      isAdmin: true,
    }
  },
})
```

### Accessing

By default, you can directly read and write to the state by accessing it through the `store` instance:

```ts
const store = useStore()

store.counter++
```

### Resetting

You can *reset* the state to its initial value by calling the `$reset()` method on the store:

```ts
const store = useStore()

store.$reset()
```

### Mutating

Apart from directly mutating the store with `store.counter++`, you can also call the `$patch` method. It allows you to apply multiple changes at the same time with a partial `state` object:

```ts
store.$patch({
  counter: store.counter + 1,
  name: 'Abalam',
})
```

However, some mutations are really hard or costly to apply with this syntax: any collection modification (e.g. pushing, removing, splicing an element from an array) requires you to create a new collection. Because of this, the `$patch` method also accepts a function to group this kind of mutations that are difficult to apply with a patch object:

```ts
cartStore.$patch((state) => {
  state.items.push({ name: 'shoes', quantity: 1 })
  state.hasChanged = true
})
```

The main difference here is that `$patch()` allows you to group multiple changes into one single entry in the devtools. Note **both, direct changes to `state` and `$patch()` appear in the devtools** and can be time travelled (not yet in Vue 3).

### Replacing

You can replace the whole state of a store by setting its `$state` property to a new object:

```ts
store.$state = { counter: 666, name: 'Paimon' }
```

You can also replace the whole state of your application by changing the `state` of the `pinia` instance. This is used during SSR for hydration

```ts
pinia.state.value = {}
```

### Subscribing

You can watch the state and its changes through the `$subscribe()` method of a store, similar to Vuex's subscribe method. The advantage of using `$subscribe()` over a regular `watch()` is that *subscriptions* will trigger only once after *patches* (e.g. when using the function version from above).

```ts
cartStore.$subscribe((mutation, state) => {
  // import { MutationType } from 'pinia'
  mutation.type // 'direct' | 'patch object' | 'patch function'
  // same as cartStore.$id
  mutation.storeId // 'cart'
  // only available with mutation.type === 'patch object'
  mutation.payload // patch object passed to cartStore.$patch()

  // persist the whole state to the local storage whenever it changes
  localStorage.setItem('cart', JSON.stringify(state))
})
```

## Getters

Getters are exactly the equivalent of computed values for the state of a Store. They can be defined with the `getters` property in `defineStore()`. They receive the `state` as the first parameter **to encourage** the usage of arrow function:

```ts
export const useStore = defineStore('main', {
  state: () => ({
    counter: 0,
  }),
  getters: {
    doubleCount: (state) => state.counter * 2,
  },
})
```

Most of the time, getters will only rely on the state, however, they might need to use other getters. Because of this, we can get access to the *whole store instance* through `this` when defining a regular function **but it is necessary to define the type of the return type (in TypeScript)**. This is due to a known limitation in TypeScript and **doesn't affect getters defined with an arrow function nor getters not using `this`**:

```ts
export const useStore = defineStore('main', {
  state: () => ({
    counter: 0,
  }),
  getters: {
    // automatically infers the return type as a number
    doubleCount(state) {
      return state.counter * 2
    },
    // the return type **must** be explicitly set
    doublePlusOne(): number {
      // autocompletion and typings for the whole store ✨
      return this.counter * 2 + 1
    },
  },
})
```

Then you can access the getter directly on the store instance:

```vue
<template>
  <p>Double count is {{ store.doubleCount }}</p>
</template>

<script>
export default {
  setup() {
    const store = useStore()

    return { store }
  },
}
</script>
```

### Accessing other getters

As with computed properties, you can combine multiple getters. Access any other getter via `this`. Even if you are not using TypeScript, you can hint your IDE for types with the JSDoc:

> 绷不住了

```ts
export const useStore = defineStore('main', {
  state: () => ({
    counter: 0,
  }),
  getters: {
    // type is automatically inferred because we are not using `this`
    doubleCount: (state) => state.counter * 2,
    // here we need to add the type ourselves (using JSDoc in JS). We can also
    // use this to document the getter
    /**
     * Returns the counter value times two plus one.
     *
     * @returns {number}
     */
    doubleCountPlusOne() {
      // autocompletion ✨
      return this.doubleCount + 1
    },
  },
})
```

### Accessing other stores getters

To use another store getters, you can directly *use it* inside of the *getter*:

```ts
import { useOtherStore } from './other-store'

export const useStore = defineStore('main', {
  state: () => ({
    // ...
  }),
  getters: {
    otherGetter(state) {
      const otherStore = useOtherStore()
      return state.localData + otherStore.data
    },
  },
})
```

## Actions

Actions are the equivalent of [methods](https://v3.vuejs.org/guide/data-methods.html#methods) in components. They can be defined with the `actions` property in `defineStore()` and **they are perfect to define business logic**:

```ts
export const useStore = defineStore('main', {
  state: () => ({
    counter: 0,
  }),
  actions: {
    increment() {
      this.counter++
    },
    randomizeCounter() {
      this.counter = Math.round(100 * Math.random())
    },
  },
})
```

Actions are invoked like methods:

```ts
export default defineComponent({
  setup() {
    const main = useMainStore()
    // call the action as a method of the store
    main.randomizeCounter()

    return {}
  },
})
```

### Accessing other stores actions

To use another store, you can directly *use it* inside of the *action*:

```ts
import { useAuthStore } from './auth-store'

export const useSettingsStore = defineStore('settings', {
  state: () => ({
    // ...
  }),
  actions: {
    async fetchUserPreferences(preferences) {
      const auth = useAuthStore()
      if (auth.isAuthenticated) {
        this.preferences = await fetchPreferences()
      } else {
        throw new Error('User must be authenticated')
      }
    },
  },
})
```

### File Structure

```shell
# Pinia equivalent, note ids match previous namespaces
src
└── stores
    ├── index.js          # (Optional) Initializes Pinia, does not import stores
    ├── module1.js        # 'module1' id
    ├── nested-module2.js # 'nested/module3' id
    ├── nested-module3.js # 'nested/module2' id
    └── nested.js         # 'nested' id
```



```
{
    "game_id": 0,
    "game_info": {
        "player_club_id": 241,
        "computer_club_id": 247,
        "home_club_id": 2,
        "name": "英超",
        "type": "league",
        "date": "2022-01-01",
        "season": 2,
        "cur_attacker": 241,
        "turns": 43,
        "script": "比赛开始！@00:00@5\n曼彻斯特城尝试中路渗透@00:39@4\n曼彻斯特城丢失了球权@00:42@5\n\n西汉姆联尝试防守反击@02:10@2\n卡图拉尼一脚长传，直击腹地@02:14@2\n赫诺韦沃过掉了埃尔古德@02:18@2\n赫诺韦沃起脚打门！@02:21@2\n哈夫尔利克发挥神勇，扑出这脚劲射@02:25@5\n卡图拉尼策动的长传被拦截@02:28@2\n曼彻斯特城持球@02:30@5\n\n曼彻斯特城尝试边路内切@04:15@2\n加达利亚拿球，尝试过人@04:16@3\n加达利亚过掉了费利克索娃@04:18@5\n加达利亚尝试内切@04:22@5\n巴莱斯瓦尔阻截了加达利亚的进攻@04:25@1\n卡图拉尼阻截了加达利亚的进攻@04:28@5\n\n西汉姆联尝试防守反击@06:01@1\n比茹特里策动的长传被拦截@06:02@4\n曼彻斯特城持球@06:06@2\n\n曼彻斯特城尝试中路渗透@08:26@5\n曼彻斯特城丢失了球权@08:28@2\n\n西汉姆联尝试中路渗透@09:59@1\n球员们尝试争顶@10:01@5\n吕斯卡尔抢到球权@10:05@3\n吕斯卡尔起脚打门！@10:09@5\n球进啦！曼彻斯特城 0:1 西汉姆联@2\n\n曼彻斯特城尝试中路渗透@11:25@2\n球员们尝试争顶@11:27@1\n萨格拉斯抢到球权@11:29@3\n萨格拉斯起脚打门！@11:33@1\n比茹特里发挥神勇，扑出这脚劲射@11:36@3\n\n西汉姆联尝试边路内切@13:27@4\n费利克索娃拿球，尝试过人@13:28@1\n加达利亚抢到皮球@13:31@4\n\n曼彻斯特城尝试中路渗透@15:23@4\n球员们尝试争顶@15:26@4\n巴莱斯瓦尔将球解围@15:29@1\n球员们尝试争顶@15:33@1\n吕斯卡尔抢到球权@15:35@1\n\n西汉姆联尝试中路渗透@16:46@2\n球员们尝试争顶@16:47@4\n吕斯卡尔抢到球权@16:48@3\n吕斯卡尔起脚打门！@16:49@1\n哈夫尔利克发挥神勇，扑出这脚劲射@16:52@2\n\n曼彻斯特城尝试下底传中@18:43@4\n加达利亚过掉了泰尤尚@18:47@2\n加达利亚一脚起球传中@18:50@4\n球员们尝试争顶@18:54@3\n泽博基尼抢到球权@18:56@5\n泽博基尼起脚打门！@18:58@5\n球进啦！曼彻斯特城 1:1 西汉姆联@4\n\n西汉姆联尝试下底传中@20:33@3\n泰尤尚一脚起球传中@20:34@5\n球员们尝试争顶@20:35@2\n吕斯卡尔抢到球权@20:38@2\n吕斯卡尔起脚打门！@20:40@3\n球进啦！曼彻斯特城 1:2 西汉姆联@3\n吕斯卡尔梅开二度！@1\n\n曼彻斯特城尝试下底传中@22:19@2\n加达利亚一脚起球传中@22:23@5\n西汉姆联抢到球权@22:27@1\n\n西汉姆联尝试倒三角传球@24:13@3\n费利克索娃拿球，尝试过人@24:15@3\n费利克索娃过掉了加达利亚@24:18@4\n费利克索娃尝试内切@24:19@4\n费利克索娃过掉了沙内夫@24:20@1\n费利克索娃倒三角传中@24:24@4\n\n曼彻斯特城尝试下底传中@25:53@3\n萨彻过掉了费利克索娃@25:55@5\n萨彻一脚起球传中@25:57@1\n西汉姆联抢到球权@25:59@2\n\n西汉姆联尝试中路渗透@27:44@3\n球员们尝试争顶@27:45@5\n吕斯卡尔抢到球权@27:49@4\n吕斯卡尔起脚打门！@27:53@1\n哈夫尔利克发挥神勇，扑出这脚劲射@27:54@1\n\n曼彻斯特城尝试下底传中@29:11@4\n费利克索娃抢到皮球@29:15@3\n\n西汉姆联尝试中路渗透@31:03@5\n西汉姆联丢失了球权@31:04@4\n\n曼彻斯特城尝试下底传中@33:23@5\n加达利亚过掉了泰尤尚@33:26@3\n加达利亚一脚起球传中@33:27@4\n西汉姆联抢到球权@33:30@5\n\n西汉姆联尝试防守反击@35:07@4\n比茹特里策动的长传被拦截@35:10@4\n曼彻斯特城持球@35:13@2\n\n曼彻斯特城尝试中路渗透@37:25@4\n曼彻斯特城丢失了球权@37:29@3\n\n西汉姆联尝试中路渗透@38:08@5\n球员们尝试争顶@38:10@2\n埃尔古德将球解围@38:12@1\n球员们尝试争顶@38:16@1\n泽博基尼抢到球权@38:18@4\n\n曼彻斯特城尝试中路渗透@40:39@3\n曼彻斯特城丢失了球权@40:43@5\n\n西汉姆联尝试中路渗透@42:27@2\n球员们尝试争顶@42:29@4\n吕斯卡尔抢到球权@42:30@4\n吕斯卡尔起脚打门！@42:32@5\n哈夫尔利克发挥神勇，扑出这脚劲射@42:36@5\n\n曼彻斯特城尝试下底传中@44:13@3\n费利克索娃抢到皮球@44:17@2\n\n西汉姆联尝试下底传中@45:39@2\n泰尤尚一脚起球传中@45:42@2\n球员们尝试争顶@45:43@1\n沙内夫将球解围@45:46@5\n曼彻斯特城拿到球权@45:48@2\n\n曼彻斯特城尝试边路内切@47:38@3\n加达利亚拿球，尝试过人@47:41@1\n费利克索娃抢到皮球@47:44@5\n\n西汉姆联尝试倒三角传球@49:20@3\n泰尤尚拿球，尝试过人@49:23@3\n萨彻抢到皮球@49:27@2\n\n曼彻斯特城尝试中路渗透@50:55@4\n曼彻斯特城丢失了球权@50:56@4\n\n西汉姆联尝试中路渗透@53:00@4\n球员们尝试争顶@53:02@1\n莫根施特诺娃抢到球权@53:06@1\n莫根施特诺娃起脚打门！@53:08@5\n球进啦！曼彻斯特城 1:3 西汉姆联@3\n\n曼彻斯特城尝试中路渗透@54:53@2\n球员们尝试争顶@54:56@2\n泽博基尼抢到球权@54:57@4\n泽博基尼起脚打门！@54:59@5\n球进啦！曼彻斯特城 2:3 西汉姆联@5\n泽博基尼梅开二度！@2\n\n西汉姆联尝试下底传中@56:22@2\n泰尤尚过掉了加达利亚@56:23@3\n泰尤尚一脚起球传中@56:27@5\n曼彻斯特城抢到球权@56:31@4\n\n曼彻斯特城尝试防守反击@58:09@3\n哈夫尔利克策动的长传被拦截@58:12@4\n西汉姆联持球@58:14@2\n\n西汉姆联尝试防守反击@60:14@4\n巴莱斯瓦尔策动的长传被拦截@60:15@1\n曼彻斯特城持球@60:16@1\n\n曼彻斯特城尝试下底传中@62:23@3\n泰尤尚抢到皮球@62:27@4\n\n西汉姆联尝试中路渗透@63:37@2\n西汉姆联丢失了球权@63:38@2\n\n曼彻斯特城尝试中路渗透@65:18@4\n球员们尝试争顶@65:21@4\n比斯塔埃莫萨将球解围@65:25@3\n球员们尝试争顶@65:27@3\n莫根施特诺娃抢到球权@65:30@4\n\n西汉姆联尝试防守反击@67:21@4\n巴莱斯瓦尔一脚长传，直击腹地@67:25@1\n里茨内罗娃抢到皮球@67:27@1\n巴莱斯瓦尔策动的长传被拦截@67:30@4\n曼彻斯特城持球@67:32@4\n\n曼彻斯特城尝试中路渗透@69:23@2\n球员们尝试争顶@69:26@3\n泽博基尼抢到球权@69:29@4\n泽博基尼起脚打门！@69:31@2\n球进啦！曼彻斯特城 3:3 西汉姆联@4\n泽博基尼帽子戏法！@4\n\n西汉姆联尝试中路渗透@71:37@1\n球员们尝试争顶@71:41@4\n赫诺韦沃抢到球权@71:44@2\n赫诺韦沃起脚打门！@71:45@3\n球进啦！曼彻斯特城 3:4 西汉姆联@4\n\n曼彻斯特城尝试防守反击@72:33@5\n埃尔古德一脚长传，直击腹地@72:36@3\n巴莱斯瓦尔抢到皮球@72:38@2\n埃尔古德策动的长传被拦截@72:42@4\n西汉姆联持球@72:43@5\n\n西汉姆联尝试下底传中@74:31@4\n费利克索娃过掉了萨彻@74:35@4\n费利克索娃一脚起球传中@74:39@5\n球员们尝试争顶@74:41@2\n吕斯卡尔抢到球权@74:43@4\n吕斯卡尔起脚打门！@74:44@3\n球进啦！曼彻斯特城 3:5 西汉姆联@2\n吕斯卡尔帽子戏法！@4\n\n",
        "new_script": "西汉姆联尝试下底传中@74:31@4\n费利克索娃过掉了萨彻@74:35@4\n费利克索娃一脚起球传中@74:39@5\n球员们尝试争顶@74:41@2\n吕斯卡尔抢到球权@74:43@4\n吕斯卡尔起脚打门！@74:44@3\n球进啦！曼彻斯特城 3:5 西汉姆联@2\n吕斯卡尔帽子戏法！@4\n",
        "is_extra_time": false,
        "counter_attack_permitted": true
    },
    "player_team_info": {
        "club_id": 241,
        "score": 3,
        "is_player": true,
        "attempts": 21,
        "wing_cross": 7,
        "wing_cross_success": 1,
        "under_cutting": 2,
        "under_cutting_success": 0,
        "pull_back": 0,
        "pull_back_success": 0,
        "middle_attack": 10,
        "middle_attack_success": 2,
        "counter_attack": 3,
        "counter_attack_success": 0,
        "name": "曼彻斯特城"
    },
    "computer_team_info": {
        "club_id": 247,
        "score": 5,
        "is_player": false,
        "attempts": 21,
        "wing_cross": 4,
        "wing_cross_success": 2,
        "under_cutting": 1,
        "under_cutting_success": 0,
        "pull_back": 2,
        "pull_back_success": 0,
        "middle_attack": 9,
        "middle_attack_success": 3,
        "counter_attack": 5,
        "counter_attack_success": 0,
        "name": "西汉姆联"
    },
    "player_players_info": [
        {
            "player_id": 5761,
            "ori_location": "ST",
            "real_location": "ST",
            "real_rating": 10.8,
            "final_rating": 10,
            "actions": 30,
            "shots": 3,
            "goals": 3,
            "assists": 0,
            "passes": 0,
            "pass_success": 0,
            "dribbles": 1,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 13,
            "aerial_success": 10,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 95,
            "final_stamina": 76,
            "name": "泽博基尼"
        },
        {
            "player_id": 5762,
            "ori_location": "CAM",
            "real_location": "CM",
            "real_rating": 6.1,
            "final_rating": 6.1,
            "actions": 35,
            "shots": 1,
            "goals": 0,
            "assists": 0,
            "passes": 20,
            "pass_success": 6,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 5,
            "aerial_success": 3,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 87,
            "name": "萨格拉斯"
        },
        {
            "player_id": 5763,
            "ori_location": "CAM",
            "real_location": "CM",
            "real_rating": 9.799999999999999,
            "final_rating": 9.8,
            "actions": 63,
            "shots": 0,
            "goals": 0,
            "assists": 2,
            "passes": 31,
            "pass_success": 27,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 2,
            "aerial_success": 1,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 82,
            "name": "帕伦布罗"
        },
        {
            "player_id": 5764,
            "ori_location": "ST",
            "real_location": "ST",
            "real_rating": 4.8,
            "final_rating": 4.8,
            "actions": 8,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 0,
            "pass_success": 0,
            "dribbles": 1,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 7,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 90,
            "name": "波文内克"
        },
        {
            "player_id": 5765,
            "ori_location": "CDM",
            "real_location": "CB",
            "real_rating": 4.5,
            "final_rating": 4.5,
            "actions": 22,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 11,
            "pass_success": 4,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 3,
            "tackle_success": 1,
            "aerials": 2,
            "aerial_success": 1,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 83,
            "name": "沙内夫"
        },
        {
            "player_id": 5768,
            "ori_location": "CM",
            "real_location": "CM",
            "real_rating": 7.8999999999999995,
            "final_rating": 7.9,
            "actions": 52,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 29,
            "pass_success": 23,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 91,
            "name": "南比"
        },
        {
            "player_id": 5769,
            "ori_location": "GK",
            "real_location": "GK",
            "real_rating": 7.6,
            "final_rating": 7.6,
            "actions": 14,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 1,
            "pass_success": 0,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 9,
            "save_success": 4,
            "original_stamina": 100,
            "final_stamina": 83,
            "name": "哈夫尔利克"
        },
        {
            "player_id": 5771,
            "ori_location": "CB",
            "real_location": "CB",
            "real_rating": 5,
            "final_rating": 5,
            "actions": 26,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 3,
            "pass_success": 2,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 2,
            "tackle_success": 1,
            "aerials": 14,
            "aerial_success": 4,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 74,
            "name": "埃尔古德"
        },
        {
            "player_id": 5772,
            "ori_location": "CDM",
            "real_location": "CM",
            "real_rating": 4.4,
            "final_rating": 4.4,
            "actions": 26,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 17,
            "pass_success": 1,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 1,
            "tackle_success": 1,
            "aerials": 4,
            "aerial_success": 2,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 81,
            "name": "里茨内罗娃"
        },
        {
            "player_id": 5775,
            "ori_location": "LB",
            "real_location": "LB",
            "real_rating": 4.8,
            "final_rating": 4.8,
            "actions": 8,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 1,
            "pass_success": 0,
            "dribbles": 3,
            "dribble_success": 1,
            "tackles": 2,
            "tackle_success": 1,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 89,
            "name": "萨彻"
        },
        {
            "player_id": 5777,
            "ori_location": "RB",
            "real_location": "RW",
            "real_rating": 6.3,
            "final_rating": 6.3,
            "actions": 19,
            "shots": 0,
            "goals": 0,
            "assists": 1,
            "passes": 3,
            "pass_success": 1,
            "dribbles": 7,
            "dribble_success": 3,
            "tackles": 3,
            "tackle_success": 1,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 90,
            "name": "加达利亚"
        }
    ],
    "computer_players_info": [
        {
            "player_id": 5917,
            "ori_location": "CAM",
            "real_location": "ST",
            "real_rating": 8.4,
            "final_rating": 8.4,
            "actions": 37,
            "shots": 2,
            "goals": 1,
            "assists": 0,
            "passes": 13,
            "pass_success": 13,
            "dribbles": 2,
            "dribble_success": 2,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 2,
            "aerial_success": 2,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 81,
            "name": "赫诺韦沃"
        },
        {
            "player_id": 5911,
            "ori_location": "GK",
            "real_location": "GK",
            "real_rating": 6.4,
            "final_rating": 6.4,
            "actions": 7,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 2,
            "pass_success": 0,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 4,
            "save_success": 1,
            "original_stamina": 100,
            "final_stamina": 96,
            "name": "比茹特里"
        },
        {
            "player_id": 5915,
            "ori_location": "CDM",
            "real_location": "CB",
            "real_rating": 9,
            "final_rating": 9,
            "actions": 57,
            "shots": 0,
            "goals": 0,
            "assists": 1,
            "passes": 26,
            "pass_success": 24,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 4,
            "aerial_success": 2,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 89,
            "final_stamina": 66,
            "name": "比斯塔埃莫萨"
        },
        {
            "player_id": 5921,
            "ori_location": "ST",
            "real_location": "ST",
            "real_rating": 11.100000000000001,
            "final_rating": 10,
            "actions": 30,
            "shots": 6,
            "goals": 3,
            "assists": 0,
            "passes": 0,
            "pass_success": 0,
            "dribbles": 1,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 11,
            "aerial_success": 9,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 76,
            "name": "吕斯卡尔"
        },
        {
            "player_id": 5913,
            "ori_location": "CDM",
            "real_location": "CB",
            "real_rating": 9,
            "final_rating": 9,
            "actions": 51,
            "shots": 0,
            "goals": 0,
            "assists": 1,
            "passes": 25,
            "pass_success": 24,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 1,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 95,
            "final_stamina": 86,
            "name": "亚兹迪"
        },
        {
            "player_id": 5909,
            "ori_location": "LB",
            "real_location": "LW",
            "real_rating": 6.3,
            "final_rating": 6.3,
            "actions": 19,
            "shots": 0,
            "goals": 0,
            "assists": 1,
            "passes": 2,
            "pass_success": 1,
            "dribbles": 4,
            "dribble_success": 3,
            "tackles": 5,
            "tackle_success": 3,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 92,
            "name": "费利克索娃"
        },
        {
            "player_id": 5920,
            "ori_location": "CDM",
            "real_location": "CM",
            "real_rating": 7.6,
            "final_rating": 7.6,
            "actions": 35,
            "shots": 0,
            "goals": 0,
            "assists": 1,
            "passes": 19,
            "pass_success": 15,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 88,
            "final_stamina": 77,
            "name": "索梅伊"
        },
        {
            "player_id": 5906,
            "ori_location": "ST",
            "real_location": "ST",
            "real_rating": 5.5,
            "final_rating": 5.5,
            "actions": 13,
            "shots": 1,
            "goals": 1,
            "assists": 0,
            "passes": 0,
            "pass_success": 0,
            "dribbles": 2,
            "dribble_success": 0,
            "tackles": 0,
            "tackle_success": 0,
            "aerials": 7,
            "aerial_success": 2,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 79,
            "final_stamina": 62,
            "name": "莫根施特诺娃"
        },
        {
            "player_id": 5908,
            "ori_location": "CB",
            "real_location": "CB",
            "real_rating": 5.7,
            "final_rating": 5.7,
            "actions": 25,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 3,
            "pass_success": 2,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 2,
            "tackle_success": 2,
            "aerials": 11,
            "aerial_success": 5,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 68,
            "final_stamina": 46,
            "name": "巴莱斯瓦尔"
        },
        {
            "player_id": 5907,
            "ori_location": "CB",
            "real_location": "CB",
            "real_rating": 6,
            "final_rating": 6,
            "actions": 23,
            "shots": 0,
            "goals": 0,
            "assists": 0,
            "passes": 1,
            "pass_success": 1,
            "dribbles": 0,
            "dribble_success": 0,
            "tackles": 2,
            "tackle_success": 2,
            "aerials": 11,
            "aerial_success": 6,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 87,
            "final_stamina": 76,
            "name": "卡图拉尼"
        },
        {
            "player_id": 5910,
            "ori_location": "RB",
            "real_location": "RB",
            "real_rating": 6,
            "final_rating": 6,
            "actions": 13,
            "shots": 0,
            "goals": 0,
            "assists": 1,
            "passes": 3,
            "pass_success": 2,
            "dribbles": 2,
            "dribble_success": 1,
            "tackles": 3,
            "tackle_success": 1,
            "aerials": 0,
            "aerial_success": 0,
            "saves": 0,
            "save_success": 0,
            "original_stamina": 100,
            "final_stamina": 98,
            "name": "泰尤尚"
        }
    ]
}
```

