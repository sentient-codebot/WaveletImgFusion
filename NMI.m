function Q_MI = NMI(A,B,F)
%Q_MI = NMI(A,B,F) normalized mutual information
    HA = JE(A,A);
    HB = JE(B,B);
    HF = JE(F,F);
    MIAF = HA + HF - JE(A,F);
    MIBF = HB + HF - JE(B,F);
    Q_MI = 2*(MIAF/(HA+HF)+MIBF/(HB+HF));
    
end