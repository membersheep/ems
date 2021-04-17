import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.awt.*; 
import themidibus.*; 
import themidibus.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ems extends PApplet {





UI ui;
DeviceManager deviceManager;
MIDIClock midiClock;
InternalClock internalClock;
Sequencer sequencer;
MidiBus midiBus;

float screenWidth = 800;
float screenHeight = 480;

public void setup() {
  
  //noCursor();
  //size(800, 480); // debug
  frameRate(25);
  MidiBus.list();
  deviceManager = new DeviceManager();
  String[] defaults = deviceManager.defaults();
  println(defaults[0]);
  println(defaults[1]);
  midiBus = new MidiBus(this, defaults[0], defaults[1]);
  //midiBus = new MidiBus(this, "MIDI Mix", "Unknown name");
  sequencer = new Sequencer(midiBus);
  midiClock = new MIDIClock(sequencer);
  internalClock = new InternalClock(sequencer); //<>//
  ui = new UI(this);
  internalClock.start();
}
 //<>//
public void draw() {
  background(0);
  sequencer.drawTracks();
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

public void rawMidi(byte[] data) {  
  if (deviceManager.inputName == "INTERNAL") {
    return;
  }
  if(data[0] == (byte)0xFC) {
    // reset timing when clock stops to stay in sync for the next start
  } else if(data[0] == (byte)0xF8) { // CLOCK PULSE
    midiClock.pulse();
  }
}

public void controllerChange(ControlChange change) {
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

public void noteOn(Note note) {
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

public void noteOff(Note note) {
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
class InternalClock extends Thread {
  public ClockListener listener;
  public int bpm = 120;
  public int pulse = 0;
  public int division = 4;
  int ppqn = 24; // pulses per quarter note MIDI standard value is 24
  
  Boolean isActive = true;
  Boolean isRunning = true;
  long previousTime; // in ns
  double pulseInterval; // in ns

  InternalClock(ClockListener inListener) {
    listener = inListener;
    pulseInterval = 1000.0f / (bpm / 60.0f * ppqn) * 1000000; 
    previousTime = System.nanoTime();
  }
  
  public void setBPM(int newBpm) {
    bpm = newBpm;
    pulseInterval = 1000.0f / (bpm / 60.0f * ppqn) * 1000000; 
  }

  public void run() {
    try {
      while(isActive) {
        if (!isRunning) { continue; }
        long timePassed = System.nanoTime() - previousTime;
        if (timePassed < (long)pulseInterval) {
          continue;
        } 
        listener.pulse();
        //byte[] pulseMessage= {(byte)0xF8};
        //midiBus.sendMessage(pulseMessage);
        pulse++;
        int pulsesPerTick = ppqn / division; // 24 - 12 - 8 - 6
        if (pulse % pulsesPerTick == 0) {
          listener.tick();
        }
        if (pulse % pulsesPerTick == pulsesPerTick/2) {
          listener.tock();
        }
        // calculate real time until next pulse
        long delay = ((long)pulseInterval*5/3 - (System.nanoTime() - previousTime));
        previousTime = System.nanoTime();
        if (delay > 0) {
          Thread.sleep(delay/1000000);
        }
      }
    }  catch(InterruptedException e) {
      println("force quit...");
    }
  }
} 

class MIDIClock {
  public ClockListener listener;
  public int pulse;
  public int division;
  
  public MIDIClock(ClockListener inListener) {
    listener = inListener; 
    pulse = 0;
    division = 4;
  }
  
  public void pulse() {
    listener.pulse();
    pulse++;
    int pulsesPerTick = 24 / division; // 24 - 12 - 8 - 6
    if (pulse % pulsesPerTick == 0) {
      listener.tick();
    }
    if (pulse % pulsesPerTick == pulsesPerTick/2) {
      listener.tock();
    }
  }
}

interface ClockListener {
    public void tick();
    public void tock();
    public void pulse();
}
class DeviceManager {  
  int inputIndex = -1;
  String inputName = "";
  int controllerIndex = -1;
  String controllerName = "";
  int outputIndex = -1;
  String outputName = "";
  
  public String[] defaults() {
    String[] outputs = MidiBus.availableOutputs();
    String[] inputs = MidiBus.availableInputs();
    String output = "";
    String input = "";
    for (int i = 0; i < outputs.length; i++) {
      if (outputs[i].contains("fmidi")) {
        output = outputs[i];
        println("default output found");
      }
    }
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i].contains("Mix")) {
        input = inputs[i];
        println("default input found");
      }
    }
    return new String[]{input, output};
  }
  
  public String getNextController() {
    if (MidiBus.availableInputs().length > controllerIndex + 1) {
      return MidiBus.availableInputs()[controllerIndex + 1];
    } else if (MidiBus.availableInputs().length > 0) {
      return MidiBus.availableInputs()[0];
    } else {
      return "";
    }
  }
  
  public int getNextControllerIndex() {
    if (MidiBus.availableInputs().length > controllerIndex + 1) {
      return controllerIndex + 1;
    } else if (MidiBus.availableInputs().length > 0) {
      return 0;
    } else {
      return -1;
    }
  }
  
  public String getNextInput() {
    if (MidiBus.availableInputs().length > inputIndex + 1) {
      return MidiBus.availableInputs()[inputIndex + 1];
    } else {
      return "INTERNAL";
    }
  }
  
  public int getNextInputIndex() {
    if (MidiBus.availableInputs().length > inputIndex + 1) {
      return inputIndex + 1;
    } else {
      return -1;
    }
  }
  
  public String nextOutput() {
    if (MidiBus.availableOutputs().length > outputIndex + 1) {
      outputIndex = outputIndex + 1;
      outputName = MidiBus.availableOutputs()[outputIndex];
    } else {
      outputIndex = -1;
      outputName = "ALL";
    }
    return outputName;
  }
  
  public Boolean addAllOutputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableOutputs().length; i++) {
      midiBus.addOutput(MidiBus.availableOutputs()[i]);
      found = true;
    }
    return found;
  }
  
  // Adds LPD8 and MIDI Mix controllers if found
  public Boolean addKnownInputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableInputs().length; i++) {
      if (MidiBus.availableInputs()[i] == "LPD8" || MidiBus.availableInputs()[i] == "MIDI Mix") {
        midiBus.addInput(MidiBus.availableInputs()[i]);
        found = true;
      }
    }
    return found;
  }
}


