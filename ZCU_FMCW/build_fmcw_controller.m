%% FMCW Controller FSM — Stateflow-based chirp timing controller
% L11.4: Creates fmcw_controller_test model with Stateflow Chart DUT

%% Parameters
modelName = "fmcw_controller_test";
sampleTime = 1/200e6;  % 200 MHz FPGA clock
samplesPerChirp = uint16(1024);
flybackSamples = uint16(50);
testNumChirps = uint16(4);

%% Cleanup existing model
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end

%% Create model
new_system(modelName);
open_system(modelName);

% Calculate stop time
totalClocks = double(testNumChirps) * (double(samplesPerChirp) + double(flybackSamples)) + 200;
stopTime = totalClocks * sampleTime;

% Set solver for discrete/HDL system
set_param(modelName, ...
    "Solver", "FixedStepDiscrete", ...
    "FixedStep", num2str(sampleTime), ...
    "StopTime", num2str(stopTime, "%.15g"));

%% Create DUT Subsystem
dutPath = modelName + "/FMCW_Controller";
add_block("simulink/Ports & Subsystems/Subsystem", dutPath, ...
    "Position", [300 100 500 350]);
set_param(dutPath, "TreatAsAtomicUnit", "on");

% Remove default blocks inside subsystem
delete_line(dutPath, "In1/1", "Out1/1");
delete_block(dutPath + "/In1");
delete_block(dutPath + "/Out1");

%% Add Stateflow Chart inside DUT
chartPath = dutPath + "/FSM";
add_block("sflib/Chart", chartPath, "Position", [200 80 500 320]);

%% Configure Stateflow Chart (BEFORE connecting lines)
rt = sfroot();
chartObj = rt.find("-isa", "Stateflow.Chart", "Path", char(chartPath));
chartObj.ActionLanguage = "MATLAB";

% --- Data: Inputs ---
dEnable = Stateflow.Data(chartObj);
dEnable.Name = "enable";
dEnable.Scope = "Input";
dEnable.DataType = "boolean";

dNumChirps = Stateflow.Data(chartObj);
dNumChirps.Name = "num_chirps";
dNumChirps.Scope = "Input";
dNumChirps.DataType = "uint16";

% --- Data: Outputs (order matters for port numbering) ---
dChirpActive = Stateflow.Data(chartObj);
dChirpActive.Name = "chirp_active";
dChirpActive.Scope = "Output";
dChirpActive.DataType = "boolean";

dRomAddr = Stateflow.Data(chartObj);
dRomAddr.Name = "rom_addr";
dRomAddr.Scope = "Output";
dRomAddr.DataType = "uint16";

dSampleCount = Stateflow.Data(chartObj);
dSampleCount.Name = "sample_count";
dSampleCount.Scope = "Output";
dSampleCount.DataType = "uint16";

dChirpCount = Stateflow.Data(chartObj);
dChirpCount.Name = "chirp_count";
dChirpCount.Scope = "Output";
dChirpCount.DataType = "uint16";

dCpiDone = Stateflow.Data(chartObj);
dCpiDone.Name = "cpi_done";
dCpiDone.Scope = "Output";
dCpiDone.DataType = "boolean";

dDmaActive = Stateflow.Data(chartObj);
dDmaActive.Name = "dma_active";
dDmaActive.Scope = "Output";
dDmaActive.DataType = "boolean";

% --- Data: Local ---
dFlybackCount = Stateflow.Data(chartObj);
dFlybackCount.Name = "flyback_count";
dFlybackCount.Scope = "Local";
dFlybackCount.DataType = "uint16";

dDmaCount = Stateflow.Data(chartObj);
dDmaCount.Name = "dma_count";
dDmaCount.Scope = "Local";
dDmaCount.DataType = "uint16";

% --- Data: Local constants ---
dSamplesPerChirp = Stateflow.Data(chartObj);
dSamplesPerChirp.Name = "SAMPLES_PER_CHIRP";
dSamplesPerChirp.Scope = "Local";
dSamplesPerChirp.DataType = "uint16";
dSamplesPerChirp.Props.InitialValue = "1024";

dFlybackSamples = Stateflow.Data(chartObj);
dFlybackSamples.Name = "FLYBACK_SAMPLES";
dFlybackSamples.Scope = "Local";
dFlybackSamples.DataType = "uint16";
dFlybackSamples.Props.InitialValue = "50";

