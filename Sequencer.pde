import themidibus.*;

class Sequencer implements ClockListener {
  Map<String, Track> tracks = new HashMap<String, Track>();
  LinkedList<Map.Entry<String, Track>> sortedTracks;
  int midiChannel = 0;
  MidiBus midiBus;
  
  public Sequencer() {
    midiBus = new MidiBus(this, 0, 0);
    tracks.put("1", new Track("1", 60, 16, 4, 0, Color.RED.getRGB()));
    tracks.put("2", new Track("2", 61, 8, 0, 0, Color.GREEN.getRGB()));
    tracks.put("3", new Track("3", 62, 8, 0, 0, Color.YELLOW.getRGB()));
    tracks.put("4", new Track("4", 63, 4, 0, 0, Color.BLUE.getRGB()));
    sortedTracks = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
    sortTracks();
  }
  
  public void sortTracks() {
    LinkedList<Map.Entry<String, Track>> list = new LinkedList<Map.Entry<String, Track>>(tracks.entrySet());
    Collections.sort(list, new Comparator<Map.Entry<String, Track>>() {
        @Override
        public int compare(Map.Entry<String, Track> o1, Map.Entry<String, Track> o2) {
           return o1.getValue().steps - o2.getValue().steps;      
        }
    });
    sortedTracks = list;
  }
  
  void drawTracks() {
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
      int trackLength = entry.getValue().steps;
      if (trackLength == 0) {
        continue;
      }
      float angle = TWO_PI / (float)trackLength;
      int currentStepIndex = clock.tick % trackLength;
      int[] steps = entry.getValue().computedSteps;
      for(int i = 0; i < trackLength; i++) {
        int stepVelocity = steps[i];
        color stepColor;
        if (i == currentStepIndex) {
          stepColor = Color.WHITE.getRGB();
        } else {
          stepColor = entry.getValue().trackColor;
        }
        if (stepVelocity == 0) {
          noFill();
          stroke(stepColor);
          stepVelocity = 100;
        } else {
          fill(stepColor);
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

  @ Override
  void tick(int tick) {
    println(tick);
    // send midi messages basing on track ticks
    Iterator<Map.Entry<String, Track>> iterator = sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      int[] steps = track.computedSteps;
      int index = tick % steps.length;
      int velocity = steps[index];
      if (velocity > 0) {
        print("PLAY " );
        print(track.id);
        println(" " );
        midiBus.sendNoteOn(midiChannel, track.note, velocity);
      }
    }
  }
}
