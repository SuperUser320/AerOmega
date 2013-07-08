////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////  case:                                                                                           Communication Example:                                                                                                                                        ////
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
    // throw away data after index of 2 //
    if (dataIndex < 11 || readChar == ' ') {
      tmpStr += readChar;
    }
  }
}

//// Store values read from IMU ////
void storeVal() {
  switch(dataIndex - 1) {
  case 0:

    yAng = float(tmpStr);     // x and y axies are switched //

    break;

  case 1:

    xAng = float(tmpStr);

    break;

  case 2:

    zAng = float(tmpStr);

    break;

  case 3:

    mt1 = float(tmpStr);

    break;

  case 4:

    mt2 = float(tmpStr);

    break;

  case 5:

    mt3 = float(tmpStr);

    break;

  case 6:

    mt4 = float(tmpStr);

    break;
  }
}

void sendData()
{
  arduino.write("DAT:" + ((10 * throttle) + 1000) + ",");
}

