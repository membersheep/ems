import controlP5.*;

class UI {
  ControlP5 cp5;
  
  int uiWidth = 300;
  int sliderHeight = 48;
  int buttonHeight = 48;
  int buttonWidth = 90;
  int padding = 15;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    
    cp5.addButton("controller")
    .setPosition(screenWidth - uiWidth - padding, padding)
    .setSize(buttonWidth, buttonHeight);
    cp5.addTextlabel("controllerLabel", MidiBus.availableInputs()[0], (int)screenWidth - uiWidth - padding + buttonWidth, padding + buttonHeight/2 );
    
    cp5.addButton("input")
    .setPosition(screenWidth - uiWidth - padding, padding * 2 + sliderHeight)
    .setSize(buttonWidth, buttonHeight);
    cp5.addTextlabel("inputLabel", MidiBus.availableInputs()[0], (int)screenWidth - uiWidth - padding + buttonWidth, padding * 2 + buttonHeight * 3/2 );
    
    cp5.addButton("output")
    .setPosition(screenWidth - uiWidth - padding, padding * 3 + sliderHeight * 2)
    .setSize(buttonWidth, buttonHeight);
    cp5.addTextlabel("outputLabel", MidiBus.availableOutputs()[0], (int)screenWidth - uiWidth - padding + buttonWidth, padding * 3 + buttonHeight * 5/2 );
    
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
