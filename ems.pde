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

public void circular() {
  sequencer.drawCircle = !sequencer.drawCircle;
}

public void radial() {
  sequencer.drawRadius = !sequencer.drawRadius;
}

public void polygonal() {
  sequencer.drawPolygon = !sequencer.drawPolygon;
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
    case 16: sequencer.updateTrackBeats("1", change.value()); break;
    case 17: sequencer.updateTrackOffset("1", change.value()); break;
    case 18: sequencer.updateTrackAccents("1", change.value()); break;
    case 19: sequencer.updateTrackLength("1", change.value()); break;
    case 20: sequencer.updateTrackBeats("2", change.value()); break;
    case 21: sequencer.updateTrackOffset("2", change.value()); break;
    case 22: sequencer.updateTrackAccents("2", change.value()); break;
    case 23: sequencer.updateTrackLength("2", change.value()); break;
    case 24: sequencer.updateTrackBeats("3", change.value()); break;
    case 25: sequencer.updateTrackOffset("3", change.value()); break;
    case 26: sequencer.updateTrackAccents("3", change.value()); break;
    case 27: sequencer.updateTrackLength("3", change.value()); break;
    case 28: sequencer.updateTrackBeats("4", change.value()); break;
    case 29: sequencer.updateTrackOffset("4", change.value()); break;
    case 30: sequencer.updateTrackAccents("4", change.value()); break;
    case 31: sequencer.updateTrackLength("4", change.value()); break;
    case 46: sequencer.updateTrackBeats("5", change.value()); break;
    case 47: sequencer.updateTrackOffset("5", change.value()); break;
    case 48: sequencer.updateTrackAccents("5", change.value()); break;
    case 49: sequencer.updateTrackLength("5", change.value()); break;
    case 50: sequencer.updateTrackBeats("6", change.value()); break;
    case 51: sequencer.updateTrackOffset("6", change.value()); break;
    case 52: sequencer.updateTrackAccents("6", change.value()); break;
    case 53: sequencer.updateTrackLength("6", change.value()); break;
    case 54: sequencer.updateTrackBeats("7", change.value()); break;
    case 55: sequencer.updateTrackOffset("7", change.value()); break;
    case 56: sequencer.updateTrackAccents("7", change.value()); break;
    case 57: sequencer.updateTrackLength("7", change.value()); break;
    case 58: sequencer.updateTrackBeats("8", change.value()); break;
    case 59: sequencer.updateTrackOffset("8", change.value()); break;
    case 60: sequencer.updateTrackAccents("8", change.value()); break;
    case 61: sequencer.updateTrackLength("8", change.value()); break;
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
