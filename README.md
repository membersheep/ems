# Euclidean Multitrack Sequencer

## TODO
v0.1
Functions
	- Save pattern menu: 8 slots (square buttons) to save the current pattern to
	- Load pattern menu: 8 slots (square buttons) to load the current pattern from
	- Detect and fix crash when modifying a sequence while playing
	- Allow multiple midi outputs (add ALL OUTPUTS option to add all midi devices)
	- Refresh input list without restarting. findMidiDevices() is not working as advertised
UI
	- Animate the beat dot
	- Implement radial visualization
	- Implement polygonal visualization
Support Akai midi mix
	- Add 4 tracks
	- Accents
	- Flam
	- Mute track
	- Velocity LFO per track (we could use select track + master volume knob to regulate the lfo modulation amount)
Raspberry embedded version

v0.2
- Add settings: allow to select midi note number and midi channel for each track
- Internal sequencer: write a more consistent internal clock which avoids yielding the current thread. Maybe use the java midi sequencer.
- Get inputs only from the selected midi controller

## Input
The programs uses the input from any CC message with the following mapping:
- CC number 1 to 4: set track number beats for tracks from 1 to 4
- CC number 5 to 8: set track beats rotation for tracks from 1 to 4
- Note number 36 to 39: decrement track length for tracks from 1 to 4
- Note number 40 to 43: increment track length for tracks from 1 to 4

## Output
###Tanzmaus mappings
MIDI Channels:
- 1 kick
- 2 snare
- 3 rim
- 4 clap
- 5 tom
- 6 sp1
- 7 sp1-alt
- 8 sp2
- 9 sp2-alt
Note: 60

## Melodic sequencer

http://gershonwolfe.com/wordpress/?p=104

https://www.musicradar.com/how-to/how-to-create-music-in-any-style-and-genre-with-fractals

https://www.geeksforgeeks.org/thue-morse-sequence/

https://github.com/rmoscowitz/fractal-music

## EMS Visuals

https://rbnrpi.wordpress.com/2017/09/20/a-visualiser-for-sonic-pi-3/

https://www.youtube.com/watch?v=nepm_IOR02M

https://gist.github.com/rbnpi/abf9fb2fbea3c1a4fe435819eb032e80

## MIDI sequencer to manage 4 channel audio
https://www.ableton.com/en/packs/surround-panner/
https://www.amazon.com/Octo-channel-sound-card-Raspberry/dp/B06Y3PZ6MF
https://www.adj.com/14-mxr
mixer che permetta tramite midi di controllare quanto di ogni input mandare in ognuno dei 4 output 
forse OSC va meglio del midi per fare una roba del genere
