function c_hat = demodulation(d_tilde, switch_mod, switch_graph)

c_hat = [].';
if switch_mod == 0 %QAM
    values = [-3, -1, 1, 3]/sqrt(10);
    for i = 1:length(d_tilde)
        re = real(d_tilde(i));
        [~, index] = min(abs(re-values));   % find minimum distance (|x|^2) symbol on real axis
        if index == 1
            c_hat = cat(1, c_hat, [0 0]');
        elseif index == 2
            c_hat = cat(1, c_hat, [0 1]');
        elseif index == 3
            c_hat = cat(1, c_hat, [1 1]');
        elseif index == 4
            c_hat = cat(1, c_hat, [1 0]');
        end
        
        im = imag(d_tilde(i));
        [~, index] = min(abs(im-values));   % find minimum distance symbol on imag axis
        if index == 1
            c_hat = cat(1, c_hat, [0 0]');
        elseif index == 2
            c_hat = cat(1, c_hat, [0 1]');
        elseif index == 3
            c_hat = cat(1, c_hat, [1 1]');
        elseif index == 4
            c_hat = cat(1, c_hat, [1 0]');
        end
    end
    
elseif switch_mod == 1 %PSK
    gray = [0 1 3 2 7 6 4 5 15 14 12 13 8 9 11 10]; % gray coded symbol order
    angles = gray .* (1/16 * 2 * pi);               % calculate possible symbol angles in rad
    phase_angle = angle(d_tilde);                   % determine angles of data
    % convert negative angles into positive equivalent
    for i = 1:length(phase_angle)
        if phase_angle(i) < 0
            phase_angle(i) = 2 * pi + phase_angle(i);
        end
    end
    % find minimum distance (|x|^2) symbol to data
    for i = 1:length(phase_angle)
        [~, index] = min(abs(phase_angle(i)-angles));
        c_hat = cat(1, c_hat, de2bi(index-1, 4).');
    end
end

if switch_graph == 1
    scatterplot(d_tilde);
    grid;
    if switch_mod == 1
        for ii = 1:8
            refline(tan(pi/2 - pi/16 - ii*pi/8), 0);
        end        
    elseif switch_mod == 0
        for ii = -1:1
            refline(0, ii*0.632);
            line([ii*0.632 ii*0.632], [-2.6, 2.6]);
        end
    end
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
end