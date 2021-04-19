class Label {
  String text;
  color textColor;
  float x;
  float y; 
  PFont font = createFont("PreschoolBits.ttf", 24);

  Label(String textIn, float xpos, float ypos, color inColor) {
    text = textIn;
    x = xpos;
    y = ypos;
    textColor = inColor;
  }
  
  void draw() {
    fill(textColor);
    textAlign(LEFT, BOTTOM);
    textFont(font);
    text(text, x, y);
  }
}
