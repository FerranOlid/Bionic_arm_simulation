function [ rest_pos1, rest_pos2, std1, std2 ] = emg_calibrate( S1, S2, iterations, lp_freq, hp_freq, sf, chunk_size )
%EMG_CALIBRATE Calibrates EMG signals
%   Given two EMG signals, this function calculates the means of some
%	preprocessed chunks of the EMG data. Actually, it corresponds to
%	around 5 seconds of data (i.e: 10k samples)

    rest_pos1 = 0;
    rest_pos2 = 0;
    acc1 = [1];
    acc2 = [1];
    for i = 1:iterations
        j = (i-1)*chunk_size+1;
        j1 = i*chunk_size;
        [fs1, fs2] = filter_chunk(S1(j:j1), S2(j:j1), lp_freq, hp_freq, sf);
        mfs1 = mean(fs1);
        mfs2 = mean(fs2);
        rest_pos1 = rest_pos1 + mfs1;
        rest_pos2 = rest_pos2 + mfs2;
        acc1(i) = mfs1;
        acc2(i) = mfs2;
        acc1 = [acc1, 0];
        acc2 = [acc2, 0];
    end
    
    rest_pos1 = rest_pos1 / iterations;
    rest_pos2 = rest_pos2 / iterations;
    std1 = std(acc1(1:end-1));
    std2 = std(acc2(1:end-1));
end

