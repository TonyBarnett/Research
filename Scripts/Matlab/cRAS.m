% This is the cRAS algorithm described by (Lenzen2006)
% The plan is to have con_cells be a matrix whose rows are conditions
% (padded with 0's) and each cell is 1000*colIndex + rowIndex
% the tolerance is 1 +- tol, a normal value would be 0.0000001
function [A_twiddle R_hat S_hat, SSER, SSES] = cRAS (A, row_sum, col_sum, con_cells, con_totals, number_of_iterations, tol)
	A_twiddle = A;
    IsR = 0;
    IsS = 0;
    p = 1;
    SSER = [];
    SSES = [];

    if(nargin < 7)
        tol=0.00001;
    end

    if(nargin < 6)
        number_of_iterations = 100000;
    end
    
    while (IsR + IsS) < 2 && p < number_of_iterations % and the R, S, and constraints are close to I within the tolerance
        
        [A_twiddle R_hat S_hat] = RAS (A_twiddle, row_sum, col_sum, 1, tol);

        % now we get onto the "c" part, for each constraint we multiply
        % each cell by a scaling factor, the scaling factor is the 
        % required total for those cells divided by the sum of the cells.
        %dbstop('in','cRAS.m','at', '26')
        for i = 1:length(con_totals)
            
            temp = con_cells(i, con_cells(i,:) ~= 0);

            y = floor(temp / 1000); % floor = round down to an integer
            x = rem(temp, 1000); % rem = remainder
            total = 0;
			
            for j = 1:length(temp) % Sum over all elements of constraint i.
                total = total + A_twiddle(x(j), y(j));
            end
            
            if con_totals(i) == 0
                disp(con_totals)
            end
            if total == 0
                disp('Total is 0')
            end
            
            total = con_totals(i) / total; % calculate scaling factor i.
            
            for j = 1:length(temp)
                A_twiddle(x(j), y(j)) = A_twiddle(x(j), y(j)) * total; % scale each element of constraint by scaling factor
            end
            
        end
        
        [SSER(p), IsR] = IsEye(R_hat, tol); %#ok<*AGROW>
        
        [SSES(p), IsS] = IsEye(S_hat, tol);
        
        p = p + 1;
    end
end