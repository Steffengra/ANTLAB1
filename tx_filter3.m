function s = tx_filter3(d, par_tx, switch_graph)
%upsample
for i = length(d):-1:1
    d = [d(1:i);zeros(par_tx-1,1);d(i+1:end)];
end

filter = dsp.LowpassFilter('PassbandFrequency', 1/par_tx, 'PassbandRipple', 0.001, 'DesignForMinimumOrder', true);
fvtool(filter);