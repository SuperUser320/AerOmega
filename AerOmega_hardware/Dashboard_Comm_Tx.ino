////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  case:                                                                                           Communication Example:     (to dashboard)                                                                                                                     ////
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
int feedbackCase = 1; //0 = debugFullHuman, 1 = debugFull, 2 = normal, 3 = normal w/o timestamp

void updateDashboard() {
  if (loopCount > updateFreq) {
    switch (feedbackCase) {
    
    case 0:
      Serial.print("state: ");
      Serial.print(quadState);
      Serial.print("\t");
      
      Serial.print("xAng: ");
      Serial.print(xAng);
      Serial.print("\t");
      Serial.print("yAng: ");
      Serial.print(yAng);
      Serial.print("\t");
      Serial.print("zAng: ");
      Serial.print(zAng);
      Serial.print("\t");
      
      Serial.print("m1: ");
      Serial.print("\t");
      Serial.print(mt1);
      Serial.print("\t");
      Serial.print("m2: ");
      Serial.print(mt2);
      Serial.print("\t");
      Serial.print("m3: ");
      Serial.print(mt3);
      Serial.print("\t");
      Serial.print("m4: ");
      Serial.print(mt4);
      Serial.print("\t");
  
      Serial.print("hBar: ");
      Serial.print(hBar);
      Serial.print("\t");
      Serial.print("hIR: ");
      Serial.print(hIR);
      Serial.print("\t");
  
      Serial.print("bat: ");
      Serial.print(battVoltage);
      Serial.print("\t");
      
      Serial.print(",throt: ");
      Serial.print(throttle);
      Serial.print("\t");
      Serial.print(",tR: ");
      Serial.print(tRoll);
      Serial.print("\t");
      Serial.print(",tP: ");
      Serial.print(tPitch);
      Serial.print("\t");
      Serial.print(",tH: ");
      Serial.print(tYaw);
      Serial.print("\t");
      
      Serial.print(",kP: ");
      Serial.print(kP);
      Serial.print("\t");
      Serial.print(",kI: ");
      Serial.print(kI);
      Serial.print("\t");
      Serial.print(",kD: ");
      Serial.print(kD);
      Serial.print("\t");
      Serial.print(",kPa: ");
      Serial.print(kPagg);
      Serial.print("\t");
      Serial.print(",kIa: ");
      Serial.print(kIagg);
      Serial.print("\t");
      Serial.print(",kDa: ");
      Serial.print(kDagg);
      Serial.print("\t");
      Serial.print(",kPh: ");
      Serial.print(kPheight);
      Serial.print("\t");
      Serial.print(",kIh: ");
      Serial.print(kIheight);
      Serial.print("\t");
      Serial.print(",kDh: ");
      Serial.print(kDheight);
      Serial.print("\t");
      
      Serial.print(millis());
      Serial.println();
    break;
    
    case 1:
      Serial.print(quadState);
      Serial.print("\t");
      
      Serial.print(xAng);
      Serial.print("\t");
      Serial.print(yAng);
      Serial.print("\t");
      Serial.print(zAng);
      Serial.print("\t");
      
      Serial.print(mt1);
      Serial.print("\t");
      Serial.print(mt2);
      Serial.print("\t");
      Serial.print(mt3);
      Serial.print("\t");
      Serial.print(mt4);
      Serial.print("\t");

      Serial.print(hBar);
      Serial.print("\t");
      Serial.print(hIR);
      Serial.print("\t");
  
      Serial.print(battVoltage);
      Serial.print("\t");
      
      Serial.print(throttle);
      Serial.print("\t");
      Serial.print(tRoll);
      Serial.print("\t");
      Serial.print(tPitch);
      Serial.print("\t");
      Serial.print(tYaw);
      Serial.print("\t");
      
      Serial.print(kP);
      Serial.print("\t");
      Serial.print(kI);
      Serial.print("\t");
      Serial.print(kD);
      Serial.print("\t");
      Serial.print(kPagg);
      Serial.print("\t");
      Serial.print(kIagg);
      Serial.print("\t");
      Serial.print(kDagg);
      Serial.print("\t");
      Serial.print(kPheight);
      Serial.print("\t");
      Serial.print(kIheight);
      Serial.print("\t");
      Serial.print(kDheight);
      Serial.print("\t");
      
      Serial.print(millis());
      Serial.println();
    break;
    
    case 2:
      Serial.print(quadState);
      Serial.print("\t");
      
      Serial.print(xAng);
      Serial.print("\t");
      Serial.print(yAng);
      Serial.print("\t");
      Serial.print(zAng);
      Serial.print("\t");
      
      Serial.print(mt1);
      Serial.print("\t");
      Serial.print(mt2);
      Serial.print("\t");
      Serial.print(mt3);
      Serial.print("\t");
      Serial.print(mt4);
      Serial.print("\t");

      Serial.print(hBar);
      Serial.print("\t");
      Serial.print(hIR);
      Serial.print("\t");
  
      Serial.print(battVoltage);
      Serial.print("\t");
      
      Serial.print(millis());
      Serial.println();
    break;
    
    case 3:
      Serial.print(quadState);
      Serial.print("\t");
      
      Serial.print(xAng);
      Serial.print("\t");
      Serial.print(yAng);
      Serial.print("\t");
      Serial.print(zAng);
      Serial.print("\t");
      
      Serial.print(mt1);
      Serial.print("\t");
      Serial.print(mt2);
      Serial.print("\t");
      Serial.print(mt3);
      Serial.print("\t");
      Serial.print(mt4);
      Serial.print("\t");

      Serial.print(hBar);
      Serial.print("\t");
      Serial.print(hIR);
      Serial.print("\t");
  
      Serial.print(battVoltage);
      Serial.print("\t");
      
      Serial.println();
    break;
    }
    
    loopCount = 0;
  }
  loopCount++;
}


