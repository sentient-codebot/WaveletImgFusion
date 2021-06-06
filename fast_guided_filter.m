function O = fast_guided_filter(P, I, kwargs)
    arguments
        P
        I % must be of same size
        kwargs.r (1,1) {mustBeInteger,mustBeNonnegative} = 1
        kwargs.eps (1,1) {mustBeNonnegative} = 0.001
        kwargs.s (1,1) {mustBeInteger,mustBePositive} = 2
        kwargs.SubMethod (1,1) string = 'nearest'
        kwargs.UpMethod (1,1) string = 'cubic'
    end
    r = kwargs.r;
    eps = kwargs.eps;
    s = kwargs.s;
    SubMethod = kwargs.SubMethod;
    UpMethod = kwargs.UpMethod;
    
    img_size = size(I);
    if s>1
        [X,Y] = meshgrid(1:img_size(2),1:img_size(1));
        [X_sub,Y_sub] = meshgrid(1:s:img_size(2),1:s:img_size(1));
        I_sub = interp2(X,Y,I,X_sub,Y_sub,SubMethod);
        P_sub = interp2(X,Y,P,X_sub,Y_sub,SubMethod);
        r_sub = floor(r/s);
    else
        I_sub = I;
        P_sub = P;
        r_sub = r;
    end
    
    % coefficients
    mean_I = img_avg(I_sub,r_sub);
    mean_P = img_avg(P_sub,r_sub);
    corr_I = img_avg(I_sub.*I_sub,r_sub);
    corr_IP = img_avg(I_sub.*P_sub,r_sub);
    
    var_I = corr_I - mean_I.*mean_I;
    cov_IP = corr_IP - mean_I.*mean_P;
    
    A = cov_IP./(var_I+eps);
    B = mean_P - A.*mean_I;
    
    A_bar = img_avg(A,r);
    B_bar = img_avg(B,r);
    if s>1
        A_bar = interp2(X_sub,Y_sub,A_bar,X,Y,UpMethod);
        B_bar = interp2(X_sub,Y_sub,B_bar,X,Y,UpMethod);
    end
    % output
    O = A_bar.*I + B_bar;
    
    
end









