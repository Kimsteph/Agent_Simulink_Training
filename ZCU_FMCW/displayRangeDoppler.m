function displayRangeDoppler(RangeDopplerResponse,varargin)
%DISPLAYRANGEDOPPLER Show Range Doppler response and Detection Map
%
% displayRangeDoppler(RESP) 
%   Displays the Range Doppler response RESP.
% displayRangeDoppler(RESP,DETIDX)
%   Displays the Range Doppler response and detection map with indices from DETIDX.
% displayRangeDoppler(..., DISP)
%   Uses the figure handle DISP.

% Parse arguments
switch numel(varargin)
    case 0
        plotMode = 1;
        hDisp = gcf;
    case 1
        if ishandle(varargin{1})
            plotMode = 1;
            hDisp = varargin{1};
        else
            plotMode = 2;
            DetectionIdx = varargin{1};
            hDisp = gcf;
        end
    case 2
        plotMode = 2;
        DetectionIdx = varargin{1};
        hDisp = varargin{2};
    otherwise
        error('Invalid number of arguments');
end

% Get parameters from workspace
RngEstBins = evalin('base','RngEstBins');
VelEstBins = evalin('base','VelEstBins');

% Add small amount of noise to Range Doppler response
RangeDopplerResponse = abs(RangeDopplerResponse + 1e-3*randn(size(RangeDopplerResponse)));

% Convert Range Doppler response to dB for display.
rdMap = 20*log10(RangeDopplerResponse);

if plotMode == 2
    % Create detection map
    DetectionMap = zeros(size(RangeDopplerResponse), 'logical');
    for ii=1:size(DetectionIdx,1)
       DetectionMap(DetectionIdx(ii,1),DetectionIdx(ii,2)) = true;
    end

    % Detection clustering
    if ~isempty(DetectionIdx)
        clusterer = clusterDBSCAN('MinNumPoints',4,'Epsilon',20, ...
            'EnableDisambiguation',false);
        clusterIdx = clusterer(DetectionIdx);
        numClusters = max(clusterIdx);
    end
end

% Bring figure to front
figure(hDisp);

% Display Range Doppler Response
if plotMode == 2
    subplot(121);
end
imagesc([VelEstBins(1) VelEstBins(end)],[RngEstBins(1) RngEstBins(end)],rdMap);
xlabel('Velocity (m/s)');
ylabel('Range (m)');
title('Range Doppler Response');

% Display Detection Map
if plotMode == 2
    subplot(122);
    imagesc([VelEstBins(1) VelEstBins(end)],[RngEstBins(1) RngEstBins(end)],DetectionMap);
    xlabel('Velocity (m/s)');
    ylabel('Range (m)');
    title('Detection Map'); 

    % Display target clusters on Detection Map
    if ~isempty(DetectionIdx) && (numClusters > 0)
        fprintf('Detected %d targets:\n',numClusters); 
        for ii=1:numClusters
            temp = DetectionIdx(clusterIdx == ii,:);
            RngEst = mean(RngEstBins(temp(:,1)));
            VelEst = mean(VelEstBins(temp(:,2)));
            fprintf(' Target %d:\tRange = %.2f m,\tVelocity = %.2f m/s\n',ii,RngEst,VelEst);
            text(VelEst-20,RngEst-80,sprintf('%.2f m\n%.2f m/s',RngEst,VelEst),...
                'Color','white','FontSize',12);
        end
    else
       fprintf('No targets detected\n'); 
    end
end

end