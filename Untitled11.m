  
%%
clc;
clear;
%% import data
fig_origin1 = imread("source22_1.tif");
fig_origin2 = imread("source22_2.tif");
fig_origin1 = im2double(fig_origin1);fig_origin2 = im2double(fig_origin2);
figure;
subplot(1,2,1);
imshow(fig_origin1);
subplot(1,2,2);
imshow(fig_origin2);
%% wavelet transform
fig1 = fig_origin1;
fig2 = fig_origin2;
% set the wavelet type to haar
wname = 'haar';
[row, col] = size(fig1);
% l = length;
% w = width;
iter = 1;
[c1,s] = wavedec2(fig1,iter,wname);
[c2,~] = wavedec2(fig2,iter,wname);
% % while 1
% %     if mod(l,2) == 0 && mod(w,2) == 0
% %         iter = iter+1;
% %         l = l/2;
% %         w = w/2;
% %     else
% %         break;
% %     end
% % end
% % use dwt2() to implement full 2D wavelet decomposition
% for j=iter:-1:1
%     
%     % TODO4a - select the coarse scale (subimage)
%     a1 = fig1(1:length/(2^(iter-j)),1:width/2^((iter-j)));
%     a2 = fig2(1:length/2^((iter-j)),1:width/2^((iter-j)));
%     
%     % apply dwt2 to coarse scale
%     [cA1,cH1,cV1,cD1] = dwt2(a1,wavename);
%     [cA2,cH2,cV2,cD2] = dwt2(a2,wavename);
%     
%     % TODO4b - build-up the wavelet component according to Figure 1 in labwork
%     % cA->T_phi, cH->T^H_psi, cV->T^V_psi, cD->T^D_psi
%     tmp1 = [cA1,cH1;cV1,cD1];
%     tmp2 = [cA2,cH2;cV2,cD2];
%     
%     % TODO4c - substitute wavelet component into coarse scale, iverse of
%     % TODO4a
%     fig1(1:length/(2^(iter-j)),1:width/2^((iter-j))) = tmp1;
%     fig2(1:length/(2^(iter-j)),1:width/2^((iter-j))) = tmp2;
% end
% figure;
% subplot(1,2,1);
% imshow(C);
% subplot(1,2,2);
% imshow(S);
%% fusion process
%% maximum selection rule
    
len = length(c1);
coef_fusion = zeros(1,len);
coef_fusion(1:s(1,1)*s(1,2)) = (c1(1:s(1,1)*s(1,2))+c2(1:s(1,1)*s(1,2)))/2;
mm1 = c1(s(1,1)*s(1,2)+1:len);
mm2 = c2(s(1,1)*s(1,2)+1:len);
id = abs(mm1)>abs(mm2);
mm = (mm1.*id)+(~id.*mm2);
coef_fusion(s(1,1)*s(1,2)+1:len)=mm;
% fig = zeros(length, width);
% fig = max(fig1,fig2);
% fig(1:length/2^iter,1:width/2^iter) = (fig1(1:length/2^iter,1:width/2^iter) + fig2(1:length/2^iter,1:width/2^iter));
%% mean-mean
coef_fusion = (c1+c2)/2;
%% modified feature selection algorithm
fig1 = appcoef2(c1,s,wname,iter);
fig2 = appcoef2(c2,s,wname,iter);
for i = iter:-1:1
    [H1,V1,D1] = detcoef2('all',c1,s,i);
    [H2,V2,D2] = detcoef2('all',c2,s,i);
    fig1 = [fig1,H1;V1,D1];
    fig2 = [fig2,H2;V2,D2];
end


wd_size = 3; % specify the window size
fig1_pd = padarray(fig1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
fig2_pd = padarray(fig2,[(wd_size-1)/2,(wd_size-1)/2]);
fig1_pd = dlarray(fig1_pd);fig2_pd = dlarray(fig2_pd);
fig1_mp = maxpool(fig1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
fig2_mp = maxpool(fig2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
fig1_mp = extractdata(fig1_mp);fig2_mp = extractdata(fig2_mp);
bdm = fig1_mp>fig2_mp; % binary decision map(1 for fig1,0 for fig2)
% consisteny verification
convo = [1,1,1;1,0,1;1,1,1];
bdm_f = zeros(size(bdm));
bdm_m = ones(size(bdm));%initial
% while ~min(min(bdm_f == bdm_m))
iterations = 1;
while iterations
% bdm_m = bdm;
% mid = conv2(bdm,convo,'same');
% bdm = mid>4;
% bdm_f = bdm; % final binary decision map
bdm = bwmorph(bdm,'majority');
iterations = iterations-1;
end
fig = bdm.*fig1;
fig = fig+~bdm.*fig2;
figure;
imshow(bdm);
%% inverse wavelet transform
coef_fusion = [];
coef_fusion(1:(row/2^iter)*(col/2^iter)) = reshape(fig(1:row/2^iter,1:col/2^iter),1,[]);
for i = iter:-1:1
    H = reshape(fig(row/2^i+1:row/(2^(i-1)),1:col/(2^i)),1,[]);
    V = reshape(fig(1:row/(2^i),col/2^i+1:col/(2^(i-1))),1,[]);
    D = reshape(fig(row/2^i+1:row/(2^(i-1)),col/2^i+1:col/(2^(i-1))),1,[]);
    coef_fusion = [coef_fusion,V,H,D];
end
%%
% for j = 1:iter
%     
%     % TODO5a - select the coarse scale (subimage)
%     a = fig(1:length/(2^(iter-j)),1:width/2^((iter-j)));    
%     
%     % TODO5b - set the coarse scale size
%     m = length/(2^(iter-j+1));
%     n = width/(2^(iter-j+1));
%     
%     % TODO5c - apply idwt2 to coarse scale
%     % carefully choose cA and details matrices cH, cV, and cD
%     cA = a(1:m,1:n);
%     cH = a(1:m,n+1:2*n);
%     cV = a(m+1:2*m,1:n);
%     cD = a(m+1:2*m,n+1:2*n);
%     tmp = idwt2(cA, cH, cV, cD, wname);
%     
%     % TODO5d - substitute wavelet component into coarse scale
%     fig(1:length/(2^(iter-j)),1:width/2^((iter-j))) = tmp;
% end
fig = waverec2(coef_fusion,s,wname);
figure;
imshow(fig);
%% plot fusion result
figure;
subplot(1,3,1);
imshow(fig_origin1);
subplot(1,3,2);
imshow(fig_origin2);
subplot(1,3,3);
imshow(fig);