import java.util.*;
import java.awt.*;
import themidibus.*;

UI ui;
Clock clock;
Sequencer sequencer;
MidiBus midiBus;
float screenWidth = 800;
float screenHeight = 480;

void setup() {
  size(800, 480);
  frameRate(25);
  MidiBus.list();
  midiBus = new MidiBus(this, "LPD8", "CRAVE");
  sequencer = new Sequencer(midiBus);
  clock = new Clock(sequencer);
  ui = new UI(this);
}

void draw() {
  background(0);
  clock.update();
  sequencer.drawTracks();
} //<>//

public void bpm(int bpm) {
  clock.bpm = bpm;
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
}
