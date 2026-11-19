function varargout = DeHaze(varargin)
% UNTITLED5 MATLAB code for untitled5.fig
%      UNTITLED5, by itself, creates a new UNTITLED5 or raises the existing
%      singleton*.
%
%      H = UNTITLED5 returns the handle to a new UNTITLED5 or the handle to
%      the existing singleton*.
%
%      UNTITLED5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED5.M with the given input arguments.
%
%      UNTITLED5('Property','Value',...) creates a new UNTITLED5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled5

% Last Modified by GUIDE v2.5 04-Jul-2024 19:45:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled5_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled5_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled5 is made visible.
function untitled5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled5 (see VARARGIN)

% Choose default command line output for untitled5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled5_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 允许用户选择图像文件
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Select an Image');
if isequal(filename, 0)
    disp('用户取消选择图片');
else
    % 构建图像的完整路径
    imgPath = fullfile(pathname, filename);
 end
    
    % 读取图像并在 GUI 中显示
    img = imread(imgPath);
    axes(handles.axes1);  % 设置显示图像的坐标轴
    imshow(img);  % 显示图像
    title('原始的图像');
    % 将图像路径保存到 handles 结构体中，以便后续操作
    handles.currentImage = img;
     handles.imgPath = imgPath;
    guidata(hObject, handles);  % 更新 handles 结构体
 


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.currentImage;
R = I(:,:,1);  G = I(:,:,2);  B = I(:,:,3);   % 提取红绿蓝三个通道
%  对三个通道分别进行均衡化处理后整合为三维图像
M = histeq(R);  N = histeq(G);  L = histeq(B);   In = cat(3, M, N, L);
 axes(handles.axes2);  % 设置显示图像的坐标轴
 imshow(In);  % 显示图像
 title('去雾后的图像');


% 灰度化处理
    Q = rgb2gray(I);      W = rgb2gray(In);
 axes(handles.axes3);  % 设置显示图像的坐标轴
 imhist(Q, 64); title('原灰度直方图', 'FontWeight', 'Bold');
axes(handles.axes4);  % 设置显示图像的坐标轴
 imhist(W, 64); title('处理后的灰度直方图', 'FontWeight', 'Bold');
  handles.img=In;
   guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.img=handles.i;
axes(handles.axes2); 
cla; 
imshow(handles.currentImage);
guidata(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file path]= uiputfile('*.jpg','Save Image as');
save=[path file]; imwrite(handles.img,save,'jpg');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取图像
image =  handles.currentImage;

% 设置参数
omega = 0.5; % 可调整的参数，控制大气光的估计比例
radius = 18;  % 可调整的参数，控制导向滤波器的半径

% 调用暗通道去雾函数
dehazed_image = dark_channel_dehaze(image, omega, radius);

  % 显示原始图像和去雾后的图像
    axes(handles.axes2);  % 设置显示图像的坐标轴
    imshow(dehazed_image); title('去雾后的图像');

    % 灰度化处理
    Q = rgb2gray(image);      W = rgb2gray(dehazed_image);
 axes(handles.axes3);  % 设置显示图像的坐标轴
 imhist(Q, 64); title('原灰度直方图', 'FontWeight', 'Bold');
axes(handles.axes4);  % 设置显示图像的坐标轴
 imhist(W, 64); title('处理后的灰度直方图', 'FontWeight', 'Bold');

 handles.img=dehazed_image;
   guidata(hObject,handles);


function dehazed_image = dark_channel_dehaze(image, omega, radius)
    % 将输入图像转换为双精度格式
    image = im2double(image);
    
    % 估计输入图像的暗通道
    dark_channel = min(image, [], 3);
    
    % 计算大气光
    [rows, cols] = size(dark_channel);
    num_pixels = rows * cols;
    num_pixels_to_keep = round(num_pixels * omega);
    
    flat_dark_channel = reshape(dark_channel, num_pixels, 1);
    sorted_dark_channel = sort(flat_dark_channel, 'descend');
    atmospheric_light = mean(sorted_dark_channel(1:num_pixels_to_keep));
    
    % 估计透射率图
    transmission_map = 1 - omega * dark_channel / atmospheric_light;
    
    % 使用导向滤波器细化透射率图
    transmission_guided = imguidedfilter(transmission_map, image, 'NeighborhoodSize', [radius, radius], 'DegreeOfSmoothing', 0.0001);
    
    % 去雾处理图像
    epsilon = 0.001;
    dehazed_image = zeros(size(image));
    for i = 1:3
        dehazed_image(:,:,i) = (image(:,:,i) - atmospheric_light) ./ max(transmission_guided, epsilon) + atmospheric_light;
    end
    
    % 将像素值裁剪到[0, 1]范围内
    dehazed_image = max(0, min(dehazed_image, 1));
    
  


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取图像
image =  handles.currentImage;

