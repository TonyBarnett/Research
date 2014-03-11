function [SSE, IsEye] = IsEye (A, tolerance)
IsEye = 1;

I = eye(length(A));
for i=1:size(A, 1)
    for j = size (A,2)
        if A(i,j) > (I(i,j) + tolerance) || A(i,j) < (I(i,j) - tolerance)
            IsEye = 0;
        end
    end
% row-of-ones * (A-I)^2 * column-of-ones
SSE = ones(1, size(A,2)) * ((A - I).^2) * ones(size(A,1),1);

end
