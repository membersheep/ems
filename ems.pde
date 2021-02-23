import oscP5.*;
import netP5.*;
import java.util.*;
import java.awt.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Map<String, Track> tracks = new HashMap<String, Track>();
LinkedList<Map.Entry<String, Track>> sortedTracks;
String currentTrackId = "1";
float size = 512;
int tick = 0;

class Track {
  public String id;
  public int[] steps;
  public color trackColor;
  
  public float getAngle() {
    return 0.0;
  }
  
  public Track(String inId, int[] inSteps, color inColor) {
    id = inId;
    steps = inSteps;
    trackColor = inColor;
  }
}

void setup() {
  size(512, 512);
  frameRate(25);
  oscP5 = new OscP5(this,5000);  
  int[] steps = {127, 0, 100, 0, 110, 0, 100, 0};
  tracks.put("1", new Track("1", steps, Color.RED.getRGB()));
  tracks.put("2", new Track("2", steps, Color.ORANGE.getRGB()));
  tracks.put("3", new Track("3", steps, Color.YELLOW.getRGB()));
  tracks.put("4", new Track("4", steps, Color.BLUE.getRGB()));
  tracks.put("5", new Track("5", steps, Color.GREEN.getRGB()));
  tracks.put("6", new Track("6", steps, Color.WHITE.getRGB()));
  tracks.put("7", new Track("7", steps, Color.CYAN.getRGB()));
  tracks.put("8", new Track("8", steps, Color.GRAY.getRGB()));
  sortedTracks = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
  sortTracks();
}

void draw() {
  background(0);
  text(currentTrackId,20,20);
  ellipseMode(CENTER);
  noFill();
  Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
  int index = 1;
  while (iterator.hasNext()) {
    Map.Entry<String, Track> entry = iterator.next();
    float radius = size / 9 * index;
    noFill();
    stroke(entry.getValue().trackColor);
    ellipse(size/2, size/2, radius, radius);
    
    float angle = TWO_PI / (float)entry.getValue().steps.length;
    for(int i = 0; i < entry.getValue().steps.length; i++) {
      int stepVelocity = entry.getValue().steps[i];
      if (stepVelocity == 0) {
        noFill();
        stroke(entry.getValue().trackColor);
        stepVelocity = 100;
      } else {
        fill(entry.getValue().trackColor);
      }
      drawStep(radius/2 * sin(angle*i) + size/2, radius/2 * cos(angle*i) + size/2, stepVelocity);
    }
    index++;
  }
}

void drawStep(float x, float y, int velocity) {
  float radius = ((float)velocity) / 127.0 * 20.0;
  ellipse(x, y, radius, radius);
}

void oscEvent(OscMessage message) { //<>//
  String addrpattern = message.addrPattern();
  if (addrpattern.equals("/current")) {
    String trackId = message.get(0).stringValue();
    currentTrackId = trackId;
    println("current track", trackId);
  } else if (addrpattern.equals("/tick")) {
    int newTick = message.get(0).intValue();
    tick = newTick;
  } else if (addrpattern.equals("/track/update")) {
    String trackId = message.get(0).stringValue();
    String stepsString = message.get(1).stringValue();
    Track track = tracks.get(trackId);
    track.steps = getSteps(stepsString);
    sortTracks();
  }
}

public void sortTracks() {
  LinkedList<Map.Entry<String, Track>> list = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
  Collections.sort(list, new Comparator<Map.Entry<String, Track>>() {
      @Override
      public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
         return o1.getValue().steps.length - o2.getValue().steps.length;      
      }
  });
  sortedTracks = list;
}

public static int[] getSteps(String s) {
  s = s.substring(1, s.length() - 1);
  String[] parts = s.split(", ");
  int[] array = new int[parts.length];
  for (int i = 0; i < parts.length; i++)
    array[i] = Integer.parseInt(parts[i]);
  return array;
}
