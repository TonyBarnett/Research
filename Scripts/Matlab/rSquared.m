function [rSquared] = rSquared(X, Y)

lbf = polyfit(X, Y, 1);

sse=0;
Yt = 0;

for j=1:length(Y)
	sse = sse + (Y(j) - (lbf(1) * X(j) + lbf(2)))^2;
	
	Yt = Yt + Y(j);
end
Yt = Yt/length(Y);
error=0;

for j=1:length(Y)
	error = error + (Y(j) - Yt)^2;
end
yMinusYHat = sse;
yMinusYBar = error;

rSquared = 1 - (yMinusYHat / yMinusYBar);

end