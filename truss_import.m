%% truss matrix setup

% connection matrix is 1 if there is a connection at that joint
% rows are joints
% cols are members
C = [1 1 0 0 0 0 0;
     1 0 1 0 1 1 0;
     0 1 1 1 0 0 0;
     0 0 0 1 1 0 1;
     0 0 0 0 0 1 1];

% cols sum to 2 (down)
% rows sum to number of members attached to a joint (across)

% support matrices (only 3 ones total for 3 unknown support rxns)
%  Sx1, Sy1, Sy2
Sx = [1 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0];

Sy = [0 1 0; 
      0 0 0; 
      0 0 0;
      0 0 0;
      0 0 1];

% joint coords
X = [0; 1; 2; 3; 4];
Y = [0; 1; 0; 3; 0];

% load vector
my_load = 15; % arbitrary
% create an empty load vector ( size(C,1) is j)
L = zeros(2*size(C,1), 1); 

% Only one live load at joint 2
% (numJoints + j_load) replace the joint where the load is at
L(size(C,1)+2) = my_load;  % my_load oz at joint 2 !!!!!!!!!!!!!!!change as needed

%% calculations

% generate eq eqns
[A, L] = eq_eqns(C, Sx, Sy, X, Y, L);

% solve for member forces and the 3 reaction forces
% T is in this format: [ T_1-m, S_x1, S_y2, S_y2 ]
T = A \ L; 

% check cost and member/joint reqs
[totalCost, totalLength, memberLengths] = checkCostAndMembers(C, X, Y);

% Rm
Rm = T / my_load;
Rm_membersOnly = Rm(1:size(C,2)); % no reaction forces in Rm

% make pcrit matrix
[Pcrits] = pcritCalc(memberLengths);

% critical member and max theoretical load
[critical_member, W_failure_min] = buckme(Pcrits, Rm_membersOnly, memberLengths);

%% printing 
fprintf('EK301, Section A2, Group 2: Kailan Pan, James Conlon, Austin Zhang 4/5/2024');
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
load_to_cost = abs(W_failure_min) / totalCost;
fprintf('Theoretical max load/cost ratio in oz/$: %.4f\n', load_to_cost);


