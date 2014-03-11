% This is the first RAS algorithm printed in (Lahr2004)
function [A_twiddle R_hat S_hat] = RAS (A, row_sum, col_sum, number_of_iterations, tol)
	A_twiddle = A;
	e = ones(length(A),1);
    
    if(nargin < 5)
        tol=0.00001;
    end
    if (nargin < 4)
        number_of_iterations = 100000;
    end
    IsR = 0;
    IsS = 0;
    p = 1;
	while (IsR + IsS) < 2 && p < number_of_iterations + 1
        % Row scaling
		R_hat = diag(row_sum) / diag(A_twiddle * e);
		temp = R_hat * A_twiddle;
		
        % Column scaling
            % Minor correction, in the paper this is a multiply but 
            % it should be a divide (IMHO).
		S_hat = diag(col_sum) / diag(e' * temp);
        A_twiddle = temp * S_hat;
        
        p=p+1;
        
        [~,IsR] = IsEye(R_hat, tol);
        [~,IsS] = IsEye(S_hat, tol);
	end

end