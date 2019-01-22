function u_hat = source_decoding(b_hat_buf, code_tree, switch_off)
%add switch_off
if switch_off == 0
    u_hat = [];

    byte_index = 1;
    for i = 1:100
        code_length = 1;
        code_index = find([0 0]); %reset code_index for while loop
        while isempty(code_index)
            if byte_index+code_length > length(b_hat_buf)
                code_index = 1;
                break;
            end
            snippet = b_hat_buf(byte_index:byte_index+code_length)';
            match = cellfun(@(x)isequal(x, snippet), code_tree{2});
            code_index = find(match);
            code_length = code_length + 1;
            if code_length > 7
                disp('shit');
                return
            end
        end

        u_hat = [u_hat; de2bi(code_tree{1}{code_index}, 8)];
        byte_index = byte_index + code_length;
    end
elseif switch_off == 1
    u_hat = b_hat_buf;
else
    disp('switch_off must be 0 or 1');
end