clear,clc,close all

B = [1 0 0 0 0.316 0 0 0 0 0.5 0 0 0 0.01];
A = [1 0 0 0 0 0 0 0 0 0 0 0 0 0];
% freqz(B, A);

c = [1 0.316 0.5 0.01];
c = c*1024;
c_bin = dec2bin(c);

IFout_v = dlmread('D:/William/Course/Base_Band/Lab02/Matlab/IFout_dec.txt', 'r');
IFout_v = IFout_v/16384;
[pxx1, f1] = pwelch(IFout_v);

mpc = dlmread('D:/William/Course/Base_Band/Lab04/Matlab/mpc_out.txt', 'r');
mpc_v = mpc/(16384*1024);

[pxx2, f2] = pwelch(mpc_v);

subplot(2,1,1);
plot(f1, 10*log(pxx1));
title('QAM');
subplot(2,1,2);
plot(f2, 10*log(pxx2));
title('Multi-path Channel');