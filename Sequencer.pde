import themidibus.*;

class Sequencer implements ClockListener {
  Map<String, Track> tracks = new HashMap<String, Track>();
  LinkedList<Map.Entry<String, Track>> sortedTracks;
  int maxSteps = 32;
  int midiChannel = 0;
  MidiBus midiBus;
  public int tick = 0;
  boolean isPlaying = false;
  
  public Sequencer(MidiBus bus) {
    midiBus = bus;
    tracks.put("1", new Track("1", 40, 16, 4, 0, color(255,196,61)));
    tracks.put("2", new Track("2", 41, 16, 0, 0, color(239,71,111)));
    tracks.put("3", new Track("3", 42, 16, 0, 0, color(27,154,170)));
    tracks.put("4", new Track("4", 43, 16, 0, 0, color(178,237,197)));
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
      float radius = screenHeight / (activeTracksCount + 1) * index;
      // Draw track circle
      noFill();
      stroke(entry.getValue().trackColor);
      //ellipse(screenHeight/2, screenHeight/2, radius, radius);
      // Draw track steps
      noStroke();
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
        float x = radius/2 * sin(angle*i) + screenHeight/2;
        float y = radius/2 * -cos(angle*i) + screenHeight/2;
        if (i == currentStepIndex) {
          if (stepVelocity == 0) {
            stepColor = entry.getValue().trackColor;
            fill(stepColor);
            ellipse(x, y, 20, 20);
          } else {
            stepColor = Color.WHITE.getRGB();
            fill(stepColor);
            ellipse(x, y, 20, 20);
          }
        } else {
          if (stepVelocity == 0) {
            stepColor = entry.getValue().trackColor;
            fill(stepColor);
            ellipse(x, y, 8, 8);
          } else {
            stepColor = Color.WHITE.getRGB();
            fill(stepColor);
            float stepRadius = ((float)stepVelocity) / 127.0 * 15.0;
            ellipse(x, y, stepRadius, stepRadius);
          }
        }
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
      int[] steps = track.computedSteps;
      int index = tick % steps.length;
      int velocity = steps[index];
      if (velocity > 0) {
        print("PLAY track " );
        print(track.id);
        print(" tick " );
        print(tick);
        println(" " );
        midiBus.sendNoteOn(midiChannel, track.note, velocity);
        delay(1);
        midiBus.sendNoteOff(midiChannel, track.note, velocity);
      }
    }
  }
  
  public void incrementTrackLength(String id) {
    if (tracks.get(id).steps + 1 < maxSteps) {
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
  
  public void updateTrackBeats(String id, int value) {
    tracks.get(id).beats = tracks.get(id).steps * value / 127;
    tracks.get(id).computeSteps();
  }
  
  public void updateTrackOffset(String id, int value) {
    tracks.get(id).rotate = tracks.get(id).steps * value / 127;
    tracks.get(id).computeSteps();
  }
  
  private void delay(int time) {
    int current = millis();
    while (millis () < current+time) Thread.yield();
  }
}
