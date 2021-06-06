function O = guided_filter(P, I, kwargs)
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
    
    % padding
    padded_P = zeros(input_size(1)+2*r, input_size(2)+2*r);
    padded_I = zeros(input_size(1)+2*r, input_size(2)+2*r);
    padded_P(r+1:end-r,r+1:end-r) = P;
    P = padded_P;
    padded_I(r+1:end-r,r+1:end-r) = I;
    I = padded_I;
    
    % coefficients
    A = zeros(input_size);
    B = zeros(input_size);
    for row = r+1:r+input_size(1)
        for col = r+1:r+input_size(2)
            local_I = I(row-r:row+r,col-r:col+r);
            local_P = P(row-r:row+r,col-r:col+r);
            mu_I = mean(local_I(:));
            delta_I = var(local_I(:));
            mu_P = mean(local_P(:));
            
            A(row-r,col-r) = (1/win_size^2*sum(local_I.*local_P,'all') - mu_I*mu_P)/(delta_I+eps);
            B(row-r,col-r) = mu_P - A(row-r,col-r)*mu_I;
        end
    end
    
    A_bar = conv2(A, 1/(win_size)^2*ones(win_size,win_size), 'same');
    B_bar = conv2(B, 1/(win_size)^2*ones(win_size,win_size), 'same');
    for row = [1:r,input_size(1)-r+1:input_size(1)]
        for col = [1:r,input_size(2)-r+1:input_size(2)]
            left = max(1,col-r);
            right = min(input_size(2),col+r);
            top = max(1,row-r);
            bottom = min(input_size(1),row+r);
            A_bar(row,col) = mean(A(top:bottom,left:right),'all');
            B_bar(row,col) = mean(B(top:bottom,left:right),'all');
        end
    end
    
    % output
    O = A_bar.*I(r+1:end-r,r+1:end-r) + B_bar;
    
    
end









