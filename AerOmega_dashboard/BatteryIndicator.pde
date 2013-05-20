class BatteryIndicator {
  
  //Position variables
  float x, y, indicatorWidth, indicatorHeight;
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
  
  BatteryIndicator(int tx, int ty, int size) {
    x = tx;
    y = ty;
    indicatorWidth = size/ratio;
    indicatorHeight = size;
  }
  
  void displayBattery() {
    
    //Background Rectangle
    noStroke();
    fill(backgroundColor);
    rect(x + (indicatorWidth)/2 - indicatorHeight/8, y - ratio*2, indicatorHeight/4, ratio*2);
    rect(x, y, indicatorWidth, indicatorHeight);
    
    if(batteryPercent != 0) {
      
      if(batteryPercent <= alertThreshold) {
        fill(batteryAlertColor);
      } else {
        fill(batteryColor);
      }
      
      //Draw Battery Box
      rect(x, y + (indicatorHeight * (1 - batteryPercent)), indicatorWidth, indicatorHeight * batteryPercent);
      
      //Write battery percentage
      textFont(SegoeUI);
      text(int(batteryPercent * 100) + "%", x - textWidth(int(batteryPercent * 100) + "%") - indicatorHeight/10 , y + indicatorHeight);
    }
  }
  
  void calculatePercent() {
    ///////////////////////////
    //TODO: ADD PERCENT TEST //
    ///////////////////////////
  }
}
