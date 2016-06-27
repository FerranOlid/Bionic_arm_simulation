% Script for quick EMG processing (NO DYNAMOMETER)
% 
% emg_qp quickly process and EMG signal to have some feedback from it when
% captured in the lab. The parameters are the following:
% 
%       - filename: filename of the file containing the EMG
%       - sf: samplig frequency of the signal
%       - hp_freq: high pass frequency
%       - lp_freq: low pass frequency
%       - wsize: window size for filtering
%       - f_sr: Fourier sampling rate
%       - show_evo: if true, shows evolution of signal after filters
function [S1, S2, FS1, FS2, avS1, avS2] = emg_qp(filename, sf, hp_freq, lp_freq, wsize, f_sr, show_evo)
%   Reading signals
    load(filename);
%     Signals are cropped to avoid lab equipment activation and
%     deactivation noise.
    S1 = biosignalDev2_ai0.Data;
    S1 = S1(100:(size(S1)-200));
    S2 = biosignalDev2_ai7.Data;
    S2 = S2(100:(size(S2)-200));
    
    if (show_evo)
        figure;
        plot(S1);
        title('Signal 1 RAW');
        figure;
        plot(S2);
        title('Signal 2 RAW');
    end
    
%   ------------------------ LOW PASS FILTER --------------------------

    order = 6;
    [b, a] = butter(order, lp_freq/(sf/2));
    S1 = filter(b, a, S1);
    S2 = filter(b, a, S2);
    
    %Resizing
    S1 = S1(50:end);
    S2 = S2(50:end);
    
    if (show_evo)
        figure;
        plot(S1);
        title('Signal 1 after low pass');
        figure;
        plot(S2);
        title('Signal 2 after low pass');
    end
    
    
%   ------------------------ HIGH PASS FILTER --------------------------
%   Obtaining Butterworth filter
    order = 6;
    [b, a] = butter(order, hp_freq/(sf/2), 'high');
    S1 = filter(b, a, S1);
    S2 = filter(b, a, S2);
    
    %Resizing
    S1 = S1(400:end);
    S2 = S2(400:end);
    
    if (show_evo)
        figure;
        plot(S1);
        title('Signal 1 after high and low pass');
        figure;
        plot(S2);
        title('Signal 2 after high pass');
    end
    
%   ------------------------ NOTCH FILTER ---------------------------

%   Noch filter can cause a big information loss, uncomment only if you
%   know what you are doing

    Wo = 50/(sf/2);
    [a, b] = iirnotch(Wo, (0.05*Wo));

    % Applying 50Hz notch filter to signals
    S1 = filter(a, b, S1);
    S2 = filter(a, b, S2);
    
    %Resizing
    S1 = S1(400:end);
    S2 = S2(400:end);
    
    if (show_evo)
        figure;
        plot(S1);
        title('Signal 1 after notch filter');
        figure;
        plot(S2);
        title('Signal 2 after notch filter');
    end
    

% ------------- DELETING EXTREME VALUES AND PLOTTING ----------------
%     S1 = emg_rms(S1, wsize);
%     S2 = emg_rms(S2, wsize);
%     Deleting 0 close values at beginning and end
    S1 = delete_zeros(S1, false);
    S2 = delete_zeros(S2, false);
    
%     Cropping signals again to avoid filtering initial noise
    S1 = S1';
%     S1 = S1(350:size(S1));
    S2 = S2';
%     S2 = S2(400:size(S2));
    
    FS1 = fft(S1, f_sr);
    FS2 = fft(S2, f_sr);
    
%    -------------------- Plotting filtered signals --------------------
    figure;
    plot(S1);
    title('Signal 1: Extensors');
    figure;
    plot(S2);
    title('Signal 2: Wirst tendoms');
    
    cor = xcorr(S1, S1);
    figure;
    plot(cor);
    title('Cross correlation between signal 1 and signal 2');
    
%     -------------------Plotting fourier transforms--------------------
%     First, define axis as power and frequency
    sfs1 = size(FS1);
    sfs2 = size(FS2);

    ps1 = abs(FS1/sfs1(1));
    ps1 = ps1(1:sfs1(1)/2+1);
    ps1(2:end-1) = 2*ps1(2:end-1);
    
    ps2 = abs(FS2/sfs2(1));
    ps2 = ps2(1:sfs2(1)/2+1);
    ps2(2:end-1) = 2*ps2(2:end-1);
    
    freq_dom_s1 = sf*(0:(sfs1(1)/2))/sfs1(1);
    freq_dom_s2 = sf*(0:(sfs2(1)/2))/sfs2(1);
    
%     Now plotting    
    figure;
    plot(freq_dom_s1(1:int32(end/4)), ps1(1:int32(end/4)));
    title('Signal 1 Fourier transform');
    xlabel('f (Hz)');
    ylabel('|P1(f)|');
    figure;
    
    plot(freq_dom_s2(1:int32(end/4)), ps2(1:int32(end/4)));
    title('Signal 2 Fourier transform');
    xlabel('f (Hz)');
    ylabel('|P1(f)|');
    
%     -------------------- Moving Average ------------------------
    avS1 = movavg(abs(S1), 200, 200, 'e');
    avS2 = movavg(abs(S2), 200, 200, 'e');
    
    figure;
    plot(avS1);
    title('Signal 1 moving average');
    
    figure;
    plot(avS2);
    title('Signal 2 moving average');
end