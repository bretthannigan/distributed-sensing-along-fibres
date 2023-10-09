%% Model Distributed Sensor as RC Ladder
% Code used to prepare figure for distributed sensing paper. Calculates
% initial capacitance/resistance and gauge factor from stress-strain tests
% to model the chain of sensors under different strains. Plots and saves
% the change in series capacitance versus frequency at each strain level,
% compared to zero strain.

MAIN_PATH = ".\Data\Simulations";
EXC_FREQ = 10000;
IS_RC_PARALLEL = true;
filepath = ls(fullfile(MAIN_PATH, "StressStrain-LCR-*.tsv"));
C0_values = zeros(1, size(filepath, 1));
R0_values = zeros(1, size(filepath, 1));
GF_C_values = zeros(1, size(filepath, 1));
GF_R_values = zeros(1, size(filepath, 1));
f = logspace(3, 6, 250);
w = 2*pi*f;
strains_to_evaluate = 0:0.1:0.4;
n_freq = length(f);
n_sensor = size(filepath, 1);
n_strain = length(strains_to_evaluate);
RC_ladder_sys = cell(n_sensor, n_strain);

for i=1:n_sensor
    sensor = filepath(i,18)
    data_in = dlmread(fullfile(MAIN_PATH, filepath(i,:)), '\t', 1, 0);
    strain = data_in(:,5);
    [R, C] = Z2RCSeries(data_in(:,6), data_in(:,7), EXC_FREQ);
    i_start = find(data_in(:,5)>=1e-3, 1, 'first');
    C0_values(i) = mean(C(1:i_start-1));
    R0_values(i) = mean(R(1:i_start-1));
    dCC0 = (C - C0_values(i))/C0_values(i);
    dRR0 = (R - R0_values(i))/R0_values(i);
    linear_fit_C = polyfit(strain, dCC0, 1);
    linear_fit_R = polyfit(strain, dRR0, 1);
    GF_C_values(i) = linear_fit_C(1);
    GF_R_values(i) = linear_fit_R(1);
end

delta_C = zeros(n_freq, n_sensor*n_strain);
figure
strains_per_sensor = [strains_to_evaluate' zeros(length(strains_to_evaluate), n_sensor - 1)];
C0 = zeros(n_freq, n_sensor);
for i_sensor=1:n_sensor
    subplot(n_sensor, 1, i_sensor)
    for i_strain=1:n_strain
        Cn = C0_values.*GF_C_values.*strains_per_sensor(i_strain,:) + C0_values;
        Rn = R0_values.*GF_R_values.*strains_per_sensor(i_strain,:) + R0_values;
        RC_ladder_sys{i_sensor, i_strain} = 1/RCLadderN(fliplr(Rn), fliplr(Cn));
        h = freqresp(RC_ladder_sys{i_sensor, i_strain}, w);
        if IS_RC_PARALLEL
            [~, C] = Z2RCParallel(abs(squeeze(h)), rad2deg(angle(squeeze(h))), (w/(2*pi))');
        else
            [~, C] = Z2RCSeries(abs(squeeze(h)), rad2deg(angle(squeeze(h))), (w/(2*pi))');
        end
        if ~any(strains_per_sensor(i_strain,:))
            C0(:,i_sensor) = C;
        end
        delta_C(:,(i_sensor-1)*n_strain+i_strain) = C-C0(:,i_sensor);
        semilogx(w, C-C0(:,i_sensor))
        hold on
    end
    strains_per_sensor = circshift(strains_per_sensor, 1, 2);
end

if IS_RC_PARALLEL
    col_names = {'sensor', 'strain', 'f', 'dCp'};
    out_file_name = 'DeltaCsSimulated_RCParallel';
else
    col_names = {'sensor', 'strain', 'f', 'dCs'};
    out_file_name = 'DeltaCsSimulated_RCSeries';
end
T = table(repelem({'A'; 'B'; 'C'; 'D'}, n_freq*n_strain), repmat(repelem(strains_to_evaluate', n_freq), n_sensor, 1), repmat(f', n_sensor*n_strain, 1), delta_C(:), 'VariableNames', col_names);
writetable(T, ['./' out_file_name '.txt'])

function [Rs, Cs] = Z2RCSeries(Zmag, Zphase, f)
    Rs = Zmag.*cos(Zphase*pi/180);
    Q = Zmag.*sin(Zphase*pi/180);
    Cs = -1./(2*pi.*f.*Zmag.*sin(Zphase*pi/180));
end

function [Rp, Cp] = Z2RCParallel(Zmag, Zphase, f)
    I = Zmag.*cos(Zphase*pi/180);
    Q = Zmag.*sin(Zphase*pi/180);
    I2Q2 = I.^2 + Q.^2;
    Rp = I2Q2./I;
    Cp = -Q./(2*pi.*f.*I2Q2);
end