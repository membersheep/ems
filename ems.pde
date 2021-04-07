import java.util.*;
import java.awt.*;
import themidibus.*;

UI ui;
DeviceManager deviceManager;
Clock clock;
MIDIClock midiClock;
Sequencer sequencer;
MidiBus midiBus;

float screenWidth = 800;
float screenHeight = 480;

void setup() {
  size(800, 480);
  frameRate(25);
  MidiBus.list();
  deviceManager = new DeviceManager();
  midiBus = new MidiBus(this);
  sequencer = new Sequencer(midiBus);
  clock = new Clock(sequencer);
  midiClock = new MIDIClock(sequencer);
  ui = new UI(this);
}
 //<>//
void draw() {
  background(0);
  if (deviceManager.inputName == "INTERNAL") {
    clock.update();
  }
  sequencer.drawTracks();
}

// BUTTON CALLBACKS

public void bpm(int bpm) {
  clock.bpm = bpm;
}

public void division(int division) {
  clock.division = division;
  midiClock.division = division;
}

public void play() {
  sequencer.play();
}

public void pause() {
  sequencer.pause();
}

public void stop() {
  sequencer.stop();
}

public void save() {
  // OPEN SAVE MENU
}

public void load() {
  // OPEN LOAD MENU
}

public void controller() {
  MidiBus.findMidiDevices();
  MidiBus.list();
  String name = deviceManager.getNextController();
  int index = deviceManager.getNextControllerIndex();
  if (deviceManager.controllerName != deviceManager.inputName) {
    midiBus.removeInput(deviceManager.controllerName);
  }
  ui.controllerButton.setLabel("MIDI CONTROLLER: " + name);
  deviceManager.controllerName = name;
  deviceManager.controllerIndex = index;
  if (name != deviceManager.inputName) {
    midiBus.addInput(name);
  }
}

public void input() {
  MidiBus.findMidiDevices();
  MidiBus.list();
  String name = deviceManager.getNextInput();
  int index = deviceManager.getNextInputIndex();
  if (deviceManager.controllerName != deviceManager.inputName) {
    midiBus.removeInput(deviceManager.inputName);
  }
  ui.inputButton.setLabel("MIDI CLOCK SOURCE: " + name);
  deviceManager.inputName = name;
  deviceManager.inputIndex = index;
  if (name != deviceManager.controllerName && name != "INTERNAL") {
    midiBus.addInput(name);
  }
}

public void output() {
  MidiBus.findMidiDevices();
  MidiBus.list();
  String name = deviceManager.nextOutput();
  ui.outputButton.setLabel("MIDI OUTPUT: " + name);
  midiBus.clearOutputs();
  midiBus.addOutput(name);
}

public void visualization() {
  sequencer.visualization = (sequencer.visualization + 1)%3;
}

// MIDI CALLBACKS

void rawMidi(byte[] data) {  
  if (deviceManager.inputName == "INTERNAL") {
    return;
  }
  if(data[0] == (byte)0xFC) {
    // reset timing when clock stops to stay in sync for the next start
  } else if(data[0] == (byte)0xF8) {
    midiClock.pulse();
  }
}

void controllerChange(ControlChange change) {
  switch (change.number()) {
    case 1: sequencer.updateTrackBeats("1", change.value()); break;
    case 2: sequencer.updateTrackBeats("2", change.value()); break;
    case 3: sequencer.updateTrackBeats("3", change.value()); break;
    case 4: sequencer.updateTrackBeats("4", change.value()); break;
    case 5: sequencer.updateTrackOffset("1", change.value()); break;
    case 6: sequencer.updateTrackOffset("2", change.value()); break;
    case 7: sequencer.updateTrackOffset("3", change.value()); break;
    case 8: sequencer.updateTrackOffset("4", change.value()); break;
    default: break;
  }
  ui.updateTrackLabels();
}

void noteOn(Note note) {
  switch (note.pitch()) {
    case 36: sequencer.decrementTrackLength("1"); break;
    case 37: sequencer.decrementTrackLength("2"); break;
    case 38: sequencer.decrementTrackLength("3"); break;
    case 39: sequencer.decrementTrackLength("4"); break;
    case 40: sequencer.incrementTrackLength("1"); break;
    case 41: sequencer.incrementTrackLength("2"); break;
    case 42: sequencer.incrementTrackLength("3"); break;
    case 43: sequencer.incrementTrackLength("4"); break;
    default: break;
  }
  ui.updateTrackLabels();
}
