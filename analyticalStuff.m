clear
clc

clc; clear;
% Intialization

j = sqrt(-1);
Rr  =  1.39e-3;             % ohm, Rotor resistance
Rs  =  1.343e-3;            % ohm, Stator resistance
fb  =  50;                  % Hz, Base frequency
p   =  6;                   % Number of poles
M   =  6;                   % sec, mechanical time constant
Pb  =  1.45e6;              % W, base power
Ib  =  1723*sqrt(2);        % A, base current
we  =  2*pi*fb;             % erad/s, synchronous speed
wmb =  we*(2/p);            % mrad/s, mechanical base speed
Tb  =  13.944e3;            % Nm, rated torque
Vb  = 331.98*sqrt(2);       % V, supply phase peak voltage
J = p/2*Pb*M/(wmb^2);       % inertia


% Impedance and angular speed calculations
Lls     =  0.1044e-3;       % H, Stator inducatnce
Llr     =  0.0498e-3;       % H, Rotor inductance
Lm      =  1.77016e-3;      % H, Magnetizing Inductance 
Lr      = Llr + Lm;
Ls      = Lls + Lm;

Xls     =  Lls*we;          % Ohm, Stator impedance
Xlr     =  Llr*we;          % Ohm, Rotor impedance
Xm      =  Lm*we;           % Ohm, Magnetizing impedance
wb      =  2*pi*fb;         % rad/s, Base speed
Xmstar  =  1/(1/Xls+1/Xm+1/Xlr);


% part a condition
slip = 0.0177;
wrotor = wb*(1-slip);      % rad/s, Base speed
w = 0;  % stationary frame
 
%% transient constants
tau_s = Ls/Rs;
tau_r = Lr/Rr;
sigma = 1 - Lm^2 / (Lr*Ls);
alpha = tau_s/tau_r;

tau_s_sc = sigma*tau_s;     %short circuit transient time const.
tau_r_sc = sigma*tau_r;

Lambda1 = -1/(2*sigma*tau_r) * (1+alpha) + j*(0.5*wrotor - w) + ...
    1/(2*sigma*tau_r) * sqrt((1+alpha)^2 - 4*sigma*alpha - (wrotor*sigma*tau_r)^2 + j*2*(alpha-1)*wrotor*sigma*tau_r);

Lambda2 = -1/(2*sigma*tau_r) * (1+alpha) + j*(0.5*wrotor - w) - ...
    1/(2*sigma*tau_r) * sqrt((1+alpha)^2 - 4*sigma*alpha - (wrotor*sigma*tau_r)^2 + j*2*(alpha-1)*wrotor*sigma*tau_r);


pf = 1;
theta = acos(pf);

Iqds0 = Ib/sqrt(2)*exp(-j*theta);  
Iqdr0 = -Iqds0*j*Xm/(j*Xm + j*Xlr + Rr/slip);
Iqdsinf = 0;
Iqdrinf = 0;

Xmat = [Iqds0; Iqdr0; 0; 0];
Tmat = [1, 1, 0, 0;
    0, 0, 1, 1;
    Rs+j*we*Ls+Ls*Lambda1, Rs+j*we*Ls+Ls*Lambda2, Lambda1*Lm+j*Lm*we, Lambda2*Lm+j*Lm*we;
    Lm*Lambda1+Lm*j*(we-wrotor), Lm*Lambda2+Lm*j*(we-wrotor), Rr+j*Lr*(we-wrotor)+Lr*Lambda1, Rr+j*Lr*(we-wrotor)+Lr*Lambda2];

%Cmat = [C1; C2; C3; C4]

Cmat = Tmat\Xmat;

C1 = Cmat(1);
C2 = Cmat(2);
C3 = Cmat(3);
C4 = Cmat(4);


t = linspace(0, 3, 10000);
Iqds = (C1*exp(Lambda1*t) + C2*exp(Lambda2*t));   % stator current, synchronous frame w=we
Iqdr = (C3*exp(Lambda1*t) + C4*exp(Lambda2*t));   % rotor current, synchronous frame w=we

Iqdss = Iqds.*exp(j*we*t);     % stator current, stator frame w=0
figure;plot(t,real(Iqdss)/Ib);
title('Phase A stator current, stationary frame (\omega=0)')
xlabel('Time [sec]')
ylabel('Current [pu]')