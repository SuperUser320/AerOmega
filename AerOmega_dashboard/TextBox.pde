class TextBox {

  int x, y, w, h;
  String label;
  String inputText;
  
  boolean selectable;
  boolean fitText;
  
  boolean enabled = false;
  boolean locked = false;
  boolean pressed = false;
  boolean selected = false;
  boolean hover = false;
  boolean hasBeenPressed = false;
  boolean pressOriginInside = false;
  boolean lastPressed = false;
  boolean lastMouse = false;
  
  boolean charAdded = false;

  TextBox(int tx, int ty, int tw, int th, boolean tselectable, String tlabel) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
    selectable = tselectable;
    label = tlabel;
  }
  
  TextBox(int tx, int ty, boolean tselectable, String tlabel) {
    x = tx;
    y = ty;
    selectable = tselectable;
    fitText = true;
    label = tlabel;
  }
  
  void update(String input) {
    if (selectable) {
      //mousePressed in text box
      if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && !locked) {
        if (mousePressed) {
          pressed = true;
          hover = false;
        } 
        else {
          hover = true;
          pressed = false;
        }
      } 
      else {
        hover = false;
        pressed = false;
      }
      
      //mouseDown in button
      if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && !locked && lastPressed == false && pressed == true && lastMouse == false && mousePressed) {
        pressOriginInside = true;
      } else if (!(mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) && !locked && lastPressed == false && pressed == true && lastMouse == false && mousePressed) {
        pressOriginInside = false;
      }
      
      //mouseReleased in button
      if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && !locked && lastPressed == true && pressed == false && pressOriginInside) {
        hasBeenPressed = true;
      } else {
        hasBeenPressed = false;
      }
      
      lastPressed = pressed;
      lastMouse = mousePressed;
      
      //Handle selection
      if (pressed) {
        selected = true;
      } else if (mousePressed) {
        selected = false;
      }
      
      if (!keyDown) {
        charAdded = false;
      }
    }
    
    //Handle typing
      if (selected && !charAdded && keyDown) {
      if (key == '.' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
        inputText += key;
      }
      charAdded = true;
    } else if (!selected) {
      inputText = input;
    }
    
    drawTextBox();
  }
  
  private void drawTextBox() {
    
      textFont(SegoeUI);
      if(fitText) {
        //Calculate width and height
        w = int(textWidth(inputText));
        h = 20;
      }
      //Draw box
      strokeWeight(1);
      stroke(200);
      fill(50);
      if (w == 0) {
        w = int(textWidth(inputText) + 10);
      }
      rect(x - 4, y , w + 6, h);
      fill(255);
      text(label, x - textWidth(label) - 5, y + h - 2);
      text(inputText, x + w - int(textWidth(inputText)), y + h - 2);
  }
}

