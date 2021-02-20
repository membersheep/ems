import oscP5.*;
import netP5.*;
import java.util.*;
import java.awt.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
TrackCircle[] tracks;
float size = 512;

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

class TrackCircle {
  public String id;
  public int stepsCount;
  public int beatsCount;
  public color trackColor;
  public HashMap mMarkers;
  public int index;
  
  public float getRadius() {
    return size / 9 * index;
  }
  
  public float getAngle() {
    return 0.0;
  }
  
  public Collection getMarkers() {
    return mMarkers.values();
  }
  
  public TrackCircle(String inId, int inStepsCount, int inBeatsCount) {
    id = inId;
    stepsCount = inStepsCount;
    beatsCount = inBeatsCount;
    trackColor = Color.ORANGE.getRGB();
    index = 0;
    mMarkers = new HashMap();
  }
}

void setup() {
  size(500, 500);
  frameRate(25);
  oscP5 = new OscP5(this,5000);  
  tracks = new TrackCircle[8];
}

int getColorFromMarkerType(Marker m) {
  if (m.getType().equals("HissMaker")) {
    return Color.YELLOW.getRGB();
  } else if (m.getType().equals("BuzzMaker")) {
    // PURPLE
    return 0xFFAF00AF;
  } else if (m.getType().equals("BeepMaker")) {
    return Color.ORANGE.getRGB();
  } else if (m.getType().equals("TweetMaker")) {
    return Color.PINK.getRGB();
  }
  return 0;
}

void draw() {
  background(0);
  ellipseMode(CENTER);
  noFill();
  Collection<TrackCircle> cs = Arrays.asList(tracks); 
  for (Iterator i = cs.iterator(); i.hasNext();) {  
    TrackCircle track = (TrackCircle) i.next();
    if (track != null) {
      stroke(track.trackColor);
      ellipse(size/2, size/2, track.getRadius(), track.getRadius());
    }
  }
  noStroke();
  for (Iterator i = cs.iterator(); i.hasNext();) {
    TrackCircle track = (TrackCircle) i.next();
    if (track != null) {
      Collection ms = track.getMarkers();
    for (Iterator j = ms.iterator(); j.hasNext();) {
      Marker m = (Marker) j.next();
      fill(getColorFromMarkerType(m));      
      ellipse(size/2 +track.getRadius() * cos(m.getAngle()), size/2 + track.getRadius() * sin(m.getAngle()), 10, 10);
    }
    fill(0xFFFFFFFF);
    ellipse(size/2 + track.getRadius() * cos(track.getAngle()), size/2 + track.getRadius() * sin(track.getAngle()), 16, 16);
    }
  }
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage message) { //<>//
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: " + message.addrPattern());
  println(" typetag: " + message.typetag());
  String addrpattern = message.addrPattern();
  if (addrpattern.equals("/track/create")) {
    println("adding track");
    String trackId = message.get(0).stringValue();
    int trackLength = message.get(1).intValue();
    int beatsCount = message.get(2).intValue();
    //int tick = message.get(2).intValue();
    TrackCircle track = new TrackCircle(trackId, trackLength, beatsCount);
    addTrack(track);
    println("added track");
  } else if (addrpattern.equals("/track/update")) {
    println("updating track");
    String trackId = message.get(0).stringValue();
    TrackCircle track = getTrack(trackId);
    int trackLength = message.get(1).intValue();
    int beatsCount = message.get(2).intValue();
    //int tick = message.get(2).intValue();
    track.stepsCount = trackLength;
    track.stepsCount = beatsCount;
    //track.tick = tick;
    println("updated circle");
  }
}

public TrackCircle getTrack(String id) {
  int i;
  TrackCircle track = tracks[0];
  for(i = 0; i < tracks.length-1; i++) {
    if (tracks[i].id == id) {
      track = tracks[i];
      break;
    }
  }
  return track;
}

public void addTrack(TrackCircle track) {  
  int i;
  for(i = 0; i < tracks.length - 1; i++) {
    if (tracks[i] == null) {
      break;
    }
    if (tracks[i].stepsCount > track.stepsCount) {
      break;
    }
  }
  for(int k = i; k < tracks.length-1; k++) {
      tracks[k+1] = tracks[k];
      tracks[i] = track;
  }
}
