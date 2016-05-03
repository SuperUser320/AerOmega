import processing.serial.*;

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

void setup() {
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
  arduino = new Serial(this, Serial.list()[5], 57600);  //For reduced packed drop reduce baud
  delay(10);
}

void draw() {
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
  if(arduino.available() == 0) {
    connectionEst = true;
  }
  sendData();
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
  text("aerΩmega | v0.1", 20, 70);
  
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

void displayAngleData() {
  xGimbal.updateAngle(xAng);
  yGimbal.updateAngle(yAng);
  zGimbal.updateAngle(zAng);
}

void displaySetpointData() {
  xGimbal.updatePidAngle((float)(pxAng*(Math.PI/180)));
  yGimbal.updatePidAngle((float)(pyAng*(Math.PI/180)));
  zGimbal.updatePidAngle((float)(pzAng*(Math.PI/180)));
}

void displayMotorData() {
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

void displayPidData() {
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
