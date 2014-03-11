function[matrix, sortedIndex] = sortMatrix(matrix, index)
% sort matrix by index column
% based on bubble sort algorithm
%matrix is re-ordered matrix
%sortedIndex is position of original elements

	sortedIndex = 1:length(matrix);
	initMatrix = matrix;
	
%don't run if index outside bound of array
	%counter to determine whether ordered
	ordered = 1;


	while ordered != 0
		for j = 1:length(matrix) - 1
			if matrix(j, index) > matrix(j + 1, index)
				x = matrix(j + 1, :);
				matrix(j + 1, :) = matrix(j, :);
				matrix(j, :) = x;
				
				x = sortedIndex(j + 1);
				sortedIndex(j + 1) = sortedIndex(j);
				sortedIndex(j) = x;
			end
		end		
	
	
		%retest if array is in order
		ordered = 0;
		for j = 1:length(matrix) - 1
			if matrix(j, index) > matrix(j + 1, index)
				ordered = ordered + 1;
			end
		end			
	end
end