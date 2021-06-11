function M_out = dot_prod(arr_1,arr_2)
    arguments
        arr_1 (:,:,:)
        arr_2 (:,:,:)
    end
    outsize = size(arr_1);
    outsize = outsize(1:2);
    M_out = zeros(outsize);
    for channel = 1:size(arr_1,3)
        M_out = M_out + arr_1(:,:,channel).*arr_2(:,:,channel);
    end
end