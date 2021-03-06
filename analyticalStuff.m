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
slip = -0.0075;
wrotor = wb*(1-slip);      % rad/s, Base speed
w = 0;  % stationary frame
 
%% transient constants
sigma = 1 - Lm^2/(Ls*Lr);
Ls_prime = sigma*Ls;

Vsp = Vb/sqrt(2)* exp(j*(we - 9*pi/180));
% Isp = Vsp / (Rs + j*Xls);
% Irp = Isp*j*Xm / (j*Xm + j*Xlr + Rr/slip);

Vm = Vsp * j*Xm / (Rs + j*(Xls + Xm));
Erp = Vm*(Rr/slip / (j*we*Llr + Rr/slip));
Eqd_prime = (1-slip)*Lm/Lr*Erp;
eig = -Rs/Ls_prime;
Isc = -Eqd_prime / (Rs + j*wrotor*Ls_prime);
C = Vsp/(j*wrotor*Ls_prime);
%C = Vsp/(j*we*Ls+Rs) + Eqd_prime/(j*wrotor*Ls_prime+Rs);

t = linspace(-0.1,0.1,2000);
iqds = C*exp(eig*t) + Isc*exp(j*wrotor*t);
iqdr = -iqds * j*Xm/ (j*Xm + j*Xlr + Rr/slip);
iqs = real(iqds);
ids = -imag(iqds);
iqr = real(iqdr);
idr = -imag(iqdr);
T_transient = Tb + (3/2*p/2*Lm * (iqs.*idr - ids.*iqr)).*(t>=0);

SCdata = load("3phSCData.mat");
% figure
% plot(SCdata.time, SCdata.Ia3ph)

currents = [(-real(iqds/Ib))', (SCdata.Ia3ph(1001:3000))'];
time = linspace(2.5, 2.6, 1000);

figure
plot(time, currents(1:1000,1), time, currents(1:1000,2));
title('Plot of phase A current')
ylabel('pu')
xlabel('time [sec]')
xlim([2.5 2.6])
legend('Analytical', 'Simulation')

% figure
% plot(t, -T_transient/Tb);
% title('Plot of torque')
% ylabel('pu')

