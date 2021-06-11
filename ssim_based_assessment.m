function Qy = ssim_based_assessment(A,B,F)
% The closer the Q(x,y,f) value to 1, the higher the quality
% of the composite image is.
wd_size = 7;
total_pixel = size(A,1)*size(A,2);
A = padarray(A,[(wd_size-1)/2,(wd_size-1)/2]);%padding
B = padarray(B,[(wd_size-1)/2,(wd_size-1)/2]);
F = padarray(F,[(wd_size-1)/2,(wd_size-1)/2]);
Qy = 0;
for i = 1+(wd_size-1)/2:size(A,2)-(wd_size-1)/2
    for j = 1+(wd_size-1)/2:size(A,1)-(wd_size-1)/2
        Aw = A(j-(wd_size-1)/2:j+(wd_size-1)/2,i-(wd_size-1)/2:i+(wd_size-1)/2);
        Bw = B(j-(wd_size-1)/2:j+(wd_size-1)/2,i-(wd_size-1)/2:i+(wd_size-1)/2);
        Fw = F(j-(wd_size-1)/2:j+(wd_size-1)/2,i-(wd_size-1)/2:i+(wd_size-1)/2);
        lambda = var(Aw,0,'all')/(var(Aw,0,'all')+var(Bw,0,'all'));
        if ssim(Aw,Bw)>=0.75
            qy = lambda*ssim(Aw,Fw)+(1-lambda)*ssim(Bw,Fw);
        else
            qy = max(ssim(Aw,Fw),ssim(Bw,Fw));
        end
        Qy = Qy+qy
        
    end
end
Qy = Qy/total_pixel;
        
     