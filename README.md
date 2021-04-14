# Euclidean Multitrack Sequencer

## TODO
v0.1
- Functions
	- A/B function: bank left button -> A: enables A (immediately) (A led on)
					bank right button -> B: enables B (immediately) (B led on)
					shift + A: copy A to B
					shift + B: copy B to A
					A + B: chains A and B (both led on)
	- Generate and send midi CLOCK
- UI
	- Draw polygons with bezier curves varying over time
	- Rotate polygons with tick
	- Polygon wrong colors on tracks
- Raspberry embedded version

v0.2
- Rewrite with java midi instead of midibus library
	- Impossible to refresh input list without restarting. findMidiDevices() is not working as advertised
	- Add all available outputs at startup
	- Add LPD8 and MIDI Mix inputs if found
- Settings: Allow to set max steps
- Save pattern menu: 8 slots (square buttons) to save the current pattern to
- Load pattern menu: 8 slots (square buttons) to load the current pattern from
- Add settings: allow to select midi note number and midi channel for each track, and to name each track
- Flam function (similar to accent but play a flam instead of an accented note). It needs 3 additional knobs per track: for beats, rotation and level (2-3-4).
- Enable/Disable steps by tapping them.

## Input
Supported MIDI controllers: 
- Akai LPD8
- Akai MIDI Mix

## Output
### Tanzmaus mappings
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

### Behringer RD8
Channel 1, default notes.
Alredy configured in the rd8 branch.

## Melodic sequencer

http://gershonwolfe.com/wordpress/?p=104

https://www.musicradar.com/how-to/how-to-create-music-in-any-style-and-genre-with-fractals

https://www.geeksforgeeks.org/thue-morse-sequence/

https://github.com/rmoscowitz/fractal-music

## EMS Visuals
Registrare grafica generata dal suono con processing mentre si suona e registrare anche i poligoni col sequencer e poi sovrapporre tutto per fare un visual e farlo montare da morto

https://rbnrpi.wordpress.com/2017/09/20/a-visualiser-for-sonic-pi-3/

https://www.youtube.com/watch?v=nepm_IOR02M

https://gist.github.com/rbnpi/abf9fb2fbea3c1a4fe435819eb032e80

## MIDI sequencer to manage 4 channel audio
https://www.ableton.com/en/packs/surround-panner/
https://www.amazon.com/Octo-channel-sound-card-Raspberry/dp/B06Y3PZ6MF
https://www.adj.com/14-mxr
mixer che permetta tramite midi di controllare quanto di ogni input mandare in ognuno dei 4 output 
forse OSC va meglio del midi per fare una roba del genere