% 设置参数
alpha = 0.8; % 可调整的参数，控制局部对比度对透射率的贡献度
beta = 0.5;  % 可调整的参数，用于调节整体的透射率值

% 调用基于局部对比度的去雾函数
dehazed_image = contrast_based_dehaze(image, alpha, beta);

 % 显示原始图像和去雾后的图像
    axes(handles.axes2);  % 设置显示图像的坐标轴
    imshow(dehazed_image); title('去雾后的图像');

    % 灰度化处理
    Q = rgb2gray(image);      W = rgb2gray(dehazed_image);
 axes(handles.axes3);  % 设置显示图像的坐标轴
 imhist(Q, 64); title('原灰度直方图', 'FontWeight', 'Bold');
axes(handles.axes4);  % 设置显示图像的坐标轴
 imhist(W, 64); title('处理后的灰度直方图', 'FontWeight', 'Bold');


 handles.img=dehazed_image;
   guidata(hObject,handles);



 function dehazed_image = contrast_based_dehaze(image, alpha, beta)
    % 将输入图像转换为双精度格式
    image = im2double(image);
    
    % 计算图像的局部对比度
    local_contrast = compute_local_contrast(image);
    
    % 估计透射率图
    transmission_map = 1 - alpha * local_contrast + beta;
    
    % 调整透射率图的大小与原始图像匹配
    transmission_map = imresize(transmission_map, [size(image, 1), size(image, 2)]);
    
    % 去雾处理图像
    epsilon = 0.001;
    dehazed_image = zeros(size(image));
    for i = 1:3
        dehazed_image(:,:,i) = (image(:,:,i) - 1) ./ max(transmission_map, epsilon) + 1;
    end
    
    % 将像素值裁剪到[0, 1]范围内
    dehazed_image = max(0, min(dehazed_image, 1));
    


function local_contrast = compute_local_contrast(image)
    % 计算图像的局部对比度
    window_size = 17; % 可调整的窗口大小，影响局部对比度计算的精度
    sigma = 0.2;      % 可调整的高斯核标准差，影响局部对比度计算的平滑度
    
    % 计算局部对比度
    local_contrast = stdfilt(rgb2gray(image), true(window_size));
    local_contrast = imgaussfilt(local_contrast, sigma);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取图像
image =  handles.currentImage;
% 设置参数
omega = 0.95; % 控制去雾效果的强度
t0 = 0.1;    % 防止除零的最小透射率

% 调用基于大气散射模型的去雾函数
dehazed_image = atmospheric_scattering_dehaze(image, omega, t0);
 % 显示原始图像和去雾后的图像
    axes(handles.axes2);  % 设置显示图像的坐标轴
    imshow(dehazed_image); title('去雾后的图像');

    % 灰度化处理
    Q = rgb2gray(image);      W = rgb2gray(dehazed_image);
 axes(handles.axes3);  % 设置显示图像的坐标轴
 imhist(Q, 64); title('原灰度直方图', 'FontWeight', 'Bold');
axes(handles.axes4);  % 设置显示图像的坐标轴
 imhist(W, 64); title('处理后的灰度直方图', 'FontWeight', 'Bold');


 handles.img=dehazed_image;
   guidata(hObject,handles);

 function dehazed_image = atmospheric_scattering_dehaze(image, omega, t0)
    % 将输入图像转换为双精度格式
    image = im2double(image);
    
    % 估计大气光
    dark_channel = get_dark_channel(image, 15);
    A = estimate_atmospheric_light(image, dark_channel);
    
    % 估计透射率
    transmission = estimate_transmission(image, A, omega);
    
    % 去雾处理图像
    dehazed_image = recover_image(image, A, transmission, t0);
    


function dark_channel = get_dark_channel(image, patch_size)
    % 获取暗通道
    dark_channel = min(image, [], 3);
    dark_channel = imerode(dark_channel, strel('square', patch_size));


function A = estimate_atmospheric_light(image, dark_channel)
    % 估计大气光
    [h, w, ~] = size(image);
    num_pixels = h * w;
    num_brightest = floor(num_pixels * 0.001); % 取最亮的0.1%像素
    
    % 对暗通道图像进行排序
    [~, indices] = sort(dark_channel(:), 'descend');
    brightest_indices = indices(1:num_brightest);
    
    % 计算大气光
    A = mean(image(brightest_indices));


function transmission = estimate_transmission(image, A, omega)
    % 估计透射率
    norm_image = bsxfun(@rdivide, image, A);
    dark_channel = get_dark_channel(norm_image, 15);
    transmission = 1 - omega * dark_channel;


function recovered_image = recover_image(image, A, transmission, t0)
    % 恢复无雾图像
    transmission = max(transmission, t0);
    transmission = repmat(transmission, [1, 1, 3]);
    recovered_image = (image - A) ./ transmission + A;


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取图像
image =  handles.currentImage;

% 设置参数
omega = 0.95; % 控制去雾效果的强度
r = 40;      % 引导滤波器的半径
eps = 0.001; % 引导滤波器的正则化参数

