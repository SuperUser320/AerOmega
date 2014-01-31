//////////////////////////
//// Parse User Input ////
//////////////////////////
int dataIndex;
boolean readUsrBool;
byte readUsrByte;
int readUsrInt;
float readUsrFloat;
double readUsrDouble;
String readUsrChar;
byte valueId = -1;
// each location represents an id and datatype associated //
byte dataType [] = {0,0,4,4,4,4,4,4};
// 0  initialize motors
// 1  enable/disable
// 2  kP
// 3  kI
// 4  kD
// 5  kPagg
// 6  kIagg
// 7  kDagg
// 8  kPheight
// 9  kIheight
// 10 kDheight

void SearialEvent() {
  
    Serial.println("RECIEVED:");
  if(Serial.available()) {

    readUsrByte = byte(Serial.read());

    if (valueId == -1) {

      // Take state of quadrotor //
      if (dataIndex = 0) {
        quadState = readUsrByte;
        dataIndex++;
        Serial.println("RECIEVED:");
        Serial.println(readUsrByte);
      }

      // EOL signified by byte of [B11111111] or [255] //
      if (readUsrByte == byte(255)) {
        dataIndex = 0;
      } 

      if (dataIndex > 0) {
        valueId = readUsrByte;
      }

    } 
    else {

      switch(dataType[valueId]) {
      case 0:
        readUsrBool = boolean(Serial.read());
        break;

      case 1:
        readUsrByte = byte(Serial.read());
        break;

      case 2:
        readUsrInt = int(Serial.read());
        break;

      case 3:
        readUsrFloat = float(Serial.read());
        break;

      case 4:
        readUsrDouble = double(Serial.read());
        break;

      case 5:
        readUsrChar = String(char(Serial.read())); 
        break;
      }

      storeVals();

      valueId = -1;
      dataIndex++;
    }
  }
}

void storeVals() {
  switch(valueId) {
  case 0:
    if (readUsrBool) {
      initMotors();
      initPids();
    }
    break;

  case 1:
    if (readUsrBool) {
      quadState = 2;
    } 
    else {
      quadState = 1;
    }
    break;

  case 2:
    kP = readUsrDouble;
    break;

  case 3:
    kI = readUsrDouble;
    break;

  case 4:
    kD = readUsrDouble;
    break;

  case 5:
    kPagg = readUsrDouble;
    break;

  case 6:
    kIagg = readUsrDouble;
    break;

  case 7:
    kDagg = readUsrDouble;
    break;

  case 8:
    kPheight = readUsrDouble;
    break;

  case 9:
    kIheight = readUsrDouble;
    break;

  case 10:
    kDheight = readUsrDouble;
    break;
  }

  if (valueId >= 2) {
    xPid.SetTunings(kP,kI,kD);
    yPid.SetTunings(kP,kI,kD);
  }
}


