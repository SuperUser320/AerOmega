import processing.serial.*;

Serial arduino;

//////////////////////
//// GUI ELEMENTS ////
//////////////////////
SignalIndicator signalIndicator;

VScrollbar throttleBar1;
VScrollbar throttleBar2;
VScrollbar throttleBar3;
VScrollbar throttleBar4;

GuiQuad guiQuad;

DisplayBar throttleOut1;
DisplayBar throttleOut2;
DisplayBar throttleOut3;
DisplayBar throttleOut4;

Gimbal xGimbal;
Gimbal yGimbal;
Gimbal zGimbal;

Button debugButton;  //Enable/Disable debug layout
Button stateButton;  //Enable/Disable
Button initButton;
Button eStopButton;

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

/////////////////////////////////////////
////// QUADROTOR CONTROL VARIABLES //////
/////////////////////////////////////////

//////////////////////////////////
//// CONTROL OUTPUT VARIABLES ////
//////////////////////////////////
int throttle;
boolean init = false;

////////////////////////
//// DASHBOARD DATA ////
////////////////////////
//// Current orientation of quadrotor ////
float xAng = 12;
float yAng = 243;
float zAng = 146;

//// Desired location of quadrotor ////
float pxAng = 0;
float pyAng = 0;
float pzAng = 0;

//// Throttle output of quadrotor (of 1000) ////
float mt1 = 352;
float mt2 = 532;
float mt3 = 732;
float mt4 = 164;

//// PID Values ////
double kP = 0.4;
double kI = 0.5;
double kD = 0;
//// Aggressive PID values ////
double kPagg = 0.8;
double kIagg = 0.5;
double kDagg = 0;
//// PID values for height ////
double kPheight = 0.2;
double kIheight = 0;
double kDheight = 0;
//// PID output limits ////
long lowerLimit = -500; 
long upperLimit = 500;
float pidThreshold = 35.0;
int pidSampleTime = 50;

void setup() {
  size(1280, 800);
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
  
  throttleBar1 = new VScrollbar(550, 500, 30, 220, 1);
  throttleBar2 = new VScrollbar(650, 500, 30, 220, 1);
  throttleBar3 = new VScrollbar(750, 500, 30, 220, 1);
  throttleBar4 = new VScrollbar(850, 500, 30, 220, 1);
  
  guiQuad = new GuiQuad(100, 525, 200);
  
  throttleOut1 = new DisplayBar(80,  500, 30, 220);
  throttleOut2 = new DisplayBar(180, 500, 30, 220);
  throttleOut3 = new DisplayBar(280, 500, 30, 220);
  throttleOut4 = new DisplayBar(380, 500, 30, 220);
  
  xGimbal = new Gimbal(135, 265, 175, false, true);
  yGimbal = new Gimbal(355, 265, 175, false, true);
  zGimbal = new Gimbal(575, 265, 175, true,  true);
  
  debugButton = new Button(975, 540, 260, 35, "Debug View Disabled", "Debug View Enabled", false);
  stateButton = new Button(975, 590, 260, 35, "Disabled", "Enabled", false);
  initButton = new Button(975, 640, 260, 35, "INIT QUADROTOR", true, "QUAD ARMED");
  eStopButton = new Button(975, 690, 260, 65, "EMERGENCY STOP", true, "E-STOP ENABLED");

  //////////////////////////////////////
  //// ARDUINO SERIAL COMMUNICATION ////
  //////////////////////////////////////
  //arduino = new Serial(this, Serial.list()[1], 57600);  //For reduced packed drop reduce baud
  delay(10);
}

void draw() {
  drawBackground();
  fill(255);

  signalIndicator.displaySignal();

  displayControls();
  displayAngleData();
  displayMotorData();
  displayPidData();
  
  //Send data back at the same speed
  //sendData();
}

void drawBackground() {
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
  text("aerΩmega | V0.1", 20, 70);
  
  textFont(SegoeUISubTitle);
  text("attitude values", 40, 150);
  text("pid corrections", 725, 150);
  text("motor values", 40, 480);
  text("controls", 500, 480);
  
  textFont(SegoeUI);
}

void displayControls() {

  //Main throttle slider
  throttleBar1.update();
  throttleBar1.display("A: ");

  throttleBar2.update();
  throttleBar2.display("B: ");
  
  throttleBar3.update();
  throttleBar3.display("C: ");
  
  throttleBar4.update();
  throttleBar4.display("D: ");
  
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

void displayAngleData() {
  xGimbal.updateAngle("X: ", xAng);
  yGimbal.updateAngle("Y: ", yAng);
  zGimbal.updateAngle("Z: ", zAng);
}

void displayPidData() {
  xGimbal.updatePidAngle(pxAng);
  yGimbal.updatePidAngle(pyAng);
  zGimbal.updatePidAngle(pzAng);
}

void displayMotorData() {
  //Motor Throttles

  if (!debugViewEnabled) {
    guiQuad.draw3dQuad();
    //Text boxes with motor values below
  } else {
    float mo1 = truncate(mt1, 2);
    float mo2 = truncate(mt2, 2);
    float mo3 = truncate(mt3, 2);
    float mo4 = truncate(mt4, 2);
    
    throttleOut1.update("A: ", mo1/10);
    throttleOut2.update("B: ", mo2/10);
    throttleOut3.update("C: ", mo3/10);
    throttleOut4.update("D: ", mo4/10);
  }
}
