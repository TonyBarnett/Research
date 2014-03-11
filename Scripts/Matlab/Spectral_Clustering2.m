close all;clear all;
PAS2050 = csvread('PAS2050.csv');
PAS = PAS2050(:,1);
atuk = PAS2050(:,2);
ra = zeros(365,365);
rp = zeros(365,365);
d = zeros(365,365);
a = zeros(365,365);
Q(1) = 0;
output = 0;
cOutput=0;
dlmwrite('Spectral_Clustering2.csv',Q(1))
for outerLoop = 1:100
	% fail = 0;
	for i=1:365
		 w=0;
		 for j=1:365
			 if i < j
				 ra(i,j) = atuk(j) / atuk(i);
				 rp(i,j) = PAS(j) / PAS(i);
             else
                 if i == j
					ra(i,j) = 1;
                    rp(i,j) = 1;
                else
					ra(i,j) = atuk(i) / atuk(j);
					rp(i,j) = PAS(i) / PAS(j);
                end
			 end

			 a(i, j) = abs(ra(i, j) - rp(i, j));
			 % a(i, j) = a(i,j) / ra(i,j);
			 if a(i, j) >= 0
				 w = w + a(i,j);
				 %w=w+1;
			 % else
				 % fail = fail + 1;
			  end
		 end
		 d(i,i) = w;
	end
	w=0;
	L=d-a;
	[v e] = eig(L);

	v2 = v(1:2,:)';

    if output == 0
        output = [v2(:,1) v2(:,2)];
    end
   
	x = zeros(1,20);
	y = -1:0.1:1;
   
	[cidx ctrs2] = kmeans(v2, 2);

	counter = zeros(1,2);
	PASave = zeros(1,2);
	atukave =  zeros(1,2);
	
    for i=1:365

        if cidx(i) == 1
            PASave(1) =  PASave(1) + PAS(i);
            atukave(1) = atukave(1) + atuk(i);
            counter(1) = counter(1) + 1;
		
        elseif cidx(i) == 2
            PASave(2) =  PASave(2) + PAS(i);
            atukave(2) = atukave(2) + atuk(i);
            counter(2) = counter(2) + 1;
		
        end %if
		
    end % for

	centroid = zeros(3, 3);

	for i=1:2
		centroid(i,1) = PASave(i) / counter(i);
		centroid(i,2) = atukave(i) / counter(i);
	end

  			% x, y, 'k-',...
			% -1:1,0,'k-',...
    blah = modularity(a, cidx, centroid);
    testQ = 0;
    for qTest = 1:length(Q)
        if Q(qTest) == blah
            testQ = testQ + 1;
        end
    end
    
    if testQ == 0
        output = [output, cidx];
         Q(length(Q) + 1) = blah;
%         figure;
%         plot(atuk(cidx==1),PAS(cidx==1),'r.', ...
%              atuk(cidx==2),PAS(cidx==2),'b.', ...
%              ctrs2(:,1),ctrs2(:,2),'kx');
          figure;
          plot(v2(cidx==1, 1),v2(cidx==1, 2),'r.', ...
              v2(cidx==2, 1),v2(cidx==2, 2),'b+', ...
              ctrs2(:,1),ctrs2(:,2),'kx');
%          title('spectral clustering, 2 clusters');
%          xlabel('coordinate of eigenvector 1');
%          ylabel('coordinate of eigenvector 2');
    end
end
Q(2:length(Q))
dlmwrite('variables\Spectral_Clustering2.csv', output')
dlmwrite('C:\Dropbox\python\variables\Spectral_Clustering2.csv', output')
 