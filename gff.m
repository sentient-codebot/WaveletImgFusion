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
        I1 (:,:) 
        I2 (:,:)
        kwargs.r1
        kwargs.eps1
        kwargs.r2
        kwargs.eps2
        kwargs.rg (1,1) {mustBeInteger, mustBePositive} = 5
        kwargs.sigg {mustBePositive} = 5
    end
    
    %% step 1 two-scale decomposition - 8-neighbor averaging
    avg_kernel = ones(3,3)/9; % the filter size is deputable
    B1 = conv2(I1,avg_kernel,'same');
    B2 = conv2(I2,avg_kernel,'same');
    D1 = I1 - B1;
    D2 = I2 - B2;

    %% step 2 weigh map construciton
    % saliency measure
    laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];
    H1 = conv2(I1, laplacian_kernel,'same');
    H2 = conv2(I2, laplacian_kernel,'same');
    gaussian_kernel = zeros(2*rg+1, 2*rg+1);
    for x = -rg:rg
        for y = -rg:rg
            gaussian_kernel(y+rg+1,x+rg+1) = 1/(2*pi*rg^2)*exp(-(x^2+y^2)/(2*rg^2));
        end
    end
    S1 = conv2(abs(H1),gaussian_kernel,'same');
    S2 = conv2(abs(H2),gaussian_kernel,'same');
    P1 = S1 == max(S1,S2);
    P2 = S2 == max(S1,S2);
    
    
    
    
    
    
    
    
    
    
    
    
end

