% This script was automatically generated on 2026-04-10 16:05:07, during
% SoC Blockset design generation

% Generated design information:
%	Target platform: XilinxZynqUltraScale_RFSoCZCU111EvaluationKit
%	Generated bitstream: D:\My_Projects\CC\PDR\soc_prj2\soc_range_doppler_top-XilinxZynqUltraScale_RFSoCZCU111EvaluationKit.bit

% NOTE: You must program the FPGA with the generated bitstream file
% before running this script

% Copyright 2026 The MathWorks, Inc.

%% Load saved AXI manager info
% This file contains information used by this script
% Available structs in this file: s2mm_dma, radar_target_emulator_ip, range_doppler_tx_rx_ip, memRegions
load('D:\My_Projects\CC\PDR\soc_prj2\soc_range_doppler_top_XilinxZynqUltraScale_RFSoCZCU111EvaluationKit_aximanager.mat');

% Create hardware object
hwObj = socHardwareBoard('Xilinx Zynq UltraScale+ RFSoC ZCU111 Evaluation Kit','Connect',false);

%% Create socAXIManager object

AXIManagerObj = socAXIManager(hwObj);

%% User settings

% Initialize memory contents

%% Initialize built-in IP core(s) 

% Create IP core object for DMA core
s2mm_dmaCoreObj=socIPCore(AXIManagerObj, s2mm_dma,'DMA');
% Initialize DMA core
initialize(s2mm_dmaCoreObj,'memoryRegion',memRegions);

%% Initialize user IP core(s)

init_radar_target_emulator_ip(AXIManagerObj, radar_target_emulator_ip);

init_range_doppler_tx_rx_ip(AXIManagerObj, range_doppler_tx_rx_ip);

%% Run testbench

% Adjust 'NumRuns' variable to change the number of consecutive runs of the testbench
NumRuns = 1;
for n = 1:NumRuns
    % Insert testbench stimulus here ...
end

%% Release AXI Manager object

AXIManagerObj.release;

%%
% -------------------------------------------------------------------------------
%
% SUPPORT FUNCTIONS
%
% -------------------------------------------------------------------------------
%%

function init_radar_target_emulator_ip(AXIManagerObj, radar_target_emulator_ip)

%% Register space for radar_target_emulator_ip IP core.
writememory(AXIManagerObj,radar_target_emulator_ip.IPCore_Reset, uint32(1)); % Reset IP core

% AXI4-Lite Memory-Mapped register access
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,radar_target_emulator_ip.Target_Emulator_Doppler_Inc, uint32([0  0  0  0]));
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,radar_target_emulator_ip.Target_Emulator_Range_Delay, uint32([0  0  0  0]));
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,radar_target_emulator_ip.Target_Emulator_Gain, uint32([0  0  0  0]));
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,radar_target_emulator_ip.Target_Emulator_Channel_Enable, uint32([0  0  0  0]));
end

function init_range_doppler_tx_rx_ip(AXIManagerObj, range_doppler_tx_rx_ip)

%% Register space for range_doppler_tx_rx_ip IP core.
writememory(AXIManagerObj,range_doppler_tx_rx_ip.IPCore_Reset, uint32(1)); % Reset IP core

% Default values for AXI4_Stream_0_Master interface -- range_doppler_tx_rx_ip
% The TLAST output signal of the interface is generated based on the packet size.
writememory(AXIManagerObj,range_doppler_tx_rx_ip.AXI4_Stream_0_Master_PacketSize, uint32(range_doppler_tx_rx_ip.packetSize));

% AXI4-Lite Memory-Mapped register access
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,range_doppler_tx_rx_ip.Tx_Gain, uint32(0));
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,range_doppler_tx_rx_ip.CPI_Start, uint32(0));
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,range_doppler_tx_rx_ip.CPI_Length, uint32(0));
% AXI4-Lite register write (Default value from Register Channel)
writememory(AXIManagerObj,range_doppler_tx_rx_ip.Rx_Delay_Cycles, uint32(0));
end
