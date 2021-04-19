class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  PFont font = createFont("PreschoolBits.ttf", 16);
  
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  
  void draw() {
    fill(255);
    rect(x, y, w, h);
    textAlign(CENTER, CENTER);
    fill(0);
    textFont(font);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  boolean mouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
