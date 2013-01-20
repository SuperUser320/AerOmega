class Gimbal {

  int x, y, size;
  float angle = 0;
  boolean isCompass;

  Gimbal (int tx, int ty, int tsize, boolean tisCompass) {
    x = tx;
    y = ty;
    size = tsize;
    isCompass = tisCompass;
  }

  void update(float inAngle) {
    angle = (float) ((inAngle * Math.PI) / 180);

    strokeWeight(4);
    stroke(100);
    fill(200);
    ellipse(x, y, size, size);

    if (!isCompass) {
      
      noStroke();
      fill(25);
      arc(x, y, size * .99, size * .99, 0, PI);
      
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(angle);
      stroke(180);
      fill(180);
      triangle(-size * 0.6, 0, 0, -size/10, size * 0.6, 0);
      stroke(50);
      fill(50);
      triangle(-size * 0.6, 0, 0, size/10, size * 0.6, 0);
      popMatrix();
      
    } else {
      
      textFont(SegoeUI);
      text("N", x - (textWidth("N") / 2), y - (size/2) - (size * 0.1));
      text("S", x - (textWidth("S") / 2), y + (size/2) + (size * 0.2));
      
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(angle);
      stroke(175);
      fill(175);
      triangle(-size/15, 0, 0, size * 0.6, size/15, 0);
      stroke(85);
      fill(85);
      triangle(-size/15, 0, 0, -size * 0.6, size/15, 0);
      stroke(175);
      fill(175);
      triangle(-size/15, 0, 0, -size * 0.05, size/15, 0);
      popMatrix();
    }
  }
}

