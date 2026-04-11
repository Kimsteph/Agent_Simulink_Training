%% FMCW Radar E2E Test Script
% PDR 구조 유지, Range Processing만 FMCW로 교체
% 실행: >> cd('D:\My_Projects\CC\Agent_Simulink_Training\ZCU_FMCW'); fmcw_run_test;

%% Parameters (PDR 구조 유지)
propSpeed = physconst("LightSpeed");
ConverterSampleRate = 2e9;
DecimInterpFactor = 8;
Fs = ConverterSampleRate / DecimInterpFactor;  % 250 MHz
SamplesPerClockCycle = 2;
FPGAClkRate = Fs / SamplesPerClockCycle;       % 125 MHz

Fc = 30e9;
lambda = propSpeed / Fc;
ChirpBW = 200e6;
ChirpSamples = 1024;
Tsweep = ChirpSamples / Fs;     % 4.096 us
ChirpRate = ChirpBW / Tsweep;
CPILength = 64;

RngRes = propSpeed / (2 * ChirpBW);
range_axis = (0:ChirpSamples/2-1) * Fs/ChirpSamples * propSpeed*Tsweep/(2*ChirpBW);
vel_axis = (-CPILength/2:CPILength/2-1) * lambda/(2*CPILength*Tsweep);

fprintf("FMCW: Fs=%.0fMHz, BW=%.0fMHz, N=%d, CPI=%d, RngRes=%.2fm\n", ...
    Fs/1e6, ChirpBW/1e6, ChirpSamples, CPILength, RngRes);

%% Targets (사용자 설정)
targets = struct('range', {25, 125, 150}, ...
                 'velocity', {10, -30, 50}, ...
                 'rcs', {1.0, 0.7, 0.5});

%% FMCW Processing Pipeline
n = (0:ChirpSamples-1)';
phase_tx = 2*pi * ChirpRate/2 * (n/Fs).^2;
tx_ref = cos(phase_tx);
hannWin = hann(ChirpSamples);

cpi_buffer = zeros(ChirpSamples, CPILength);

for chirp_idx = 1:CPILength
    rx = zeros(ChirpSamples, 1);
    for t = 1:length(targets)
        tau = 2 * targets(t).range / propSpeed;
        d = round(tau * Fs);
        fd = 2 * targets(t).velocity * Fc / propSpeed;
        phase_rx = 2*pi * ChirpRate/2 * ((n-d)/Fs).^2;
        rx = rx + targets(t).rcs * cos(phase_rx + 2*pi*fd*chirp_idx*Tsweep);
    end
    rx = rx + 0.01 * randn(ChirpSamples, 1);

    beat = tx_ref .* rx;              % De-chirp
    beat_win = beat .* hannWin;       % Hann window
    cpi_buffer(:, chirp_idx) = fft(beat_win, ChirpSamples);  % Range FFT
end

% Velocity FFT
rd_map = fftshift(fft(cpi_buffer, CPILength, 2), 2);
rd_mag = abs(rd_map(1:ChirpSamples/2, :)).^2;
rd_db = 10*log10(rd_mag + 1e-10);

%% Detection
fprintf("\n===== Detection Results =====\n");
rd_search = rd_mag;
for pk = 1:length(targets)
    [~, idx] = max(rd_search(:));
    [ri, vi] = ind2sub(size(rd_search), idx);
    R = range_axis(ri); V = vel_axis(vi);
    fprintf("T%d: R=%.1fm (expect %dm), v=%.1fm/s, error=%.1f%%\n", ...
        pk, R, targets(pk).range, V, abs(R-targets(pk).range)/targets(pk).range*100);
    rd_search(max(1,ri-5):min(end,ri+5), max(1,vi-5):min(end,vi+5)) = 0;
end

%% Plot
figure("Position", [100 100 1000 700]);
subplot(2,1,1);
imagesc(vel_axis, range_axis, rd_db);
xlabel("Velocity (m/s)"); ylabel("Range (m)");
title("FMCW Range-Doppler Map"); colorbar; colormap(jet);
clim([max(rd_db(:))-40, max(rd_db(:))]); set(gca,"YDir","normal"); ylim([0 200]);

subplot(2,1,2);
plot(range_axis, rd_db(:,round(CPILength/2)+1), "b", "LineWidth", 1.5);
xlabel("Range (m)"); ylabel("Power (dB)");
title("Range Profile"); grid on; xlim([0 200]);
hold on;
for t = 1:length(targets)
    xline(targets(t).range, "r--", sprintf("%dm", targets(t).range));
end
hold off;
