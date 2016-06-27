% Bionic Hand Real Time Simulation script
% Author: Ferran Olid Dominguez

% This file is part of the Bachelor thesis carried on by Ferran Olid
% Dominguez, and is protected under BSD license. Therefore, any use or
% distribution of this code, partial or complete, must recognise the
% credits to the original author.

% Given an array containing EMG signals from a huma forearm, this script
% processes these signals in order to detect wether the muscles are active
% or not, hence recognising when the fist is closed or not. The signals
% used in this thesis are EMG signals recorded from the flexo carpum
% muscles (S1) and smaller forearm extensors (S2).
% The signal S3 is the reading of a Dynamometer recording the strength (in
% Newtons) of the fist when it closes. It can be used to relate the
% strength of the muscle signals with the final strength of the arm.

clear;
% Declaring general variables
sf = 2000;              % Sampling frequency
filename = '2016_06_15_2_ecg_2.mat';
lp_freq = 150;          % Low pass frequency
hp_freq = 20;           % High pass frequency
wsize = 50;             % window size
chunk_size = 600;       % RT simulation chunk size
window_shift = 200;     % After calibration, shifting of the window
calib_time = 5;         % Seconds of calibration
maxmean = 0;            % Mean of the maximums
DEBUG = true;           % Debug flag
cycles = zeros(1, 2);   % Cycle storage

% Declaring other variables
max_counter = 1;

% Reading data from files
[S1, S2] = read_signals(filename);
hand = imread('images/hand.png');
fist = imread('images/fist.png');

% Starting RT simulation
% First seconds are for resting position calibrations
disp( sprintf( 'Calibrating...'));
iterations = calib_time/(chunk_size/sf);
[rest_pos1, rest_pos2, std1, std2] = emg_calibrate(S1, S2, iterations, lp_freq, hp_freq, sf, chunk_size);
disp( sprintf( 'Calibration done!') );
disp( sprintf( 'Starting bionic hand algorithm...') );

if (DEBUG)
    rest_pos1;
    std1;
end


if(~DEBUG)
    figure;
    imshow(hand);
    hold on;
end
ssample = size(S1);
active = false;
values_1 = [1, rest_pos1, rest_pos1, rest_pos1, rest_pos1];
values_2 = [1, rest_pos2, rest_pos2, rest_pos2, rest_pos2];
monitor = 0;	% Stores mean, processed values from EMG signal (what the algorithm works with)
n = 0;
if (DEBUG)
    figure;
    plot(monitor);
    hold on;
end
onval = 0;
offval = 0;

for i = (iterations*chunk_size):window_shift:ssample
%     Getting actual value(s)
    [actval1, actval2] = filter_chunk(S1(i:int32(i+chunk_size)), S2(i:int32(i+chunk_size)), lp_freq, hp_freq, sf);
    values_1(1) = mean(actval1);
    values_2(1) = mean(actval2);
    
    if (DEBUG)
        monitor = [monitor, mean(actval1)];
        plot(monitor, 'b');
    end
    
    if (active)
        % Arm is active here--------------------------------------------
        if (~ ttest_check_active(values_1, values_2, rest_pos1, rest_pos2, std1, std2, true))
            active = false;
            if (~DEBUG)
                do_move()
                imshow(hand);
            end
            disp( sprintf( 'Hand deactivated!') );
            offval = i;
%             Recording cycle
            cycles(end, :) = [onval, offval];
            cycles = [cycles; 0, 0];
        end
        values_1 = update_values(values_1);
        values_2 = update_values(values_2);
%         Updating maximum
        maxmean = (maxmean*(max_counter-1) + values_1(1))/(max_counter);
        max_counter = max_counter + 1;
    else
        %Arm is inactive here-------------------------------------------
        if (ttest_check_active(values_1, values_2, rest_pos1, rest_pos2, std1, std2, false))
            active = true;
            if (~DEBUG)
                do_move()
                imshow(fist);
            end
            disp( sprintf( 'Hand activated!') );
            onval = i;
            n = n+1;
            if (DEBUG)
                n
            end
        end
        values_1 = update_values(values_1);
        values_2 = update_values(values_2);
    end
    pause(window_shift/sf);           % RT here
end

% Setting positions on cycle matrix
cycles = cycles.*window_shift+(iterations*chunk_size);
