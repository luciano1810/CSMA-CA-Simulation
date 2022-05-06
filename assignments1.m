%%
clc;
clear;

%% Parameters Setting
data_size = 1548*8;
ACK_size = 10*8;

data_time = 200e-6;
ACK_time = 32e-6;

SIFS = 16e-6;
DIFS = 34e-6;
aSlotTime = 9e-6;

CW_min = 7;
CW_max = 1023;

STAs = 500; %Number of STAs
efficiency = 1:STAs;

total_trans_num = 20000;

%% Simulation
for STA=1:STAs
transmission_num = 0;

total_time = 0;
eff_time = 0;

CW = CW_min * ones(STA,1);

% Random Backoff Generation
for i = 1:STA
    backoff_slot = randi([0 CW(i)],[STA 1]);
end

%%
t = 0;
while transmission_num < total_trans_num
[min_time,index] = min(backoff_slot);
backoff_slot = backoff_slot - min_time;

total_time = total_time + min_time * aSlotTime;

transmitt_num = 0;

for i = 1:STA
    if backoff_slot(i) == 0
        transmitt_num = transmitt_num + 1;
    end
end

% Transmitt Data
total_time = total_time + data_time;
if transmitt_num == 1
    total_time  = total_time + SIFS + ACK_time + DIFS;
    eff_time = eff_time + data_time + ACK_time;
    transmission_num = transmission_num + 1;
        if STA == 50
            eff50(transmission_num) = eff_time / total_time;
        end
    for i = 1:STA           
        if i == index
            CW(i) = CW_min;
            backoff_slot(i) = randi([0 CW(i)]);
        end
    end
else
    total_time = total_time + DIFS;
    for i = 1:STA
        if backoff_slot(i) == 0
            if CW(i) ~= CW_max
                CW(i) = CW(i) * 2 + 1;
            end
            backoff_slot(i) = randi([0 CW(i)]);         
        end
    end
end
t = t + 1;

end
        if STA == 50
            figure(1);
            plot(eff50);
            title("Transmission Efficiency versus Transmission Number")
            xlabel('Transmission Number')
            ylabel('Transmission Efficiency')
        end
% disp(t);
% eff = eff_time / total_time
efficiency(STA) = eff_time / total_time;

end

%%
figure(2);
plot(efficiency(1:STAs));
title('Efficiency versus Number of STAs')
xlabel('number of STAs')
ylabel('Transmission Efficiency')
