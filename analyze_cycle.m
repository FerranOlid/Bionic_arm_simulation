    function [ m, dev, mm ] = analyze_cycle( c, sf )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    sc = size(c)
    m = mean(c);
    dev = std(c);
    mm = max(c);

    ps1 = abs(c/sc(1));
    ps1 = ps1(1:sc(1)/2+1);
    ps1(2:end-1) = 2*ps1(2:end-1);
    freq_dom_s1 = sf*(0:(sc(1)/2))/sc(1);
    figure; 
    plot(freq_dom_s1(2:500), ps1(2:500));
    title('Cycle Fourier transform');
    xlabel('f (Hz)');
    ylabel('|P1(f)|');

end

