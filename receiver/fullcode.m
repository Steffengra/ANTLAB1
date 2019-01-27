par_qampsk = 0;
switch_graph = 0;
MSE_tot = zeros(1, 10);
BER_final_tot = zeros(1, 10);
BER_coded_tot = zeros(1, 10);
BER_decoded_tot = zeros(1, 10);

for ii = 1:10
    SNR_DB = ii;
    run transmitter.m
    run receiver.m
    MSE_tot(ii) = MSE;
    BER_final_tot(ii) = BER_final;
    BER_coded_tot(ii) = BER_coded;
    BER_decoded_tot(ii) = BER_decoded;
end

figure;


plot(1:10, MSE_tot);
hold;
plot(1:10, BER_final_tot);
plot(1:10, BER_coded_tot);
plot(1:10, BER_decoded_tot);
title('MSE and BER over SNR|DB');
xlabel('SNR|DB');
legend({'MSE','BER final', 'BER coded', 'BER decoded'});