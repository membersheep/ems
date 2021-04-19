class UI {
  int buttonHeight = 36;
  int buttonWidth = 50;
  int padding = 15;
  int uiWidth = 300;
  
  Button playButton = new Button("PLAY", padding, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button pauseButton = new Button("PAUSE", padding * 2 + buttonWidth, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button stopButton = new Button("STOP", padding * 3 + buttonWidth * 2, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button viewButton = new Button("VIEW", padding * 4 + buttonWidth * 3, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button ioButton = new Button("I/O", padding * 5 + buttonWidth * 4, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button clockButton = new Button("CLOCK: INTERNAL", padding * 6 + buttonWidth * 5, screenHeight - padding - buttonHeight, buttonWidth * 3, buttonHeight);
  Label[] trackNameLabels = setupTrackNameLabels();
  Label[] trackLabels = setupTrackLabels();

  public void draw() {
    playButton.draw();
    pauseButton.draw();
    stopButton.draw();
    viewButton.draw();
    clockButton.draw();
    ioButton.draw();
    for (int i = 0; i < trackLabels.length; i++) {
      trackNameLabels[i].draw();
      trackLabels[i].draw();
    }
  }
  
  void onTap() {
    if (playButton.mouseIsOver()) {
    } else if (pauseButton.mouseIsOver()) {
      
    } else if (stopButton.mouseIsOver()) {
      
    } else if (viewButton.mouseIsOver()) {
      
    } else if (clockButton.mouseIsOver()) {
      if (clockButton.label == "CLOCK: INTERNAL") {
        clockButton.label = "CLOCK: MIDI";
        internalClock.isActive = false;
      } else if (clockButton.label == "CLOCK: MIDI") {
        clockButton.label = "CLOCK: INTERNAL";
        internalClock.isActive = true;
      }
    } else if (ioButton.mouseIsOver()) {
      deviceManager.setupIODevices();
    }
  }
  
  private Label[] setupTrackNameLabels() {
    Label[] labels = new Label[8];
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    int index = 0;
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      String text = track.id;
      Label label = new Label(text, screenWidth - uiWidth, screenHeight - padding - padding * 2 * index, track.trackColor);
      labels[index] = label;
      index++;
    }
    return labels; 
  }
  
  private Label[] setupTrackLabels() {
    Label[] labels = new Label[8];
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    int index = 0;
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      String text = String.format("%02d", track.steps) + " - " + String.format("%02d", track.beats) + " - " + String.format("%02d", track.rotate) + " - " + String.format("%02d", track.accents);
      Label label = new Label(text, screenWidth - uiWidth + padding * 5, screenHeight - padding - padding * 2 * index, track.trackColor);
      labels[index] = label;
      index++;
    }
    return labels; 
  }
  
  public void updateTrackLabels() {
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    int index = 0;
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      Label label = trackLabels[index];
      String text = track.id + " - " + String.format("%02d", track.steps) + " - " + String.format("%02d", track.beats) + " - " + String.format("%02d", track.rotate) + " - " + String.format("%02d", track.accents);
      label.text = text;
      index++;
    }
  }
  
}
