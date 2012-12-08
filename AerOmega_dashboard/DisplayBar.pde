
class displayBar {

  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // y position of slider
  int sposMin, sposMax;   // max and min values of slider

  displayBar (int xp, int yp, int sw, int sh) {
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
    
    spos = ypos + (value * (sposMax-sposMin));
    
    stroke(170);
    fill(255);
    rect(xpos, ypos, swidth, sheight + 4);
    fill(0);
    rect(xpos, ypos, swidth, spos - ypos);
    fill(180);
    noStroke();
    rect(xpos - 10, spos, swidth + 20, 5);
    fill(100);
    triangle(xpos - 10, spos + 5, xpos, spos + 5, xpos, spos + 5 + 5);
    triangle(xpos + swidth + 10, spos + swidth, xpos + swidth, spos + 5, xpos + 5, spos + 5 + 5);
    fill(140);
    rect(xpos, spos + 5, swidth, 2);
    stroke(1);
  }
}
