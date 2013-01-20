class TextBox {


  int x, y, w, h;
  boolean selectable;

  TextBox(int tx, int ty, int tw, int th, boolean tselectable) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
    selectable = tselectable;
  }
  
  void update (String inputText) {
    strokeWeight(1);
    stroke(200);
    fill(50);
    if (w == 0) {
      w = int(textWidth(inputText) + 10);
    }
    rect(x, y , w, h);
    fill(255);
    text(inputText, x - 5 + w - int(textWidth(inputText)), y + h - 2);
  }
}

