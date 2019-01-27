function d_tilde = rx_filter(s_tilde, par_rx_w, switch_graph)

%design filter---------------
rp = .0025;                                         % Passband ripple
rs = 50;                                            % Stopband ripple
f = [1/par_rx_w-0.005 1/par_rx_w+0.005];            % Cutoff frequencies
a = [1 0];                                          % Desired amplitudes
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; % Ripple dB <> linear

[n, fo, ao, w] = firpmord(f, a, dev);               % Determine min filter order for specs
h = firpm(n, fo, ao, w);                            % Get filter transfer function
%----------------------------

d_tilde = filtfilt(h, 1, s_tilde);                  % Apply filter


%plots
% figure;
% fft_d = fft(s_tilde);
% fft_h = (fft(h));
% fft_s = fftshift(fft(d_tilde));
% 
% subplot(3, 1, 1);
% plot(abs(fft_d));
% subplot(3, 1, 2);
% plot(abs(fft_h));
% subplot(3, 1, 3);
% plot(abs(fft_s));


%downsample
d_tilde = d_tilde(1:par_rx_w:end);

if switch_graph == 1
   figure;
   subplot(2,1,1);
   plot(real(d_tilde));
   title('real part of filtered signal');
   ylabel('value');
   subplot(2,1,2);
   plot(imag(d_tilde));
   title('imaginary part of filtered signal');
   xlabel('samples')
   ylabel('value');
   
   
   eyediagram(d_tilde, 4);
end