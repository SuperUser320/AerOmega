
void parseUserData() {
  if(Serial.available()) {
    readUsrChar = String(char(Serial.read()));

    if (readUsrChar == "\n") {
      dataIndex = 0;
      readUsrChar = "";
      storeUserVal();
      tmpUsrStr = "";
    }
    if (readUsrChar == ",") {
      dataIndex++;
      readUsrChar = "";
      storeUserVal();
      tmpUsrStr = "";
    }
    if (dataIndex < 3) {
      tmpUsrStr += readUsrChar;
    }
  }
}

//// Store values read from IMU ////
void storeUserVal() {
  switch(dataIndex) {
  case 0:

    eStop = int(tmpUsrStr.toFloat());

    break;
  }
}


