class Label {
  String text;
  color textColor;
  float x;
  float y; 
  PFont font = createFont("PreschoolBits.ttf", 24);
  int hAlignment;
  int vAlignment;

  Label(String textIn, float xpos, float ypos, color inColor) {
    text = textIn;
    x = xpos;
    y = ypos;
    textColor = inColor;
    hAlignment = LEFT;
    vAlignment = BOTTOM;
  }
  
  Label(String textIn, float xpos, float ypos, color inColor, int inHAlignment, int inVAlignment) {
    text = textIn;
    x = xpos;
    y = ypos;
    textColor = inColor;
    hAlignment = inHAlignment;
    vAlignment = inVAlignment;
  }
  
  void draw() {
    fill(textColor);
    textAlign(hAlignment, vAlignment);
    textFont(font);
    text(text, x, y);
  }
}
