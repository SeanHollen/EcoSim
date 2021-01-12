boolean isPaused = false; 

void settings() {
  size(boardX, boardY);
}

void setup() {
  organisms = new ArrayList<Organism>();
  addStartingPlants(startingPlants); 
  addStartingHerbavores(startingHerbavores);
  addStartingCarnivores(startingCarnivores);
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
final int boardX = 750;
final int boardY = 750; 

// === Visuals === ///
final float bodySizeMultiplier = 1;
final float headSizeMultiplier = 1;
final float jawsSizeMultiplier = 1;
final float trunkSizeMultiplier = 1;
final float canopySizeMultiplier = 1;
final boolean displayLightRays = false; 

// === Starting Situation === //
final int startingPlants = 200; 
final float plantStartingEnergy = 20;
final int startingHerbavores = 5; 
final int startingCarnivores = 20; 
final float startingBodySize = 10; 
final float startingGraze = 1.5; 
final float startingJaws = 2.5; 

// === Movement === //
final float speedMultiplier = 2; 
final int gracePeriod = 10; 

// === Energy and Costs === //
final float infancyLength = 20; 
final float growthSpeed = 0.5;
final float energyPerRay = 20; // was: 1 
final float sunlightPer10kPixels = 1; // was: 20 
final float energyCostPerFrame = 0.006; //was: .003
final float costPerBodySize = 0.005; //was: .01
final float costPerTrunkSize = 0.005; //was: .01
final float seedDispersalCost = 0; 

// === Restrictions === //
final float canopyMaxSizeMultiplier = 2; 
final float grazingMaxSizeMultiplier = 0.5;
final float jawsMaxSizeMultiplier = 0.75;
final float legsMaxSizeMultiplier = 0.5; 
