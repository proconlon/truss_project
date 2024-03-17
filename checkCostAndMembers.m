% function that checks cost, member/joints 

function [totalCost, totalLength] = checkCostAndMembers(C, X, Y)
    % length of each member in an array (zeros for now)
    memberLengths = zeros(size(C,2), 1);

    % go thru every member (col) -- to find member lens
    for i = 1:size(C,2)
        joints = find(C(:,i)); % Find the joints connected to that member and save to joints
        if length(joints) == 2 % if there are two joints connected then you are good
            diffx = X(joints(2)) - X(joints(1)); 
            diffy = Y(joints(2)) - Y(joints(1));
            memberLengths(i) = sqrt(diffx^2 + diffy^2); % add the length of the member to the memberLengths array
        else
            fprintf('member %d is not connected to two joints!!!!!!!!!!!!!!! wtf are you doing!!!!!!!!!!!!!!!!!\n', i);
        end
    end

    totalLength = sum(memberLengths); % Total length of all members
    numJoints = size(C,1); % Total number of joints

    % total cost
    totalCost = 10 * numJoints + totalLength;

    % print if the cost is ok
    if totalCost > 300
        fprintf('cost exceeds the limit: $%0.2f > $300\n', totalCost);
    else
        fprintf('cost is within the limit: $%0.2f <= $300\n', totalCost);
    end

    % check member/joint ratio
    % M = 2J - 3
    if size(C,2) > 2 * size(C,1) - 3
        fprintf('too many members!: %d > %d\n', size(C,2), 2 * size(C,1) - 3);
    else
        fprintf('members within range: %d <= %d\n', size(C,2), 2 * size(C,1) - 3);
    end

end
