
import geomerative.*;
import oscP5.*;
import java.util.Calendar;

Muse muse;
NeuroFont neuroFont;

void setup () {
  size(1920, 1080, P2D);
  smooth();

  RG.init(this);

  neuroFont = new NeuroFont("Roboto-Medium.ttf", 124);
  muse = new Muse(5000);
  
  background(0);
}

void draw () {
  noStroke();
  fill(0, 110);
  rect(0, 0, width, height);

  updateFont();

  drawSpecimen();
  muse.drawSignals(576, height * 0.8, width * 0.4, 180);
}

void keyPressed () {
  if (key == 's' || key == 'S') {
    neuroFont.save("roboto-" + timestamp(), "glyph-");
  }
}

void updateFont() {

  if (muse.status.isTouchingForehead) {

    // Get data
    float delta         = muse.getDelta();
    float theta         = muse.getTheta();
    float alpha         = muse.getAlpha();
    float beta          = muse.getBeta();
    float gamma         = muse.getGamma();
    float concentration = muse.getConcentration();
    float mellow        = muse.getMellow();

    // Concentration level
    float segmentLen = map(concentration, 0, 100, 7.0, 4.0);
    RCommand.setSegmentLength(segmentLen);
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

    // Process alpha block (stress level)
    float stress = muse.getStressLevel(alpha, beta);
    neuroFont.noiseStep  = map(abs(beta), 0.0, 1.0, 1.0, 16.0);
    neuroFont.noiseScale = map(stress, 0.0, 10.0, 1.0, 5.0);

    // Delta, Theta
    neuroFont.offsetX = map(abs(gamma), 0.0, 1.0, 0.03, 0.07);
    neuroFont.offsetY = map(abs(theta), 0.0, 1.0, 0.04, 0.06);

    // Mellow level
    neuroFont.ampSin = map(mellow, 0, 100, 0.5, 4.0);
    neuroFont.ampCos = map(abs(alpha), 0, 1.0, 0.5, 8.0);
  }

  neuroFont.update();
}

void drawSpecimen () {

  pushMatrix();
  translate(220, 220);

  stroke(255);
  strokeWeight(2.0);
  fill(255, 15);

  // First row
  float x = 0, y = 0;
  for (int i = 0; i < 26; i++) {
    if (x > (width - 440)) {
      x = 200;
      y += 118;
    }

    pushMatrix();
    translate(x, y);

    neuroFont.shapes[i].draw();

    popMatrix();

    x += 100;
  }

  // Second row
  x = 0; 
  y += 160;
  for (int i = 26; i < 52; i++) {
    if (x > (width - 440)) {
      x = 200;
      y += 118;
    }

    pushMatrix();
    translate(x, y);

    neuroFont.shapes[i].draw();

    popMatrix();

    x += 100;
  }

  // Third row
  x = 0; 
  y += 160;
  for (int i = 52; i < 67; i++) {
    if (x > (width - 440)) {
      x = 200;
    }

    pushMatrix();
    translate(x, y);

    neuroFont.shapes[i].draw();

    popMatrix();

    x += 100;
  }

  popMatrix();
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
