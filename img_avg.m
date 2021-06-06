function mean_img = img_avg(img, r)
% img_avt(img, r) do local average with a (2*r+1)*(2*r+1) kernel with no
% padding

    arguments 
        img
        r
    end
    img_size = size(img);
    avg_kernel = ones(2*r+1,2*r+1)/(2*r+1)^2;
    mean_img = conv2(img, avg_kernel, 'same');
    
    for row = 1:img_size(1)
        for col = 1:img_size(2)
            if (row>=r+1)&&(row<=img_size(1)-r)&&...
                    (col>=r+1)&&(col<=img_size(2)-r)
                continue
            end
            left = max(1,col-r);
            right = min(img_size(2),col+r);
            top = max(1,row-r);
            bottom = min(img_size(1),row+r);
            mean_img(row,col) = mean(img(top:bottom,left:right),'all');
        end
    end
    
    
end


