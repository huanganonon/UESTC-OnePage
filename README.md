# 简介：适配UESTC一页纸排版

- 使用`typst`进行排版
- 主要考虑到使得一页纸能够装下更多的内容，舍弃了一定的美观度

> 不得不吐槽，用普通的A4纸大家都方便，非要使用纸张大小都参差不齐的一页纸，但是也考虑到防止作弊好像这也只能忍受，但是真恶心🤮

![show](https://pub-0e8efcc4330948248cee44d22f062746.r2.dev/PicGo/20260709122308334.png)

![s](https://pub-0e8efcc4330948248cee44d22f062746.r2.dev/PicGo/20260709165806286.png)

# 配置说明

> 可以参考`circuit.typ`的配置内容，这是目前我最后完成的一个一页纸

## 纸张大小和距离

- 需要注意的是，我遇到的各个学院各个批次的**一页纸大小**和**印刷距离**都是有一定的偏差的
- 因此，想要准确的配置，可能需要手动进行测量，相关的参数我写了较为详细的参数，但是也需要使用的人针对自己手上的一页纸完成配置和验证

```typst
#let real-width = 192mm   // 实际宽度
#let real-height = 265mm  // 实际高度

// ==========  安全边距  ==========
#let safe-left = 3mm
#let safe-right = 3mm
#let safe-top = 3mm
#let safe-bottom = 3mm

// ========== 预印说明文字区域(精确测量,单位 mm) ==========
// 说明文字矩形框的边界(即你希望避让的区域)
#let stamp-top = 21mm          // 说明文字顶部到纸顶的距离
#let stamp-bottom = 80mm       // 说明文字底部到纸顶的距离
#let stamp-left = 21mm         // 说明文字左边界到纸左的距离
#let stamp-right = 172mm       // 说明文字右边界到纸左的距离
.....
```

## 字体配置

- 考虑到大量内容的时候需要极小字体，因此选择无衬线字体，正文使用中文思源黑体与英文Inter结合
- 对于数字字体也是同样的考虑，当然也可以直接删除这部分内容，默认的现代公式字体肯定是更加美观的

> ⚠️对于字符间距的设置需要谨慎，如果空间足够这里最好保持默认即可

```typst
// ========== 字体设定(中文思源黑体 + 英文 Inter) ==========
#set text(
  font: (
    // 第一项:英文和拉丁字符专用 Inter
    (name: "Inter", covers: "latin-in-cjk"),
    // 第二项:中文(含标点)和所有其他文字使用思源黑体
    "Source Han Sans",
    // 更多备选回退字体
    "Microsoft YaHei",
    "SimHei",
  ),
  size: 7.9pt,
  hyphenate: true,
  costs: (hyphenation: 100%, runt: 0%, widow: 0%, orphan: 0%),
  tracking: -0.5pt, // ! 字符间距，谨慎调整：注意字体本身就内含了间距，所以调整为负不会导致字重合
)
// 数学字体微调,设置无衬线字体
#show math.equation: set text(font: (
  "Fira Math",
  "Inter",
  "Source Han Sans",
))
```

## 其它间距

- 对于行距、段间距等配置可以根据实际情况调整
- 后面有很多我对于一些公式或者符号的距离压缩，但是实际上影响不大，删除了也没啥关系
- 包括后面，因为我移动通信内容实在太多，我用了一个正则替换吧中文标点全变成英文的半角标点，其实空间不是太紧张的话就没有必要

```typst
// ========== 其他样式设定(如颜色、行距等) ==========
#set par(
  leading: 0.7em, // 行距
  spacing: 0.7em, // 段间距
)

// 强行压缩独立公式块的上下外边距，默认值较大，改为 0.4em 甚至更低
#show math.equation.where(block: true): set block(above: 0.3em, below: 0.3em)
......
```

## 颜色和考点框

- 颜色根据AI的建议使用了较深的色彩，用了4中不同的颜色来表示不同的重要级别
- 所谓考点框就是用于快速定位，考虑到空间的占用，使用了考点颜色框加上左侧的颜色条

![box](https://pub-0e8efcc4330948248cee44d22f062746.r2.dev/PicGo/20260709122357029.png)

```typst
// ==================== 打印级颜色核心配置 ====================
// 级别 1：【核心必考 / 超级公式】 - 高警示度朱红色（红偏橘，考场上第一眼看到）
#let my-red = rgb("d32f2f")
// 级别 2：【高频考点 / 核心概念】 - 深邃湖蓝色（理智、清晰，适合大段核心知识点）
#let my-blue = rgb("0288d1")
// 级别 3：【次要考点 / 补充定义】 - 稳重橄榄绿（不刺眼，用于区分常规概念）
#let my-green = rgb("388e3c")
// 级别 4：【普通标记 / 题型分类】 - 暗夜紫罗兰（低调但有高对比度，适合分类标签）
#let my-purple = rgb("7b1fa2")
// =========================================================

// 定义快速调用的函数
#let alert(content) = text(fill: my-red, content)
#let info(content) = text(fill: my-blue, content)
#let success(content) = text(fill: my-green, content)
#let common(content) = text(fill: my-purple, content)


// 配置考点框
#let kp-mix-box(clr, body) = box(
  // 左边用 2pt 粗线，上、右、下用 0.4pt 超细线，颜色可以用同一个，也可以分明暗
  stroke: (
    left: 2pt + clr,
    top: 0.7pt + clr.lighten(30%),
    right: 0.7pt + clr.lighten(30%),
    bottom: 0.7pt + clr.lighten(30%),
  ),
  radius: (left: 0pt, right: 1.5pt), // 左边直角对齐条，右边圆角收尾
  inset: (left: 2pt, right: 0.5pt, y: 0pt), // ! box内边距
  outset: (y: 1.2pt), // !box外边距，调整外边距而不是内边距，可以防止其带来的行距的加大
  baseline: 0%,
  [*#body*],
)
```

## 顶部区域控制

- 顶部其实是有较大的空余空间的，可以利用起来
- 后面几个`#place`内容其实都是在对一些位置进行框选，`typst`支持精确的定位，所以可以手动测量位置精确进行把握

![top](https://pub-0e8efcc4330948248cee44d22f062746.r2.dev/PicGo/20260709122413812.png)

# 正文说明

- 正文我是采用的三列，然后每列间距为2mm，可以自行控制
- 想要准确和清晰的分配自己的内容，需要一定程度掌握相关语法

```typst
#columns(3, gutter: 2mm)[
  正文内容
]
```

# 注意点

- 需要一定程度了解typst的语法，我是觉得比LaTeX方便的
- 在制作一页纸都时候不要太过关注格式，等把基本的内容都写好之后，再设置行距，字体大小等等
- `doc/`下是对应两个示例的PDF，可以作为一个简要的参考
- 在快点印务打印的时候，如果他那没有打印好，实际设置的精确距离反而会出现一些问题，可以稍微注意这个问题

> 😁这两门课应该是我本科最后的开卷课程了，最后效果还行，现代通信系统2期末90，通信电路期末89，也是超乎我的意料了
