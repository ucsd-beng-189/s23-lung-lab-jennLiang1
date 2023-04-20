%filename: lung.m (main program)

%% Original Code
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

setup_lung
cvsolve
outchecklung

%% Task 1
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

beta_list = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
for i = 1:length(beta_list)
    beta = beta_list(i);
    setup_lung
    cvsolve
    outchecklung

    PI_list(i) = PI;       %inspired partial pressure of oxygen
    Pv_list(i) = Pv;       %mean partial pressure in venous blood
    Pabar_list(i) = Pabar; %mean arterial oxygen partial pressure
    PAbar_list(i) = PAbar; %mean alveolar oxygen partial pressure
end

figure(4)
plot(beta_list,PI_list)
hold on 
plot(beta_list,Pv_list)
plot(beta_list, Pabar_list)
plot(beta_list,PAbar_list)
legend("PI", "Pv", "Pabar", "PAbar")
xlabel("beta"); ylabel("Partial Pressure of Oxygen"); title("PI, Pv, Pabar, PAbar")