class Sequencer implements ClockListener {
  Map<String, Track> tracks = new HashMap<String, Track>();
  LinkedList<Map.Entry<String, Track>> sortedTracks;
  LinkedList<Map.Entry<String, Track>> reversedTracks;
  int maxSteps = 16;
  MidiBus midiBus;
  public int tick = 0;
  public int pulse = 0;
  boolean isPlaying = false;
  boolean isSoloing = false;
  boolean drawCircle = true;
  boolean drawRadius = false;
  boolean drawPolygon = false;
  String isEditingTrackId = "";
  
  public Sequencer(MidiBus bus) {
    midiBus = bus;
    tracks.put("1", new Track("KICK", 0, 76, 0, 0, 0, 0, color(200,38,53), 1)); //red
    tracks.put("2", new Track("SNARE", 0, 79, 0, 0, 0, 0, color(255,127,81), 4)); //orange
    tracks.put("3", new Track("RIM", 0, 81, 0, 0, 0, 0, color(239,138,23), 7)); //peach
    tracks.put("4", new Track("CLAP", 0, 82, 0, 0, 0, 0, color(242,193,20), 10)); //yellow
    tracks.put("5", new Track("TOM", 0, 83, 0, 0, 0, 0, color(17,75,95), 13));// blue
    tracks.put("6", new Track("SP1", 0, 86, 0, 0, 0, 0, color(136,212,152), 16));// green
    tracks.put("7", new Track("SP2", 0, 91, 0, 0, 0, 0, color(117,159,188), 19));// light blue
    tracks.put("8", new Track("SQ1", 1, 76, 0, 0, 0, 0, color(255,166,158), 22));// pink
    sortTracks();
  }
  
