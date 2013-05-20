class BatteryIndicator {
  
  //Position variables
  int x, y, size;
  float ratio = 1.5;
  
  //Data variables
  int batteryVoltage;
  float batteryPercent;
  
  //Color variables
  color batteryColor = color(160);
  color backgroundColor = color(80);
  color batteryAlertColor = color(215, 60, 60);
  
  //Threshold variables
  float alertThreshold = .2;
  
  BatteryIndicator(int tx, int ty, int tsize) {
    x = tx;
    y = ty;
    size = tsize;
  }
  
  void displayBattery() {
    
    //Background Rectangle
    noStroke();
    fill(backgroundColor);
    rect(x + (size/ratio)/2 - size/8, y - ratio*2, size/4, ratio*2);
    rect(x, y, size/ratio, size);
    
    if(batteryPercent != 0) {
      
      if(batteryPercent <= alertThreshold) {
        fill(batteryAlertColor);
      } else {
        fill(batteryColor);
      }
      
      //Draw Battery Box
      rect(x, y + (size * (1 - batteryPercent)), size/ratio, size * batteryPercent);
      
      //Write battery percentage
      textFont(SegoeUI);
      text(int(batteryPercent * 100) + "%", x - textWidth(int(batteryPercent * 100) + "%") - size/10 , y + size);
    }
  }
  
  void calculatePercent() {
    ///////////////////////////
    //TODO: ADD PERCENT TEST //
    ///////////////////////////
  }
}
