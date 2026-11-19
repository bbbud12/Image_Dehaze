

% ==== 1. 读取并转灰度 ====
I_rgb = imread('1.jpg');    % 也可以换成 png/tif
I_gray = rgb2gray(I_rgb);            % 若已是灰度图，这一步会自动保持不变

% ==== 2. 绘制直方图 ====
figure;

imhist(I_gray, 256);                 % 256 个灰度级
title('a) 原图像的灰度直方图','FontSize',25);
xlabel('Gray Level (0–255)','FontSize',16);
ylabel('Pixel Count','FontSize',20);
ax = gca;                        % 取得坐标轴
ax.XAxis.FontSize = 18;          % 横轴数字
ax.YAxis.FontSize = 18;          % 纵轴数字

ax = gca;          % 获取当前坐标轴句柄
ax.FontSize = 18;  % 刻度数字字号（可改 16、20 等）
% ==== 3. 可选：保存直方图 ====
saveas(gcf, 'gray_histogram.png');
