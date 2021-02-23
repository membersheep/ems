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
  public int stepsCount;
  public int beatsCount;
  public color trackColor;
  
  public float getAngle() {
    return 0.0;
  }
  
  public Track(String inId, int inStepsCount, int inBeatsCount, color inColor) {
    id = inId;
    stepsCount = inStepsCount;
    beatsCount = inBeatsCount;
    trackColor = inColor;
  }
}

void setup() {
  size(512, 512);
  frameRate(25);
  oscP5 = new OscP5(this,5000);  
  tracks.put("1", new Track("1", 16, 4, Color.RED.getRGB()));
  tracks.put("2", new Track("2", 16, 5, Color.ORANGE.getRGB()));
  tracks.put("3", new Track("3", 16, 6, Color.YELLOW.getRGB()));
  tracks.put("4", new Track("4", 16, 7, Color.BLUE.getRGB()));
  tracks.put("5", new Track("5", 16, 8, Color.GREEN.getRGB()));
  tracks.put("6", new Track("6", 16, 9, Color.WHITE.getRGB()));
  tracks.put("7", new Track("7", 16, 10, Color.CYAN.getRGB()));
  tracks.put("8", new Track("8", 16, 2, Color.GRAY.getRGB()));
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
    
    float angle = TWO_PI / (float)entry.getValue().stepsCount;
    for(int i = 0; i < entry.getValue().stepsCount; i++) {
      drawStep(radius/2 * sin(angle*i) + size/2, radius/2 * cos(angle*i) + size/2);
    }
    fill(entry.getValue().trackColor);
    index++;
  }
}

void drawStep(float x, float y) {
  ellipse(x, y, 20, 20);
}

void drawBeat(float x, float y) {
  ellipse(x, y, 20, 20);
}

void oscEvent(OscMessage message) { //<>//
  String addrpattern = message.addrPattern();
  if (addrpattern.equals("/steps")) {
    println("updating steps");
    String trackId = message.get(0).stringValue();
    Track track = tracks.get(trackId);
    int trackLength = message.get(1).intValue();
    track.stepsCount = trackLength;
    sortTracks();
    println("updated steps");
  } else if (addrpattern.equals("/beats")) {
    println("updating beats");
    String trackId = message.get(0).stringValue();
    Track track = tracks.get(trackId);
    int beatsCount = message.get(1).intValue();
    track.beatsCount = beatsCount;
    println("updated beats");
  } else if (addrpattern.equals("/current")) {
    String trackId = message.get(0).stringValue();
    currentTrackId = trackId;
    println("current track", trackId);
  } else if (addrpattern.equals("/tick")) {
    int newTick = message.get(0).intValue();
    tick = newTick;
  } else if (addrpattern.equals("/track")) {
    String ring = message.get(0).stringValue();
      println(ring);
    boolean[] steps = getSteps(ring, "(ring ", ")");
      println(steps);
  }
}

public void sortTracks() {
  LinkedList<Map.Entry<String, Track>> list = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
  Collections.sort(list, new Comparator<Map.Entry<String, Track>>() {
      @Override
      public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
         return o1.getValue().stepsCount - o2.getValue().stepsCount;      
      }
  });
  sortedTracks = list;
}

public static boolean[] getSteps(String s, String prefix, String suffix) {
  if (s != null && prefix != null && s.startsWith(prefix) && suffix != null && s.endsWith(suffix)) {
    s = s.substring(prefix.length(), s.length() - suffix.length());
  }
  String[] parts = s.split(", ");
  boolean[] array = new boolean[parts.length];
  for (int i = 0; i < parts.length; i++)
    array[i] = Boolean.parseBoolean(parts[i]);
  return array;
}