  public void play() {
    isPlaying = true;
  }
  
  public void pause() {
    isPlaying = false;
  }
  
  public void stop() {
    isPlaying = false;
    tick = 0;
  }
  
  private void sortTracks() {
    LinkedList<Map.Entry<String, Track>> list = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
    Collections.sort(list, new Comparator<Map.Entry<String, Track>>() {
        @Override
        public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
           return o1.getValue().steps - o2.getValue().steps;      
        }
    });
    sortedTracks = list;
    LinkedList<Map.Entry<String, Track>> reversedList = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
    Collections.sort(reversedList, new Comparator<Map.Entry<String, Track>>() {
        @Override
        public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
           return o2.getValue().steps - o1.getValue().steps;      
        }
    });
    reversedTracks = reversedList;
  }
  
  private int activeTracksCount() {
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    int activeTracksCount = 0;
    while (iterator.hasNext()) {
      if (iterator.next().getValue().steps > 0) {
        activeTracksCount++;
      }
    }
    return activeTracksCount;
  }
  
  public void drawTracks() {
    int activeTracksCount = activeTracksCount();
    // Draw polygon
    if (drawPolygon) {
      int index = 0;
      Iterator<Map.Entry<String, Track>> iterator = reversedTracks.iterator();
      while(iterator.hasNext()) {
        Track track = iterator.next().getValue();
        int[] steps = track.computedSteps.clone();
        if (track.steps == 0) {
          continue;
        }
        float radius = screenHeight / (activeTracksCount + 1) * (activeTracksCount-index);
        noStroke();
        fill(track.trackColor);
        beginShape();
        float angle = TWO_PI / (float)track.steps;
        for(int j = 0; j < steps.length; j++) {
          int stepVelocity = steps[j];
          if (stepVelocity != 0) {
            float x = radius/2 * sin(angle*j) + screenHeight/2;
            float y = radius/2 * -cos(angle*j) + screenHeight/2;
            vertex(x,y);
          }
        }
        endShape();
        noFill();
        noStroke();
        index++;
      }
    }
    
    ellipseMode(CENTER);
    noFill();
    int index = 1;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Map.Entry<String, Track> entry = iterator.next();
      int[] steps = entry.getValue().computedSteps.clone();
      int trackLength = entry.getValue().steps;
      if (trackLength == 0) {
        continue;
      }
      // Draw track circle
      float radius = screenHeight / (activeTracksCount + 1) * index;
      noFill();
      if (drawCircle) {
        strokeWeight(24);
        stroke(entry.getValue().trackColor, 64);
        ellipse(screenHeight/2, screenHeight/2, radius, radius);
        noStroke();
      }      
      
      // Draw track steps
      float angle = TWO_PI / (float)trackLength;
      int currentStepIndex = tick % trackLength;
      for(int i = 0; i < trackLength; i++) {
        int stepVelocity = steps[i];
        int stepColor;
        if (stepVelocity == 0) {
          stepColor = entry.getValue().trackColor;
        } else {
          stepColor = Color.WHITE.getRGB();
        }
        float x = radius/2 * sin(angle*i) + screenHeight/2;
        float y = radius/2 * -cos(angle*i) + screenHeight/2;
        float size;
        if (i == currentStepIndex) { 
          size = 16; 
        } else {
          if (stepVelocity == 127) {
            size = 14; 
          } else {
            size = 10;
          }
        }
        // Draw radius
        if (drawRadius && stepVelocity != 0) {
          stroke(entry.getValue().trackColor, 64);
          strokeWeight(size/2);
          line(screenHeight/2, screenHeight/2, x, y);
          noStroke();
        }
        // Draw step
        fill(stepColor);
        ellipse(x, y, size, size);
      }
      index++;
    }
    
    drawLFO();
  }
  
  public void drawLFO() {
    if (isEditingTrackId != "") {
      Track track = tracks.get(isEditingTrackId);
      stroke(track.trackColor);
      strokeWeight(2);
      int x = (int)screenWidth - 300;
      int y = (int)screenHeight - 66 - 54;
      int lineSpacing = 4;
      float period = 300.0f / 127.0f * track.lfoPeriod;
      double degrees = (double)((tick % track.lfoPeriod) * 360 / track.lfoPeriod);
      float a = (float)Math.toRadians(degrees);
      float increment = TWO_PI/period * lineSpacing;
      int amp = track.lfoAmount * 2;
      for (int i = 0; i < 300; i = i + lineSpacing) {
        line(x+i, y, x+i, y + -sin(a) * amp);
        a = a + increment;
      }
      noStroke();
    }
  }

  public @Override
  void tick() {
    if (!isPlaying) { return; }
    tick++;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      if (track.steps < 1 || track.isMuted) { continue; }
      if (isSoloing && track.isSolo == false) { continue; }
      int[] steps = track.computedSteps;
      int index = tick % track.steps;
      int velocity = steps[index];
      if (velocity > 0) {
        if (track.lfoAmount > 0) {
          double degrees = (double)((tick % track.lfoPeriod) * 360 / track.lfoPeriod);
          double radians = Math.toRadians(degrees);
          int modifier = (int)(Math.sin(radians) * track.lfoAmount);
          velocity = velocity + modifier;
          if (velocity > 127) {
            velocity = 127;
          }
        }
        midiBus.sendNoteOn(track.channel, track.note, velocity);
        midiBus.sendNoteOff(track.channel, track.note, velocity);
        if (isEditingTrackId == "") {
          midiBus.sendNoteOn(0, track.controllerLightNote + 2, 127); // blink track light
        }
      }
    }
  }
  
  public @Override 
  void tock() {
    if (isEditingTrackId == "") {
      turnOffBeatLights();
    }
  }
  
  public @Override 
  void pulse() {
    if (!isPlaying) { return; }
    pulse++;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      if (!track.isMuted && track.isRolling && pulse % track.rollPeriod == 0) {
        midiBus.sendNoteOn(track.channel, track.note, track.normalVelocity);
        midiBus.sendNoteOff(track.channel, track.note, track.normalVelocity);
      }
    }
  }
  
  private void turnOffBeatLights() {
    midiBus.sendNoteOn(0, 3, 0);
    midiBus.sendNoteOn(0, 6, 0);
    midiBus.sendNoteOn(0, 9, 0);
    midiBus.sendNoteOn(0, 12, 0);
    midiBus.sendNoteOn(0, 15, 0);
    midiBus.sendNoteOn(0, 18, 0);
    midiBus.sendNoteOn(0, 21, 0);
    midiBus.sendNoteOn(0, 24, 0);
  }
  
  private void turnOnBeatLightFor(String id) {
    midiBus.sendNoteOn(0, tracks.get(id).controllerLightNote + 2, 127);
  }
  
  // LENGTH
  
  public void incrementTrackLength(String id) {
    if (tracks.get(id).steps + 1 <= maxSteps) {
      tracks.get(id).steps = tracks.get(id).steps + 1;
      tracks.get(id).computeSteps();
      sortTracks();
    }
  }
  
  public void decrementTrackLength(String id) {
    if (tracks.get(id).steps - 1 >= 0) {
      tracks.get(id).steps = tracks.get(id).steps - 1;
      tracks.get(id).computeSteps();
      sortTracks();
    }
  }
  
  public void updateTrackLength(String id, int value) {
    tracks.get(id).steps = maxSteps * value / 127;
    tracks.get(id).computeSteps();
    sortTracks();
  }
  
  // BEATS
  
  public void updateTrackBeats(String id, int value) {
    tracks.get(id).beats = maxSteps * value / 127; 
    tracks.get(id).computeSteps();
  }
  
  // OFFSET
  
  public void updateTrackOffset(String id, int value) {
    tracks.get(id).rotate = maxSteps * value / 127; 
    tracks.get(id).computeSteps();
  }
  
  public void incrementTrackOffset(String id) {
    if (tracks.get(id).rotate + 1 <= maxSteps) {
      tracks.get(id).rotate = tracks.get(id).rotate + 1;
      tracks.get(id).computeSteps();
    }
  }
  
  public void decrementTrackOffset(String id) {
    if (tracks.get(id).rotate - 1 >= 0) {
      tracks.get(id).rotate = tracks.get(id).rotate - 1;
      tracks.get(id).computeSteps();
    }
  }
  
  // ACCENTS
  
  public void updateTrackAccents(String id, int value) {
    tracks.get(id).accents = tracks.get(id).beats * value / 127;
    tracks.get(id).computeSteps();
  }
  
  // MUTE/SOLO
  
  public void muteTrack(String id) {
    tracks.get(id).isMuted = !tracks.get(id).isMuted;
    int velocity = tracks.get(id).isMuted ? 127 : 0;
    midiBus.sendNoteOn(0, tracks.get(id).controllerLightNote, velocity);
  }
  
  public void addSoloTrack(String id) {
    tracks.get(id).isSolo = true;
    boolean hasSoloTrack = false;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      if (iterator.next().getValue().isSolo) {
        hasSoloTrack = true;
      }
    }
    isSoloing = hasSoloTrack;
  }
  
  public void removeSoloTrack(String id) {
    tracks.get(id).isSolo = false;
    boolean hasSoloTrack = false;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      if (iterator.next().getValue().isSolo) {
        hasSoloTrack = true;
      }
    }
    isSoloing = hasSoloTrack;
  }
  
  public void clearSoloTracks() {
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      track.isSolo = false;
    }
    isSoloing = false;
  }
  
  // ROLL
  
  public void rollTrack(String id) {
    tracks.get(id).isRolling = !tracks.get(id).isRolling;
  }
  
  // LFO
  
  public void editTrackLFO(String id) {
    if (isEditingTrackId == "") { // start editing
      isEditingTrackId = id;
      turnOffBeatLights();
      turnOnBeatLightFor(id);
    } else { // end editing
      turnOffBeatLights();
      isEditingTrackId = "";
    }
  }
  
  public void updateLFOAmount(int value) {
    if (isEditingTrackId == "") {
      return;
    } else {
      tracks.get(isEditingTrackId).lfoAmount = 27 * value / 127;
    }
  }
  
  public void updateLFOPeriod(int value) {
    if (isEditingTrackId == "") {
      return;
    } else if (value > 0) {
      tracks.get(isEditingTrackId).lfoPeriod = value; 
    }
  }
  
  // A/B
  
  public void switchToA() {
    
  }
  
  public void switchToB() {
    
  }
}

