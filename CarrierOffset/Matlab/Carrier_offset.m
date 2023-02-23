clear,clc,close all

% Parameter
N = 1024;
width = log2(N);

% Sine
sin_temp = sin((([0:N-1])*2*pi/N) + (pi/4));
sin_digital = round(sin_temp'*4*width);

%Cosine
cos_temp = cos((([0:N-1])*2*pi/N) + (pi/4));
cos_digital = round(cos_temp'*4*width);

[pxx, f] = pwelch(sin_digital);
[pxx2, f2] = pwelch(cos_digital);

plot(sin_digital);
hold on;
plot(cos_digital);
hold off;

% fid_sin = fopen('./sin_dec.coe', 'w');
% fprintf(fid_sin, 'MEMORY_INITIALIZATION_RADIX=10;\n');
% fprintf(fid_sin, 'MEMORY_INITIALIZATION_VECTOR=\n');
% fprintf(fid_sin, '%d,\n', sin_digital(1:1023));
% fprintf(fid_sin, '%d;', sin_digital(1024));
% fclose(fid_sin);
% 
% fid_cos = fopen('./cos_dec.coe', 'w');
% fprintf(fid_sin, 'MEMORY_INITIALIZATION_RADIX=10;\n');
% fprintf(fid_sin, 'MEMORY_INITIALIZATION_VECTOR=\n');
% fprintf(fid_cos, '%d,\n', cos_digital(1:1023));
% fprintf(fid_cos, '%d;', cos_digital(1024));
% fclose(fid_cos);

%Carrier Offset
I = dlmread('D:/William/Course/Base_Band/Lab02/Matlab/I_1024_bin.txt', 'w');
Q = dlmread('D:/William/Course/Base_Band/Lab02/Matlab/Q_1024_bin.txt', 'w');

for i = 1:1024
    if(I(i) == 11)
        I(i) = -1;
    end
end

for i = 1:1024
    if(Q(i) == 11)
        Q(i) = -1;
    end
end

for i = 1:1024
    I_rotate(i) = I(i)*(cos_digital(i)/4096) - Q(i)*(sin_digital(i)/4096);
    Q_rotate(i) = I(i)*(sin_digital(i)/4096) + Q(i)*(cos_digital(i)/4096);
end
I_ro = dec2bin(I_rotate);
Q_ro = dec2bin(Q_rotate);

for i = 1:1024
    if(I_ro(i, 1) == '1')
        Ir(i, 1:6) = '1';
    else 
        Ir(i, 1:6) = '0';
    end
end

for i = 1:1024
    if(Q_ro(i, 1) == '1')
        Qr(i, 1:6) = '1';
    else 
        Qr(i, 1:6) = '0';
    end
end

I_bin = str2num([Ir, I_ro]);
Q_bin = str2num([Qr, Q_ro]);

% fid = fopen('./I_rotate_dec.txt', 'w');
% fprintf(fid, '%d\n', I_rotate');
% fclose(fid);
% fid = fopen('./I_rotate_bin.txt', 'w');
% fprintf(fid, '%014d\n', I_bin);
% fclose(fid);
% fid2 = fopen('./Q_rotate_dec.txt', 'w');
% fprintf(fid2, '%d\n', Q_rotate);
% fclose(fid2);
% fid2 = fopen('./Q_rotate_bin.txt', 'w');
% fprintf(fid2, '%014d\n', Q_bin);
% fclose(fid2);

% Carrier offset simulation
[pxx3, f3] = pwelch(I);
[pxx4, f4] = pwelch(Q);
[pxx5, f5] = pwelch(I_rotate);
[pxx6, f6] = pwelch(Q_rotate);

% subplot(4,1,1);
% plot(f3, 10*log(pxx3));
% title('Baseband I');
% subplot(4,1,2);
% plot(f4, 10*log(pxx4));
% title('Baseband Q');
% subplot(4,1,3);
% plot(f5, 10*log(pxx5));
% title('Rotated I');
% subplot(4,1,4);
% plot(f6, 10*log(pxx6));
% title('Rotated Q');


