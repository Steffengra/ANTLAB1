function [c] = channel_coding(b, par_H, switch_off)
c = [];

if switch_off == 0
    %create generator matrix G
    %find parity bit indices
    index_pbit = [];
    for i = 1:length(par_H)
        if sum(par_H(:,i)) == 1 %parity bit columns have just one 1
            index_pbit = cat(2, index_pbit, i); %save indices
        end
    end
    %find data bit indices
    index_dbit = 1:7; 
    index_dbit(index_pbit) = []; %remove parity bit indices, data bit indices remain
    
    %create G
    %G has one 1 and three 0 for data bits, so that multiplication only
    %transfers the data bit
    %G has three 1 and one 0 for parity bits, depending on which data bit
    %each parity bit covers
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
    %coding is multiplication G*b, modulo 2
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