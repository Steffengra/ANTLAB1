function x = tx_hardware(s, par_txthresh, switch_graph)
test = s;
for i = 1:length(s)
   absolute = abs(test(i));
   if absolute >= par_txthresh
       test(i) = test(i)/absolute;
   end
end
x = test;

if switch_graph == 1
    figure;
    subplot(2, 1, 1)
    plot(abs(s));
    title('signal before thresholding');
    ylabel('magnitude');
    subplot(2, 1, 2);
    plot(abs(x));
    title('thresholded signal');
    xlabel('samples');
    ylabel('magnitude');
end
