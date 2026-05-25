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


// ========== 分栏设置 ==========
#columns(
  3, // 双栏
  gutter: 2mm, // 栏间距
)[
  = 第一章 极限与连续

  *夹逼定理*：若 $x_n <= y_n <= z_n$，且 $lim_(n->oo) x_n = lim_(n->oo) z_n = A$，则 $lim_(n->oo) y_n = A$。

  *重要极限*：
  $lim_(x->0) sin x / x = 1$
  $lim_(x->oo) (1 + 1/x)^x = e$

  *连续的定义*：$f(x)$ 在 $x_0$ 处连续当且仅当 $lim_(x->x_0) f(x) = f(x_0)$。

  *间断点分类*：
  - 可去间断点：$lim_(x->x_0) f(x)$ 存在但不等于 $f(x_0)$
  - 跳跃间断点：左右极限存在但不等
  - 无穷间断点：极限趋于 $plus.minus oo$

  *零点定理*：若 $f in C[a,b]$ 且 $f(a) dot f(b) < 0$，则 $exists xi in (a,b)$ 使 $f(xi) = 0$。

  *介值定理*：闭区间上连续函数可取到最大值与最小值之间的任何值。

  #image("figures/winodws-dark.png", width: 8cm)

  = 第二章 导数与微分

  *定义*：$f'(x) = lim_(Delta x->0) (f(x+Delta x) - f(x)) / (Delta x)$

  *基本求导公式*：
  - $(x^n)' = n x^(n-1)$
  - $(sin x)' = cos x$
  - $(cos x)' = -sin x$
  - $(ln x)' = 1/x$
  - $(e^x)' = e^x$
  - $(arctan x)' = 1 / (1 + x^2)$

  *莱布尼茨公式*（两函数乘积的高阶导）：
  $(u v)^((n)) = sum_(k=0)^n binom(n, k) u^((n-k)) v^((k))$

  *链式法则*：若 $y = f(u)$，$u = g(x)$，则 $partial(y)/partial(x) = partial(y)/partial(u) dot partial(u)/partial(x)$。

  *隐函数求导*：对方程 $F(x,y)=0$ 两边对 $x$ 求导，视 $y$ 为 $y(x)$。

  *对数求导法*：对幂指函数 $y = u(x)^(v(x))$，取对数 $ln y = v ln u$ 再求导。

  = 第三章 中值定理与泰勒展开

  *罗尔定理*：$f in C[a,b]$，$f$ 在 $(a,b)$ 可导，$f(a)=f(b)$，则 $exists xi in (a,b)$ 使 $f'(xi) = 0$。

  *拉格朗日*：$exists xi in (a,b)$ 使 $f(b)-f(a) = f'(xi)(b-a)$

  *柯西中值*：若 $g'(x) != 0$，则 $exists xi in (a,b)$ 使 $frac(f(b)-f(a), g(b)-g(a)) = frac(f'(xi), g'(xi))$

  *泰勒公式（拉格朗日余项）*：
  $f(x) = sum_(k=0)^n frac(f^((k))(x_0), k!) (x-x_0)^k + frac(f^((n+1))(xi), (n+1)!) (x-x_0)^(n+1)$

  *麦克劳林展开（常用）*：
  $e^x = 1 + x + x^2/2! + x^3/3! + dots$
  $sin x = x - x^3/3! + x^5/5! - dots$
  #box(width: 43pt)
  $cos x = 1 - x^2/2! + x^4/4! - dots$
  #box(width: 43pt)
  $ln(1+x) = x - x^2/2 + x^3/3 - dots$
  #box(width: 43pt)
  $(1+x)^alpha = 1 + alpha x + $
  #box(width: 43pt)
  $frac(alpha(alpha-1), 2!) x^2 + dots$
]



