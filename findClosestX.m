function [Tplot, averageError, bestFitT, Terror, foundIndices, errorAllSorted] = findClosestX(Pwant, Trange, t, p, X, data1Find, data1,varargin)
% FINDCLOSESTX finds the number of WISTFUL samples within a certain error of seismic data type.   
%
%   [Tplot, averageError, bestFitT, Terror, foundIndices, errorAll]= numWithinError(Pwant, Trange, t, p, X, data1Find, data1,varargin)
%   finds the closest X of data points from the
%   input WISTFUL database for a given data at a given pressure P [bars]
%   over a range Trange [Tmin Tmax] in degrees C. To use this file in a
%   script, please load your preferred wave speed file as well as any
%   property file you wish to match with. 
%
%   t and p are the WISTFUL temperature and pressure vectors from loading any WISTFUL speed file.
%
%   X is the number of samples you wish to find closest to the investigated
%   data. If X is greater than the number of constraints you have applied,
%   X will be converted to the number of constraints.
%   
%   data1Find is the point which you are fitting to (e.g. Vp,Vs, Vp/Vs)
%   
%   data1 is the WISTFUL data of that parameter loaded from the .mat file
%   (e.g. Vp, Vs, Vp/Vs).
%
%   [Tplot, averageError, bestFitT, Terror, foundIndices, errorAll]= numWithinError(P, Trange, t, p,
%   data1Find, data1Error, data1,constraints) only looks at the samples
%   with true values in the constraints variable. data1Find can be a
%   vector. if constraints is empty, all rocks are used.
%
%   [Tplot, averageError, bestFitT, Terror, foundIndices, errorAll]= numWithinError(P, Trange, t, p,
%   data1Find, data1Error, data1, constraints, data2Find, data2Error,data2)
%   adds the additional constraint (e.g. Vp and Vs) with it's own
%   individual error. If empty constraints is empty, all samples will be used. 
%   
%   OUTPUTS:
%
%   Tplot is a vector of the temperature points at which misfit was investigated.
%   
%   averageError is average RMSE of the closest X points to the
%   investigated points.
%
%   bestFitT is the temperature with the lowest averageError.
%
%   Terror is half the temperature range over which averageError at the bestFitT
%   is less than the minimum RMSE + 1 standard deviation of the RMSE of the closest X at that temperature.
%
%   foundIndices is a cell for the WISTFUL sample indices at each
%   investigated temperature sorted from lowest to highest error.
%
%   errorAllSorted (misfit for all constrained samples in %) sorted. 
%
%   last updated by William Shinevar 04/2021

%% this section checks the varargin and produces errors if wrong number of variables are input
if nargin<7
    error('You have submitted less than the minimum required inputs.')
elseif nargin>7
    switch length(varargin)
        case 1
            constraints=varargin{1};
        case 3
            constraints=varargin{1};
            data2Find=varargin{2}; 
            data2=varargin{3};
        otherwise
            error('You have input an invalid number of inputs.')
    end
    if isempty(constraints)
        constraints=true(length(data1),1);
    end
end
if exist('constraints')~=1
    constraints=true(length(data1),1);
end
X=round(X);
if sum(constraints)<X
    X=sum(constraints);
end
%% First we find the pIndex and tindex we need to investigate

TwantMin=273.1+Trange(1);
TwantMax=273.1+Trange(2);
pIndex=find(abs(Pwant-p)==min(abs(Pwant-p)), 1 );
tIndexMin=find(abs(TwantMin-t)==min(abs(TwantMin-t)), 1 );
tIndexMax=find(abs(TwantMax-t)==min(abs(TwantMax-t)), 1 );
tIndex=tIndexMin:tIndexMax;
Tplot=t(tIndex)-273.1;
Tplot=Tplot';

%% then we find the data we need to compare against
data1Use=squeeze(data1(pIndex,tIndex,:));
data1Use(:,~constraints)=NaN;
error1=zeros(size(data1Use,1),size(data1Use,2),length(data1Find));
if exist('data2')==1 %if we have two fittings
    data2Use=squeeze(data2(pIndex,tIndex,:));
    data2Use(:,~constraints)=NaN;
    error2=zeros(size(data1Use,1),size(data1Use,2),length(data1Find));
end
%% find all the misfits and number of samples within error box
% numWithin=zeros(length(tIndex),length(data1Find));
% foundIndices=cell(length(tIndex),length(data1Find));
for i= 1:length(tIndex)
    for j=1:length(data1Find)
        error1(i,:,j)=abs(squeeze(data1Find(j)-data1Use(i,:))*100/data1Find(j));
        if exist('error2')==1
            error2(i,:,j)=abs(squeeze(data2Find(j)-data2Use(i,:))*100/data2Find(j));
        end
    end
end

if exist('data2')==1
    errorAll=sqrt(error1.^2+error2.^2);
else
    errorAll=abs(error1);
end
errorAllSorted=zeros(size(errorAll));
%% now we go through, sort the error, and report indices and average closest error. 
[errorAllSorted, foundIndices]=sort(errorAll,2);
foundIndices=foundIndices(:,1:X);
averageError=squeeze(mean(errorAllSorted(:,1:X,:),2));
stdError=squeeze(std(errorAllSorted(:,1:X,:),0,2));
%% find best fit temperature
[bestFitIndex1, bestFitIndex2]=find(min(averageError)==averageError);
bestFitT=Tplot(bestFitIndex1);
dT=Tplot(2)-Tplot(1);
Terror=zeros(size(bestFitT));
for i=1:length(Terror)
    Terror(i)=sum((averageError(:,i)-min(averageError(:,i))<stdError(bestFitIndex1(i),i)))*dT;
end