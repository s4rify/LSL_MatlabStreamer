% This function sets a flag so that the sendData function knows if the
% state of the program is 'pause'.
function pauseEEGstream()
    global running paused
    if running
       paused = true;
       running = false;
    end
end

