function [Tplot, numWithin, bestFitT, Terror, foundIndices, errorAll] = numWithinError(Pwant, Trange, t, p, data1Find, data1Error, data1,varargin)
% NUMWITHINERROR finds the number of WISTFUL samples within a certain error of seismic data type.   
%
%   [TPLOT, NUMWITHIN, BESTFITT, TERROR, FOUNDINDICES]= numWithinError(P, Trange, t, p,
%   data1Find, data1Error, data1) finds the number of data points from the
%   input WISTFUL database for a given data at a given pressure P [bars]
%   over a range Trange [Tmin Tmax] in degrees C. To use this file in a
%   script, please load your preferred wave speed file as well as any
%   property file you wish to match with. 
%
%   t and p are the WISTFUL temperature and pressure vectors from loading any WISTFUL speed file.
%   
%   data1Find is the point which you are fitting to (e.g. Vp,Vs, Vp/Vs)
%   
%   data1Error is the error in %.
%
%   data1 is the WISTFUL data of that parameter loaded from the .mat file
%   (e.g. Vp, Vs, Vp/Vs).
%
%   [TPLOT, NUMWITHIN, BESTFITT, TERROR, FOUNDINDICES]= numWithinError(P, Trange, t, p,
%   data1Find, data1Error, data1,constraints) only looks at the samples
%   with true values in the constraints variable. data1Find can be a
%   vector.
%
%   [TPLOT, NUMWITHIN, BESTFITT, TERROR, FOUNDINDICES]= numWithinError(P, Trange, t, p,
%   data1Find, data1Error, data1, constraints, data2Find, data2Error,data2)
%   adds the additional constraint (e.g. Vp and Vs) with it's own
%   individual error. If empty constraints is empty, all samples will be used. 
%   
%   OUTPUTS:
%
%   Tplot is the temperature points at which misfit was investigated.
%   
%   numWithin is the number of samples within error at each corresponding
%   temperature point (Tplot).
%
%   bestFitT is the mean of the numWithin distribution.
%
%   Terror is the standard deviation of the numWithin distribution.
%
%   foundIndices is a cell for the WISTFUL sample indices at each
%   investigated temperature. 
%   
%   last updated by William Shinevar 04/2021


%% this section checks the varargin and produces errors if wrong number of variables are input
if nargin<7
    error('You have submitted less than the minimum required inputs.')
elseif nargin>7
    switch length(varargin)
        case 1
            constraints=varargin{1};
        case 4
            constraints=varargin{1};
            data2Find=varargin{2}; 
            data2Error=varargin{3}; 
            data2=varargin{4};
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
%% First we find the pIndex and tindex we need

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
numWithin=zeros(length(tIndex),length(data1Find));
foundIndices=cell(length(tIndex),length(data1Find));
for i= 1:length(tIndex)
    for j=1:length(data1Find)
        error1(i,:,j)=abs(squeeze(data1Find(j)-data1Use(i,:))*100/data1Find(j));
        if exist('error2')==1
            error2(i,:,j)=abs(squeeze(data2Find(j)-data2Use(i,:))*100/data2Find(j));
            temporary=squeeze(error2(i,:,j)<=data2Error&error1(i,:,j)<=data1Error);
            numWithin(i,j)=sum(temporary);
            foundIndices{i,j}=find(temporary);
        else
            temporary=error1(i,:,j)<=data1Error;
            numWithin(i,j)=sum(temporary);
            foundIndices{i,j}=find(temporary);
        end
    end
end


%% find best fit temperature
bestFitT=NaN(size(data1Find));
Terror=NaN(size(data1Find));
for j=1:length(data1Find)
    sumFits=sum(numWithin(:,j));%n
    sumM2=sum(numWithin(:,j).*Tplot.^2);
    bestFitT(j)=sum(Tplot.*numWithin(:,j))./sumFits;
    Terror(j)=2*sqrt((sumM2-sumFits*bestFitT(j)^2)/(sumFits-1));
end
if exist('data2')==1
    errorAll=sqrt(error1.^2+error2.^2);
else
    errorAll=abs(error1);
end


