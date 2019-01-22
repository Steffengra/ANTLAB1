function b_buf = tx_fifo(b, par_fifolen, par_ccblklen, switch_reset)
%use persistent variables - they persist inbetween calls of the same
%function
persistent buffer;
persistent fifoindexend;

%if reset buffer
if switch_reset == 1
    buffer = zeros(par_fifolen, 1); %empty buffer
    fifoindexend = 0; %set end index to start
end

%if input greater than buffer length
if fifoindexend+length(b) > length(buffer)
    error('buffer full');
    quit;
end


buffer(fifoindexend+1:fifoindexend+length(b)) = b; %add new data to buffer
fifoindexend = fifoindexend + length(b); %move end pointer to new end

%if remaining buffer smaller than requested output size
if par_ccblklen > fifoindexend-1
    b_buf = [];
else
    b_buf = buffer(1:par_ccblklen); %output one block
    buffer = cat(1, buffer(1+par_ccblklen:end), zeros(par_ccblklen, 1)); %remove output data from buffer, add zeros at the end to pad length
    fifoindexend = fifoindexend - par_ccblklen; %move end pointer to correct position
end
