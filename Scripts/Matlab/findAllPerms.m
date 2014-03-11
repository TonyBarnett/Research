% close all;clear all;
% load PAS2050Cat.csv -ascii
% cat = PAS2050Cat(:,1);
a = [1 2 3 4 5 6 7 8 9 10 11 12 13];
n = 13;
counter = 0;
output = [counter a];
	save a.txt 'null'
jay = n-1;
while jay ~= 0
	%find next permutation
	%L1
	counter = counter + 1;
	output = [counter a];
	save -append a.txt output	
	%L2	
	jay = n - 1;
	
	while ( a(jay) >= a(jay+1) )
		jay = jay - 1;
	end	
	
	%L3
	el = n;
	
	while (a(jay) >= a(el))
		el = el - 1;
	end		
	
	x = a(el);
	a(el) = a(jay);
	a(jay) = x;

	%L4
	kay = jay + 1;
	el = n;
	
	while (kay < el)
	
		x  = a(el);
		a(el) = a(kay);
		a(kay) = x;
		
		kay = kay + 1;
		el = el - 1;
		
	end 
	
end