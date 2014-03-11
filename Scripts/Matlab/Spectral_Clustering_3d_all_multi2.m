%warning takes 7 days, 7 hours
close all;clear all;
load PAS2050Cat.csv -ascii
qmin = ones(1,2);
qmax = zeros(1,2);
catInit = PAS2050Cat(:,1);
PAS = PAS2050Cat(:,2);
atuk = PAS2050Cat(:,3);
jay=12;
n = 13; % number of clusters
b0 = [1 2 3 4 5 6 7 8 9 10 11 12 13];
b = b0;
Disp(GetDate(clock))
File = ['q10klex' num2str(time(1)) num2str(time(2)) num2str(time(3)) num2str(time(4)) num2str(time(5)) '.txt'];
save (File, 'n', '-ascii')
perms = csvread('Perms10Lex.csv');
aTemp = zeros(365,365);
for i=1:365
    for j=1:365
        aTemp(i,j) = (PAS(i) -PAS(j))^2 + (atuk(i) -atuk(j))^2;
    end
end

a = zeros(365,365);
d = zeros(365,365);

% for adgnhd = 1:3
for loopCounter = 1:10000
    b = perms(loopCounter,:);
	%assign the value of a to the category using the initial assignement (1-13)
	for catInd = 1:length(catInit)
		cat(catInd) = b(b0==catInit(catInd));
    end
    
    a = zeros(365,365);
    d = zeros(365,365);

    w=0;
    for i = 1:365
        w=0;

        for j = 1:365
                a(i,j) = abs(sqrt(aTemp(i,j) + (cat(i) - cat(j))^2));
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

    vec3 = vec(:,1:n);
	for count = 1:5
        [cidx ctrs] = kmeans(vec3, n);

        counter = zeros(1,n);
        PASave = zeros(1,n);
        atukave =  zeros(1,n);
        catave =  zeros(1,n);

        %Assign centroids to each cluster
        %using average of cluster.
        for i=1:365
            PASave(cidx(i)) =  PASave(cidx(i)) + PAS(i);
            atukave(cidx(i)) = atukave(cidx(i)) + atuk(i);
        	catave(cidx(i)) = catave(cidx(i)) + cat(i);	
    		counter(cidx(i)) = counter(cidx(i)) + 1;  
        end % for

        centroid = zeros(n, 3);

        for j=1:n
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
	save (File, 'Q2', '-append', '-ascii')
    
    end % for count
	
	%move on to next iteration
% 	for i=1:622702
% 		[jay b] = findNextPerm(b, jay, n);
% 	end
% 	loopCounter = loopCounter + 1;
end

save(File, 'qmax', '-append', '-ascii')
save(File, 'qmin', '-append', '-ascii')
Disp(GetDate(clock))