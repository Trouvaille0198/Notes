# 一、执行文件

`manimgl yourfile.py [className] [-params]`

One can also specify the render quality by using the flags `-ql`, `-qm`, `-qh`, or `-qk`, for low, medium, high, and 4k quality, respectively.

| flag                                  | abbr                  | function                                                  |
| ------------------------------------- | --------------------- | --------------------------------------------------------- |
| `--help`                              | `-h`                  | Show the help message and exit                            |
| `--output_file OUTPUT_FILE`           | `-o OUTPUT_FILE`      | Specify the name of the output file                       |
| `--preview`                           | `-p`                  | Automatically open the saved file once its done           |
| `--show_in_file_browser`              | `-f`                  | Show the output file in the File Browser                  |
| `--write_all`                         | `-a`                  | Write all the scenes from a file                          |
| `--save_last_frame`                   | `-s`                  | Save the last frame only (no movie file is generated)     |
| `--save_pngs`                         | `-g`                  | Save each frame as a png                                  |
| `--save_as_gif`                       | `-i`                  | Save the video as gif                                     |
| `--background_color BACKGROUND_COLOR` | `-c BACKGROUND_COLOR` | Specify background color                                  |
| `--dry_run`                           |                       | Do a dry run (render scenes but generate no output files) |
| `--transparent`                       | `-t`                  | Render a scene with an alpha channel                      |
| `--low_quality`                       | `-ql`                 | Render at low quality                                     |
| `--medium_quality`                    | `-qm`                 | Render at medium quality                                  |
| `--high_quality`                      | `-qh`                 | Render at high quality                                    |
| `--fourk_quality`                     | `-qk`                 | Render at 4K quality                                      |

# 二、Mobject

## 2.1 通用函数

所有方法以 `Mobject.` 开头

### 2.1.1 移动

- ***to_edge(edge, buff=)***

    移动到指定方向及其线性组合

    - *edge*：DIRECTION
    - *buff*：两者的边界距离

- ***to_corner(corner, buff=)***

    移动到四角

    - *corner*：
    - *buff*：两者的边缘的距离

- ***move_to(...)***

    在当前位置移动到对应的位置

    参数可以是

    - *mobject*：另一个Mobject
    - *aligned_edge*：DIRECTION 的线性组合
    - *coor_mask*：numpy 向量，默认为 `np.array([1, 1, 1])`

- ***next_to(mobject, direction, buff=)***

    移动到指定对象的相对位置

    - *mobject*：另一个 Mobject 对象
    - *direction*：DIRECTION
    - *buff*：两者的边界距离

- ***align_to(mobject, direction)***

    与指定对象对齐

    - *mobject*：另一个 Mobject 对象
    - *direction*：DIRECTION

- ***shift(aligned_edge)***

    向自己的垂直方向平移

    - *aligned_edge*：DIRECTION 的线性组合

### 2.1.2 旋转

- ***rotate(angle)***

    逆时针旋转

    - *angle*：`PI * number`

- ***flip(direction)***

    按照指定方向翻转 180 度，方向遵循右手定则

    - *direction*：DIRECTION

### 2.1.3 变形

- ***become(mobject)***

    变成其他图形

    - *mobject*：另一个 Mobject 对象

- ***set_color(color)***

    变色

    - *color*：COLOR 

- ***scale(scale_factor)***

    缩放大小

    - *scale_factor*：缩放倍数

### 2.1.4 获取信息

- ***get_center()***

    获取位置信息

### 2.1.5 VMobject 独有方法

- ***set_fill(color,opacity=)***

    在图案中填充颜色

    - *color*：COLOR
    - *opacity*：int 透明度

## 2.2 文字

### 2.2.1 Text

`manim.mobject.svg.text_mobject`

Mobjects used for displaying (non-LaTeX) text.

```python
class HelloWorld(Scene):
    def construct(self):
        text = Text('Hello world').scale(3)
        self.add(text)
```

Parameters

- color：str COLOR
- size：int
- font：str
- gradient：tuple (COLOR,COLOR)

### 2.2.2 Tex

`manim.mobject.svg.tex_mobject`

A string compiled with LaTeX in normal mode.

```python
class HelloLaTeX(Scene):
    def construct(self):
        tex = Tex(r'\LaTeX').scale(3)
        self.add(tex)
```

we are using a raw string (`r'---'`) instead of a regular string (`'---'`). 

### 2.2.3 MathTex

Whereas in a MathTex mobject everything is math-mode by default.

## 2.3 Geometry

### 2.3.1 Circle

- ***Circle()***

### 2.3.2 Dot

- ***Dot()***

# 三、Animation

## 3.1 通用

所有方法以 `self.` 开头

### 3.1.1 wait()

***wait(seconds)***

等待动画停留时间，如果没有参数则默认等待到将动画播放完为止

### 3.1.2 add()

***add(someObject1, someObject2, ...)***

无动画添加文字

### 3.1.3 remove()

***remove(someObject1, someObject2, ...)***

移除

### 3.1.4 play()

***play(SomePlayMethod(someObject), run_time=seconds)***

播放某种动画方法

```python
class concurrent(Scene):
    def construct(self):
        dot1 = Dot()
        dot2 = Dot()
        dot2.shift(UP)
        dot3 = Dot()
        dot3.shift(DOWN)
 
        # 单个动画的演示
        self.play(Write(dot1))
        # 多个动画演示
        self.play(*[
            Transform(i.copy(), j) for i, j in zip([dot1, dot1], [dot2, dot3])
        ]) # 故意使用i,j是为了显示zip的使用

        self.wait()
```

## 3.2 PlayMethod

### 3.2.1 Mobject.animate.method()

### 3.2.2 Creation

`manim.animation.creation`

- ***DrawBorderThenFill(mobject)***

    Draw the border first and then show the fill.

- ***ShowCreation(mobject)***

    Incrementally show a VMobject.

- ***Uncreate(mobject)***

    Like `ShowCreation` but in reverse.

- ***Write(mobject)***

    Simulate hand-writing a `Text` or hand-drawing a `VMobject`.

### 3.2.3 Fading

`manim.animation.fading`

- ***FadeIn(mobject)***
	淡入
- ***FadeInFrom(mobject, direction)***
	从指定方向淡入
- ***FadOut(mobject)***
	淡出
- ***FadeOutAndShift(mobject, direction)***
	从指定方向淡出

### 3.2.4 Movement

- ***MoveAlongPath(mobject, path)***

    Make one mobject move along the path of another mobject

### 3.2.5 Rotate

Animations related to rotation.

- ***Rotate(mobject, angle)***

### 3.2.6 transform

Animations transforming one mobject into another.

- ***Transform(mobject, target_mobject)***