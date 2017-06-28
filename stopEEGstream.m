% set stop-flag. The control over the closing of the socket and the 
% termination of the stream should lie in the main sending method.
% 
% Additional necessary action: set sample counter back to zero if state is
% 'paused'.
function stopEEGstream()
global  running stopit paused handles
    if ~running
        quitStreamReplayer();
    end
    stopit = true;
    running = false;
    paused = false;    
    set(handles.SampleCounterDisplay,'String', 0);
    set(handles.TrialCounterDisplay,'String', 0);
    disp 'eeg stream stopped';
end