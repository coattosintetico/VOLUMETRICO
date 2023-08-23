PImage[] imgs;
int noOfFrames = 208;
int imgIndex = 0;
int direction = 1;
int slowedIndex = 0;

int[] NO_OF_TILES = {120, 214};
int tileSize = 4;

float[][] terrain;
color[][] terrainColors;
float MAX_Z = 40;

float theta = 0;
float phi = 0;
boolean returnToZero = true; // a variable to control whether theta should return to zero

void setup() {
  size(480, 854, P3D);
  frameRate(24);
  ortho();
  lights();

  imgs = new PImage[noOfFrames];
  println("Loading images...");
  for (int i = 0; i < noOfFrames; i++) {
    imgs[i] = loadImage("framesClean/frame" + nf(i+1, 4) + ".jpg");
    imgs[i].resize(480, 854);
  }
  println("Images loaded.");

  terrain = new float[NO_OF_TILES[0]][NO_OF_TILES[1]];
  terrainColors = new color[NO_OF_TILES[0]][NO_OF_TILES[1]];
}

void draw() {
  background(0);

  // directionalLight(200, 200, 255, 0, 1, -1);

  if (!returnToZero) {
    directionalLight(200, 200*cos(theta), 200*cos(theta), 1, 0, -1);
    directionalLight(200*cos(phi), 200*cos(phi), 200, -1, 0, -1);
    // directionalLight(120, 120, 120, 0, -1, -1);
  }

  if (!returnToZero) {
    theta = lerp(theta, map(mouseX, 0, width, -PI, PI), 0.1);
    phi = lerp(phi, map(mouseY, 0, height, -PI, PI), 0.1);
  } else {
    theta = lerp(theta, 0, 0.1);
    phi = lerp(phi, 0, 0.1);
  }

  pushMatrix();
  translate(width/2, height/2);
  rotateY(theta);
  rotateX(-phi);
  // imageMode(CENTER);
  // image(imgs[imgIndex], 0, 0);

  setTerrain(imgs[imgIndex]);
  triangulize(terrain, terrainColors, tileSize);

  popMatrix();
  if (returnToZero) {
    imgIndex += direction;
    if (imgIndex >= (noOfFrames-1) || imgIndex <= 0) direction *= -1;
  } else {
    slowedIndex++;
    if (slowedIndex % 2 == 0) {
      imgIndex += direction;
      if (imgIndex >= (noOfFrames-1) || imgIndex <= 0) direction *= -1;
    }
  }

  saveFrame("savedFrames/frame" + nf(frameCount, 5) + ".jpg");

  // print debug info about angles
  fill(255);
  text("theta: " + map(mouseX, 0, width,  -PI, PI), 10, height-30, 200);
  text("phi: "   + map(mouseY, 0, height, -PI, PI), 10, height-10, 200);
}

void keyPressed() {
  if (key == ' ') {
    returnToZero = !returnToZero;
  }
}


void setTerrain(PImage img) {
  /*
    Creates a terrain from the following image. It's not assumed to be BnW.
    The terrain[][] and the terrainColors[][] arrays are assumed to be already
    initialized.
  */
  PImage bnw = createImage(img.width, img.height, RGB);
  bnw.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
  bnw.filter(GRAY);
  bnw = enhanceContrast(bnw, 2);

  for (int i = 0; i < NO_OF_TILES[0]; i++) {
    for (int j = 0; j < NO_OF_TILES[1]; j++) {
      float tileX = tileSize * i + tileSize * 1/2; // careful here with what do I multiply - it can round numbers
      float tileY = tileSize * j + tileSize * 1/2;
      color tileColor = bnw.get(int(tileX), int(tileY));
      float b = map(brightness(tileColor), 0, 255, 1, 0);
      float z = map(b, 0, 1, -MAX_Z*2, MAX_Z*2);
      terrain[i][j] = z;
      terrainColors[i][j] = img.get(int(tileX), int(tileY));
    }
  }
}