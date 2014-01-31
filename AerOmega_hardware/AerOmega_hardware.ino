#include <Servo.h> 
#include <PID_v1.h>

/***********************************************************
 *  reference IMU output:
 *  !ANG:0.40,0.09,-10.13,
 *  !ANG:0.48,0.12,-10.22,
 *  !ANG:0.41,0.16,-10.29,
 *  !ANG:0.42,0.11,-10.35,
 *  !ANG:0.43,0.14,-10.40,
 *  !ANG:0.43,0.16,-10.44,
 *  !ANG:0.42,0.17,-10.49,
 *
 *  reference Quadrotor:
 *        x-                8 - 11 motors
 *   !8-m1 9-m2             A0 - IR distance sensor
 *      \   /        |‾
 *       \ /           \
 * y-     A0    y+  z+  |
 *       / \           /
 *      /   \
 *   11-m3 !10-m4
 *        x+
 ***********************************************************/
 
// MAKE REQUEST DRIVEN NOT IMU DATA DRIVEN (main cpu request data from IMU)

////////////////////////
//// Dashboard Data ////
////////////////////////
int loopCount = 0;
int updateFreq = 500;

/////////////////////////
//// Battery Voltage ////
/////////////////////////
double battVoltage;

//////////////////////////////
//// Heights from sensors ////
//////////////////////////////
double hBar;
double hIR;

/////////////////////////
//// Angles from IMU ////
/////////////////////////
double xAng;
double yAng;
double zAng;

////////////////////////
//// balance values ////
////////////////////////
double tRoll;  // throttle roll - x
double tPitch; // throttle pitch - y
double tYaw;   // throttle yaw - z

/////////////////////////////////
//// setpoint balance values ////
/////////////////////////////////
double roll = 0;   // desired roll - x
double pitch = 0;  // desired pitch - y
double yaw = 0;    // desired yaw - z
double height = 100; // desired height

////////////////////
//// PID Values ////
////////////////////
double kP = 0.4;
double kI = 0.5;
double kD = 0;
double kPagg = 0.8;
double kIagg = 0.5;
double kDagg = 0;
double kPheight = 0.2;
double kIheight = 0;
double kDheight = 0;

const long lowerLimit = -500; 
const long upperLimit = 500; // lowered for testing purposes

const float pidThreshold = 35.0;

const int pidSampleTime = 50;

PID xPid(&xAng, &tPitch, &pitch, kP, kI, kD, AUTOMATIC);
PID yPid(&yAng, &tRoll, &roll, kP, kI, kD, AUTOMATIC);
      // input, output, setPt, kP, kI, kD, direction (AUTOMATIC = reverse)

//////////////////////////      
//// QUADROTOR STATES ////
//////////////////////////
byte quadState = 1;
 
/////////////////////////////////      
//// Motor Controller Values ////
/////////////////////////////////
// Port Constants //
const int mp1 = 8;
const int mp2 = 9;
const int mp3 = 10;
const int mp4 = 11;
// Declare Motor Controllers// motor controllers work as servos*
Servo m1;
Servo m2;
Servo m3;
Servo m4;

// Output Vals //
float throttle;   //Base throttle
float mt1;        //PID added throttle
float mt2;
float mt3;
float mt4;

void setup() {
  // Open serial lines on 57600 baud //
  Serial.begin(57600);
  Serial1.begin(57600);
  Serial.write("WARNING: MOTORS MAY BE ALREADY INITIALIZED, UNPLUG BATTERY IF NECESSARY");
  delay(1000);
}

void loop() {
  //parseUserData();
  updateDashboard();
  pidMode();
  xPid.Compute();
  yPid.Compute();
  updateMotors();
}
