import java.util.*;
import java.awt.*;

UI ui;
DeviceManager deviceManager;
ClockManager clockManager;
Sequencer sequencer;

float screenWidth = 800;
float screenHeight = 480;

// PROCESSING METHODS

void setup() {
  //fullScreen();
  //noCursor();
  size(800, 480); // debug
  frameRate(25);
  String[] outputs = new String[]{"fmidi", "CRAVE", "CTRL"};
  deviceManager = new DeviceManager(new ArrayList<String>(Arrays.asList(outputs)));
  deviceManager.setupIODevices();
  sequencer = new Sequencer(deviceManager); //<>//
  clockManager = new ClockManager(sequencer);
  ui = new UI(); //<>// //<>//
}

void draw() { //<>// //<>//
  background(0);
  sequencer.drawTracks();
  ui.draw();
}

void mousePressed() {
  ui.onTap();
}
