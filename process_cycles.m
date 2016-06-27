function [ out ] = process_cycles( c )
%Process Cycles:  Processes an EMG cycle
%   Given a cycle in which the muscle is active, this functions extracts
%   several properties of it.

    sz = size(c);
    m = mean(c);
    d = std(c);
    
    

end

