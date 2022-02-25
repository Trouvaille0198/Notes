---
title: "Tailwind"
date: 2022-01-17
author: MelonCholi
draft: false
tags: [CSS,前端,快速入门]
categories: [前端]
---

# Tailwind

## 要点

### 响应式变体

- 移动优先，未加前缀的功能类在所有的屏幕上都生效

    - 而加了前缀的功能类（如 `md:uppercase`）仅在指定断点及以上的屏幕上生效。

    - 要为移动设备设计样式，就需要使用无前缀的功能类，而不是带 `sm:` 前缀的版本
    - 因此，通常最好先为移动设备设计布局，接着在 `sm` 屏幕上进行更改，然后是 `md` 屏幕，以此类推

- Tailwind 的断点仅包括 `min-width` 而没有 `max-width`
    - 这意味着在较小的断点上添加的任何功能类都将应用在更大的断点上。

### 状态变体

默认变体参考：https://www.tailwindcss.cn/docs/hover-focus-and-other-states#-4

### `dark` 变体

`dark` 变体可以与响应式变体和状态变体结合使用：

```html
<button class="lg:dark:hover:bg-white ...">
  <!-- ... -->
</button>
```

为了使其正常工作，必须把响应式变体要在最前面，然后是 `dark` 变体，最后是状态变体。

默认情况下，`dark variance` 只对 `backgroundColor`、`borderColor`、`gradientColorStops`、`placeholderColor` 和 `textColor` 启用。

### 其他

#### 在 HTML 中使用类

如果您只想对 `html` 或者 `body` 元素应用某种全局样式，只需将现有类添加到 HTML 中的那些元素，而不是编写新的 CSS ：

```html
<!doctype html>
<html lang="en" class="text-gray-900 leading-tight">
  <!-- ... -->
  <body class="min-h-screen bg-gray-100">
    <!-- ... -->
  </body>
</html>
```

#### 使用 @apply 抽取组件类

```html
<button class="btn-indigo">
  Click me
</button>

<style>
  .btn-indigo {
    @apply py-2 px-4 bg-indigo-500 text-white font-semibold rounded-lg shadow-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:ring-opacity-75;
  }
</style>
```

为了避免意外的特定性问题，我们建议您使用 `@layer components { ... }` 指令包装您的自定义组件样式，以告诉 Tailwind 这些样式属于哪一层

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer components {
  .btn-blue {
    @apply py-2 px-4 bg-blue-500 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75;
  }
}
```

```css
@layer components {
  @variants responsive, hover {
    .btn-blue {
      @apply py-2 px-4 bg-blue-500 ...;
    }
  }
}
```

Tailwind 会将这些样式自动移到与 `@tailwind components` 相同的位置，因此您不必担心在源文件中正确放置顺序。

### 添加新的功能类

使用 CSS

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  .scroll-snap-none {
    scroll-snap-type: none;
  }
  .scroll-snap-x {
    scroll-snap-type: x;
  }
  .scroll-snap-y {
    scroll-snap-type: y;
  }
}
```

通过使用 `@layer` 指令， Tailwind 将自动把这些样式移动到 `@tailwind utilities` 相同的位置，以避免出现意外的未知问题。

#### 附带响应式变体

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  @variants responsive {
    .scroll-snap-none {
      scroll-snap-type: none;
    }
    .scroll-snap-x {
      scroll-snap-type: x;
    }
    .scroll-snap-y {
      scroll-snap-type: y;
    }
  }
}
```

#### 附带深色模式变体

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  @variants dark {
    .filter-none {
      filter: none;
    }
    .filter-grayscale {
      filter: grayscale(100%);
    }
  }
}
```

#### 附带状态变体

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  @variants hover, focus {
    .filter-none {
      filter: none;
    }
    .filter-grayscale {
      filter: grayscale(100%);
    }
  }
}
```

状态变体的生成顺序与您在 `@variants` 指令中列出的顺序相同，因此，如果您希望一个变体优先于另一个变体，请确保这个变体最后被列出

### Preflight

- 默认的外边距 (margin) 已移除
- 默认启用 `box-border`，即为元素规定的高度或宽度将包括元素的 `border` 和 `padding`