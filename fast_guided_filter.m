function O = fast_guided_filter(P, I, kwargs)
    arguments
        P
        I % must be of same size
        kwargs.r (1,1) {mustBeInteger,mustBeNonnegative} = 1
        kwargs.eps (1,1) {mustBeNonnegative} = 0.001
    end
    r = kwargs.r;
    eps = kwargs.eps;
    win_size = (2*r+1); % window: size x size
    input_size = size(P);
    
    % coefficients
    mean_I = img_avg(I,r);
    mean_P = img_avg(P,r);
    corr_I = img_avg(I.*I,r);
    corr_IP = img_avg(I.*P,r);
    
    var_I = corr_I - mean_I.*mean_I;
    cov_IP = corr_IP - mean_I.*mean_P;
    
    A = cov_IP./(var_I+eps);
    B = mean_P - A.*mean_I;
    
    A_bar = img_avg(A,r);
    B_bar = img_avg(B,r);
    
    % output
    O = A_bar.*I + B_bar;
    
    
end









