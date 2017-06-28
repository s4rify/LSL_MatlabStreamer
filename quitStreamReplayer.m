% This function cleans up.
function quitStreamReplayer()
    global initialized running paused eeg_outlet marker_outlet stopit

    stopit = true;
    paused = false;
    if running
        running = false;
        return;
    end
    running = false;

    if initialized 
        initialized = false;
        % finally, when loop is terminated or interrupted/stopped
        eeg_outlet.delete;
        marker_outlet.delete;
        disp 'sending of eeg data terminated, outlets were deleted.';
    end
end