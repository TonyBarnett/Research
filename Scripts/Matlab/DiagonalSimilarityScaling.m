% This is the first RAS algorithm printed in (Lahr2004)
function [A_twiddle] = DiagonalSimilarityScaling (A)
	A_twiddle = A;
    size = length(A);
	e = ones(size,1);
    for p = 1:100000
        index = 0;
        % m is a vector of rowsums - colSums
        row =  e' * A_twiddle;
        col = A_twiddle * e;
        m = row - col';
        index = find(abs(m)==max(abs(m)),1, 'first');
        alpha = sqrt(row(index) / col(index));
        
        % logically (realistically) you can loop over rows and columns 
        % at the same time because you only want a single row and a single 
        % column
        for i = 1:size
            if(i ~= index)
                A_twiddle(i, index) = A_twiddle(i, index) / alpha;
                A_twiddle(index, i) = A_twiddle(index, i) * alpha;
            end
        end
    end
end