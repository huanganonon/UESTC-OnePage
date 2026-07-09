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


// ========== 再次细致配置距离 ==========
#let name-top = 37mm           // 姓名书写位置下方
#let name-top-up = 33mm        // 姓名书写位置下方
#let seal-left = 120mm         // 印章左所在位置
#let attention-top = 58mm      // 注意事项上所在位置
#let title-left = 59mm         // 标题左与左边距离
#let title-right = 134mm       // 标题右与左边距离


// 计算方便使用的值
#let stamp-height = stamp-bottom - stamp-top
#let stamp-width = stamp-right - stamp-left
#let content-width = real-width - safe-left - safe-right

#set page(
  width: real-width,
  height: real-height,
  margin: (
    top: safe-top, // 关键:不设顶部边距
    bottom: safe-bottom,
    left: safe-left,
    right: safe-right,
  ),
)

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

// ========== 其他样式设定(如颜色、行距等) ==========
#set par(
  leading: 0.7em, // 行距
  spacing: 0.7em, // 段间距
)

// 强行压缩独立公式块的上下外边距，默认值较大，改为 0.4em 甚至更低
#show math.equation.where(block: true): set block(above: 0.3em, below: 0.3em)

// 单独设置公式打字，设置为正文的 90%
#show math.equation.where(block: false): set text(size: 0.9em)

// 让行内公式里的文字挨得更紧凑
#show math.equation.where(block: false): set text(tracking: -0.5pt)

// 设置方括号矩阵
#set math.mat(delim: "[")


// 替换符号，减少空间占用
#show math.plus: it => math.class("normal", it)// 1. 拦截所有的“+”号，干掉两侧间距
#show math.minus: it => math.class("normal", it)// 2. 拦截所有的“-”号（注意在数学里它是减号 minus）
#show math.eq: it => math.class("normal", it)// 3. 拦截所有的“=”号
#show math.lt: it => math.class("normal", it)// 4. 如果你用了其他符号（如 <, >, * ），也可以照葫芦画瓢加上：
#show math.gt: it => math.class("normal", it)
#show math.arrow: it => math.class("normal", it)
#show math.approx: it => math.class("normal", it)
#show math.lt.double: it => math.class("normal", it)
#show math.gt.double: it => math.class("normal", it)
#show math.prop: it => math.class("normal", it)
#show math.eq.not: it => math.class("normal", it)
#show math.arrow.double: it => math.class("normal", it)
#show math.arrow.l.r.double: it => math.class("normal", it)
#show math.bar.v: it => math.class("normal", it)
#show math.angle: it => math.class("normal", it)

// 自动将全角标点替换为半角标点
#show regex("[，。？！、：；（）「」【】]"): it => {
  let mapping = (
    "，": ",",
    "。": ".",
    "？": "?",
    "！": "!",
    "、": ",",
    "：": ":",
    "；": ";",
    "（": "(",
    "）": ")",
    "「": "[",
    "」": "]",
    "【": "[",
    "】": "]",
  )
  mapping.at(it.text, default: it.text)
}



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


// // ==================== 打印级颜色核心配置 ====================
// // 级别 1：【核心必考 / 超级公式】 - 高警示度朱红色（红偏橘，考场上第一眼看到）
// #let clr-red = rgb("d32f2f")

// // 级别 2：【高频考点 / 核心概念】 - 深邃湖蓝色（理智、清晰，适合大段核心知识点）
// #let clr-blue = rgb("0288d1")

// // 级别 3：【次要考点 / 补充定义】 - 稳重橄榄绿（不刺眼，用于区分常规概念）
// #let clr-green = rgb("388e3c")

// // 级别 4：【普通标记 / 题型分类】 - 暗夜紫罗兰（低调但有高对比度，适合分类标签）
// #let clr-purple = rgb("7b1fa2")
// // =========================================================




// 辅助函数:画绿色虚线矩形,表示预印区域
#let draw-stamp-box(content) = {
  place(
    // !这里绘制区域时是在设置的页边距基础上定位的
    dx: stamp-left - safe-left,
    dy: stamp-top - safe-top,
    clearance: 0em,
    rect(
      width: stamp-width,
      height: stamp-height,
      fill: none,
      inset: 0em,
      outset: 0em,
      stroke: (dash: "dashed", paint: green, thickness: 1pt),
      [
        #content
      ],
    ),
  )
}

// 在文档中调用一次,画框
#draw-stamp-box([])

// 左上角框
#place(
  dx: 0mm,
  dy: 0mm,
  clearance: 0em,
  rect(
    width: title-left - safe-left,
    height: name-top-up - safe-top, // 留出一点空隙
    fill: none,
    stroke: (dash: "dashed", paint: blue, thickness: 1pt),
    inset: 0pt,
    outset: 0pt,
    [
      #image("figures/射频放大器设计-重绘.png")
    ],
  ),
)

// 顶部空余
#place(
  dx: title-left - safe-left + 0.3mm,
  dy: 0mm,
  clearance: 0em,
  rect(
    width: title-right - title-left - 0.6mm,
    height: stamp-top - safe-top - 0.5mm, // 留出一点空隙
    fill: none,
    stroke: (dash: "dashed", paint: purple, thickness: 1pt),
    inset: 0pt,
    outset: 0pt,
    [
      $e^(i theta) = cos theta + i sin theta$，$k = 1.38 times 10^(-23) J \/ K$,$Gamma = Gamma_r + j Gamma_i = |Gamma| angle theta$,$Gamma_r^2 + (Gamma_i - (1) / (Q_n))^2 = 1 + (1) / (Q_n^2) , x < 0$,$Gamma_r^2 + (Gamma_i + (1) / (Q_n))^2 = 1 + (1) / (Q_n^2) , x > 0$
    ],
  ),
)

// 右上角框
#place(
  dx: title-right - safe-left,
  dy: 0mm,
  clearance: 0em,
  rect(
    width: title-left - safe-left,
    height: name-top-up - safe-top, // 留出一点空隙
    fill: none,
    stroke: (dash: "dashed", paint: blue, thickness: 1pt),
    inset: 0pt,
    outset: 0pt,
    [
      #image("figures/Hartley频域-重绘.png")
    ],
  ),
)

// 中间空隙
#place(
  dx: 0mm,
  dy: name-top - safe-top,
  clearance: 0em,
  rect(
    width: seal-left,
    height: attention-top - name-top, // 留出一点空隙
    fill: none,
    stroke: (dash: "dashed", paint: blue, thickness: 1pt),
    inset: 0pt,
    outset: 0pt,
    [
      #box(image("figures/等效电路-重绘.png"))
    ],
  ),
)

// 顶部小区域(放在说明文字上方)
#let top-area-y = 2mm             // 顶部小框距纸顶的微调距离
#let top-area-height = stamp-top - top-area-y - 2mm   // 留出上下空隙



// 跳过预印区,主正文从说明文字下方开始
// !注意:这里的高度是从 safe-top 开始计算的,因为 page 的 margin 已经设置了 safe-top 了
#block(height: stamp-bottom - safe-top)
// 这里可以放置正文内容

#columns(3, gutter: 2mm)[
  测试内容
]