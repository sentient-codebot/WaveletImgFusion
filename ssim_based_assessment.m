function Qy = ssim_based_assessment(A,B,F)
% The closer the Q(x,y,f) value to 1, the higher the quality
% of the composite image is.
wd_size = 7;
total_pixel = size(A,1)*size(A,2);
A = padarray(A,[3,3]);%padding
B = padarray(B,[3,3]);
F = padarray(F,[3,3]);
Qy = 0;
for i = 1+3:size(A,2)-3
    for j = 1+3:size(A,1)-3
        Aw = A(j-3:j+3,i-3:i+3);
        Bw = B(j-3:j+3,i-3:i+3);
        Fw = F(j-3:j+3,i-3:i+3);
        lambda = var(Aw,0,'all')/(var(Aw,0,'all')+var(Bw,0,'all'));
        if ssim(Aw,Bw)>=0.75
            qy = lambda*ssim(Aw,Fw)+(1-lambda)*ssim(Bw,Fw);
        else
            qy = max(ssim(Aw,Fw),ssim(Bw,Fw));
        end
        Qy = Qy+qy;
        
    end
end
Qy = Qy/total_pixel;
        
     