close all;clear;
output = csvread(strcat('E1997.csv'));
output = [0; output(:,1)];

for year = 1997:2010
    U = csvread(strcat('U', num2str(year), '.csv'));
    V = csvread(strcat('V', num2str(year), '.csv'));
    V = V';
    E = csvread(strcat('E', num2str(year), '.csv'));
    E=E(:,2); % E has the category system as an index, this removes it.
    Y = csvread(strcat('Y', num2str(year), '.csv'));
%     g = ones(1, length(U)) * U;
%     q = (U * ones(length(U), 1))';    
%     g(g==0) = 1; % we set totals to 1 if they're 0 
%     q(q==0) = 1; % so we can divide by them.
%     gt = diag(g);
%     qt = diag(q);
%     A = gt\U;
%     B = qt\V;
%     
%     Astar = [
%         zeros(length(A)), A;
%         B,                zeros(length(B))
%     ];
% 
%     Ystar = [Y;zeros(length(Y),1)];
%     %gstar = [q;g];
%     t = eye(length(Astar)) - Astar;
%     I = t \ Ystar;
%     length(E)
%     E = [E;zeros(length(E), 1)];
%     I = E./I;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    g = V * ones(length(V), 1);
    q = ((U * ones(length(U), 1)) + Y)';

    g(g==0) = 1; % we set totals to 1 if they're 0 
    q(q==0) = 1; % so we can divide by them. 
                 % This works because if the sum of a row is 0 then each
                 % element is 0 and we assume then that the scaled version
                 % (i.e. B or D) will be 0, however 0/0=#NaN, 
                 % whereas 0/1=0.

    B = U / diag(g);
    D = V / diag(q);

    % A = D * B;
    A = B * D;
    L = eye(length(A)) - A;
    t = (eye(length(A)) - A) * Y;
    I = E ./ (t);
    I= [year;I];
    output = [output I];

end

csvwrite(strcat('Intensities.csv'), output);