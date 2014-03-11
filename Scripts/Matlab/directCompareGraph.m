close all;clear all;

load PAS2050.csv
PAS = PAS2050(:,1);
atuk = PAS2050(:,2);

line1 = polyfit(atuk, PAS, 1);

i = -2:15;
lines = line1(1) * i + line1(2);
% 
% figure;
% plot(atuk, PAS, 'k.');
% hold on;
% 
% plot(i, lines, 'r');
% title('A comparison between the @UK footprint and the PAS2050 footprint','fontSize',12);
% xlabel('@UK footprint (kgco2e)','fontSize',12);
% ylabel('PAS2050 footprint (kgco2e)','fontSize',12);

% rsquared = rSquared(atuk, PAS)

poly=[i; lines]

csvwrite('variables\directCompareGraph.csv', [atuk'; PAS']);
csvwrite('C:\Dropbox\python\variables\directCompareGraph.csv', [atuk'; PAS']);

csvwrite('variables\directCompareGraph_polyFit.csv', poly);
csvwrite('C:\Dropbox\python\variables\directCompareGraph_polyfit.csv', poly);