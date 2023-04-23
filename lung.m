%filename: lung.m (main program)

%% Original Code
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

setup_lung
cvsolve
outchecklung

%% Task 3
% run with beta values set below and comment out the default beta=0.5

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

%% Task 4.1 
% default parameters 
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

% run with M values set below and comment out deafult M = 0.25*cref*5.6
cref=0.2/(22.4*(310/273));

for i = 1:100
    disp("Iteration: "+ i)
    M = (0.25*cref*5.6)*i;
    
    setup_lung
    cvsolve
    outchecklung
end

% need to be run separately after the error message
fprintf("The maximum sustainable rate of oxygen consumption for the given set of parameters is %0.2f. \n", M)

%%
% [Not Use] Task 4.2 
% Task 4 part 2: Find M for different beta; 
% comment out default beta = 0.5 and M = 0.25*cref*5.6

clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

% for manually modifying beta = 0:0.1:1
beta = 1;

for i = 1:100
    disp("Iteration: "+ i)
    M = (0.25*cref*5.6)*i;
    
    setup_lung
    cvsolve
    outchecklung
end

% by modifying beta = 0:0.1:1, 
% I found out that when beta=1:0.1:0.7, M_max = 0.0330 
% and when beta = 0.8:1, M_max = 0.0220
M_max = [repelem(0.0330, 8), repelem(0.0220, 3)];
beta = 0:0.1:1;
figure(5)
plot(beta, M_max, 'o')
hold on
plot(beta, M_max, 'g')
xlabel("beta"); ylabel("maximum sustainable rate of oxygen consumption"); 
title("beta vs max sustainable rate of oxygen consumption")

%%
% [Not use] cannot figure out try and catch statement

clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

beta_list = 0:0.1:1;
cref=0.2/(22.4*(310/273));

M_max =[];
for i = 1:length(beta_list)
    beta = beta_list(i);
    for j = 1:100
        %keep increasing M until cvsolve.m identifies M being too large for the specific beta
        M = (0.25*cref*5.6)*j; 
        M_max(end+1) = M;

        setup_lung
        try
            cvsolve
            outchecklung
            break
        catch Err
            if strcmp(Err.message, 'M is too large')
                M_max(end+1) = NaN;
            end
        end
    end
    
end 

figure(5)
plot(beta_list, M_max,'o')

%% Task 5
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

cref=0.2/(22.4*(310/273));
cI_list=[];
Pv_list5=[]; Pabar_list5=[];PAbar_list5=[];
cv_list5=[]; cabar_list5=[]; cAbar_list5=[];

% comment out cI in setup_lung.m to reset cI values
% increase by 1% in each iteration from 0.5cref
for i = 0.5:0.01:1
    cI = cref*i;
    cI_list(end+1) = cI;
    setup_lung
    cvsolve
    outchecklung

    Pv_list5(end+1) = Pv;       %mean partial pressure in venous blood
    Pabar_list5(end+1) = Pabar; %mean arterial oxygen partial pressure
    PAbar_list5(end+1) = PAbar; %mean alveolar oxygen partial pressure

    cv_list5(end+1) = cv;       %[oxygen] in venous blood
    cabar_list5(end+1) = cabar; %mean arterial [oxygen] 
    cAbar_list5(end+1) = cAbar; %mean alevolar [oxygen]

end

figure(6)
plot(cI_list, Pv_list5)
hold on 
plot(cI_list, Pabar_list5)
plot(cI_list, PAbar_list5)
hold off
legend("Pv","Pabar","PAbar")
xlabel("cI"); ylabel("oxygen partial pressure"); 
title("cI vs oxygen partial pressure")

figure(7)
plot(cI_list, cv_list5)
hold on 
plot(cI_list, cabar_list5)
plot(cI_list, cAbar_list5)
hold off
legend("cv",'cabar','cAbar')
xlabel("cI"); ylabel("oxygen concentration");
title("cI vs oxygen concentration")
%% Task 6
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

Pv_list6=[]; Pabar_list6=[]; PAbar_list6=[];
cv_list6=[]; cabar_list6=[]; cAbar_list6=[];

% comment out cref in setup_lung.m --> reset cref in each iteration

for i = 1:1:300
    cref=0.2/((22.4+i)*(310/273));
    
    setup_lung
    cvsolve
    outchecklung

%     setup_lung
%     try 
%         cvsolve
%         outchecklung

    Pv_list6(end+1) = Pv;       %mean partial pressure in venous blood
    Pabar_list6(end+1) = Pabar; %mean arterial oxygen partial pressure
    PAbar_list6(end+1) = PAbar; %mean alveolar oxygen partial pressure

    cv_list6(end+1) = cv;       %[oxygen] in venous blood
    cabar_list6(end+1) = cabar; %mean arterial [oxygen] 
    cAbar_list6(end+1) = cAbar; %mean alevolar [oxygen]

