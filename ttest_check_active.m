function [ active ] = ttest_check_active( vals1, vals2, ref1, ref2, std1, std2, actived )
%CHECK_ACTIVE Returns whether the arm is active or not
%   This function is the one that decides wether the robotic arm should activate
% 	or not. To do this it checks the values stored in the "vals" array, and do
%	some tests on them, such as scope, threshold values and std. Also, in
%	the ttest_ version, statistical test is performed and used to
%	determinate the activation of the hand
    
%     variables
    conditions = zeros(1, 3);
    weights = [0.4, 0.3, 0.15, 0.10, 0.05];

    refa=ones(1,5)*ref1;
    refb=ones(1,5)*ref2;

    [h,p]=ttest2(abs(vals1+vals2),mean([refa; refb]));
    
%     Checking threshold and std tests
    if (~actived)
        conditions(1) = (sum(vals1) > (4*(3*ref1))) || (sum(vals2) > (4*(3*ref2)));
        conditions(2) = (sum(weights .* vals1) > (ref1 + 3*std1)) || (sum(weights .* vals2) > (ref2 + 3*std2));
    else
        conditions(1) = (sum(vals1) >= (2*ref1)) || (sum(vals2) >= (2*ref2));
        conditions(2) = (sum(weights .* vals1) >= (ref1 + 1*std1)) || (sum(weights .* vals2) >= (ref2 + 1*std2));
    end
    
%     Checking ttest value
    if p < 0.0001 
        conditions(3) = 0;
    else 
        conditions(3) = 1;
    end
    active = (sum(conditions) >= 3);
                         
%     This tells which muscle is the stronger (remove semicolon)
check=[[vals1+vals2]/[vals1-vals2]];

end

