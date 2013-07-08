void keyPressed() {
  if(!keyDown) {
    keyDown = true;
    if(key == ' ') {
      eStopButton.lock(true);
      //////////////////////////////
      //TODO: WRITE CODE TO E-STOP//
      //////////////////////////////
    }
    if(key == '\n') {
      stateButton.toggle();
      //////////////////////////////
      //TODO: WRITE CODE TO E-STOP//
      //////////////////////////////
    }
  }
}
void keyReleased() {
  keyDown = false;
}
