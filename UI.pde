import controlP5.*;

class UI {
  ControlP5 cp5;
  
  int uiWidth = 300;
  int buttonHeight = 48;
  int buttonWidth = 90;
  int padding = 15;
  
  public UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    
    cp5.addButton("PLAY").setValue(0).setPosition(screenWidth - uiWidth - padding, padding).setSize(buttonWidth, buttonHeight);
    cp5.addButton("PAUSE").setValue(0).setPosition(screenWidth - uiWidth + buttonWidth, padding).setSize(buttonWidth, buttonHeight);
    cp5.addButton("STOP").setValue(0).setPosition(screenWidth - uiWidth + buttonWidth * 2 + padding, padding).setSize(buttonWidth, buttonHeight);
  }
}
