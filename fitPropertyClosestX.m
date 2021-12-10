function [meanProperty, stdProperty, averagePropertyRange, stdPropertyRange] = fitPropertyClosestX(Pfind, Tfind,Terror,t,p,Trange,property,foundIndices, errorAllSorted)
% fitPropertyNumWithin finds the average and weighted standard deviation of
% a given property from the variables found in findClosestX
%
% Pfind is the pressure [Pa] you input to findClosestX.
%
% Tfind is the temperature [degrees C] you want the average property at.Ter
% For best fit, use bestFitT from findClosestX. 
%
% Terror is the range of temperature. For best fit error, use Terror from
% the sister function findClosestX.
%
% t and p are the WISTFUL temperature and pressure vectors from loading any WISTFUL speed file.
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
%   OUTPUTS:
%
% meanProperty gives you a averaged property weighted by the distance to
% the desired temperature.
%
% stdProperty is the standard deviation of the property also weighted by
% the distance to the desired temperature.
%
% averagePropertyRange is the weighted mean property at each temperature
% within the range.
%
% stdPropertyRange is the weighted standard deviation of the property at
% each temperature within the range. 
%
%
% coded by William Shinevar, last updated 12/21
%% error check and fixing property
if nargin ~=9
    error('Wrong number of input variables.')
end
TwantMin=273.1+Trange(1);
TwantMax=273.1+Trange(2);
pIndex=find(abs(Pfind-p)==min(abs(Pfind-p)), 1 );
tIndexMin=find(abs(TwantMin-t)==min(abs(TwantMin-t)), 1 );
tIndexMax=find(abs(TwantMax-t)==min(abs(TwantMax-t)), 1 );
tIndex=tIndexMin:tIndexMax;
tIndex2=find(abs(Tfind-t(tIndex)+273.1)==min(abs(Tfind-t(tIndex)+273.1)), 1 );

if length(size(property))>2
    propertyUse=squeeze(property(pIndex,tIndex,:))';
    tempsensitive=true;
elseif sum(size(property))>(length(property)+1)
    propertyUse=property;
    tempsensitive=true;
else 
    propertyUse=property;
    tempsensitive=false;
end
X=size(foundIndices,2);
averagePropertyRange=zeros(length(tIndex),1);
stdPropertyRange=zeros(length(tIndex),1);
averageLowestError=zeros(length(tIndex),1);
for i=1:length(tIndex)
    indices=squeeze(foundIndices(i,:));
    Xi=errorAllSorted(i,1:X);
    averageLowestError(i)=mean(Xi);
    weight= (1./Xi)*sum(1./Xi);
    if tempsensitive
        data1sorted=propertyUse(indices,i)';
    else
        data1sorted=propertyUse(indices);
    end
%     if size(data1sorted,1)>=size(data1sorted,2)
%         data1sorted=data1sorted';
%     end
    averagePropertyRange(i)=sum(data1sorted./Xi)./sum(1./Xi);
    stdPropertyRange(i)=std(data1sorted,weight);
end

%% calculate weighted average and error.
rangeIndex=abs(t(tIndex)-273.1-Tfind)<=ceil(Terror);
meanProperty=averagePropertyRange(tIndex2);
stdProperty=sum(stdPropertyRange(rangeIndex)./averageLowestError(rangeIndex))./sum(1./averageLowestError(rangeIndex));
