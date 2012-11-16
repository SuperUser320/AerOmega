void updateDashboard() {
  if (loopCount > updateFreq) {
    Serial.print("xAng: ");
    Serial.print(xAng);
    Serial.print(",yAng: ");
    Serial.print(yAng);
    Serial.print(",zAng: ");
    Serial.print(zAng);

    Serial.print(",throttle: ");
    Serial.print(throttle);
    Serial.print(",tRoll: ");
    Serial.print(tRoll);
    Serial.print(",tPitch: ");
    Serial.print(tPitch);

    Serial.print(",m1: ");
    Serial.print(mt1);
    Serial.print(",m2:");
    Serial.print(mt2);
    Serial.print(",m3: ");
    Serial.print(mt3);
    Serial.print(",m4: ");
    Serial.print(mt4);

    Serial.print(",millis: ");
    Serial.print(millis());

    Serial.print(",taskLand: ");
    Serial.print(taskLand);

    Serial.println();
    loopCount = 0;
  }
  loopCount++;
}


