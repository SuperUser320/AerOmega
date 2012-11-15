/////////////////.///////
//// initializations ////
/////////////////////////

void initPids() {
  xPid.SetOutputLimits(lowerLimit, upperLimit);
  yPid.SetOutputLimits(lowerLimit, upperLimit);
  
  xPid.SetSampleTime(pidSampleTime);
  yPid.SetSampleTime(pidSampleTime);
  
  xPid.SetMode(AUTOMATIC);
  yPid.SetMode(AUTOMATIC);
}

void initMotors() {
  // Open Servo lines (for motor controller) //
  m1.attach(9);
  m2.attach(10);
  m3.attach(11);
  m4.attach(12);

  m1.writeMicroseconds(1000);
  m2.writeMicroseconds(1000);
  m3.writeMicroseconds(1000);
  m4.writeMicroseconds(1000);

  Serial.println("Attach main battery (15s)");
  int i = 0;
  while( i < 10)
  {
    if(i%2 == 0) {
      analogWrite(13, 255);
    } 
    else {
      analogWrite(13, 0);
    }
    i++;
    delay(1000);
  }
  i = 0;
  while( i < 10)
  {
    if(i%2 == 0) {
      analogWrite(13, 255);
    } 
    else {
      analogWrite(13, 0);
    }
    i++;
    delay(500);
  }
  analogWrite(13, 255);
  Serial.println("Arming ESCs (2s)");

  m1.writeMicroseconds(2000);
  m2.writeMicroseconds(2000);
  m3.writeMicroseconds(2000);
  m4.writeMicroseconds(2000);

  delay(2000);

  m1.writeMicroseconds(1000);
  m2.writeMicroseconds(1000);
  m3.writeMicroseconds(1000);
  m4.writeMicroseconds(1000);

  delay(1000);
  analogWrite(13, 0);
  Serial.println("ESCs are armed!!!"); 
}

/////////////////////////
//// change pid mode ////
/////////////////////////

// Constantly setting pidThreashold may cause slower loop time //
void pidMode() {
  // calculations for roll //
  if (abs(roll - xAng) > pidThreshold) {
    xPid.SetTunings(kPagg, kIagg, kDagg);
  } 
  else {
    xPid.SetTunings(kP, kI, kD);
  }

  // calculations for pitch //
  if (abs(pitch - yAng) > pidThreshold) {
    xPid.SetTunings(kPagg, kIagg, kDagg);
  } 
  else {
    xPid.SetTunings(kP, kI, kD);
  }
}

///////////////////////////
//// set motor outputs ////
///////////////////////////

void updateMotors() {
  // calculate throttle // normalize values to keep under 255?
  mt1 = (+tPitch +tRoll) + throttle;
  mt2 = (+tPitch -tRoll) + throttle;
  mt3 = (-tPitch +tRoll) + throttle;
  mt4 = (-tPitch -tRoll) + throttle;

  m1.write(int(mt1) + 1000);
  m2.write(int(mt2) + 1000);
  m3.write(int(mt3) + 1000);
  m4.write(int(mt4) + 1000); 
}
