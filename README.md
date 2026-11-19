内容包括几种非常经典的图像去雾算法，大家可以参考。
可以用NH-HAZE数据集(Non-Homogeneous Haze Dataset)和O-HAZE数据集（outdoor scenes Haze Dataset）进行实验。正好可以对比均匀与非均匀场景的去雾结果，更充分展示各类算法的适用范围与局限。
这里放一下官方下载渠道：
NH-HAZE: https://data.vision.ee.ethz.ch/cvl/ntire20/nh-haze/
O-HAZE: https://data.vision.ee.ethz.ch/cvl/ntire18/o-haze/

还用designer做了一个比较清晰可爱的可视化界面～
<img width="1129" height="607" alt="Screenshot 2026-11-19 at 18 08 49" src="https://github.com/user-attachments/assets/98e8d923-6227-4b4b-9aab-761204f55a26" />

算法文件清单
% Main.fig Main.m GUI文件

% DehazeNet 的文件:
% boxfilter.m convConst.cpp convConest.mexw64 convMax.m convloution.m dehaze.mat guidedfilter.m run_cnn.m sse.hpp wrappers.hpp

% MSCNNd 的文件：
% dehazing_code matlab

% 全局均衡化 的文件：
% Global_1.m

% 局部均衡化 的文件：
% Local_1.m

% SSR\MSR\MSRCR 的文件：
% Retinex_1.m Retinex_2.m Retinex_3.m

% 暗通道 的文件：
% Antongd_1.m

% 改进的暗通道 的文件：
% guided_filter.m  get_dark_channel.m  estimate_atmosphere.m  estimate_transmission.m

要申明的是这些内容是我两年前做的了，从硬盘里掏出来的版本也不清楚是不是最后可以实现的版本，现在的电脑甚至连MATLAB都没安装哈哈哈，所以肯定会有很多错误的地方，参考的时候请分辨，也有大好人可以在评论中指出，代码部分我是不打算更新维护了。希望可以帮助到各位学习基础的图像去雾算法：）