class Track {
  public String id;
  public int channel;
  public int note;
  public int steps;
  public int beats;
  public int rotate;
  public int accents;
  public int trackColor;
  public boolean isMuted = false;
  public boolean isSolo = false;
  public boolean isRolling = false;
  public int rollPeriod = 2; // when rolling, play a note every *rollPeriod* pulses
  public int lfoPeriod = 32; // period in ticks, from 0 to 127
  public int lfoAmount = 0; // -27 - +27
  public int controllerLightNote;

  int normalVelocity = 100;
  int accentVelocity = 127;
  
  public int[] computedSteps;
  public int[] computedAccents;

  public Track(String inId, int inChannel, int inNote, int inSteps, int inBeats, int inRotate, int inAccents, int inColor, int inControllerLightNote) {
    id = inId;
    channel = inChannel;
    note = inNote;
    steps = inSteps;
    beats = inBeats;
    rotate = inRotate;
    accents = inAccents;
    trackColor = inColor;
    controllerLightNote = inControllerLightNote;
    computeSteps();
  }

  public void computeSteps() {
    Vector<Boolean> sequence = computeEuclideanSequence(beats, steps);
    Vector<Boolean> accentsSequence = computeEuclideanSequence(accents, beats);
    
    int[] beats = new int[sequence.capacity()];
    int beatIndex = 0;
    for (int i = 0; i < sequence.size(); i++) {
      if (sequence.get(i) == true) {
        if (accentsSequence.get(beatIndex) == true) {
          beats[i] = accentVelocity;
        } else {
          beats[i] = normalVelocity;
        }
        beatIndex++;
      } else {
        beats[i] = 0;
      }
    }
    ArrayRightRotation.rotateRight(beats, rotate, steps);
    computedSteps = beats;
  }
  
