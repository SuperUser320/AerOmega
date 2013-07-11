
void parseUserData() {
  if(Serial.available()) {

    readUsrByte = byte(Serial.read());

    if (valueId != -1) {
      
      // Take state of quadrotor //
      if (dataIndex = 0) {
        quadState = readUsrByte;
        dataIndex++;
      }

      // EOL signified by byte of [B11111111] or [255] //
      if (readUsrByte == byte(255)) {
        dataIndex = 0;
      } 
      
      if (dataIndex > 0) {
        valueId = readUsrByte;
      }

    } else {

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
      
      valueId = -1;
      dataIndex++;
    }
  }
}
