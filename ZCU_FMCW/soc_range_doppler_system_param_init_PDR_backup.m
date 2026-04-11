%% Radar Parameters

% Environment parameters
propSpeed = physconst('LightSpeed'); % Propagation speed
Fc = 30e9; % Operating or carrier frequency
lambda = propSpeed/Fc;

% Inherit sample rate
if ~exist('Fs','var')
    Fs = 250e6;
end
Ts = 1/Fs;

% Application parameters
pulseWidthSamples = 32;
pulseBw = 200e6; % Pulse bandwidth
RngGateSamples = 176;
RxActiveSamples = 1024;
pulsePeriodSamples = 1952;
CPILength = 64; % Number of pulses in a coherent processing interval(CPI)

% Derived parameters
pulseWidth = pulseWidthSamples*Ts; % Pulse width
pulsePeriod = pulsePeriodSamples*Ts; % Pulse repetition period
PRF = 1/pulsePeriod; % Pulse repetition frequency
CPIPeriod = CPILength*pulsePeriod;
RxActiveTime = RxActiveSamples*Ts;

RngGate = RngGateSamples*Ts; % Range gate start
RngMin = propSpeed*RngGate/2;
RngMax = propSpeed*(RngGate+RxActiveTime-pulseWidth)/2; % Maximum unambiguous range
VelMax = propSpeed*PRF/(Fc*4); % Maximum unambiguous velocity

RngRes = (RngMax-RngMin)/RxActiveSamples; % Range resolution
VelRes = (VelMax*2)/CPILength; % Velocity resolution

RngDimLen = RxActiveSamples;
VelDimLen = CPILength;

RngMaxIdx = round((RxActiveTime-pulseWidth)*Fs);
VelMaxIdx = VelDimLen;

RngEstBins = linspace(RngMin,RngMax,RngMaxIdx);
VelEstBins = (2*VelMax/VelMaxIdx)*[(-VelMaxIdx/2:-1) (0:VelMaxIdx/2-1)];

% Matched filter parameters
hwav = phased.LinearFMWaveform(...
    'PulseWidth',pulseWidth,...
    'PRF',PRF,...
    'SweepBandwidth',pulseBw,...
    'SampleRate',Fs);
matchingCoeff = getMatchedFilter(hwav);
txSignalFullPeriod = hwav();
txSignal = txSignalFullPeriod(1:pulseWidthSamples);

%% Target Parameters

target1Az = 50;
target1Dist = 400;
target1Speed = -80;
target1RCS = 8;

target2Az = -47;
target2Dist = 250;
target2Speed = 40;
target2RCS = 2.5;


target1Pos = [target1Dist*cosd(target1Az); target1Dist*sind(target1Az); 0];
target1Vel = -[target1Speed*cosd(target1Az); target1Speed*sind(target1Az); 0];
target2Pos = [target2Dist*cosd(target2Az); target2Dist*sind(target2Az); 0];
target2Vel = -[target2Speed*cosd(target2Az); target2Speed*sind(target2Az); 0];

targetPos = [target1Pos target2Pos];
targetVel = [target1Vel target2Vel];
targetRCS = [target1RCS target2RCS];

%% CFAR Detection
CFARGuardVel = 1;
CFARGuardRng = 1;
CFARTrainVel = 8;
CFARTrainRng = 16;
CFARGuardRegion = [CFARGuardRng CFARGuardVel];
CFARTrainRegion = [CFARTrainRng CFARTrainVel];
CFARRngPad = CFARGuardRng+CFARTrainRng;
CFARVelPad = CFARGuardVel+CFARTrainVel;
CFARRngIdx = (1+CFARRngPad):(RngMaxIdx-CFARRngPad);
CFARRngBins = RngEstBins(CFARRngIdx);
CFARRngNumBins = numel(CFARRngIdx);
CFARVelIdx = [(1+CFARVelPad):(VelMaxIdx/2 - 2) ...
    (VelMaxIdx/2 + 3):(VelMaxIdx-CFARVelPad)];
CFARVelBins = VelEstBins(CFARVelIdx);
CFARVelNumBins = numel(CFARVelIdx);
CFARProb = 1e-15;
CFARIdx = zeros(2,CFARVelNumBins*CFARRngNumBins);
nn = 1;
for ii=CFARVelIdx
    for jj=CFARRngIdx
        CFARIdx(:,nn) = [jj;ii];
        nn=nn+1;
    end
end