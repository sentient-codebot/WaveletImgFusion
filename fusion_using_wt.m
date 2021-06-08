function [fig,bdm] = fusion_using_wt(fig_origin1,fig_origin2,wname,rule,iter,iterations)
% -------------------------------------------------------------------------
% This function implements image fusion algorithm using wavelet transform.
% Inputs:
% fig_origin1: first image of an image fusion pair.
% fig_origin1: second image of an image fusion pair.
% wname: wavelet name.
% rule: rules of fusion; 'max' or 'modified'(modified feature selection alg
% orithm).
% iter: wavelet decomposition level.
% iterations: consistency verification level.
% Outputs:
% fig: fusioned image.
% bdm: binary decision map.
% -------------------------------------------------------------------------

%% format transform
fig_origin1 = im2double(fig_origin1);
fig_origin2 = im2double(fig_origin2);

%% wavelet transform
fig1 = fig_origin1;
fig2 = fig_origin2;
% set the wavelet type to haar
[row, col] = size(fig1);
% l = length;
% w = width;
[c1,s] = wavedec2(fig1,iter,wname);
[c2,~] = wavedec2(fig2,iter,wname);

%% fusion process
%% maximum selection rule
if strcmp(rule,'max')    
len = length(c1);
coef_fusion = zeros(1,len);
coef_fusion(1:s(1,1)*s(1,2)) = (c1(1:s(1,1)*s(1,2))+c2(1:s(1,1)*s(1,2)))/2;
mm1 = c1(s(1,1)*s(1,2)+1:len);
mm2 = c2(s(1,1)*s(1,2)+1:len);
id = abs(mm1)>abs(mm2);
mm = (mm1.*id)+(~id.*mm2);
coef_fusion(s(1,1)*s(1,2)+1:len)=mm;
bdm = [];

elseif strcmp(rule,'modified')    
%% modified feature selection algorithm
fig1 = appcoef2(c1,s,wname,iter);
fig2 = appcoef2(c2,s,wname,iter);
wd_size = 3; % specify the window size
fig = (fig1+fig2)/2;