dDmaCycles = Stateflow.Data(chartObj);
dDmaCycles.Name = "DMA_CYCLES";
dDmaCycles.Scope = "Local";
dDmaCycles.DataType = "uint16";
dDmaCycles.Props.InitialValue = "100";

%% Create States
% IDLE
sIdle = Stateflow.State(chartObj);
sIdle.Name = "IDLE";
sIdle.Position = [80 60 200 160];
sIdle.LabelString = sprintf(join([ ...
    "IDLE"; ...
    "en: chirp_active = false;"; ...
    "en: rom_addr = uint16(0);"; ...
    "en: sample_count = uint16(0);"; ...
    "en: chirp_count = uint16(0);"; ...
    "en: cpi_done = false;"; ...
    "en: dma_active = false;"; ...
    "en: flyback_count = uint16(0);"; ...
    "en: dma_count = uint16(0);"], newline));

% CHIRP_ACTIVE
sChirpActive = Stateflow.State(chartObj);
sChirpActive.Name = "CHIRP_ACTIVE";
sChirpActive.Position = [80 300 250 120];
sChirpActive.LabelString = sprintf(join([ ...
    "CHIRP_ACTIVE"; ...
    "en: chirp_active = true;"; ...
    "en: cpi_done = false;"; ...
    "du: rom_addr = sample_count;"; ...
    "du: sample_count = sample_count + uint16(1);"], newline));

% FLYBACK
sFlyback = Stateflow.State(chartObj);
sFlyback.Name = "FLYBACK";
sFlyback.Position = [450 300 250 120];
sFlyback.LabelString = sprintf(join([ ...
    "FLYBACK"; ...
    "en: chirp_active = false;"; ...
    "en: chirp_count = chirp_count + uint16(1);"; ...
    "en: flyback_count = uint16(0);"; ...
    "du: flyback_count = flyback_count + uint16(1);"], newline));

% CPI_DONE
sCpiDone = Stateflow.State(chartObj);
sCpiDone.Name = "CPI_DONE";
sCpiDone.Position = [450 60 200 80];
sCpiDone.LabelString = sprintf(join([ ...
    "CPI_DONE"; ...
    "en: cpi_done = true;"; ...
    "en: chirp_active = false;"], newline));

% DMA_OUT
sDmaOut = Stateflow.State(chartObj);
sDmaOut.Name = "DMA_OUT";
sDmaOut.Position = [450 500 250 100];
sDmaOut.LabelString = sprintf(join([ ...
    "DMA_OUT"; ...
    "en: dma_active = true;"; ...
    "en: cpi_done = false;"; ...
    "en: dma_count = uint16(0);"; ...
    "du: dma_count = dma_count + uint16(1);"], newline));

%% Create Transitions
% Default transition to IDLE
dtrans = Stateflow.Transition(chartObj);
dtrans.Source = [];
dtrans.Destination = sIdle;
dtrans.SourceOClock = 0;
dtrans.DestinationOClock = 0;

% IDLE -> CHIRP_ACTIVE [enable == true]
t1 = Stateflow.Transition(chartObj);
t1.Source = sIdle;
t1.Destination = sChirpActive;
t1.LabelString = "[enable == true]";
t1.SourceOClock = 6;
t1.DestinationOClock = 0;

% CHIRP_ACTIVE -> FLYBACK [sample_count >= SAMPLES_PER_CHIRP]
t2 = Stateflow.Transition(chartObj);
t2.Source = sChirpActive;
t2.Destination = sFlyback;
t2.LabelString = "[sample_count >= SAMPLES_PER_CHIRP]";
t2.SourceOClock = 3;
t2.DestinationOClock = 9;

% FLYBACK -> CHIRP_ACTIVE [more chirps needed]
t3 = Stateflow.Transition(chartObj);
t3.Source = sFlyback;
t3.Destination = sChirpActive;
t3.LabelString = "[chirp_count < num_chirps && flyback_count >= FLYBACK_SAMPLES] / sample_count = uint16(0);";
t3.SourceOClock = 9;
t3.DestinationOClock = 3;

% FLYBACK -> CPI_DONE [all chirps completed]
t4 = Stateflow.Transition(chartObj);
t4.Source = sFlyback;
t4.Destination = sCpiDone;
t4.LabelString = "[chirp_count >= num_chirps && flyback_count >= FLYBACK_SAMPLES]";
t4.SourceOClock = 0;
t4.DestinationOClock = 6;

