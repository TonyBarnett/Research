b0 = [1 2 3 4 5 6 7 8 9 10 11 12 13];
b = [1 2 3 4 5 6 7 8 9 10 11 12 13];
jay=12;
n = 13;
save('perms2', 'b');
for l=1:10000
	
save ('perms2', 'b', '-append', '-ascii');

	for i=1:622702
		[jay b] = findNextPerm(b, jay, n);
	end
end