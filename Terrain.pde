float terrainRandX = random(100);
float terrainRandY = random(100);
color waterColor = color(66, 230, 245); 
color landColor = color(230, 255, 200); 

PImage terrain;

void generateTerrain() {
  terrain = createImage(BOARD_X, BOARD_Y, RGB);
  for (int x = 0; x < BOARD_X; x++) {
    for (int y = 0; y < BOARD_Y; y++) {
      color c; 
      if (isWater(x, y)) c = waterColor; else c = landColor;
      terrain.set(x, y, c);
    }
  }
}

boolean isWater(float x, float y) {
  return noise(x * DELTA + terrainRandX, y * DELTA + terrainRandY) < PERCENT_WATER; 
}

boolean isWater(Location loc) {
  return isWater(loc.getX(), loc.getY()); 
}

PImage terrainCrop() {
  Location heightAndWidth = screenBottomRight.getLocBySubtracting(screenTopLeft); 
  PImage toReturn = terrain.get(
  (int)screenTopLeft.getX(), 
  (int)screenTopLeft.getY(), 
  (int)heightAndWidth.getX(), 
  (int)heightAndWidth.getY());
  toReturn.resize(SCREEN_X, SCREEN_Y); 
  return toReturn; 
}
