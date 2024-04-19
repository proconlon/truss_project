%% truss matrix setup
% Saves the truss design to the .mat file specified at the end. 
% change name of file as needed

% connection matrix is 1 if there is a connection at that joint
% rows are joints
% cols are members
C = [1 1 1 0 0 0 0 0 0 0 0 0 0 0 0;
     1 0 0 1 1 0 0 0 0 0 0 0 0 0 0;
     0 1 0 1 0 1 0 0 0 0 0 0 0 0 0;
     0 0 0 0 1 0 1 1 0 0 0 0 0 0 0;
     0 0 1 0 0 1 1 0 1 1 0 0 0 0 0;
     0 0 0 0 0 0 0 1 1 0 1 0 0 1 0;
     0 0 0 0 0 0 0 0 0 1 1 1 1 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 1;
     0 0 0 0 0 0 0 0 0 0 0 1 0 0 1];

% cols sum to 2 (down)
% rows sum to number of members attached to a joint (across)

% support matrices (only 3 ones total for 3 unknown support rxns)
%  Sx1, Sy1, Sy2
Sx = [1 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0];


Sy = [0 1 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 0;
      0 0 1];

% joint coords
X = [0; 0; 7; 9; 13; 18; 20; 27; 31];
Y = [0; 11; 8; 13; 0; 13; 0; 9; 0];

% load vector
my_load = 32; % arbitrary
% create an empty load vector ( size(C,1) is j)
L = zeros(2*size(C,1), 1); 

% Only one live load at joint 4
% (numJoints + j_load) replace the +4 with the number of the joint
L(size(C,1)+5) = my_load;  % my_load oz at joint 4 !!!!!!!!!!!!!!!change as needed

save('Truss Design 2.mat', 'C', 'Sx', 'Sy', 'X', 'Y', 'L');
