
void parseUserData() {
  if(Serial.available()) {
    readUsrChar = String(char(Serial.read()));

    if (readUsrChar == ":") {
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
  switch(dataIndex - 1) {
  case 0:

    throttle = int(tmpUsrStr.toFloat());

    break;

  case 1:

    break;
   
  case 2:

     if(int(tmpUsrStr.toFloat()) == 1) {
     
       initMotors();
       
     }

    break;
  }
}


