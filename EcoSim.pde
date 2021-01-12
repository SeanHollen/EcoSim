boolean isPaused = false; 

void settings() {
  size(BOARD_X, BOARD_Y);
}

void setup() {
  organisms = new ArrayList<Organism>();
  addStartingPlants(STARTING_PLANTS); 
  addStartingHerbavores(START_HERBAVORES);
  addStartingCarnivores(START_CARNIVORES);
}

void draw() {
  background(217, 255, 224);
  noStroke(); 
  drawOrganisms(); 
  drawNumOrganisms(); 
  if (!isPaused) {
    ageOrganisms(); 
    moveAnimals();
    collisionOperations(); 
    feedPlants();
    homeostasis();
    killOrganisms(); 
  } 
  pausedText(); 
}

void mouseClicked() {
  if (isPaused) {
    isPaused = false; 
  } else if (mouseX < 100 && mouseY < 100) {
    isPaused = true; 
  }
}

void pausedText() {
  if (isPaused) {
    textSize(16);
    text("paused", 13, 60);
  } else {
    textSize(16);
    text("pause", 13, 60);
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
final boolean SHOW_LIGHT_RAYS = false; 

// === Starting Situation === //
final int STARTING_PLANTS = 200; 
final float PLANT_STARTING_ENERGY = 20;
final int START_HERBAVORES = 5; 
final int START_CARNIVORES = 20; 
final float START_BODY_SIZE = 10; 
final float START_GRAZE = 1.5; 
final float START_JAWS = 2.5; 

// === Movement === //
final float SPEED_MULTIPLE = 2; 
final int GRACE_PERIOD = 10; 

// === Energy and Costs === //
final float INFANCY_LENGTH = 20; 
final float GROWTH_SPEED = 0.5;
final float ENERGY_PER_RAY = 20; // was: 1 
final float RAYS_PER_10K_PIXELS = 1; // was: 20 
final float ENERGY_COST = 0.006; //was: .003
final float COST_PER_BODY_SIZE = 0.005; //was: .01
final float COST_PER_TRUNK = 0.005; //was: .01
final float SEED_DISPERSAL_COST = 0; 

// === Restrictions === //
final float CANOPY_MAX_SIZE_X = 2; 
final float GRAZING_MAX_SIZE_X = 0.5;
final float JAWS_MAX_SIZE_X = 0.75;
final float LEGS_MAX_SIZE_X = 0.5; 
final float SHELL_MAX_SIZE_X = 0.2; 
