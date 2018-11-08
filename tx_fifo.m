function b_buf = tx_fifo(b, par_fifolen, par_ccblklen, switch_reset)
persistent buffer;
persistent fifoindexend;
if switch_reset == 1
    buffer = zeros(par_fifolen, 1);
    fifoindexend = 0;
end

if fifoindexend+length(b) > length(buffer)
    error('buffer full');
    quit;
end
buffer(fifoindexend+1:fifoindexend+length(b)) = b;
fifoindexend = fifoindexend + length(b);

if par_ccblklen > fifoindexend-1
    b_buf = [];
else
    b_buf = buffer(1:par_ccblklen);
    buffer = cat(1, buffer(1+par_ccblklen:end), zeros(par_ccblklen, 1));
    fifoindexend = fifoindexend - par_ccblklen;
end
