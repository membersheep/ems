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
  String name = deviceManager.getNextController();
  int index = deviceManager.getNextControllerIndex();
  if (deviceManager.controllerName != deviceManager.inputName) {
    midiBus.removeInput(deviceManager.controllerName);
    midiBus.removeOutput(deviceManager.controllerName);
  }
  ui.controllerButton.setLabel("MIDI CONTROLLER: " + name);
  deviceManager.controllerName = name;
  deviceManager.controllerIndex = index;
  if (name != deviceManager.inputName) {
    midiBus.addInput(name);
    midiBus.addOutput(name);
  }
}

public void input() {
  MidiBus.findMidiDevices();
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
  String name = deviceManager.nextOutput();
  ui.outputButton.setLabel("MIDI OUTPUT: " + name);
  midiBus.clearOutputs();
  if (name != "ALL") {
    midiBus.addOutput(name);
  } else {
    for (int i = 0; i < MidiBus.availableOutputs().length; i++) {
      midiBus.addOutput(MidiBus.availableOutputs()[i]);
    }
  }
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
    case 16: sequencer.updateTrackAccents("1", change.value()); break;
    case 17: sequencer.updateTrackOffset("1", change.value()); break;
    case 18: sequencer.updateTrackBeats("1", change.value()); break;
    case 19: sequencer.updateTrackLength("1", change.value()); break;
    case 20: sequencer.updateTrackAccents("2", change.value()); break;
    case 21: sequencer.updateTrackOffset("2", change.value()); break;
    case 22: sequencer.updateTrackBeats("2", change.value()); break;
    case 23: sequencer.updateTrackLength("2", change.value()); break;
    case 24: sequencer.updateTrackAccents("3", change.value()); break;
    case 25: sequencer.updateTrackOffset("3", change.value()); break;
    case 26: sequencer.updateTrackBeats("3", change.value()); break;
    case 27: sequencer.updateTrackLength("3", change.value()); break;
    case 28: sequencer.updateTrackAccents("4", change.value()); break;
    case 29: sequencer.updateTrackOffset("4", change.value()); break;
    case 30: sequencer.updateTrackBeats("4", change.value()); break;
    case 31: sequencer.updateTrackLength("4", change.value()); break;
    case 46: sequencer.updateTrackAccents("5", change.value()); break;
    case 47: sequencer.updateTrackOffset("5", change.value()); break;
    case 48: sequencer.updateTrackBeats("5", change.value()); break;
    case 49: sequencer.updateTrackLength("5", change.value()); break;
    case 50: sequencer.updateTrackAccents("6", change.value()); break;
    case 51: sequencer.updateTrackOffset("6", change.value()); break;
    case 52: sequencer.updateTrackBeats("6", change.value()); break;
    case 53: sequencer.updateTrackLength("6", change.value()); break;
    case 54: sequencer.updateTrackAccents("7", change.value()); break;
    case 55: sequencer.updateTrackOffset("7", change.value()); break;
    case 56: sequencer.updateTrackBeats("7", change.value()); break;
    case 57: sequencer.updateTrackLength("7", change.value()); break;
    case 58: sequencer.updateTrackAccents("8", change.value()); break;
    case 59: sequencer.updateTrackOffset("8", change.value()); break;
    case 60: sequencer.updateTrackBeats("8", change.value()); break;
    case 61: sequencer.updateTrackLength("8", change.value()); break;
    case 62: sequencer.updateMasterFader(change.value()); break; 
    default: break;
  }
  ui.updateTrackLabels();
}

boolean isShifting = false;

void noteOn(Note note) {
  println("ON note number:" + note.pitch);
  switch (note.pitch()) {
    case 1: sequencer.muteTrack("1"); break;
    case 4: sequencer.muteTrack("2"); break;
    case 7: sequencer.muteTrack("3"); break;
    case 10: sequencer.muteTrack("4"); break;
    case 13: sequencer.muteTrack("5"); break;
    case 16: sequencer.muteTrack("6"); break;
    case 19: sequencer.muteTrack("7"); break;
    case 22: sequencer.muteTrack("8"); break;
    case 3: sequencer.rollTrack("1"); break;
    case 6: sequencer.rollTrack("2"); break;
    case 9: sequencer.rollTrack("3"); break;
    case 12: sequencer.rollTrack("4"); break;
    case 15: sequencer.rollTrack("5"); break;
    case 18: sequencer.rollTrack("6"); break;
    case 21: sequencer.rollTrack("7"); break;
    case 24: sequencer.rollTrack("8"); break;
    case 2: sequencer.editTrackLFO("1"); break;
    case 5: sequencer.editTrackLFO("2"); break;
    case 8: sequencer.editTrackLFO("3"); break;
    case 11: sequencer.editTrackLFO("4"); break;
    case 14: sequencer.editTrackLFO("5"); break;
    case 17: sequencer.editTrackLFO("6"); break;
    case 20: sequencer.editTrackLFO("7"); break;
    case 23: sequencer.editTrackLFO("8"); break;
    case 25: sequencer.masterIncrement(); break;
    case 26: sequencer.masterIncrement(); break;
    case 27: isShifting = true; break;
    default: break;
  }
  ui.updateTrackLabels();
}

void noteOff(Note note) {
  println("OFF note number:" + note.pitch);
  switch (note.pitch()) {
    case 3: sequencer.rollTrack("1"); break;
    case 6: sequencer.rollTrack("2"); break;
    case 9: sequencer.rollTrack("3"); break;
    case 12: sequencer.rollTrack("4"); break;
    case 15: sequencer.rollTrack("5"); break;
    case 18: sequencer.rollTrack("6"); break;
    case 21: sequencer.rollTrack("7"); break;
    case 24: sequencer.rollTrack("8"); break;
    case 27: isShifting = false; break;
    default: break;
  }
}
