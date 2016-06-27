function [ fs1, fs2 ] = filter_chunk( S1, S2, lp_freq, hp_freq, sf )
%FILTER_CHUNK Filters a chunk of EMG data
%   Given a chunk of EMG data, this function applies the next
%	signal filters:
%		
%		- Low pass filter at lp_freq
%		- High pass filter at hp_freq
%		- Notch filter at 50 Hz (change to 60Hz for american countries)


%   ------------------------ LOW PASS FILTER --------------------------

    order = 6;
    [b, a] = butter(order, lp_freq/(sf/2));
    S1 = filter(b, a, S1);
    S2 = filter(b, a, S1);
    
    %Resizing
    S1 = S1(120:end);
    S2 = S2(120:end);
    
%   ------------------------ HIGH PASS FILTER --------------------------
%   Obtaining Butterworth filter
    order = 6;
    [b, a] = butter(order, hp_freq/(sf/2), 'high');
    S1 = filter(b, a, S1);
    S2 = filter(b, a, S1);
    
    % Resizing
    S1 = S1(120:end);
    S2 = S2(120:end);
    
%     --------------------- NOTCH FILTER ----------------------------
    Wo = 50/(sf/2);
    [a, b] = iirnotch(Wo, (0.05*Wo));

    % Applying 50Hz notch filter to signals
    S1 = filter(a, b, S1);
    S2 = filter(a, b, S2);
    
    % Resizing
    S1 = S1(120:end);
    S2 = S2(120:end);

    % Transposing and "absoluting" signals
    S1 = abs(S1');
    S2 = abs(S2');
    
%     figure;
%     plot(S1);
%     title('Signal 1: Extensors');
%     figure;
%     plot(S2);
%     title('Signal 2: Wirst tendoms');
    
    fs1 = S1;
    fs2 = S2;
end

