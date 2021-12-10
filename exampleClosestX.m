%%%
% This script shows an example of how to use the functions fitClosestX.m.
% and fitPropertyClosestX.m
% This uses the HGP4 files, not HGP4_800

% written by WJS, 12/2021

%% first load in database files
load WISTFUL_rockType.mat
load WISTFUL_compositions_clean.mat
load WISTFUL_densities_clean.mat
load WISTFUL_speeds_moduli_clean.mat %you can replace this with wave speed files made by calculateWaveSpeedFiles.mlx

%% Let's search for the closest 100 compositions for Vp of 8.1 km/s and a Vs of 4.65 km/s at 2 GPa
X=100;%Let's search for the 100 closest
Pwant=2e9;
VpFind=8.1;
VsFind=4.65;
constraints= mgnum>=0.86&isPeridotite';%Let's look at peridotites that have mgnum>0.86
[Tplot, averageError, Temp, Temp_err, foundIndices, errorAllSorted] =...
    findClosestX(Pwant, [300 1400], t, p, X, VsFind, vs,constraints,  VpFind, vp);
%the result for this should be Temp=693.4897, Temp_err=44.8718
%% Let's look at the best fitting Mg # (temperature insensitive parameter)
% as well as the best fitting density (tempereature sensitive paramater).
[mgnumBest, mgnumErr] = fitPropertyClosestX(Pwant, Temp,Temp_err,t,p,[300 1400],mgnum,foundIndices, errorAllSorted);
% mgnumBest=0.9133, mgnumErr=0.0083

[densityBest, densityErr] = fitPropertyClosestX(Pwant, Temp,Temp_err,t,p,[Tplot(1) Tplot(end)],rockDensity,foundIndices, errorAllSorted);
%densityBest=3.3059e+03, densityErr=14.9922

%% This plots the results of our search
figure(1); close; figure(1);
plot(Tplot,averageError,'k','LineWidth',2)
set(gca,'LineWidth',2,'XColor','k','YColor','k','FontSize',18)
xlabel(['Temperature [' char(176) 'C]'])
ylabel('Average RMSE')
grid on; box on;