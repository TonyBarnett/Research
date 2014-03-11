function [jout, aout] = findNextPerm(a, j, n)
	%find next permutation
	%L1

	
	%L2	
	j = n - 1;
	
	while ( a(j) >= a(j+1) )
		j = j - 1;
	end	
	
	%L3
	l = n;
	
	while (a(j) >= a(l))
		l = l - 1;
	end		
	
	x = a(l);
	a(l) = a(j);
	a(j) = x;

	%L4
	k = j + 1;
	l = n;
	
	while (k < l)
	
		x  = a(l);
		a(l) = a(k);
		a(k) = x;
		
		k = k + 1;
		l = l - 1;
		
	end
	aout = a;
	jout = j;
end