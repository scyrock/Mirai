close all
clear all
clc
load("61712046.mat")
load("BoostParam.mat")
pFC = RawData.FC_output_power_FCDC__kW*1e3;

PW_FCtest = linspace(0,max(pFC)); 


eta = 1e-3*PW_FCtest./(BoostParam.eta_c+BoostParam.eta_b*PW_FCtest+BoostParam.eta_a*PW_FCtest.^2);
plot(PW_FCtest,eta)