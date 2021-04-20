import themidibus.*;

class Sequencer implements ClockListener {
  Map<String, Track> tracks = new HashMap<String, Track>();
  LinkedList<Map.Entry<String, Track>> sortedTracks;
  LinkedList<Map.Entry<String, Track>> reversedTracks;
  int maxSteps = 16;
  MidiBus midiBus;
  public int tick = 0;
  public int pulse = 0;
  boolean isPlaying = true;
  boolean isSoloing = false;
  int visualizationIndex = 1;
  String isEditingTrackId = "";
  
  public Sequencer(MidiBus bus) {
    midiBus = bus;
    tracks.put("1", new Track("KICK", 0, 76, 0, 0, 0, 0, color(237,28,36), 1)); //red
    tracks.put("2", new Track("SNARE", 0, 79, 0, 0, 0, 0, color(238,185,2), 4)); //yellow
    tracks.put("3", new Track("RIM", 0, 81, 0, 0, 0, 0, color(244,93,1), 7)); //orange
    //tracks.put("CLAP", new Track("CLAP", 0, 82, 0, 0, 0, 0, color(242,193,20), 10)); //yellow
    tracks.put("4", new Track("TOM", 0, 83, 0, 0, 0, 0, color(162,220,4), 10));// green
    tracks.put("5", new Track("SP1", 0, 86, 0, 0, 0, 0, color(78,20,140), 13));// purple
    tracks.put("6", new Track("SP2", 0, 91, 0, 0, 0, 0, color(255,112,166), 16));// pink
    tracks.put("7", new Track("SQ1-A", 1, 52, 0, 0, 0, 0, color(45,125,210), 19));// light blue
    tracks.put("8", new Track("SQ1-B", 2, 52, 0, 0, 0, 0, color(0,49,102), 22));// blue
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
  
  public void toggleVisualization() {
    visualizationIndex++;
  }
  
  private Boolean drawSteps() {
    return visualizationIndex%6 == 0 || visualizationIndex%6 == 1 || visualizationIndex%6 == 2 || visualizationIndex%6 == 5; 
  }
  
  private Boolean drawCircle() {
    return visualizationIndex%6 == 1 || visualizationIndex%6 == 2 || visualizationIndex%6 == 3; 
  }
  
  private Boolean drawPolygon() {
    return visualizationIndex%6 == 2 || visualizationIndex%6 == 3 || visualizationIndex%6 == 4 || visualizationIndex%6 == 5; 
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
    LinkedList<Map.Entry<String, Track>> reversedList = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
    Collections.sort(reversedList, new Comparator<Map.Entry<String, Track>>() {
        @Override
        public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
           return o2.getValue().steps - o1.getValue().steps;      
        }
    });
    reversedTracks = reversedList;
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
    int activeTracksCount = activeTracksCount();
    // Draw polygon
    if (drawPolygon()) {
      int index = 0;
      Iterator<Map.Entry<String, Track>> iterator = reversedTracks.iterator();
      while(iterator.hasNext()) {
        Track track = iterator.next().getValue();
        int[] steps = track.computedSteps.clone();
        if (track.steps == 0) {
          continue;
        }
        float radius = screenHeight / (activeTracksCount + 1) * (activeTracksCount-index);
        noStroke();
        fill(track.trackColor);
        beginShape();
        float angle = TWO_PI / (float)track.steps;
        for(int j = 0; j < steps.length; j++) {
          int stepVelocity = steps[j];
          if (stepVelocity != 0) {
            float x = radius/2 * sin(angle*j) + screenHeight/2;
            float y = radius/2 * -cos(angle*j) + screenHeight/2;
            vertex(x,y);
          }
        }
        endShape();
        noFill();
        noStroke();
        index++;
      }
    }
    
    ellipseMode(CENTER);
    noFill();
    int index = 1;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Map.Entry<String, Track> entry = iterator.next();
      int[] steps = entry.getValue().computedSteps.clone();
      int trackLength = entry.getValue().steps;
      if (trackLength == 0) {
        continue;
      }
      // Draw track circle
      float radius = screenHeight / (activeTracksCount + 1) * index;
      noFill();
      if (drawCircle()) {
        strokeWeight(24);
        stroke(entry.getValue().trackColor, 64);
        ellipse(screenHeight/2, screenHeight/2, radius, radius);
        noStroke();
      }      
      // Draw track steps
      if (drawSteps()) {
        float angle = TWO_PI / (float)trackLength;
        int currentStepIndex = tick % trackLength;
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
            size = 16; 
          } else {
            if (stepVelocity == 127) {
              size = 14; 
            } else {
              size = 10;
            }
          }
          // Draw radius
          //if (drawRadius && stepVelocity != 0) {
          //  stroke(entry.getValue().trackColor, 64);
          //  strokeWeight(size/2);
          //  line(screenHeight/2, screenHeight/2, x, y);
          //  noStroke();
          //}
          // Draw step
          fill(stepColor);
          ellipse(x, y, size, size);
        }
      }
      index++;
    }
    
    drawLFO();
  }
  
  void drawLFO() {
    if (isEditingTrackId != "") {
      Track track = tracks.get(isEditingTrackId);
      stroke(track.trackColor);
      strokeWeight(2);
      int x = (int)screenWidth - 300;
      int y = (int)screenHeight/4;
      int lineSpacing = 4;
      float period = 300.0 / 127.0 * track.lfoPeriod;
      double degrees = (double)((tick % track.lfoPeriod) * 360 / track.lfoPeriod);
      float a = (float)Math.toRadians(degrees);
      float increment = TWO_PI/period * lineSpacing;
      int amp = track.lfoAmount * 2;
      for (int i = 0; i < 300; i = i + lineSpacing) {
        line(x+i, y, x+i, y + -sin(a) * amp);
        a = a + increment;
      }
      noStroke();
    }
  }

  @ Override
  void tick() {
    if (!isPlaying) { return; }
    tick++;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      if (track.steps < 1 || track.isMuted) { continue; }
      if (isSoloing && track.isSolo == false) { continue; }
      int[] steps = track.computedSteps;
      int index = tick % track.steps;
      int velocity = steps[index];
      if (velocity > 0) {
        if (track.lfoAmount > 0) {
          double degrees = (double)((tick % track.lfoPeriod) * 360 / track.lfoPeriod);
          double radians = Math.toRadians(degrees);
          int modifier = (int)(Math.sin(radians) * track.lfoAmount);
          velocity = velocity + modifier;
          if (velocity > 127) {
            velocity = 127;
          }
        }
        
        midiBus.sendNoteOn(track.channel, track.note, velocity);
        midiBus.sendNoteOff(track.channel, track.note, velocity);
        
        if (isEditingTrackId == "") {
          midiBus.sendNoteOn(0, track.controllerLightNote + 2, 127); // blink track light
        }
      }
    }
  }
  
  @Override 
  void tock() {
    if (isEditingTrackId == "") {
      turnOffBeatLights();
    }
  }
  
  @Override 
  void pulse() {
    if (!isPlaying) { return; }
    pulse++;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      if (!track.isMuted && track.isRolling && pulse % track.rollPeriod == 0) {
        midiBus.sendNoteOn(track.channel, track.note, track.normalVelocity);
        midiBus.sendNoteOff(track.channel, track.note, track.normalVelocity);
      }
    }
  }
  
  private void turnOffBeatLights() {
    midiBus.sendNoteOn(0, 3, 0);
    midiBus.sendNoteOn(0, 6, 0);
    midiBus.sendNoteOn(0, 9, 0);
    midiBus.sendNoteOn(0, 12, 0);
    midiBus.sendNoteOn(0, 15, 0);
    midiBus.sendNoteOn(0, 18, 0);
    midiBus.sendNoteOn(0, 21, 0);
    midiBus.sendNoteOn(0, 24, 0);
  }
  
  private void turnOnBeatLightFor(String id) {
    midiBus.sendNoteOn(0, tracks.get(id).controllerLightNote + 2, 127);
  }
  
  // LENGTH
  
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
  
  // BEATS
  
  public void updateTrackBeats(String id, int value) {
    tracks.get(id).beats = maxSteps * value / 127; 
    tracks.get(id).computeSteps();
  }
  
  // OFFSET
  
  public void updateTrackOffset(String id, int value) {
    tracks.get(id).rotate = maxSteps * value / 127; 
    tracks.get(id).computeSteps();
  }
  
  public void incrementTrackOffset(String id) {
    if (tracks.get(id).rotate + 1 <= maxSteps) {
      tracks.get(id).rotate = tracks.get(id).rotate + 1;
      tracks.get(id).computeSteps();
    }
  }
  
  public void decrementTrackOffset(String id) {
    if (tracks.get(id).rotate - 1 >= 0) {
      tracks.get(id).rotate = tracks.get(id).rotate - 1;
      tracks.get(id).computeSteps();
    }
  }
  
  // ACCENTS
  
  public void updateTrackAccents(String id, int value) {
    tracks.get(id).accents = tracks.get(id).beats * value / 127;
    tracks.get(id).computeSteps();
  }
  
  // MUTE/SOLO
  
  public void muteTrack(String id) {
    tracks.get(id).isMuted = !tracks.get(id).isMuted;
    int velocity = tracks.get(id).isMuted ? 127 : 0;
    midiBus.sendNoteOn(0, tracks.get(id).controllerLightNote, velocity);
  }
  
  public void addSoloTrack(String id) {
    tracks.get(id).isSolo = true;
    boolean hasSoloTrack = false;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      if (iterator.next().getValue().isSolo) {
        hasSoloTrack = true;
      }
    }
    isSoloing = hasSoloTrack;
  }
  
  public void removeSoloTrack(String id) {
    tracks.get(id).isSolo = false;
    boolean hasSoloTrack = false;
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      if (iterator.next().getValue().isSolo) {
        hasSoloTrack = true;
      }
    }
    isSoloing = hasSoloTrack;
  }
  
  public void clearSoloTracks() {
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      track.isSolo = false;
    }
    isSoloing = false;
  }
  
  // ROLL
  
  public void rollTrack(String id) {
    tracks.get(id).isRolling = !tracks.get(id).isRolling;
  }
  
  // LFO
  
  public void editTrackLFO(String id) {
    if (isEditingTrackId == "") { // start editing
      isEditingTrackId = id;
      turnOffBeatLights();
      turnOnBeatLightFor(id);
    } else { // end editing
      turnOffBeatLights();
      isEditingTrackId = "";
    }
  }
  
  public void updateLFOAmount(int value) {
    if (isEditingTrackId == "") {
      return;
    } else {
      tracks.get(isEditingTrackId).lfoAmount = 27 * value / 127;
    }
  }
  
  public void updateLFOPeriod(int value) {
    if (isEditingTrackId == "") {
      return;
    } else if (value > 0) {
      tracks.get(isEditingTrackId).lfoPeriod = value; 
    }
  }
  
  // A/B
  
  public void switchToA() {
    
  }
  
  public void switchToB() {
    
  }
}
