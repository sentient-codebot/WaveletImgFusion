% guided filtering based fusion (GFF) with diff parameters (r1)


%% load image
fig_origin1 = imread("source22_1.tif");
fig_origin2 = imread("source22_2.tif");
fig_origin1 = im2single(fig_origin1);fig_origin2 = im2single(fig_origin2);

%% transforms
figs_r1 = {};
r1s = 25:10:45;
num_figs = length(r1s);
for fig_count = 1:num_figs
    r1 = r1s(fig_count);
    fig = gff(fig_origin1,fig_origin2,...
        'rg',31,...
        'r1',r1,...
        'eps1',0.3,...
        'r2',7,...
        'eps2',1e-6);
    figs_r1{fig_count} = fig;
end

%% display result
figure
for fig_count = 1:num_figs
    subplot(2,floor(num_figs/2)+1,fig_count)
    imshow(figs_r1{fig_count})
    xlabel(r1s(fig_count))
end

%% RESULT

% no much diff