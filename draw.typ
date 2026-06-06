// ==================== 1. 基础图形宏定义 (纯原生 Typst 语法) ====================

// 绘制一个带箭头的导线
#let arrow(start, end, stroke: 0.8pt + black) = {
let (x1, y1) = start
let (x2, y2) = end

// 1. 绘制主干线段
place(line(start: start, end: end, stroke: stroke))

// 2. 自动计算方向并绘制箭头
let dx = (x2 - x1) / 1cm
let dy = (y2 - y1) / 1cm
let len = calc.sqrt(dx * dx + dy * dy)
if len > 0 {
let angle = calc.atan2(dy, dx)
place(
dx: x2,
dy: y2,
rotate(angle, origin: (left))[
#line(start: (0pt, 0pt), end: (-6.5pt, -3pt), stroke: stroke)
#line(start: (0pt, 0pt), end: (-6.5pt, 3pt), stroke: stroke)
]
)
}
}

// 绘制矩形功能模块框
#let block-box(pos, width, height, label) = {
let (x, y) = pos
place(
dx: x,
dy: y,
rect(
width: width,
height: height,
stroke: 1.0pt + black,
radius: 0pt,
fill: white,
align(center + horizon, label)
)
)
}

// 绘制带斜向可调箭头的乘法/权重器
#let phase-rotator(center, r: 0.3cm) = {
let (cx, cy) = center
place(dx: cx - r, dy: cy - r, circle(radius: r, stroke: 0.8pt + black, fill: white))
// 穿过圆圈的斜向箭头
arrow((cx - 0.35cm, cy + 0.35cm), (cx + 0.4cm, cy - 0.4cm))
}

// ==================== 2. 框图实体排列绘制 ====================

#set text(font: "Source Han Sans", size: 8.5pt)

// 使用一个 block 块包装作为画布容器，您可以根据版面大小任意微调其宽高
#block(width: 15.5cm, height: 7.2cm, stroke: none, {

// --- A. 核心节点坐标参数 (微调此处的 cm 数值即可任意缩短/拉长线段) ---
let input-x = 0.2cm           // 信号输入 r(t) 的起点
let bus-x = 1.8cm             // 输入信号分发竖线的横坐标
let block-w = 2.8cm           // 各个方框的宽度
let block-h = 0.8cm           // 各个方框的高度
let left-box-x = 2.8cm        // 左侧两列方框的横坐标起点
let path-box-x = 7.8cm        // “路径选择”方框的横坐标起点
let rotator-x = 10.2cm        // 相位控制圆圈的中心横坐标
let adder-x = 13.5cm          // 加法器中心的横坐标

// 各个支路的纵坐标 (y 轴)
let y-sync = 0.5cm            // 同步捕获支路
let y-branch1 = 2.0cm         // RAKE支路 1
let y-branch2 = 3.5cm         // RAKE支路 2 (第二路)
let y-branchM = 5.5cm         // RAKE支路 M (最后一路)

// --- B. 绘制输入信号与分发竖线 ---
place(dx: input-x, dy: y-branch2 + 0.4cm - 0.5em, [$r(t)$])
arrow((input-x + 0.9cm, y-branch2 + 0.4cm), (bus-x, y-branch2 + 0.4cm))

// 分发竖线
place(line(start: (bus-x, y-sync + 0.4cm), end: (bus-x, y-branchM + 0.4cm), stroke: 0.8pt + black))
// 分接点的小圆黑点
place(dx: bus-x - 2pt, dy: y-branch2 + 0.4cm - 2pt, circle(radius: 2pt, fill: black))
place(dx: bus-x - 2pt, dy: y-branchM + 0.4cm - 2pt, circle(radius: 2pt, fill: black))

// 分发到各个模块的水平输入箭头
arrow((bus-x, y-sync + 0.4cm), (left-box-x, y-sync + 0.4cm))
arrow((bus-x, y-branch1 + 0.4cm), (left-box-x, y-branch1 + 0.4cm))
arrow((bus-x, y-branch2 + 0.4cm), (left-box-x, y-branch2 + 0.4cm))
arrow((bus-x, y-branchM + 0.4cm), (left-box-x, y-branchM + 0.4cm))

// --- C. 绘制所有功能方框 ---
block-box((left-box-x, y-sync), block-w, block-h, [同步捕获/跟踪])
block-box((path-box-x, y-sync), block-w, block-h, [路径选择])

block-box((left-box-x, y-branch1), block-w, block-h, [RAKE 支路 1])
block-box((left-box-x, y-branch2), block-w, block-h, [RAKE 支路 1])
block-box((left-box-x, y-branchM), block-w, block-h, [RAKE 支路 1])

