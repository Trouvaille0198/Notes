---
title: "配置 typora"
date: 2022-02-25
draft: false
author: "MelonCholi"
tags: []
categories: [有用的东东]
---

# 配置 Typora

## 自动添加标题序号

新建 `base.user.css` 文件，内容如下

```css
/** initialize css counter */
#write {
	counter-reset: h1;
}
h1 {
	counter-reset: h2;
}
h2 {
	counter-reset: h3;
}
h3 {
	counter-reset: h4;
}
h4 {
	counter-reset: h5;
}
h5 {
	counter-reset: h6;
}
/** put counter result into headings */
#write h1:before {
	counter-increment: h1;
	/**content: counter(h1) " ";**/
}
#write h2:before {
	counter-increment: h2;
	content: counter(h2) ". ";
}
#write h3:before,
h3.md-focus.md-heading:before /** override the default style for focused headings */ {
	counter-increment: h3;
	content: counter(h2) "." counter(h3) " ";
}
#write h4:before,
h4.md-focus.md-heading:before {
	counter-increment: h4;
	content: counter(h2) "." counter(h3) "." counter(h4) " ";
}
#write h5:before,
h5.md-focus.md-heading:before {
	counter-increment: h5;
	content: counter(h5) ") ";
}
#write h6:before,
h6.md-focus.md-heading:before {
	counter-increment: h6;
	content: counter(h6) ". ";
}
/** override the default style for focused headings */
#write > h3.md-focus:before,
#write > h4.md-focus:before,
#write > h5.md-focus:before,
#write > h6.md-focus:before,
h3.md-focus:before,
h4.md-focus:before,
h5.md-focus:before,
h6.md-focus:before {
	color: inherit;
	border: inherit;
	border-radius: inherit;
	position: inherit;
	left: initial;
	float: none;
	top: initial;
	font-size: inherit;
	padding-left: inherit;
	padding-right: inherit;
	vertical-align: inherit;
	font-weight: inherit;
	line-height: inherit;
}
```
