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
  size: 7pt,
  hyphenate: true,
  costs: (hyphenation: 100%, runt: 0%, widow: 0%, orphan: 0%),
  tracking: -0.5pt, // ! 字符间距：注意字体本身就内含了间距，所以调整为负不会导致字重合
)
// 数学字体微调,设置无衬线字体
#show math.equation: set text(font: (
  "Fira Math",
  "Source Han Sans",
))

// ========== 其他样式设定(如颜色、行距等) ==========
#set par(
  leading: 0.8em, // 行距
  spacing: 0.7em, // 段间距
)

// 强行压缩独立公式块的上下外边距，默认值较大，改为 0.4em 甚至更低
#show math.equation.where(block: true): set block(above: 0.3em, below: 0.3em)

// 单独设置公式打字，设置为正文的 90%
#show math.equation.where(block: false): set text(size: 0.9em)

// 让行内公式里的文字挨得更紧凑
#show math.equation.where(block: false): set text(tracking: -0.5pt)




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
#draw-stamp-box([*瑞利与莱斯PDF/CDF图像特征*])

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
      a
    ],
  ),
)

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
      a
    ],
  ),
)

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

// 放置顶部小内容(绝对定位)
#place(
  dx: 0mm,
  dy: 0mm,
  clearance: 0em,
  rect(
    width: content-width,
    height: stamp-top - safe-top - 1mm, // 留出一点空隙
    fill: none,
    stroke: (dash: "dashed", paint: blue, thickness: 0.4pt),
    inset: 0pt,
    outset: 0pt,

    [   // 这里写顶部速记内容,如关键公式
      // ；*基带*理想低通传输 $B = R_s/2$,对于NRZ则$B = R_s$,对于升余弦则$B = (1 + alpha) R_s/2$,但是一般涉及到SNR都是频带,即基带的两倍
    ],
  ),
)

// #place(
//   dx: stamp-left - 10mm,
//   dy: stamp-top - safe-top,
// )[
//   #rotate(90deg, origin: top + left)[
//     #image("figures/抗窄带干扰.pdf", width: 33%)
//   ]
// ]

// 跳过预印区,主正文从说明文字下方开始
// !注意:这里的高度是从 safe-top 开始计算的,因为 page 的 margin 已经设置了 safe-top 了
#block(height: stamp-bottom - safe-top)
// 这里可以放置正文内容

// 定义颜色常量（方便后续统一修改）
#let my-red = rgb("#d9383a")
#let my-blue = rgb("#2b6cb0")
#let my-green = rgb("#38a169")

// 定义快速调用的函数
#let alert(content) = text(fill: my-red, [#content])
#let info(content) = text(fill: my-blue, content)
#let success(content) = text(fill: my-green, content)

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


// ==================== 打印级颜色核心配置 ====================
// 级别 1：【核心必考 / 超级公式】 - 高警示度朱红色（红偏橘，考场上第一眼看到）
#let clr-red = rgb("d32f2f")

// 级别 2：【高频考点 / 核心概念】 - 深邃湖蓝色（理智、清晰，适合大段核心知识点）
#let clr-blue = rgb("0288d1")

// 级别 3：【次要考点 / 补充定义】 - 稳重橄榄绿（不刺眼，用于区分常规概念）
#let clr-green = rgb("388e3c")

// 级别 4：【普通标记 / 题型分类】 - 暗夜紫罗兰（低调但有高对比度，适合分类标签）
#let clr-purple = rgb("7b1fa2")
// =========================================================



