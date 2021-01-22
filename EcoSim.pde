void settings() {
  size(SCREEN_X, SCREEN_Y);
}

void setup() {
  organisms = new ArrayList<Organism>();
  addStartingPlants(); 
  addStartingHerbavores();
  addStartingCarnivores();
  generateMap();
  println("map created");
}

void draw() {
  background(mapCrop()); 
  toRecropThisFrame = false; 
  screenTransform();
  drawOrganisms(); 
  markSelected(); 
  if (!isPaused) {
    incrementAges();
    moveAnimals();
    collisions(); 
    feedPlants();
    homeostasis();
    removeDead(); 
  } 
  undoScreenTransform(); 
  drawNumOrganisms(); 
  pausedText(); 
  infoOfSelected(); 
}

// === Board Diminsions === //
final int BOARD_X = 2000; 
final int BOARD_Y = 2000; 
final int SCREEN_X = 750;
final int SCREEN_Y = 750;
final float X_START = 1000; 
final float Y_START = 1000;

// === Scrolling, Clicking, and Zooming == // 
Location screenTopLeft = new Location(X_START, Y_START);
Location screenBottomRight = new Location(X_START + SCREEN_X, Y_START + SCREEN_Y);
final float SCROLL_SPEED = 0.01;

// === Visuals === ///
final float BODY_SIZE_VIEW = 1;
final float HEAD_SIZE_VIEW = 1;
final float JAWS_SIZE_VIEW = 1;
final float TRUNK_SIZE_VIEW = 1;
final float CANOPY_SIZE_VIEW = 1;
final float LEGS_WIDTH_VIEW = 0.5; 
final float FINS_VIEW_X = 2; 
final float LEGS_LENGTH_VIEW_X = 0.5;
final float SHELL_STROKE = 0.2; 
final boolean SHOW_LIGHT_RAYS = false; 

// === Info Display === // 
final float textXOffset = 13; 
final float panelTop = SCREEN_Y - 220;
float crawldown;
final float panelFont = 15;
final float INDICATOR_TRIANGLE_SIZE = 16;

// === Starting Situation === //
final int START_PLANTS = 300; 
final int START_HERBAVORES = 100; 
final int START_CARNIVORES = 100; 
final float PLANT_START_ENERGY = 20;
final float START_ANIMAL_ENERGY = 40;

// === Terrain === //
final float DELTA = 0.005; 
final float PERCENT_WATER = 0.4;
final float PERCENT_MOUNTAIN = 0.33;

// === Movement === //
final float NOLEG_SPEED = 0; 
final float NOFIN_SPEED = 4; 
final float LEGS_SPEED = 12; 
final float FINS_SPEED = 12; 
final int GRACE_PERIOD = 10; //was: 100

// === Energy and Costs === //
final float COST_PER_BODY_SIZE = 0.00003; 
final float COST_PER_TRUNK = 0.00003; 
final float AGE_COST_PER1K_ONGOING = 0.0006; 
final float GROWTH_SPEED = 0.5;
final float ENERGY_PER_RAY = 20; 
final float RAYS_PER_10K_PIXELS = 1; 
final float INFANCY_LENGTH = 20; 
final float SEED_DISPERSAL_COST = 0; 

// === Trait Benefits === //
final float SHELL_PROTECTION_X = 1; 
final float JAWS_X = 1; 
final float GRAZING_X = 1; 

// === Restrictions === //
final float CANOPY_MAX_SIZE_X = 2;
final float GRAZING_MAX_SIZE_X = 0.5;
final float JAWS_MAX_SIZE_X = 0.75;
final float LEGS_MAX_SIZE_X = 0.40;
final float FINS_MAX_SIZE_X = 0.40;
final float SHELL_MAX_SIZE_X = 0.2; 

// === Genetics === // 
final int START_GENETIC_AFFINITY = 40; 
final float MUTATION_RANGE_PORTION = 0.25; 
final int COLOR_MUTATION_RANGE = 40;
final float CHANCE_ACQUIRE_NEW_TRAIT = 0.2;


// === Scrolling, Clicking, and Zooming functions == // 

boolean isPaused = false; 
boolean toRecropThisFrame = false; 

void screenTransform() {
  scale(getScale()); 
  translate(- screenTopLeft.getX(), - screenTopLeft.getY()); 
}

