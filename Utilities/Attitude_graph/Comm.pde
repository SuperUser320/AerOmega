
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
  if (!useImu) {
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
  } else {
    if (arduino.available() > 0) {
      readChar = char(arduino.read());
      print(readChar);
      // start looking for data after '\n' //
      if (readChar == ':') {
        dataIndex = 0;
        readChar = ' ';
        storeVal();
        tmpStr = "";
      }
      // look for new data after ':'s //
      if (readChar == ',') {
        dataIndex++;
        storeVal();
        readChar = ' ';
        tmpStr = "";
      }
      // throw away data after index of 2 //
      if (dataIndex < 3 || readChar == ' ') {
        tmpStr += readChar;
      }
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
  }
}