  private Vector<Boolean> computeEuclideanSequence(int beats, int steps) {
    Vector<Boolean> pattern = new Vector<Boolean> ( );
    if ( beats >= steps ) {
      /** Fill every steps with a pulse. */
      for ( int i = 0; i < steps; i++ ) {
        pattern.add ( true );
      }
    } else if ( steps == 1 ) {
      pattern.add ( beats == 1 );
    } else if ( beats == 0 ) {
      /** Fill every steps with a silence. */
      for ( int i = 0; i < steps; i++ ) {
        pattern.add ( false );
      }
    } else {
      // SANE INPUT
      int pauses = steps - beats;
      if ( pauses >= beats ) { 
        // first case more pauses than pulses
        int per_pulse = ( int ) Math.floor ( pauses / beats );
        int remainder = pauses % beats;
        for ( int i = 0; i < beats; i++ )
        {
          pattern.add ( true );
          for ( int j = 0; j < per_pulse; j++ )
          {
            pattern.add ( false );
          }
          if ( i < remainder )
          {
            pattern.add ( false );
          }
        }
      } else { 
        // second case more pulses than pauses
        int per_pause = ( int ) Math.floor ( ( beats - pauses ) / pauses );
        int remainder = ( beats - pauses ) % pauses;
        for ( int i = 0; i < pauses; i++ )
        {
          pattern.add ( true );
          pattern.add ( false );
          for ( int j = 0; j < per_pause; j++ )
          {
            pattern.add ( true );
          }
          if ( i < remainder )
          {
            pattern.add ( true );
          }
        }
      }
    }
    return pattern;
  }
}


