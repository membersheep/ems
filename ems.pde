import java.util.*;
import java.awt.*;

Clock clock;
Sequencer sequencer;
String currentTrackId = "1";
float size = 512;


void setup() {
  size(512, 512);
  frameRate(25);
  sequencer = new Sequencer();
  clock = new Clock(sequencer);
}

// CC METHODS

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

// DRAW METHODS

void draw() {
  clock.update();
  background(0);
  text(currentTrackId,20,20);
  sequencer.drawTracks();
} //<>//