#columns(
  3,
  gutter: 1mm,
)[
  #kp-mix-box(clr-green, [移动通信]) *广义*:通信双方或至少其中一方在运动状态中(或临时静止状态)进行信息交互的通信方式;采用电磁波为传输媒介的无线通信*狭义*:蜂窝移动通信系统

  #kp-mix-box(clr-green, [1-4代系统]) *1代(模拟/窄带)* #success([主要多址技术:])FDMA  #success([质量:])较差 #success([业务:])语音通信  #success([代表:])AMPS(美国)TACS(欧洲)*2代(数字/窄带)*  FDMA/TDMA/CDMA;较好;语音为主,数字为辅;GSM(欧洲)IS-95(Qualcomm)*3代(数字/宽带)*(多模式多频) CDMA;好;数字语音多媒体;WCDMA(欧/日)cdma2000(北美)TD-SCDMA(中国)*4代(数字/宽带)*OFDMA/SC-FDMA;好;数字语音多媒体;LTE-A   #kp-mix-box(clr-purple, [WiMAX和LTE类似技术]):正交频分多址OFDMA,子信道自适应调制和编码(AMC),混合自动重传请求(H-ARQ),多输入多输出(MIMO),纯 IP 核心网

  // ? #kp-mix-box(clr-purple,[移动通信的特点]):频谱拥挤、频谱需严格菅理;电波传播存在衰落、多径等问题;面临环境的干扰和噪声;存在高速移动和大动态范围的要求;对移动台体积、重量、功耗的要求高;系统复杂,系统需组网,网络需有越区切换、漫游等功能

  #kp-mix-box(clr-blue, [工作方式]) *单工*:收发交替进行.同频/异频单工;*半双工*:基站双工,移动台异频单工;*双工*:同时工作 #success([*FDD*]) (频分双工,不同频率收发,有保护频带):需成对频率,频带宽,适合对称业务(不对称时频谱利用率低);技术简单;收发有保护频带间隔,抗干扰能力强;覆盖范围大,设备成本高.#success([*TDD*]) (时分双工,不同时隙收发,有保护时间):不需成对频率,频带窄,支持不对称业务,便于频谱分配,频谱利用率高;需更复杂的网络规划和优化;通过保护时间隔离,易形成同频干扰;收发同一频段,上下行信道特性一致,便于采用智能天线技术;覆盖范围小,需要更大的发送功率;设备成本降低.

  #kp-mix-box(clr-green, [应用系统]) (陆地公众蜂窝发展最快,规模最大):*陆地公众蜂窝*(公网,覆盖广/容量大/核心主流);*宽带无线接入*(高带宽/局域高速数据传输,如WiMAX);*无线局域网*(短距离/高card速率,如WiFi);*集群通信*(专网专用/多向调度/一呼百应,多用于应急指挥);*无绳电话*(固定电话的无线延伸,基站范围极小);*卫星移动通信*(利用卫星作中继,实现全球大面积乃至远洋荒漠覆盖)。

  // ?【*无线电波传播方式*】*地波*(沿地球表面传播,低频/长波,传播距离远、较稳定);*天波*(靠电离层反射传播,高频/短波,用于远距离短波通信);*视距/对流层*(在对流层内沿直线或散射传播,超短波/微波,距离受视线限制);*卫星*(穿透电离层,利用卫星中继传输,微波,距离远、覆盖大)

  #kp-mix-box(clr-green, [电波传播机制]) *直射*(信号最强,无障碍物或天线足够高);*反射*(物体尺寸远大于波长,是多径衰落的主要原因);*绕射*(阻挡体边缘尖锐,基于惠更斯-菲涅尔原理,频率越低绕射能力越强);*散射*(粗糙表面/小物体或不规则物体,使电波向多方向辐射)

  #kp-mix-box(clr-red, [大尺度路径损耗])#alert([*自由空间传播损耗*]):$P_r = P_t G_t G_r (lambda / (4 pi d))^2,L=P_t/P_r$, $L("dB") = 32.45 + 20 lg f("MHz") + 20 lg d("km") - 10 lg G_T - 10 lg G_R$ ($c=lambda f$#success([理想状态]));#alert([*对数路径损耗模型*]):近场有奇点故引入远场参考距离$d_0$,路径损耗指数$n$室外典型值4(室内可$<2$),$P_r (d) = P_r (d_0) (d_0 / d)^n$,$L(d) = L(d_0) + 10n log_10 (d / d_0)$(#info([$d>d_0>2D^2/lambda$])D:天线的最大尺寸);#alert([*阴影衰落*]):大障碍物遮挡引起,引入正态随机变量 $zeta \~ N(0,sigma^2)"dB"$($sigma$典型值8),最终损耗公式 $L(d) = L(d_0) + 10n lg (d / d_0) + zeta_sigma$.

  #kp-mix-box(clr-red, [小尺度衰落])*多径效应*:时延扩展与时间色散;*多普勒效应*:$f_d = v/lambda cos theta$, $theta$为#alert([速度与电波夹角(补角)]),多普勒扩展与频率色散

  #kp-mix-box(clr-green, [多径信道模型]) $r,s$对应复包络:$r(t)=s(t)*h(t,tau)$;大尺度+小尺度:$h(t, tau) = sum_(i=0)^(N(t)) alpha_i (t) e^(-j phi_i (t)) delta(tau - tau_i (t))$

  #kp-mix-box(clr-blue, [瑞利衰落]) 离基站远且反射物丰富,#info([无直射波,各反射波幅度和相位独立]).*本质*:经N条独立的衰落路径到达接收端.接收#info([信号包络])$r(t) = sum_(i=0)^N alpha_i exp(-j phi_i)s(t-tau_i)$*1.直角坐标*:定义同相分量 $T_C (t) = Re(r(t))$,正交分量 $T_S (t) = Im(r(t))$.由中心极限定理,当$N arrow.r infinity$时$T_C,T_S \~ N(0,sigma^2)$,$sigma_C^2 = sigma_S^2 = sigma^2$.其联合概率密度 $p(T_C, T_S) = p(T_C) dot p(T_S) = 1/(2 pi sigma^2) exp(-(T_C^2+T_S^2)/(2 sigma^2))$.*2.坐标变换*:转为极坐标(包络 $r$,相位 $theta$), $T_C = r cos theta, T_S = r sin theta$.雅可比行列式 $|J| = |partial(T_C, T_S)/partial(r, theta)| = r$.新坐标系联合PDF $p_(r,theta)(r,theta) = p(T_C,T_S) dot |J| = r/(2 pi sigma^2) exp(-r^2/(2 sigma^2))$.*3.边缘PDF*:*包络r*:$p_r (r) = integral_0^(2 pi) p_(r,theta) d theta = r/sigma^2 exp(-r^2/(2 sigma^2))$(*瑞利分布*, $r >= 0$);*相位* $theta$:在 $(0,infinity)$ 对 $r$ 积分, $p_theta (theta) = 1/(2 pi)$ (*均匀分布*, $theta in (0,2 pi)$).

  #kp-mix-box(clr-blue, [莱斯衰落]) 多径信道中#info([某路信号较强且占支配地位]).*莱斯因子*:主信号功率与多径分量方差之比,即 $K = A^2/(2 sigma^2)$.$A arrow.r 0$且$K arrow.r 0$时,无直射分量,莱斯分布退化为*瑞利分布*(衰落最严重);$A^2/(2 sigma^2) arrow.r infinity$且$K arrow.r infinity$时,直射波极强,莱斯分布向*高斯分布*趋近(衰落最轻).
  // ? *PDF公式*:当 $r >= 0$ 时, $p(r) = r/sigma^2 exp(-(r^2+A^2)/(2 sigma^2)) I_0((A^2)/sigma^2)$,$r < 0$时$p(r) = 0$.($A$为主信号峰值,其功率$A^2/2$; $r$为包络;$sigma^2$为$r$的方差;$I_0(dot)$为0阶第一类修正贝塞尔函数).

  #kp-mix-box(clr-blue, [时延扩展]) 各多径分量附加时延为$tau_i$,对应接收功率为 $P(tau_i)$.*平均附加时延*:$overline(tau) = (sum_i a_i^2 tau_i)/(sum_i a_i^2) = (sum_i P(tau_i) tau_i) / (sum_i P(tau_i))$;*均方根时延扩展*: $sigma_tau = sqrt(overline(tau^2) - (overline(tau))^2)$,其中$overline(tau^2) = (sum_i P(tau_i) tau_i^2) / (sum_i P(tau_i))$ ($overline(tau^2)$是先平方再加权平均);注意是#info([数值运算])

  #kp-mix-box(clr-red, [时间色散]) #info([多径传播导致时延扩展])#alert([*相干带宽*]):$B_C$定义为#info([信道衰落特性保持高度相关的最大频率范围]).*工程近似*:$B_C approx 1 / (5 sigma_tau) prop 1 / sigma_tau$.*信号参数*:#info([信号带宽])$B_S$#info([符号周期])$T_S$.#alert([*判定*]):$B_S << B_C$($T_S >> sigma_tau$)#success([平坦/非频率选择性衰落]) ;$B_S > B_C$($T_S < sigma_tau$)#success([频率选择性衰落]),引发ISI.

  #kp-mix-box(clr-red, [频率色散]) #info([移动导致多普勒频移])多普勒扩展导致信道冲激响应随时间快速波动.#alert([*相干时间*]): $T_C$定义为#info([信道特性近似固定不变的时间窗]).*工程近似*:$T_C approx 0.423 / f_m prop 1 / f_m$.#alert([*判定*]):$T_S << T_C$($B_S >> f_m$)#success([慢/非时间选择性衰落)]),信道增益恒定;$T_S > T_C$($B_S < f_m$)#success([快/时间选择性衰落)]),引发#info([严重相位畸变与多普勒展宽])

  #kp-mix-box(clr-green, [角度色散]) #info([散射体分布导致多角度信号到达接收端,引发空间干涉图样变化(角度扩展)]).*相关距离*$D_C$定义为信道特性高度相关的空间范围.*天线间距* $Delta x$.*判定*:$Delta x << D_C$*空间非选择性衰落*

  #kp-mix-box(clr-purple, [语音编码]) *波形*:质量好但高带宽;*参量*:省带宽但质量差;*混合*兼顾低速率与高音质
  // ? *波形*:不改变波形,直接对模拟信号抽样量化编码,质量好但高带宽,典型如 PCM、ADPCM;*参量*:提取发音器官物理参数进行传输和重建,极省带宽但音质有合成感,合成语意度差,典型如LPC);*混合*(波形与参量结合,用参数编码提取特征,用波形编码提取残差;兼顾低速率与高音质,典型如 CELP,VSELP).

  #kp-mix-box(clr-blue, [信噪比换算]) $S$信号平均功率;$N$总噪声功率(噪声平均功率);$N_0$单边噪声功率谱密度;$B$接收机(噪声)带宽;$M$调制阶数.#success([*功率与能量*]): $S = E_b R_b = E_s R_s$, $N = N_0 B$;#success([*SNR换算*]): $S/N = (E_b/N_0) (R_b/B)$, $S/N = (E_s/N_0) (R_s/B)$, $E_s/N_0 = (E_b/N_0) log_2 M$.若信道编码码率$R_c != 1$,则$E_s = E_b R_c log_2 M$;

  #kp-mix-box(clr-blue, [频带利用率]) $R_b = R_s log_2 M$.$B_(T) = 2 B$;$B = R_s (1 + alpha) / 2$,对于NRZ$B = R_s$,对于RZ$B=2R_s$;$eta_s = R_s / B_(T) = 1 / (1 + alpha)"Baud/Hz"=R_b / B_(T) = (log_2 M) / (1 + alpha)"bps/Hz"=eta_b$

  #kp-mix-box(clr-green, [香农公式])  $C_t = B log_2 (1 + P_s / (N_0 B)) = B log_2 (1 + "SNR")$(bps,要求#success([AWGN])).$C_oo = P_s / (N_0 ln 2) approx 1.44 dot P_s / N_0$;$C_oo = 1$时,$P_s / N_0 = ln 2 approx -1.6 "dB"$(香农限)

  // ? #kp-mix-box(clr-purple, [恒包络连续相位]) *CPFSK*:时段 $k T_b <= t < (k+1)T_b$ 内信号 $s(t) = cos(omega_c t + a_k (h pi)/T_b t + phi_k)$,单个周期 $T_b$ 内:发 $a_k = 1$ 相位斜向上增 $+h pi$,发 $a_k = -1$ 相位斜向下减 $-h pi$.*MSK(最小频移键控)*:满足正交的最小调制指数 $h = 0.5$ 的 CPFSK 特例.*GMSK*:在 MSK 前加高斯低通滤波器,物理本质是将 MSK 折线相位轨迹的尖角磨圆滑,减小带外辐射 (高频旁瓣衰减极快,提高频谱利用率)

  #kp-mix-box(clr-green, [MSPK]) *BPSK*:$s(t) = plus.minus A cos omega_c t$.$P_b = Q(sqrt((2E_b)/N_0))$.*QPSK*:正交双路合成,$s(t) = A_c cos(omega_c t) - A_s sin(omega_c t)$,其中 $A_c, A_s = plus.minus A / sqrt(2)$.*解调机理*:相干载波分两路正交相乘,加低通滤波,完全解耦为两个独立的 BPSK 进行二维独立判决. $P_b = Q(sqrt((2E_b)/N_0))$

  #kp-mix-box(clr-red, [相位映射]) $(I,Q)-> phi_k$:$(+1,+1) arrow.r pi/4$; $(-1,+1) arrow.r (3pi)/4$; $(-1,-1) arrow.r -(3pi)/4$; $(+1,-1) arrow.r -(pi)/4$.*QPSK*:I/Q两路同时翻转,#success([最大相位跳变$pi$.轨迹直接穿过原点]),包络起伏100%,产生严重非线性失真.*OQPSK*:Q路延迟一个比特错开翻转,#success([最大相位跳变$pi/2$.轨迹不穿过原点])*$pi/4$DQPSK*:绝对相位$theta_k = theta_(k-1) + phi_k$,#success([最大相位跳变 $(3pi)/4$.轨迹不穿过原点]),#info([频谱性能])劣于OQPSK,但优于QPSK
  #image("figures/相位转移图.pdf")

  #kp-mix-box(clr-blue, [OFDM]) #info([*正交子载波*]):总带宽$B = 1/T_s$,串并转换后符号周期扩大$N$倍$T = N T_s$使得单个子信道带宽小于信道相干带宽(平坦衰落).$B = f_(N-1) - f_0 + 2 delta approx N Delta f$,$eta = (N R_s log_2 M) / (( N - 1 ) Delta f + 2 delta) approx log_2 M$ *论述*:#success([OFDM是一种无线环境下的高速传输技术,将高速的数据流分解为多路并行的低速数据流,在多个载波上同时进行传输]) *流程*:输入$->$S/P转换$->$IFFT$->$P/S转换$->$加CP$->$D/A$->$RF,接收端逆过程即可

  #kp-mix-box(clr-green, [CP]) 消除ISI/ICI,符号前插保护间隔,ZP破坏正交性导致ICI

  // ? #kp-mix-box(clr-purple, [信道估计]) 块状导频频率上连续,梳状导频时间上连续.峰均比 PAPR,定义公式为 $"PAPR" = max(|s(t)|^2) / E(|s(t)|^2)$,当子载波数 $N$ 很大时时域信号近似服从高斯分布.抑制 PAPR 核心方法对比:限幅限制峰值附近信号幅度,实现简单但破坏正交性,且带外干扰;编码增加冗余,选择小PAPR码字,无失真但谱效降低且复杂度高；加扰用扰码降低信号同相叠加概率,无失真但需要额外信息且复杂度高;预失真进入放大器之前预先补偿失真,让放大之后无失真,本质没有抑制PAPR,补偿程度有限.

  #kp-mix-box(clr-blue, [OFDM优缺点]) *优点*:正交子载波频谱重叠交叉使频谱利用率高;串并转换减小符号速率,抗多径干扰与抗窄带衰落能力强;FFT/IFFT实现降低复杂度;CP克服多径带来的ISI;能获取等效频率单径信道,更适于MIMO传输;降低对时间同步的要求.*缺点*:频偏敏感,频偏容易使得正交性被破坏;高PAPR,多个子信道叠加,对器件要求高

  #kp-mix-box(clr-blue, [分集]) *本质*:对同一信号在不同时间频率空间和极化方向的采样 *概念*:利用加性独立(至少不相关)的衰落路径传送相同的信号并合并,从而提高接收信号的信噪比 *原理*:信号经过复制和映射,在多个独立路径传播,各个独立信号同时经历深衰落概率低 *作用*:接收端充分利用信号能量,提高接收信噪比 (SNR),减小平坦性衰落的深度和持续时间

  #kp-mix-box(clr-green, [微观分集]) *时间*:信息在不同时刻重复传输$Delta T>>T_C$ *频率*:信息以不同频率传输 $Delta f >> B_C$ *空间*: 不相关的两个以上天线(波束方向)或同一天线不同极化方向(水平/垂直)传输同一信号$Delta x >> D_C$

  #kp-mix-box(clr-blue, [最大比合并]) #success([*系统模型*]):设M路合并信号包络为$r_("mr") = sum_(k=1)^(M) a_k r_k$;正弦信号瞬时功率$P_s = r_("mr")^2/2$;合并输出噪声总功率$N_("mr") = sum_(k=1)^(M) a_k^2 N_k$;得到#info([合并器输出信噪比]):$xi_(m r) = P_s / N_(m r) = (sum_(k=1)^M a_k r_k)^2 / (2 sum_(k=1)^M a_k^2 N_k) = [sum_(k=1)^M (a_k sqrt(N_k)) times (r_k \/ sqrt(N_k))]^2 / (2 sum_(k=1)^M a_k^2 N_k)$ #success([*许瓦兹不等式寻优*]):可令$x_k = a_k sqrt(N_k),y_k = r_k/sqrt(N_k)$,由$(sum x_k y_k)^2 <= (sum x_k^2)(sum y_k^2)$可得:$xi_(m r) <= ( ( sum_(k=1)^M a_k^2 N_k ) dot ( sum_(k=1)^M r_k^2 \/ N_k ) ) / (2 sum_(k=1)^M a_k^2 N_k) = sum_(k=1)^M r_k^2 / (2 N_k) = sum_(k=1)^M xi_k$,#info([取等条件])$x_k / y_k = (a_k sqrt(N_k)) / (r_k \/ sqrt(N_k)) = C => a_k = C r_k / N_k prop r_k / N_k$(加权系数与信噪比成正比)

  #kp-mix-box(clr-blue, [合并增益]) 各支路独立且信号与噪声无关,有相同的*平均信噪比*$xi_k=overline(xi)$ #info([*最大比合并*]):调整同相后按SNR加权合并$alpha_k = C r_k / N_k prop r_k / N_k$,合并后$xi_("MRC") = sum_(k=1)^M xi_k=M overline(xi)$,$D_("MRC") = overline(xi_("mr"))/overline(xi)=M$ #info([*等增益合并*]):所有分支权重相等,$xi_("EGC") = [1+(M-1) pi/4]overline(xi)$ #info([*选择合并*]):选择SNR最大的分支(任意时频等)$xi_("SC")=overline(xi) sum_(k=1)^M 1/k$.$F(x) = P_("out") = P(xi <= x),overline(P_b) = integral_0^infinity P_b (xi)p_M (xi)d xi$

  #kp-mix-box(clr-blue, [交织]) *概念*:一条消息中的比特以非连续方式传送,使突发差错信道变为离散信道(将突发错误随机化),便于利用纠错码消除随机错 *行列交织器*:m行n列,#alert([按行写入,按列读出]),#info([交织深度(交织前相邻两符号在交织后的距离)M,交织宽度N,交织延迟M$dot$N]) *要求*: #alert([交织深度$>>$相干时间]),交织深度对应实际时间$M times T_S ("符号周期")$;交织宽度$>$分组长度/译码深度

  #kp-mix-box(clr-green, [行列交织器优缺点]) *优点*:抗突发误码能力强,结构简单易实现;*缺点*:交织时延大,存储开销大(可引入卷积交织器)

  #kp-mix-box(clr-blue, [信道编码]) *定义*:信息码元中增加冗余码元,在接收端检测或纠正有噪信道中引入的误码 *码率*:$R = k/n$ *码距*:码字中不同码元数目

  #kp-mix-box(clr-purple, [分组码]) $(n,k)$ 循环码(CRC)$x^(n-k)m(x)$($g(x)$最高$n-k$),汉明码

  #kp-mix-box(clr-red, [卷积码]) $(n,k,m)$ $m$寄存器个数,状态数$2^m$ *约束长度*$l=m+1$ *多项式编码*:$g^((1))(D)=1+D+D^2,g^((2))(D)=1+D^2$ *Vterbi译码*:一种最大似然序列译码,运算量和存贮量都与状态数呈线性关系

  #kp-mix-box(clr-blue, [横向滤波线性均衡器]) $y_n = sum_(k=-N)^N c_k x_(n-k) <=> Y(z) = X(z)E(z)$,$X(z) = sum_(k=-N)^N x_k z^(-k)$,$E(z) = sum_(k=-N)^N c_k z^(-k)$,输出$y_n$,输入$x_n$,均衡$c_n$

  #kp-mix-box(clr-red, [迫零算法]) #info([*最小峰值误差准则*])$D = 1 / y_0 sum_(mat(k = -infinity; k != 0))^infinity |y_k|$,使码间干扰峰值最小 *算法*:$x$代入初始畸变$D_0<1$时,迫零可得到$N$阶($2N+1$抽头)下最优解.$y_n = cases(1 &", " n = 0, 0 &", " n = plus.minus 1\, ...\, plus.minus N)$$quad bold(y) = bold(x) bold(c) => bold(c) = bold(x)^(-1) bold(y)$.N大于多径M
  $bold(y) = mat(y_(-N); y_(-N+1); dots.v; y_0; dots.v; y_(N-1); y_N) quad bold(x) = mat(x_0, x_(-1), dots.h, x_(-2N); x_1, x_0, dots.h, x_(-2N+1); dots.v, dots.v, , dots.v; x_N, x_(N-1), dots.h, x_(-N); dots.v, dots.v, , dots.v; x_(2N-1), x_(2N-2), dots.h, x_(-1); x_(2N), x_(2N-1), dots.h, x_0) quad bold(c) = mat(c_(-N); c_(-N+1); dots.v; c_0; dots.v; c_(N-1); c_N)$

  #kp-mix-box(clr-green, [其它均衡]) #info([*最小均方误差准则*]):均方误差:$epsilon.alt^2 = 1/y_0^2 sum_(mat(k = -infinity; k != 0))^(infinity)y_k^2$使码间干扰均方误差最小,自适应均方误差定义$overline(epsilon.alt^2)=E[e_k^2]=E[a_k-y_k]$ *自适应均衡*:训练/跟踪模式，单向/选择式单向均衡

  #kp-mix-box(clr-blue, [扩频]) *定义*:扩频宽度远大于所传信息必需的最小带宽;频带的扩展由扩频码序列完成,与信息数据无关;收端用相同扩频码解扩并恢复数据 *优点*:降低信号功率谱密度(抗截获)干扰抑制(抗干扰) *本质*:频率/时间分集 *扩频增益*:$G_p=("解扩器输出SNR")/("解扩器输入SNR")=(B_(S S)"扩展带宽")/(B_D"信息带宽")$

  #kp-mix-box(clr-blue, [m序列]) 特征多项式-最长线性反馈移位寄存器-周期$N=2^m-1$(除去全0) #info([*平衡特性*]):完整N内1比0多一个 #info([*游程特性*]):N内连续0/1序列称为一个游程;N内游程总数$L = (N+1)/2$;长度为$l$的游程数$ceil(L/2^l)$;最长游程是m个连1 #info([*相关特性*]):两序列a,b#info([模2相加]),0数目为A,1数目为D $R_(a,b)=(A-D)/(A+D)$;#info([自相关函数])$R_(a, a)(n) = cases(1 &", " n = l N \, l = 0\, plus.minus 1\, ..., -1/N &", 其余 " n)$ #alert([*计算*]):原$b(t)$扩展N后#success([异或])$G=N$

  #kp-mix-box(clr-red, [DS]) *参数*:扩展倍数$N= B_c/B_b = T_b/T_c$实际扩展为$B_c + B_b$ *2PSK下*:$G_p= P_i/P_o = N$ #success([*抗窄带干扰*]):发端扩频,信号频谱展宽,功率谱密度降低;受到干扰;信号解扩恢复为窄带,功率谱密度上升,同时干扰频谱被扩展,其功率谱密度下降;经窄带滤波,信道内干扰功率大幅下降#image("figures/抗窄带干扰.pdf") #success([*抗衰落*]):#alert([抗频率选择性失真]) (抗衰落):扩频码的#info([码片时间小于多径时延差(频谱扩展宽度远大于信道相关带宽)])时,可利用扩频码的自相关特性进行相关解扩,提取所需要的主径信号,抑制多径干扰(频率分集增益) #alert([抗SNR损耗]) (抗多径):利用RAKE接收,可以区分#success([多径时延差大于码片周期(多径可分离)])的各条多径信号并合并,即时间/多径分集,具有分集合并增益 #success([*RAKE接收*]):用扩频码的相关特性进行多径分离与合并,实现时间分集;*要求*:#alert([两径时延差大于Chip周期]);*绘图*:#info([多径矢量合成])三角$->$单向,#info([接收机示意图]): #image("figures/RAKE.pdf")

  #kp-mix-box(clr-red, [FH]) *概念*:载波信号的频率随时间变化,#info([靠躲避干扰来提升抗干扰性能]),本质是频率分集 *参数*:$G_H = W/B = N$即跳频点数 #success([*抗衰落*]):#alert([抗频率选择性失真]) (抗多径):在#info([多径信号没有到来之前(跳频周期小于多径时延差)])接收机已开始接收下一跳信号,但需以提高跳频速率为代价(快跳频) #alert([抗SNR损耗]) (抗衰落):#info([跳频总带宽大于信道相干带宽(也可理解为跳频频率间隔大于信道相干带宽)])时,若将相关的跳频频点作为一个跳频子集,不同跳频子集的信号相互独立,可获得频率分集,具有分集合并增益 #success([*抗同信道干扰*(补充)])正交跳频图案避免频率复用引起的同频干扰

  #kp-mix-box(clr-green, [MIMO]) *建模*:AWGN下$bold(y) = bold(H)bold(x) + bold(n)$;*技术分类*:#info([空间分集]),#info([空间复用]) (接收/发射分集),#info([预编码/波束赋形]) (特定方向波束),#info([毫米波]) (窄定向波束)

  #kp-mix-box(clr-red, [空间分集]) #success([对抗衰落]);#alert([*STBC空时分组码*]):$mat(c_1, c_2) => mat(c_1, -c_2^*; c_2, c_1^*)$ *等效公式*:$bold(r)=bold(H)bold(c)+bold(n)=mat(r_1; r^*)=mat(h_1, h_2; h_2^*, -h_1^*)mat(c_1; c_2)+mat(n_1; n_2^*)$ *检测*:$tilde(bold(r))=bold(H)^H bold(r)=(|h_1^2|+|h_2^2|)bold(c)+tilde(bold(n))$,再接#success([ML检测]) #info([*多接收*]):线性合并$tilde(bold(r))=sum_(j=1)^(M_r)bold(H)_j^H r_j=(sum_(j=1)^(M_r) ||bold(h)_j||^2)bold(c) + tilde(bold(n))$;*性能*:#info([分集度]) (BER曲线斜率)MRC与STBC相同;#info([分集增益])MRC性能好3dB(STBC中两TX总功率和MRC单Tx功率相同),但因为#success([非对称性])STBC应用广(MRC永远1Tx多Rx)

  #kp-mix-box(clr-red, [空间复用]) #success([提高频谱效率]);#alert([*V-BLAST垂直贝尔实验室分层空时码*]):$(c_1, c_2) => mat(c_1;c_2)$,$bold(r)=bold(H)bold(c)+bold(n)$ *ML*:$tilde(bold(r))=arg min_(hat(bold(c))in bold(C))|bold(r)-bold(H)hat(bold(c))|^2$,需要先验等概+AWGN,最优最复杂

  #kp-mix-box(clr-green, [MIMO-OFDM]) MIMO在不增加带宽的条件下成倍提高系统容量和频谱利用率;OFDM把频率选择性衰落信道变成多个子载波的平坦衰落信道,使MIMO在宽带无线通信中发挥其优势

  #kp-mix-box(clr-purple, [链路自适应技术]) 系统依据信道的变化动态地调整系统参数,达到性能的最优 AMC(自适应编码调制),ARQ/FEC/HARQ

  #kp-mix-box(clr-green, [区域覆盖]) *小容量大区制*:建网方式简单,设备成本低,无切换问题,但容量小,功耗与限制大且频谱效率极低;*大容量小区制*:容量大(频率复用)功耗低且设备小,但网络复杂且存在切换问题

  #kp-mix-box(clr-blue, [小容量大区制]) *簇/区群*:共同使用全部可用频率的N个小区叫做一个簇;*簇基本条件*:基本图案(簇)能彼此邻接且无空隙地覆盖整个面积,#success([相邻簇中，同频小区间距离相等，且为最大]) ;*频率复用*:簇内每个小区使用不同的频率组,相邻簇使用相同的频率组;*复用和覆盖方式*:带状 面状;*基站对小区覆盖*:中心激励 顶点激励($120degree$)

  #kp-mix-box(clr-red, [簇]) $N=i^2 + i j + j^2$,3/4/7/9/12 *信道总数和容量*:$S=K N,C=M S$ M为复制次数;*同频小区确定*:#success([沿着任意一条六边形边的垂线方向移动i个小区,然后逆时针旋转$60 degree$再移动j个小区]);*同频复用距离*:$D=sqrt(3 N)R$;

  #kp-mix-box(clr-red, [同频干扰]) #success([*论述*]):同频干扰是制约系统容量的主要因素,同频干扰与频谱利用率是一对矛盾体:在小区半径不变R的情况下,同频复用距离D越小,同频干扰越大,但每个区群的小区数N越小,在单位面积内可复制的区群数越多,所以频谱利用率越高,系统容量越大；同频复用距离D越大,同频干扰越小,每个区群的小区数N越大,在单位面积内可复制的区群数越少,则频谱利用率降低,系统容量越小.#alert([从提高频谱利用率的角度,在保持满意的通信质量的前提下,N应取最小值最好]) *载干比*:只考虑第一层干扰$C/I = (sqrt(3 N))^n/L$,$n$为路径损耗指数(4),$L$为同频干扰小区数(全向天线6,定向天线2/3);*同频复用比*:$Q= D/R = sqrt(3N)$,越小容量越大,越大干扰越小

  #kp-mix-box(clr-green, [通信容量]) *定义*:每个小区的可用信道数,即每小区允许同时工作的用户数;单位面积内可允许同时工作的用户数; *通用公式*:#success([$m= B_t/(B_c N) ("信道/小区")$]),$B_t$:信道总带宽,$B_c$单个信道等效带宽,$N$频率复用因子,#info([容量取决于载干比和总带宽])

  #kp-mix-box(clr-red, [FDMA]) #info([频率])划分时间共享 上下行频带分割,保护频带 #alert([$m=B_t/(B_c N)$])

  #kp-mix-box(clr-red, [TDMA]) #info([时隙])划分频率共享 #alert([$m=B_t/(B'_c N)$]) 等效信道带宽#alert([$B'_c = B_c/M_("slot")$]) $M_("slot")$为每个载波的时隙数;*同步*:位/时隙/帧同步 *定时*:延迟需要保护时间 用户提前发送

  #kp-mix-box(clr-red, [CDMA]) #info([码型])划分,时间和频率共享 #info([地址码])作*物理信道* #info([码号])作*用户地址* #alert([*干扰受限系统*]):#success([容量主要受限于系统内移动台的相互干扰]),N可为1,#info([基于DS]) #alert([$C/I = (E_b "/" I_0)/(W "/" R_b)$]) $E_b$:信息处比特能量 $I_0$:干扰功率谱密度 $W$:总频带宽度 $R_b$:信息比特速率 #alert([$m = 1 + I/C$])

  #line(length: 100%, stroke: 0.5pt)

  #image("figures/GSM结构.pdf")
  #kp-mix-box(clr-green, [GSM结构]) *MS*:移动台 *BSS*:基站子系统 *NSS*:网络子系统 *OSS*:操作支持子系统 *BTS*:基站收发信台 *BSC*:基站控制器 *MSC*:移动业务交换中心 *VLR*:来访用户位置寄存器 *HLR*:归属用户位置寄存器 *AUC*:鉴权中心 *EIR*:移动设备识别寄存器 *OMC*:操作维护中心 *PSTN*:公用电话网 *ISDN*:综合业务数字网 *PDN*:公用数据网 #success([*功能*]):*MS*移动客户的设备部分;*BSS*:与MS进行通信的系统设备,主要负责完成无线发送接收和无线资源管理等功能;*NSS*:完成GSM系统的交换功能和用于用户数据与移动性管理所需的数据库功能;*OSS*:对整个GSM网络进行管理和监控

  #kp-mix-box(clr-green, [信道]) *物理信道*:用来传送信号或数据的物理通路,每个载频上支持的一个时隙(TS)就是一个物理信道;*逻辑信道*:物理信道上所传输的内容.根据物理信道所传输的信息种类的不同可定义不同的逻辑信道:#alert([业务信道(TCH)和控制信道]);根据所需完成的功能,#success([控制信道])又分为:#alert([广播信道BCH,公共控制信道CCCH,专用控制信道DCCH]);*BCH*:频率校正(FC)同步(S)广播控制(BC);*CCCH*:寻呼(P)随机接入(RA)允许接入(AG)*DCCH*:独立专用(SDC)慢速辅助(SAC)快速辅助(FAC)*TCH*:全/半/增强型全速率

  #kp-mix-box(clr-purple, [突发脉冲序列]) *频率矫正*-FCCH;*同步*-SCH;*接入*-RACH;*常规*-除上述三种外其他逻辑信道的序列结构;*空闲*-填空

  #kp-mix-box(clr-purple, [定时提前量]) *帧偏移*:基站角度上行帧相对下行帧时间上固定后推3个时隙;*时间调整*:移动台角度,如果不时间调整,传输时延使MS之间信息发生重叠;需要时间调整量补偿传播时延,使基站固定3个时隙帧偏移

  #kp-mix-box(clr-purple, [GSM抗衰落技术]) 信道编码(卷积),交织(块内/间),天线分集,均衡(维特比),跳频

  #kp-mix-box(clr-blue, [安全性管理]) 接入网络-鉴权;无线路径-加密;移动设备-设备识别;用户识别码-临时用户识别码TMSI;SIM卡-PIN码保护

  #kp-mix-box(clr-blue, [鉴权]) #alert([*三参数组*]):用于鉴权的随机数RAND,符号响应SRES,密钥$K_c$;#success([*过程*]):MS向网络端发出接入请求;MSC/VLR从AUC获得三参数,把RAND发给MS;MS收到RAND,使用SIM卡中鉴权键$K_i$与$A_3$算法算出SRES($A_8$算$K_c$)并发送回网络端;对比

  #kp-mix-box(clr-purple, [接续管理]) 客户状态(开机空闲,忙,关机);MS主呼;MS被呼

  #kp-mix-box(clr-blue, [位置更新]) #success([*概念*]):在MS的实时位置信息已知的情况下更新位置数据库(VLR,HLR)和认证移动台(MS从一个LA到另一个LA#info([强制登记]);MS发现SIM卡中LAI和收到的LAI发生变化就执行登记),位置更新总是由MS启动;*周期性登记*;*越区位置登记*:不同MSC/VLR业务区;同MSC/VLR,不同LA

  #kp-mix-box(clr-blue, [越区切换]) *GSM硬切换*:在切换过程中会发生短时中断(CDMA软);*切换方式*:移动台辅助的切换;*切换触发准则*:具有滞后余量和门限规定的相对信号强度准则;*切换流程*:同BSC控制区不同cell;同MSC业务区不同BSC;不同BSC

  #kp-mix-box(clr-purple, [5G技术]) 大规模天线,新型多址,超密集组网,高频段通信

]