class UI {
  ControlP5 cp5;
  
  int sliderHeight = 36;
  int buttonHeight = 36;
  int padding = 15;
  int uiWidth = 300 - padding;

  Group menuGroup;
  controlP5.Button controllerButton;
  controlP5.Button inputButton;
  controlP5.Button outputButton;
  controlP5.Textlabel[] trackLabels;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    trackLabels = new controlP5.Textlabel[sequencer.sortedTracks.size()];
    int buttonWidth = (uiWidth - padding * 2)/3;
    
    addTrackLabels();
    
    cp5.addButton("quit")
    .setLabel("QUIT")
    .setPosition(0, 0)
    .setSize(buttonHeight, buttonHeight);
    
    menuGroup = cp5.addGroup("settings")
    .setPosition(screenWidth - uiWidth - padding, padding).setWidth(uiWidth)
    .setSize(uiWidth, (int)screenHeight - padding * 2).setOpen(false);
    
    controllerButton = cp5.addButton("controller")
    .setLabel("SELECT MIDI CONTROLLER")
    .setPosition(0, padding)
    .setSize(uiWidth, buttonHeight)
    .moveTo(menuGroup);
    
    inputButton = cp5.addButton("input")
    .setLabel("MIDI CLOCK SOURCE: INTERNAL")
    .setPosition(0, padding * 2 + sliderHeight)
    .setSize(uiWidth, buttonHeight)
    .moveTo(menuGroup);
    
    outputButton = cp5.addButton("output")
    .setLabel("SELECT MIDI OUTPUT")
    .setPosition(0, padding * 3 + sliderHeight * 2)
    .setSize(uiWidth, buttonHeight)
    .moveTo(menuGroup);
    
