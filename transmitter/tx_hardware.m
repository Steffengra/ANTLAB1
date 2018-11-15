function x = tx_hardware(s, par_txthresh, switch_graph)
for i = 1:length(s)
   absolute = abs(s(i));
   if absolute >= par_txthresh
       s(i) = s(i)/absolute;
   end
end

x = s;