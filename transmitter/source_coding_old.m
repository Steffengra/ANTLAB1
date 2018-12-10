function [b, code_tree] = source_coding_old(u,par_scblklen,switch_off,switch_graph)
%replace huffmandict, huffmanenco
iter = ceil(length(u)/par_scblklen);
code_tree = {};
b = [];

for i = 1:iter
    if i*par_scblklen+1 > length(u)
        current = u((i-1)*par_scblklen+1:end,:);
    else
        current = u((i-1)*par_scblklen+1:i*par_scblklen,:);
    end

    [codes, indexa, indexc] = unique(current, 'rows');
    counts = accumarray(indexc, 1); %counts*1 for each unique index
    p = counts/length(current);
    
    [dict, ~] = huffmandict(bi2de(codes), p);
    code_tree{end+1} = dict;
    bitstream = huffmanenco(bi2de(current), dict);
    b = cat(1, b, bitstream);
end