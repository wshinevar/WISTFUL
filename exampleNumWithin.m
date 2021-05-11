%%%
% This script shows an example of how to use the functions fitClosestX.m
% and fitPropertyClosestX.m

% written by WJS, 5/2021

%% first load in database files
% load WISTFUL_rockType.mat
% load WISTFUL_compositions_clean.mat
% load WISTFUL_densities_clean.mat
% load WISTFUL_speeds_moduli_clean.mat %you can replace this with wave speed files made by calculateWaveSpeedFiles.mlx
% 
%% Let's search for the closest 100 compositions for Vp of 8 km/s and a Vs of 4.7 km/s at 2 GPa with 0.5% error
X=100;%Let's search for the 100 closest
Pwant=2;
VpFind=8;
VsFind=4.7;
allowedError=0.5;
constraints= mgnum>=0.86&isPeridotite';%Let's look at peridotites that have mgnum>0.86
    [tPlot, numWithin, Temp_numW, Temp_err_numW, foundIndices, errorAll] =...
        numWithinError(Pwant, [t(1) t(end)]-273.1, t, p, VsFind, allowedError, vs, constraints,VpFind, allowedError,vp);

%% Let's look at the best fitting Mg # (temperature insensitive parameter)
% as well as the best fitting density (tempereature sensitive paramater).
[mgnumBest_numW, mgnumErr_numW] = fitPropertyNumWithin(Pwant, Temp_numW,t,p,tPlot,mgnum',foundIndices, errorAll);
[densityBest_numW, densityErr_numW] = fitPropertyNumWithin(Pwant, Temp_numW,t,p,tPlot,rockDensity,foundIndices, errorAll);

%% This plots the results of our search
figure(1); close; figure(1);
plot(Tplot,numWithin,'k','LineWidth',2)
set(gca,'LineWidth',2,'XColor','k','YColor','k','FontSize',18)
xlabel(['Temperature [' char(176) 'C]'])
ylabel('# of Samples Within Error')
grid on; box on;