% This function finds and prints both critical member and MIN (nominal) value of all the Wfailures among the members. 
% therefore it is the max theoretical load that the truss can support before the weakest member buckles.

% Also includes weak, nominal, strong uncertainty.

function [critical_member, W_failure_min, W_failure_strong, W_failure_weak] = buckme(Pcrit_nom, Rm, memberLens)
    error_margin = 1.36;
    Pcrit_strong = Pcrit_nom + error_margin;
    Pcrit_weak = Pcrit_nom - error_margin;

    % W_failure for each member
    Wfailure_nom = -Pcrit_nom ./ Rm;
    Wfailure_strong = -Pcrit_strong ./ Rm;
    Wfailure_weak = -Pcrit_weak ./ Rm;

    % ignore 0 force members (or positive ie tension) by setting value to inf
    Wfailure_nom(Rm >= 0) = Inf;
    Wfailure_strong(Rm >= 0) = Inf;
    Wfailure_weak(Rm >= 0) = Inf;

    % [min Wfailure value, index] of the critical member
    [W_failure_min, critical_member] = min(Wfailure_nom); %output nominal
    W_failure_strong = Wfailure_strong(critical_member);
    W_failure_weak = Wfailure_weak(critical_member);
    
    %printer
    fprintf('Critical Member: m%d\n',critical_member);
    fprintf('m%d with length %.3fin will buckle at nominal force: %.2f oz\n',critical_member, memberLens(critical_member), W_failure_min);
    fprintf('strong force: %.2f oz, weak force: %.2f oz\n\n',  W_failure_strong, W_failure_weak);

    % potential critical members considering the strong and weak forces
    fprintf('Other members near critical failure of strong/weak with +/-%.2f oz error: (if any)\n', error_margin);
    lower_bound = W_failure_min - error_margin;
    upper_bound = W_failure_min + error_margin;
    
    for i = 1:length(Wfailure_nom)
        if i ~= critical_member && Wfailure_nom(i) <= upper_bound && Wfailure_nom(i) >= lower_bound % exclude the critical member but include any other member within range
            fprintf('m%d: failure load (nom) = %.2f oz, length = %.3f in\n', i, Wfailure_nom(i), memberLens(i));
        end
    end

end
