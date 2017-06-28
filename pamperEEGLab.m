% This function is called once when the figure is loaded. After that, this
% function is never to called again, because eeglab will get cranky and end
% up being in a very bad state.
% This function starts eeglab, loads the dataset given as a parameter and
% then stores the events in my own datastructure.
% The datastructure and the EEG variables are made global variables so that
% they are accessible throughout the program.
function EEG =  pamperEEGLab(rawdatapath, datasetName, chars, oneChannel, xdf)
global martinsEvents ALLEEG CURRENTSET eegdata nchans srate EEG_labels

disp 'eeglab setup';
%% check if ALLEEG exists, if not, start EEGLAB and load dataset
%rawdatapath = '../../Data/RawDataFromMartin/';
%if  evalin( 'base', 'exist(''EEG'',''var'') == 0' ) || isempty(EEG)
    disp('eeglab is being loaded..');
    % start eeglab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab; %#ok<*ASGLU>
    % load dataset
    EEG = pop_loadset('filename',datasetName,'filepath',rawdatapath);
    % copy changes to ALLEEG
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
    
    eeglab redraw
%end


if xdf
    EEG = renameEvents(EEG);
    eeg_eventtypes(EEG)
end
% eeglab was started successfully, use info and data
eegdata = EEG.data;
nchans = EEG.nbchan;
srate = EEG.srate;  
samples = EEG.pnts; 

                       
% fill the cell array with the type of the event and the sample number in
% which it occured. first row contains the types, second row the sample.
martinsEvents = LoopOverEvents(chars);


if oneChannel
    EEG_labels{1} = EEG.chanlocs(1).labels;
else 
    % store labels from the dataset into EEG_labels
    for i = 1 : 18
        EEG_labels{i} = EEG.chanlocs(i).labels;
    end
    
end

    %% helper function to get the events and latencies from the dataset
    function martinsEvents = LoopOverEvents(chars)
    % 1768 rows, 2 columns
    martinsEvents = cell(length(EEG.event),2);
    for j = 1 : length(EEG.event)
        if chars
            % first column: events in every row
            martinsEvents{j,1} = char(EEG.event(j).type);
            % second column: corresponding latency in every row
            martinsEvents{j,2} = EEG.event(j).latency;
        else
            % first column: events in every row
            %martinsEvents{j,1} = uint8(EEG.event(j).type);
            martinsEvents{j,1} = EEG.event(j).type;
            % second column: corresponding latency in every row
            martinsEvents{j,2} = EEG.event(j).latency;
        end
    end
    end

end