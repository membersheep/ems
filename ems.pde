import java.util.*;
import java.awt.*;
import themidibus.*;

UI ui;
DeviceManager deviceManager;
MIDIClock midiClock;
InternalClock internalClock;
Sequencer sequencer;
MidiBus midiBus;

float screenWidth = 800;
float screenHeight = 480;

void setup() {
  //fullScreen();
  //noCursor();
  size(800, 480); // debug
  frameRate(25);
  MidiBus.list();
  deviceManager = new DeviceManager();
  midiBus = new MidiBus(this, "MIDI Mix", "Unknown name");
  midiBus.addInput("MIDI Mix");
  midiBus.addOutput("Unknown name");
  sequencer = new Sequencer(midiBus);
  midiClock = new MIDIClock(sequencer);
  internalClock = new InternalClock(sequencer); //<>//
  ui = new UI(this);
  internalClock.start();
}
 //<>//
void draw() {
  background(0);
  sequencer.drawTracks();
  ui.draw();
}

// BUTTON CALLBACKS

public void bpm(int bpm) {
  internalClock.setBPM(bpm);
}

public void division(int division) {
  internalClock.division = division;
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

public void quit() {
  exit();
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
  if (name == "INTERNAL") {
    internalClock.isRunning = true;
  } else {
    internalClock.isRunning = false;
  }
}

public void output() {
  MidiBus.findMidiDevices();
  String name = deviceManager.nextOutput();
  ui.outputButton.setLabel("MIDI OUTPUT: " + name);
  midiBus.clearOutputs();
  if (name != "ALL") {
    midiBus.addOutput(deviceManager.controllerName);
    midiBus.addOutput(name);
  } else {
    deviceManager.addAllOutputs();
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
  } else if(data[0] == (byte)0xF8) { // CLOCK PULSE
    midiClock.pulse();
  }
}

void controllerChange(ControlChange change) {
  if (deviceManager.controllerName.contains("Mix")) {
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
      default: break;
    }
    if (isShifting) {
      switch (change.number()) {
        case 62: sequencer.updateLFOPeriod(change.value()); break; 
        default: break;
      }
    } else {
      switch (change.number()) {
        case 62: sequencer.updateLFOAmount(change.value()); break; 
        default: break;
      }
    }
  } else if (deviceManager.controllerName.contains("LPD8")) {
    switch (change.number()) {
      case 1: sequencer.updateTrackBeats("1", change.value()); break;
      case 2: sequencer.updateTrackBeats("2", change.value()); break;
      case 3: sequencer.updateTrackBeats("3", change.value()); break;
      case 4: sequencer.updateTrackBeats("4", change.value()); break;
      case 5: sequencer.updateTrackLength("1", change.value()); break;
      case 6: sequencer.updateTrackLength("2", change.value()); break;
      case 7: sequencer.updateTrackLength("3", change.value()); break;
      case 8: sequencer.updateTrackLength("4", change.value()); break;
      default: break;
    }
  }
  ui.updateTrackLabels();
}

boolean isShifting = false;

void noteOn(Note note) {
  if (deviceManager.controllerName.contains("Mix")) {
    if (isShifting) {
      switch (note.pitch()) {
        case 3: sequencer.editTrackLFO("1"); break;
        case 6: sequencer.editTrackLFO("2"); break;
        case 9: sequencer.editTrackLFO("3"); break;
        case 12: sequencer.editTrackLFO("4"); break;
        case 15: sequencer.editTrackLFO("5"); break;
        case 18: sequencer.editTrackLFO("6"); break;
        case 21: sequencer.editTrackLFO("7"); break;
        case 24: sequencer.editTrackLFO("8"); break;
        default: break;
      }  
    } else {
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
        case 25: sequencer.switchToA(); break;
        case 26: sequencer.switchToB(); break;
        case 27: isShifting = true; break;
        default: break;
      }
    }
    switch (note.pitch()) {
      case 2: sequencer.addSoloTrack("1"); break;
      case 5: sequencer.addSoloTrack("2"); break;
      case 8: sequencer.addSoloTrack("3"); break;
      case 11: sequencer.addSoloTrack("4"); break;
      case 14: sequencer.addSoloTrack("5"); break;
      case 17: sequencer.addSoloTrack("6"); break;
      case 20: sequencer.addSoloTrack("7"); break;
      case 23: sequencer.addSoloTrack("8"); break;
      default: break;
    } 
  } else if (deviceManager.controllerName.contains("LPD8")) {
    switch (note.pitch()) {
      case 36: sequencer.decrementTrackOffset("1"); break;
      case 37: sequencer.decrementTrackOffset("2"); break;
      case 38: sequencer.decrementTrackOffset("3"); break;
      case 39: sequencer.decrementTrackOffset("4"); break;
      case 40: sequencer.incrementTrackOffset("1"); break;
      case 41: sequencer.incrementTrackOffset("2"); break;
      case 42: sequencer.incrementTrackOffset("3"); break;
      case 43: sequencer.incrementTrackOffset("4"); break;
      default: break;
    } 
  }
  ui.updateTrackLabels();
}

void noteOff(Note note) {
  if (isShifting) {
    switch (note.pitch()) {
      case 27: 
        isShifting = false;
        sequencer.clearSoloTracks();
        break;
      default: break;
    }
  } else {
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
  switch (note.pitch()) {
    case 2: sequencer.removeSoloTrack("1"); break;
    case 5: sequencer.removeSoloTrack("2"); break;
    case 8: sequencer.removeSoloTrack("3"); break;
    case 11: sequencer.removeSoloTrack("4"); break;
    case 14: sequencer.removeSoloTrack("5"); break;
    case 17: sequencer.removeSoloTrack("6"); break;
    case 20: sequencer.removeSoloTrack("7"); break;
    case 23: sequencer.removeSoloTrack("8"); break;
    default: break;
  } 
}