// --- D. 绘制控制连线 ---
// 1. 同步捕获/跟踪 -> 路径选择
arrow((left-box-x + block-w, y-sync + 0.4cm), (path-box-x, y-sync + 0.4cm))
place(dx: left-box-x + block-w + 0.3cm, dy: y-sync - 0.2cm, text(8pt)[相位控制])

// 2. 路径选择 -> RAKE 支路 (斜向指示箭头)
let ctrl-start = (path-box-x + 0.6cm, y-sync + block-h)
arrow(ctrl-start, (left-box-x + block-w - 0.4cm, y-branch1))
arrow(ctrl-start, (left-box-x + block-w - 0.4cm, y-branch2))
arrow(ctrl-start, (left-box-x + block-w - 0.4cm, y-branchM))

// --- E. 支路输出信号线与其上的相位调节圆圈 ---
// 支路1
arrow((left-box-x + block-w, y-branch1 + 0.4cm), (rotator-x - 0.3cm, y-branch1 + 0.4cm))
place(dx: left-box-x + block-w + 0.9cm, dy: y-branch1 + 0.05cm, [$Z_1$])
phase-rotator((rotator-x, y-branch1 + 0.4cm))

// 支路2
arrow((left-box-x + block-w, y-branch2 + 0.4cm), (rotator-x - 0.3cm, y-branch2 + 0.4cm))
place(dx: left-box-x + block-w + 0.9cm, dy: y-branch2 + 0.05cm, [$Z_2$])
phase-rotator((rotator-x, y-branch2 + 0.4cm))

// 支路M
arrow((left-box-x + block-w, y-branchM + 0.4cm), (rotator-x - 0.3cm, y-branchM + 0.4cm))
place(dx: left-box-x + block-w + 0.9cm, dy: y-branchM + 0.05cm, [$Z_M$])
phase-rotator((rotator-x, y-branchM + 0.4cm))

// --- F. 垂直省略号 (Dots) ---
place(dx: left-box-x + block-w / 2, dy: y-branch2 + 1.1cm, text(size: 15pt)[$dots.v$])
place(dx: rotator-x - 0.1cm, dy: y-branch2 + 1.1cm, text(size: 15pt)[$dots.v$])
place(dx: adder-x - 0.1cm, dy: y-branch2 + 1.1cm, text(size: 15pt)[$dots.v$])

// --- G. 加法器并联汇集连线 ---
let adder-r = 0.4cm
// 绘制加法器圆圈 (包含里面的十字)
place(dx: adder-x - adder-r, dy: y-branch2 + 0.4cm - adder-r, circle(radius: adder-r, stroke: 1.0pt + black, fill: white))
place(line(start: (adder-x - 0.25cm, y-branch2 + 0.4cm), end: (adder-x + 0.25cm, y-branch2 + 0.4cm), stroke: 0.8pt + black))
place(line(start: (adder-x, y-branch2 + 0.4cm - 0.25cm), end: (adder-x, y-branch2 + 0.4cm + 0.25cm), stroke: 0.8pt + black))

// 支路1权重输出连线 -> 加法器顶部
place(line(start: (rotator-x + 0.3cm, y-branch1 + 0.4cm), end: (adder-x, y-branch1 + 0.4cm), stroke: 0.8pt + black))
arrow((adder-x, y-branch1 + 0.4cm), (adder-x, y-branch2 + 0.4cm - adder-r))
place(dx: rotator-x + 1.4cm, dy: y-branch1 + 0.05cm, [$a_1$])

// 支路2权重输出连线 -> 加法器左侧
arrow((rotator-x + 0.3cm, y-branch2 + 0.4cm), (adder-x - adder-r, y-branch2 + 0.4cm))
place(dx: rotator-x + 1.4cm, dy: y-branch2 + 0.05cm, [$a_2$])

// 支路M权重输出连线 -> 加法器底部
place(line(start: (rotator-x + 0.3cm, y-branchM + 0.4cm), end: (adder-x, y-branchM + 0.4cm), stroke: 0.8pt + black))
arrow((adder-x, y-branchM + 0.4cm), (adder-x, y-branch2 + 0.4cm + adder-r))
place(dx: rotator-x + 1.4cm, dy: y-branchM + 0.05cm, [$a_M$])

// --- H. 最终总输出 ---
arrow((adder-x + adder-r, y-branch2 + 0.4cm), (adder-x + 1.8cm, y-branch2 + 0.4cm))
place(dx: adder-x + 0.7cm, dy: y-branch2 + 0.05cm, [$Z_("OUT")$])
})