function [ active ] = check_active( vals, ref, std, actived )
%CHECK_ACTIVE Returns whether the arm is active or not
%   This function is the one that decides wether the robotic arm should activate
% 	or not. To do this it checks the values stored in the "vals" array, and do
%	some tests on them, such as scope, threshold values and std.
    
%     variables
    conditions = zeros(1, 2);
    weights = [0.4, 0.3, 0.15, 0.10, 0.05];
    
    if (~actived)
%         conditions(1) = (sum(vals) > (0.06));
        conditions(1) = (sum(vals) > (4*(3*ref)));
%         std check
        conditions(2) = (sum(weights .* vals) > (ref + 3*std));
    else
%         conditions(1) = (sum(vals) >= (0.01));
        conditions(1) = (sum(vals) >= (2*ref));
%         std check
        conditions(2) = (sum(weights .* vals) >= (ref + 1*std));
    end
    active = (sum(conditions) >= 2);


end

