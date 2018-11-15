s_tilde = rx_hardware(x, 1, 0);
d_tilde = rx_filter(s_tilde, 8, 0);
c_hat = demodulation(d_tilde, par_qampsk, 0);
b_hat = channel_decoding(c_hat, H, 0);
%b_hat_buf = rx_fifo(b_hat, par_fifolen, par_sdblklen, switch_reset);
%u_hat = source_decoding(b_hat_buf, code_tree, switch_off);
%a_tilde = da_conversion(u_hat, par_w, par_q, switch_graph);
%[MSE, BER] = analog_sink(a, a_tilde, b, b_hat);
