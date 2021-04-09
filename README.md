# Euclidean Multitrack Sequencer

## TODO
v0.1
UI
	- Draw polygons with bezier curves varying over time
	- Fix polygon colors sometimes switching
Functions
	- Use lights to indicate
		- muted tracks (mute button light on)
		- note played (mute button light on-off when note is played)
		- lfo frequency (rec arm button light blinking with lfo period)
		- blink bank lights when editing LFO
	- A/B function: A button, B button, A->B button to toggle chaining, copy to A/B button
	- Refresh input list without restarting. findMidiDevices() is not working as advertised

Raspberry embedded version

v0.2
- Save pattern menu: 8 slots (square buttons) to save the current pattern to
- Load pattern menu: 8 slots (square buttons) to load the current pattern from
- Add settings: allow to select midi note number and midi channel for each track, and to name each track
- Internal sequencer: write a more consistent internal clock which avoids yielding the current thread. Maybe use the java midi sequencer.
- Flam function (similar to accent but play a flam instead of an accented note). It needs 3 knobs: for beats, rotation and level (2-3-4).

## Input
Akai LPD8
- CC number 1 to 4: set track number beats for tracks from 1 to 4
- CC number 5 to 8: set track beats rotation for tracks from 1 to 4
- Note number 36 to 39: decrement track length for tracks from 1 to 4
- Note number 40 to 43: increment track length for tracks from 1 to 4
Akai MIDI Mix

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
