close all;clear all;
rankDat = csvread('rankData.csv');

atuk = rankDat(:,1);
aIndex = rankDat(:,2);
pas = rankDat(:,3);
pIndex = rankDat(:,4);
rankatuk = rankDat(:,6);
rankPas = rankDat(:,7);
rankDif = rankDat(:,9);

csvwrite('variables\ranked.csv', [rankatuk';rankPas']);
csvwrite('C:\Dropbox\python\variables\ranked.csv', [rankatuk';rankPas']);

% plot(rankatuk, rankPas, 'k.');
% hold on;
% plot(0:400, 0:400);
% title('Ranked @UK footprints versus ranked PAS2050 footprints');
% xlabel('@UK footprints ranked');
% ylabel('PAS2050 footprints ranked');
