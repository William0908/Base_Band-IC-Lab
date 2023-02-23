clear,clc,close all

u1 = 0.1;
u2 = 0.3;
u3 = 0.5;

x = -50*ones(20, 1);
for i = 2:20
    x(i) = x(i-1) + 5*randi([0,3],1,1);
    if(x(i) > 120) 
        x(i) = x(i-1);
    end
end

for i = 1:19
    y1(i) = x(i) +u1*(x(i + 1) - x(i));
    y2(i) = x(i) +u2*(x(i + 1) - x(i));
    y3(i) = x(i) +u3*(x(i + 1) - x(i));
end

x_1 = dec2bin(x);
x_bin = str2num(x_1);

% fid = fopen('./linear_u3_bin.txt', 'w');
% fprintf(fid, '%08d\n', x_bin);
% fclose(fid);
% fid = fopen('./linear_u3_20.txt', 'w');
% fprintf(fid, '%d\n', x);
% fclose(fid);
% fid = fopen('./linear_u3_out.txt', 'w');
% fprintf(fid, '%f\n', y3');
% fclose(fid);

% plot(x);
% hold on;
% plot(y);
% hold off;

u1b = dec2bin(u1*32);
u2b = dec2bin(u2*32);
u3b = dec2bin(u3*32);

tpo = dlmread('./tpo_u3_out.txt');
tpo = tpo/32;

% Timing offset simulation
I = dlmread('D:/William/Course/Base_Band/Lab02/Matlab/I_1024_bin.txt', 'w');
Q = dlmread('D:/William/Course/Base_Band/Lab02/Matlab/Q_1024_bin.txt', 'w');
tpo_out = dlmread('D:/William/Course/Base_Band/Lab05/Matlab/tpo_u1_out.txt');

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

% subplot(2,1,1);
% plot(I(1:50));
% subplot(2,1,2);
% plot(Q(1:50));

for i = 1:1023
    I_t1(i) = I(i) +u1*(I(i + 1) - I(i));
    Q_t1(i) = Q(i) +u1*(Q(i + 1) - Q(i));
    I_t2(i) = I(i) +u2*(I(i + 1) - I(i));
    Q_t2(i) = Q(i) +u2*(Q(i + 1) - Q(i));
    I_t3(i) = I(i) +u3*(I(i + 1) - I(i));
    Q_t3(i) = Q(i) +u3*(Q(i + 1) - Q(i));
end

subplot(2,3,1);
plot(I(1:50));
hold on;
plot(I_t1(1:50));
hold off;
title('I: 0.1');

subplot(2,3,2);
plot(I(1:50));
hold on;
plot(I_t2(1:50));
hold off;
title('I: 0.3');

subplot(2,3,3);
plot(I(1:50));
hold on;
plot(I_t3(1:50));
hold off;
title('I: 0.5');

subplot(2,3,4);
plot(Q(1:50));
hold on;
plot(Q_t1(1:50));
hold off;
title('Q: 0.1');

subplot(2,3,5);
plot(Q(1:50));
hold on;
plot(Q_t2(1:50));
hold off;
title('Q: 0.3');

subplot(2,3,6);
plot(Q(1:50));
hold on;
plot(Q_t3(1:50));
hold off;
title('Q: 0.5');

