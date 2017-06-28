% This function is responsible for the init phase.
% The lsl library is loaded and eeglab is started with all its
% consequences.
function initLSLAndEEGLab(startSample)
global initialized EEG_labels leftOrRightTrialsCounter
global samplecounter eventcounter eeg_outlet nchans paused stopit srate marker_outlet

%% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();
eventcounter = 1;
samplecounter = startSample;
leftOrRightTrialsCounter = 1;

% make a new stream outlet
disp('Creating a new streaminfo...');
eeg_info = lsl_streaminfo(lib,'MatlabEEG','EEG',nchans,srate,'cf_float32','sdfwerr32432');
marker_info = lsl_streaminfo(lib,'MatlabMarkerStream','Markers',1,0,'cf_string','myuniquesourceid23443');

%% Add some meta information to the stream.
chns = eeg_info.desc().append_child('channels');
% 
% for label = {'R5', 'R3', 'R1', 'R2', 'R4' ,'R6' ,'R8', 'R7', 'L7', 'L5', '4ADLR',...
%              'L3' , 'L1' , 'L2', 'L4', '4BRef', 'L6', 'L8'}
for i = 1: length(EEG_labels)
    ch = chns.append_child('channel');
    ch.append_child_value('label',EEG_labels{i}); % append the name od the channel from the dataset
    ch.append_child_value('unit','microvolts');
    ch.append_child_value('type','EEG');
end


disp('Opening an eeg outlet..');
eeg_outlet = lsl_outlet(eeg_info);

disp('Opening a marker outlet..');
marker_outlet = lsl_outlet(marker_info);

initialized = true;
paused = false;
stopit = false;

end