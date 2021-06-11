function [Q_Y_bar,Q_Y] = SSIMF(A,B,F,kwargs)
% Q_Y = SSIMF(A,B,F) structural similarity based metric for fusion
% assessment
% kwargs.w --> w by w window
%
% RGB image is converted to grayscale for computation convenience
    arguments
        A
        B
        F
        kwargs.w (1,1) {mustBeInteger,mustBePositive} = 7
    end
    if size(A,3) == 3
        A = rgb2gray(A);
        B = rgb2gray(B);
        F = rgb2gray(F);
    end
    w=floor((kwargs.w-1)/2);
    A_pad = padarray(A,[w,w],0,'both');
    B_pad = padarray(B,[w,w],0,'both');
    F_pad = padarray(F,[w,w],0,'both');
    
    ROWNUM = size(A,1);
    COLNUM = size(A,2);
    Q_Y = zeros(ROWNUM,COLNUM);
    for row = 1:ROWNUM
        for col = 1:COLNUM
            Aw = A_pad(row:row+w,col:col+w);
            Bw = B_pad(row:row+w,col:col+w);
            Fw = F_pad(row:row+w,col:col+w);
            lambda_w = var(Aw(:))/(var(Aw(:))+var(Bw(:)));
            if ssim(Aw,Bw) >= 0.75
                Q_Y(row,col)=lambda_w*ssim(Aw,Fw)+(1-lambda_w)*ssim(Bw,Fw);
            else
                Q_Y(row,col)=max(ssim(Aw,Fw),ssim(Bw,Fw));
            end
        end
    end
    
    Q_Y_bar = mean(Q_Y,'all');
    
end







    