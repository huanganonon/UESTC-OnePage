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
)

// ========== 其他样式设定(如颜色、行距等) ==========
#set par(
  leading: 0.8em, // 行距
)

// 辅助函数:画绿色虚线矩形,表示预印区域
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
        *预印区域*测试abc
      ],
    ),
  )
}

// 在文档中调用一次,画框
#draw-stamp-box()

// 顶部小区域(放在说明文字上方)
#let top-area-y = 2mm             // 顶部小框距纸顶的微调距离
#let top-area-height = stamp-top - top-area-y - 2mm   // 留出上下空隙

// 放置顶部小内容(绝对定位)
#place(
  dx: 0mm,
  dy: 0mm,
  rect(
    width: content-width,
    height: stamp-top - safe-top - 1mm, // 留出一点空隙
    fill: none,
    stroke: 0.3pt,
    inset: 0pt,
    outset: 0pt,
    // stroke: none,
    [   // 这里写顶部速记内容,如关键公式
      *瑞利与莱斯PDF/CDF图像特征*
    ],
  ),
)

// 跳过预印区,主正文从说明文字下方开始
// !注意:这里的高度是从 safe-top 开始计算的,因为 page 的 margin 已经设置了 safe-top 了
#block(height: stamp-bottom - safe-top)
// 这里可以放置正文内容


