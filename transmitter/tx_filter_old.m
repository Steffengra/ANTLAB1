function s = tx_filter(d, par_tx, switch_graph)
%flips spectrum, but itll be flipped again on rx_filter
%upsample
for i = length(d):-1:1
    d = [d(1:i);zeros(par_tx-1,1);d(i+1:end)];
end

%create filter
lg = length(d); %same length
x = linspace(-lg/2, lg/2, lg); %time vector
f = linspace(0, 1, lg); %freq vector
B = 1/par_tx; %normalization factor
h = B*sinc(B*x); %filter function in time domain

%apply filter
s = conv(h, d, 'same')';

% % %plots
% figure;
% fft_d = fft(d);
% fft_h = (fft(h));
% fft_s = fftshift(fft(s));
% 
% subplot(3, 1, 1);
% plot(f, abs(fft_d));
% subplot(3, 1, 2);
% plot(f, abs(fft_h));
% subplot(3, 1, 3);
% plot(abs(fft_s));

if switch_graph == 1
   figure;
   subplot(2,1,1);
   plot(real(s));
   title('real part of filtered signal');
   ylabel('value');
   subplot(2,1,2);
   plot(imag(s));
   title('imaginary part of filtered signal');
   xlabel('samples')
   ylabel('value');
end