void undoScreenTransform() {
  translate(screenTopLeft.getX(), screenTopLeft.getY()); 
  scale(1 / getScale()); 
}

float getScale() {
  return SCREEN_X / (screenBottomRight.getX() - screenTopLeft.getX()); 
}

void mouseClicked() {
  if (mouseOnPause()) {
    isPaused = !isPaused; 
  } else {
    selectOrganism(actualLoc()); 
  }
}

Location actualLoc() {
  return new Location(mouseX, mouseY).getScaledDownBy(getScale()).getLocByAdding(screenTopLeft);
}

void pausedText() {
  textSize(16);
  String text; 
  if (mouseOnPause()) fill(171, 171, 171); else fill(0);
  if (isPaused) text = "paused"; else text = "pause"; 
  text(text, textXOffset, 60);
}

boolean mouseOnPause() {
  return mouseX > textXOffset && mouseX < 70 && mouseY > 50 && mouseY < 70;
}

void mouseWheel(MouseEvent e) {
  toRecropThisFrame = true; 
  float amount = - (float) e.getCount() * SCROLL_SPEED; 
  float xChange = (screenBottomRight.getX() - screenTopLeft.getX()) * amount; 
  float yChange = (screenBottomRight.getY() - screenTopLeft.getY()) * amount; 
  Location cursorLoc = actualLoc(); 
  float cursorRightSkew = (cursorLoc.getX() - screenTopLeft.getX()) 
  / (screenBottomRight.getX() - screenTopLeft.getX());
  float cursorBottomSkew = (cursorLoc.getY() - screenTopLeft.getY()) 
  / (screenBottomRight.getY() - screenTopLeft.getY());
  screenBottomRight.subFromX(xChange * (1 - cursorRightSkew)); 
  screenBottomRight.subFromY(yChange * (1 - cursorBottomSkew));
  screenTopLeft.addToX(xChange * cursorRightSkew); 
  screenTopLeft.addToY(yChange * cursorBottomSkew);
  screenTopLeft.ensureLessThanBy(screenBottomRight, 2);
  ensureScreenInBounds();
}

void ensureScreenInBounds() {
  if (screenBottomRight.getX() > BOARD_X) {
    float off = screenBottomRight.getX() - BOARD_X;
    screenTopLeft.subFromX(off);
    screenBottomRight.subFromX(off);
  }
  if (screenBottomRight.getY() > BOARD_Y) {
    float off = screenBottomRight.getY() - BOARD_Y;
    screenTopLeft.subFromY(off);
    screenBottomRight.subFromY(off);
  }
  if (screenTopLeft.getX() < 0) {
    float off = abs(screenTopLeft.getX());
    screenTopLeft.addToX(off);
    screenBottomRight.addToX(off);
  }
  if (screenTopLeft.getY() < 0) {
    float off = abs(screenTopLeft.getY());
    screenTopLeft.addToY(off);
    screenBottomRight.addToY(off);
  }
  if (screenBottomRight.getX() > screenTopLeft.getX() + BOARD_X) {
    screenBottomRight.setX(BOARD_X);
  }
  if (screenBottomRight.getY() > screenTopLeft.getY() + BOARD_Y) {
    screenBottomRight.setY(BOARD_Y);
  }
}

Location mousePressedOn; 

void mousePressed() {
  mousePressedOn = actualLoc();
}

void mouseDragged() {
  toRecropThisFrame = true; 
  Location actual = actualLoc(); 
  float xDiff = actual.getX() - mousePressedOn.getX();
  float yDiff = actual.getY() - mousePressedOn.getY();
  if (screenBottomRight.getX() - xDiff < BOARD_X && screenTopLeft.getX() - xDiff > 0) {
    screenBottomRight.subFromX(xDiff);
    screenTopLeft.subFromX(xDiff);
  }
  if (screenBottomRight.getY() - yDiff < BOARD_Y && screenTopLeft.getY() - yDiff > 0) {
    screenBottomRight.subFromY(yDiff);
    screenTopLeft.subFromY(yDiff);
  }
}

void keyPressed() {
  // remove/kill selected 
  if ((key == 'r' || key == 'k') && selected != null) {
    selected.energy = -1000; 
    selected.reduceBaseBy(selected.base());
    // toggle pause 
  } else if (key == ' ') {
    isPaused = !isPaused; 
  }
}