#columns(
  3,
  gutter: 1mm,
)[
  【*移动通信*】*广义*:通信双方或至少其中一方在运动状态中(或临时静止状态)进行信息交互的通信方式;采用电磁波为传输媒介的无线通信*狭义*:蜂窝移动通信系统

  【*1-4代系统*】
  *1代(模拟/窄带)* 主多址:FDMA  质量:较差 业务:语音通信  代表:AMPS(美国)、TACS(欧洲)*2代(数字/窄带)*  主多址:FDMA/TDMA/CDMA  质量:较好 业务:语音为主,数字为辅  代表:GSM(欧洲)、IS-95(Qualcomm)*3代(数字/宽带)*多模式多频  主多址:CDMA  质量:好 业务:数字语音多媒体  代表:WCDMA(欧/日)、cdma2000(北美)、TD-SCDMA(中国)*4代(数字/宽带)*  主多址:OFDMA/SC-FDMA  质量:好 业务:数字、语音、多媒体  代表:LTE-A

  *WiMAX和LTE相同技术*:正交频分多址 OFDMA,子信道自适应调制和编码(AMC),混合自动重传请求 (H-ARQ),多输入多输出(MIMO),纯 IP 核心网

  【*移动通信的特点*】:频谱拥挤、频谱需严格菅理;电波传播存在衰落、多径等问题;面临环境的干扰和噪声;存在高速移动和大动态范围的要求;对移动台体积、重量、功耗的要求高;系统复杂,系统需组网,网络需有越区切换、漫游等功能

  【*工作方式*】*单工*:通信双方收发不能同时进行,只能交替进行。同频单工、异频单工;*半双工*:基站为双工,移动台为异频单工;*双工*:通信双方收发能同时工作的方式-*FDD(频分双工,不同频率收发,有保护频带)*:需成对频率,频带宽。适合对称业务(不对称时频谱利用率低);技术简单。收发有保护频带间隔,抗干扰能力强;覆盖范围大,设备成本高。*TDD(时分双工:不同时隙收发,有保护时间)*:不需成对频率,频带窄。支持不对称业务,便于频谱分配,利用率高;需更复杂的网络规划和优化;通过时间隔离,易形成同频干扰;收发同一频段,上下行信道特性一致,便于采用智能天线技术;覆盖范围小,需要更大的发送功率;设备成本降低。*移动中继*:单工中继,双工中继

  【*移动通信应用系统*】*典型应用系统(陆地公众蜂窝发展最快、规模最大)*:*陆地公众蜂窝*(公网,覆盖广、容量大、核心主流);*宽带无线接入*(高带宽、局域高速数据传输,如WiMAX);*无线局域网*(短距离、高 card 速率,如WiFi);*集群通信*(专网专用、多向调度、一呼百应,多用于应急指挥);*无绳电话*(固定电话的无线延伸,基站范围极小);*卫星移动通信*(利用卫星作中继,实现全球大面积乃至远洋荒漠覆盖)。

  #line(length: 100%, stroke: 0.5pt)

  【*无线电波传播方式*】*地波*(沿地球表面传播,低频/长波,传播距离远、较稳定);*天波*(靠电离层反射传播,高频/短波,用于远距离短波通信);*视距/对流层*(在对流层内沿直线或散射传播,超短波/微波,距离受视线限制);*卫星*(穿透电离层,利用卫星中继传输,微波,距离远、覆盖大)

  【*基本电波传播机制*】*直射*(信号最强,无障碍物或天线足够高);*反射*(物体尺寸远大于波长,是多径衰落的主要原因);*绕射*(阻挡体边缘尖锐,基于惠更斯-菲涅尔原理,频率越低绕射能力越强);*散射*(粗糙表面、小物体或不规则物体,使电波向多方向辐射)

  【*大尺度路径损耗*】*自由空间传播损耗(理想状态)*:功率公式 $P_r = P_t G_t G_r (lambda / (4 pi d))^2,L=P_t/P_r$,损耗对数公式 $L("dB") = 32.45 + 20 lg f("MHz") + 20 lg d("km") - 10 lg G_T - 10 lg G_R$;*对数路径损耗模型*:近场 $d=0$ 有奇点故引入远场参考距离 $d_0$,路径损耗指数 $n$ 室外典型值 4(室内可 $<2$),功率公式 $P_r (d) = P_r (d_0) (d_0 / d)^n$,损耗公式 $L(d) = L(d_0) + 10n log_10 (d / d_0)$;*阴影衰落*:大障碍物遮挡引起,引入正态随机变量 $zeta ~ N(0,sigma^2)"dB"$(标准差典型值 8),最终损耗公式 $L(d) = L(d_0) + 10n lg (d / d_0) + zeta_sigma$.

  【*小尺度衰落*】*多径效应*(电波经不同路径到达接收端导致信号矢量叠加衰落,引起时延扩展与时间色散);*多普勒效应*(移动导致频移,公式 $f_d = v/lambda cos theta = f_m cos theta$, $theta$ 为速度与电波夹角,最大多普勒频移 $f_m = v/lambda$,多普勒扩展范围 $f_d in [-f_m, f_m]$,引起多普勒扩展与频率色散).

  【*多径信道模型*】$r,s$对应复包络$r(t)=s(t)*h(t,tau)$ $ h(t, tau) = sum_(i=0)^(N(t)) alpha_i (t) e^(-j phi_i (t)) delta(tau - tau_i (t)) $

  【*瑞利衰落*】*假设*:离基站远且反射物丰富,无直射波,各反射波幅度和相位独立.*本质*经N条独立的衰落路径到达接收端.接收信号包络 $r(t) = sum_(i=0)^N alpha_i exp(-j phi_i)s(t-tau_i)$*1.直角坐标*:定义同相分量 $T_C (t) = Re(r(t))$,正交分量 $T_S (t) = Im(r(t))$.由中心极限定理,当 $N arrow.r infinity$ 时 $T_C,T_S$ 服从高斯分布,且均值为 0,方差 $sigma_C^2 = sigma_S^2 = sigma^2$.其联合概率密度 $p(T_C, T_S) = p(T_C) dot p(T_S) = 1/(2 pi sigma^2) exp(-(T_C^2+T_S^2)/(2 sigma^2))$.*2.坐标变换*:转为极坐标(包络 $r$,相位 $theta$), $T_C = r cos theta, T_S = r sin theta$.雅可比行列式 $|J| = |partial(T_C, T_S)/partial(r, theta)| = r$.新坐标系联合PDF $p_(r,theta)(r,theta) = p(T_C,T_S) dot |J| = r/(2 pi sigma^2) exp(-r^2/(2 sigma^2))$.*3.求边缘PDF*:*包络r*:在 $(0,2 pi)$ 对 $theta$ 积分, $p_r(r) = integral_0^(2 pi) p_(r,theta) d theta = r/sigma^2 exp(-r^2/(2 sigma^2))$ (*瑞利分布*, $r >= 0$);*相位* $theta$:在 $(0,infinity)$ 对 $r$ 积分, $p_theta(theta) = 1/(2 pi)$ (*均匀分布*, $theta in (0,2 pi)$).

  【*莱斯衰落*】*物理前提*:多径信道中存在较强某路信号且占支配地位(有直射波LOS信号).*PDF公式*:当 $r >= 0$ 时, $p(r) = r/sigma^2 exp(-(r^2+A^2)/(2 sigma^2)) I_0((A)/sigma^2)$,当 $r < 0$ 时 $p(r) = 0$.(其中 $A$ 为主信号峰值,其功率为 $A^2/2$; $r$ 为衰落信号包络; $sigma^2$ 为$r$的方差; $I_0(dot)$ 为0阶第一类修正贝塞尔函数).*莱斯因子*:定义为主信号功率与多径分量方差之比,即 $K = A^2/(2 sigma^2)$.当 $A arrow.r 0$ 且 $K arrow.r 0$ 时,无直射分量,莱斯分布退化为*瑞利分布*(衰落最严重);当 $A^2/(2 sigma^2) arrow.r.long infinity$ 且 $K arrow.r.long infinity$ 时,直射波极强,莱斯分布向*高斯分布*趋近(衰落最轻).

  【*时延扩展*】设各多径分量的附加时延为 $tau_i$,对应接收功率为 $P(tau_i)$.*1.平均附加时延*: #text(rgb("#2b6cb0"))[$overline(tau) = (sum_i a_i^2 tau_i)/(sum_i a_i^2) = (sum_i P(tau_i) tau_i) / (sum_i P(tau_i))$] (功率加权的一阶矩);*2.均方根时延扩展*: #text(rgb("#d9383a"))[$sigma_tau = sqrt(overline(tau^2) - (overline(tau))^2)$],其中二阶矩 #text(rgb("#2b6cb0"))[$overline(tau^2) = (sum_i P(tau_i) tau_i^2) / (sum_i P(tau_i))$] (注意 $overline(tau^2)$ 是先平方再加权平均);*3.考场解题避坑*:若题目给出的功率是分贝形式 $P_("dB")$,*必须先转换回线性功率* $P = 10^(P_("dB")/10)$ 再代入上式计算

  【*时间色散 -> 频域波形波动*】多径传播导致时延扩展,测量得平均附加时延 $overline(tau)$ 与均方根时延扩展 $sigma_tau$.信道核心参数为*相干带宽* $B_C$,其定义为信道衰落特性保持高度相关的最大频率范围.严格计算公式 $B_C approx 1 / (2 pi sigma_tau)$,工程近似比例 $B_C prop 1 / sigma_tau$.信号对应参数为*信号带宽* $B_S$.核心判定规则:*1.* 当 #text(rgb("#d9383a"))[$B_S$] $<=$ #text(rgb("#2b6cb0"))[$B_C$] (或符号周期 $T_S >= sigma_tau$)时,信号通过平坦滑梯,各频率衰落一致,产生 #text(rgb("#38a169"))[*平坦衰落(非频率选择性衰落)*],波形不失真;*2.* 当 #text(rgb("#d9383a"))[$B_S$] $>$ #text(rgb("#2b6cb0"))[$B_C$] (或 $T_S < sigma_tau$)时,信号跨越不平坦区,不同频率成分衰落不同导致严重相消,产生 #text(rgb("#d9383a"))[*频率选择性衰落*],其严重后果是引发 #text(rgb("#d9383a"))[*码间干扰(ISI)*] 畸变.

  【*频率色散 -> 时域波形变化*】移动导致多普勒频移,最大多普勒频移 $f_m = v / lambda cos theta$,多普勒扩展导致信道冲激响应随时间快速波动.信道核心参数为*相干时间* $T_C$,其定义为信道特性近似固定不变的时间窗.严格计算公式 $T_C approx 0.423 / f_m$,工程近似比例 $T_C prop 1 / f_m$.信号对应参数为*符号周期(码元宽度)* $T_S$.核心判定规则:*1.* 当 #text(rgb("#d9383a"))[$T_S$] $<=$ #text(rgb("#2b6cb0"))[$T_C$] (或信号带宽 $B_S >= f_m$)时,在单码元传输期间信道来不及变,产生 #text(rgb("#38a169"))[*慢衰落(非时间选择性衰落)*],信道增益恒定;*2.* 当 #text(rgb("#d9383a"))[$T_S$] $>$ #text(rgb("#2b6cb0"))[$T_C$] (或 $B_S < f_m$)时,传输单码元时信道已剧变导致波形首尾不一,产生 #text(rgb("#d9383a"))[*快衰落(时间选择性衰落)*],引发 #text(rgb("#d9383a"))[*严重相位畸变与多普勒展宽*].

  【*角度色散 -> 空域表现异同*】散射体分布导致多角度信号到达接收端,引发空间干涉图样变化.信道核心参数为*相关距离* $D_C$,其定义为信道特性高度相关的空间范围.工程近似比例 $D_C prop 1 / (chevron.l alpha chevron.r)$( $chevron.l alpha chevron.r$ 为角度扩展).系统设计参数为*天线阵列间距* $Delta x$.核心判定规则:*1.* 当 #text(rgb("#d9383a"))[$Delta x$] $<=$ #text(rgb("#2b6cb0"))[$D_C$] 时,两根天线处于同一个空间同质区,接收衰落完全相同,产生*空间非选择性衰落*,天线冗余失效;*2.* 当 #text(rgb("#d9383a"))[$Delta x$] $>$ #text(rgb("#2b6cb0"))[$D_C$] 时,各天线处干涉独立(一根在波峰一根在波谷),产生 #text(rgb("#38a169"))[*空间选择性衰落*]. 这是实现 #text(rgb("#38a169"))[*空间分集与多天线MIMO技术*] 从而对抗多径衰落的物理前提.

]

