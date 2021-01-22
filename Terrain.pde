enum Terrain {
  land, water, mountain; 
}

color terrainColor(Terrain terrain) {
  if (terrain == Terrain.water) return color(66, 230, 245);
  if (terrain == Terrain.mountain) return color(82, 79, 69);
  return color(230, 255, 200);
}

PImage map;
float terrainRandX = random(100);
float terrainRandY = random(100);

void generateMap() {
  map = createImage(BOARD_X, BOARD_Y, RGB);
  for (int x = 0; x < BOARD_X; x++) {
    for (int y = 0; y < BOARD_Y; y++) {
      Terrain terrain = terrainAt(x, y); 
      map.set(x, y, terrainColor(terrain));
    }
  }
}

Terrain terrainAt(float x, float y) {
  float elevation = noise(x * DELTA + terrainRandX, y * DELTA + terrainRandY); 
  if (elevation < PERCENT_WATER) return Terrain.water; 
  if (elevation > (1 - PERCENT_MOUNTAIN)) return Terrain.mountain; 
  return Terrain.land; 
}

Terrain terrainAt(Location loc) {
  return terrainAt(loc.getX(), loc.getY()); 
}

PImage mapCrop() {
  Location heightAndWidth = screenBottomRight.getLocBySubtracting(screenTopLeft); 
  PImage toReturn = map.get(
  (int)screenTopLeft.getX(), 
  (int)screenTopLeft.getY(), 
  (int)heightAndWidth.getX(), 
  (int)heightAndWidth.getY());
  toReturn.resize(SCREEN_X, SCREEN_Y); 
  return toReturn; 
}
