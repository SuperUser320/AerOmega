import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class AerOmega_dashboard extends PApplet {



Serial arduino;
//// GUI elements ////
VScrollbar throttleBar1;
VScrollbar throttleBar2;
VScrollbar throttleBar3;
VScrollbar throttleBar4;

DisplayBar throttleOut1;
DisplayBar throttleOut2;
DisplayBar throttleOut3;
DisplayBar throttleOut4;

Gimbal xGimbal;
Gimbal yGimbal;
Gimbal zGimbal;

Button initButton;

PFont BankGothic;
PFont SegoeUI;
PFont SegoeUITitle;
PFont SegoeUISubTitle;

//// GUI variables ////
boolean dispQuad = false;

//// transmission variables ////
int loopCount = 0;
int updateFreq = 100;

//// control output variables ////
int throttle;
boolean init = false;

//// dashboard data ////
float xAng = 12;
float yAng = -43;
float zAng = 146;

float mt1 = 352;
float mt2 = 532;
float mt3 = 932;
float mt4 = 164;

boolean dataRecieved;

//// parsing variables ////
int dataIndex;
char readChar = ' ';
String tmpStr;

public void setup() {
  size(1280, 800);
  BankGothic = loadFont("BankGothicBT-Light-24.vlw");
  SegoeUITitle = loadFont("SegoeUI-Light-72.vlw");
  SegoeUISubTitle = loadFont("SegoeUI-Light-48.vlw");
  SegoeUI = loadFont("SegoeUI-20.vlw");
  //textFont(BankGothic);
  println(Serial.list());

  //// GUI ELEMENTS ////
  throttleBar1 = new VScrollbar(550, 500, 30, 220, 1);
  throttleBar2 = new VScrollbar(650, 500, 30, 220, 1);
  throttleBar3 = new VScrollbar(750, 500, 30, 220, 1);
  throttleBar4 = new VScrollbar(850, 500, 30, 220, 1);
  
  throttleOut1 = new DisplayBar(80, 500, 30, 220);
  throttleOut2 = new DisplayBar(180, 500, 30, 220);
  throttleOut3 = new DisplayBar(280, 500, 30, 220);
  throttleOut4 = new DisplayBar(380, 500, 30, 220);
  
  xGimbal = new Gimbal(135, 265, 175, false);
  yGimbal = new Gimbal(355, 265, 175, false);
  zGimbal = new Gimbal(575, 265, 175, true);
  
  
  initButton = new Button(975, 720, 260, 35, "INIT QUADROTOR", true, "QUAD ARMED");

  //// ARDUINO ////
  //arduino = new Serial(this, Serial.list()[1], 57600);
  delay(10);
}

public void draw() {
  drawBackground();
  fill(255);

  //displaySignal();

  displayControls();
  displayAngleData();
  displayMotorData();

  //Send data back at the same speed
  //sendData();
}

public void drawBackground() {
  background(35);
  noFill();
  strokeWeight(4);
  stroke(0);
  rect(0,0,width, height);
  stroke(25);
  fill(30);
  rect(20, 100, width - 40, height - 120);
  strokeWeight(1);
  
  fill(255);
  textFont(SegoeUITitle);
  text("Aer\u2126mega | V0.1", 20, 70);
  
  textFont(SegoeUISubTitle);
  text("Attitude Values", 40, 150);
  text("PID Corrections", 725, 150);
  text("Motor Values", 40, 480);
  text("Controls", 500, 480);
  
  textFont(SegoeUI);
}

public void displayControls() {

  //Main throttle slider
  fill(255);
  text("MT1: " + PApplet.parseInt(throttleBar1.getPos()), 510, height - 40);
  throttleBar1.update();
  throttleBar1.display();

  fill(255);
  text("MT2: " + PApplet.parseInt(throttleBar2.getPos()), 610, height - 40);
  throttleBar2.update();
  throttleBar2.display();
  
  fill(255);
  text("MT3: " + PApplet.parseInt(throttleBar3.getPos()), 710, height - 40);
  throttleBar3.update();
  throttleBar3.display();
  
  fill(255);
  text("MT4: " + PApplet.parseInt(throttleBar4.getPos()), 810, height - 40);
  throttleBar4.update();
  throttleBar4.display();
  //Quadrotor init button
  initButton.update();
  if (initButton.buttonPressed()) {
    arduino.write("1,1,1,1");
    initButton.lock(true);
  }
}

public void displayAngleData() {
  //Angles
  text("xAng: " + xAng, 90, 415);
  text("yAng: " + yAng, 310, 415);
  text("zAng: " + zAng, 530, 415);
  
  xGimbal.update(xAng);
  yGimbal.update(yAng);
  zGimbal.update(zAng);
}

public void displayMotorData() {
  //Motor Throttles

  if (dispQuad) {

    stroke(255);
    strokeWeight(5);
    line(200, 180, 335, 315);
    line(200, 315, 335, 180);
    stroke(0);
    strokeWeight(1);
    fill(100, 200, 255);
    rect(245, 225, 45, 45);
    fill(50, 150, 205);
    arc(200, 180, 60, 60, 0, ((mt1 - 999)/1000) * TWO_PI);
    //line(180, 180, );
    arc(335, 180, 60, 60, 0, ((mt2 - 999)/1000) * TWO_PI);
    arc(200, 315, 60, 60, 0, ((mt3 - 999)/1000) * TWO_PI);
    arc(335, 315, 60, 60, 0, ((mt4 - 999)/1000) * TWO_PI);
  } 
  else {
    float mo1 = truncate(mt1, 2);
    float mo2 = truncate(mt2, 2);
    float mo3 = truncate(mt3, 2);
    float mo4 = truncate(mt4, 2);
    
    throttleOut1.update(mo1/10);
    throttleOut2.update(mo2/10);
    throttleOut3.update(mo3/10);
    throttleOut4.update(mo4/10);
    
    fill(255);
    text("M1: " + mo1, 30, height - 40);
    text("M2: " + mo2, 130, height - 40);
    text("M3: " + mo3, 230, height - 40);
    text("M4: " + mo4, 330, height - 40);
  }
}

public void displaySignal() {
  if (dataRecieved && loopCount < updateFreq) {
    
    loopCount++;
    
  } else {
    loopCount = 0;
    if (arduino.available() > 0) {
      fill(0, 255, 0);
      dataRecieved = true;
      println("blah");
    } else {
      fill(215, 60, 60);
      dataRecieved = false;
    }
  }
  rect(width - 50, 10, 40, 40);
}


public void serialEvent(Serial arduino) {
  
  // only run if imu data is available else idle or parse data // make main cpu request data later //
  if (arduino.available() > 0) {
    readChar = PApplet.parseChar(arduino.read());
    // start looking for data after '\n' //
    if (readChar == '\n') {
      dataIndex = 0;
      readChar = ' ';
      storeVal();
      tmpStr = "";
    }
    // look for new data after ':'s //
    if (readChar == ':') {
      dataIndex++;
      readChar = ' ';
      tmpStr = "";
    }
    if (readChar == ',') {
      readChar = ' ';
      storeVal();
      tmpStr = "";
    }
    // throw away data after index of 2 //
    if (dataIndex < 11 || readChar == ' ') {
      tmpStr += readChar;
    }
  }
}

//// Store values read from IMU ////
public void storeVal() {
  switch(dataIndex - 1) {
  case 0:

    yAng = PApplet.parseFloat(tmpStr);     // x and y axies are switched //

    break;

  case 1:

    xAng = PApplet.parseFloat(tmpStr);

    break;

  case 2:

    zAng = PApplet.parseFloat(tmpStr);

    break;

  case 3:

    mt1 = PApplet.parseFloat(tmpStr);

    break;

  case 4:

    mt2 = PApplet.parseFloat(tmpStr);

    break;

  case 5:

    mt3 = PApplet.parseFloat(tmpStr);

    break;

  case 6:

    mt4 = PApplet.parseFloat(tmpStr);

    break;
  }
}

public void sendData()
{
  arduino.write("DAT:" + ((10 * throttle) + 1000) + ",");
}

class Button {

  int x, y, buttonWidth, buttonHeight;

  int pressedColor = color(100);
  int releasedColor = color(200);
  int hoverColor = color(150);
  int lockedColor = color(80);
  int warningPressedColor = color(150, 45, 45);
  int warningReleasedColor = color(215, 60, 60);
  int warningHoverColor = color(200, 45, 45);
  int warningLockedColor = color(80, 45, 45);
  int pressedTextColor = color(155);
  int releasedTextColor = color(255);
  int hoverTextColor = color(205);
  int lockedTextColor = color(135);

  int textColor;
  int buttonColor;

  boolean locked = false;
  boolean pressed = false;
  boolean hover = false;
  boolean hasBeenPressed = false;
  boolean pressOriginInside = false;
  boolean lastPressed = false;
  boolean lastMouse = false;

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

  public void drawButton() {
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
    } 
    else {
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
    } 
    else {
      text(buttonText, x + (buttonWidth / 2) - (textWidth(buttonText) / 2), y + (buttonHeight / 2) + 7);
    }
  }

  public void update() {
    //mousePressed in button
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
    
    //mouseDown in button
    if (mouseX > x && mouseX < (x + buttonWidth) && mouseY > y && mouseY < (y + buttonHeight) && !locked && lastPressed == false && pressed == true && lastMouse == false && mousePressed) {
      pressOriginInside = true;
    } else if (!(mouseX > x && mouseX < (x + buttonWidth) && mouseY > y && mouseY < (y + buttonHeight)) && !locked && lastPressed == false && pressed == true && lastMouse == false && mousePressed) {
      pressOriginInside = false;
    }
    
    //mouseReleased in button
    if (mouseX > x && mouseX < (x + buttonWidth) && mouseY > y && mouseY < (y + buttonHeight) && !locked && lastPressed == true && pressed == false && pressOriginInside) {
      hasBeenPressed = true;
    } else {
      hasBeenPressed = false;
    }
    
    drawButton();
    lastPressed = pressed;
    lastMouse = mousePressed;
  }

  public boolean buttonPressed() {
    if (hasBeenPressed) {
      //hasBeenPressed = false;
      return true;
    } else {
      //hasBeenPressed = false;
      return false;
    }
  }

  public void lock(boolean lockButton) {
    locked = lockButton;
    pressed = false;
  }
}


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

  public void update(float value) {
    
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
class Gimbal {

  int x, y, size;
  float angle = 0;
  boolean isCompass;

  Gimbal (int tx, int ty, int tsize, boolean tisCompass) {
    x = tx;
    y = ty;
    size = tsize;
    isCompass = tisCompass;
  }

  public void update(float inAngle) {
    angle = (float) ((inAngle * Math.PI) / 180);

    strokeWeight(4);
    stroke(100);
    fill(200);
    ellipse(x, y, size, size);

    if (!isCompass) {
      
      noStroke();
      fill(25);
      arc(x, y, size * .99f, size * .99f, 0, PI);
      
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(angle);
      stroke(180);
      fill(180);
      triangle(-size * 0.6f, 0, 0, -size/10, size * 0.6f, 0);
      stroke(50);
      fill(50);
      triangle(-size * 0.6f, 0, 0, size/10, size * 0.6f, 0);
      popMatrix();
      
    } else {
      
      textFont(SegoeUI);
      text("N", x - (textWidth("N") / 2), y - (size/2) - (size * 0.1f));
      text("S", x - (textWidth("S") / 2), y + (size/2) + (size * 0.2f));
      
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(angle);
      stroke(175);
      fill(175);
      triangle(-size/15, 0, 0, size * 0.6f, size/15, 0);
      stroke(85);
      fill(85);
      triangle(-size/15, 0, 0, -size * 0.6f, size/15, 0);
      stroke(175);
      fill(175);
      triangle(-size/15, 0, 0, -size * 0.05f, size/15, 0);
      popMatrix();
    }
  }
}

class VScrollbar {

  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // y position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

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
  }

  public void update() {
    if (over()) {
      over = true;
    } 
    else {
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

  public int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  public boolean over() {
    if (mouseX > xpos - 10 && mouseX < xpos+swidth+10 &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }

  public void display() {
    stroke(170);
    fill(255);
    rect(xpos, ypos, swidth, sheight + 4);
    fill(0);
    rect(xpos, ypos, swidth, spos - ypos);
    if (over || locked) {
      fill(160);
    } 
    else {
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
  }

  public float getPos() {
    return 100 - (((spos - ypos)/(sposMax-sposMin)) * 100);
  }
}

public float truncate(float x, int digits) {
  int d = (int)pow(10, digits);
  x *= d;
  x = PApplet.parseInt(x);
  x /= d;
  return x;
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "AerOmega_dashboard" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
