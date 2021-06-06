% guided filtering based fusion (GFF) with diff parameters (rg)


%% load image
fig_origin1 = imread("source22_1.tif");
fig_origin2 = imread("source22_2.tif");
fig_origin1 = im2single(fig_origin1);fig_origin2 = im2single(fig_origin2);

%% transforms
figs_rg = {};
rgs = 5:3:25;
num_figs = length(rgs);
for fig_count = 1:num_figs
    rg = rgs(fig_count);
    fig = gff(fig_origin1,fig_origin2,...
        'rg',rg);
    figs_rg{fig_count} = fig;
end

%% display result
figure
for fig_count = 1:num_figs
    subplot(2,floor(num_figs/2)+1,fig_count)
    imshow(figs_rg{fig_count})
    xlabel(rgs(fig_count))
end

%% RESULT
% rg better be larger, 20~30