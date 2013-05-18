class TextBox {

  int x, y, w, h;
  String label;
  
  boolean selectable;
  boolean fitText;

  TextBox(int tx, int ty, int tw, int th, boolean tselectable, String tlabel) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
    selectable = tselectable;
    label = tlabel;
  }
  
  TextBox(int tx, int ty, boolean tselectable, String tlabel) {
    x = tx;
    y = ty;
    selectable = tselectable;
    fitText = true;
    label = tlabel;
  }
  
  void update (String inputText) {
    textFont(SegoeUI);
    if(fitText) {
      //Calculate width and height
      w = int(textWidth(inputText));
      h = 20;
    }
    //Draw box
    strokeWeight(1);
    stroke(200);
    fill(50);
    if (w == 0) {
      w = int(textWidth(inputText) + 10);
    }
    rect(x - 4, y , w + 6, h);
    fill(255);
    text(label, x - textWidth(label) - 5, y + h - 2);
    text(inputText, x + w - int(textWidth(inputText)), y + h - 2);
  }
}

