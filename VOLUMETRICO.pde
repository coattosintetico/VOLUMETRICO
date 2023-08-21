PImage img;

int NO_OF_TILES = 60;
int tileSize;

float[][] terrain;

void setup() {
  size(720, 720, P3D);
  img = loadImage("clean_sqr.jpg");
  // img.resize(480, 854);

  img.filter(GRAY);
  img = enhanceContrast(img, 2);

  tileSize = round(width / NO_OF_TILES);

  terrain = new float[NO_OF_TILES][NO_OF_TILES];
  for (int x = 0; x < NO_OF_TILES; x++) {
    for (int y = 0; y < NO_OF_TILES; y++) {
      float tileX = tileSize * x + tileSize * 1/2; // careful here with what do I multiply - it can round numbers
      float tileY = tileSize * y + tileSize * 1/2;
      color tileColor = img.get(int(tileX), int(tileY));
      float b = map(brightness(tileColor), 0, 255, 1.5, 0);
      float z = map(b, 0, 1, -100, 100);
      terrain[x][y] = z;
    }
  }}

void draw() {
  background(0);
  // image(img, 0, 0);

  directionalLight(255, 255, 255, -1, 0, -1);
  pushMatrix();
  translate(width/2, height/2);
  rotateY(radians(frameCount));

  triangulize(terrain, tileSize);

  // for (int x = 0; x < NO_OF_TILES; x++) {
  //   for (int y = 0; y < NO_OF_TILES; y++) {
  //     float tileX = tileSize * x + tileSize * 1/2; // careful here with what do I multiply - it can round numbers
  //     float tileY = tileSize * y + tileSize * 1/2;
  //     color tileColor = img.get(int(tileX), int(tileY));
  //     float b = map(brightness(tileColor), 0, 255, 1.5, 0);
  //     float z = map(b, 0, 1, -100, 100);
  //     // why can't i do this offset with translate?
  //     // pushMatrix();
  //     stroke(0);
  //     strokeWeight(tileSize*b);
  //     point(tileX-width/2, tileY-height/2, z);
  //     // popMatrix();
  //   }
  // }

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


void triangulize(float[][] terrain, float tileSize) {
  /*
    Draws a mesh of points with triangle shapes, using the terrain as the z 
    values. It recenters the triangle, assuming that a translation to the
    middle of the screen has been made.
  */
  int cols = terrain.length;
  int rows = terrain[0].length;
  for (int x = 0; x < cols-1; x++) {
    for (int y = 0; y < rows-1; y++) {
      fill(220);
      strokeWeight(1);
      noStroke();
      beginShape(TRIANGLE_STRIP);
      float s = tileSize;
      vertex(x    *s - width/2, y    *s - height/2, terrain[x  ][y  ]);
      vertex((x+1)*s - width/2, y    *s - height/2, terrain[x+1][y  ]);
      vertex(x    *s - width/2, (y+1)*s - height/2, terrain[x  ][y+1]);
      vertex((x+1)*s - width/2, (y+1)*s - height/2, terrain[x+1][y+1]);
      endShape();
    }
  }
}