import controlP5.*;

class UI {
  ControlP5 cp5;
  
  int uiWidth = 300;
  int buttonHeight = 48;
  int buttonWidth = 90;
  int padding = 15;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    
    cp5.addSlider("bpm").setPosition(screenWidth - uiWidth - padding, padding).setWidth(uiWidth - 20).setHeight(24).setRange(0, 480).setValue(60);

    cp5.addButton("play").setValue(0).setPosition(screenWidth - uiWidth - padding, padding * 4).setSize(buttonWidth, buttonHeight);
    cp5.addButton("pause").setValue(0).setPosition(screenWidth - uiWidth + buttonWidth, padding * 4).setSize(buttonWidth, buttonHeight);
    cp5.addButton("stop").setValue(0).setPosition(screenWidth - uiWidth + buttonWidth * 2 + padding, padding * 4).setSize(buttonWidth, buttonHeight);
  }
}
