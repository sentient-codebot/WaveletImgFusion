function mean_ssim = MSSIM (A,B,F,kwargs)
    arguments
        A
        B
        F
        kwargs.w (1,1) {mustBeInteger,mustBePositive} = 7
    end
    w = floor((kwargs.w-1)/2);
    if size(A,3) == 3
        A = rgb2gray(A);
        B = rgb2gray(B);
        F = rgb2gray(F);
    end
    sum_ssim = 0;
    window_count = 0;
    ROWNUM = size(A,1);
    COLNUM = size(A,2);
    for row = 1+w:w:ROWNUM-w
        for col = 1+w:w:COLNUM-w
            Aw = A(row:row+w,col:col+w);
            Bw = B(row:row+w,col:col+w);
            Fw = F(row:row+w,col:col+w);
            sum_ssim = sum_ssim + 

        end
    end
    