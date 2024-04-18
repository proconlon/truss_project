% calculates pcrits and returns the matrix
function Pcrit = pcritCalc(memberLengths)
    % pcrit matrix
    Pcrit = zeros(length(memberLengths), 1);

    % Calculate Pcrit for each member
    for i = 1:length(memberLengths)
        Pcrit(i) = 3054.789 * (memberLengths(i)^(-2.009));
    end
end
