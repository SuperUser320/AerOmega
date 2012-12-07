import processing.serial.*;

Serial arduino;
//// GUI elements ////
VScrollbar throttleBar1;
VScrollbar throttleBar2;
VScrollbar throttleBar3;
VScrollbar throttleBar4;
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
float xAng;
float yAng;
float zAng;

float mt1;
float mt2;
float mt3;
float mt4;

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
  initButton = new Button(975, 720, 260, 35, "INIT QUADROTOR", true, "QUAD ARMED");

  //// ARDUINO ////
 // arduino = new Serial(this, Serial.list()[1], 57600);
  delay(10);
}

void draw() {
  drawBackground();
  fill(255);

  //displaySignal();

  displayControls();
  //displayAngleData();
  //displayMotorData();

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
  text("PID Corrections", 600, 150);
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
  text("xAng: " + xAng, 180, 45);
  text("yAng: " + yAng, 180, 90);
  text("zAng: " + zAng, 180, 135);
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
    text("Motor 1: " + truncate(mt1 - 999, 3), 180, 180);
    text("Motor 2: " + truncate(mt2 - 999, 3), 180, 225);
    text("Motor 3: " + truncate(mt3 - 999, 3), 180, 270);
    text("Motor 4: " + truncate(mt4 - 999, 3), 180, 315);
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

