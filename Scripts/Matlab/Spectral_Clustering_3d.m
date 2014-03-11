close all;clear all;
load PAS2050Cat.csv -ascii
cat = PAS2050Cat(:,1);
PAS = PAS2050Cat(:,2);
atuk = PAS2050Cat(:,3);

% figure;
% plot(PAS((cat==1)),atuk((cat==1)) , 'rx',...
% 	PAS((cat==2)),atuk((cat==2)) , 'gx',...
% 	PAS((cat==3)),atuk((cat==3)) , 'bx',...
% 	PAS((cat==4)),atuk((cat==4)) , 'kx',...
% 	PAS((cat==5)),atuk((cat==5)) , 'r.',...
% 	PAS((cat==6)),atuk((cat==6)) , 'g.',...
% 	PAS((cat==7)),atuk((cat==7)) , 'b.',...
% 	PAS((cat==8)),atuk((cat==8)) , 'k+',...
% 	PAS((cat==9)),atuk((cat==9)) , 'r*',...
% 	PAS((cat==10)),atuk((cat==10)) , 'b*',...
% 	PAS((cat==11)),atuk((cat==11)) , 'g*',...
% 	PAS((cat==12)),atuk((cat==12)) , 'k*',...
% 	PAS((cat==13)),atuk((cat==13)) , 'k.'...
% 	);
% 
% xlabel('PAS footprint');
% ylabel('@uk footirnt');

a = zeros(365,365);
d = zeros(365,365);
for i = 1:365
w=0;
	for j = 1:365
	a(i,j) = abs(sqrt(PAS(i)^2 + atuk(i)^2 + cat(i)^2) - sqrt(PAS(j)^2 + atuk(j)^2 + cat(j)^2));
	if a(i,j) > 1
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
%figure;
% plot(PAS((cidx==1)),atuk((cidx==1)) , 'r.',...
	% PAS((cidx==2)),atuk((cidx==2)) , 'g.',...
	% PAS((cidx==3)),atuk((cidx==3)) , 'b.'...
	% );
% plot3(PAS(cidx==1), atuk(cidx==1), cat(cidx==1), 'r.',...
% 	PAS(cidx==2), atuk(cidx==2), cat(cidx==2), 'b.',...
% 	PAS(cidx==3), atuk(cidx==3), cat(cidx==3), 'g.',...
% 	ctrs(:,1), ctrs(:,2), ctrs(:,3),'kx'...
% 	);
% 	xlabel('PAS');
% 	ylabel('@UK');
% 	zlabel('cat');
% title('Spectral clustering, 3 clusters');

Q = modularity(a, cidx, ctrs)

output = [PAS, atuk, cat, cidx];


dlmwrite('variables\Spectral_Clustering_3d.csv', output')
dlmwrite('C:\Dropbox\python\variables\Spectral_Clustering_3d.csv', output')
