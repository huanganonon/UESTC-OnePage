#let real-width = 210mm   // 实际宽度
#let real-height = 296mm  // 实际高度

// ========== 安全边距（不含顶部，顶部由显式间距控制） ==========
#let safe-left = 10mm
#let safe-right = 10mm
#let safe-top = 3mm
#let safe-bottom = 8mm

// ========== 预印说明文字区域（精确测量，单位 mm） ==========
// 说明文字矩形框的边界（即你希望避让的区域）
#let stamp-top = 15mm          // 说明文字顶部到纸顶的距离
#let stamp-bottom = 45mm       // 说明文字底部到纸顶的距离
#let stamp-left = 15mm         // 说明文字左边界到纸左的距离
#let stamp-right = 195mm       // 说明文字右边界到纸左的距离（假设纸宽210）

// 计算方便使用的值
#let stamp-height = stamp-bottom - stamp-top
#let stamp-width = stamp-right - stamp-left
#let content-width = real-width - safe-left - safe-right

#set page(
  width: real-width,
  height: real-height,
  margin: (
    top: safe-top, // 关键：不设顶部边距
    bottom: safe-bottom,
    left: safe-left,
    right: safe-right,
  ),
)

// ========== 字体设定（中文思源黑体 + 英文 Inter） ==========
#set text(
  font: (
    // 第一项：英文和拉丁字符专用 Inter
    (name: "Inter", covers: "latin-in-cjk"),
    // 第二项：中文（含标点）和所有其他文字使用思源黑体
    "Source Han Sans",
    // 更多备选回退字体
    "Microsoft YaHei",
    "SimHei",
  ),
  size: 10pt,
)

// ========== 其他样式设定（如颜色、行距等） ==========
#set par(
  leading: 1em, // 行距
)

// 辅助函数：画绿色虚线矩形，表示预印区域
#let draw-stamp-box() = {
  place(
    // !这里绘制区域时是在设置的页边距基础上定位的
    dx: stamp-left - safe-left,
    dy: stamp-top - safe-top,
    rect(
      width: stamp-width,
      height: stamp-height,
      fill: none,
      stroke: (dash: "dashed", paint: green, thickness: 0.5pt),
      [
        *预印区域*
      ],
    ),
  )
}

// 在文档中调用一次，画框
#draw-stamp-box()


// 跳过预印区，主正文从说明文字下方开始
// !注意：这里的高度是从 safe-top 开始计算的，因为 page 的 margin 已经设置了 safe-top 了
#block(height: stamp-bottom - safe-top)
// 这里可以放置正文内容




