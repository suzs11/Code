# 第四章代码说明
### 这一章的都是为说明回归图算法及其参数优化。
+ [fig4_1.tex](fig4_1.tex)为图4.1的画图代码，用$\LaTeX$编译即可得到。
+ [fig4_2.py](fig4_2)为图4.2的画图代码，python版本为3.8，必要的模块`numpy`、`matplotlib`和`scipy`,可用类似`pip install numpy`进行安装，若是用`Anaconda`可直接进行编译。
+ [fig4_3.m](fig4_3.m)图4.3的代码，用`autoMI.m`和`myDelay.m`寻找系统x方向的时间序列的延迟时间参数，用找到的参数来重构Lorenz系统的相空间。
+ [rp_lgsc.py](rp_lgsc.py)为图4.6的代码。
+ [rp_lor.py](rp_lor.py)为图4.8的代码。
+ [rp_lor.py](rp_lgsc.py)将`if __name__=='__main__'`中的train_data改为$R\"ossler$系统,即可得到图4.10的代码。
+ [fig4.5.m](fig4_5.m), [fig4.7.m](fig4_7.m), [fig4_9.m](fig4_9.m)分别是图4.5、图4.7和图4.9对应的代码。