% truss matrix setup

%% connection matrix is 1 if there is a connection at that joint
% rows are joints
% cols are members
C = [1 1 1 1 1 0 0;
     1 1 1 0 1 1 0;
     0 0 0 1 0 0 0;
     0 0 0 0 0 0 1;
     0 0 0 0 0 1 1];

% cols sum to 2 (down)
% rows sum to number of members attached to a joint (across)

%% support matrices (only 3 ones total for 3 unknown support rxns)
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

%% joint coords
% 
X = [0; 1; 2; 3; 4];
Y = [0; 1; 0; 30; 0];

%% load vector
% create an empty load vector ( 5 is j)
L = zeros(2*5, 1); 

% Only one load at joint 8
% j+x --> x is the y joint: so joint 3 in y direction you put the load at L(8)
L(8) = 15;  % 15 lb at joint 3


%% check cost and member/joint reqs
[totalCost, totalLength] = checkCostAndMembers(C, X, Y);

% generate eq eqns
[A, L] = eq_eqns(C, Sx, Sy, X, Y, L);
