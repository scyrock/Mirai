close all
clear all
clc

load("MotorInverter.mat")

x = [0 5 10 15 30 45 60]*1e3;
y = [0.7 0.84 0.95 0.96 0.9 0.89 0.89];
xtest = linspace(0,60)*1e3;
ytest = ppval(pp_MotInv,xtest)
plot(x,y,'o')
hold on, plot(xtest,ytest)
ylim([0 1.2])
