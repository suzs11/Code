# 第三章代码说明
### 这一章的都是为研究Logistic、Lorenz、Rössler系统的分岔图和Lyapunov指数图搜集的图片。
+ [logistic_g.m为图3.1](logistic_g.m)的代码。固定初始值，选择不同的$\mu$值来得到周期和混沌时序图。
+ [Logistic.m为图3.2](Logistic.m)的代码。
+ [plorenz.m为图3.3](plorenz.m)的代码，通过ode45解微分方程。
+ [lorenzLya.m为图3.4](lorenzLya.m)的代码，选择Matlab系统默认的eps作为扰动，Lorenz系统演化产生偏离，用e指数衡量轨道偏离程度。
+ [prossler.m为图3.5和3.6](prossler.m)的代码，用ode45解微分方程。
+ [rosslerLya.m](rosslerLya.m)为图3.7的b图的代码。[bifross.m](bifross.m)为图3.7中a图的代码。类似的Lorenz系统x方向的分岔图可用[biflor.m](biflor.m)得到。