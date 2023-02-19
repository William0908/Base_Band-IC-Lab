clear;

%/=============================================
% Generate random bitstream 
din = randi([0, 1], 1024, 1);
% fid = fopen('./data_in_1024_bin.txt', 'w');
% fprintf(fid, '%d\n', din);
% fclose(fid);

%/=============================================
% Part A: S/P Converter
% fid = fopen('./golden_1024_bin.txt', 'w');
% fprintf(fid, '%d%d\n', din);
% fclose(fid);

%/=============================================
% Part B: Signal Mapping
data_read = dlmread('golden_1024_bin.txt');
for i = 1:512
    if(data_read(i) == 00)
        I(i) = 01;
        Q(i) = 01;
    elseif(data_read(i) == 01)
        I(i) = 01;
        Q(i) = 11;
    elseif(data_read(i) == 10)
        I(i) = 11;
        Q(i) = 01;
    elseif(data_read(i) == 11)
        I(i) = 11;
        Q(i) = 11;
    end
end

% fid = fopen('./I_512_bin.txt', 'w');
% fprintf(fid, '%02d\n', I');
% fclose(fid);
% fid2 = fopen('./Q_512_bin.txt', 'w');
% fprintf(fid2, '%02d\n', Q'); 
% fclose(fid2);

%/=============================================
% Part C: Up Sampling Interpolator
up_sample = zeros(2048, 2);
up_sample(1, 1) = I(1);
up_sample(1, 2) = Q(1);
for i = 2:512
    up_sample(i+3*(i-1), 1) = I(i);
    up_sample(i+3*(i-1), 2) = Q(i);
end

% fid = fopen('./I_up_2048_bin.txt', 'w');
% fprintf(fid, '%02d\n', up_sample(:,1));
% fclose(fid);
% fid2 = fopen('./Q_up_2048_bin.txt', 'w');
% fprintf(fid2, '%02d\n', up_sample(:,2));
% fclose(fid2);

%/=============================================
% Part D: SRRC
srrc = srrcf(4, 4, 0.495);
srrc_16 = srrc*16384;
srrc_round = round(srrc_16, 0);
srrc_bin = dec2bin(srrc_round, 16);
% fid = fopen('srrc_float.txt', 'w');
% fprintf(fid, '%f\n', srrc);
% fclose(fid);
% fid2 = fopen('srrc_bin.txt', 'w');
% fprintf(fid2, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', srrc_bin');
% fclose(fid2);

% SRRC sprectrum
for i = 1:2048
    for j = 1:2
        if(up_sample(i,j) == 11)
            up_sample(i,j) = -1;
        end
    end
end

srrc_I = conv(up_sample(:,1),srrc);
srrc_Q = conv(up_sample(:,2),srrc);

[Pxx1, f1] = pwelch(srrc_I);
[Pxx2, f2] = pwelch(srrc_Q);

srrc_v = dlmread('srrc_out_1024_dec_I.txt');
srrc_norm = srrc_v/16384;

for i=1:2048
    if(srrc_norm(i) > 8)
        srrc_norm(i) = srrc_norm(i) - 16;
    end
end

[Pxx3, f3] = pwelch(srrc_norm);

% subplot(3,1,1);
% plot(up_sample(:,1));
% title('Input data');
% subplot(3,1,2);
% plot(f2, 10*log10(Pxx2));
% title('Convolution');
% subplot(3,1,3);
% plot(f3, 10*log10(Pxx3));
% title('SRRC');

% Part E: DDFS Mixer
txf_now = 0;
tx_carrier_freq = pi/2;

for i = 1:2048
    IFout(i) = srrc_I(i)*cos(txf_now) - srrc_Q(i)*sin(txf_now);
    txf_now = txf_now + tx_carrier_freq;
end

IFout = IFout';

[Pxx4, f4] = pwelch(IFout);

% IFout_v = dlmread('DDFS_out_dec.txt', 'r');
IFout_v = dlmread('IFout_dec.txt', 'r');
IFout_v = IFout_v/16384;
[Pxx5, f5] = pwelch(IFout_v);

% subplot(3,1,1);
% plot(IFout_v);
% title('Time domain');
% subplot(3,1,2);
% plot(f4, 10*log10(Pxx4));
% title('Matlab Spectrum');
% subplot(3,1,3);
% plot(f5, 10*log10(Pxx5));
% title('Verilog Implementation');

% plot(f4, 10*log10(Pxx4));
% hold on;
% plot(f5, 10*log10(Pxx5));
% hold off;

subplot(3,1,1);
plot(up_sample(:,1));
title('Input signal');
subplot(3,1,2);
plot(f1, 10*log(Pxx1));
title('Matlab Spectrum (dB)');
subplot(3,1,3);
plot(f3, 10*log(Pxx3));
title('Verilog Spectrum (dB)');

error = (sum(srrc,'all')-sum(IFout_v,'all'))/sum(srrc,'all');



       