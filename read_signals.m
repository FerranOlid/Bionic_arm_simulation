function [ S1, S2 ] = read_signals( filename )
%READ_SIGNALS Read emg signals from files

load(filename);

% Cutting ending of the signals (device start and stop noise)
S1 = biosignalDev2_ai0.Data;
S1 = S1(100:(size(S1)-200));
S2 = biosignalDev2_ai1.Data;
S2 = S2(100:(size(S2)-200));

end

