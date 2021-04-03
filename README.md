# Euclidean Multitrack Sequencer

## TODO
Add control UI:
	Allow to select the input and output device with on screen buttons
	Allow to sync to extenal clock
Radial visualization
Make settings menu hidable
Visualize track parameters under hidable menu
Allow to select midi note number and midi channel for each track
Write a more consistent internal clock which avoids yielding the current thread. Maybe use the java midi sequencer.
Get inputs only from the selected midi controller

Akai midi mix
Add 4 tracks
Implement accents for third row of knobs
Implement Raspberry embedded version

## Input
The programs uses the input from any CC message with the following mapping:
- CC number 1 to 4: set track number beats for tracks from 1 to 4
- CC number 5 to 8: set track beats rotation for tracks from 1 to 4
- Note number 36 to 39: decrement track length for tracks from 1 to 4
- Note number 40 to 43: increment track length for tracks from 1 to 4

## Tanzmaus mappings
MIDI Channels:
1 kick
- 2 snare
- 3 rim
- 4 clap
- 5 tom
- 6 sp1
- 7 sp1-alt
- 8 sp2
- 9 sp2-alt
Note: 60