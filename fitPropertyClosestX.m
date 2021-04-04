function [meanProperty, stdProperty] = fitPropertyClosestX(Pfind, Tfind,Terror,t,p,Tplot,property,foundIndices, errorAllSorted)
% fitPropertyNumWithin finds the average and weighted standard deviation of
% a given property from the variables found in findClosestX
%
% Pfind is the pressure [bars] you input to findClosestX.
%
% Tfind is the temperature [degrees C] you want the average property at.
% For best fit, use bestFitT from findClosestX. 
%
% Terror is the range of temperature. For best fit error, use Terror from
% the sister function findClosestX.
%
% t and p are the WISTFUL temperature and pressure vectors from loading any WISTFUL speed file.
%
%  X is the number of closest samples averaged. 
%
% Tplot is the output from numWithinError run.
%
% foundIndices is are the ordered indices taken from the output of the
% sister function
%
% property is the property taken from the WISTFUL database you wish to
% investigate (e.g. density, composition)
%
% foundIndices and errorAll are the outputs from numWithinError run.
%
% meanProperty gives you a averaged property weighted by the distance to
% the desired data point.
%
% stdProperty is the standard deviation of the property also weighted by
% the distance to the desired data point.
%
% coded by William Shinevar, last updated 04/21
%% error check and fixing property
if nargin ~=8
    error('Wrong number of input variables.')
end
Twant=Tfind+273.1;
pIndex=find(abs(Pfind-p)==min(abs(Pfind-p)), 1 );
tIndex=find(abs(Twant-t)==min(abs(Twant-t)), 1 );
tIndex2=find(abs(Tfind-Tplot)==min(abs(Tfind-Tplot)), 1 );

if length(size(property))>2
    propertyUse=squeeze(property(pIndex,tIndex,:));
else
    propertyUse=property;
end

averageProperty=zeros(length(tIndex),1);
stdProperty=zeros(length(tIndex),1);
averageLowestError=zeros(length(tIndex),1);
for i=1:length(tIndex)
    indices=squeeze(foundIndices(i,1:closestX));
    Xi=errorsAllSorted(i,indices);
    averageLowestError(i)=mean(Xi);
    weight= (1./Xi)*sum(1./Xi);
    if tempsensitive
        data1sorted=squeeze(propertyUse(i,indices(1:closestX)));
    else
        data1sorted=propertyUse(indices(1:closestX));
    end
    if size(data1sorted,1)>=size(data1sorted,2)
        data1sorted=data1sorted';
    end
    averageProperty(i)=sum(data1sorted./Xi)./sum(1./Xi);
    stdProperty(i)=std(data1sorted,weight);
end

%% calculate weighted average and error.
rangeIndex=abs(Tplot-Tfind)<=Terror;
meanProperty=averageProperty(tIndex2);
stdProperty=sum(stdProperty(rangeIndex)./averageLowestError(rangeIndex))./sum(1./averageLowestError(rangeIndex));
