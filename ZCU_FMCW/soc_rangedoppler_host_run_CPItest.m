%% Host Machine Interface for Range-Doppler Application on Target

% Initialization script
soc_range_doppler_init;
   
%% User Configuration

% IP address of board
IPAddress = '169.254.0.2';

% Transmit gain (0-2)
TxGain = 1;

% Detection control 
DetectionEnabled = true;

% Radar target emulator parameters
TargetInfo = TargetEmulator_InfoStruct;
TargetInfo.Enabled(1) = true;
TargetInfo.Position(:,1) = [250 0 0];
TargetInfo.Velocity(:,1) = [100 0 0];
TargetInfo.RCS(1) = 4;
TargetInfo.Enabled(2) = true;
TargetInfo.Position(:,2) = [350 0 0];
TargetInfo.Velocity(:,2) = [-50 0 0];
TargetInfo.RCS(2) = 2;

%% Set Up UDP Objects

% UDP receiver
UDPR = dsp.UDPReceiver(...
    'RemoteIPAddress',IPAddress,...
    'LocalIPPort',25000,...
    'MaximumMessageLength',RngMaxIdx,...
    'ReceiveBufferSize', VelMaxIdx*RngMaxIdx*4, ...
    'MessageDataType','single');
setup(UDPR);

% UDP sender
UDPS = dsp.UDPSender(...
     'RemoteIPAddress',IPAddress,...
     'RemoteIPPort',25001);
setup(UDPS,zeros(udp_cmd.MessageLength,1));

%% Send Config Packets

disp('Configuring radar parameters...');

% Set Rx delay cycles
hostSendCommand(UDPS,'Rx_Delay_Cycles',RxDelayCycles);

% Set Tx gain
hostSendCommand(UDPS,'Tx_Gain',TxGain);

% Set number of pulses per CPI 
hostSendCommand(UDPS,'CPI_Length',CPILength);

% Configure radar target emulator
for ii=1:TargetInfo.NumChannels
    hostSendCommand(UDPS,'Target_Info',[ii ...
        TargetInfo.Enabled(ii) TargetInfo.Position(:,ii).' ...
        TargetInfo.Velocity(:,ii).' TargetInfo.RCS(ii)] );
end

pause(1);

%% Execute Test Mode

hDisp = hostInitDisplay('DetectionMapEnabled',DetectionEnabled);
cpiIdx = 1;

while(ishandle(hDisp))

    if DetectionEnabled
        fprintf('##### Start CPI %d #####\n',cpiIdx);
    end

    % CPI start
    hostSendCommand(UDPS,'CPI_Start',true);

    hostSendCommand(UDPS,'CPI_Start',false);

    

    % Wait for data packet from target
    [dataFrame, valid] = hostReceiveDataFrame(UDPR);
    
    if ~ishandle(hDisp)
        break
    end

    if ~valid
        fprintf('Timed out waiting for response from target.\n');
    else
        RngDopplerMap = fftshift(dataFrame,2);
        try
            if DetectionEnabled
                DetectionIdx = hostDetectTargets(RngDopplerMap);
                displayRangeDoppler(RngDopplerMap,DetectionIdx,hDisp);
            else
                displayRangeDoppler(RngDopplerMap,hDisp);
            end
        catch
        end
    end
    
    cpiIdx = cpiIdx+1;

end

%% Release UDP
hostSendCommand(UDPS,'Exit',true);
release(UDPR);
release(UDPS);
