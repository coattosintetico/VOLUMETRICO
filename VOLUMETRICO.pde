PImage img;

int NO_OF_TILES_W = 40;
int NO_OF_TILES_H = 71;
int tileWidth, tileHeight;

float factor = 2;

void setup() {
  size(480, 854);
  img = loadImage("clean.jpg");
  img.resize(480, 854);

  tileWidth = round(width / NO_OF_TILES_W);
  tileHeight = round(height / NO_OF_TILES_H);
}

void draw() {
  background(220);
  factor = map(mouseX, 0, width, 0.5, 5);

  for (int x = 0; x < NO_OF_TILES_W; x++) {
    for (int y = 0; y < NO_OF_TILES_H; y++) {
      int tileX = tileWidth * x + tileWidth * 1/2; // careful here with what do I multiply - it can round numbers
      int tileY = tileHeight * y + tileHeight * 1/2;
      int tileColor = img.get(tileX, tileY);
      fill(tileColor);
      noStroke();
      rectMode(CENTER);
      rect(tileX, tileY, tileWidth/factor, tileHeight/factor);
    }
  }
}
