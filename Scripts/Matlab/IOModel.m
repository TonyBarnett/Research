close all; clear all;
for year = 1997:2010
    % A_ij Spend from sector i -> sector j.
    A = csvread(strcat('Inputs\A', num2str(year), '.csv'))';

    % B_i Emissions from sector i.
    B = csvread(strcat('Inputs\B', num2str(year), '.csv'))';

    % F_i Total spend in sector i.
    F = csvread(strcat('Inputs\F', num2str(year), '.csv'));

    % B is actually supposed to be per unit spend, hence divide by F.
    % The rest is just scaling to take sectoral flows into accout.
    t = eye(length(B))-A;
    det(t)
    t = t ^ -1;
    t = t * F;
    x = B' .* t;
    file = strcat('VariableRecords\IOModel', num2str(year) ,'.csv')
    csvwrite(file,[(1:length(x))' x]);
end