/*class SignalIndicator {

  int x, y, indicatorWidth, indicatorHeight;
  
  SignalIndicator() {
    
    
    
  }
  
  void displaySignal() {
    if (dataRecieved && loopCount < updateFreq) {
      
      loopCount++;
      
    } else {
      loopCount = 0;
      if (arduino.available() > 0) {
        fill(0, 255, 0);
        dataRecieved = true;
        println("blah");
      } else {
        fill(215, 60, 60);
        dataRecieved = false;
      }
    }
    rect(width - 50, 10, 40, 40);
  }
}*/
