function s = tx_filter(d, par_tx, switch_graph)
%flips spectrum, but itll be flipped again on rx_filter
%upsample
d_upsampled = d;
for i = length(d):-1:1
    d_upsampled = [d_upsampled(1:i);zeros(par_tx-1,1);d_upsampled(i+1:end)];
end

f = [1/par_tx-0.005 1/par_tx+0.005];
a = [1 0];
rp = .0025;             % Passband ripple
rs = 50;                % Stopband ripple
dev = [(10^(rp/20)-1)/(10^(rp/20)+1) 10^(-rs/20)];

[n, fo, ao, w] = firpmord(f, a, dev);
h = firpm(n, fo, ao, w);


s = filtfilt(h, 1, d_upsampled);
s = s * 0.55 * (par_tx) ;  % add gain to filter to keep amplitude normal. amplitude normal at factor s, but due to hardware thresholding we need to add some of the gain after transmission

%plots
% figure;
% fft_d = fft(d_upsampled);
% fft_h = (fft(h));
% fft_s = fftshift(fft(s));
% 
% subplot(3, 1, 1);
% plot(0:length(fft_d)-1, abs(fft_d));
% xlim([0 length(fft_d)-1])
% subplot(3, 1, 2);
% plot(abs(fft_h));
% subplot(3, 1, 3);
% plot(abs(fft_s));
% 
% figure;
% subplot(2, 1, 1);
% plot(abs(d));
% subplot(2,1,2);
% plot(abs(s));

if switch_graph == 1
   freqz(h);
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