function F = gff(I1, I2, kwargs)
%GFF Guided filtering based image Fusion
%   gff(I1, I2) fuses image I1 and I2 and return the fused one image F. I1
%   and I2 are required to be of the same size. 
%   
%   gff(I1, I2,...
%       'r1', r1,...
%       'eps1',eps1,...
%       'r2', r2,...
%       'eps2',eps2,
%       'rg',rg,...
%       'sigg',sigg) takes optional name-value pair arguments. r1, eps1,
%       r2, eps2 are parameters of the guided filters. rg and sigg are
%       parameters of the the Gaussian low-pass filter used in the saliency
%       measure. 
%       
%   author: sentient-robot
%   date: Jun-04-2021
%   address: Technische Universiteit Delft
%

    arguments
        I1 (:,:,:) 
        I2 (:,:,:)
        kwargs.r1 (1,1) {mustBeInteger, mustBePositive} = 3
        kwargs.eps1 (1,1) {mustBePositive} = 0.05
        kwargs.r2 (1,1) {mustBeInteger, mustBePositive} = 1
        kwargs.eps2 (1,1) {mustBePositive} = 0.005
        kwargs.rg (1,1) {mustBeInteger, mustBePositive} = 5
        kwargs.sigg {mustBePositive} = 5
        kwargs.s (1,1) {mustBeInteger,mustBePositive} = 1
    end
    r1 = kwargs.r1;
    eps1 = kwargs.eps1;
    r2 = kwargs.r2;
    eps2 = kwargs.eps2;
    rg = kwargs.rg;
    sigg = kwargs.sigg;
            
    
    %% step 1 two-scale decomposition - 8-neighbor averaging
    avg_kernel = ones(10,10)/100; % the filter size is deputable
    B1 = zeros(size(I1));
    B2 = B1;
    for channel = 1:size(I1,3)
        B1(:,:,channel) = conv2(I1(:,:,channel),avg_kernel,'same');
        B2(:,:,channel) = conv2(I2(:,:,channel),avg_kernel,'same');
    end
    D1 = I1 - B1;
    D2 = I2 - B2;

    %% step 2 weigh map construciton
    % saliency measure
    laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];
    H1 = zeros(size(I1));
    H2 = H1;
    for channel = 1:size(I1,3)
        H1(:,:,channel) = conv2(I1(:,:,channel), laplacian_kernel,'same');
        H2(:,:,channel) = conv2(I2(:,:,channel), laplacian_kernel,'same');
    end
    gaussian_kernel = zeros(2*rg+1, 2*rg+1);
    for x = -rg:rg
        for y = -rg:rg
            gaussian_kernel(y+rg+1,x+rg+1) = 1/(2*pi*rg^2)*exp(-(x^2+y^2)/(2*rg^2));
        end
    end
    S1 = zeros(size(H1));
    S2 = S1;
    for channel = 1:size(I1,3)
        S1(:,:,channel) = conv2(abs(H1(:,:,channel)),gaussian_kernel,'same');
        S2(:,:,channel) = conv2(abs(H2(:,:,channel)),gaussian_kernel,'same');
    end
    P1 = S1 == max(S1,S2);
    P2 = S2 == max(S1,S2);
    
    WB1 = fast_guided_filter(P1, I1, 'r', r1, 'eps', eps1,...
        's',kwargs.s);  % big r, big eps(?)
    WD1 = fast_guided_filter(P1, I1, 'r', r2, 'eps', eps2,...
        's',kwargs.s);  % small r, small eps(?)
    
    WB2 = fast_guided_filter(P2, I2, 'r', r1, 'eps', eps1,...
        's',kwargs.s);
    WD2 = fast_guided_filter(P2, I2, 'r', r2, 'eps', eps2,...
        's',kwargs.s);
    
    WB_sum = WB1 + WB2;
    WD_sum = WD1 + WD2;
    
    
    B_bar = (WB1.*B1+WB2.*B2)./WB_sum;
    D_bar = (WD1.*D1+WD2.*D2)./WD_sum;
    
    F = B_bar + D_bar;
    
end







