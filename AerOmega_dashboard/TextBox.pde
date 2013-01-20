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
    stroke(0);
    fill(0);
  }
}

