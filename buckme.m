% find both critical member and MIN value of all the Wfailures among the members. 
% therefore it is the max theoretical load that the truss can support before the weakest member buckles

function [critical_member, W_failure_min] = buckme(Pcrit, Rm, memberLens)
    % W_failure for each member
    Wfailure = -Pcrit ./ Rm;
    
    % ignore 0 force members (or positive ie tension) by setting value to inf
    Wfailure(Rm >=0) = Inf;
    % [min Wfailure value, index] of the critical member
    [W_failure_min, critical_member] = min(Wfailure);
    
    fprintf('m%d with length %.3fin will buckle at\nforce: %.2f oz +/-1.36 oz\n', critical_member, memberLens(critical_member), W_failure_min);
end
