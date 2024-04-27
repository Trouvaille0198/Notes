---
title: "yarn"
date: 2021-12-05
author: MelonCholi
draft: false
tags: [快速入门,前端,包管理器]
categories: [前端]
---

# yarn

## 基本操作

### 安装

```bash
npm install -g yarn
```

### 初始化一个新项目

```bash
yarn init
```

### 安装所有依赖项

```bash
yarn
yarn install
```

### 添加依赖项

```bash
yarn add [package]
yarn add [package]@[version]
yarn add [package]@[tag]
```

### 将依赖项添加到不同的依赖类别中

```bash
yarn add [package] --dev  # dev dependencies
yarn add [package] --peer # peer dependencies
```

### 更新依赖项

```bash
yarn up [package]
yarn up [package]@[version]
yarn up [package]@[tag]
```

### 删除依赖项

```bash
yarn remove [package]
```

### 更新 Yarn 本体

```bash
yarn set version latest
yarn set version from sources
```

## 与 vite 配合

### 运行

```bash
yarn dev
```

