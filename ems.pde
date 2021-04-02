import java.util.*;
import java.awt.*;
import themidibus.*;

Clock clock;
Sequencer sequencer;
MidiBus midiBus;
String currentTrackId = "1";
float size = 512;


void setup() {
  size(512, 512);
  frameRate(25);
  MidiBus.list();
  midiBus = new MidiBus(this, "LPD8", 0);
  sequencer = new Sequencer(midiBus);
  clock = new Clock(sequencer);
}

void draw() {
  clock.update();
  background(0);
  text(currentTrackId,20,20);
  sequencer.drawTracks();
} //<>//

void controllerChange(ControlChange change) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+change.channel());
  println("Number:"+change.number());
  println("Value:"+change.value());
}

void noteOn(Note note) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
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
