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
  size: 8pt,
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
      stroke: (dash: "dashed", paint: green, thickness: 0.5pt),
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
    stroke: (dash: "dashed", paint: blue, thickness: 0.4pt),
    inset: 0pt,
    outset: 0pt,
    [

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
    stroke: (dash: "dashed", paint: purple, thickness: 0.4pt),
    inset: 0pt,
    outset: 0pt,
    [
      $e^(i theta) = cos theta + i sin theta$，$k = 1.38 times 10^(-23) J \/ K$
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
    stroke: (dash: "dashed", paint: blue, thickness: 0.4pt),
    inset: 0pt,
    outset: 0pt,
    [

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
    stroke: (dash: "dashed", paint: blue, thickness: 0.4pt),
    inset: 0pt,
    outset: 0pt,
    [

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
  #kp-mix-box(my-purple, [电磁波传播特性]) *自由空间传播*：$P_r = P_t G_t G_r (lambda / (4 pi d))^2$,$L=P_t/P_r$, $L("dB") = 32.45 + 20 lg f("MHz") + 20 lg d("km") - 10 lg G_T - 10 lg G_R$ *媒介对传播特性的影响*：传输损耗（吸收，散射，绕射）；衰落现象（吸收性，干涉性，极化/相位起伏）；传输失真（色散，多径）；传播方式（视距，天波，地波，不均匀媒质）

  #kp-mix-box(my-purple, [无线信道特性]) *哈莱特定律*：$I=K B T$,$I$为信息容量,$B$为系统带宽,$T$为传输时间,$K$比例系数取决于通信方式；*香农公式*：$C_t = B log_2 (1 + "SNR")$(bps)

  #kp-mix-box(my-green, [通信系统组成]) 频谱/功率/效率，灵敏度/选择性
  #image("figures/通信系统结构.pdf")
  #image("figures/发射机.pdf")
  #image("figures/接收机.pdf")
  #success([设计要求])：良好的选择性；低噪声、高动态范围；接收机对于杂散频率有良好的抑制能力；本振信号应该具有很低的相位噪声；发射机必须严格限制带外辐射；射频级必须低功耗；发射机功放要求有高的功率增加效率

  #kp-mix-box(my-purple, [发展趋势]) 高频率化；高速率化；集成化和小型化；低功耗；数字化/智能化；低价与人性化

  #kp-mix-box(my-blue, [接收机性能指标]) 选择性（除/减少干扰信号和寄生频率信号影响）；灵敏度（保证特定通信距离和正确解调）；动态范围（确定正确解调的信号变化范围）。

  #kp-mix-box(my-red, [单次变频超外差]) #info([*变频特点*])：频率降低，频谱结构不变；#info([*结构*])：*LNA*:射频放大；*变频器*：频谱搬移；*中频放大*：选信道/主增益
  #image("figures/单次变频超外差接收.png")
  #info([*特点*])：BPF1作频带选择BPF2作信道选择，实现频带选择和信道的分离；合理分配系统增益，放大器稳定性好；适用于信号载频远高于中频频率的情况；在较低固定中频上放大，ADC和解调较容易。#info([*缺点*]):镜像干扰(选择高中频或镜频抑制滤波器);组合干扰(减小混频器非线性) $|p omega_("LO") plus.minus q omega_("RF")|$ #info([*高中频与低中频*])：*高*镜像频率远离有用信号，滤波容易，利于抗镜频干扰；*低*：相同Q值条件下，中频滤波器窄带，利于选择信道/稳定的高增益

  #kp-mix-box(my-red, [二次变频超外差]) #info([*特点*])：高第一中频有利于镜频抑制，有好的频带选择性；低第二中频有利于IFA的稳定性和降低对解调器的要求。#info([*原则*]):第一中频尽量高；第二种品尽量低；增益大部分由IFA2完成
  #image("figures/二次变频超外差.png")

  #kp-mix-box(my-red, [零中频（直接下变频）]) #info([*优点*])：不存在镜像频率，无镜频信号干扰；可用低通滤波器选择信道；易解决匹配、线性动态范围等问题。 #info([*问题*])：本振泄露(本振频率与信号频率相同)；LNA偶次谐波失真干扰(两干扰$|f_1 - f_2 approx 0|$,LNA非线性输出，混频器会直接漏掉这个干扰)；直流偏差(本振泄露/强干扰自混频)；$1/f$噪声 #info([*原则*])：保证$omega_("LO")$与$omega_("RF")$同频，且彼此之间的相位关系固定，需要载波提取与锁相同步;混频器应有较高的线性度;端口间隔离度要求高 #common([*优化*]):*宽带零中频*，对射频信号完全同步困难，先将射频下变频到低频，再做直接下变频，此时同步较为容易
  #image("figures/零中频.png")
  #image("figures/宽带零中频.png")

  #kp-mix-box(my-blue, [Hartley]) $v_("RF") (t) = V_("RF") cos omega_("RF") t, v_E (t) = V_("RF") cos(omega_("LO") - omega_("RF"))t$,$v_("B")(t) = V_("RF")/2 sin(omega_("LO")-omega_("RF"))t + V_("IM")/2 sin (omega_("LO")-omega_("IM"))t$,$v_C (t) = V_("RF")/2 cos(omega_("LO")-omega_("RF"))t + V_("IM")/2 cos (omega_("LO")-omega_("IM"))t$,$v_("D")(t) = V_("RF")/2 cos(omega_("LO")-omega_("RF"))t - V_("IM")/2 cos (omega_("LO")-omega_("IM"))t$($omega_("IM") < omega_("LO") < omega_("RF")$)
  // ? $v_("RF")(t) = V_("RF") cos omega_("RF")t$，对应镜像$v_("IM")(t) = V_("IM") cos omega_("IM")t$，得到$v_("B")(t) = V_("RF")/2 sin(omega_("LO")-omega_("RF"))t + V_("IM")/2 sin (omega_("LO")-omega_("IM"))t$,$v_C (t) = V_("RF")/2 cos(omega_("LO")-omega_("RF"))t + V_("IM")/2 cos (omega_("LO")-omega_("IM"))t$
  #image("figures/Hartley结构.png")
  #image("figures/Hartley频域.png")
  // #image("figures/Weaver结构.png")

  #kp-mix-box(my-red, [数字中频]) 将第二次混频和滤波数字化；可避免I/Q两路的不一致；对A/D变换器要求很高(转换速度高/较高的分辨率和较小的噪声/线性度高/较大的动态范围)
  #image("figures/数字中频.png")

  #kp-mix-box(my-blue, [发射机性能指标]) 频谱纯度；功率；效率（PA/天线/信号传输）

  #kp-mix-box(my-red, [直接变换法]) #info([*缺点*])：发射频率等于本振频率，发射强信号会影响本振源 #info([*改进*])：可以使用两个较低本振合成
  #image("figures/直接变换.png")
  #image("figures/双本振直接变换.png")

  #kp-mix-box(my-red, [两步法/间接调制]) 在较低的频率上调制，再上变频到发射频率；较低频率处调制容易，降低了滤波器要求，有助于复杂调制；对上变频滤波器要求高，存在变频组合干扰且结构复杂
  #image("figures/两步法.png")

  #image("figures/传输线方向.png")
  #kp-mix-box(my-green, [传输线模型]) #common([*传输线/电报方程*]):$(d^2 V(z)) / (d z^2) - gamma^2 V(z) = 0$,$(d^2 I(z)) / (d z^2) - gamma^2 I(z) = 0$ #alert([*传播常数*]):$gamma = alpha + j beta = sqrt((R + j omega L)(G + j omega C))$ #common([*电压电流解*]):$V(z) = V_0^+ e^(-gamma z) + V_0^- e^(gamma z)$, $I(z) = I_0^+ e^(-gamma z) + I_0^- e^(gamma z)$,$V^+ (z) = V^+_0 e^(- gamma z)$,$V^- (z) = V^-_0 e^( gamma z)$ #alert([*特征阻抗*])：$Z_0 = V_0^+ / I_0^+ = -V_0^- / I_0^- = (R + j omega L)/gamma$ #alert([*负载阻抗*])：$Z(0) = Z_L = Z_0 (1 + Gamma_0)/(1 - Gamma_0)$#alert([*反射系数*]):$Gamma_0 = Gamma(0) = (Z_L - Z_0)/(Z_L + Z_0)$

  #kp-mix-box(my-red, [无耗线])$R = G = 0$,$alpha = 0$,$beta = omega sqrt(L C)$,$gamma = j beta$,$Gamma(z) = (V^- (z))/(V^+ (z)) = Gamma_0 e^(2 j beta z)$ #info([*相速*])：$lambda = v_P/f$,$v_P = 1/sqrt(L C)$,$beta = omega/v_P = (2pi)/lambda$ #alert([*驻波比*])：$"SWR" = (|V_("max")|)/(|V_("min")|) = (1+|Gamma|)/(1-|Gamma|)$ #alert([*输入阻抗*])：$Z_("in") (z) = Z_0 (1 + Gamma(z))/(1 - Gamma(z))$

  #kp-mix-box(my-red, [短路线]) $V(z) = -2 j V_0^+ sin beta z$,$I(z) = (2V_0^+)/Z_0 cos beta z$,$Z_("in") = j Z_0 tan beta l$

  #kp-mix-box(my-red, [开路线]) $V(z) = 2 V_0^+ cos beta z$,$I(z) = (-2 j V_0^+)/Z_0 sin beta z$,$Z_("in") = -j Z_0 cot beta l$

  #kp-mix-box(my-red, [特定长度]) $l= n lambda/2$则$Z_("in") = Z_L$;$l= lambda/4 + n lambda/2$则$Z_("in") = Z_0^2/Z_L$

  #image("figures/二端口网络.png")
  #kp-mix-box(my-blue, [阻抗导纳]) $mat(v_1; v_2) = mat(z_11, z_12; z_21, z_22) mat(i_1; i_2)$,$z_("ij") = v_i/i_j |_(i_k=0,k != j)$;$mat(i_1; i_2) = mat(y_11, y_12; y_21, y_22) mat(v_1; v_2)$,$y_("ij") = i_i/v_j |_(v_k = 0, k != j)$;$bold(Z) = bold(Y)^(-1)$; #common([*互易网络*])：对称矩阵($z_(1 2) = z_(2 1)$) #common([*无耗网络*])：纯虚数

  #kp-mix-box(my-blue, [混合参量]) $mat(v_1; i_2) = mat(H_11, H_12; H_21, H_22) mat(i_1; i_2)$,$H_11 = v_1/i_1 |_(v_2 = 0)$输入阻抗,$H_12 = v_1/v_2 |_(i_1 = 0)$反向电压增益,$H_21 = i_2/i_1 |_(v_2 = 0)$正向电流增益,$H_22 = i_2/v_2 |_(i_1 = 0)$输出导纳

  #kp-mix-box(my-red, [S参量]) #info([*归一化入射/反射电压波*])$a_n = (V_n + Z_0 I_n)/(2sqrt(Z_0))=V_n^+/sqrt(Z_0)=sqrt(Z_0) I_n^+$,$b_n = (V_n - Z_0 I_n)/(2sqrt(Z_0)) = V_n^-/sqrt(Z_0) = -sqrt(Z_0)I_n^-$;$V_n = sqrt(Z_0)(a_n + b_n)$,$I_n = (a_n - b_n)/sqrt(Z_0)$;$V_n = V_n^+ + V_n^- = Z_0 I_n^+ - Z_0 I_n^-$ #alert([*定义*])：$mat(b_1; b_2) = mat(S_11, S_12; S_21, S_22)mat(a_1; a_2)$,$S_11 = b_1/a_1 |_(a_2 = 0)$,$S_21 = b_2/a_1 |_(a_2 = 0)$,$S_22 = b_2/a_2 |_(a_1 = 0)$,$S_12 = b_1/a_2 |_(a_1 = 0)$,定义式中要求两个端口没有功率波返回，只有#alert([两端传输线匹配])才成立
  #image("figures/S网络.png")
  #alert([*物理意义*]):$S_11 = Gamma_("in") = (Z_("in") - Z_0)/(Z_("in") + Z_0)$回波损耗$R L = -20 log |S_11|$;$S_21 = (2V_2^-)/V_("G1") = (2V_2)/V_("G1")$($S_11 = 0$)端口1向端口2的正向电压增益，平方后功率增益$G_0 = |S_21|^2$;$S_22 = Gamma_("out") = (Z_("out")-Z_0)/(Z_("out")+ Z_0)$；$S_12 = (2V_1^-)/V_("G2") = 2V_1 / V_("G2")$($S_22 = 0$)端口2向端口1的反向电压增益；#common([*传输线上*])：$mat(0, e^(-gamma l); e^(-gamma l), 0)$；$[Z] = Z_0 ([I] + [S])([I] - [S])^(-1)$,$[S] = ([z] - [I])([z] + [I])^(-1)$,$[Z]=[z] dot Z_0$

  #kp-mix-box(my-purple, [链形散射]) $mat(a_1; b_1) = mat(T_11, T_12; T_21, T_22)mat(b_2; a_2)$,级联时$bold(T) = bold(T)^A bold(T)^B$；$T = 1/S_21 mat(1, -S_22; S_11, -Delta S)$,$S = 1/T_11 mat(T_21, -Delta T; 1, -T_12)$

  #image("figures/ABCD网络.png")
  #kp-mix-box(my-blue, [ABCD]) $mat(v_1; i_1) = mat(A, B; C, D) mat(v_2; i_2)$,$mat(v_1; i_1) = mat(A_1, B_1; C_1, D_1) mat(A_2, B_2; C_2, D_2) mat(v_3; i_3)$互易则$A D - B C = 1$

  #kp-mix-box(my-purple, [网络连接]) *串联*Z参量相加；*混联*H参量相加；*并联*Y参量相加；*级联*ABCD相乘

  #set math.mat(delim: none)

  #table(
    columns: (0.7fr, 2fr, 2fr, 2fr, 2fr),
    align: center + horizon,
    stroke: 0.3pt,
    inset: 4pt,
    // 紧凑单元格内边距

    [], [$[Z]$], [$[Y]$], [$[h]$], [$[A]$],

    [$[Z]$],
    [$mat(Z_11, Z_12; Z_21, Z_22)$],
    [$mat((Z_22)/(Delta Z), (-Z_12)/(Delta Z); (-Z_21)/(Delta Z), (Z_11)/(Delta Z))$],
    [$mat((Delta Z)/(Z_22), (Z_12)/(Z_22); (-Z_21)/(Z_22), (1)/(Z_22))$],
    [$mat((Z_11)/(Z_21), (Delta Z)/(Z_21); (1)/(Z_21), (Z_22)/(Z_21))$],

    [$[Y]$],
    [$mat((Y_22)/(Delta Y), (-Y_12)/(Delta Y); (-Y_21)/(Delta Y), (Y_11)/(Delta Y))$],
    [$mat(Y_11, Y_12; Y_21, Y_22)$],
    [$mat((1)/(Y_11), (-Y_12)/(Y_11); (Y_21)/(Y_11), (Delta Y)/(Y_11))$],
    [$mat((-Y_22)/(Y_21), (-1)/(Y_21); (-Delta Y)/(Y_21), (-Y_11)/(Y_21))$],

    [$[h]$],
    [$mat((Delta h)/(h_22), (h_12)/(h_22); (-h_21)/(h_22), (1)/(h_22))$],
    [$mat((1)/(h_11), (-h_12)/(h_11); (h_21)/(h_11), (Delta h)/(h_11))$],
    [$mat(h_11, h_12; h_21, h_22)$],
    [$mat((-Delta h)/(h_21), (-h_11)/(h_21); (-h_22)/(h_21), (-1)/(h_21))$],

    [$[A]$],
    [$mat((A)/(C), (Delta A B C D)/(C); (1)/(C), (D)/(C))$],
    [$mat((D)/(B), (-Delta A B C D)/(B); (-1)/(B), (A)/(B))$],
    [$mat((B)/(D), (Delta A B C D)/(D); (-1)/(D), (C)/(D))$],
    [$mat(A, B; C, D)$],
  )

  #kp-mix-box(my-red, [L型网络]) $Q_L = sqrt((R_("大值")) / (R_("小值")) - 1) = (1) / (2) Q_n$,$"BW"_(3"dB") = f_0/Q_L$,$omega_0 = 1/sqrt(L C) sqrt(1- 1/Q_n^2)$,$C = 1/(omega X_P)$,$L = X_S /omega$.#info([*源阻抗更大*])：$Q_L = (X_S) / (R_L) = (R_S) / (X_P) = (R_P) / (X_"SP")$,$R_P = R_L (1 + Q_L^2)$,$X_"SP" = X_S (1 + (1) / (Q_L^2))$ 
  #image("figures/RS大.png")
  #info([*负载更大*])：$Q_L = (X_S) / (R_S) = (R_L) / (X_P) = (X_"PS") / (r_S)$,$r_s = (R_L) / (1 + Q_L^2)$,$X_"PS" = (X_p) / (1 + (1) / (Q_L^2))$
  #image("figures/RL大.png")

  #kp-mix-box(my-red, [Smith圆图]) #success([圆半径越小对应值越大]) #alert([*串联元件-阻抗圆图*])：串联L，沿#info([等电阻圆顺时针])；串联C，沿#info([等电阻圆逆时针])；#alert([*并联元件-导纳圆图*])：并联L，沿#info([等电导圆逆时针])；并联C，沿#info([等电导圆顺时针])；#success([*连接无耗线*])：*顺时针（向电源方向）*或*逆时针（向负载方向）*。#success([*连接短截线*])：纯电抗（电纳）性质，并联使用等电导圆

  #kp-mix-box(my-green, [分立元件和微带线]) #success([*无耗线长度*]) 对应外圈求出长度，旋转一圈是$lambda / 2$(#success([可以直接根据$Gamma$角度变化确定长度]))
  #image("figures/微带线结合电容.png")

  #kp-mix-box(my-green, [单截短截线]) 根据交点求出*电纳*变化值，从$y=0$(开路点)沿着$g = 0$(最大电导圆)*顺时针*旋转到该电纳变化值，对应*长度*为*开路线*长度，加上$lambda / 4$即为短路线长度
  #image("figures/单截短截线.png")

  #kp-mix-box(my-purple, [节点品质因素]) 每个节点$Z_S = R_S + j X_S$,$Y_P = G_P + j B_P$，则定义$Q_n = (|X_S|)/R_S = (|B_P|)/G_P$ #success([*三元件网络最大Q值位置*]) $pi$型网络哪边电阻大最大Q值必定靠近哪边；T型网络相反

  #kp-mix-box(my-red, [等效噪声温度]) $T_e = N_o / (K B G_p)$,温度为$T_e$则对应的噪声功率$k T_e B$,$N_o$为输出噪声功率;#common([*测量*])：$Y = N_1/N_2 = (T_1 + T_e)/(T_2 + T_e)$(两个温度下分别测量)，$T_e = (T_1 - Y T_2)/(Y-1)$

  #kp-mix-box(my-red, [噪声系数]) *定义*：$F = (S_i \/ N_i)/(S_o \/ N_o)$ #info([*使用*])：#common([设信号源在$T_0 = 290K$])下产生热噪声，则$F = 1 + T_e/T_0$,$T_e = (F-1)T_0$;#success([*无源有耗网络*])：噪声系数数值上等于损耗$"NF" = 1/G_p = L$;#success([*级联*])：$T = T_("e1") + 1/G_1 T_("e2") + 1/(G_1 G_2) T_("e3") + dots$,$F = F_1 + 1/G_1 (F_2 -1) + 1/(G_1 G_2) (F_3 -1) + dots$

  #kp-mix-box(my-blue, [非线性效应]) #common([*一个有用信号*])：谐波；增益压缩(实际增益比理想线性增益下降了 1dB 对应的工作点);#common([*两个以上信号*]) (基波+谐波$|p omega_1 + q omega_2|$)：堵塞(有用信号弱)；交叉调制(干扰信号幅度转移到有用信号幅度上)；互调失真(频率接近)

  #kp-mix-box(my-green, [互调失真]) #common([*互调失真比*]):输出互调与输出基波之比，电压幅度比$"IMR" = (3 a_3)/(4 a_1) V_m^2$,功率比$P = ("IMR")^2$;#info([*三阶互调截点$I P_3$*]):三阶互调功率和基波功率相等的点；基波功率$P_(01) = G_(p 1)P_i$,三阶互调功率$P_(03) = G_(p 3)P_i^3$;电压振幅$V_("imIP3") = sqrt(4/3 |a_1/a_3|)$,$V_("im-1dB") = sqrt(0.145 |a_1/a_3|)$(-9.6 dB);#info([*级联特性*])：$1/("IIP"_3) = 1/("IIP"_(3,1)) + G_1/("IIP"_(3,2))+ (G_1 G_2)/("IIP"_(3,3)) + dots$($G_1 = A_1^2$),注意$"OIP"_3 = G_p + "IIP"_3$

  #kp-mix-box(my-purple, [非线性抑制]) 功率回退；负反馈；前馈；预失真

  #kp-mix-box(my-red, [接收机灵敏度]) 接收机输出噪声$N_o$,$"SNR"_o = P_(o,"min")/N_o$,天线噪声温度$T_a$.#alert([*灵敏度*]):$P_("in","min") = k B [T_a + (F-1)T_0]"SNR"_o$,$P_("in","min") ("dBm") = k[T_a + (F-1)T_0]("dBm/Hz") + 10 lg B + "SNR"_o ("dB")$,当$T_a = T_0 = 290K$,$P_("in","min") ("dBm") = -174("dBm/Hz") + "NF"("dB") + 10 lg B + "SNR"_o ("dB")$;#info([*基底噪声*])：$F_t = k[T_a + (F-1)T_0]("dBm/Hz") + 10 lg B$

  #kp-mix-box(my-blue, [动态范围]) 一般是电平/功率比 #info([*线性*])：$"DR"_L = P_("in","1dB") - F_t (P_("in","min"))$ #info([*无杂散*])：下限和前面相同，上限是输出端产生的三阶互调输出折合到输入端等于基底噪声($F_t = (P_("o3"))/G_p$)$"DR"_f("dB") = 1/3 [2"IIP"_3 ("dBm") + F_t ("dBm")] - [F_t ("dBm") + "SNR"_o ("dB")]$

  #kp-mix-box(my-red, [链路分析]) #common([*增益*])：由前向后的原则，注意$L = -G_p$(分贝)；#info([*噪声系数*])：由后向前的原则，#success([无源器件噪声系数等于其插入损耗]),使用级联计算公式；#alert([*三阶截断点*])：#info([由后向前])的原则

  #kp-mix-box(my-green, [滤波器指标]) #common([*插入损耗*])：$"IL" = 10 lg P_("av")/P_L=-20 lg |S_21|$,对于无损网络$"IL" = 10 lg P_("in")/P_L = -10 lg (1 - |Gamma_"in" |^2)$($P_("av")$资用功率，$P_("in")$信号源输入功率)；#common([*波纹*])：衡量带内响应平坦度；#common([*带宽*])；#common([*矩形系数*])：带通滤波器通带与阻带间过渡带宽的陡峭程度$"SF" = ("BW"_("3dB")/("BW"_("60dB")))$;#common([*品质因素*])：空载为在谐振频率下滤波器上一个周期内平均储能与功率损耗的比$Q = omega_c W_("stored")/P_("loss")$;有载$Q_L$接入负载$1/Q_L = 1/Q + 1/Q_E$(外部品质因素),$"BW"_("3dB") = f_c/Q_L$

  #kp-mix-box(my-red, [低通滤波器原型]) #alert([*巴特沃斯*])：$"IL" = 10 lg(1 + a^2 Omega^(2N))$,#success([归一化频率])$Omega = omega/omega_c$,$omega_c$为截止频率,N为滤波器阶数,a取1时$Omega=1$是3dB损耗点；#alert([*切比雪夫*])：$I L = 10 log([1 + a^2 T_"N"^2(Omega)])$,$T_"N" (Omega) = cos({N [cos^(-1)(Omega)]})|Omega| <= 1$,$T_"N" (Omega) = cosh({N [cosh^(-1)(Omega)]}) |Omega| >= 1$,这里a是波纹幅度调节因子$a^2 = 10^("RP"_"IL" \/ 10) - 1$,$"RP"_"IL"$是波纹峰值(dB)；#common([*原型电路*])：$g_0$第一个元件是并联电容则表示电阻，串联电感则表示电导；$g_(N + 1)=1$负载看最后一个元件决定电阻/电导
  #image("figures/原型电路.png")

  #kp-mix-box(my-blue, [频率变换]) #common([*低通*])：$omega = Omega omega_c$,$L' = L/omega_c$,$C' = C/omega_c$;#common([*高通*])：$omega = - omega_c/Omega$,$C' = 1/(omega_c L)$,$L' = 1/(omega_c C)$(电容电感互换);#common([*带通*])：$Omega = ((omega_0) / (omega_U - omega_L))((omega) / (omega_0) - (omega_0) / (omega))$,中心频率$omega_0^2 = omega_U omega_L$;#success([串联电感])$L' = L/(omega_U - omega_L)$,$C' = (omega_U - omega_L)/(omega_0^2 L)$(LC串联谐振)；#success([并联电容])$L' = (omega_U - omega_L)/(omega_0^2 C)$,$C' = C/(omega_U - omega_L)$(LC并联谐振)；#common([*带阻*])：$Omega = {(-omega_0) / (omega_U - omega_L)((omega) / (omega_0) - (omega_0) / (omega))}^(-1)$,$omega_0^2 = omega_U omega_L$；#success([串联电感])$L' = (omega_U - omega_L)/(omega_0^2) L$,$C' = 1/((omega_U - omega_L)L)$(并联LC谐振)；#success([并联电容])：$L' = 1/((omega_U - omega_L)C)$,$C' = (omega_U - omega_L)/(omega_0^2) C$(串联LC谐振)

  #kp-mix-box(my-blue, [阻抗变换]) 阻抗变换之前用的都是归一化的源电阻，源阻抗为$R_G$时，$R_G ' = R_G$,$L' = L R_G$,$C' = C/R_G$,$R_L ' = R_L R_G$
] 
