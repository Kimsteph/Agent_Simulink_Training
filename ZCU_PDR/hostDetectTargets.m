function DetectionIdx = hostDetectTargets(RangeDopplerMap)
%HOSTDETECTTARGETS Run 2D CFAR detection on Range Doppler response
%#codegen
%#ok<*EMCA>

CFARTrainRegion = evalin('base','CFARTrainRegion');
CFARGuardRegion = evalin('base','CFARGuardRegion');
CFARIdx = evalin('base','CFARIdx');

% CFAR detection
detector = phased.CFARDetector2D(...
    'TrainingBandSize',CFARTrainRegion, ...
    'GuardBandSize',CFARGuardRegion, ...
    'ProbabilityFalseAlarm',20e-3);
detections = step(detector,RangeDopplerMap,CFARIdx);
DetectionIdx = CFARIdx(:,detections).';

end

