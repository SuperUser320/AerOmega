
void serialEvent(Serial arduino) {
  
  // only run if imu data is available else idle or parse data // make main cpu request data later //
  if (arduino.available() > 0) {
    readChar = char(arduino.read());
    // start looking for data after '\n' //
    if (readChar == '\n') {
      dataIndex = 0;
      readChar = ' ';
      storeVal();
      tmpStr = "";
    }
    // look for new data after ':'s //
    if (readChar == ':') {
      dataIndex++;
      readChar = ' ';
      tmpStr = "";
    }
    if (readChar == ',') {
      readChar = ' ';
      storeVal();
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