    cp5.addSlider("bpm").setSliderMode(Slider.FLEXIBLE)
    .setPosition(0, padding * 4 + sliderHeight * 3)
    .setWidth(uiWidth - 20).setHeight(sliderHeight)
    .setRange(0, 480).setValue(120)
    .moveTo(menuGroup);
    
    cp5.addRadioButton("division")
    .setItemsPerRow(4).addItem("by 1", 1).addItem("by 2", 2).addItem("by 3", 3).addItem("by 4", 4)
    //.toggle(3) method not yet implemented
    .setSpacingColumn(padding*2)
    .setPosition(0, padding * 5 + sliderHeight * 4)
    .setSize(sliderHeight, sliderHeight)
    .moveTo(menuGroup);
    
    cp5.addButton("play").setValue(0)
    .setPosition(screenWidth - uiWidth - padding, screenHeight - padding - buttonHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addButton("pause").setValue(0)
    .setPosition(screenWidth - uiWidth - padding + buttonWidth + padding, screenHeight - padding - buttonHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addButton("stop").setValue(0)
    .setPosition(screenWidth - uiWidth - padding + buttonWidth * 2 + padding * 2, screenHeight - padding - buttonHeight)
    .setSize(buttonWidth, buttonHeight);
    
    //cp5.addButton("save").setValue(0)
    //.setPosition(screenWidth - uiWidth - padding, screenHeight - padding * 2 - buttonHeight * 2)
    //.setSize(buttonWidth, buttonHeight);
    //cp5.addButton("load").setValue(0)
    //.setPosition(screenWidth - uiWidth - padding + buttonWidth * 2 + padding * 2, screenHeight - padding * 2 - buttonHeight * 2)
    //.setSize(buttonWidth, buttonHeight);
    
    cp5.addButton("circular").setLabel("C")
    .setPosition(padding, screenHeight - buttonHeight - padding)
    .setSize(buttonHeight, buttonHeight);
    cp5.addButton("radial").setLabel("R")
    .setPosition(padding * 2 + buttonHeight, screenHeight - buttonHeight - padding)
    .setSize(buttonHeight, buttonHeight);
    cp5.addButton("polygonal").setLabel("P")
    .setPosition(padding * 3 + buttonHeight * 2, screenHeight - buttonHeight - padding)
    .setSize(buttonHeight, buttonHeight);
  }
  
  private void addTrackLabels() {
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    int index = 0;
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      cp5.addLabel(track.id + index)
      .setText(track.id)
      .setColor(track.trackColor)
      .setFont(createFont("Courier", 20))
      .setPosition(screenWidth - uiWidth - padding, padding * 2 + padding * 2 * index);
      controlP5.Textlabel trackLabel = cp5
      .addLabel(track.id)
      .setText(String.format("%02d", track.steps) + " - " + String.format("%02d", track.beats) + " - " + String.format("%02d", track.rotate) + " - " + String.format("%02d", track.accents))
      .setColor(track.trackColor)
      .setFont(createFont("Courier", 20))
      .setPosition(screenWidth - uiWidth + padding * 4, padding * 2 + padding * 2 * index);
      trackLabels[index] = trackLabel;
      index++;
    }
  }
  
  public void updateTrackLabels() {
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      controlP5.Textlabel trackLabel = (controlP5.Textlabel)cp5.getController(track.id);
      trackLabel.setText(String.format("%02d", track.steps) + " - " + String.format("%02d", track.beats) + " - " + String.format("%02d", track.rotate) + " - " + String.format("%02d", track.accents));
    }
  }
  
}
public static class ArrayRightRotation {  
  public static void rotateRight(int array[], int d, int n) {   
    for (int i = 0; i < d; i++)   
      rotateArrayByOne(array, n);      
  }
  
  public static void rotateArrayByOne(int array[], int n) {   
    if (n < 1 || array.length < 1) {
      return;
    }
    int i, temp;   
    temp = array[n - 1];   
    for (i = n-1; i > 0; i--)
      array[i] = array[i - 1];       
      array[0] = temp;   
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ems" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
