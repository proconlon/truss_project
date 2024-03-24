% find both critical member and MIN value of all the Wfailures among the members. 
% therefore it is the max theoretical load that the truss can support before the weakest member buckles

function [critical_member, W_failure_min] = buckme(Pcrit, Rm)
    % W_failure for each member
    Wfailure = -Pcrit ./ Rm;
    
    % [min Wfailure value, index] of the critical member
    [W_failure_min, critical_member] = min(Wfailure);
    
    fprintf('critical member: %d with max load: %.2f oz\n', critical_member, W_failure_min);
end
