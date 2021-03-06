import processing.serial.*;

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

void setup() {
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

void draw() {
  drawBackground();
  fill(255);

  //displaySignal();

  displayControls();
  displayAngleData();
  displayMotorData();

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
  text("AerΩmega | V0.1", 20, 70);
  
  textFont(SegoeUISubTitle);
  text("Attitude Values", 40, 150);
  text("PID Corrections", 725, 150);
  text("Motor Values", 40, 480);
  text("Controls", 500, 480);
  
  textFont(SegoeUI);
}

void displayControls() {

  //Main throttle slider
  fill(255);
  text("MT1: " + int(throttleBar1.getPos()), 510, height - 40);
  throttleBar1.update();
  throttleBar1.display();

  fill(255);
  text("MT2: " + int(throttleBar2.getPos()), 610, height - 40);
  throttleBar2.update();
  throttleBar2.display();
  
  fill(255);
  text("MT3: " + int(throttleBar3.getPos()), 710, height - 40);
  throttleBar3.update();
  throttleBar3.display();
  
  fill(255);
  text("MT4: " + int(throttleBar4.getPos()), 810, height - 40);
  throttleBar4.update();
  throttleBar4.display();
  //Quadrotor init button
  initButton.update();
  if (initButton.buttonPressed()) {
    arduino.write("1,1,1,1");
    initButton.lock(true);
  }
}

void displayAngleData() {
  //Angles
  text("xAng: " + xAng, 90, 415);
  text("yAng: " + yAng, 310, 415);
  text("zAng: " + zAng, 530, 415);
  
  xGimbal.update(xAng);
  yGimbal.update(yAng);
  zGimbal.update(zAng);
}

void displayMotorData() {
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

void displaySignal() {
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

