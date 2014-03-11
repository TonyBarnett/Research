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
	atuk76PlusV = atuk76 + atuk76 * variance;

	atukClosest = zeros(length(PAS), 1);

	for i=1:length(PAS)
		if PAS(i) > atuk76PlusV(i)
			atukClosest(i) = atuk76PlusV(i);			
		else
			if PAS(i) < atuk76MinusV(i)
				atukClosest(i) = atuk76MinusV(i);
			else
				atukClosest(i) = PAS(i);
                ratio(k) = ratio(k) + 1/3.65;
			end
		end
	end
	
	rsquared76(k) = rSquared(atukClosest, PAS);
	
	k=k+1;
end
thingy = [(range);rsquared76'];
thingy2 = [(range);ratio'];

csvwrite('variables\priceCompare5.csv', thingy);
csvwrite('C:\Dropbox\python\variables\priceCompare5.csv', thingy);

csvwrite('variables\priceCompare5_ratio.csv', thingy2);
csvwrite('C:\Dropbox\python\variables\priceCompare5_ratio.csv', thingy2);
