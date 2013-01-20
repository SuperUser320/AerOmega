class Gimbal {

  int x, y, size;
  float angle = 0;
  boolean isCompass;
  boolean showPid;

  Gimbal (int tx, int ty, int tsize, boolean tisCompass, boolean tshowPid) {
    x = tx;
    y = ty;
    size = tsize;
    isCompass = tisCompass;
  }

  void updateAngle(float inAngle) {
    angle = (float) ((inAngle * Math.PI) / 180);

    strokeWeight(4);
    stroke(100);
    fill(200);
    ellipse(x, y, size, size);

    if (!isCompass) {

      noStroke();
      fill(25);
      arc(x, y, size * .98, size * .98, 0, PI);

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
      stroke(85);
      fill(85);
      triangle(-size/15, 0, 0, -size * 0.6, size/15, 0);
      stroke(175);
      fill(175);
      quad(-size/15, 0, 0, size * 0.6, size/15, 0, 0, -size * 0.05);
      popMatrix();
    }
  }

  void updatePidAngle(float pidAngle) {

    if (!isCompass) {
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(pidAngle);
      noStroke();
      fill(180, 80);
      triangle(-size * 0.6, 0, 0, -size/10, size * 0.6, 0);
      noStroke();
      fill(50, 80);
      triangle(-size * 0.6, 0, 0, size/10, size * 0.6, 0);
      popMatrix();
    } else {
      pushMatrix();
      strokeWeight(0);
      translate(x, y);
      rotate(pidAngle);
      noStroke();
      fill(85, 80);
      triangle(-size/15, 0, 0, -size * 0.6, size/15, 0);
      noStroke();
      fill(175, 68);
      quad(-size/15, 0, 0, size * 0.6, size/15, 0, 0, -size * 0.05);
      popMatrix();
    }
  }
}

