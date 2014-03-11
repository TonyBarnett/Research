close all;clear all;
data = csvread('PriceVarianceMat.csv');
price = data(:,3);

Intensity76 = data(:,6);
range = 0:0.01:1;
PAS = data(:,8);
k=1;
rsquared76 = zeros(length(range),1);
ratio = zeros(length(range),1);
for variance = 0:0.01:1
	atuk76= Intensity76;

	atuk76MinusV = atuk76 - atuk76 * variance;
	atuk76PlusV = atuk76;

	atukClosest = zeros(length(PAS), 1);

	for i=1:length(PAS)
		if PAS(i) > atuk76PlusV(i)
			atukClosest(i) = atuk76PlusV(i);			
		else
			if PAS(i) < atuk76MinusV(i)
				atukClosest(i) = atuk76MinusV(i);
			else
				atukClosest(i) = PAS(i);
                ratio(k) = ratio(k) + 100/length(PAS);
			end
		end
	end
	
	rsquared76(k) = rSquared(atukClosest, PAS);
	
	k=k+1;
end
thingy = [(range);rsquared76'];
thingy2 = [(range);ratio'];

csvwrite('variables\priceCompare6.csv', thingy);
csvwrite('C:\Dropbox\python\variables\priceCompare6.csv', thingy);

csvwrite('variables\priceCompare6_ratio.csv', thingy2);
csvwrite('C:\Dropbox\python\variables\priceCompare6_ratio.csv', thingy2);

% plot(range, rsquared76 * 100, 'r.');
% hold on;
% plot(range, ratio, 'g.');