
class DisplayBar {

  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // y position of slider
  int sposMin, sposMax;   // max and min values of slider

  DisplayBar (int xp, int yp, int sw, int sh) {
    swidth = sw;
    sheight = sh;
    int heighttowidth = sh - sw;
    xpos = xp-swidth/2;
    ypos = yp;
    spos = ypos + sheight - swidth;
    newspos = spos;
    sposMin = ypos;
    sposMax = ypos + sheight - swidth;
  }

  void update(float value) {
    
    spos = (ypos + (-value/100) * (sposMax-sposMin)) + (sposMax-sposMin);
    
    strokeWeight(1);
    stroke(170);
    fill(255);
    rect(xpos, ypos, swidth, sheight + 4);
    fill(0);
    rect(xpos, ypos, swidth, spos - ypos);
    fill(180);
    noStroke();
    rect(xpos - 10, spos, swidth + 20, 5);
    fill(100);
    triangle(xpos - 10, spos + 4, xpos, spos + 4, xpos, spos + 10);
    triangle(xpos + swidth + 10, spos + 4, xpos + swidth + 1, spos + 4, xpos + swidth + 1, spos + 10);
    fill(140);
    rect(xpos, spos + 5, swidth + 1, 2);
    stroke(1);
  }
}
