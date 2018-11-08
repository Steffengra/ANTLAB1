function [c] = channel_coding(b,par_H,switch_off)
c = encode(b, 7, 4, 'hamming/binary');