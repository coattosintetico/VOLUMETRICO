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