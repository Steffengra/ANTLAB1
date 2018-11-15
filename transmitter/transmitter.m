par_qampsk = 0;

a = analog_source(1000, 1, 0);
u = ad_conversion(a, 2, 8, 0);
[b, code_tree] = source_coding(u, 100, 0, 0);

b_buf = tx_fifo(b, 10000, 32, 1);
H = [1 0 1 0 1 0 1;0 1 1 0 0 1 1;0 0 0 1 1 1 1];
c = channel_coding(b_buf, H, 0);
d = modulation(c, par_qampsk, 0);
while 1
    b_buf = tx_fifo([], 10000, 32, 0);
    if isequal(b_buf, [])
        break;
    end
    c = channel_coding(b_buf, H, 0);
    d = cat(1, d, modulation(c, par_qampsk, 0));
end

s = tx_filter(d, 8, 0);
x = tx_hardware(s, 1, 0);