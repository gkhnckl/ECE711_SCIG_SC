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
sigma = 1 - Lm^2/(Ls*Lr);
Ls_prime = sigma*Ls;

Vsp = Vb/sqrt(2) * exp(j*we);
% Isp = Vsp / (Rs + j*Xls);
% Irp = Isp*j*Xm / (j*Xm + j*Xlr + Rr/slip);

Erp = Vsp * j*Xm / (Rs + j*(Xls + Xm));
Eqd_prime = (1-slip)*Lm/Lr*Erp;
eig = -Rs/Ls_prime;
Isc = -Eqd_prime / (Rs + j*wrotor*Ls_prime);
C = Vsp/(j*wrotor*Ls_prime);

t = linspace(0,0.1,10000);
iqds = C*exp(-eig*t) + Isc*exp(j*wrotor*t);
plot(t, -real(iqds/Ib));
title('Plot of phase A current')