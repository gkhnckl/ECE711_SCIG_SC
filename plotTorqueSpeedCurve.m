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
%title('Torque-speed characteristics at rated voltage, in linear region')
yline(0, '--k')
xline(1, '--k')
xlim([wr_table(35) wr_table(15)])
xticks([wr_table(35) (wr_table(35)+0.5*(1-wr_table(35))) 1 (1+0.5*(wr_table(15)-1)) wr_table(15)])
xticklabels({'0.9805', '0.9902', '1', '1.0114', '1.0228'})