%% RFSoC Parameters

% ADC and DAC RF sampling rate
ConverterSampleRate = 2e9; 

% ADC and DAC bits
DACNumBits = 14;
ADCNumBits = 12;

% DDC and DUC factor
DecimInterpFactor = 8;

% Effective data sampling rate
Fs = ConverterSampleRate/DecimInterpFactor;

% Samples per clock cycle
SamplesPerClockCycle = 2;

% FPGA clock rate
FPGAClkRate = Fs/SamplesPerClockCycle;
TsFPGA = 1/FPGAClkRate;

% Number of ADC and DAC channels
NumChan = 4;

% Sample data width
SampleDataWidth = 16*2; % 16-bit I/Q samples

%% Common System Parameters

soc_range_doppler_system_param_init;

%% UDP Command Initialization

udp_cmd = struct();
udp_cmd.MessageLength = 10;
udp_cmd.Exit = 0;
udp_cmd.Tx_Gain = 1;
udp_cmd.CPI_Length = 2;
udp_cmd.CPI_Start = 3;
udp_cmd.Rx_Delay_Cycles = 4;
udp_cmd.Target_Info = 5;


%% Fixed-point Datatypes
inputDT = fixdt(1,ADCNumBits,ADCNumBits-1);
outputDT = fixdt(1,16,15);
txGainDT = fixdt(1,18,16);
filterOutDT = fixdt(1,16,14);

%% Radar Target Emulator Parameters

% NCO parameters for Doppler shift
TargetEmulator_NCO_accum_wl = 32;
TargetEmulator_NCO_quantizer_wl = 12;
TargetEmulator_NCO_dither_wl = 22;
TargetEmulator_NCO_out_wl = 16;

% Maximum target range delay in clock cycles
TargetEmulator_MaxDelayLength = 2^nextpow2(2*FPGAClkRate*RngMax/propSpeed);

% Maximum number of simultaneous targets
TargetEmulator_NumChannels = 4;

% Target update timestep
TargetEmulator_UpdateTime = 0.01;

% Number of timesteps to emulate
TargetEmulator_NumSteps = 200;

% Target emulator configuration structure
TargetEmulator_InfoStruct = struct;
TargetEmulator_InfoStruct.NumChannels = TargetEmulator_NumChannels;
TargetEmulator_InfoStruct.Enabled = false(1,TargetEmulator_NumChannels);
TargetEmulator_InfoStruct.Position = zeros(3,TargetEmulator_NumChannels,'single');
TargetEmulator_InfoStruct.Velocity = zeros(3,TargetEmulator_NumChannels,'single');
TargetEmulator_InfoStruct.RCS = zeros(1,TargetEmulator_NumChannels,'single');
info = Simulink.Bus.createObject(TargetEmulator_InfoStruct);
TargetEmulatorInfo = evalin('base', info.busName);
clear(info.busName);


% Radar target emulator parameters
TargetInfo = TargetEmulator_InfoStruct;
TargetInfo.Enabled(1) = true;
TargetInfo.Position(:,1) = target1Pos;
TargetInfo.Velocity(:,1) = target1Vel;
TargetInfo.RCS(1) = target1RCS;
TargetInfo.Enabled(2) = true;
TargetInfo.Position(:,2) = target2Pos;
TargetInfo.Velocity(:,2) = target2Vel;
TargetInfo.RCS(2) = target2RCS;

%% Cycle Count
% Number of clock cycles delay from Tx to Rx loopback (measured in hardware)
LoopbackDelayCycles = 63;

% Number of clock cycles delay for start of Rx active window
RxDelayCycles = RngGateSamples/SamplesPerClockCycle + LoopbackDelayCycles*2;

% Number of cycles Rx is active
RxActiveCycles = RxActiveSamples/SamplesPerClockCycle;

%% DMA Information
% Stream to memory map (FPGA to Processor)
S2MM_DMAFrameLength = RngDimLen*VelDimLen/SamplesPerClockCycle;
S2MM_DMAFrameSize = S2MM_DMAFrameLength*8;
S2MM_DMANumBuffers = 16;

%% Sample Time
TsHost = 5e-5;
TsPulse = pulsePeriod;
TsFrame = pulsePeriod*CPILength;
TsTargetUpdate = TargetEmulator_UpdateTime;
TsSWBase = 0.2;

%% Simulation Parameter

stoptime = TsFrame*2;
