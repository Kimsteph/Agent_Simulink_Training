%% FMCW Radar SoC Initialization
% Converted from PDR (soc_range_doppler_init.m)
% Changes: continuous chirp, de-chirp processing, no pulse gating

%% RFSoC Parameters
ConverterSampleRate = 3.2e9;    % ADC/DAC RF sampling rate (was 2e9)
ADCNumBits = 12;
DACNumBits = 14;
DecimInterpFactor = 8;          % DDC/DUC factor

% Effective data sampling rate
Fs = ConverterSampleRate / DecimInterpFactor;  % 400 MHz (was 250 MHz)

% Samples per clock cycle
SamplesPerClockCycle = 2;

% FPGA clock rate
FPGAClkRate = Fs / SamplesPerClockCycle;  % 200 MHz (was 125 MHz)
TsFPGA = 1 / FPGAClkRate;

%% FMCW Chirp Parameters
propSpeed = physconst("LightSpeed");
Fc = 1e9;                      % Carrier frequency (was 30 GHz)
lambda = propSpeed / Fc;

ChirpBW = 200e6;               % Sweep bandwidth
ChirpSamples = 1024;           % Samples per chirp
FlybackSamples = 50;           % Gap between chirps
ChirpTotalSamples = ChirpSamples + FlybackSamples;  % 1074
Tsweep = ChirpSamples / Fs;    % 2.56 us

ChirpRate = ChirpBW / Tsweep;  % Hz/s

% CPI (Coherent Processing Interval)
CPILength = 256;                % Chirps per CPI (was 64 pulses)
CPIPeriod = CPILength * ChirpTotalSamples / Fs;

%% Range Parameters
RngRes = propSpeed / (2 * ChirpBW);     % Range resolution = 0.75 m
RngMax = Fs * propSpeed * Tsweep / (4 * ChirpBW);  % Max unambiguous range

RngDimLen = ChirpSamples;      % Range FFT bins
VelDimLen = CPILength;         % Velocity FFT bins

fprintf("FMCW Radar Parameters:\n");
fprintf("  Fs = %.0f MHz, FPGA Clk = %.0f MHz\n", Fs/1e6, FPGAClkRate/1e6);
fprintf("  Chirp: BW=%.0f MHz, N=%d, Tsweep=%.2f us\n", ChirpBW/1e6, ChirpSamples, Tsweep*1e6);
fprintf("  CPI: %d chirps, %.1f us\n", CPILength, CPIPeriod*1e6);
fprintf("  Range: res=%.2f m, max=%.0f m\n", RngRes, RngMax);

%% Velocity Parameters
VelMax = lambda / (4 * Tsweep);         % Max unambiguous velocity
VelRes = lambda / (2 * CPILength * Tsweep);

fprintf("  Velocity: res=%.2f m/s, max=%.1f m/s\n", VelRes, VelMax);

%% Range/Velocity Axes
RngEstBins = linspace(0, RngMax, RngDimLen/2);
VelEstBins = linspace(-VelMax, VelMax, VelDimLen);

%% Fixed-point Data Types
inputDT = fixdt(1, ADCNumBits, ADCNumBits-1);
chirpDT = fixdt(1, 16, 14);
beatDT = fixdt(1, 16, 14);
outputDT = fixdt(1, 16, 15);

%% DMA Information
S2MM_DMAFrameLength = RngDimLen * VelDimLen / SamplesPerClockCycle;  % 131072
S2MM_DMAFrameSize = S2MM_DMAFrameLength * 8;  % 1 MB
S2MM_DMANumBuffers = 8;

fprintf("  DMA: %d words × 8B = %.0f KB per CPI\n", S2MM_DMAFrameLength, S2MM_DMAFrameSize/1024);

%% RFDC NCO Settings
ADC_NCO_Frequency = -1000;  % MHz (was -500)
DAC_NCO_Frequency = 1000;   % MHz (was 500)

%% Target Parameters (for simulation/emulation)
target1Range = 50;     % meters
target1Vel = 30;       % m/s
target1RCS = 4;

target2Range = 120;    % meters
target2Vel = -20;      % m/s
target2RCS = 2;

%% Simulation Time
stoptime = CPIPeriod * 2;  % 2 CPIs
