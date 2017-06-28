This is the MatlabStreamer software which reads in a set file from eeglab and creates an LSL stream containing
the raw EEG data and the markers.

INSTRUCTONS
- make sure, eeglab is added to the Matlab path 
- make sure, you have installed the LabstreamingLayer Matlab libraries and that they are added to the Matlab path 
- in Matlab, navigate to the path where this readme is placed
- place your eeg raw data file into this folder (or change the path in the streamControl.m file
- type your filename into streamControl.m file (indicated with a comment)
- you can now start the streamer
- type "streamControl" into the command line
- a window appears which offers to start, pause and stop the stream
- in the Matlab command line, debug outputs display the current events which are sent out
