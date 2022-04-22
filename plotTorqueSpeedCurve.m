clear
clc

data = load("torqueSpeedCurveData.mat");
wr_table = data.wr_table;
Tload = data.Tload;
Tb  =  13.944e3;            % Nm, rated torque

figure
plot(wr_table(15:35), Tload(15:35)/Tb)
xlabel('\omega_{r} [pu]')
ylabel('Torque [pu]')
title('Torque-speed characteristics at rated voltage, in linear region')
yline(0, '--k')
xline(1, '--k')
xlim([wr_table(35) wr_table(15)])