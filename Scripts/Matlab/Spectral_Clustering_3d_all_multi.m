close all;clear all;
load PAS2050Cat.csv -ascii
qmin = ones(1,2);
qmax = zeros(1,2);
catInit = PAS2050Cat(:,1);
PAS = PAS2050Cat(:,2);
atuk = PAS2050Cat(:,3);
jay=12;
n = 13;
b0 = [1 2 3 4 5 6 7 8 9 10 11 12 13];
b = b0;
loopCounter = 0;
save ('q10klex.txt', '-ascii')
% for adgnhd = 1:3
while loopCounter<10000
	%assign the value of a to the category using the initial assignement (1-13)
	for catInd = 1:length(catInit)
		cat(catInd) = b(b0==catInit(catInd));
	end
	for count = 1:5
        a = zeros(365,365);
        d = zeros(365,365);

        for i = 1:365
            w=0;

            for j = 1:365
                a(i,j) = abs(sqrt((PAS(i) -PAS(j))^2 + (atuk(i) -atuk(j))^2 + (cat(i) - cat(j))^2));
                if a(i,j) > 2
                    a(i,j) = 0;
                end
                if a(i,j)>=0
                    w=w+a(i,j);
                end
            end % j
            d(i,i) = w;
        end % i
        L=d-a;

        [vec val] = eig(L);

        vec3 = vec(:,1:3);
        [cidx ctrs] = kmeans(vec3, 3);

        counter = zeros(1,3);
        PASave = zeros(1,3);
        atukave =  zeros(1,3);
        catave =  zeros(1,3);

        %Assign centroids to each cluster
        %using average of cluster.
        for i=1:365
            PASave(cidx(i)) =  PASave(cidx(i)) + PAS(i);
            atukave(cidx(i)) = atukave(cidx(i)) + atuk(i);
        	catave(cidx(i)) = catave(cidx(i)) + cat(i);	
    		counter(cidx(i)) = counter(cidx(i)) + 1;  
        end % for

        centroid = zeros(3, 3);

        for j=1:3
            for i=1:3
                centroid(i,j) = PASave(i) / counter(i);			
            end
        end

        Q = modularity(a, cidx, centroid);



        Q2 = [loopCounter Q b];
        if Q < qmin(2)
            qmin = Q2;
        end

        if Q > qmax(2)
            qmax = Q2;
        end
	save ('q10klex.txt', 'Q2', '-append', '-ascii')
    
    end % for count
	
	%move on to next iteration
	for i=1:622702
		[jay b] = findNextPerm(b, jay, n);
	end
	loopCounter = loopCounter + 1;
end

save('q10klex.txt', 'qmax', '-append', '-ascii')
save('q10klex.txt', 'qmin', '-append', '-ascii')