PImage img;
PImage origImg;

int[] NO_OF_TILES = {120, 214};
int tileSize = 4;

float[][] terrain;
color[][] terrainColors;
float MAX_Z = 10;

void setup() {
  size(480, 854, P3D);
  img = loadImage("cazorla.jpg");
  origImg = loadImage("cazorla.jpg");
  img.resize(480, 854);
  origImg.resize(480, 854);

  img.filter(GRAY);
  img = enhanceContrast(img, 2);

  terrain = new float[NO_OF_TILES[0]][NO_OF_TILES[1]];
  terrainColors = new color[NO_OF_TILES[0]][NO_OF_TILES[1]];

  for (int i = 0; i < NO_OF_TILES[0]; i++) {
    for (int j = 0; j < NO_OF_TILES[1]; j++) {
      float tileX = tileSize * i + tileSize * 1/2; // careful here with what do I multiply - it can round numbers
      float tileY = tileSize * j + tileSize * 1/2;
      color tileColor = img.get(int(tileX), int(tileY));
      float b = map(brightness(tileColor), 0, 255, 1, 0);
      float z = map(b, 0, 1, -MAX_Z*2, MAX_Z*2);
      terrain[i][j] = z;
      terrainColors[i][j] = origImg.get(int(tileX), int(tileY));
    }
  }
}

void draw() {
  background(0);
  // image(img, 0, 0);

  directionalLight(255, 255, 255, -1, 0, -1);

  pushMatrix();
  translate(width/2, height/2);
  rotateY(radians(frameCount*0.5));

  triangulize(terrain, terrainColors, tileSize);

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


void triangulize(float[][] terrain, color[][] terrainColors, float tileSize) {
  /*
    Draws a mesh of points with triangle shapes, using the terrain as the z 
    values. It recenters the triangle, assuming that a translation to the
    middle of the screen has been made.
    Asumes the tiles have the same width and height.
  */
  int cols = terrain.length;
  int rows = terrain[0].length;
  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      fill(terrainColors[i][j]);
      strokeWeight(1);
      noStroke();
      beginShape(TRIANGLE_STRIP);
      float x   =  i   *tileSize - width/2;
      float xP1 = (i+1)*tileSize - width/2;
      float y   =  j   *tileSize - height/2;
      float yP1 = (j+1)*tileSize - height/2;
      vertex(x  , y  , terrain[i  ][j  ]);
      vertex(xP1, y  , terrain[i+1][j  ]);
      vertex(x  , yP1, terrain[i  ][j+1]);
      vertex(xP1, yP1, terrain[i+1][j+1]);
      endShape();
    }
  }
}