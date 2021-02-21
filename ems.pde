import oscP5.*;
import netP5.*;
import java.util.*;
import java.awt.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Track[] tracks;
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
  tracks = new Track[8];
  tracks[0] = new Track("1", 16, 4, Color.RED.getRGB());
  tracks[1] = new Track("2", 16, 4, Color.ORANGE.getRGB());
  tracks[2] = new Track("3", 16, 4, Color.YELLOW.getRGB());
  tracks[3] = new Track("4", 16, 4, Color.BLUE.getRGB());
  tracks[4] = new Track("5", 16, 4, Color.GREEN.getRGB());
  tracks[5] = new Track("6", 16, 4, Color.WHITE.getRGB());
  tracks[6] = new Track("7", 16, 4, Color.CYAN.getRGB());
  tracks[7] = new Track("8", 16, 4, Color.WHITE.getRGB());
}


void draw() {
  background(0);
  ellipseMode(CENTER);
  noFill();
  int i;
  for(i = 0; i < tracks.length; i++) {
    float radius = size / 9 * (i + 1);
    if (tracks[i] != null) {
      stroke(tracks[i].trackColor);
      ellipse(size/2, size/2, radius, radius);
    }
  }
}

void oscEvent(OscMessage message) { //<>//
  //println(" message: " + message.addrPattern());
  String addrpattern = message.addrPattern();
  if (addrpattern.equals("/steps")) {
    println("updating steps");
    String trackId = message.get(0).stringValue();
    Track track = getTrack(trackId);
    int trackLength = message.get(1).intValue();
    track.stepsCount = trackLength;
    sortTracks();
    println("updated steps");
  } else if (addrpattern.equals("/beats")) {
    println("updating beats");
    String trackId = message.get(0).stringValue();
    Track track = getTrack(trackId);
    int beatsCount = message.get(1).intValue();
    track.beatsCount = beatsCount;
    println("updated beats");
  } else if (addrpattern.equals("/tick")) {
    //println("updating tick");
    int newTick = message.get(0).intValue();
    //println(newTick);
    tick = newTick;
    //println("updated tick");
  }
}

public Track getTrack(String id) {
  int i;
  Track track = tracks[0];
  for(i = 0; i < tracks.length-1; i++) {
    if (tracks[i].id == id) {
      track = tracks[i];
      break;
    }
  }
  return track;
}

public void sort2() {
  int n = tracks.length;  
  for (int j = 1; j < n; j++) {  
      Track track = tracks[j];  
      int i = j-1;  
      while ( (i > -1) && ( tracks[i].stepsCount > track.stepsCount ) ) {  
          tracks [i+1] = tracks [i];  
          i--;  
      }  
      tracks[i+1] = track;  
  }
}

public void sortTracks() {
  Track[] newTracks = new Track[8];
  int i, j;
  for(i = 0; i < tracks.length; i++) {
    for(j = 0; j < tracks.length; j++) {
      print(i, j);
      if (newTracks[j] == null) {
        println("set");
        newTracks[j] = tracks[i];
        break;
      }
      print(tracks[i].stepsCount <= newTracks[j].stepsCount);
      print("-");
      print(tracks[i].stepsCount);
      print("-");
      print(newTracks[j].stepsCount);
      if (tracks[i].stepsCount <= newTracks[j].stepsCount) {
        print("-move-");
        for(int k = tracks.length - 1; k >= j; k--) {
          if (newTracks[k] != null) {
            if (k+1 != tracks.length) {
              newTracks[k+1] = newTracks[k];
            }
          }
        }
        println("set");
        newTracks[j] = tracks[i];
        break;
      }
    }
  }
  tracks = newTracks;
}
