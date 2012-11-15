
void parseImuData() {
  // only run if imu data is available else idle or parse data // make main cpu request data later //
  if(Serial1.available()) {
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

    yAng = double(tmpStr.toFloat());     // x and y axies are switched //

    break;

  case 1:

    xAng = double(tmpStr.toFloat());

    break;

  case 2:
    
    zAng = double(tmpStr.toFloat());

    break;
  }
}
