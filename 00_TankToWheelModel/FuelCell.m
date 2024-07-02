close all
clear all
clc

load("61712046.mat")
load("FCparam.mat")

iFC = RawData.FC_current_vsCAN3__A;
vFC = RawData.FC_smoothed_value_of_fc_voltage_vsCAN3__V;
pFC = RawData.FC_output_power_FCDC__kW*1e3;

%%
iTest = linspace(0,max(iFC));
vTest = FCparam.N*(FCparam.E0-FCparam.A*(3+log(iTest/FCparam.I0)))-FCparam.R1*iTest;

figure, plot(iFC,vFC,'*', MarkerSize=2)
hold on, grid on
plot(iTest,vTest, LineWidth=3)
xlabel('FC Current (A)')
ylabel('FC Voltage (V)')


%%
pTest = linspace(0,max(pFC));
iTest = FCparam.pFC_a*pTest.^2+FCparam.pFC_b*pTest;
figure, plot(pFC,iFC,'*', MarkerSize=2)
hold on, grid on
plot(pTest,iTest,LineWidth=3)
xlabel('FC power (W)')
ylabel('FC current (A)')

%%
auxPFC = FCparam.auxFC_a*pTest.^2+FCparam.auxFC_b;
figure, plot(pTest,auxPFC,LineWidth=3), grid on

