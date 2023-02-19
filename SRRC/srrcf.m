function srrcc=srrcf(intp_num, symbol_interval, r)
%
% Ex: impulse response interval: -4T...4T, 4 pts per symbol because of 
% assuming 4 times oversampling implementation, total (4*4)*2+1=33 taps
%
%  input:  intp_num - the resolution points used between two symbols in the Nyq filter
%          symbol_interval - the span of the Nyquist filter
%          r - rolloff factor ( 0 < r < 1 )
%  output: srrcc - square root raised cosine filter coefficients
%

tap=2*symbol_interval*intp_num+1;
ti=-symbol_interval:1/intp_num:symbol_interval;

for i=1:tap
    t=ti(i);
    if t==0
       srrcc(i)=1-r+4*r/pi;
    elseif abs(t)==1/r
       srrcc(i)=r/sqrt(2)*((1+2/pi)*sin(pi/4/r)+(1-2/pi)*cos(pi/4/r));
    else      
       srrcc(i)=(sin(pi*t*(1-r))+4*r*t*cos(pi*t*(1+r)))/(pi*t*(1-(4*r*t)^2));
    end
end

end
