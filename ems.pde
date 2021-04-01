import java.util.*;
import java.awt.*;
import themidibus.*;

Clock clock;
Sequencer sequencer;
Map<String, EMSTrack> tracks = new HashMap<String, EMSTrack>();
LinkedList<Map.Entry<String, EMSTrack>> sortedTracks;
String currentTrackId = "1";
float size = 512;
int tick = 0;
MidiBus midiBus;

void setup() {
  size(512, 512);
  frameRate(25);
  midiBus = new MidiBus(this, 0, 0);
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
  drawTracks();
}

void drawTracks() {
  ellipseMode(CENTER);
  noFill();
  Iterator<Map.Entry<String, EMSTrack>> iterator = sortedTracks.iterator();
  int index = 1;
  while (iterator.hasNext()) {
    Map.Entry<String, EMSTrack> entry = iterator.next();
    float radius = size / 9 * index;
    noFill();
    stroke(entry.getValue().trackColor);
    ellipse(size/2, size/2, radius, radius);
    int trackLength = entry.getValue().steps;
    if (trackLength == 0) {
      continue;
    }
    float angle = TWO_PI / (float)trackLength;
    int currentStepIndex = tick % trackLength;
    int[] steps = entry.getValue().computedSteps;
    for(int i = 0; i < trackLength; i++) {
      int stepVelocity = steps[i];
      color stepColor;
      if (i == currentStepIndex) {
        stepColor = Color.WHITE.getRGB();
      } else {
        stepColor = entry.getValue().trackColor;
      }
      if (stepVelocity == 0) {
        noFill();
        stroke(stepColor);
        stepVelocity = 100;
      } else {
        fill(stepColor);
      }
      drawStep(radius/2 * sin(angle*i) + size/2, radius/2 * cos(angle*i) + size/2, stepVelocity);
    }
    index++;
  }
}

void drawStep(float x, float y, int velocity) {
  float radius = ((float)velocity) / 127.0 * 20.0;
  ellipse(x, y, radius, radius);
} //<>//
