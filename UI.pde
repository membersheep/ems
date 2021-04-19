class UI {
  int buttonHeight = 36;
  int buttonWidth = 50;
  int padding = 15;
  int uiWidth = 300;
  
  Button playButton = new Button("PLAY", padding, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button pauseButton = new Button("PAUSE", padding * 2 + buttonWidth, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button stopButton = new Button("STOP", padding * 3 + buttonWidth * 2, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button circleButton = new Button("C", padding * 4 + buttonWidth * 3, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button radialButton = new Button("R", padding * 5 + buttonWidth * 4, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button polygonalButton = new Button("P", padding * 6 + buttonWidth * 5, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Button ioButton = new Button("I/O", padding * 7 + buttonWidth * 6, screenHeight - padding - buttonHeight, buttonWidth, buttonHeight);
  Label[] trackNameLabels = setupTrackNameLabels();
  Label[] trackLabels = setupTrackLabels();

  public void draw() {
    playButton.draw();
    pauseButton.draw();
    stopButton.draw();
    circleButton.draw();
    radialButton.draw();
    polygonalButton.draw();
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
      
    } else if (circleButton.mouseIsOver()) {
      
    } else if (radialButton.mouseIsOver()) {
      
    } else if (polygonalButton.mouseIsOver()) {
      
    } else if (ioButton.mouseIsOver()) {
      
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
