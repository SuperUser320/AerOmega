import processing.serial.*;

///////////////////////////////////////////
// ==== QUADROTOR CONTROL VARIABLES ==== //
///////////////////////////////////////////
Serial arduino;

//////////// USER CONFIG ///////////////
///////// USE IMU OR QUADROTOR /////////
boolean useImu = false;
////////////////////////////////////////



int frames = 0;

double xAng;
double yAng;
double zAng;
double lastX;
double lastY;
double lastZ;




void setup() {
  size(800, 400);
  smooth();

  //////////////////////////////////////
  //// ARDUINO SERIAL COMMUNICATION ////
  //////////////////////////////////////
  if (useImu) {
    arduino = new Serial(this, Serial.list()[0], 57600);  //For reduced packed drop reduce baud
  } else {
    arduino = new Serial(this, Serial.list()[0], 9600);  //For reduced packed drop reduce baud
  }
  delay(10);
  background(0);
}

void draw() {
  if (frames == width) {
    background(0);
    frames = 0;
  }

  plot(xAng, lastX, color(255, 0, 0));
  plot(yAng, lastY, color(0, 255, 0));
  plot(zAng, lastZ, color(0, 0, 255));
  
  fill(255,0,0);
  text( "xAng", 10, 20);
  fill(0,255,0);
  text( "yAng", 10, 40);
  fill(0,0,255);
  text( "zAng", 10, 60);

  lastX = xAng;
  lastY = yAng;
  lastZ = zAng;

  frames++;
}

void plot(double point, double lastPoint, color fillColor) {
  stroke(fillColor);
  line(float(frames - 1), (float) (height/2 - lastPoint), float(frames), (float) (height/2 - point));
}

