function [MSE, BER] = analog_sink(a, a_tilde, u, u_hat)
limit = floor(.8 * length(a_tilde));
MSE = (sum(abs(a(1:limit) - a_tilde(1:limit))) / limit) ^ 2;

limit = floor(.8 * length(u));
size_signal = size(u(1:limit,:));
size_signal = size_signal(1) * size_signal(2);
BER = sum(sum(abs(u(1:limit,:) - u_hat(1:limit,:)))) / size_signal;