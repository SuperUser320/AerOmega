class GuiQuad {
  
  //Location variables
  int x, y, size;
  
  GuiQuad(int tx, int ty, int tsize) {
    x = tx;
    y = ty;
    size = tsize;
  }
  
  void draw3dQuad() {
    
  }
  
  void draw2dQuad() {
    //Only useful for displaying motor value visualization
    stroke(255);
    strokeWeight(7);
    line(x, y, x + size, y + size);
    line(x, y + size, x + size, y);
    stroke(0);
    strokeWeight(1);
    fill(100);
    rect(x + (size / 3), y + (size / 3), size / 3, size / 3);
    fill(200);
    arc(x, y, size / 3, size / 3, 0, (mt1/1000) * TWO_PI);
    arc(x + size, y, size / 3, size / 3, 0, (mt2/1000) * TWO_PI);
    arc(x, y + size, size / 3, size / 3, 0, (mt3/1000) * TWO_PI);
    arc(x + size, y + size, size / 3, size / 3, 0, (mt4/1000) * TWO_PI);
  }  
}
