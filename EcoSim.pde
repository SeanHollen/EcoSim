boolean isPaused = false; 

void settings() {
  size(BOARD_X, BOARD_Y);
}

void setup() {
  organisms = new ArrayList<Organism>();
  addStartingPlants(); 
  //addStartingHerbavores();
  //addStartingCarnivores();
  addExperimentalOrganisms(); 
}

void draw() {
  background(217, 255, 224);
  noStroke(); 
  drawOrganisms(); 
  drawNumOrganisms(); 
  drawSelected(); 
  if (!isPaused) {
    incrementAges(); 
    moveAnimals();
    collisionOperations(); 
    feedPlants();
    homeostasis();
    removeDead(); 
  } 
  pausedText(); 
}

void mouseClicked() {
  if (mouseX < 100 && mouseY < 100) {
    isPaused = !isPaused; 
  } else {
    selectOrganism(); 
  }
}

void pausedText() {
  if (isPaused) {
    textSize(16);
    fill(0,0,0);
    text("paused", textXOffset, 60);
  } else {
    textSize(16);
    fill(0,0,0);
    text("pause", textXOffset, 60);
  }
}

// === Board Diminsions === //
final int BOARD_X = 750;
final int BOARD_Y = 750; 

// === Visuals === ///
final float BODY_SIZE_VIEW = 1;
final float HEAD_SIZE_VIEW = 1;
final float JAWS_SIZE_VIEW = 1;
final float TRUNK_SIZE_VIEW = 1;
final float CANOPY_SIZE_VIEW = 1;
final float LEGS_SIZE_VIEW = 5;
final float SHELL_STROKE = 0.05; 
final boolean SHOW_LIGHT_RAYS = false; 

// === Starting Situation === //
final int START_PLANTS = 100; 
final float PLANT_START_ENERGY = 20;
final int START_HERBAVORES = 5; 
final int START_CARNIVORES = 20; 
final float START_ANIMAL_ENERGY = 40; 
final float START_GRAZE = 1.5; 
final float START_JAWS = 5; 
final int START_GENETIC_AFFINITY = 5; 

// === Movement === //
final float SPEED_MULTIPLE = 2; 
final float LEGS_SPEED = 2;
final int GRACE_PERIOD = 10; 

// === Energy and Costs === //
final float INFANCY_LENGTH = 20; 
final float GROWTH_SPEED = 0.5;
final float ENERGY_PER_RAY = 20; 
final float RAYS_PER_10K_PIXELS = 1; 
final float ENERGY_COST = 0.006; 
final float COST_PER_BODY_SIZE = 0.005; 
final float COST_PER_TRUNK = 0.005; 
final float SEED_DISPERSAL_COST = 0; 

// === Restrictions === //
final float CANOPY_MAX_SIZE_X = 2; 
final float GRAZING_MAX_SIZE_X = 0.5;
final float JAWS_MAX_SIZE_X = 0.75;
final float LEGS_MAX_SIZE_X = 0.5; 
final float SHELL_MAX_SIZE_X = 0.2; 

// === PANEL === // 
final float textXOffset = 13; 
final float panelTop =  BOARD_Y - 200;
float panelLoc;
float panelFont = 15;
