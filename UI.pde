import controlP5.*;

class UI {
  ControlP5 cp5;
  
  int sliderHeight = 48;
  int buttonHeight = 48;
  int padding = 15;
  int uiWidth = 300 - padding;

  Group menuGroup;
  controlP5.Button controllerButton;
  controlP5.Button inputButton;
  controlP5.Button outputButton;
  controlP5.Textlabel[] trackLabels;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    trackLabels = new controlP5.Textlabel[sequencer.sortedTracks.size()];
    int buttonWidth = (uiWidth - padding * 2)/3;
    
    menuGroup = cp5.addGroup("settings")
    .setPosition(screenWidth - uiWidth - padding, padding).setWidth(uiWidth)
    .setSize(uiWidth, (int)screenHeight - padding * 2).setOpen(false);
    
    controllerButton = cp5.addButton("controller")
    .setLabel("SELECT MIDI CONTROLLER")
    .setPosition(0, padding)
    .setSize(uiWidth, buttonHeight)
    .moveTo(menuGroup);
    
    inputButton = cp5.addButton("input")
    .setLabel("MIDI CLOCK SOURCE: INTERNAL")
    .setPosition(0, padding * 2 + sliderHeight)
    .setSize(uiWidth, buttonHeight)
    .moveTo(menuGroup);
    
    outputButton = cp5.addButton("output")
    .setLabel("SELECT MIDI OUTPUT")
    .setPosition(0, padding * 3 + sliderHeight * 2)
    .setSize(uiWidth, buttonHeight)
    .moveTo(menuGroup);
    
    cp5.addSlider("bpm").setSliderMode(Slider.FLEXIBLE)
    .setPosition(0, padding * 4 + sliderHeight * 3)
    .setWidth(uiWidth - 20).setHeight(sliderHeight)
    .setRange(0, 480).setValue(120)
    .moveTo(menuGroup);
    
    cp5.addRadioButton("division").setItemsPerRow(4).addItem("/1", 1).addItem("/2", 2).addItem("/3", 3).addItem("/4", 4)
    .setSpacingColumn(padding*2)
    .setPosition(0, padding * 5 + sliderHeight * 4)
    .setSize(sliderHeight, sliderHeight)
    .moveTo(menuGroup);
    
    cp5.addButton("play").setValue(0)
    .setPosition(screenWidth - uiWidth - padding, screenHeight - padding - buttonHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addButton("pause").setValue(0)
    .setPosition(screenWidth - uiWidth - padding + buttonWidth + padding, screenHeight - padding - buttonHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addButton("stop").setValue(0)
    .setPosition(screenWidth - uiWidth - padding + buttonWidth * 2 + padding * 2, screenHeight - padding - buttonHeight)
    .setSize(buttonWidth, buttonHeight);
    
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    int index = 0;
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      controlP5.Textlabel trackLabel = cp5
      .addLabel(track.id)
      .setText("TRACK " + track.id + "     steps     " + track.steps + "     beats     " + track.beats + "     rotation     " + track.rotate)
      .setColor(track.trackColor)
      .setPosition(screenWidth - uiWidth - padding, screenHeight - padding - buttonHeight - padding - padding * index);
      trackLabels[index] = trackLabel;
      index++;
    }
  }
  
  public void updateTrackLabels() {
    Iterator<Map.Entry<String, Track>> iterator = sequencer.sortedTracks.iterator();
    while (iterator.hasNext()) {
      Track track = iterator.next().getValue();
      controlP5.Textlabel trackLabel = (controlP5.Textlabel)cp5.getController(track.id);
      trackLabel.setText("TRACK " + track.id + "     steps     " + track.steps + "     beats     " + track.beats + "     rotation     " + track.rotate);
    }
  }
  
}
