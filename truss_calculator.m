%% truss matrix setup
% requries ancillary functions in the functions folder to run

load('Truss Design 2.mat'); % mat file with C, Sx, Sy, X, Y, L
fprintf('EK301, Section A2, Group 2: Kailan Pan, James Conlon, Austin Zhang, Spring 2024\n\n');

%% calculations

% generate eq eqns
[A, L] = eq_eqns(C, Sx, Sy, X, Y, L);

% solve for member forces and the 3 reaction forces
% T is in this format: [ T_1-m, S_x1, S_y2, S_y2 ] (all internal forces)
T = A \ L; 

% check cost and member/joint reqs
[totalCost, totalLength, memberLengths] = checkCostAndMembers(C, X, Y);

% Rm
my_load = L(L ~= 0); % extract load from L (only one nonzero value in L)
Rm = T / my_load;
Rm_membersOnly = Rm(1:size(C,2)); % no reaction forces in Rm

% make pcrit matrix
[Pcrits] = pcritCalc(memberLengths);

% critical member and W_failure for nominal, strong, weak
[critical_member, W_failure_nom, W_failure_strong, W_failure_weak] = buckme(Pcrits, Rm_membersOnly, memberLengths);

%% printing 
fprintf('\nLoad: %.3f oz\n', my_load);
fprintf('Member forces in oz\n');
for i = 1:size(C,2)
    if T(i) == 0
        fprintf('m%d: %.3f (0 force member)\n', i, abs(T(i)));
    elseif T(i) < 0
        fprintf('m%d: %.3f (C)\n', i, abs(T(i))); % we in compression
    else
        fprintf('m%d: %.3f (T)\n', i, T(i)); % we in tension
    end
end


fprintf('Reaction forces in oz:\n');
fprintf('Sx1: %.2f\n', T(size(C,2)+1));
fprintf('Sy1: %.2f\n', T(size(C,2)+2));
fprintf('Sy2: %.2f\n', T(size(C,2)+3));


fprintf('Cost of truss: $%0.2f\n', totalCost);
load_to_cost = abs(W_failure_nom) / totalCost;
fprintf('Theoretical max load/cost ratio in oz/$: %.4f\n', load_to_cost);
