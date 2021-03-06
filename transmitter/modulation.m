function d = modulation(c, switch_mod, switch_graph)
iter = length(c)/4;
d = [];
re = [];
im = [];
if switch_mod == 0 %QAM
    for i = 1:iter %symbol table, first two bits -> real, last two bits -> imag
        signal = c(1+4*(i-1):4+4*(i-1));
        if isequal(signal(1:2), [0 0]')
            re = -3;
        elseif isequal(signal(1:2), [0 1]')
            re = -1;
        elseif isequal(signal(1:2), [1 1]')
            re = 1;
        elseif isequal(signal(1:2), [1 0]')
            re = 3;
        end
        
        if isequal(signal(3:4), [0 0]')
            im = -3;
        elseif isequal(signal(3:4), [0 1]')
            im = -1;
        elseif isequal(signal(3:4), [1 1]')
            im = 1;
        elseif isequal(signal(3:4), [1 0]')
            im = 3;
        end
        d = cat(1, d, re + j*im);
    end
    d = d ./ sqrt(10); %normalize average symbol power to 1
    
elseif switch_mod == 1 %PSK
    for i = 1:iter
        signal = c(1+4*(i-1):4+4*(i-1));
        gray = [0 1 3 2 7 6 4 5 15 14 12 13 8 9 11 10]; %counter-clockwise ordering of bits around the unit circle to ensure grey coding
        angle = gray(bi2de(signal')+1) * 1/16 * 2 * pi; %calculate angle according to above order
        d = cat(1, d, exp(j*angle));
        %power normalized by default
    end  
end


if switch_graph == 1
    figure;
    scatter(real(d), imag(d));
    x = linspace(0, 2*pi, 1000);
    y = exp(j*x);
    if switch_mod == 1
        hold on;
        plot(real(y), imag(y));
        hold off;
    end
    grid on;
    axis([-1.5 1.5 -1.5 1.5]);
    xlabel('re');
    ylabel('im');
    title('modulated symbols');
end