function d_tilde = rx_filter(s_tilde, par_rx_w, switch_graph)
%missing switch_graph
%lowpass-filter to remove artifacts, flips spectrum a 2nd time
%create filter
lg = length(s_tilde);
x = linspace(-lg/2, lg/2, lg);
f = linspace(0, 1, lg);
B = 1/par_rx_w;
h = B*sinc(B*x);

%apply filter
d_tilde = conv(h, s_tilde, 'same')';


%downsample
d_tilde = d_tilde(1:par_rx_w:end);

%plots
% fft_s_tilde = fftshift(fft(s_tilde));
% fft_h = fftshift(fft(h));
% fft_d_tilde = fftshift(fft(d_tilde));
% subplot(3, 1, 1);
% plot(f, abs(fft_s_tilde));
% subplot(3, 1, 2);
% plot(f, abs(fft_h));
% subplot(3, 1, 3);
% plot(abs(fft_d_tilde));