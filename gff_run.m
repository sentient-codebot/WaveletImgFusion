
%% load image
% 
% fig_origin1 = imread("source22_1.tif");
% fig_origin2 = imread("source22_2.tif");

fig_origin1 = imread("c01_1.tif");
fig_origin2 = imread("c01_2.tif");

fig_origin1 = im2single(fig_origin1);fig_origin2 = im2single(fig_origin2);

% display image
figure
subplot(1,2,1)
imshow(fig_origin1)
subplot(1,2,2)
imshow(fig_origin2)

%% transform
tic
fig = gff(fig_origin1,fig_origin2,...
        'rg',31,...
        'r1',45,...
        'eps1',0.3,...
        'r2',7,...
        'eps2',1e-6,...
        's',3);
toc
%% display result
figure;
subplot(1,3,1)
imshow(fig_origin1)
subplot(1,3,2)
imshow(fig_origin2)
subplot(1,3,3)
imshow(fig)