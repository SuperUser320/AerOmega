import processing.serial.*;

Serial arduino;
//// GUI elements ////
VScrollbar throttleBar;
Button initButton;

PFont BankGothic;
PFont SegoeUI;

//// GUI variables ////
boolean dispQuad = true;

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
  SegoeUI = loadFont("SegoeUI-20.vlw");
  textFont(BankGothic);
  println(Serial.list());

  //// GUI ELEMENTS ////
  throttleBar = new VScrollbar(80, 20, 40, height - 95, 1);
  initButton = new Button(170, 350, 260, 35, "INIT QUADROTOR", true, "QUAD ARMED");

  //// ARDUINO ////
  arduino = new Serial(this, Serial.list()[1], 57600);
  delay(10);
}

void draw() {
  background(40);
  fill(255);

  //displaySignal();

  displayControls();
  displayAngleData();
  displayMotorData();

  //Send data back at the same speed
  sendData();
}

void displayControls() {

  //Main throttle slider
  throttle = int(throttleBar.getPos());
  text("Throttle: \n\n" + throttle, 20, height - 50);
  throttleBar.update();
  throttleBar.display();

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
