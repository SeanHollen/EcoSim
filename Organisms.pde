import java.util.Collections;

ArrayList<Organism> organisms; 
boolean areOrganismsSorted = false; 
Organism selected = null; 

void addStartingPlants() {
  ArrayList<Action> actions = new ArrayList<Action>(); 
  actions.add(new GrowTrunk());
  for (int i = 0; i < 3; i++) {
    actions.add(new GrowCanopy());
  }
  actions.add(new Reproduce(40, 100, 500));
  ArrayList<Action> actionsWithShell = new ArrayList<Action>(actions);
  actionsWithShell.add(new GrowShell()); 
  for (int i = 0; i < START_PLANTS; i++) {
    Genome genome;
    if (i % 3 == 0) {
      genome = new Genome(actionsWithShell, color(66, 245, 114)); 
    } else {
      genome = new Genome(actions, color(66, 245, 114));
    }
    Plant newPlant = new Plant(genome, new Location().onLand(), PLANT_START_ENERGY);
    organisms.add(newPlant);
  }
}

void addStartingHerbavores() {
  ArrayList<Action> actions = new ArrayList<Action>(); 
  for (int i = 0; i < 4; i++) {
    actions.add(new GrowBody()); 
  }
  actions.add(new GrowGrazing()); 
  actions.add(new GrowShell()); 
  actions.add(new Reproduce(60, 10, 500)); 
  actions.add(new GrowLegs()); 
  for (int i = 0; i < 20; i++) {
    Genome genome = new Genome(actions, color(219, 197, 156));
    Animal newAnimal = new Animal(genome, new Location().onLand(), START_ANIMAL_ENERGY);
    organisms.add(newAnimal);
  }
}

void addStartingCarnivores() {
  ArrayList<Action> actions = new ArrayList<Action>(); 
  for (int i = 0; i < 5; i++) {
    actions.add(new GrowBody()); 
    actions.add(new GrowJaws()); 
  }
  actions.add(new GrowLegs()); 
  actions.add(new Reproduce(40, 60, 500)); 
  for (int i = 0; i < 20; i++) {
    Genome genome = new Genome(actions, color(217, 118, 85));
    Animal newAnimal = new Animal(genome, new Location().onLand(), START_ANIMAL_ENERGY);
    organisms.add(newAnimal);
  }
}

void selectOrganism(Location clicked) {
  selected = null; 
  Location loc = new Location(clicked.getX(), clicked.getY()); 
  ensureSorted(); 
  int i = 0; 
  while (i < organisms.size() && clicked.getX() < organisms.get(i).location.getX()) i++; 
  for (; i < organisms.size(); i++) {
    if (organisms.get(i).intersects(loc)) {
      selected = organisms.get(i); 
      return;
    }
  }
}

void drawOrganisms() {
  if (keyPressed && key == 'f') return; 
  Collections.sort(organisms, new SortByHeight()); 
  areOrganismsSorted = false; // they are not sorted by X
  for (Organism organism : organisms) {
    organism.drawOrganism();
  }
}

void infoOfSelected() {
  if (selected != null) {
    fill(255, 150); 
    noStroke(); 
    rect(0, panelTop, 180, BOARD_Y - panelTop); 
    selected.displayInfo();
  } 
}

void markSelected() {
  if (selected != null) {
    selected.displayMark();
  } 
}

void drawNumOrganisms() {
  fill(0, 0, 0); 
  textSize(32);
  text(organisms.size(), 10, 30);
}

void incrementAges() {
  for (Organism organism : organisms) {
    organism.ageUp(); 
  }
}

void moveAnimals() {
  for (Organism organism : organisms) {
    organism.move();
  }
  areOrganismsSorted = false; 
}

// uses sweep and prune system 
void collisions() {
  ensureSorted(); 
  for (int i = 0; i < organisms.size(); i++) {
    Organism org = organisms.get(i);
    checkCollisionsRightOf(org, i); 
  }
}

void checkCollisionsRightOf(Organism org1, int indexOfOrganism) {
  for (int n = indexOfOrganism + 1; n < organisms.size(); n++) {
      Organism org2 = organisms.get(n);
      if (!org1.inIntersectingXRange(org2)) {
        return; 
      }
      if (org1.intersects(org2)) {
        org1.actOnOrganism(org2);
        org2.actOnOrganism(org1); 
      }
    }
}

void feedPlants() {
  ArrayList<Location> lightRays = makeLightRays();
  Collections.sort(lightRays); 
  HashMap<Location, Plant> plantsToGetLight = plantsToGetLight(lightRays);
  for (Location key : plantsToGetLight.keySet()) {
    plantsToGetLight.get(key).obsorbSunlight(ENERGY_PER_RAY); 
  }
}

ArrayList<Location> makeLightRays() {
  int boardSize = BOARD_X * BOARD_Y; 
  float boardSizeIn10kPixeslsSquared = (float) boardSize / 10000.0; 
  int numLightRays = (int) (boardSizeIn10kPixeslsSquared * RAYS_PER_10K_PIXELS); 
  ArrayList<Location> lightRays = new ArrayList<Location>(); 
  for (int i = 0; i < numLightRays; i++) {
    Location newRay = new Location();
    lightRays.add(newRay); 
    if (SHOW_LIGHT_RAYS) {
      noStroke(); 
      drawRay(newRay);
    }
  }
  return lightRays; 
}

// be careful cleaning this code, the algorithm is clever but quite complicated/integrated  
HashMap<Location, Plant> plantsToGetLight(ArrayList<Location> lightRays) {
  ensureSorted(); 
  HashMap<Location, Plant> results = new HashMap<Location, Plant>(); 
  int leftMostRayIndex = 0; 
  for (int i = 0; i < organisms.size(); i++) {
    Organism org = organisms.get(i); 
    for (int rayIndex = leftMostRayIndex; rayIndex < lightRays.size(); rayIndex++) {
      Location ray = lightRays.get(rayIndex);
      if (org.bodyWestOfXPoint(ray.getX())) {
        leftMostRayIndex++; 
      } else if (org.intersects(ray)) {
        if (!org.isPlant()) {
          continue; 
        } else if (!results.containsKey(ray)) {
          results.put(ray, (Plant) org); 
        } else if (org.tallerPlantThan(results.get(ray))) {
          results.put(ray, (Plant) org); // error here 
        }
      } else if (org.bodyEastOfXPoint(ray.getX())) {
        break; 
      }
    }
  }
  return results; 
}

void ensureSorted() {
  if (!areOrganismsSorted) {
    Collections.sort(organisms); 
    areOrganismsSorted = true; 
  }
}

void drawRay(Location ray) {
  fill(255, 243, 74);
  circle(ray.getX(), ray.getY(), 10);
}

void homeostasis() {
  for (int i = 0; i < organisms.size(); i++) {
    organisms.get(i).homeostasis(); 
  }
}

void removeDead() {
  for (int i = 0; i < organisms.size(); i++) {
    if (organisms.get(i).isDead()) {
      organisms.remove(i); 
    }
  }
}
