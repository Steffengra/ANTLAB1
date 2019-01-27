function b_hat_buf = rx_fifo(b_hat, par_fifolen, par_sdblklen, switch_reset)
persistent buffer;
persistent fifoindexend;

%if reset buffer
if switch_reset == 1
    buffer = zeros(par_fifolen, 1);     % empty buffer
    fifoindexend = 0;                   % set end index to start
end

%if input greater than buffer length
if fifoindexend+length(b_hat) > length(buffer)
    error('buffer full');
    quit;
end

buffer(fifoindexend+1:fifoindexend+length(b_hat)) = b_hat;      %add new data to buffer
fifoindexend = fifoindexend + length(b_hat);                    %move end pointer to new end

%if remaining buffer smaller than requested output size
if par_sdblklen > fifoindexend-1
    b_hat_buf = [];
else
    b_hat_buf = buffer(1:par_sdblklen); %output one block
    buffer = cat(1, buffer(1+par_sdblklen:end), zeros(par_sdblklen, 1)); %remove output data from buffer, add zeros at the end to pad length
    fifoindexend = fifoindexend - par_sdblklen; %move end pointer to correct position
end