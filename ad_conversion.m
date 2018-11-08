function u = ad_conversion(a, par_w, par_q, switch_graph)
%discretize
b = a(1:par_w:end);

%quantize
aMin = -1;
aMax = 1;
steps = linspace(aMin, aMax, 2^par_q);
b_quantized = zeros(length(b), 1);
for i = 1:length(b_quantized)
    [~, index] = min(abs(steps-b(i)));
    b_quantized(i) = index-1;
end
u = de2bi(b_quantized);

%plot digitalized values and quantization error
if switch_graph == 1
    stem(steps(b_quantized+1));
    hold on;
    q_err = b - steps(b_quantized+1)';
    plot(q_err);
    hold off;
end
