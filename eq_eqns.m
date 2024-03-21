% somehow make the equations

function [A, L] = eq_eqns(C, Sx, Sy, X, Y, L)
    % x,y are the num of joints and num of members
    [numJoints, numMembers] = size(C);

    % create A matrix of proper size in zeros
    A = zeros(2*numJoints, numMembers + 3);

    % go thru entire C matrix looking for 1s
    for joint = 1:numJoints
        for member = 1:numMembers
            if C(joint, member) == 1 % ie if connected at this point
                % important! have to find the other joint which is connected to
                % that member (meaning the other 1 in that col)
                otherJoint = find(C(:, member) & (1:numJoints)' ~= joint);
                
                % direction cosines for the current member 
                deltaX = X(otherJoint) - X(joint);
                deltaY = Y(otherJoint) - Y(joint);
                memberLen = sqrt(deltaX^2 + deltaY^2);
                cosTheta = deltaX / memberLen; % exactly same calculation as on the manual
                sinTheta = deltaY / memberLen;
                
                % now add both to A matrix
                A(joint, member) = cosTheta; % Contribution to sum of forces in x-direction
                A(joint + numJoints, member) = sinTheta; % sum of F_y has to be offset by numJoints to match A's format
            end
        end
        
        % only 1 sx support rxn below, add it to A matrix
        if Sx(joint)
            A(joint, numMembers+1) = 1; % adds to numMembers+1 col since thats where Sx goes in x component of A
        end

        % there are 2 Sy support rxns added to last 2 cols
        for k = 1:3
            if Sy(joint, k) == 1
                A(joint+numJoints, numMembers+k) = 1;  % adds needed 1 where its supposed to be in y component of A
            end
        end

    end

end
