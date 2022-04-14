%%%
% This script shows an example of how to use the functions numWithinError.m
% and fitPropertyNumWithin.m
% This uses the HGP4 files, not HGP4_800

% written by WJS, 12/2021

%% first load in database files
load WISTFUL_rockType.mat
load WISTFUL_compositions_clean.mat
load WISTFUL_densities_clean.mat
load WISTFUL_speeds_moduli_clean.mat %you can replace this with wave speed files made by calculateWaveSpeedFiles.mlx

%% Let's search for the number of compositions within 0.5% error for Vp of 8.1 km/s and a Vs of 4.65 km/s at 2 GPa
Pwant=2e9;
VpFind=8.1;
VsFind=4.65;
allowedError=0.5;
constraints= mgnum>=0.86&isPeridotite';%Let's look at peridotites that have mgnum>0.86
    [tPlot, numWithin, Temp_numW, Temp_err_numW, foundIndices, errorAll] =...
        numWithinError(Pwant, [t(1) t(end)]-273.1, t, p, VsFind, allowedError, vs, constraints,VpFind, allowedError,vp);
%the result for this should be Temp_numW =  734.9181, Temp_err_numW =   64.6072

%% Let's look at the best fitting Mg # (temperature insensitive parameter)
% as well as the best fitting density (tempereature sensitive paramater).
[mgnumBest_numW, mgnumErr_numW] = fitPropertyNumWithin(Pwant, Temp_numW,t,p,tPlot,mgnum',foundIndices, errorAll);
%result should be mgnumBest_numW =    0.9096,mgnumErr_numW =0.0110
[densityBest_numW, densityErr_numW] = fitPropertyNumWithin(Pwant, Temp_numW,t,p,tPlot,rockDensity,foundIndices, errorAll);
%result should be densityBest_numW =   3.3124e+03, densityErr_numW =   20.3522

%% This plots the results of our search
figure(1); close; figure(1);
plot(tPlot,numWithin,'k','LineWidth',2)
set(gca,'LineWidth',2,'XColor','k','YColor','k','FontSize',18)
xlabel(['Temperature [' char(176) 'C]'])
ylabel('# of Samples Within Error')
grid on; box on;