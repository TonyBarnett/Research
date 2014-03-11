close all;clear all;
data = csvread('PriceVarianceMat.csv');
price = data(:,3);

Intensity76 = data(:,6);
Intensity123 = data(:,7);
range = 1:0.1:10;
PAS = data(:,8);
k=1;
fontSize = 14;
rsquared76 = zeros(length(range),1);
ratio = zeros(length(range),1);
rsquared123 = zeros(length(range),1);
for variance = range
	atuk76= Intensity76;
	atuk123 = Intensity123;

	atuk76MinusV = atuk76 * (1 / variance);
	atuk76PlusV = atuk76 * variance;

	atuk123MinusV = atuk123 * (1 / variance);
	atuk123PlusV = atuk123 * variance;

	atukClosest = zeros(length(PAS), 1);

	for i=1:length(PAS)
		if PAS(i) > atuk76PlusV(i)
			atukClosest(i) = atuk76PlusV(i);			
		else
			if PAS(i) < atuk76MinusV(i)
				atukClosest(i) = atuk76MinusV(i);
			else
				atukClosest(i) = PAS(i);
			end
		end
	end
	
	rsquared76(k) = rSquared(atukClosest, PAS);
	
	
	for i=1:length(PAS)
		if PAS(i) > atuk123PlusV(i)
			atukClosest(i) = atuk123PlusV(i);
		else
			if PAS(i) < atuk123MinusV(i)
				atukClosest(i) = atuk123MinusV(i);
			else
				atukClosest(i) = PAS(i);
                ratio(k) = ratio(k) + 1/3.65;
			end
		end
	end
	
	rsquared123(k) = rSquared(atukClosest, PAS);
	k=k+1;
end
thingy = [(range); rsquared76'];
thingy2 = [(range); ratio'];

csvwrite('variables\priceCompare4.csv', thingy);
csvwrite('C:\Dropbox\python\variables\priceCompare4.csv', thingy);

csvwrite('variables\priceCompare4_ratio.csv', thingy2);
csvwrite('C:\Dropbox\python\variables\priceCompare4_ratio.csv', thingy2);
% h = figure('visible', 'off');
% plot(range, rsquared76, 'r.', 'FontSize', fontSize);
% xlabel('n', 'FontSize', fontSize);
% ylabel('R^2', 'FontSize', fontSize);
% title('The effect of varying range of @UK footprints on correlation of footprints', 'FontSize', fontSize);
% print(h,'-dpng', '-r96','Figures\AtPASPriceCompare.png')
% h = figure('visible', 'off');
% plot(range, ratio, 'r.');
% xlabel('n', 'FontSize', fontSize);
% ylabel('percent of products for which u''_i = p_i', 'FontSize', fontSize);
% title('Percent of products for which u''_i = p_i for different values of n', 'FontSize', fontSize);
% print(h,'-dpng', '-r96','Figures\AtPASPriceCompareRatio.png')