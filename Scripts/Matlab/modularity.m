function [Q] = modularity(A, assignment, centroids)

	m = 0;
	w=zeros(1,365);
	for i=1:365
		for j=1:365
			if A(i,j) > 0.2
				A(i,j) = 1;
			else
				A(i,j) = 0;
			end
			w(i) = w(i) + A(i,j);
		end
		m = m + w(i);
	end
	
	%m = m/2;
	
	%           A [i, j]      (w[i]) * (w[j])
	%Q = SUM ( -----------  -  --------------- )
	%              2m              (2m)^2
	%
	%where m is number of connections
	%w is number of connections on a row
	%A is similarity matrix.
	%
	
Q = 0;
	for i = 1:365
		for j = 1:365
		if assignment(i) == assignment(j)
			Q = Q + (A(i,j) / (2 * m)) - ((w(i) * w(j)) / (4 * m * m));
		end			
		end
	end
end