% CPI_DONE -> DMA_OUT (unconditional, 1 clock pulse for cpi_done)
t5 = Stateflow.Transition(chartObj);
t5.Source = sCpiDone;
t5.Destination = sDmaOut;
t5.LabelString = "";
t5.SourceOClock = 6;
t5.DestinationOClock = 0;

% DMA_OUT -> IDLE [dma transfer complete]
t6 = Stateflow.Transition(chartObj);
t6.Source = sDmaOut;
t6.Destination = sIdle;
t6.LabelString = "[dma_count >= DMA_CYCLES]";
t6.SourceOClock = 9;
t6.DestinationOClock = 9;

%% Now add Inport/Outport blocks and connect lines inside DUT
% Inputs
add_block("simulink/Sources/In1", dutPath + "/enable", "Position", [50 100 80 114]);
add_block("simulink/Sources/In1", dutPath + "/num_chirps", "Position", [50 160 80 174]);

% Outputs
add_block("simulink/Sinks/Out1", dutPath + "/chirp_active", "Position", [600 80 630 94]);
add_block("simulink/Sinks/Out1", dutPath + "/rom_addr", "Position", [600 130 630 144]);
add_block("simulink/Sinks/Out1", dutPath + "/sample_count", "Position", [600 180 630 194]);
add_block("simulink/Sinks/Out1", dutPath + "/chirp_count", "Position", [600 230 630 244]);
add_block("simulink/Sinks/Out1", dutPath + "/cpi_done", "Position", [600 280 630 294]);
add_block("simulink/Sinks/Out1", dutPath + "/dma_active", "Position", [600 330 630 344]);

% Connect inputs to chart
add_line(dutPath, "enable/1", "FSM/1", "autorouting", "smart");
add_line(dutPath, "num_chirps/1", "FSM/2", "autorouting", "smart");

% Connect chart outputs
add_line(dutPath, "FSM/1", "chirp_active/1", "autorouting", "smart");
add_line(dutPath, "FSM/2", "rom_addr/1", "autorouting", "smart");
add_line(dutPath, "FSM/3", "sample_count/1", "autorouting", "smart");
add_line(dutPath, "FSM/4", "chirp_count/1", "autorouting", "smart");
add_line(dutPath, "FSM/5", "cpi_done/1", "autorouting", "smart");
add_line(dutPath, "FSM/6", "dma_active/1", "autorouting", "smart");

%% Add test harness blocks (top level)
% Constant: enable = true (boolean)
add_block("simulink/Sources/Constant", modelName + "/enable", ...
    "Position", [50 120 100 140], ...
    "Value", "true", ...
    "OutDataTypeStr", "boolean");

% Constant: num_chirps = 4 (uint16)
add_block("simulink/Sources/Constant", modelName + "/num_chirps", ...
    "Position", [50 200 100 220], ...
    "Value", "uint16(4)", ...
    "OutDataTypeStr", "uint16");

% Connect inputs to DUT
add_line(modelName, "enable/1", "FMCW_Controller/1", "autorouting", "smart");
add_line(modelName, "num_chirps/1", "FMCW_Controller/2", "autorouting", "smart");

% To Workspace blocks for outputs
outputNames = ["chirp_active", "rom_addr", "sample_count", "chirp_count", "cpi_done", "dma_active"];
yPositions = [100, 150, 200, 250, 300, 350];

for idx = 1:numel(outputNames)
    blkName = "ws_" + outputNames(idx);
    blkPath = modelName + "/" + blkName;
    add_block("simulink/Sinks/To Workspace", blkPath, ...
        "Position", [650 yPositions(idx) 750 yPositions(idx)+20], ...
        "VariableName", outputNames(idx), ...
        "SaveFormat", "Timeseries");
    add_line(modelName, "FMCW_Controller/" + idx, blkName + "/1", "autorouting", "smart");
end

%% Arrange and save
Simulink.BlockDiagram.arrangeSystem(dutPath);
Simulink.BlockDiagram.arrangeSystem(modelName);
save_system(modelName, fullfile(pwd, modelName + ".slx"));

fprintf("Model '%s' created successfully.\n", modelName);
fprintf("StopTime = %g s (%d clocks)\n", stopTime, totalClocks);
