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
  private String mId;
  private int mLength;
  private float mX;
  private float mY;
  private float mRadius;
  private color mColor;
  private float mPlayAngle;
  private HashMap mMarkers;
  
  public Collection getMarkers() {
    return mMarkers.values();
  }
  
  public String getId() {
    return mId;
  }
  
  public int getLength() {
    return mLength;
  }
  
  public float getX() {
    return mX;
  }
  public float getY() {
    return mY;
  }
  public float getRadius() {
    return mRadius;
  }
  public color getColor() {
    return mColor;
  }
  public float getPlayAngle() {
    return mPlayAngle;
  }
  public void setX(float inX) {
    mX = inX;
  }
  public void setY(float inY) {
    mY = inY;
  }
  public void setRadius(float inRadius) {
    mRadius = inRadius;
  }
  public void setPlayAngle(float inPlayAngle) {
    mPlayAngle = inPlayAngle;
  }
  public void addMarker(String inId, float inAngle, String inType) {
    mMarkers.put(inId, new Marker(inAngle, inType));
  }
  public void updateMarker(String inId, float inAngle) {
    Marker m = (Marker) mMarkers.get(inId);
    m.setAngle(inAngle);
  }
  public TrackCircle(String id, int trackLength, float inRadius, float inX, float inY, color inColor) {
    mId = id;
    mLength = trackLength;
    mX = inX;
    mY = inY;
    mRadius = inRadius;
    mColor = inColor;
    mMarkers = new HashMap();
    mPlayAngle = 0.0;
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
      stroke(track.getColor());
      ellipse(track.getX(), track.getY(), track.getRadius() * 2, track.getRadius() * 2);
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
      ellipse(track.getX() +track.getRadius() * cos(m.getAngle()), track.getY() + track.getRadius() * sin(m.getAngle()), 10, 10);
    }
    fill(0xFFFFFFFF);
    ellipse(track.getX() + track.getRadius() * cos(track.getPlayAngle()), track.getY() + track.getRadius() * sin(track.getPlayAngle()), 16, 16);
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
    float radius = size/9;
    float x = size/2;
    float y = size/2;
    TrackCircle track = new TrackCircle(trackId, trackLength,radius, x, y, color(0xFF0000FF));
    addTrack(track);
    println("added track");
  } else if (addrpattern.equals("/track/update")) {
    println("updating track");
    String trackId = message.get(0).stringValue();
    TrackCircle track = getTrack(trackId);
    float trackLength = message.get(1).floatValue(); // calculate radius from track length
    float radius = message.get(1).floatValue(); // calculate radius from track length
    float x = 250;
    float y = 250;
    if (track != null) {
      track.setRadius(radius);
      track.setX(x);
      track.setY(y);
    }
    println("updated circle");
  } else if (addrpattern.equals("/tracksequencer/marker/create")) {
    String trackId = message.get(0).stringValue();
    TrackCircle track = getTrack(trackId);
    if (track != null) {
      String markerId = message.get(1).stringValue();
      float angle = message.get(2).floatValue();
      String type = message.get(3).stringValue();
      track.addMarker(markerId, angle, type);
    }
  } else if (addrpattern.equals("/tracksequencer/marker/update")) {
    String trackId = message.get(0).stringValue();
    TrackCircle track = getTrack(trackId);
    if (track != null) {
      String markerId = message.get(1).stringValue();
      float angle = message.get(2).floatValue();
      track.updateMarker(markerId, angle);
    }
  } else if (addrpattern.equals("/tracksequencer/circle/playangle")) {
    String trackId = message.get(0).stringValue();
    TrackCircle track = getTrack(trackId);
    if (track != null) {
      float angle = message.get(1).floatValue();
      track.setPlayAngle(angle);
    }
  }
}

public TrackCircle getTrack(String id) {
  int i;
  TrackCircle track = tracks[0];
  for(i = 0; i < tracks.length-1; i++) {
    if(tracks[i].mId == id) {
      track = tracks[i];
      break;
    }
  }
  return track;
}

public void addTrack(TrackCircle track) {  
  int i;
  println("added 1");
  if (tracks.length == 0) {
    println("added 1b");
    return;
  }
  println("added 1c");
  for(i = 0; i < tracks.length - 1; i++) {
    println("added 1d");
      if(tracks[i].mId == track.mId)
          break;
  }
  println("added 2");
  for(int k = i; k < tracks.length-1; k++) {
      tracks[k+1] = tracks[k];
      tracks[i] = track;
  }
  System.out.println(Arrays.toString(tracks));  
}