% 调用基于引导滤波的去雾函数
dehazed_image = guided_filter_dehaze(image, omega, r, eps);
 % 显示原始图像和去雾后的图像
    axes(handles.axes2);  % 设置显示图像的坐标轴
    imshow(dehazed_image); title('去雾后的图像');

    % 灰度化处理
    Q = rgb2gray(image);      W = rgb2gray(dehazed_image);
 axes(handles.axes3);  % 设置显示图像的坐标轴
 imhist(Q, 64); title('原灰度直方图', 'FontWeight', 'Bold');
axes(handles.axes4);  % 设置显示图像的坐标轴
 imhist(W, 64); title('处理后的灰度直方图', 'FontWeight', 'Bold');


% 保存为 guided_filter_dehaze.m
function dehazed_image = guided_filter_dehaze(image, omega, r, eps)
    % 将输入图像转换为双精度格式
    image = im2double(image);
    
    % 计算暗通道
    dark_channel = get_dark_channel(image, 15);
    
    % 估计大气光
    A = estimate_atmospheric_light(image, dark_channel);
    
    % 估计粗略透射率图
    transmission = estimate_transmission(image, A, omega);
    
    % 使用引导滤波器细化透射率图
    transmission_refined = guided_filter(rgb2gray(image), transmission, r, eps);
    
    % 去雾处理图像
    dehazed_image = recover_image(image, A, transmission_refined, 0.1);
    








function q = guided_filter(I, p, r, eps)
    % 引导滤波器
    I = double(I);
    p = double(p);
    [hei, wid] = size(I);
    N = boxfilter(ones(hei, wid), r);

    mean_I = boxfilter(I, r) ./ N;
    mean_p = boxfilter(p, r) ./ N;
    mean_Ip = boxfilter(I .* p, r) ./ N;
    cov_Ip = mean_Ip - mean_I .* mean_p;

    mean_II = boxfilter(I .* I, r) ./ N;
    var_I = mean_II - mean_I .* mean_I;

    a = cov_Ip ./ (var_I + eps);
    b = mean_p - a .* mean_I;

    mean_a = boxfilter(a, r) ./ N;
    mean_b = boxfilter(b, r) ./ N;

    q = mean_a .* I + mean_b;


function imDst = boxfilter(imSrc, r)
    % 方框滤波器
    [hei, wid] = size(imSrc);
    imDst = zeros(size(imSrc));

    % 累加求和
    imCum = cumsum(imSrc, 1);
    imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
    imDst(r+2:hei-r, :) = imCum(2*r+2:hei, :) - imCum(1:hei-2*r-1, :);
    imDst(hei-r+1:hei, :) = repmat(imCum(hei, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :);

    % 再次累加求和
    imCum = cumsum(imDst, 2);
    imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
    imDst(:, r+2:wid-r) = imCum(:, 2*r+2:wid) - imCum(:, 1:wid-2*r-1);
    imDst(:, wid-r+1:wid) = repmat(imCum(:, wid), [1, r]) - imCum(:, wid-2*r:wid-r-1);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 读取图像
image =  handles.currentImage;
% 设置参数
scales = [50, 20, 10]; % 多尺度Retinex的尺度
weight = [1/2, 1/2, 1/2]; % 各尺度的权重

% 调用基于多尺度Retinex的去雾函数
dehazed_image = msr_dehaze(image, scales, weight);
 % 显示原始图像和去雾后的图像
    axes(handles.axes2);  % 设置显示图像的坐标轴
    imshow(dehazed_image); title('去雾后的图像');

    % 灰度化处理
    Q = rgb2gray(image);      W = rgb2gray(dehazed_image);
 axes(handles.axes3);  % 设置显示图像的坐标轴
 imhist(Q, 64); title('原灰度直方图', 'FontWeight', 'Bold');
axes(handles.axes4);  % 设置显示图像的坐标轴
 imhist(W, 64); title('处理后的灰度直方图', 'FontWeight', 'Bold');




function dehazed_image = msr_dehaze(image, scales, weight)
    % 将输入图像转换为双精度格式
    image = im2double(image);
    
    % 将图像转换为对数域
    log_image = log(image + 1);
    
    % 初始化多尺度Retinex滤波后的图像
    msr_image = zeros(size(image));
    
    % 对图像应用多尺度Retinex滤波
    for i = 1:length(scales)
        % 高斯滤波
        blurred_image = imgaussfilt(image, scales(i));
        log_blurred = log(blurred_image + 1);
        
        % 计算Retinex图像
        retinex_image = log_image - log_blurred;
        
        % 累加加权后的Retinex图像
        msr_image = msr_image + weight(i) * retinex_image;
    end
    
    % 将图像转换回线性域
    dehazed_image = exp(msr_image);
    
    % 调整图像的对比度和亮度
    dehazed_image = imadjust(dehazed_image, stretchlim(dehazed_image), []);
    
