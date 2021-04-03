import controlP5.*;

class UI {
  ControlP5 cp5;
  
  int uiWidth = 300;
  int sliderHeight = 48;
  int buttonHeight = 48;
  int buttonWidth = 90;
  int padding = 15;
  
  controlP5.Button controllerButton;
  controlP5.Button inputButton;
  controlP5.Button outputButton;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    
    controllerButton = cp5.addButton("controller")
    .setLabel("SELECT MIDI CONTROLLER")
    .setPosition(screenWidth - uiWidth - padding, padding)
    .setSize(uiWidth, buttonHeight);
    
    inputButton = cp5.addButton("input")
    .setLabel("SELECT MIDI CLOCK SOURCE")
    .setPosition(screenWidth - uiWidth - padding, padding * 2 + sliderHeight)
    .setSize(uiWidth, buttonHeight);
    
    outputButton = cp5.addButton("output")
    .setLabel("SELECT MIDI OUTPUT")
    .setPosition(screenWidth - uiWidth - padding, padding * 3 + sliderHeight * 2)
    .setSize(uiWidth, buttonHeight);
    
    cp5.addSlider("bpm").setSliderMode(Slider.FLEXIBLE)
    .setPosition(screenWidth - uiWidth - padding, padding * 4 + sliderHeight * 3)
    .setWidth(uiWidth - 20).setHeight(sliderHeight)
    .setRange(0, 480).setValue(120);
    
    cp5.addRadioButton("division").setItemsPerRow(4).addItem("/1", 1).addItem("/2", 2).addItem("/3", 3).addItem("/4", 4)
    .setSpacingColumn(padding*2)
    .setPosition(screenWidth - uiWidth - padding, padding * 5 + sliderHeight * 4)
    .setSize(sliderHeight, sliderHeight);
    
    cp5.addButton("play").setValue(0)
    .setPosition(screenWidth - uiWidth - padding, screenHeight - padding - sliderHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addButton("pause").setValue(0)
    .setPosition(screenWidth - uiWidth + buttonWidth, screenHeight - padding - sliderHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addButton("stop").setValue(0)
    .setPosition(screenWidth - uiWidth + buttonWidth * 2 + padding, screenHeight - padding - sliderHeight)
    .setSize(buttonWidth, buttonHeight);
  }
}
