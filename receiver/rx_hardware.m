function s_tilde = rx_hardware(y, par_rxthresh, switch_graph)

s_tilde = y;

if switch_graph == 1
    figure;
    subplot(2, 1, 1)
    plot(abs(y));
    ylim([0 2]);
    title('signal before thresholding');
    ylabel('magnitude');
    subplot(2, 1, 2);
    plot(abs(s_tilde));
    ylim([0 2]);
    title('"thresholded" signal');
    xlabel('samples');
    ylabel('magnitude');
end