class Button {

  int x, y, buttonWidth, buttonHeight;
  
  color pressedColor = color(100);
  color releasedColor = color(200);
  color hoverColor = color(150);
  color lockedColor = color(80);
  color warningPressedColor = color(150,45,45);
  color warningReleasedColor = color(215,60,60);
  color warningHoverColor = color(200,45,45);
  color warningLockedColor = color(80,45,45);
  color pressedTextColor = color(155);
  color releasedTextColor = color(255);
  color hoverTextColor = color(205);
  color lockedTextColor = color(135);
  
  color textColor;
  color buttonColor;
  
  boolean locked = false;
  boolean pressed = false;
  boolean hover = false;
  
  String buttonText;
  String lockedText;

  boolean warningButton;

  Button (int tx, int ty, int twidth, int theight, String ttext, boolean twarningButton) {
    x = tx;
    y = ty;
    buttonWidth = twidth;
    buttonHeight = theight;
    warningButton = twarningButton;
    buttonText = ttext;
  }
  
  Button (int tx, int ty, int twidth, int theight, String ttext, boolean twarningButton, String tlockText) {
    x = tx;
    y = ty;
    buttonWidth = twidth;
    buttonHeight = theight;
    warningButton = twarningButton;
    buttonText = ttext;
    lockedText = tlockText;
  }

  void drawButton() {
    stroke(0);
    if (warningButton) {
      if (locked) {
        buttonColor = warningLockedColor;
        textColor = lockedTextColor;
      } 
      else if (hover) {
        buttonColor = warningHoverColor;
        textColor = hoverTextColor;
      } 
      else if (pressed) {
        buttonColor = warningPressedColor;
        textColor = pressedTextColor;
      } 
      else {
        buttonColor = warningReleasedColor;
        textColor = releasedColor;
      }
    } else {
      if (locked) {
        buttonColor = lockedColor;
        textColor = lockedTextColor;
      } 
      else if (hover) {
        buttonColor = hoverColor;
        textColor = hoverTextColor;
      } 
      else if (pressed) {
        buttonColor = pressedColor;
        textColor = pressedTextColor;
      } 
      else {
        buttonColor = releasedColor;
        textColor = releasedTextColor;
      }
    }
    
    fill(buttonColor);
    rect(x, y, buttonWidth, buttonHeight);
    
    fill(textColor);
    if (locked) {
      text(lockedText, x + (buttonWidth / 2) - (textWidth(lockedText) / 2), y + (buttonHeight / 2) + 7);
    } else {
      text(buttonText, x + (buttonWidth / 2) - (textWidth(buttonText) / 2), y + (buttonHeight / 2) + 7);
    }
  }

  void update() {
    if (mouseX > x && mouseX < (x + buttonWidth) && mouseY > y && mouseY < (y + buttonHeight) && !locked) {
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
    drawButton();
  }

  boolean buttonPressed() {
    if (pressed) {
      return true;
    } 
    else {
      return false;
    }
  }

  void lock(boolean lockButton) {
    locked = lockButton;
    pressed = false;
  }
}

