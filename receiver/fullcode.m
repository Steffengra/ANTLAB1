par_qampsk = 0;
switch_graph = 0;
MSE_tot = zeros(1, 10);
BER_tot = zeros(1, 10);

for ii = 1:10
    SNR_DB = ii;
    run transmitter.m
    run receiver.m
    MSE_tot(ii) = MSE;
    BER_tot(ii) = BER;
end

figure;


plot(1:10, MSE_tot);
hold;
plot(1:10, BER_tot);
title('MSE and BER over SNR_DB');
xlabel('SNR DB');
legend({'MSE','BER'});