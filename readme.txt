This is the MatlabStreamer software which reads in a set file from eeglab and creates an LSL stream containing
the raw EEG data and the markers.

Author: Sarah Blum, 2016

Note: This is far from done, but it can be used as it is. I will add a more convenient way to load files and to setup the streamer soon.
The software is quite unflexible at the moment in terms of the event markers. If you need help concerning the setup here, please let me know!


INSTRUCTONS
- make sure, eeglab is added to the Matlab path 
- make sure, you have installed the LabstreamingLayer Matlab libraries and that they are added to the Matlab path 
- in Matlab, navigate to the path where these functions are placed
- place your eeglab raw data file into this folder (or change the path in the streamControl.m file). you will need the .set and the .fdt file
- type your filename into streamControl.m file (indicated with a comment)
- define your events in the streamControl.m file (indicated with a comment). the streamer must know the event markers as they appear in the raw eeg file
- you can now start the streamer:
  - type "streamControl" into the command line
  - a window appears which offers to start, pause and stop the stream
  - in the Matlab command line, debug outputs display the current events which are sent out
  - in the network you can now see an LSL stream for the raw data and an LSL stream which contains the event markers
