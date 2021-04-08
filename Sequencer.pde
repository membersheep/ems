import themidibus.*;

class Sequencer implements ClockListener {
  Map<String, Track> tracks = new HashMap<String, Track>();
  LinkedList<Map.Entry<String, Track>> sortedTracks;
  int maxSteps = 32;
  MidiBus midiBus;
  public int tick = 0;
  boolean isPlaying = false;
  boolean drawCircle = true;
  boolean drawRadius = false;
  boolean drawPolygon = false;
  
  public Sequencer(MidiBus bus) {
    midiBus = bus;
    tracks.put("1", new Track("KICK", 1, 60, 2, 1, 0, 0, color(200,38,53))); //red
    tracks.put("2", new Track("SNARE", 2, 60, 3, 1, 0, 0, color(255,127,81))); //orange
    tracks.put("3", new Track("RIM", 3, 60, 4, 3, 0, 1, color(239,138,23))); //peach
    tracks.put("4", new Track("CLAP", 4, 60, 5, 3, 0, 2, color(242,193,20))); //yellow
    tracks.put("5", new Track("TOM", 5, 60, 0, 0, 0, 0, color(17,75,95)));// blue
    tracks.put("6", new Track("SP1", 6, 60, 0, 0, 0, 0, color(136,212,152)));// green
    tracks.put("7", new Track("SP2", 7, 60, 0, 0, 0, 0, color(117,159,188)));// light blue
    tracks.put("8", new Track("CH8", 8, 60, 0, 0, 0, 0, color(255,166,158)));// pink
    sortTracks();
  }
  
  public void play() {
    isPlaying = true;
  }
  
  public void pause() {
    isPlaying = false;
  }
  
  public void stop() {
    isPlaying = false;
    tick = 0;
  }
  
  private void sortTracks() {
    LinkedList<Map.Entry<String, Track>> list = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
    Collections.sort(list, new Comparator<Map.Entry<String, Track>>() {
        @Override
        public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
           return o1.getValue().steps - o2.getValue().steps;      
        }
    });
    sortedTracks = list;
  }
  
  private int activeTracksCount() {
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    int activeTracksCount = 0;
    while (iterator.hasNext()) {
      if (iterator.next().getValue().steps > 0) {
        activeTracksCount++;
      }
    }
    return activeTracksCount;
  }
  
  void drawTracks() {
    ellipseMode(CENTER);
    noFill();
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    int index = 1;
    int activeTracksCount = activeTracksCount();
    while (iterator.hasNext()) {
      Map.Entry<String, Track> entry = iterator.next();
      int trackLength = entry.getValue().steps;
      if (trackLength == 0) {
        continue;
      }
      // Draw track circle
      float radius = screenHeight / (activeTracksCount + 1) * index;
      noFill();
      if (drawCircle) {
        strokeWeight(24);
        stroke(entry.getValue().trackColor, 64);
        ellipse(screenHeight/2, screenHeight/2, radius, radius);
        noStroke();
      }
      // Draw polygon
      if (drawPolygon) {
        noStroke();
        fill(entry.getValue().trackColor);
        beginShape();
        int[] steps = entry.getValue().computedSteps;
        float angle = TWO_PI / (float)trackLength;
        for(int i = 0; i < trackLength; i++) {
          int stepVelocity = steps[i];
          if (stepVelocity != 0) {
            float x = radius/2 * sin(angle*i) + screenHeight/2;
            float y = radius/2 * -cos(angle*i) + screenHeight/2;
            vertex(x,y);
          }
        }
        endShape();
        noFill();
      }
      
      // Draw track steps
      float angle = TWO_PI / (float)trackLength;
      int currentStepIndex = tick % trackLength;
      int[] steps = entry.getValue().computedSteps;
      for(int i = 0; i < trackLength; i++) {
        int stepVelocity = steps[i];
        color stepColor;
        if (stepVelocity == 0) {
          stepColor = entry.getValue().trackColor;
        } else {
          stepColor = Color.WHITE.getRGB();
        }
        float x = radius/2 * sin(angle*i) + screenHeight/2;
        float y = radius/2 * -cos(angle*i) + screenHeight/2;
        float size;
        if (i == currentStepIndex) { 
          size = 24; 
        } else {
          if (stepVelocity == 0) {
            size = 8; 
          } else {
            size = ((float)stepVelocity) / 127.0 * 16.0;
          }
        }
        // Draw radius
        if (drawRadius) {
          stroke(entry.getValue().trackColor, 64);
          strokeWeight(size/2);
          line(screenHeight/2, screenHeight/2, x, y);
          noStroke();
        }
        // Draw step
        fill(stepColor);
        ellipse(x, y, size, size);
      }
      index++;
    }
  }

  @ Override
  void tick() {
    if (!isPlaying) { return; }
    tick++;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      if (track.steps < 1) { continue; }
      int[] steps = track.computedSteps;
      int index = tick % track.steps;
      int velocity = steps[index];
      if (velocity > 0) {
        midiBus.sendNoteOn(track.channel, track.note, velocity);
        // We could try to group the on and the off commands to yield for a default gate length among them
        midiBus.sendNoteOff(track.channel, track.note, velocity);
      }
    }
  }
  
  public void incrementTrackLength(String id) {
    if (tracks.get(id).steps + 1 <= maxSteps) {
      tracks.get(id).steps = tracks.get(id).steps + 1;
      tracks.get(id).computeSteps();
      sortTracks();
    }
  }
  
  public void decrementTrackLength(String id) {
    if (tracks.get(id).steps - 1 >= 0) {
      tracks.get(id).steps = tracks.get(id).steps - 1;
      tracks.get(id).computeSteps();
      sortTracks();
    }
  }
  
  public void updateTrackLength(String id, int value) {
    tracks.get(id).steps = maxSteps * value / 127;
    tracks.get(id).computeSteps();
    sortTracks();
  }
  
  public void updateTrackBeats(String id, int value) {
    tracks.get(id).beats = tracks.get(id).steps * value / 127;
    tracks.get(id).computeSteps();
  }
  
  public void updateTrackOffset(String id, int value) {
    tracks.get(id).rotate = tracks.get(id).steps * value / 127;
    tracks.get(id).computeSteps();
  }
  
  public void updateTrackAccents(String id, int value) {
    tracks.get(id).accents = tracks.get(id).beats * value / 127;
    tracks.get(id).computeSteps();
  }
}
