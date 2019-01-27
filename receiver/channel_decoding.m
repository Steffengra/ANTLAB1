function b_hat = channel_decoding(c_hat, par_H, switch_off, switch_graph)
plotflag = 0;

b_hat = []';
if switch_off == 0
    iter = length(c_hat)/7; % 7 bits -> 4 bits
    for i = 1:iter
        code = c_hat(1 + 7*(i-1):7 + 7*(i-1));  % grab a 7 bit slice
        syndrome = mod(par_H*code, 2);          % calculate syndrome matrix (showing error)
        if not(isequal(syndrome, [0 0 0]'))     % if error:
            %exemplary figure of corrected bit
            if and(plotflag == 0, switch_graph == 1)
                figure;
                stem(1:7, code);
                hold on;
                code(bi2de(syndrome')) = not(code(bi2de(syndrome'))); % flip bit if error at position
                stem(1:7, code);
                hold off;
                plotflag = 1;
                xlim([.5 7.5]);
                ylim([-.5 1.5]);
                legend({'Before', 'After'});
                title('Single bit correction via channel coding');
                xlabel('bits');
                ylabel('value');
            else
                code(bi2de(syndrome')) = not(code(bi2de(syndrome'))); % flip bit if error at position
            end
            
        end
        %create decoder matrix R-------------
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
        %-------------------------------------
        
        b_hat = cat(1, b_hat, R*code); % 7 -> 4
    
    end
    
elseif switch_off == 1
    b_hat = c_hat;
end