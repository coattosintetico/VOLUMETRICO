PImage img;

int NO_OF_TILES_W = 60;
int NO_OF_TILES_H = 107;
int tileWidth, tileHeight;

void setup() {
  size(480, 854, P3D);
  img = loadImage("clean.jpg");
  img.resize(480, 854);

  img.filter(GRAY);
  img = enhanceContrast(img, 2);

  // would the number of tiles affect a lot in this rounding?
  tileWidth = round(width / NO_OF_TILES_W);
  // fix this: tile size varies a lot
  tileHeight = 8;//round(height / NO_OF_TILES_H);
}

void draw() {
  background(220);
  // image(img, 0, 0);

  pushMatrix();
  translate(width/2, height/2);
  rotateY(radians(frameCount));

  /*
    Ahora quiero simplificar todo esto y generar un mesh de puntos dado por la imagen, donde el valor de z sea el brightness
  */

  float contrast = map(mouseX, 0, width, 1, 3);
  for (int x = 0; x < NO_OF_TILES_W; x++) {
    for (int y = 0; y < NO_OF_TILES_H; y++) {
      float tileX = tileWidth * x + tileWidth * 1/2; // careful here with what do I multiply - it can round numbers
      float tileY = tileHeight * y + tileHeight * 1/2;
      color tileColor = img.get(int(tileX), int(tileY));
      float b = map(brightness(tileColor), 0, 255, 1, 0);
      float z = map(b, 0, 1, -100, 100);
      noStroke();
      fill(0);
      ellipseMode(CENTER);
      // why can't i do this offset with translate?
      pushMatrix();
      translate(0, 0, z);
      ellipse(tileX-width/2, tileY-height/2, tileWidth*b, tileHeight*b);
      popMatrix();
    }
  }

  popMatrix();
}

PImage enhanceContrast(PImage orig, float parameter) {
  PImage img = createImage(orig.width, orig.height, RGB);
  img.copy(orig, 0, 0, orig.width, orig.height, 0, 0, orig.width, orig.height);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    float avg = (red(img.pixels[i]) + green(img.pixels[i]) + blue(img.pixels[i])) / 3.0;
    avg = (((avg - 128) * parameter) + 128);
    avg = constrain(avg, 0, 255);
    img.pixels[i] = color(avg);
  }
  img.updatePixels();
  return img;
}
