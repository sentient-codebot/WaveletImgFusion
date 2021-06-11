clc;
clear;
%% input pair images
fig_origin1 = imread("./images/input004_1.tif");
fig_origin2 = imread("./images/input004_2.tif");
fig_origin1 = im2double(fig_origin1);
fig_origin2 = im2double(fig_origin2);
%% run fusion algorithm(wavelet_based)
wname='haar';rule = 'modified';iter = 1;iterations = 100;
% Wavelet Families(you can choose any of the follwing wavelets)
% 
% Wavelets
% 
% Daubechies
% 
% 'db1' or 'haar', 'db2', ..., 'db10', ..., 'db45'
% Coiflets
% 
% 'coif1', ..., 'coif5'
% Symlets
% 
% 'sym2', ..., 'sym8', ...,'sym45'
% Fejer-Korovkin filters
% 
% 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'
% Discrete Meyer
% 
% 'dmey'
% Biorthogonal
% 
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% Reverse Biorthogonal
% 
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'
% tic;
% [fig,bdm] = fusion_using_wt(fig_origin1,fig_origin2,wname,rule,iter,iterations);
% toc;
wv = 'db2';
lv = 5;
fig = wfusimg(fig_origin1,fig_origin2,wv,lv,'mean','max');
%% input test image
% fig_test = imread("clock3.tif");
% fig_test = im2double(fig_test);

%% comparison & measuring performance
% fusion technique
% dif = fig - fig_test;
% dif_N = mat2gray(dif);
% % pixel averaging
% fig_pa = (fig_origin1+fig_origin2)/2;
% dif_pa = fig_pa - fig_test;
% dif_paN = mat2gray(dif_pa);
% % measuring performance
% roi = sqrt(sum(dif_N.^2,'all')/(size(fig,1)*size(fig,2)));
% roi_pa = sqrt(sum(dif_paN.^2,'all')/(size(fig,1)*size(fig,2)));
% Qy metric
% Qy = ssim_based_assessment(fig_origin1,fig_origin2,fig);
% Qy_ref = ssim_based_assessment(fig_origin1,fig_origin2,fig_test);


%% plot images
figure;
subplot(1,3,1);
imshow(fig_origin1);
subplot(1,3,2);
imshow(fig_origin2);
% sgtitle("Original Image Pair");
% figure;
% subplot(1,2,1);
% imshow(fig_pa)
% subplot(1,2,2);
% imshow(dif_paN);
% sgtitle("Pixel Averaging Fusion");
% figure;
% subplot(1,3,1);
% imshow(bdm);
subplot(1,3,3);
imshow(fig);
% subplot(1,3,3);
% imshow(dif_N);
sgtitle("Fusion Using The Wavelet Transform");

%% output
imwrite(fig, 'input004_fused_buildin(mean,max).png','png');