function joint_ent = JE(A,B)
    A=A(:);
    B=B(:);
    [N,Xedges,Yedges] = histcounts2(A,B);
    N = N(:);
    N = N(N~=0);
    N = N./size(A,1);
    joint_ent = -sum(N.*log2(N));
end
    
    