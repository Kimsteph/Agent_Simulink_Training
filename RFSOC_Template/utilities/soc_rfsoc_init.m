function soc_rfsoc_init(mdlPath)
% Initialization fcn for the model. It sets the model-wide params
% which are derived based on sample rate.

% 'FrameSize and 'NumBuffers' variables are set during model
% PreLoadFcn callback into base workspace. These two variables should be
% changed directly at the MATLAB command

% FrameSize = evalin('base','FrameSize');

dacSampleRate = get_param([mdlPath '/RF Data Converter'], 'dacSampleRate');
dacSampleRate = evalin('base', dacSampleRate)*1e6;
dacSamplesPerCycle = str2double(get_param([mdlPath '/RF Data Converter'], 'dacSamplesPerCycle'));
dacInterpolationMode = str2double(get_param([mdlPath '/RF Data Converter'], 'interpolationMode'));
streamClkFrequency = dacSampleRate/(dacSamplesPerCycle*dacInterpolationMode);

SampleTime = 1/streamClkFrequency;


% derived model-wide variables set into base workspace.
assignin('base','SampleTime', SampleTime);
end