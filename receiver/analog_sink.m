function [MSE, BER_final, BER_coded, BER_decoded] = analog_sink(a, a_tilde, u, u_hat, c_total, c_hat, b, b_hat)
limit = floor(.8 * length(a_tilde));        % workaround because bits are stuck in buffer
MSE = (sum(abs(a(1:limit) - a_tilde(1:limit))) / limit) ^ 2; % squared error

limit = floor(.8 * length(u));  % workaround because bits are stuck in buffer
size_signal = size(u(1:limit,:));
size_signal = size_signal(1) * size_signal(2); % total amount of bits
BER_final = sum(sum(abs(u(1:limit,:) - u_hat(1:limit,:)))) / size_signal; % linear error after full transmission

limit = floor(.8 * length(c_total));
BER_coded = sum(abs(c_total(1:limit)-c_hat(1:limit))) / limit;            % linear error 7 bits

limit = floor(.8 * length(b));
BER_decoded = sum(abs(b(1:limit)-b_hat(1:limit))) / limit;                % linear error 4 bits, after error correction