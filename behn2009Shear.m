function [shearFactor]=behn2009Shear(frequency,d,T,P,coh)
%this function reproduces the behn et al. 2009 EPSL shear wave velocity
% frequency is frequency of seismic waves (Hz).
% d is the estimated grain size of the mantle in meters
% t is the temperature in C
% p is the pressure in GPa
T=T+273.1;%convert to K
pqref=1.09;%reference grain size exponenet
pq=1;%grain size exponent
Tqref=1265;%?C, reference temperature
dqref=1.24e-5;%m, reference grain size
Eqref=505e3;%J/mol, reference activation energy
Vqref=1.2e-5;%reference activation volume m^3/mol
Bo=1.28e8;%prefactor for Q for omega=0.122 s^-1
Eq=420e3;%activation energy
Vq=1.2e-5;%activation volume
cohref=50;%H/10^6 Si
R=8.314;
Pqref=300e6;%reference pressure of 300 MPa;
rq=1.2;
alpha=0.27;
B=Bo*dqref^(pq-pqref)*(coh/cohref)^rq*exp(((Eq+Pqref*Vq)-(Eqref+Pqref*Vqref))/R/Tqref);
Qinv=(B*d^(-1*pq)/frequency*exp(-(Eq+P*1e9*Vq)/R/T))^alpha;%anelastic factor
F=cot(pi*alpha/2)/2;
shearFactor=(1-F*Qinv).^2;
end