function [b, code_tree, code_lengths] = source_coding(u,par_scblklen,switch_off,switch_graph)

code_lengths = [];
if switch_off == 0
    %work in blocks
    iter = ceil(length(u)/par_scblklen);
    code_tree = {};
    b = [];
    
    %iterate over blocks
    for i = 1:iter
        %decide if remaining input is a full block
        if i*par_scblklen+1 > length(u)
            current = u((i-1)*par_scblklen+1:end,:);
        else
            current = u((i-1)*par_scblklen+1:i*par_scblklen,:);
        end

        %find unique words
        [codes, ~, indexc] = unique(current, 'rows');
        counts = accumarray(indexc, 1); %counts*1 for each unique index
        index = 1:length(codes);
        codes = bi2de(codes);
        p = counts/length(current); %find probability within block
        treelength = ones(length(codes), 1);

        %table to keep track of tree nodes
        index_cur = index;
        codes_cur = codes;
        p_cur = p;
        treelength_cur = treelength;
        combines1 = zeros(length(codes), 1);
        combines2 = zeros(length(codes), 1);
        connec1 = zeros(length(codes), 1);
        connec2 = zeros(length(codes), 1);


        %huffman dict
        for i = 1:length(codes)-1
            p_sort = sort(p_cur);
            min1 = p_sort(1);
            i_min1 = find(p_cur == min1);

            if length(i_min1) > 1
                min_length = min(treelength(i_min1));
                i_min_length = find(treelength(i_min1)==min_length);

                if length(i_min_length) > 1
                    i_min1 = i_min1(i_min_length(1));
                else
                    i_min1 = i_min1(i_min_length);
                end
            end

            min2 = p_sort(2);
            i_min2 = find(p_cur == min2);
            i_min2 = setdiff(i_min2, i_min1); %remove i_min1 from list of possibilities
            if length(i_min2) > 1
                min_length = min(treelength(i_min2));
                i_min_length = find(treelength(i_min2)==min_length);

                if length(i_min_length) > 1
                    i_min2 = i_min2(i_min_length(1));
                else
                    i_min2 = i_min2(i_min_length);
                end
            end
            %combine min1, min2 into one node--
            %add new node in current set
            index_cur(end+1) = index_cur(end)+1;
            codes_cur(end+1) = [0];
            p_cur(end+1) = p_cur(i_min1) + p_cur(i_min2);
            treelength_cur(end+1) = max([treelength_cur(i_min1),treelength_cur(i_min2)])+1;

            %add new node in global set
            index(end+1) = index(end)+1;
            codes(end+1) = [0];
            p(end+1) = p_cur(i_min1) + p_cur(i_min2);
            treelength(end+1) = max([treelength_cur(i_min1),treelength_cur(i_min2)])+1;
            combines1(end+1) = index_cur(i_min1);
            combines2(end+1) = index_cur(i_min2);

            %remove used nodes from current set
            index_cur([i_min1, i_min2]) = [];
            codes_cur([i_min1, i_min2]) = [];
            p_cur([i_min1, i_min2]) = [];
            treelength_cur([i_min1, i_min2]) = [];
            %--
        end

        %determine which connection of a node is 0 and which is 1
        index_borders = find(combines1 ~= 0);
        for i = index_borders(1):index_borders(end)
            if p(combines1(i)) > p(combines2(i))
                connec1(end+1) = 1;
                connec2(end+1) = 0;
            else
                connec1(end+1) = 0;
                connec2(end+1) = 1;
            end
        end

        %build codewords by going from the roots to the stem
        codewords = {};
        index_roots = find(combines1 == 0);
        for i = index_roots(1):index_roots(end)
            n_cur = i;
            c_cur = [];
            while n_cur ~= index(end)
                if ismember(n_cur, combines1)
                    n_cur = find(combines1==n_cur);
                    c_cur = [c_cur, connec1(n_cur)];
                elseif ismember(n_cur, combines2)
                    n_cur = find(combines2==n_cur);
                    c_cur = [c_cur, connec2(n_cur)];
                else
                    disp('oh no');
                end 
            end
            codewords{end+1, 1} = c_cur;
        end
        codes = num2cell(codes(index_roots));
        tree_cur = {codes, codewords};
        code_tree{end+1} = tree_cur;

        %encode bits--
        length_100 = 0;
        for i = 1:length(current)
            %find source in source alphabet
            index_code = find(cell2mat([tree_cur{1}]) == bi2de(current(i,:)));
            %find corresponding code
            encoded = cell2mat(tree_cur{2}(index_code));
            length_100 = length_100 + length(encoded);
            b = [b; encoded'];
        end
        %--
        code_lengths = [code_lengths, length_100];
    end
    
    %graph
    if switch_graph == 1
        figure;
        bar(cell2mat(codes), p(index_roots))
        ylabel('probability');
        xlabel('source alphabet');
        title('source coding probability distribution');
    end
    
    
elseif switch_off == 1
    b = u;
    code_tree = [];
else
    error('invalid parameter, switch_off must be 0 or 1');
end