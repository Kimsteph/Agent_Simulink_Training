function [hDisp,varargout] = hostInitDisplay(varargin)

%#codegen
%#ok<*EMCA>
p = inputParser;
p.addParameter('DetectionMapEnabled', true);
p.addParameter('BeamformingControlEnabled', false);
p.KeepUnmatched = true;
p.parse(varargin{:});
config = p.Results;

figName = 'Range-Doppler';

close(findall(0,'type','figure','name',figName))
hDisp = figure('Name',figName);

if config.DetectionMapEnabled
    set(hDisp,'position',[475 355 1425 600]);
else
    set(hDisp,'position',[475 355 600 600]);
end

RngMaxIdx = evalin('base', 'RngMaxIdx');
VelMaxIdx = evalin('base', 'VelMaxIdx');
VelMax = evalin('base', 'VelMax');
RngMin = evalin('base', 'RngMin');
RngMax = evalin('base', 'RngMax');

% Range Doppler Map
if config.DetectionMapEnabled
    subplot(1,2,1);
end
imagesc([-VelMax VelMax],[RngMin RngMax],zeros([VelMaxIdx RngMaxIdx]));
xlabel('Velocity (m/s)');
ylabel('Range (m)');
title('Range-Doppler Map');

% Detection Map
if config.DetectionMapEnabled
    subplot(1,2,2);
    imagesc([-VelMax VelMax],[RngMin RngMax],zeros([VelMaxIdx RngMaxIdx]));
    xlabel('Velocity (m/s)');
    ylabel('Range (m)');
    title('Detection Map');
end

if config.BeamformingControlEnabled
    uicontrol('Style', 'PushButton', 'Position', [10 575 60 20], ...
            'String', 'Stop','Callback','delete(gcbf)');
    uicontrol('Style','Text','String','Steering angle:','Position',[5 10 75 20]);
    varargout{1} = uicontrol('Style', 'edit','String','0','Position',[85 12 40 20]);
end

end

