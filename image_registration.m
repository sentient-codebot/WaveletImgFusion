[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-3;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

fig_origin_ref = rgb2gray(fig_origin1);
fig_origin3 = zeros(size(fig_origin1));
tform = imregtform(rgb2gray(fig_origin2),fig_origin_ref,...
    'rigid',...
    optimizer,...
    metric);
for channel = 1:size(fig_origin1,3)
    fig_origin3(:,:,channel) = imwarp(fig_origin2(:,:,channel),tform,...
        'OutputView',...
        imref2d(size(fig_origin_ref)));
end