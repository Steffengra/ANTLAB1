function [c] = channel_coding(b, par_H, switch_off)
%different result than .p
c = [];

if switch_off == 0
    %create generator matrix G
    %find parity bit indices
    index_pbit = [];
    for i = 1:length(par_H)
        if sum(par_H(:,i)) == 1
            index_pbit = cat(2, index_pbit, i);
        end
    end
    %find data bit indices
    index_dbit = 1:7;
    index_dbit(index_pbit) = [];
    
    %create G
    G = zeros(7, 4);
    for i = 1:3
        G(index_pbit(i),:) = par_H(i, index_dbit);
    end
    for i = 1:4
        buffer = zeros(1,4);
        buffer(i) = 1;
        G(index_dbit(i),:) = buffer;
    end
    
    %code b with G in 4 bit batches
    iter = length(b)/4;
    for i = 1:iter
        sig = mod(G * b(1+(i-1)*4:4+(i-1)*4), 2);
        c = cat(1, c, sig);
    end
    
elseif switch_off == 1
    c = b;
else
    error('invalid parameter, switch_off must be 0 or 1');
end