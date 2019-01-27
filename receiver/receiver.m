%fix filter clipping

% s_tilde = y;
% d_tilde = s_tilde;
s_tilde = rx_hardware(y, 1, switch_graph);
d_tilde = rx_filter(s_tilde, 8, switch_graph);
c_hat = demodulation(d_tilde, par_qampsk, switch_graph);
b_hat = channel_decoding(c_hat, H, 0);
b_hat_buf = rx_fifo(b_hat, 10000, code_lengths(1), 1); %isequal(b(1:2336), b_hat(1:2336)) = 1, missing bits stuck in tx_fifo
u_hat = source_decoding(b_hat_buf, code_tree{1}, 0);

for i = 2:(length(code_lengths))
    b_hat_buf = rx_fifo([], 10000, code_lengths(i), 0); %last block of 100 bytes will be missing if bits are stuck in tx_fifo
    u_hat = [u_hat; source_decoding(b_hat_buf, code_tree{i}, 0)];
end
    
a_tilde = da_conversion(u_hat, 2, 8, switch_graph);
[MSE, BER_final, BER_coded, BER_decoded] = analog_sink(a, a_tilde, u, u_hat, c_total, c_hat, b, b_hat);
