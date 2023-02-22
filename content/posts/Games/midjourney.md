---
title: "midjourney 技巧"
date: 2023-01-23
author: MelonCholi
draft: false
tags: [Game]
categories: [其他]
---

# midjourney 技巧

## 一些实用工具

- 很全的风格参考
    - https://github.com/willwulfken/MidJourney-Styles-and-Keywords-Reference

- 随机关键词，适合头脑风暴
    - https://electricnotebook.neocities.org/chaos-prompt-gen

- midjourney 技巧收集
    - https://docs.google.com/spreadsheets/u/0/d/1GuAeSFtICsjQEwsRP2f--IayDxW9Dl0SCLOVov56FMc/htmlview?fs=e&s=cl#
- 免费的 Stable Diffusion
    - https://huggingface.co/spaces/stabilityai/stable-diffusion

## 常用关键词

### 一些看起来像废话的词

- highly detailed
- ultra realistic

### 光线

- 摄影棚布光：studio lighting

### 形容词

- 精细复杂的：intricate
    - intricate rococo
- 明暗对比：chiaroscuro

### 引擎风格

- octane render
- unreal engine

### 艺术风格

- 3D 渲染：3d rendering

- 洛可可：rococo
- 苏联式政治宣传（海报）：soviet propaganda
- 克式：lovecraftian horrorific
- 塔罗牌：tarot card
- 浮世绘：Ukiyo-e
- 平面插画：flat illustration

### 材质（XXX textured)

- fur：皮毛

### 艺术家

- 葛饰北斋：Katsushika Hokusai
    - 神奈川冲浪里

### 其他

- 人物肖像：photographic portrait

## 固定风格

雕塑质感

```
gorgeous <item name> statue with gold filigree :: carved marble --ar 2:3
```

![gorgeous Vulture statue with gold filigree](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/grid_0.png)

## 图像相关

### 纵横比 `--ar x:y`

一些常见的纵横比是：

- 16:9（宽屏桌面，手机横屏） 
- 9:16（竖屏手机，Instagram ） 
- 4:3（典型的“缩略图”或横向照片） 
- 4:5（Instagram 提要中“纵向”的图像)

### 视角

#### 人物

- 低位视角 from below
- 高位视角  from above,
- 侧边视角  from side,
- 单人焦点  solo focus, (+ blurry background, >> 多人背景)
- 背后焦点  back focus,
- 人物面朝远方 (背对) facing away,
- 侧脸  profile,
- **全身**：full body shot
- 正面面对  straight-on,
- 第一人称  first-person view,
- 主观视角  pov,
- 手主观视角  pov hands,
- 胯部主观视角 pov crotch,
- 三视图  three sided view, (+ concept art, reference sheet, official art,)
- 参考纸样  reference sheet,
- 多视图  multiple views,

## 指令参数

- --w：图像宽度 (px)	
    - 以 64 倍数会产生较好的成果（或 128 的倍数 for --hd）		
- --h：图像高度 (px)	
    - 以 64 倍数会产生较好的成果（或 128 的倍数 for --hd）		
- --seed：设置随机种子
    - （有时可以帮助保持几代生成间的图像稳定）用法是先用信封表符传到信箱得知种子编号		
- --no：负激发
    - 指定不要什么；
    - “--no plants” 试着不要有植物
    - “snoop dogg --no canine” 画史奴比但是不要有真的狗出现	
- --video：会把逐渐制图过程录成动画，Saves a progress video, which is sent to you in the ✉️
- --iw：设置图片参数权重，Sets image prompt weight			
- --fast：较快速生成图像	图像连续（合理）性较差		
- --hd：Faster version of the old algorithm	
    - 官方说明适合大张的图，但会比较容易有不连续		注意图面积别太大，可能记忆体不足无法算
- --stop：Stop the generation at an earlier percentage. Must be between 10-100
    - 在运算早期“停止”生成图像，需在 10~100 之间
    - 如果你看动画总觉得模糊时就很讚清楚反而不好可以试这个
- --uplight	使用 “轻量”、”高阶” 生成后续图像时，新图像较为接近原图
    - Use "light" upscaler for subsequent upscales. Results are then closer to the original image		

### 尺寸快速输入

| 参数        | 意义                    | 说明                            |
| ----------- | ----------------------- | ------------------------------- |
| --wallpaper | --w 1920 --h 1024 --hd  | --hd 结尾图像会超展开到无法想象 |
| --sl        | --w 320 --h 256         |                                 |
| --ml        | --w 448 --h 320         |                                 |
| --ll        | --w 768 --h 512 --hd    |                                 |
| --sp        | --w 10800 --h 1920 --hd |                                 |
| --mp        | --w 256 --h 320         |                                 |
| --lp        | --w 512 --h 768 --hd    |                                 |

### 权重设定

You can suffix any part of the prompt with ::0.5 to give that part a weight of 0.5. If the weight is not specified, it defaults to 1. 

```shell
/imagine hot dog::1 food::-1 # This sends a text prompt of hot dog with the weight 1 and food of weight -1

/imagine hot dog::0.5 animal::-0.75 # Sends hot dog of weight 0.5 and animal of negative 0.75

/imagine hot dog:: food::-1 animal # Sends hot dog of weight 1, food of weight -1 and animal of weight 1
```

Watch out for prompts such as /imagine hot dog animal::-1, as this will send the prompt of hot dog animal with weight -1.

Note: The --no command is equivalent to using weight -0.5.
