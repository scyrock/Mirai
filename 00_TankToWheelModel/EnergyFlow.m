close all
clear all
clc

load("61712046.mat")
load("BoostParam.mat")
load ("FCparam.mat")
load("MotorInverter.mat")

time = RawData.Time__s_RawFacilities;
iFC = RawData.FC_current_vsCAN3__A;
vFC = RawData.FC_smoothed_value_of_fc_voltage_vsCAN3__V;
pFC = RawData.FC_output_power_FCDC__kW*1e3;
pFC1 = iFC.*vFC;
etaBoost = 1e-3*pFC1./(BoostParam.eta_c+BoostParam.eta_b*pFC1+BoostParam.eta_a*pFC1.^2);
min(etaBoost)
max(etaBoost)
pBo = etaBoost.*pFC1;

vBat = RawData.HVBatt_Volt_Hioki_analog10hz__U1__V;
iBat = RawData.HVBatt_Curr_Hioki_analog10hz__I1__A;
pBat = RawData.HVBatt_Power_Hioki_analog10hz__P1__kW*1e3;
pBat1 = iBat.*vBat;
pFCa = FCparam.auxFC_a*pFC1.^2+FCparam.auxFC_b;
pCa = 489;
etaBuckBust = 1
pBb = (pBat-pFCa-pCa).*etaBuckBust.^(sign(pBat-pFCa-pCa))


tMot = RawData.EV_drive_motor_execution_torque_EV__Nm;
wMot = RawData.EV_drive_motor_revolution_EV__rpm*(2*pi)/60;
pMot = tMot.*wMot;
etaInv = ppval(pp_MotInv,pMot);
pInv = pMot./etaInv;

pHopeZero = pBo-pInv-pBb;

figure, plot(pHopeZero)

figure,
plot(time, pBo), hold on, plot(time,pInv), plot(time,pBb)
figure, plot(time,pBo-pInv+pBb)


%%
figure, 
subplot(321), plot(time,pFC), hold on, plot(time,pFC1,'--'), plot(time,pBo), title('Fuel cell')
legend('FC log', 'FC i*v', 'FC after boost')
subplot(322), plot(time,pBat), hold on, plot(time,pBat1,'--'), plot(time,pFCa), plot(time,pBb), title('Battery')
legend('Bat log', 'Bat i*v', 'Bat FC aux', 'Bat after buck/boost')
subplot(323), plot(time,pMot), hold on, plot(time,pInv), title('Motor')
legend('Mot T*w', 'Mot pre InvMot')



%%
Efc(1) = 0;
Ebat(1) = 0;
Emot(1) = 0;
Ebo(1) = 0;
Efca(1) = 0;
Einv(1) = 0;
Ebb(1) = 0;

for i = 2:length(time)
    Efc(i) = Efc(i-1) + trapz(time(i-1:i),pFC1(i-1:i));
    Ebat(i) = Ebat(i-1) + trapz(time(i-1:i),pBat1(i-1:i));
    Emot(i) = Emot(i-1) + trapz(time(i-1:i),pMot(i-1:i));
    Ebo(i) = Ebo(i-1) + trapz(time(i-1:i),pBo(i-1:i));
    Efca(i) = Efca(i-1) + trapz(time(i-1:i),pFCa(i-1:i));
    Einv(i) = Einv(i-1) + trapz(time(i-1:i),pInv(i-1:i));
    Ebb(i) = Ebb(i-1) + trapz(time(i-1:i),pBb(i-1:i));
end

figure, 
subplot(321), plot(time,Efc), hold on, plot(time,Ebo), title('Fuel cell')
legend('FC i*v', 'FC after boost',Location='southeast')
subplot(322), plot(time,Ebat), hold on, plot(time,Efca), title('Battery')
legend('Bat i*v', 'Bat FC aux')
subplot(323), plot(time,Emot), title('Motor')

figure, hold on
plot(time,Ebo)
plot(time,Einv)
plot(time,Ebb)
figure, plot(time,Ebo-Einv+Ebb, 'k--')

