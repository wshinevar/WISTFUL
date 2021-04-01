function [J1,J2,fM] = creep10(Te,gs,pres,omega)
%calculate real and imaginary parts of creepfunction, eq. 7 JF10
%params from Jackson and Faul, PEPI, 2010, Table 2, note p

global alpha sig% alpha is used in J1anel and J2anel, sig in J1p and J2p
Tr = 1173; iTr=1/Tr; %reference temperature in K
Pr = 0.2*1E9; PT = Pr/Tr; %reference pressure in Pa
gsr = 1.34E-5; % reference grain size in m
deltaB = 1.04; % background relaxation strength,
alpha = 0.274; % background frequency exponent
%reference values for relaxation times
tauLo = 1E-3; tauHo = 1E7; tauMo = 3.02E7; 
ma = 1.31;  % anelastic grain size exponent
mv = 3;     % viscous grain size exponent
EB = 3.6E5; % activation energy for background and peak (orig 3.6E5)
AV = 1E-5;  % activation volume 1E-5
R = 8.314; 
AVR = AV/R; ER = EB/R; gr = gs/gsr;

% peak parameters:
tauPo = 3.98E-4; % reference peak relaxation time,
deltaP = 0.057;  % peak relaxation strength pref (orig 0.057)
sig = 4;         % peak width (orig 4)
cp = deltaP * (2*pi)^(-0.5)/sig; %peak integration const.

% relaxation times eqs. 9 and 10
taut = exp((ER)*(1./Te-iTr)).*exp(AVR*((pres./Te)-PT));
tauH = tauHo*gr.^ma.*taut;
tauL = tauLo*gr.^ma.*taut;
tauP = tauPo*gr.^ma.*taut;
tauM = tauMo*gr.^mv.*taut;
%initialize arrays
sT = size(Te);
on = ones(sT);
ij1 = zeros(sT); ij2 = zeros(sT); 
ip1 = zeros(sT); ip2 = zeros(sT);

%integration for peak wrt to dtau 0 - inf;
for ii = 1 : length(Te)
  ij1(ii) = integral(@(tau)J1anel(tau,omega(ii)),tauL(ii),tauH(ii),'AbsTol',1e-8,'RelTol',1e-5);
%  ij1(ii) = quadl(@(tau)J1anel(tau,omega(ii)),tauL(ii),tauH(ii));
  ij2(ii) = integral(@(tau)J2anel(tau,omega(ii)),tauL(ii),tauH(ii));
  ip1(ii) = quadgk(@(tau)J1p(tau,omega(ii),tauP(ii)),0,inf);
  ip2(ii) = quadgk(@(tau)J2p(tau,omega(ii),tauP(ii)),0,inf);
end

Jb1 = alpha*deltaB*ij1./(tauH.^alpha-tauL.^alpha);
Jb2 = omega*alpha*deltaB.*ij2./(tauH.^alpha-tauL.^alpha);
Jp1 = cp.*ip1; 
Jp2 = cp.*omega.*ip2;

J1 = on + Jb1 + Jp1;
J2 = (Jb2 + Jp2) + 1./(omega.*tauM);
fM = 1./tauM;

return