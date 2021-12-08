function [meanProperty, stdProperty] = fitPropertyNumWithin(Pfind, Tfind,t,p,Tplot,property,foundIndices, errorAll)
% fitPropertyNumWithin finds the average and weighted standard deviation of
% a given property from the variables found in numWithinError
% 
% Pfind is the pressure [Pa] you input to numWithinError.
%
% Tfind is the temperature [degrees C] you want the average property over. For best-fit
% average property, use the bestFitT output from numWithinerror.
%
% t and p are the WISTFUL temperature and pressure vectors from loading any WISTFUL speed file.
% 
% Tplot is the output from numWithinError run.
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
if nargin ~=8
    error('Wrong number of input variables.')
end
Twant=Tfind+273.1;
pIndex=find(abs(Pfind-p)==min(abs(Pfind-p)), 1 );
tIndex=find(abs(Twant-t)==min(abs(Twant-t)), 1 );
tIndex2=find(abs(Tfind-Tplot)==min(abs(Tfind-Tplot)), 1 );
if isempty(foundIndices{tIndex2})
    meanProperty=NaN;
    stdProperty=NaN;
    return
end
if length(size(property))>2
    propertyUse=squeeze(property(pIndex,tIndex,:));
else
    propertyUse=property;
end
weights=1./errorAll(tIndex2,:,:);
if size(weights,1)==1
       j=1;
       meanProperty=sum(propertyUse(foundIndices{tIndex2})'.*squeeze(weights(foundIndices{tIndex2})))./sum(squeeze(weights(foundIndices{tIndex2,j})));
        stdProperty=std(propertyUse(foundIndices{tIndex2}),squeeze(weights(foundIndices{tIndex2})));
else
    for j=1:size(foundIndices,2)
        %I=find(abs(averageTemp-tPlot)==min(abs(averageTemp-tPlot)), 1 );
        meanProperty(j)=sum(propertyUse(foundIndices{tIndex2,j})'.*squeeze(weights(foundIndices{tIndex2,j},j)))./sum(squeeze(weights(foundIndices{tIndex2,j},j)));
        stdProperty(j)=std(propertyUse(foundIndices{tIndex2,j}),squeeze(weights(foundIndices{tIndex2,j},j)));
    end
end