import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AerOmega_dashboard extends PApplet {



///////////////////////////////////
// ==== DASHBOARD VARIABLES ==== //
///////////////////////////////////

//////////////////////
//// GUI ELEMENTS ////
//////////////////////

//// INDICATORS ////
SignalIndicator signalIndicator;
BatteryIndicator batteryIndicator;

//// ATTITUDE VALUES ////
Gimbal xGimbal;
Gimbal yGimbal;
Gimbal zGimbal;

//// THROTTLE VALUES ////
VScrollbar throttleBar1;
VScrollbar throttleBar2;
VScrollbar throttleBar3;
VScrollbar throttleBar4;

//// CONTROLS ////
DisplayBar throttleOut1;
DisplayBar throttleOut2;
DisplayBar throttleOut3;
DisplayBar throttleOut4;

Button updateButton;  //Enable/Disable debug layout
Button debugButton;   //Enable/Disable debug layout
Button stateButton;   //Enable/Disable
Button initButton;
Button eStopButton;

//// PID CORRECTIONS ////
//// PID Constants ////
TextBox kPText;
TextBox kIText;
TextBox kDText;
//// Aggressive PID constants ////
TextBox kPaggText;
TextBox kIaggText;
TextBox kDaggText;
//// PID constants for height ////
TextBox kPheightText;
TextBox kIheightText;
TextBox kDheightText;

///////////////
//// FONTS ////
///////////////
PFont SegoeUI;
PFont SegoeUITitle;
PFont SegoeUISubTitle;

///////////////////////
//// GUI VARIABLES ////
///////////////////////
boolean debugViewEnabled;

///////////////////
// KEY VARIABLES //
///////////////////
boolean keyDown;

/////////////////////
// MOUSE VARIABLES //
/////////////////////
boolean mouseReleased;

///////////////////////////////////////////
// ==== QUADROTOR CONTROL VARIABLES ==== //
///////////////////////////////////////////
Serial arduino;
boolean connectionEst = false;

//////////////////////////////////
//// CONTROL OUTPUT VARIABLES ////
//////////////////////////////////
int throttle;
boolean init = false;

///////////////////////
//// ATTITUDE DATA ////
///////////////////////
//// Current orientation of quadrotor ////
float xAng;
float yAng;
float zAng;

//// Desired location of quadrotor ////
float pxAng;
float pyAng;
float pzAng;
float pHeight;


/////////////////////
//// OUTPUT DATA ////
/////////////////////
//// Throttle output of quadrotor (of 1000) ////
float mt1;
float mt2;
float mt3;
float mt4;


//////////////////
//// PID DATA ////
//////////////////
//// PID Values ////
float kP;
float kI;
float kD;
//// Aggressive PID values ////
float kPagg;
float kIagg;
float kDagg;
//// PID values for height ////
float kPheight;
float kIheight;
float kDheight;


/////////////////////
//// SENSOR DATA ////
/////////////////////
//// Sensor altitude ////
float heightBar;
float heightIr;

//// Battery Reading - placeholder (use onboard hardware, sensor not implemented) ////
float battVoltage;


//////////////////////
//// FLEIGHT DATA ////
//////////////////////
float upTime;

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

public void setup() {
  size(1280, 800, "processing.core.PGraphicsRetina2D");
  hint(ENABLE_RETINA_PIXELS);
  smooth();
  
  ////////////////////
  //// LOAD FONTS ////
  ////////////////////
  SegoeUITitle = loadFont("SegoeUI-Light-48.vlw");
  SegoeUISubTitle = loadFont("SegoeUI-Light-36.vlw");
  SegoeUI = loadFont("SegoeUI-Light-20.vlw");
  println(Serial.list());

  //////////////////////
  //// GUI ELEMENTS ////
  //////////////////////
  signalIndicator = new SignalIndicator(1195, 20, 15, 4);
  batteryIndicator = new BatteryIndicator(1025, 20, 60);
  
  //// Motor Output ////
  throttleOut1 = new DisplayBar(80,  500, 30, 220, "A: ");
  throttleOut2 = new DisplayBar(180, 500, 30, 220, "B: ");
  throttleOut3 = new DisplayBar(280, 500, 30, 220, "C: ");
  throttleOut4 = new DisplayBar(380, 500, 30, 220, "D: ");
  
  //// Attitude Values ////
  xGimbal = new Gimbal(135, 265, 175, false, true, "X: ");
  yGimbal = new Gimbal(355, 265, 175, false, true, "Y: ");
  zGimbal = new Gimbal(575, 265, 175, true,  true, "Z: ");
  
  //// Controls ////
  throttleBar1 = new VScrollbar(550, 500, 30, 220, 1, "A: ");
  throttleBar2 = new VScrollbar(650, 500, 30, 220, 1, "B: ");
  throttleBar3 = new VScrollbar(750, 500, 30, 220, 1, "C: ");
  throttleBar4 = new VScrollbar(850, 500, 30, 220, 1, "D: ");
  
  updateButton = new Button(975, 490, 260, 35, "Send Values", false);
  debugButton = new Button(975, 540, 260, 35, "Debug View Disabled", "Debug View Enabled", false);
  stateButton = new Button(975, 590, 260, 35, "Disabled", "Enabled", false);
  initButton = new Button(975, 640, 260, 35, "INIT QUADROTOR", true, "QUAD ARMED");
  eStopButton = new Button(975, 690, 260, 65, "EMERGENCY STOP", true, "E-STOP ENABLED");
  
  //// PID CORRECTIONS ////
  //// PID Constants ////
  kPText = new TextBox(780, 175, true, "kP: ");
  kIText = new TextBox(780, 200, true, "kI: ");
  kDText = new TextBox(780, 225, true, "kD: ");
  //// Aggressive PID constants ////
  kPaggText = new TextBox(780, 275, true, "kPagg: ");
  kIaggText = new TextBox(780, 300, true, "kIagg: ");
  kDaggText = new TextBox(780, 325, true, "kDagg: ");
  //// PID constants for height ////
  kPheightText = new TextBox(1075, 175, true, "kPheight: ");
  kIheightText = new TextBox(1075, 200, true, "kIheight: ");
  kDheightText = new TextBox(1075, 225, true, "kDheight: ");

  //////////////////////////////////////
  //// ARDUINO SERIAL COMMUNICATION ////
  //////////////////////////////////////
  //arduino = new Serial(this, Serial.list()[5], 57600);  //For reduced packed drop reduce baud
  delay(10);
}

public void draw() {
  drawBackground();
  fill(255);

  signalIndicator.displaySignal();
  batteryIndicator.displayBattery();

  displayControls();
  displayAngleData();
  displayMotorData();
  displaySetpointData();
  displayPidData();
  
  //Send data back at the same speed
  /*if(arduino.available() == 0) {
    connectionEst = true;
  }
  sendData();*/
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
  text("aer\u2126mega | v0.1", 20, 70);
  
  textFont(SegoeUISubTitle);
  text("attitude values", 40, 150);
  text("pid corrections", 725, 150);
  text("motor values", 40, 480);
  text("controls", 500, 480);
  
  textFont(SegoeUI);
}

public void displayControls() {

  //Main throttle slider
  throttleBar1.update();
  throttleBar1.display();

  throttleBar2.update();
  throttleBar2.display();
  
  throttleBar3.update();
  throttleBar3.display();
  
  throttleBar4.update();
  throttleBar4.display();
  
  //Send data to quadrotor button
  updateButton.update();
  if (updateButton.buttonPressed()) {
    //////////////////////////////////
    //TODO: WRITE CODE TO SEND DATA //
    //////////////////////////////////
  }
  
  //Toggle debug perspective
  debugButton.update();
  if (debugButton.buttonPressed()) {
    debugButton.toggle();
    debugViewEnabled = debugButton.enabled;
  }
  
  //Toggle States button
  stateButton.update();
  if (stateButton.buttonPressed()) {
    ///////////////////////////////
    //TODO: WRITE CODE FOR TOGGLE//
    ///////////////////////////////
    stateButton.toggle();
  }
  
  //Quadrotor init button
  initButton.update();
  if (initButton.buttonPressed()) {
    //arduino.write("1,1,1,1");
    initButton.lock(true);
  }
  
  //E-STOP Button
  eStopButton.update();
  if (eStopButton.buttonPressed()) {
    //////////////////////////////
    //TODO: WRITE CODE TO E-STOP//
    //////////////////////////////
    eStopButton.lock(true);
  }
}

public void displayAngleData() {
  xGimbal.updateAngle(xAng);
  yGimbal.updateAngle(yAng);
  zGimbal.updateAngle(zAng);
}

public void displaySetpointData() {
  xGimbal.updatePidAngle((float)(pxAng*(Math.PI/180)));
  yGimbal.updatePidAngle((float)(pyAng*(Math.PI/180)));
  zGimbal.updatePidAngle((float)(pzAng*(Math.PI/180)));
}

public void displayMotorData() {
  //Motor Throttles
  float mo1 = truncate(mt1, 2);
  float mo2 = truncate(mt2, 2);
  float mo3 = truncate(mt3, 2);
  float mo4 = truncate(mt4, 2);
  
  throttleOut1.update(mo1/10);
  throttleOut2.update(mo2/10);
  throttleOut3.update(mo3/10);
  throttleOut4.update(mo4/10);
}

public void displayPidData() {
  //// PID Constants ////
  kPText.update(Float.toString(kP));
  kIText.update(Float.toString(kI));
  kDText.update(Float.toString(kD));
  //// Aggressive PID constants ////
  kPaggText.update(Float.toString(kPagg));
  kIaggText.update(Float.toString(kIagg));
  kDaggText.update(Float.toString(kDagg));
  //// PID constants for height ////
  kPheightText.update(Float.toString(kPheight));
  kIheightText.update(Float.toString(kIheight));
  kDheightText.update(Float.toString(kDheight));
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  case:                                                                                           Communication Example:  (from quadrotor)                                                                                                                      ////
////  [0]   case:0,xAng:[...],yAng:[...],zAng:[...],m1:[...],m2:[...],m3:[...],m4:[...],hBar:[...],hIR:[...],bat:[...],throt:[...],tR:[...],tP:[...],tH:[...],kP:[...],kI:[...],kD:[...],kPa:[...],kIa:[...],kDa:[...],kPh:[...],kIh:[...],kDh:[...],[timeStamp],   ////
////  [1]   case,xAng,yAng,zAng,m1,m2,m3,m4,hBar,hIR,bat,tT,tR,tP,tH,kP,kI,kD,kPa,kIa,kDa,kPh,kIh,kDh,timeStamp,                                                                                                                                                    ////
////  [2]   case,xAng,yAng,zAng,m1,m2,m3,m4,hBar,hIR,bat,timeStamp,                                                                                                                                                                                                 ////
////  [3]   case,xAng,yAng,zAng,m1,m2,m3,m4,hBar,hIR,bat,                                                                                                                                                                                                           ////
////                                                                                                                                                                                                                                                                ////
////  NOTE: In human readable case [0] '\t' [TAB] will separate each output                                                                                                                                                                                         ////
////        All cases will end with '\n' [NEWLINE] character                                                                                                                                                                                                        ////
////        [...] denotes a human readable data set                                                                                                                                                                                                                 ////
////                                                                                                                                                                                                                                                                ////
////  Var Definitions:                                                                                                                                                                                                                                              ////
////     xAng, yAng, zAng  -  Attitude of quadrotor on each axis (zAng = heading) [-179,179]                                                                                                                                                                        ////
////     m1, m2, m3, m4    -  Output of each motor [0,100]                                                                                                                                                                                                          ////
////     hBar, hIR         -  Height as given by the barometric pressure sensor and infrared sensors respectively (hBar [0,inf], hIR [0,??])                                                                                                                        ////
////     bat               -  Battery Voltage in mV [0, 12600] (full charge 12.6V)                                                                                                                                                                                  ////
////     throt             -  Throttle, value added to PID corrections                                                                                                                                                                                              ////
////     tR, tP, tH        -  PID targets for Roll, Pitch and Heading respectively [-179,179]                                                                                                                                                                       ////
////     kP, kI, kD        -  PID constants for normal PID                                                                                                                                                                                                          ////
////     kPa, kIa, kDa     -  PID constants for aggressive PID                                                                                                                                                                                                      ////
////     kPh, kIh, kDh     -  PID constants for height PID                                                                                                                                                                                                          ////
////     [timeStamp]       -  Timestamp, not labled, milliseconds of uptime                                                                                                                                                                                         ////
////                                                                                                                                                                                                                                                                ////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//// Type of feedback recieved ////
int feedbackCase;

//// Reading variables ////
boolean dataRecieved;

//// Parsing variables ////
int dataIndex;
char readChar = ' ';
String tmpStr;

//// transmission variables ////
int loopCount = 0;
int updateFreq = 100;

public void serialEvent(Serial arduino) {
  // only run if imu data is available else idle or parse data // make main cpu request data later //
  if (arduino.available() > 0) {
    readChar = PApplet.parseChar(arduino.read());
    print(readChar);
    // start looking for data after '\n' //
    if (readChar == '\n') {
      dataIndex = 0;
      readChar = ' ';
      storeVal();
      tmpStr = "";
    }
    // look for new data after ':'s //
    if (readChar == '\t') {
      storeVal();
      dataIndex++;
      readChar = ' ';
      tmpStr = "";
    }
    // throw away data after index of 25 //
    if (dataIndex < 25 || readChar == ' ') {
      tmpStr += readChar;
    }
  }
}

//// Store values read from IMU ////
public void storeVal() {
  switch(dataIndex) {
  case 0:
    feedbackCase = PApplet.parseInt(tmpStr);
    break;
    
  ////  Attitude Feedback ////
  case 1:
    yAng = PApplet.parseFloat(tmpStr);     // x and y axies are switched //
    break;

  case 2:
    xAng = PApplet.parseFloat(tmpStr);
    break;

  case 3:
    zAng = PApplet.parseFloat(tmpStr);
    break;


  ////  Motor Outputs ////
  case 4:
    mt1 = PApplet.parseFloat(tmpStr);
    break;

  case 5:
    mt2 = PApplet.parseFloat(tmpStr);
    break;

  case 6:
    mt3 = PApplet.parseFloat(tmpStr);
    break;

  case 7:
    mt4 = PApplet.parseFloat(tmpStr);
    break;
    

  //// Sensor Altitidue ////
  case 8:
    heightBar = PApplet.parseFloat(tmpStr);
    break;

  case 9:
    heightIr = PApplet.parseFloat(tmpStr);
    break;
  

  //// Battery Feedback ////
  case 10:
    battVoltage = PApplet.parseFloat(tmpStr);
    break;
    
    
  //// PID Setpoints ////
  case 11:
    pHeight = PApplet.parseFloat(tmpStr);
    break;
    
  case 12:
    pxAng = PApplet.parseFloat(tmpStr);
    break;
    
  case 13:
    pyAng = PApplet.parseFloat(tmpStr);
    break;
  
  case 14:
    pzAng = PApplet.parseFloat(tmpStr);
    break;
    
    
  //// PID Parameters ////
  case 15:
    kP = PApplet.parseFloat(tmpStr);
    break;
    
  case 16:
    kI = PApplet.parseFloat(tmpStr);
    break;
    
  case 17:
    kD = PApplet.parseFloat(tmpStr);
    break;
    
  case 18:
    kPagg = PApplet.parseFloat(tmpStr);
    break;
    
  case 19:
    kIagg = PApplet.parseFloat(tmpStr);
    break;
    
  case 20:
    kDagg = PApplet.parseFloat(tmpStr);
    break;
    
  case 21:
    kPheight = PApplet.parseFloat(tmpStr);
    break;
    
  case 22:
    kIheight = PApplet.parseFloat(tmpStr);
    break;
    
  case 23:
    kDheight = PApplet.parseFloat(tmpStr);
    break;  
    
  case 24:
    upTime = PApplet.parseFloat(tmpStr);
    break;
  }
}

public void sendData()
{
    if(connectionEst) {
      //// If e-stop is enabled continuously resend '0' line ////
      if(eStopButton.buttonLocked()) {
        arduino.write(PApplet.parseByte(0));
        arduino.write(PApplet.parseByte(255));
        println("SENT E-STOP");
      }
      
      //// Continue to operate normally ////
      arduino.write("1");
  }
}
class BatteryIndicator {
  
  //Position variables
  float x, y, indicatorWidth, indicatorHeight;
  float ratio = 1.5f;
  
  //Data variables
  float batteryVoltage;
  float batteryPercent;
  
  //Color variables
  int batteryColor = color(160);
  int backgroundColor = color(80);
  int batteryAlertColor = color(215, 60, 60);
  
  //Threshold variables
  float alertThreshold = .2f;
  
  //State variables
  boolean enabled = false;
  boolean locked = false;
  boolean pressed = false;
  boolean hover = false;
  boolean hasBeenPressed = false;
  boolean pressOriginInside = false;
  boolean lastPressed = false;
  boolean lastMouse = false;
  
  BatteryIndicator(int tx, int ty, int size) {
    x = tx;
    y = ty;
    indicatorWidth = size/ratio;
    indicatorHeight = size;
  }
  
  public void displayBattery() {
    
    //Background Rectangle
    noStroke();
    fill(backgroundColor);
    rect(x + (indicatorWidth)/2 - indicatorHeight/8, y - ratio*2, indicatorHeight/4, ratio*2);
    rect(x, y, indicatorWidth, indicatorHeight);
    
    if(batteryPercent != 0) {
      
      if(batteryPercent <= alertThreshold) {
        fill(batteryAlertColor);
      } else {
        fill(batteryColor);
      }
      
      //Draw Battery Box
      rect(x, y + (indicatorHeight * (1 - batteryPercent)), indicatorWidth, indicatorHeight * batteryPercent);
      
      //Write battery percentage
      textFont(SegoeUI);
      
      checkClick();
      
      if (buttonPressed()) {
        toggle();
      }
      
      if (enabled) {
        text(PApplet.parseInt(batteryPercent * 100) + "%", x - textWidth(PApplet.parseInt(batteryPercent * 100) + "%") - indicatorHeight/10 , y + indicatorHeight);
      } else {
        text(PApplet.parseInt(batteryVoltage) + "mV", x - textWidth(PApplet.parseInt(batteryVoltage) + "mV") - indicatorHeight/10 , y + indicatorHeight);
      }
    }
  }
  
  public void checkClick() {
   //mousePressed in button
    if (mouseX > x && mouseX < (x + indicatorWidth) && mouseY > y && mouseY < (y + indicatorHeight) && !locked) {
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
    if (mouseX > x && mouseX < (x + indicatorWidth) && mouseY > y && mouseY < (y + indicatorHeight) && !locked && lastPressed == false && pressed == true && lastMouse == false && mousePressed) {
      pressOriginInside = true;
    } else if (!(mouseX > x && mouseX < (x + indicatorWidth) && mouseY > y && mouseY < (y + indicatorHeight)) && !locked && lastPressed == false && pressed == true && lastMouse == false && mousePressed) {
      pressOriginInside = false;
    }
    
    //mouseReleased in button
    if (mouseX > x && mouseX < (x + indicatorWidth) && mouseY > y && mouseY < (y + indicatorHeight) && !locked && lastPressed == true && pressed == false && pressOriginInside) {
      hasBeenPressed = true;
    } else {
      hasBeenPressed = false;
    }
    
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
  
  
  public void toggle() {
    if (enabled) {
      enabled  = false;
    } else {
      enabled = true;
    }
  }
  
  public void calculatePercent() {
    ///////////////////////////
    //TODO: ADD PERCENT TEST //
    ///////////////////////////
  }
}
class Button {

  int x, y, buttonWidth, buttonHeight;

  int pressedColor = color(100);
  int releasedColor = color(160);
  int hoverColor = color(140);
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

  boolean enabled = false;
  boolean locked = false;
  boolean pressed = false;
  boolean hover = false;
  boolean hasBeenPressed = false;
  boolean pressOriginInside = false;
  boolean lastPressed = false;
  boolean lastMouse = false;

  String buttonTextDefault;
  String buttonTextEnabled;
  String lockedText;

  boolean warningButton;

  //textDefault will deisplay when the button is in the false state
  
  Button (int tx, int ty, int twidth, int theight, String ttextDefault, boolean twarningButton) {
    x = tx;
    y = ty;
    buttonWidth = twidth;
    buttonHeight = theight;
    warningButton = twarningButton;
    buttonTextDefault = ttextDefault;
    buttonTextEnabled = ttextDefault;
  }
  
  Button (int tx, int ty, int twidth, int theight, String ttextDefault, String ttextEnabled, boolean twarningButton) {
    x = tx;
    y = ty;
    buttonWidth = twidth;
    buttonHeight = theight;
    warningButton = twarningButton;
    buttonTextDefault = ttextDefault;
    buttonTextEnabled = ttextEnabled;
  }

  Button (int tx, int ty, int twidth, int theight, String ttextDefault, boolean twarningButton, String tlockText) {
    x = tx;
    y = ty;
    buttonWidth = twidth;
    buttonHeight = theight;
    warningButton = twarningButton;
    buttonTextDefault = ttextDefault;
    lockedText = tlockText;
  }

  public void drawButton() {
    if (warningButton) {
      if (locked) {
        buttonColor = warningLockedColor;
        textColor = lockedTextColor;
      } else if (hover) {
        buttonColor = warningHoverColor;
        textColor = hoverTextColor;
      } else if (pressed) {
        buttonColor = warningPressedColor;
        textColor = pressedTextColor;
      } else {
        buttonColor = warningReleasedColor;
        textColor = releasedTextColor;
      }
    } else { 
      if (locked) {
        buttonColor = lockedColor;
        textColor = lockedTextColor;
      } else if (hover) {
        buttonColor = hoverColor;
        textColor = hoverTextColor;
      } else if (pressed) {
        buttonColor = pressedColor;
        textColor = pressedTextColor;
      } else {
        buttonColor = releasedColor;
        textColor = releasedTextColor;
      }
    }

    noStroke();
    fill(buttonColor);
    rect(x, y, buttonWidth, buttonHeight);
    fill(red(buttonColor) - 40, blue(buttonColor) - 40, green(buttonColor) - 40);
    triangle(x, y + buttonHeight, x + 10, y + buttonHeight, x + 10, y + buttonHeight + 5);
    rect(x + 10, y + buttonHeight, buttonWidth - 20, 5);
    triangle(x + buttonWidth - 10, y + buttonHeight, x + buttonWidth, y + buttonHeight, x + buttonWidth - 10, y + buttonHeight + 5);

    fill(textColor);
    if (locked) {
      text(lockedText, x + (buttonWidth / 2) - (textWidth(lockedText) / 2), y + (buttonHeight / 2) + 7);
    } 
    else if (enabled){
      text(buttonTextEnabled, x + (buttonWidth / 2) - (textWidth(buttonTextEnabled) / 2), y + (buttonHeight / 2) + 7);
    } else {
      text(buttonTextDefault, x + (buttonWidth / 2) - (textWidth(buttonTextDefault) / 2), y + (buttonHeight / 2) + 7);
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
    } else if (!(mouseX > x && mouseX < (x + buttonWidth) && mouseY > y && mouseY < (y + buttonHeight)) && !locked) {
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
      return true;
    } else {
      return false;
    }
  }

  public boolean buttonLocked() {
    if (locked) {
      return true;
    } else {
      return false;
    }
  }
  public void lock(boolean lockButton) {
    locked = lockButton;
    pressed = false;
  }
  
  public void toggle() {
    if (enabled) {
      enabled = false;
    } else {
      enabled = true;
    }
  }
}


class DisplayBar {

  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // y position of slider
  int sposMin, sposMax;   // max and min values of slider
  TextBox textBox;

  DisplayBar (int xp, int yp, int sw, int sh, String label) {
    swidth = sw;
    sheight = sh;
    xpos = xp-swidth/2;
    ypos = yp;
    spos = ypos + sheight - swidth;
    newspos = spos;
    sposMin = ypos;
    sposMax = ypos + sheight - 5;
    textBox = new TextBox(xpos - PApplet.parseInt(textWidth("100.0") + 20)/2 + swidth/2, ypos + sheight + 15, (int)textWidth("100.0") + 20, 20, false, label);
  }

  public void update(float value) {
    
    spos = (ypos + (-value/100) * (sposMax-sposMin)) + (sposMax-sposMin);
    
    //Slider body
    strokeWeight(1);
    stroke(170);
    //Slider fill
    fill(255);
    rect(xpos, ypos, swidth, sheight + 4);
    //Slider background
    fill(0);
    rect(xpos, ypos, swidth, spos - ypos + 1);
    
    
    //Slider rectangle body
    fill(180);
    noStroke();
    rect(xpos - 10, spos, swidth + 20, 4);
    
    //Slider depth body
    fill(100);
    triangle(xpos - 10, spos + 4, xpos, spos + 4, xpos, spos + 10);
    triangle(xpos + swidth + 10, spos + 4, xpos + swidth + 1, spos + 4, xpos + swidth + 1, spos + 10);
    fill(140);
    rect(xpos, spos + 4, swidth + 1, 2);
    stroke(1);
    
    fill(255);
    textBox.update(Float.toString(value));
  }
}
class Gimbal {

  int x, y, size;
  float angle = 0;
  boolean isCompass;
  boolean showPid;
  
  TextBox textBox;
  
  Gimbal (int tx, int ty, int tsize, boolean tisCompass, boolean tshowPid, String label) {
    x = tx;
    y = ty;
    size = tsize;
    isCompass = tisCompass;
    textBox = new TextBox(x - PApplet.parseInt(textWidth("360.0") + 20)/2, y + size/2 + 20, (int) textWidth("360.0") + 20, 20, false, label);
  }

  public void updateAngle(float inAngle) {
    angle = (float) ((inAngle * Math.PI) / 180);

    strokeWeight(4);
    stroke(100);
    fill(200);
    ellipse(x, y, size, size);

    if (!isCompass) {

      noStroke();
      fill(25);
      arc(x, y, size * .98f, size * .98f, 0, PI);

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
      fill(50);
      strokeWeight(2);
      stroke(180);
      float nDotSize = 9;
      ellipse(x, y - (nDotSize/2) - (size/2) - (20 + nDotSize/2), nDotSize, nDotSize);
      //text("N", x - (textWidth("N") / 2), y - (size/2) - (size * 0.1));
      //text("S", x - (textWidth("S") / 2), y + (size/2) + (size * 0.2));

      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(angle);
      stroke(85);
      fill(85);
      triangle(-size/15, 0, 0, -size * 0.6f, size/15, 0);
      stroke(175);
      fill(175);
      quad(-size/15, 0, 0, size * 0.6f, size/15, 0, 0, -size * 0.05f);
      popMatrix();
    }
    
    fill(255);
    textBox.update(Float.toString(inAngle));
  }

  public void updatePidAngle(float pidAngle) {

    if (!isCompass) {
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(pidAngle);
      noStroke();
      fill(180, 80);
      triangle(-size * 0.6f, 0, 0, -size/10, size * 0.6f, 0);
      noStroke();
      fill(50, 80);
      triangle(-size * 0.6f, 0, 0, size/10, size * 0.6f, 0);
      popMatrix();
    } else {
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(pidAngle);
      noStroke();
      fill(85, 80);
      triangle(-size/15, 0, 0, -size * 0.6f, size/15, 0);
      noStroke();
      fill(175, 68);
      quad(-size/15, 0, 0, size * 0.6f, size/15, 0, 0, -size * 0.05f);
      popMatrix();
    }
  }
}

public void keyPressed() {
  if(!keyDown) {
    keyDown = true;
    if(key == ' ') {
      eStopButton.lock(true);
      //////////////////////////////
      //TODO: WRITE CODE TO E-STOP//
      //////////////////////////////
    }
    if(key == '\n') {
      stateButton.toggle();
      //////////////////////////////
      //TODO: WRITE CODE TO E-STOP//
      //////////////////////////////
    }
  }
}
public void keyReleased() {
  keyDown = false;
}
public void mousePressed() {
  mouseReleased = false;
}

public void mouseReleased() {
  mouseReleased = true;
}
class SignalIndicator {

  //Position variables
  int x, y, size, bars;
  
  //Data variables
  int signalStrength;
  
  //Color variables
  int signalColor = color(160);
  int noSignalColor = color(80);
  int signalAlertColor = color(215, 60, 60);
  
  SignalIndicator(int tx, int ty, int tsize, int tbars) {
    x = tx;
    y = ty;
    size = tsize;
    bars = tbars;
  }
  
  public void displaySignal() {
    
    //Background triangle
    noStroke();
    fill(noSignalColor);
    triangle(x, y + (size * bars), x + (size * bars), y, x + (size * bars), y + (size * bars));
    
    if(signalStrength > 0) {
      
      fill(signalColor);
      textFont(SegoeUI);
      text("signal", x - textWidth("signal") - size, y + size * bars);
      
      if(signalStrength <= 1) {
        fill(signalAlertColor);
      } else {
        fill(signalColor);
      }
      
      //Draw indicator bars
      for(int i = 0; i < signalStrength; i++) {
        triangle(x + (i * size), y + (size * (bars - i)), x + ((i + 1) * size), y + (size * (bars - (i + 1))), x + ((i + 1) * size), y + (size * (bars - i)));
        rect(x + (i * size), y + (size * (bars - i)), size, size * i);
      }
    } else {
      //If no communications display no signal
      fill(signalAlertColor);
      textFont(SegoeUI);
      text("no comm.", x - textWidth("no comm.") - size, y + size * bars);
    }
  }
  
  public void testSignal() {
    //////////////////////////
    //TODO: ADD SIGNAL TEST //
    //////////////////////////
  }
}
class VScrollbar {

  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // y position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean pressOriginInside;
  boolean pressed;
  boolean lastPressed;
  boolean locked;
  float ratio;
  TextBox textBox;
  
  VScrollbar (int xp, int yp, int sw, int sh, int l, String label) {
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
    
    textBox = new TextBox(xpos - (PApplet.parseInt(textWidth("100.0")) + 20)/2 + swidth/2, ypos + sheight + 15, PApplet.parseInt(textWidth("100.0")) + 20, 20, false, label);
  }

  public void update() {
    if (over()) {
      over = true;
    } else {
      over = false;
    }
    
    if (mouseX > xpos && mouseX < (xpos + swidth) && mouseY > ypos && mouseY < (ypos + sheight) && mousePressed) {
      pressed = true;
    } 
    else {
      pressed = false;
    }
    
    //mouseDown in button
    if (mouseX > xpos && mouseX < (xpos + swidth) && mouseY > ypos && mouseY < (ypos + sheight) && lastPressed == false && pressed == true && mousePressed) {
      pressOriginInside = true;
    } else if (!(mouseX > xpos && mouseX < (xpos + swidth) && mouseY > ypos && mouseY < (ypos + sheight))) {
      pressOriginInside = false;
    }
    
    if (mousePressed && over && pressOriginInside) {
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
    
    lastPressed = mousePressed;
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
    textBox.update(Float.toString(truncate(100 - (((spos - ypos)/(sposMax-sposMin)) * 100), 1)));
  }

  public float getPos() {
    return 100 - (((spos - ypos)/(sposMax-sposMin)) * 100);
  }
}

class TextBox {

  int x, y, w, h;
  String label;
  String inputText;
  
  int cursorColorDark = color(100);
  int cursorColorLight = color(170);
  int selectedColor = color(60);
  int releasedColor = color(100);
  int hoverColor = color(80);
  boolean darkCursor = false;
  
  boolean selectable;
  boolean fitText;
  
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
  
  public float update(String input) {
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
      if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
        inputText += key;
      }
      //Handle decimal
      if (key == '.' && !inputText.contains(".")) { 
        inputText += key;
      }
      //Handle backspace
      if (key == 8 && inputText.length() > 0) {
        inputText = inputText.substring(0,inputText.length() - 1);
      }
      //Handle newline
      if (key == '\n') {
        selected = false;
      }
      
      charAdded = true;
    } else if (!selected) {
      inputText = input;
    }
    
    drawTextBox();
    
    if (!(inputText.length() > 0)) {
      return 0.0f;
    } else {
      return PApplet.parseFloat(inputText);
    }
  }
  
  private void drawTextBox() {
    
      textFont(SegoeUI);
      if(fitText) {
        //Calculate width and height
        w = PApplet.parseInt(textWidth(inputText));
        h = 20;
      }
      //Draw box
      strokeWeight(1);
      stroke(200);
      fill(50);
      if (w == 0) {
        w = PApplet.parseInt(textWidth(inputText) + 10);
      }
      
      if (selected) {
          fill(selectedColor);
        } else if (hover) {
          fill(hoverColor);
        } else {
          fill(releasedColor);
      }
        
      if (selected) {
        if (frameCount % 20 == 0) {
          if (darkCursor) {
            darkCursor = false;
          } else { 
            darkCursor = true;
          }
        }
        
        if (darkCursor) {
          stroke(cursorColorDark);
        } else {
          stroke(cursorColorLight);
        }
      }
      
      rect(x - 4, y , w + 6, h);
      
      fill(255);
      
      text(label, x - textWidth(label) - 5, y + h - 2);
      text(inputText, x + w - PApplet.parseInt(textWidth(inputText)), y + h - 2);
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
    String[] appletArgs = new String[] { "AerOmega_dashboard" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
