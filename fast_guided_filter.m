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
    A_bar_rgb = zeros(size(I));
    B_bar_rgb = zeros(size(I));
    O = zeros(size(I));
    
    %% subsampling    
    img_size = size(I);
    img_size = img_size(1:2);
    if s>1
        [X,Y] = meshgrid(1:img_size(2),1:img_size(1));
        [X_sub,Y_sub] = meshgrid(...
            linspace(1,img_size(2),floor(img_size(2)/s)),...
            linspace(1,img_size(1),floor(img_size(1)/s)));
        for channel = 1:size(I,3)
            I_sub_rgb(:,:,channel) = interp2(X,Y,I(:,:,channel),X_sub,Y_sub,SubMethod);
            P_sub_rgb(:,:,channel) = interp2(X,Y,P(:,:,channel),X_sub,Y_sub,SubMethod);
        end
        r_sub = floor(r/s);
    else
        I_sub_rgb = I;
        P_sub_rgb = P;
        r_sub = r;
    end

    %% coefficients & output
    for channel_P = 1:size(I,3)
        P_sub = P_sub_rgb(:,:,channel_P);
        mean_P = img_avg(P_sub,r_sub);
        for channel_I = 1:size(I,3)
            I_sub = I_sub_rgb(:,:,channel_I);
            
            mean_I = img_avg(I_sub,r_sub);
            corr_I = img_avg(I_sub.*I_sub,r_sub);
            corr_IP = img_avg(I_sub.*P_sub,r_sub);

            var_I = corr_I - mean_I.*mean_I;
            cov_IP = corr_IP - mean_I.*mean_P;

            A = cov_IP./(var_I+eps);
            A_rgb(:,:,channel_I) = A;
            mean_I_rgb(:,:,channel_I) = mean_I;

            A_bar = img_avg(A,r);
            if s>1
                A_bar = interp2(X_sub,Y_sub,A_bar,X,Y,UpMethod);
            end
            A_bar_rgb(:,:,channel_I) = A_bar;
        end
        B = mean_P - dot_prod(A_rgb,mean_I_rgb);
        B_bar = img_avg(B,r);
        if s>1
            B_bar = interp2(X_sub,Y_sub,B_bar,X,Y,UpMethod);
        end
        % output
        O(:,:,channel_P) = dot_prod(A_bar,I)+B_bar;
    end
    
end









