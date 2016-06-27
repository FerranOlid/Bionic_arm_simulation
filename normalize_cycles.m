function [ out1, out2 ] = normalize_cycles( cycles, s1, s2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    

%     First thing is to look for the widest cycle
    max_length = 0;
    max_loc = 0;
    aux = cycles(:, 2) - cycles(:, 1);
    [max_length, max_loc] = max(aux);
    
    size_cycles = size(cycles) - 1;
    
    out1 = zeros(max_length, size_cycles(1));
    out2 = zeros(max_length, size_cycles(1));
    
    maxpow1 = max(s1);
    maxpow2 = max(s2);
    
%     Normalizing
    for i=1:(size(cycles)-1)
%         Normalizing length
        if i ~= max_loc
            aux = s1(cycles(i, 1):cycles(i, 2));
            aux2 = s2(cycles(i, 1):cycles(i, 2));
            
            faux = fft(aux);
            faux2 = fft(aux2);
            diff = max_length - (cycles(i, 2) - cycles(i, 1))-1;
            
            faux = [faux; zeros(diff, 1)];
            faux2 = [faux2; zeros(diff, 1)];
            
            out1(:, i) = ifft(faux);
            out2(:, i) = ifft(faux2);
            
%             Normalizing power
            Mout1 = max(out1(:, i));
            mout1 = min(out1(:, i));
            Mout2 = max(out2(:, i));
            mout2 = min(out2(:, i));
            
            out1(:, i) = out1(:, i) - mout1;
            out1(:, i) = out1(:, i) ./ Mout1;
            out2(:, i) = out2(:, i) - mout2;
            out2(:, i) = out2(:, i) ./ Mout2;
            
            out1(:, i) = out1(:, i) .* maxpow1;
            out2(:, i) = out2(:, i) .* maxpow2;
        end
    end

end

