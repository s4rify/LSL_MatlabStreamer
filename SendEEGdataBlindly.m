% This function sends data until it is interrupted, or stopped. If the
% stream is resumed, the function will continue at the previous position of
% the stream.
% It will provide Information in the GUI about which kind of trial has been
% presented (and which would therefore be the correct classification result),
% about the samplecounter and about the trialnumber.
function SendEEGdataBlindly()

global events eegdata initialized running paused samplecounter
global eventcounter stopit eeg_outlet marker_outlet nchans srate handles  
 

if ~initialized
    startSampleCounter = 1;
    initLSLAndEEGLab(startSampleCounter);
    
    
    % if we start with a samplecounter that is not the first one,
    % skip all events until here and then begin the normal replay
    if samplecounter > 1
        while uint64(events{eventcounter,2}) < samplecounter
            eventcounter = eventcounter + 1;
        end
        disp(['skipped to eventcounter', ' ', num2str(eventcounter)]);
    end
end

% let's go
disp('Now transmitting EEG data..');
running = true;
paused = false;
starttime = clock;
startsamples = samplecounter;

precision = 2;
exampleSample_idx = 1300;


% the iterator variable is increased whenever
% a sample was found in the inner loop (eegdata) at which a marker has been
% set in the data. if this marker is left or right trial, a trigger is
% sent out via UDP or LSL
while running && samplecounter < length(eegdata) && eventcounter <= samplecounter
    
    elapsedtime = etime(clock, starttime);
    elapsedsamples = samplecounter - startsamples;
    
    latency = elapsedtime * srate - elapsedsamples;
    
    if latency <= 0
        % This pause statment allows for jobs in the job queue to be
        % processed! So we need this everywhere we want to do sth
        % sr is 500, so make pause to send out 500 samples/second
        pause(1.0 / srate);
    elseif latency > srate * 3
        disp 'warning: we are more than 3 seconds late';
    elseif latency > srate * 10
        disp 'terminating: we are more than 10 seconds late';
        running = false;
        paused = true;
    end
    
    if ~running || paused
        running = false;
        if stopit
            samplecounter = 1;
            eventcounter = 1;
            quitStreamReplayer();
        end
        break;
    end

    eegsample = eegdata(1:nchans,samplecounter);
    eeg_outlet.push_sample(double(eegsample));
    
    % display at which sample we currently are in the GUI
    set(handles.SampleCounterDisplay,'String', num2str(samplecounter));
    
    % whenever a sample is reached at which a marker is set in the
    % dataset send out UDP package to CLAPP to indicate, that an interesting trial has been
    % presented.
    while uint64(events{eventcounter,2}) <= samplecounter 

        event = num2str(events{eventcounter,1});
  
        % the message which is sent out via UDP and LSL 
        triggermsg = event;
        
        % display one sample from the current chunk for comparison reasons
        sampleInfoForTrigger = num2str(eegdata(12, samplecounter + exampleSample_idx), precision);
        
        % if any interesting event occurs, send out LSL and UDP marker
        disp([ 'M_Trial #', num2str(eventcounter), ' ', event , ' ', sampleInfoForTrigger]);
        
        sendUDPSignal(strcat(triggermsg, ':', num2str(eventcounter), ':', sampleInfoForTrigger));
        marker_outlet.push_sample({strcat(triggermsg, ':', num2str(eventcounter), ':', sampleInfoForTrigger)});
       
        % display which trial we just sent out in the GUI
        set(handles.leftorRightTag,'String', event);
        set(handles.TrialCounterDisplay,'String', num2str(eventcounter));
        
        if eventcounter < length(events)
            eventcounter = eventcounter + 1;
        else
            % we are done and reached the last event, stop everything
            stopit = true;
        end

    end
    samplecounter = samplecounter + 1;
    
end

if samplecounter >= length(eegdata)
    running = false;
    paused = false;
    samplecounter = 1;
    eventcounter = 1;
end


end %endfuncdef