if strcmp(wname,'haar')
bdm = 0.5*ones(size(fig));
for i = iter:-1:1
    [H1,V1,D1] = detcoef2('all',c1,s,i);
    [H2,V2,D2] = detcoef2('all',c2,s,i);
    
    H1_pd = padarray(H1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
    H2_pd = padarray(H2,[(wd_size-1)/2,(wd_size-1)/2]);
    V1_pd = padarray(V1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
    V2_pd = padarray(V2,[(wd_size-1)/2,(wd_size-1)/2]);
    D1_pd = padarray(D1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
    D2_pd = padarray(D2,[(wd_size-1)/2,(wd_size-1)/2]);
    H1_pd = abs(H1_pd);H2_pd = abs(H2_pd);
    V1_pd = abs(V1_pd);V2_pd = abs(V2_pd);
    D1_pd = abs(D1_pd);D2_pd = abs(D2_pd);
    H1_pd = dlarray(H1_pd);H2_pd = dlarray(H2_pd);
    V1_pd = dlarray(V1_pd);V2_pd = dlarray(V2_pd);
    D1_pd = dlarray(D1_pd);D2_pd = dlarray(D2_pd);
    H1_mp = maxpool(H1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
    H2_mp = maxpool(H2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
    V1_mp = maxpool(V1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
    V2_mp = maxpool(V2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
    D1_mp = maxpool(D1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
    D2_mp = maxpool(D2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
    H1_mp = extractdata(H1_mp);H2_mp = extractdata(H2_mp);
    V1_mp = extractdata(V1_mp);V2_mp = extractdata(V2_mp);
    D1_mp = extractdata(D1_mp);D2_mp = extractdata(D2_mp);
    bdmH = H1_mp>H2_mp; % binary decision map(1 for fig1,0 for fig2)
    bdmV = V1_mp>V2_mp;
    bdmD = D1_mp>D2_mp;
    % consisteny verification
%     convo = [1,1,1;1,0,1;1,1,1];
%     bdm_f = zeros(size(bdm));
%     bdm_m = ones(size(bdm));%initial
    % while ~min(min(bdm_f == bdm_m))
    i = iterations;
    while i
%     bdm_m = bdm;
%     mid = conv2(bdm,convo,'same');
%     bdm = mid>4;
%     bdm_f = bdm; % final binary decision map
    bdmH = bwmorph(bdmH,'majority');
    bdmV = bwmorph(bdmV,'majority');
    bdmD = bwmorph3(bdmD,'majority');
    i = i-1;
    end
    H = bdmH.*H1;
    H = H+~bdmH.*H2;
    V = bdmV.*V1;
    V = V+~bdmV.*V2;
    D = bdmD.*D1;
    D = D+~bdmD.*D2;
    fig = [fig,H;V,D];
    bdm = [bdm,bdmH;bdmV,bdmD];
end

coef_fusion = [];
coef_fusion(1:(row/2^iter)*(col/2^iter)) = reshape(fig(1:row/2^iter,1:col/2^iter),1,[]);
for i = iter:-1:1
    V = reshape(fig(row/2^i+1:row/(2^(i-1)),1:col/(2^i)),1,[]);
    H = reshape(fig(1:row/(2^i),col/2^i+1:col/(2^(i-1))),1,[]);
    D = reshape(fig(row/2^i+1:row/(2^(i-1)),col/2^i+1:col/(2^(i-1))),1,[]);
    coef_fusion = [coef_fusion,H,V,D];
end
else
    fig = reshape(fig,1,[]);
    for i = iter:-1:1
    [H1,V1,D1] = detcoef2('all',c1,s,i);
    [H2,V2,D2] = detcoef2('all',c2,s,i);
    
    H1_pd = padarray(H1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
    H2_pd = padarray(H2,[(wd_size-1)/2,(wd_size-1)/2]);
    V1_pd = padarray(V1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
    V2_pd = padarray(V2,[(wd_size-1)/2,(wd_size-1)/2]);
    D1_pd = padarray(D1,[(wd_size-1)/2,(wd_size-1)/2]);%padding
    D2_pd = padarray(D2,[(wd_size-1)/2,(wd_size-1)/2]);
    H1_pd = abs(H1_pd);H2_pd = abs(H2_pd);
    V1_pd = abs(V1_pd);V2_pd = abs(V2_pd);
    D1_pd = abs(D1_pd);D2_pd = abs(D2_pd);
    H1_pd = dlarray(H1_pd);H2_pd = dlarray(H2_pd);
    V1_pd = dlarray(V1_pd);V2_pd = dlarray(V2_pd);
    D1_pd = dlarray(D1_pd);D2_pd = dlarray(D2_pd);
    H1_mp = maxpool(H1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
    H2_mp = maxpool(H2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
    V1_mp = maxpool(V1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
    V2_mp = maxpool(V2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
    D1_mp = maxpool(D1_pd,wd_size,'Stride',1,'DataFormat','SSCB');%maxpooling
    D2_mp = maxpool(D2_pd,wd_size,'Stride',1,'DataFormat','SSCB');
    H1_mp = extractdata(H1_mp);H2_mp = extractdata(H2_mp);
    V1_mp = extractdata(V1_mp);V2_mp = extractdata(V2_mp);
    D1_mp = extractdata(D1_mp);D2_mp = extractdata(D2_mp);
    bdmH = H1_mp>H2_mp; % binary decision map(1 for fig1,0 for fig2)
    bdmV = V1_mp>V2_mp;
    bdmD = D1_mp>D2_mp;
    i = iterations;
    while i
    bdmH = bwmorph(bdmH,'majority');
    bdmV = bwmorph(bdmV,'majority');
    bdmD = bwmorph3(bdmD,'majority');
    i = i-1;
    end
    H = bdmH.*H1;
    H = H+~bdmH.*H2;
    V = bdmV.*V1;
    V = V+~bdmV.*V2;
    D = bdmD.*D1;
    D = D+~bdmD.*D2;
    fig = [fig,reshape(H,1,[]),reshape(V,1,[]),reshape(D,1,[])];
    end
    coef_fusion = fig;
    bdm = [];
end
end

%% inverse wavelet transform
fig = waverec2(coef_fusion,s,wname);


