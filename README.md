# Euclidean Multitrack Sequencer

## TODO
v0.1
- Raspberry embedded version
	- MIDI clock source/thru
	- Fix fmidi interface not working
	- Optimize raspbian to run ems

v0.2
- Fix polygon wrong colors on tracks
- Add I/O configuration
	- select controller, input, and output devices for
	- select name, input channel, output channel and notes for each track.
- Settings: Allow to set max steps
- Save pattern menu: 8 slots (square buttons) to save the current pattern to
- Load pattern menu: 8 slots (square buttons) to load the current pattern from
- Enable/Disable steps by tapping them.

## Controllers
Supported MIDI controllers: 
- Akai LPD8
- Akai MIDI Mix

## Raspberry
### Install
Clone the repository to your home folder. The build folder contains the executable for ARMv6.

### Autostart
Copy ems.desktop file to /home/pi/.config/autostart

## Melodic sequencer
Akai LPD8 controller
Knobs:
	1. steps
	2. beats
	3. rotate
	4. accent
	5. accent rotate
	6. root note (could use 2 pads)
	7. scale (could use 2 pads)
	8. undersample factor 0-127
https://github.com/rmoscowitz/fractal-music
how do we generate and play note length?

Apply thue-morse over the generated euclidean sequence
https://reglos.de/musinum/
http://gershonwolfe.com/wordpress/?p=104
https://www.musicradar.com/how-to/how-to-create-music-in-any-style-and-genre-with-fractals
https://www.geeksforgeeks.org/thue-morse-sequence/

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
