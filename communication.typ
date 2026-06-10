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
)
// 数学字体微调,设置无衬线字体
#show math.equation: set text(font: (
  "Fira Math",
  "Source Han Sans", // 建议配合黑体,保持整体无衬线风格一致
))

// ========== 其他样式设定(如颜色、行距等) ==========
#set par(
  leading: 0.8em, // 行距
  spacing: 1em, // 段间距
)

// 强行压缩独立公式块的上下外边距，默认值较大，改为 0.4em 甚至更低
#show math.equation.where(block: true): set block(above: 0.3em, below: 0.3em)

// // 如果公式内有分式（如 \frac{\lambda}{2\pi}），控制其行高不把整体撑得太开
// #show math.equation: set text(features: ("tnum",))

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
      // *瑞利与莱斯PDF/CDF图像特征*；*基带*理想低通传输 $B = R_s/2$,对于NRZ则$B = R_s$,对于升余弦则$B = (1 + alpha) R_s/2$,但是一般涉及到SNR都是频带,即基带的两倍
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



#columns(
  3,
  gutter: 1mm,
)[
  【*移动通信*】*广义*:通信双方或至少其中一方在运动状态中(或临时静止状态)进行信息交互的通信方式;采用电磁波为传输媒介的无线通信*狭义*:蜂窝移动通信系统

  【*1-4代系统*】*1代(模拟/窄带)* 主多址:FDMA  质量:较差 业务:语音通信  代表:AMPS(美国)、TACS(欧洲)*2代(数字/窄带)*  主多址:FDMA/TDMA/CDMA  质量:较好 业务:语音为主,数字为辅  代表:GSM(欧洲)、IS-95(Qualcomm)*3代(数字/宽带)*多模式多频  主多址:CDMA  质量:好 业务:数字语音多媒体  代表:WCDMA(欧/日)、cdma2000(北美)、TD-SCDMA(中国)*4代(数字/宽带)*  主多址:OFDMA/SC-FDMA  质量:好 业务:数字、语音、多媒体  代表:LTE-A

  *WiMAX和LTE相同技术*:正交频分多址 OFDMA,子信道自适应调制和编码(AMC),混合自动重传请求 (H-ARQ),多输入多输出(MIMO),纯 IP 核心网

  【*移动通信的特点*】:频谱拥挤、频谱需严格菅理;电波传播存在衰落、多径等问题;面临环境的干扰和噪声;存在高速移动和大动态范围的要求;对移动台体积、重量、功耗的要求高;系统复杂,系统需组网,网络需有越区切换、漫游等功能

  【*工作方式*】*单工*:通信双方收发不能同时进行,只能交替进行。同频单工、异频单工;*半双工*:基站为双工,移动台为异频单工;*双工*:通信双方收发能同时工作的方式-*FDD(频分双工,不同频率收发,有保护频带)*:需成对频率,频带宽。适合对称业务(不对称时频谱利用率低);技术简单。收发有保护频带间隔,抗干扰能力强;覆盖范围大,设备成本高。*TDD(时分双工:不同时隙收发,有保护时间)*:不需成对频率,频带窄。支持不对称业务,便于频谱分配,利用率高;需更复杂的网络规划和优化;通过时间隔离,易形成同频干扰;收发同一频段,上下行信道特性一致,便于采用智能天线技术;覆盖范围小,需要更大的发送功率;设备成本降低。*移动中继*:单工中继,双工中继

  【*移动通信应用系统*】*典型应用系统(陆地公众蜂窝发展最快、规模最大)*:*陆地公众蜂窝*(公网,覆盖广、容量大、核心主流);*宽带无线接入*(高带宽、局域高速数据传输,如WiMAX);*无线局域网*(短距离、高 card 速率,如WiFi);*集群通信*(专网专用、多向调度、一呼百应,多用于应急指挥);*无绳电话*(固定电话的无线延伸,基站范围极小);*卫星移动通信*(利用卫星作中继,实现全球大面积乃至远洋荒漠覆盖)。

  #line(length: 100%, stroke: 0.5pt)

  【*无线电波传播方式*】*地波*(沿地球表面传播,低频/长波,传播距离远、较稳定);*天波*(靠电离层反射传播,高频/短波,用于远距离短波通信);*视距/对流层*(在对流层内沿直线或散射传播,超短波/微波,距离受视线限制);*卫星*(穿透电离层,利用卫星中继传输,微波,距离远、覆盖大)

  【*基本电波传播机制*】*直射*(信号最强,无障碍物或天线足够高);*反射*(物体尺寸远大于波长,是多径衰落的主要原因);*绕射*(阻挡体边缘尖锐,基于惠更斯-菲涅尔原理,频率越低绕射能力越强);*散射*(粗糙表面、小物体或不规则物体,使电波向多方向辐射)

  【*大尺度路径损耗*】*自由空间传播损耗(理想状态)*:功率公式 $P_r = P_t G_t G_r (lambda / (4 pi d))^2,L=P_t/P_r$,损耗对数公式 $L("dB") = 32.45 + 20 lg f("MHz") + 20 lg d("km") - 10 lg G_T - 10 lg G_R$;*对数路径损耗模型*:近场 $d=0$ 有奇点故引入远场参考距离 $d_0$,路径损耗指数 $n$ 室外典型值 4(室内可 $<2$),功率公式 $P_r (d) = P_r (d_0) (d_0 / d)^n$,损耗公式 $L(d) = L(d_0) + 10n log_10 (d / d_0)$;*阴影衰落*:大障碍物遮挡引起,引入正态随机变量 $zeta \~ N(0,sigma^2)"dB"$(标准差典型值 8),最终损耗公式 $L(d) = L(d_0) + 10n lg (d / d_0) + zeta_sigma$.

  【*小尺度衰落*】*多径效应*(电波经不同路径到达接收端导致信号矢量叠加衰落,引起时延扩展与时间色散);*多普勒效应*(移动导致频移,公式 $f_d = v/lambda cos theta = f_m cos theta$, $theta$ 为速度与电波夹角,最大多普勒频移 $f_m = v/lambda$,多普勒扩展范围 $f_d in [-f_m, f_m]$,引起多普勒扩展与频率色散).

  【*多径信道模型*】$r,s$对应复包络$r(t)=s(t)*h(t,tau)$ $ h(t, tau) = sum_(i=0)^(N(t)) alpha_i (t) e^(-j phi_i (t)) delta(tau - tau_i (t)) $

  【*瑞利衰落*】*假设*:离基站远且反射物丰富,无直射波,各反射波幅度和相位独立.*本质*经N条独立的衰落路径到达接收端.接收信号包络 $r(t) = sum_(i=0)^N alpha_i exp(-j phi_i)s(t-tau_i)$*1.直角坐标*:定义同相分量 $T_C (t) = Re(r(t))$,正交分量 $T_S (t) = Im(r(t))$.由中心极限定理,当 $N arrow.r infinity$ 时 $T_C,T_S$ 服从高斯分布,且均值为 0,方差 $sigma_C^2 = sigma_S^2 = sigma^2$.其联合概率密度 $p(T_C, T_S) = p(T_C) dot p(T_S) = 1/(2 pi sigma^2) exp(-(T_C^2+T_S^2)/(2 sigma^2))$.*2.坐标变换*:转为极坐标(包络 $r$,相位 $theta$), $T_C = r cos theta, T_S = r sin theta$.雅可比行列式 $|J| = |partial(T_C, T_S)/partial(r, theta)| = r$.新坐标系联合PDF $p_(r,theta)(r,theta) = p(T_C,T_S) dot |J| = r/(2 pi sigma^2) exp(-r^2/(2 sigma^2))$.*3.求边缘PDF*:*包络r*:在 $(0,2 pi)$ 对 $theta$ 积分, $p_r(r) = integral_0^(2 pi) p_(r,theta) d theta = r/sigma^2 exp(-r^2/(2 sigma^2))$ (*瑞利分布*, $r >= 0$);*相位* $theta$:在 $(0,infinity)$ 对 $r$ 积分, $p_theta(theta) = 1/(2 pi)$ (*均匀分布*, $theta in (0,2 pi)$).

  【*莱斯衰落*】*物理前提*:多径信道中存在较强某路信号且占支配地位(有直射波LOS信号).*PDF公式*:当 $r >= 0$ 时, $p(r) = r/sigma^2 exp(-(r^2+A^2)/(2 sigma^2)) I_0((A)/sigma^2)$,当 $r < 0$ 时 $p(r) = 0$.(其中 $A$ 为主信号峰值,其功率为 $A^2/2$; $r$ 为衰落信号包络; $sigma^2$ 为$r$的方差; $I_0(dot)$ 为0阶第一类修正贝塞尔函数).*莱斯因子*:定义为主信号功率与多径分量方差之比,即 $K = A^2/(2 sigma^2)$.当 $A arrow.r 0$ 且 $K arrow.r 0$ 时,无直射分量,莱斯分布退化为*瑞利分布*(衰落最严重);当 $A^2/(2 sigma^2) arrow.r.long infinity$ 且 $K arrow.r.long infinity$ 时,直射波极强,莱斯分布向*高斯分布*趋近(衰落最轻).

  【*时延扩展*】设各多径分量的附加时延为 $tau_i$,对应接收功率为 $P(tau_i)$.*1.平均附加时延*: #text(rgb("#2b6cb0"))[$overline(tau) = (sum_i a_i^2 tau_i)/(sum_i a_i^2) = (sum_i P(tau_i) tau_i) / (sum_i P(tau_i))$] (功率加权的一阶矩);*2.均方根时延扩展*: #text(rgb("#d9383a"))[$sigma_tau = sqrt(overline(tau^2) - (overline(tau))^2)$],其中二阶矩 #text(rgb("#2b6cb0"))[$overline(tau^2) = (sum_i P(tau_i) tau_i^2) / (sum_i P(tau_i))$] (注意 $overline(tau^2)$ 是先平方再加权平均);*3.考场解题避坑*:若题目给出的功率是分贝形式 $P_("dB")$,*必须先转换回线性功率* $P = 10^(P_("dB")/10)$ 再代入上式计算

  【*时间色散 -> 频域波形波动*】多径传播导致时延扩展,测量得平均附加时延 $overline(tau)$ 与均方根时延扩展 $sigma_tau$.信道核心参数为*相干带宽* $B_C$,其定义为信道衰落特性保持高度相关的最大频率范围.严格计算公式 $B_C approx 1 / (2 pi sigma_tau)$,工程近似比例 $B_C prop 1 / sigma_tau$.信号对应参数为*信号带宽* $B_S$.核心判定规则:*1.* 当 #text(rgb("#d9383a"))[$B_S$] $<=$ #text(rgb("#2b6cb0"))[$B_C$] (或符号周期 $T_S >= sigma_tau$)时,信号通过平坦滑梯,各频率衰落一致,产生 #text(rgb("#38a169"))[*平坦衰落(非频率选择性衰落)*],波形不失真;*2.* 当 #text(rgb("#d9383a"))[$B_S$] $>$ #text(rgb("#2b6cb0"))[$B_C$] (或 $T_S < sigma_tau$)时,信号跨越不平坦区,不同频率成分衰落不同导致严重相消,产生 #text(rgb("#d9383a"))[*频率选择性衰落*],其严重后果是引发 #text(rgb("#d9383a"))[*码间干扰(ISI)*] 畸变.

  【*频率色散 -> 时域波形变化*】移动导致多普勒频移,最大多普勒频移 $f_m = v / lambda cos theta$,多普勒扩展导致信道冲激响应随时间快速波动.信道核心参数为*相干时间* $T_C$,其定义为信道特性近似固定不变的时间窗.严格计算公式 $T_C approx 0.423 / f_m$,工程近似比例 $T_C prop 1 / f_m$.信号对应参数为*符号周期(码元宽度)* $T_S$.核心判定规则:*1.* 当 #text(rgb("#d9383a"))[$T_S$] $<=$ #text(rgb("#2b6cb0"))[$T_C$] (或信号带宽 $B_S >= f_m$)时,在单码元传输期间信道来不及变,产生 #text(rgb("#38a169"))[*慢衰落(非时间选择性衰落)*],信道增益恒定;*2.* 当 #text(rgb("#d9383a"))[$T_S$] $>$ #text(rgb("#2b6cb0"))[$T_C$] (或 $B_S < f_m$)时,传输单码元时信道已剧变导致波形首尾不一,产生 #text(rgb("#d9383a"))[*快衰落(时间选择性衰落)*],引发 #text(rgb("#d9383a"))[*严重相位畸变与多普勒展宽*].

  【*角度色散 -> 空域表现异同*】散射体分布导致多角度信号到达接收端,引发空间干涉图样变化.信道核心参数为*相关距离* $D_C$,其定义为信道特性高度相关的空间范围.工程近似比例 $D_C prop 1 / (chevron.l alpha chevron.r)$( $chevron.l alpha chevron.r$ 为角度扩展).系统设计参数为*天线阵列间距* $Delta x$.核心判定规则:*1.* 当 #text(rgb("#d9383a"))[$Delta x$] $<=$ #text(rgb("#2b6cb0"))[$D_C$] 时,两根天线处于同一个空间同质区,接收衰落完全相同,产生*空间非选择性衰落*,天线冗余失效;*2.* 当 #text(rgb("#d9383a"))[$Delta x$] $>$ #text(rgb("#2b6cb0"))[$D_C$] 时,各天线处干涉独立(一根在波峰一根在波谷),产生 #text(rgb("#38a169"))[*空间选择性衰落*]. 这是实现 #text(rgb("#38a169"))[*空间分集与多天线MIMO技术*] 从而对抗多径衰落的物理前提.

  #line(length: 100%, stroke: 0.5pt)

  【*信源编码*】*核心作用*:通过去除信源的多余冗余来#text(rgb("#d9383a"))[提高通信的有效性],降低传输速率.*主要语音编码分类*:*1.波形编码*(不改变波形,直接对模拟信号抽样、量化、编码;速率 #text(rgb("#2b6cb0"))[16\~64kbps],质量好但高带宽,典型如 #text(rgb("#38a169"))[PCM、ADPCM]);*2.参数/声码器编码*(提取发音器官物理参数进行传输和重建;速率低达 #text(rgb("#2b6cb0"))[1.2\~4.8kbps],极省带宽但音质有合成感、合成语意度差,典型如 #text(rgb("#38a169"))[LPC]);*3.混合编码*(波形与参数结合,用参数编码提取特征,用波形编码提取残差;速率 #text(rgb("#2b6cb0"))[4.8\~16kbps],兼顾低速率与高音质,典型如 #text(rgb("#38a169"))[CELP、VSELP]).

  【*信噪比与其派生指标*】*参数定义*: $S$ 为信号平均功率; $N$ 为总噪声功率; $N_0$ 为单边噪声功率谱密度; $E_b$ 为每比特能量; $E_s$ 为每码元能量; $R_b$ 为比特速率(bps); $R_s$ 为符号传输速率(Baud); $B$ 为接收机信道带宽; $M$ 为多元调制进制数(如QPSK的 $M=4$).*核心折算链公式*:*1.功率与能量*: #text(rgb("#2b6cb0"))[$S = E_b dot R_b = E_s dot R_s$], #text(rgb("#2b6cb0"))[$N = N_0 dot B$];*2.三大经典换算*: #text(rgb("#d9383a"))[$S/N = (E_b/N_0) dot (R_b/B)$], #text(rgb("#d9383a"))[$S/N = (E_s/N_0) dot (R_s/B)$], #text(rgb("#d9383a"))[$E_s/N_0 = (E_b/N_0) dot log_2 M$].*隐含条件*:#text(rgb("#d9383a"))[系统未进行信道编码] (码率 $R_c=1$).若有 $R_c$,则 $E_s = E_b dot R_c dot log_2 M$;

  【*频带利用率*】#text(rgb("#d9383a"))[$R_b = R_s dot log_2 M$]. M-PSK、M-QAM 等正交调制,其射频/带通带宽 #text(rgb("#2b6cb0"))[$B_(R F) = 2 dot B_(text("基带"))$]. 基带最小带宽 $B_(text("基带")) = R_s / 2$,则*理想射频带宽* #text(rgb("#2b6cb0"))[$B_(R F) = R_s$]. *实际射频带宽* #text(rgb("#2b6cb0"))[$B_(R F) = R_s (1 + alpha)$].*两种衡量指标*:$eta_s = R_s / B_(R F) = 1 / (1 + alpha)"Baud/Hz"=R_b / B_(R F) = log_2 M / (1 + alpha)"bps/Hz"=eta_b$.*alpha=0时*:BPSK/QPSK/16QAM/64QAM 的 $eta_b$ 分别为 #text(rgb("#d9383a"))[1 / 2 / 4 / 6] bps/Hz; $eta_s$ 则全部恒等于 #text(rgb("#2b6cb0"))[1] Baud/Hz.

  【*香农公式*】单位时间容量 #text(rgb("#d9383a"))[$C_t = B log_2 (1 + P_s / (N_0 B)) = B log_2 (1 + "SNR")$] (单位 bps, $P_s$ 为信号平均功率, $N_0 B$ 为带宽 $B$ 内的总噪声功率).*带宽与容量(割裂极限)*: $P_s$ 固定时,增大 $B$ 可提升 $C_t$,但由于噪声功率随 $B$ 同步膨胀, $C_t$ 存在不可逾越的理论极限 #text(rgb("#d9383a"))[$C_oo = lim_(B arrow.r infinity) C_t = P_s / (N_0 ln 2) approx 1.44 dot P_s / N_0$];*香农限(解题死限)*:当传送 1 比特信息(即 $C_oo = 1$ bps)时,所需的#text(rgb("#d9383a"))[最小信噪比] $P_s / N_0 = ln 2 approx #text(rgb("#d9383a"))[-1.6 dB]$,这是 AWGN 信道无差错传输的绝对物理极限,任何编码都无法突破;

  【*恒包络连续相位*】*CPFSK*:时段 $k T_b <= t < (k+1)T_b$ 内信号 $s(t) = cos(omega_c t + a_k (h pi)/T_b t + phi_k)$,单个周期 $T_b$ 内:发 $a_k = 1$ 相位斜向上增 $+h pi$,发 $a_k = -1$ 相位斜向下减 $-h pi$.*MSK(最小频移键控)*:满足正交的最小调制指数 #text(rgb("#d9383a"))[$h = 0.5$] 的 CPFSK 特例.*GMSK*:在 MSK 前加高斯低通滤波器,物理本质是将 MSK 折线相位轨迹的尖角#text(rgb("#38a169"))[磨圆滑],#text(rgb("#d9383a"))[减小带外辐射] (高频旁瓣衰减极快,提高频谱利用率)

  【*BPSK与QPSK*】*BPSK*:  $s(t) = +-A cos omega_c t$. #text(rgb("#d9383a"))[$P_b = Q(sqrt((2E_b)/N_0))$].*QPSK*:正交双路合成, $s(t) = A_c cos(omega_c t) - A_s sin(omega_c t)$,其中 $A_c, A_s = +-A / sqrt(2)$.*解调机理*:相干载波分两路正交相乘加低通滤波,完全解耦为两个独立的 BPSK 进行二维独立判决. #text(rgb("#d9383a"))[$P_b = Q(sqrt((2E_b)/N_0))$]. *码元错误率* #text(rgb("#2b6cb0"))[$P_s = 1 - (1-P_b)^2 approx 2P_b = 2Q(sqrt((2E_b)/N_0)) = 2Q(sqrt(E_s/N_0))$]

  【*QPSK相位转移*】*QPSK*: *I/Q相位映射*: $(I,Q)$ -> 相位: $(+1,+1) arrow.r pi/4$; $(-1,+1) arrow.r (3pi)/4$; $(-1,-1) arrow.r -(3pi)/4$; $(+1,-1) arrow.r -(pi)/4$.*QPSK*: I/Q 两路同时翻转,最大相位跳变 #text(rgb("#d9383a"))[$pi$]. 轨迹#text(rgb("#d9383a"))[直接穿过原点],包络起伏 100%,产生严重非线性失真.*OQPSK*: Q 路延迟半码元错开翻转,最大相位跳变仅为 #text(rgb("#2b6cb0"))[$pi/2$]. 轨迹#text(rgb("#38a169"))[穿过原点],包络起伏极小.*3. $pi/4$-DQPSK*:绝对相位$theta_k = theta_(k-1) + phi_k$,最大相位跳变 #text(rgb("#2b6cb0"))[$(3pi)/4$]. 轨迹#text(rgb("#38a169"))[不穿过原点]

  【*OFDM机理*】#text(rgb("#2b6cb0"))[正交子载波间隔] $Delta f = 1/T_s$ ,串并转换后符号周期扩大 $N$ 倍变为 $T = N T_s$ 使得单个子信道带宽小于信道相干带宽,从而将#text(rgb("#d9383a"))[频率选择性衰落转化为平坦性衰落]. 实现中采用 IFFT 代替模拟振荡器阵列,发送端第 $m$ 个时域采样点信号,接收端通过 FFT 恢复符号.$B = f_(N-1) - f_0 + 2 delta = ( N - 1 ) Delta f + 2 delta approx N Delta f$,$eta = (N R_s log_2 M) / (( N - 1 ) Delta f + 2 delta) approx log_2 M$

  【*CP机制*】为了消除#text(rgb("#d9383a"))[码间干扰(ISI)]与 ICI,在时域符号前插入保护间隔,若直接填零(ZP)会导致子载波正交性破坏从而引发 ICI.必须采用#text(rgb("#2b6cb0"))[循环前缀(CP)],即复制时域符号尾部的最后 $N_("cp")$ 个采样点垫到头部,其关键边界隐含条件为#text(rgb("#d9383a"))[CP 长度 $tau_("cp")$ 必须大于信道最大多径时延扩展 $tau_(max)$]. 带 CP 的 OFDM 符号总周期变为 $T_("total") = T + tau_("cp")$,由于多径引起的时延混叠只污染 CP 段,使得在 FFT 窗口内时域卷积完全转化为#text(rgb("#38a169"))[频域乘积积分 $Y(n) = H(n)X(n) + W(n)$].

  【*信道估计和PAPR*】#text(rgb("#2b6cb0"))[块状导频]频率上连续,#text(rgb("#2b6cb0"))[梳状导频]时间上连续.#text(rgb("#d9383a"))[峰均比 PAPR],定义公式为 $"PAPR" = max(|s(t)|^2) / E(|s(t)|^2)$,当子载波数 $N$ 很大时时域信号近似服从高斯分布.抑制 PAPR 核心方法对比:#text(rgb("#2b6cb0"))[限幅]限制峰值附近信号幅度,实现简单但破坏正交性,且带外干扰;#text(rgb("#2b6cb0"))[编码]增加冗余,选择小PAPR码字,无失真但谱效降低且复杂度高；#text(rgb("#2b6cb0"))[加扰]用扰码降低信号同相叠加概率,无失真但需要额外信息且复杂度高;#text(rgb("#2b6cb0"))[预失真]进入放大器之前预先补偿失真,让放大之后无失真,本质没有抑制PAPR,补偿程度有限.

  【*OFDM优缺点*】#text(rgb("#38a169"))[核心优点]:正交子载波频谱重叠交叉使频谱利用率极高;串并转换减小符号速率,抗多径干扰与抗窄带衰落能力强;FFT/IFFT实现降低复杂度;CP克服多径带来的ISI;获取等效频率单径信道;降低对时间同步的要求.#text(rgb("#d9383a"))[致命缺点]:频偏敏感,频偏容易使得正交性被破坏;高PAPR,多个子信道叠加,对器件要求高

  #line(length: 100%, stroke: 0.5pt)

  【*分集概念*】*本质*:对同一信号在不同时间频率空间和极化方向的采样 *概念*:利用加性独立(或不相关)的衰落路径传送相同的信号并合并,从而提高接收信号的信噪比 *原理*:信号在多个独立路径传播,各个独立信号同时经历深衰落概率低 *作用*:接收端充分利用信号能量,提高接收信噪比 (SNR),减小平坦性衰落的深度和持续时间

  【*分集种类*】微观 *时间*:信息在不同时刻重复$Delta T>>T_C$ *频率*:信息以不同频率传输 $Delta f >> B_C$ *空间*: *角度*(波束方向,天线不相关)*极化*(水平和垂直极化相关性)$Delta x >> D_C$

  【*分集合并*】各支路独立且信号与噪声无关,有相同的*平均信噪比*$xi_k=overline(xi)$ *最大比*:调整同相后按SNR加权合并$alpha_k = C r_k / N_k prop r_k / N_k$,合并后 $xi_("MRC") = sum_(k=1)^M xi_k=M overline(xi)$,$D_("MRC") = overline(xi_("mr"))/overline(xi)=M$ *等增益*:所有分支权重相等,$xi_("EGC") = [1+(M-1) pi/4]overline(xi)$ *选择*:选择SNR最大的分支(任意时刻和频率等)$xi_("SC")=overline(xi) sum_(k=1)^M 1/k$

  【*交织*】*概念*:一条消息中的比特以非连续方式传送,使突发差错信道变为离散信道(将突发错误随机化),便于利用纠错码消除随机错 *行列交织器*:m行n列,#alert([按行写入,按列读出]),#info([交织深度M,交织宽度N,交织延迟M$dot$N]) *要求*: #alert([交织深度$>>$相干时间]),交织深度对应实际时间$M times T_S ("符号周期")$

  【*行列交织器优缺点*】*优点*:抗突发误码能力强,结构简单易实现;*缺点*:交织时延大,存储开销大(可引入卷积交织器)

  【*信道编码概念*】*定义*:信息码元中增加冗余码元,在接收端检测或纠正有噪信道中引入的误码 *码率*:$R = k/n$ *码距*
  【*线性分组码*】$(n,k)$ 循环码(CRC)$x^(n-k)m(x)$,汉明码

  【*卷积码*】$(n,k,m)$ $m$寄存器个数,状态数$2^m$ *约束长度*$l=m+1$ *多项式编码*:$g^((1))(D)=1+D+D^2,g^((2))(D)=1+D^2$ *Vterbi译码*:一种最大似然序列译码,运算量和存贮量都与状态数呈线性关系

  【*线性均衡器*】$y_n = sum_(k=-N)^N c_k x_(n-k) <=> Y(z) = X(z)E(z)$,$X(z) = sum_(k=-N)^N x_k z^(-k)$,$E(z) = sum_(k=-N)^N c_k z^(-k)$,输出$y_n$,输入$x_n$,均衡$c_n$

  【*迫零算法*】*最小峰值误差准则*$D = 1 / y_0 sum_(mat(k = -infinity; k != 0))^infinity |y_k|$ *算法*:$x$代入初始畸变$D_0<1$时,迫零可得到$N$阶下最优解.$y_n = cases(1 &", " n = 0, 0 &", " n = plus.minus 1\, ...\, plus.minus N)$,$quad y = x c => c = x^(-1) y$.N大于多径M

  $y = mat(y_(-N); y_(-N+1); dots.v; y_0; dots.v; y_(N-1); y_N) quad x = mat(x_0, x_(-1), dots.h, x_(-2N); x_1, x_0, dots.h, x_(-2N+1); dots.v, dots.v, , dots.v; x_N, x_(N-1), dots.h, x_(-N); dots.v, dots.v, , dots.v; x_(2N-1), x_(2N-2), dots.h, x_(-1); x_(2N), x_(2N-1), dots.h, x_0) quad c = mat(c_(-N); c_(-N+1); dots.v; c_0; dots.v; c_(N-1); c_N)$

  【*其它均衡*】*均方误差*:$epsilon.alt^2 = 1/y_0^2 sum_(mat(k = -infinity; k != 0))^(infinity)y_k^2$,自适应均方误差定义$overline(epsilon.alt^2)=E[e_k^2]=E[a_k-y_k]$ *自适应均衡*:训练/跟踪模式，单向/选择式单向均衡

  【*扩频概念*】*定义*:扩频宽度远大于所传信息必需的最小带宽;频带的扩展由扩频码序列完成,与信息数据无关;收端用相同扩频码解扩并恢复数据 *优点*:降低信号功率谱密度(抗截获)干扰抑制(抗干扰) *本质*:频率/时间分集 *扩频增益*:$G_p=("解扩器输出SNR")/("解扩器输入SNR")=(B_(S S)"扩展带宽")/(B_D"信息带宽")$

  【*m序列*】特征多项式-最长线性反馈移位寄存器-周期$N=2^m-1$(除去全0) *平衡特性*:完整N内1比0多一个 *游程*:N内连续0/1序列称为一个游程;N内游程总数$L = (N+1)/2$;长度为$l$的游程数$ceil(L/2^l)$;最长游程是m个连1 *相关*:两序列a,b#info([模2相加]),0数目为A 1数目为D $R_(a,b)=(A-D)/(A+D)$;#info([自相关函数])$R_(a, a)(n) = cases(1 &", " n = l N \, l = 0\, plus.minus 1\, ..., -1/N &", 其余 " n)$ *计算*:原$b(t)$扩展N后#success([异或])

  【*DS*】*参数*:扩展倍数$N= B_c/B_b = T_b/T_c$实际扩展为$B_c + B_b$ *2PSK下*:$G_p= P_i/P_o = N$ *抗窄带干扰*:从发端扩频功率谱开始#image("figures/抗窄带干扰.pdf") *抗衰落*:#alert([抗频率选择性失真])扩频码的码片时间小于多径时延差时,可利用扩频码的自相关特性进行相关解扩,提取所需要的主径信号,抑制多径干扰 #alert([抗SNR损耗(多径)])RAKE接收,可以区分#success([多径时延差大于码片周期(多径可分离)])的各条多径信号并合并,即时间/多径分集,具有分集合并增益 *RAKE接收*:用扩频码的相关特性进行多径分离与合并,实现时间分集; #alert([两径时延差大于Chip周期]);#info([多径矢量合成])二维+单向 #image("figures/RAKE.pdf")

  【*FH*】*概念*:载波信号的频率随时间变化,#info([靠躲避干扰来提升抗干扰性能]),本质是频率分集 *参数*:$G_H = W/B = N$即跳频点数 *抗衰落*:#alert([抗频率选择性失真])在多径信号没有到来之前接收机已开始接收下一跳信号,但需以提高跳频速率为代价(快跳频) #alert([抗SNR损耗])跳频总带宽大于信道相干带宽时,若将相关的跳频频点作为一个跳频子集,不同跳频子集的信号相互独立(#info([跳频频率间隔大于信道相干带宽])),可获得频率分集,具有分集合并增益 #info([抗同信道干扰])正交跳频图案避免复用引起的干扰

  【*空间分集*】对抗衰落;*STBC码字*$mat(c_1, c_2) => mat(c_1, -c_2^*; c_2, c_1^*)$ *等效公式*:$bold(r)=bold(H)bold(c)+bold(n)=mat(r_1; r^*)=mat(h_1, h_2; h_2^*, -h_1^*)mat(c_1; c_2)+mat(n_1; n_2^*)$ *检测*:$tilde(bold(r))=bold(H)^H bold(r)=(|h_1^2|+|h_2^2|)bold(c)+tilde(bold(n))$,再接ML检测 *性能*:#info([分集度])BER曲线斜率,MRC与STBC相同;#info([分集增益])MRC性能好3dB,但因为#success([非对称性])STBC应用广(MRC永远1Tx多Rx)

  【*空间复用*】提高频谱效率;*V-BLAST*:$bold(r)=bold(H)bold(c)+bold(n)$ *ML*:$tilde(bold(r))=arg min_(hat(bold(c))in bold(C))|bold(r)-bold(H)hat(bold(c))|^2$,需要先验等概+AWGN,最优最复杂

  【*MIMO-OFDM*】MIMO在不增加带宽的条件下成倍提高系统容量和频谱利用率;OFDM把频率选择性衰落信道变成多个子载波的平坦衰落信道,使MIMO在宽带无线通信中发挥其优势

  【*链路自适应技术*】系统依据信道的变化动态地调整系统参数,达到性能的最优 AMC,ARQ/FEC/HARQ

  #line(length: 100%, stroke: 0.5pt)

]

