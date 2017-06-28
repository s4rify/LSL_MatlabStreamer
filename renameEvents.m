function  EEG  = renameEvents(EEG)

for e = 1:length(EEG.event)
     if~isempty(strfind(EEG.event(e).type, '>1'))
        EEG.event(e).type = 'cue_left';
     elseif~isempty(strfind(EEG.event(e).type, '>2'))
        EEG.event(e).type = 'cue_right';
     elseif~isempty(strfind(EEG.event(e).type, 'ecode>3'))
        EEG.event(e).type = 'sound';
        EEG.event(e).latency = EEG.event(e).latency + 125; % shift sound onset marker 500ms
     elseif~isempty(strfind(EEG.event(e).type, '>4'))
        EEG.event(e).type = 'fb_left';
     elseif~isempty(strfind(EEG.event(e).type, '>5'))
        EEG.event(e).type = 'fb_right';
    end
end
    

% rename training events differently
% [x, y] = max(diff([EEG.event.latency])); % end of callibration 
% 
% for e = 1:y
%     if isequal(EEG.event(e).type, 'cue_left') && isequal(EEG.event(e+1).type, 'sound');
%         EEG.event(e).type = 'cue_left_cal';
%         EEG.event(e+1).type = 'sound_left_cal';
%     elseif isequal(EEG.event(e).type, 'cue_right') && isequal(EEG.event(e+1).type, 'sound');
%         EEG.event(e).type = 'cue_right_cal';
%         EEG.event(e+1).type = 'sound_right_cal';
%     end
% end

% rename remaining online sound events
for e = 1:length(EEG.event)-1
    if isequal(EEG.event(e).type, 'cue_left') && isequal(EEG.event(e+1).type, 'sound');
        EEG.event(e+1).type = 'sound_left';     
    elseif isequal(EEG.event(e).type, 'cue_right') && isequal(EEG.event(e+1).type, 'sound');
        EEG.event(e+1).type = 'sound_right';
    end
end
    
    
end