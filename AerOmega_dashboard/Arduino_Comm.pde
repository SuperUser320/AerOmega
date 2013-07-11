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

void serialEvent(Serial arduino) {
  // only run if imu data is available else idle or parse data // make main cpu request data later //
  if (arduino.available() > 0) {
    readChar = char(arduino.read());
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
void storeVal() {
  switch(dataIndex) {
  case 0:
    feedbackCase = int(tmpStr);
    break;
    
  ////  Attitude Feedback ////
  case 1:
    yAng = float(tmpStr);     // x and y axies are switched //
    break;

  case 2:
    xAng = float(tmpStr);
    break;

  case 3:
    zAng = float(tmpStr);
    break;


  ////  Motor Outputs ////
  case 4:
    mt1 = float(tmpStr);
    break;

  case 5:
    mt2 = float(tmpStr);
    break;

  case 6:
    mt3 = float(tmpStr);
    break;

  case 7:
    mt4 = float(tmpStr);
    break;
    

  //// Sensor Altitidue ////
  case 8:
    heightBar = float(tmpStr);
    break;

  case 9:
    heightIr = float(tmpStr);
    break;
  

  //// Battery Feedback ////
  case 10:
    battVoltage = float(tmpStr);
    break;
    
    
  //// PID Setpoints ////
  case 11:
    pHeight = float(tmpStr);
    break;
    
  case 12:
    pxAng = float(tmpStr);
    break;
    
  case 13:
    pyAng = float(tmpStr);
    break;
  
  case 14:
    pzAng = float(tmpStr);
    break;
    
    
  //// PID Parameters ////
  case 15:
    kP = float(tmpStr);
    break;
    
  case 16:
    kI = float(tmpStr);
    break;
    
  case 17:
    kD = float(tmpStr);
    break;
    
  case 18:
    kPagg = float(tmpStr);
    break;
    
  case 19:
    kIagg = float(tmpStr);
    break;
    
  case 20:
    kDagg = float(tmpStr);
    break;
    
  case 21:
    kPheight = float(tmpStr);
    break;
    
  case 22:
    kIheight = float(tmpStr);
    break;
    
  case 23:
    kDheight = float(tmpStr);
    break;  
    
  case 24:
    upTime = float(tmpStr);
    break;
  }
}

void sendData()
{
    if(connectionEst) {
      //// If e-stop is enabled continuously resend '0' line ////
      if(eStopButton.buttonLocked()) {
        arduino.write(byte(0));
        arduino.write(byte(255));
        println("SENT E-STOP");
      }
      
      //// Continue to operate normally ////
      arduino.write("1");
  }
}
