function s_out = delete_zeros(signal, smooth)
%     Deletes 0 close values in the end and beginning of a signal.

% Declaring initial values
    m = mean(signal);
    dev = std(signal);
    l_th = m-dev;
    u_th = m+dev;
    
    signal = signal';
    ss = size(signal);
    z_beginning = 1;
    z_end = 0;
    done = 0;
    i = 1;
    
%     Removing 0 at the beginning
    while (i<ss(2) && done == 0)
        if ((signal(1, i) <= l_th) || (signal(1, i) >= u_th))
            z_beginning = z_beginning + 1;
        else
            done = 1;
        end
        i = i + 1;
    end
%     Resetting values
    done = 0;
    i = ss(2);
%     Removing 0 at the end
    while (i>0 && done == 0)
        if((signal(1, i)<=l_th) || (signal(1, i) >= u_th))
            z_end = z_end + 1;
        else
            done = 1;
        end
        i = i - 1;
    end
    z_end = ss(2) - z_end;
    s_out = signal(1, z_beginning:z_end);
    size(s_out);
    
    if smooth
    %     Removing extreme values
        prevalue = s_out(1);
        so = size(s_out);
        for i=2:so(2)
            diff = max(abs(prevalue/abs(s_out(i))), abs(s_out(i)/prevalue));
            if (diff > 1.3)
                s_out(i) = 0.8*prevalue;
            end
            prevalue = s_out(i);
        end
    end
end