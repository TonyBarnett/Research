close all;clear all;
temp = csvread('PAS2050AtUk1-1Mapping.csv');
atuk = temp(:, 1);
PAS2050 = temp(:,2);
figure
plot(atuk, PAS2050, 'k.');

i = [0:15];
lbf = polyfit(atuk, PAS2050, 1)
hold on;
lines = lbf(1) * i + lbf(2);
plot(0:15, lines, 'r');
title('A comparison between the @UK plc footprint and the PAS2050 footprint using mean as grouping');
xlabel('@UK plc footprint (kgco2e)');
ylabel('PAS2050 footprint (kgco2e)');

rsquared = rSquared(atuk, PAS2050)


temp = csvread('PAS2050AtUk1-1MappingMedian.csv');
atuk = temp(:, 1);
PAS2050 = temp(:,2);
figure
plot(atuk, PAS2050, 'k.');

i = [0:15];
lbf = polyfit(atuk, PAS2050, 1);
hold on;
lines = lbf(1) * i + lbf(2);
plot(0:15, lines, 'r');
title('A comparison between the @UK plc footprint and the PAS2050 footprint using median as grouping');
xlabel('@UK plc footprint (kgco2e)');
ylabel('PAS2050 footprint (kgco2e)');
rsquared = rSquared(atuk, PAS2050)
