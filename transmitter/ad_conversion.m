function u = ad_conversion(a, par_w, par_q, switch_graph)
%discretize
%1:stepsize:end
b = a(1:par_w:end);

%quantize
aMin = -1;
aMax = 1;
steps = linspace(aMin, aMax, 2^par_q); %2^par symbols
b_quantized = zeros(length(b), 1);
for i = 1:length(b_quantized)
    [~, index] = min(abs(steps-b(i))); %find the closest symbol to value
    b_quantized(i) = index-1; %set symbol
end
u = de2bi(b_quantized); %convert to binary

%plot digitalized values and quantization error
if switch_graph == 1
    figure;
    stem(steps(b_quantized+1));
    hold on;
    q_err = b - steps(b_quantized+1)'; %calculate quantization error
    plot(q_err);
    hold off;
    title('quantized signal')
    xlabel('samples');
    ylabel('value');
end
