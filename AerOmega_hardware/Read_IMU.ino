
//////////////////////////////////
//// Used in parsing IMU data ////
//////////////////////////////////
String tmpStr;
String newTmpStr;
String readChar;
int dataIndexAng; // 0-do nothing; 1-xAng; 2-yAng; 3-zAng;

void serialEvent1(){
  // only run if imu data is available else idle or parse data // make main cpu request data later //
  while(Serial1.available()) {
    readChar = String(char(Serial1.read()));
    // start looking for data after ':' //
    if(readChar == ":") {
      dataIndexAng = 0;
      readChar = "";
      storeVal();
      tmpStr = "";
    }
    // look for new data after ','s //
    if(readChar == ",") {
      dataIndexAng++;
      readChar = "";
      storeVal();
      tmpStr = "";
    }
    // throw away data after index of 2 //
    if(dataIndexAng < 3) {
      tmpStr += readChar;
    }
  }
}

//// Store values read from IMU ////
void storeVal() {
  switch(dataIndexAng - 1) {
  case 0:

    xAng = -double(tmpStr.toFloat());     // all axies are negated from IMU to match silkscreen

    break;

  case 1:

    yAng = -double(tmpStr.toFloat());

    break;

  case 2:
    
    zAng = -double(tmpStr.toFloat());

    break;
  }
}
