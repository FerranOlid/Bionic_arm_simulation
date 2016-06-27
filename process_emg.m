function [S1_filtered, S2_filtered, S1_f_std, S2_f_std, S1_fft] = process_emg(filename, show_evo)
% Variable definition
% Marks vector
mx = [0 2000 4000 6000 8000 10000 12000 14000 16000 18000 20000];
my = [1 1 1 1 1 1 1 1 1 1 1 ];

% Reading data from EMG file
load(filename);
S1 = biosignalDev2_ai0.Data;
S2 = biosignalDev2_ai2.Data;

% Applying RMS filter
S1_rms = emg_rms(S1, 25);
S2_rms = emg_rms(S2, 25);

% Creating notch filter to 50Hz assuming Q-factor of 1 (?)
Wo = 50/(2000/2);
[a, b] = iirnotch(Wo, (Wo));

% Applying 50Hz notch filter to signals
S1_filtered = filter(a, b, S1_rms);
S2_filtered = filter(a, b, S2_rms);

S1_rms = emg_rms(S1_filtered, 50);

% Plotting
figure;
if show_evo
    % Plotting first signal and filtered 
    subplot(3, 1, 1);
    plot(S1);
    hold on;
    plot(mx, my, 'o');
    hold off;
    title('Raw signal');
    axis([0 23000 0.75 1.2]);
    subplot(3, 1, 2);
    plot(S1_filtered, 'r');
    hold on;
    plot(mx, my, 'o');
    hold off;
    title('Filtered signal');
    axis([0 23000 0.75 1.2]);
    subplot(3, 1, 3);
    plot(S1);
    hold on;
    plot(S1_filtered);
    axis([0 23000 0.75 1.2]);
    plot(mx, my, 'o');
    title('Combined signals');
    hold off;
else
    subplot(2, 1, 1);
    plot(S1_filtered, 'r');
%     axis([0 23000 0.75 1.2]);
    hold on;
    plot(mx, my, 'o');
    hold off;
    title('Signal 1');
    subplot(2, 1, 2);
    plot(S2_filtered, 'g');
%     axis([0 23000 0.75 1.2]);
    hold on;
    plot(mx, my, 'o');
    hold off;
    title('Signal 2');
end

% Calculating windowed standard deviation (500ms) = 1000 points
S1_f_std = emg_wstd(S1_filtered, 1000);
S2_f_std = emg_wstd(S2_filtered, 1000);
figure;
subplot(2, 1, 1);
plot(S1_f_std);
% axis([0 23000 0 0.1]);
hold on;
plot(mx, my, 'o');
hold off;
title('Standard deviation for processed singal 1');
subplot(2, 1, 2);
plot(S2_f_std);
axis([0 23000 0 0.1]);
hold on;
plot(mx, my, 'o');
hold off;
title('Standard deviation for processed singal 2');

% Calculating FFT
S1_fft = fft(S1_filtered);
S2_fft = fft(S2_filtered);
figure; plot(S1_fft);
axis([]);
end