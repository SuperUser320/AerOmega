class VScrollbar {

  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // y position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  TextBox textBox;
  
  VScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int heighttowidth = sh - sw;
    ratio = (float)sh / (float)heighttowidth;
    xpos = xp-swidth/2;
    ypos = yp;
    spos = ypos + sheight - swidth;
    newspos = spos;
    sposMin = ypos;
    sposMax = ypos + sheight - swidth;
    loose = l;
    
    textBox = new TextBox(xpos - (int(textWidth("100.0")) + 20)/2 + swidth/2, ypos + sheight + 15, int(textWidth("100.0")) + 20, 20, false);
  }

  void update() {
    if (over()) {
      over = true;
    } else {
      over = false;
    }
    
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseY-swidth/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if (mouseX > xpos - 10 && mouseX < xpos+swidth+10 &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display(String label) {
    this.update();
    ///////////////////////////
    // Draw background boxes //
    ///////////////////////////
    stroke(170);
    
    //"Filled" background box
    fill(255);
    rect(xpos, ypos, swidth, sheight + 4);
    //"Empty" background box
    fill(0);
    rect(xpos, ypos, swidth, spos - ypos);
    
    /////////////////
    // Draw handle //
    /////////////////
    if (over || locked) {
      fill(160);
    } else {
      fill(180);
    }
    noStroke();
    rect(xpos - 10, spos, swidth + 20, swidth);
    
    if (over || locked) {
      fill(80);
    } 
    else {
      fill(100);
    }
    fill(100);
    triangle(xpos - 10, spos + swidth, xpos, spos + swidth, xpos, spos + swidth + 5);
    triangle(xpos + swidth + 10, spos + swidth, xpos + swidth, spos + swidth, xpos + swidth, spos + swidth + 5);
    fill(140);
    rect(xpos, spos + swidth, swidth, 2);
    stroke(1);
    
    fill(255);
    text(label, textBox.x - int(textWidth(label)), textBox.y + textBox.h - 2);
    textBox.update(Float.toString(truncate(100 - (((spos - ypos)/(sposMax-sposMin)) * 100), 1)));
  }

  float getPos() {
    return 100 - (((spos - ypos)/(sposMax-sposMin)) * 100);
  }
}

