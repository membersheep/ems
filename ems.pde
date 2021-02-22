import oscP5.*;
import netP5.*;
import java.util.*;
import java.awt.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Map<String, Track> tracks = new HashMap<String, Track>();
LinkedList<Map.Entry<String, Track>> sortedTracks;
float size = 512;
int tick = 0;

class Marker {
  private String mType;
  private float mAngle;
  public String getType() {
    return mType;
  }
  public void setType(String inType) {
    mType = inType;
  }
  public float getAngle() {
    return mAngle;
  }
  public void setAngle(float inAngle) {
    mAngle = inAngle;
  }
  public Marker(float inAngle, String inType) {
    mAngle = inAngle;
    mType = inType;
  }
}

class Track {
  public String id;
  public int stepsCount;
  public int beatsCount;
  public color trackColor;
  public HashMap mMarkers;
  
  public float getAngle() {
    return 0.0;
  }
  
  public Collection getMarkers() {
    return mMarkers.values();
  }
  
  public Track(String inId, int inStepsCount, int inBeatsCount, color inColor) {
    id = inId;
    stepsCount = inStepsCount;
    beatsCount = inBeatsCount;
    trackColor = inColor;
    mMarkers = new HashMap();
  }
}

void setup() {
  size(500, 500);
  frameRate(25);
  oscP5 = new OscP5(this,5000);  
  tracks.put("1", new Track("1", 16, 4, Color.RED.getRGB()));
  tracks.put("2", new Track("2", 16, 4, Color.ORANGE.getRGB()));
  tracks.put("3", new Track("3", 16, 4, Color.YELLOW.getRGB()));
  tracks.put("4", new Track("4", 16, 4, Color.BLUE.getRGB()));
  tracks.put("5", new Track("5", 16, 4, Color.GREEN.getRGB()));
  tracks.put("6", new Track("6", 16, 4, Color.WHITE.getRGB()));
  tracks.put("7", new Track("7", 16, 4, Color.CYAN.getRGB()));
  tracks.put("8", new Track("8", 16, 4, Color.GRAY.getRGB()));
  sortedTracks = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
  sortTracks();
}

void draw() {
  background(0);
  ellipseMode(CENTER);
  noFill();
  Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
  int index = 1;
  while (iterator.hasNext()) {
    Map.Entry<String, Track> entry = iterator.next();
    float radius = size / 9 * index;
    stroke(entry.getValue().trackColor);
    ellipse(size/2, size/2, radius, radius);
    index++;
  }
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
    println("current track", trackId);
  } else if (addrpattern.equals("/tick")) {
    int newTick = message.get(0).intValue();
    tick = newTick;
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
