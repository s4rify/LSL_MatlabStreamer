# The Matlab Streamer 


This is a streamer software which reads in a .set file from EEGLAB and creates an LSL stream containing
the raw EEG data and the markers.

Author: Sarah Blum, 2016


#### Note: This is work in progress, but it can be used as it is. I will add a more convenient way to load files and to setup the streamer soon. Please let me know if you have any issues using the streamer!


## INSTRUCTONS
- make sure EEGLAB is added to the Matlab path 
- make sure the LabstreamingLayer Matlab libraries are added to the Matlab path 
- in Matlab, navigate to the folder where you put the content of this repository
- place your EEGLAB raw data file into this folder (or change the path in the streamControl.m file). you will need the .set and the .fdt file
- type your filename into streamControl.m file (indicated with a comment)
- you can now start the streamer:
  - type "streamControl" into the command line
  - a window appears which offers to start, pause and stop the stream
  - in the Matlab command line, debug outputs display the current events which are sent out
  - in the network you can now see an LSL stream for the raw data and an LSL stream which contains the event markers

## Dependencies
The streamer needs the eeglab plugin (<https://sccn.ucsd.edu/eeglab/index.php>) and an LSL library for Matlab (<https://github.com/sccn/labstreaminglayer>)


## License 
 Copyright 2016 Sarah Blum

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
