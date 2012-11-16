void land() {
  if (descentCounter > descentSpeed) {
    throttle -= 1;
    descentCounter = 0;
  }
  descentCounter++;
  
  if (throttle <= 0) {
    taskLand = 0;
  }
}

