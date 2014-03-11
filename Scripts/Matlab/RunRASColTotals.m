% I take about 3.25 hours to run, 
% I take a "best guess" and run RAS, DSS, cRAS and matlab's x=A\b thing for
% the years 1997 to 2010
close all;clear; % warning: "clear all" will clear breakpoints as well!

for year = 1997:2010
    disp(year);
    disp(GetDate(clock));
    
    tol = 0.00001;
    num_its = 100000;
    %%%%%%%%%%%%%%%%%%%%%% RAS %%%%%%%%%%%%%%%%%%%%%%
    disp(strcat('Running RAS: ', num2str(year)));
    disp(GetDate(clock));
    
    A = csvread(strcat('colTotal', num2str(year), '.csv'),1,1);
    col = A(65,1:64);
    row = A(1:64,65);
    A = A(1:64,1:64);

    [A_twiddle,~,~] = RAS(A, row, col, num_its, tol);
    csvwrite(strcat('output\colTotal_RAS_', num2str(year), '.csv'), A_twiddle);
    %%%%%%%%%%%%%%%%%%%%%% DSS %%%%%%%%%%%%%%%%%%%%%%
    A_twiddle = DiagonalSimilarityScaling(A);
    csvwrite(strcat('output\colTotal_DSS_', num2str(year), '.csv'), A_twiddle);

    %%%%%%%%%%%%%%%%%%%%%% MRAS %%%%%%%%%%%%%%%%%%%%%%
%   disp('Running MRAS');
%    disp(now);
%   A = csvread(strcat('colTotalMRAS', num2str(year), '.csv'),1,1);
%   row = A(65,1:64);
%   col = A(1:64,65);
%   A = A(1:64,1:64);
%   [A_twiddle R_hat S_hat] = RAS(A, row, col);
%   csvwrite(strcat('output\colTotal_MRAS_', num2str(year), '.csv'), R_hat * A_twiddle * S_hat);

    %%%%%%%%%%%%%%%%%%%%%% cRAS %%%%%%%%%%%%%%%%%%%%%%
    disp(strcat('Running cRAS: ', num2str(year)));
    disp(GetDate(clock));
    
    cons = csvread(strcat('C:\Dropbox\IO Model source data\SimEqFiles\cRASInputKnowns', num2str(year), '.csv'));
    totals = csvread(strcat('C:\Dropbox\IO Model source data\SimEqFiles\totalsKnowns', num2str(year), '.csv'));

    [A_twiddle R_hat S_hat, SSER, SSES] = cRAS(A, row, col, cons, totals, num_its, tol);
    csvwrite(strcat('output\colTotal_cRAS_', num2str(year), '.csv'), A_twiddle);
    csvwrite(strcat('output\colTotal_cRAS_SSER_', num2str(year), '.csv'), SSER);
    csvwrite(strcat('output\colTotal_cRAS_SSES_', num2str(year), '.csv'), SSES);

    %%%%%%%%%%%%%%%%%%%%%% Matlab's best guess %%%%%%%%%%%%%%%%%%%%%%
    disp(strcat('Matlab is now having its best guess: ', num2str(year)));
    disp(GetDate(clock));
    
    totals = csvread(strcat('C:\Dropbox\IO Model source data\SimEqFiles\totalsUnknowns', num2str(year), '.csv'));
    unknowns = csvread(strcat('C:\Dropbox\IO Model source data\SimEqFiles\outputUnknowns', num2str(year), '.csv'));
    
    csvwrite(strcat('output\colTotal_MatlabGuess_', num2str(year), '.csv'), unknowns \ totals');
end