%         catch ME
%             if strcmp(ME.message, 'M is too large')
%                 fprintf("One cannot sustain with the normal resting rate of oxygen consumption when cref decreases to %0.5f with %d units of altitude increase \n", cref, i)
%             else
%                 rethrow(ME)
%             end
%     end
end

% run after the error message
figure(8)
plot(Pv_list6)
hold on 
plot(Pabar_list6)
plot(PAbar_list6)
hold off
legend("Pv","Pabar","PAbar")
xlabel("altitude"); ylabel("oxygen partial pressure");
title("altitude vs oxygen partial pressure")

figure(9)
plot(cv_list6)
hold on 
plot(cabar_list6)
plot(cAbar_list6)
hold off
legend("cv",'cabar','cAbar')
xlabel("altitude"); ylabel("oxygen concentration");
title("altitude vs oxygen concentration")

fprintf("One cannot sustain with the normal resting rate of oxygen consumption when cref decreases to %0.5f with %d units of altitude increase \n", cref, i)

%% Task 7 

clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

%comment out cstar = cref --> change to cstar = 1.5*cref in setup_lung.m
Pv_list7=[]; Pabar_list7=[]; PAbar_list7=[];
cv_list7=[]; cabar_list7=[]; cAbar_list7=[];

for i = 1:1:300
    cref=0.2/((22.4+i)*(310/273));

    setup_lung
    cvsolve
    outchecklung

    Pv_list7(end+1) = Pv;       %mean partial pressure in venous blood
    Pabar_list7(end+1) = Pabar; %mean arterial oxygen partial pressure
    PAbar_list7(end+1) = PAbar; %mean alveolar oxygen partial pressure

    cv_list7(end+1) = cv;       %[oxygen] in venous blood
    cabar_list7(end+1) = cabar; %mean arterial [oxygen] 
    cAbar_list7(end+1) = cAbar; %mean alevolar [oxygen]
end

% run after the error message
figure(10)
plot(Pv_list7)
hold on 
plot(Pabar_list7)
plot(PAbar_list7)
hold off
legend("Pv","Pabar","PAbar")
xlabel("altitude"); ylabel("oxygen partial pressure");
title("altitude vs oxygen partial pressure")

figure(11)
plot(cv_list7)
hold on 
plot(cabar_list7)
plot(cAbar_list7)
hold off
legend("cv",'cabar','cAbar')
xlabel("altitude"); ylabel("oxygen concentration");
title("altitude vs oxygen concentration")

fprintf("One cannot sustain with the normal resting rate of oxygen consumption when cref decreases to %0.5f with %d units of altitude increase \n", cref, i)

%% Task 8
clear all
clf
global Pstar cstar n maxcount M Q camax RT cI;

beta = 1;

Pv_list8=[]; Pabar_list8=[]; PAbar_list8=[];
cv_list8=[]; cabar_list8=[]; cAbar_list8=[];


% comment out cref in setup_lung.m --> reset cref in each iteration
figure(12)
for i = 1:1:300
    cref=0.2/((22.4+i)*(310/273));
    
    setup_lung
    cvsolve
    outchecklung

    Pv_list8(end+1) = Pv;       %mean partial pressure in venous blood
    Pabar_list8(end+1) = Pabar; %mean arterial oxygen partial pressure
    PAbar_list8(end+1) = PAbar; %mean alveolar oxygen partial pressure

    cv_list8(end+1) = cv;       %[oxygen] in venous blood
    cabar_list8(end+1) = cabar; %mean arterial [oxygen] 
    cAbar_list8(end+1) = cAbar; %mean alevolar [oxygen]
   
end 

% run after error message is raised
fprintf("One cannot sustain with the normal resting rate of oxygen consumption when cref decreases to %0.5f with %d units of altitude increase \n", cref, i)
figure(12)
plot(Pv_list8)
hold on 
plot(Pabar_list8)
plot(PAbar_list8)
hold off
legend("Pv","Pabar","PAbar")
xlabel("altitude"); ylabel("oxygen partial pressure");
title("altitude vs oxygen partial pressure (beta = 1)")

figure(13)
plot(cv_list8)
hold on 
plot(cabar_list8)
plot(cAbar_list8)
hold off
legend("cv",'cabar','cAbar')
xlabel("altitude"); ylabel("oxygen concentration");
title("altitude vs oxygen concentration (beta = 1)")
