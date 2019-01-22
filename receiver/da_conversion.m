function a_tilde = da_conversion(u_hat, par_w, par_q, switch_graph)

%interp1 statt upsample
x = 0:length(u_hat)-1;
xq = 0:1/par_w:length(u_hat)-1;
upsampled = floor(interp1(x, bi2de(u_hat), xq)');
upsampled = upsampled + 1;

%assign steps to values
aMin = -1;
aMax = 1;
steps = linspace(aMin, aMax, 2^par_q); %2^par symbols
a_tilde = steps(upsampled)';

if switch_graph == 1
    figure;
    plot(a_tilde);
end