function b_hat = channel_decoding(c_hat, par_H, switch_off)
%2. Figure of exemplary code word indicating corrected errors ????

b_hat = []';
if switch_off == 0
    iter = length(c_hat)/7;
    for i = 1:iter
        code = c_hat(1 + 7*(i-1):7 + 7*(i-1));
        syndrome = mod(par_H*code, 2);
        if not(isequal(syndrome, [0 0 0]'))
            code(bi2de(syndrome')) = not(code(bi2de(syndrome')));
        end
        %create decoder matrix R
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
        
        R = zeros(4, 7);
        for i = 1:4
            R(i, index_dbit(i)) = 1;
        end
        b_hat = cat(1, b_hat, R*code);
    
    end
    
elseif switch_off == 1
    b_hat = c_hat;
end