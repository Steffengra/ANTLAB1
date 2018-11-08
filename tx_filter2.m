function s = tx_filter2(d, par_tx, switch_graph)
%upsample
for i = length(d):-1:1
    d = [d(1:i);zeros(par_tx-1,1);d(i+1:end)];
end

%create filter
fft_d = fft(d);
one = (length(fft_d)/par_tx/2);
disp(length(fft_d));
H = [ones(1, one), zeros(1, length(fft_d)-2*one), ones(1, one)]';
%H = [ones(1, floor(length(fft_d)/par_tx))];
%H = [H, zeros(1, length(fft_d)-length(H))]';

%apply filter
S = fft_d .* H;

subplot(3, 1, 1);
plot(abs(fft_d));
subplot(3, 1, 2);
plot(H);
subplot(3, 1, 3);
plot(abs(fftshift(S)));

s = ifft(S);

if switch_graph == 1
   subplot(2,1,1);
   plot(real(s));
   subplot(2,1,2);
   plot(imag(s));
end