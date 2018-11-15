 test = de2bi([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]);
 modu = []';
 for i = 1:length(test)
     modu = cat(1, modu, modulation(test(i,:)', 1, 0));
 end