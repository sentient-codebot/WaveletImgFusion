fig_origin1 = imread("clock2.tif");
fig_origin2 = imread("clock1.tif");

wname='haar';rule = 'modified';iter = 8;iterations = 1;
[fig,bdm] = fusion_using_wt(fig_origin1,fig_origin2,wname,rule,iter,iterations);

fig_test = imread("clock3.tif");
fig_origin1 = im2double(fig_origin1);
fig_origin2 = im2double(fig_origin2);
fig_test = im2double(fig_test);
figure;
subplot(1,2,1);
imshow(fig_origin1);
subplot(1,2,2);
imshow(fig_origin2);

dif = fig - fig_test;
dif_N = mat2gray(dif);
% pixel averaging
fig_pa = (fig_origin1+fig_origin2)/2;
dif_pa = fig_pa - fig_test;
dif_paN = mat2gray(dif_pa);
figure;
imshow(dif_paN);

roi = sqrt(sum(dif_N.^2,'all')/(size(fig,1)*size(fig,2)));
figure;
subplot(2,2,1);
imshow(fig_origin1);
subplot(2,2,2);
imshow(fig_origin2);
subplot(2,2,3);
imshow(fig);
subplot(2,2,4);
imshow(dif_N);