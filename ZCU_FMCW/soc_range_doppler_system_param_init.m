%% FMCW Radar Parameters (converted from PDR)
% PDR 변수 이름 유지 — Simulink 모델 호환성 보장

% Environment parameters
propSpeed = physconst('LightSpeed');
Fc = 30e9;
lambda = propSpeed/Fc;

% Inherit sample rate
if ~exist('Fs','var')
    Fs = 250e6;
end
Ts = 1/Fs;

%% FMCW Chirp Parameters
Bandwidth = 150e6;                          % Sweep bandwidth (Hz)
ChirpSamples = 1024;                        % Samples per chirp
Tchirp = ChirpSamples * Ts;                 % Chirp duration (4.096 us)
SweepSlope = Bandwidth / Tchirp;            % Hz/s

% PDR-compatible variable mapping
pulseWidthSamples = 32;                     % TX LUT size (HW: 16-entry × SPC=2)
pulseBw = Bandwidth;                        % Sweep bandwidth
RngGateSamples = 0;                         % FMCW: no range gate (full-duplex)
RxActiveSamples = ChirpSamples;             % 1024
pulsePeriodSamples = ChirpSamples + 50;     % 1024 chirp + 50 flyback = 1074
CPILength = 64;

% Derived parameters (PDR 변수명 유지)
pulseWidth = pulseWidthSamples * Ts;
pulsePeriod = pulsePeriodSamples * Ts;
PRF = 1/pulsePeriod;
CPIPeriod = CPILength * pulsePeriod;
RxActiveTime = RxActiveSamples * Ts;

% FMCW Range/Velocity
RngGate = 0;
RngMin = 0;
RngMax = (Fs * propSpeed) / (2 * SweepSlope);
VelMax = lambda / (4 * Tchirp);

RngRes = propSpeed / (2 * Bandwidth);
VelRes = (VelMax * 2) / CPILength;

RngDimLen = RxActiveSamples;
VelDimLen = CPILength;

RngMaxIdx = RxActiveSamples / 2;            % One-sided FFT (512 bins)
VelMaxIdx = VelDimLen;

RngEstBins = linspace(0, RngMax, RngMaxIdx);
VelEstBins = (2*VelMax/VelMaxIdx) * [(-VelMaxIdx/2:-1) (0:VelMaxIdx/2-1)];

%% FMCW Waveform (complex chirp — LUT I/Q 분리 저장 호환)
t_chirp = (0:pulseWidthSamples-1)' / Fs;
chirpPhase_short = pi * SweepSlope * t_chirp.^2;
txSignal = exp(1j * chirpPhase_short);      % 32-sample complex chirp for TX LUT

t_full = (0:pulsePeriodSamples-1)' / Fs;
chirpPhase_full = pi * SweepSlope * t_full.^2;
txSignalFullPeriod = exp(1j * chirpPhase_full);  % Full period (1074 samples)

% Matched Filter coefficients (used by FIR block, 32-tap 크기 유지)
matchingCoeff = conj(flipud(txSignal));     % 32 complex taps

% De-chirp reference ROM (1024-pt, for Range Processing)
t_dechirp = (0:ChirpSamples-1)' / Fs;
chirpPhase_dechirp = pi * SweepSlope * t_dechirp.^2;
dechirpRefI = cos(chirpPhase_dechirp);      % Real part for de-chirp ROM
dechirpRefQ = sin(chirpPhase_dechirp);      % Imag part for de-chirp ROM

% Hann window (1024-pt, range dimension)
hannWindow1024 = hann(ChirpSamples);

%% Target Parameters (FMCW 범위에 맞게)
target1Az = 0;
target1Dist = 25;       % 25m
target1Speed = 10;      % m/s
target1RCS = 4;

target2Az = 0;
target2Dist = 125;      % 125m
target2Speed = -20;
target2RCS = 2.5;

target1Pos = [target1Dist*cosd(target1Az); target1Dist*sind(target1Az); 0];
target1Vel = -[target1Speed*cosd(target1Az); target1Speed*sind(target1Az); 0];
target2Pos = [target2Dist*cosd(target2Az); target2Dist*sind(target2Az); 0];
target2Vel = -[target2Speed*cosd(target2Az); target2Speed*sind(target2Az); 0];

targetPos = [target1Pos target2Pos];
targetVel = [target1Vel target2Vel];
targetRCS = [target1RCS target2RCS];

%% CFAR Detection (구조 유지)
CFARGuardVel = 1;
CFARGuardRng = 1;
CFARTrainVel = 8;
CFARTrainRng = 16;
CFARGuardRegion = [CFARGuardRng CFARGuardVel];
CFARTrainRegion = [CFARTrainRng CFARTrainVel];
CFARRngPad = CFARGuardRng + CFARTrainRng;
CFARVelPad = CFARGuardVel + CFARTrainVel;
CFARRngIdx = (1+CFARRngPad):(RngMaxIdx-CFARRngPad);
CFARRngBins = RngEstBins(CFARRngIdx);
CFARRngNumBins = numel(CFARRngIdx);
CFARVelIdx = [(1+CFARVelPad):(VelMaxIdx/2 - 2) ...
    (VelMaxIdx/2 + 3):(VelMaxIdx-CFARVelPad)];
CFARVelBins = VelEstBins(CFARVelIdx);
CFARVelNumBins = numel(CFARVelIdx);
CFARProb = 1e-15;
CFARIdx = zeros(2, CFARVelNumBins*CFARRngNumBins);
nn = 1;
for ii = CFARVelIdx
    for jj = CFARRngIdx
        CFARIdx(:,nn) = [jj;ii];
        nn = nn+1;
    end
end
