import controlP5.*;

class UI {
  ControlP5 cp5;
  
  int sliderHeight = 48;
  int buttonHeight = 48;
  int buttonWidth = 90;
  int padding = 15;
  int uiWidth = 300-padding;

  Group menuGroup;
  controlP5.Button controllerButton;
  controlP5.Button inputButton;
  controlP5.Button outputButton;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    menuGroup = cp5.addGroup("menu")
    .setPosition(screenWidth - uiWidth - padding, padding).setWidth(uiWidth)
    .setSize(uiWidth, (int)screenHeight);
    
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
    .setPosition(0, screenHeight - padding - sliderHeight)
    .setSize(buttonWidth, buttonHeight)
    .moveTo(menuGroup);
    cp5.addButton("pause").setValue(0)
    .setPosition(0, screenHeight - padding - sliderHeight)
    .setSize(buttonWidth, buttonHeight)
    .moveTo(menuGroup);
    cp5.addButton("stop").setValue(0)
    .setPosition(0, screenHeight - padding - sliderHeight)
    .setSize(buttonWidth, buttonHeight)
    .moveTo(menuGroup);
  }
}
