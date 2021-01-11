import java.util.Collections;

ArrayList<Organism> organisms; 
boolean areOrganismsSorted = false; 

void addStartingPlants(int numToMake) {
  ArrayList<Action> actions = new ArrayList<Action>(); 
  actions.add(new GrowTrunk());
  for (int i = 0; i < 3; i++) {
    actions.add(new GrowCanopy());
  }
  actions.add(new Reproduce(40, 100, 500)); 
  for (int i = 0; i < numToMake; i++) {
    Location newLocation = new Location(random(boardX), random(boardY));
    Plant newPlant = new Plant(new Genome(actions), newLocation, plantStartingEnergy);
    organisms.add(newPlant);
  }
}

void addStartingHerbavores(int numToMake) {
  ArrayList<Action> actions = new ArrayList<Action>(); 
  for (int i = 0; i < 4; i++) {
    actions.add(new GrowBody()); 
  }
  actions.add(new GrowGrazing()); 
  actions.add(new Reproduce(40, 0, 500)); 
  for (int i = 0; i < numToMake; i++) {
    Location newLocation = new Location(random(boardX), random(boardY));
    Animal newAnimal = new Animal(new Genome(actions), newLocation, startingBodySize, startingBodySize);
    newAnimal.grazing = startingGraze; 
    organisms.add(newAnimal);
  }
}

void addStartingCarnivores(int numToMake) {
  ArrayList<Action> actions = new ArrayList<Action>(); 
  for (int i = 0; i < 6; i++) {
    actions.add(new GrowBody()); 
  }
  actions.add(new GrowJaws());
  actions.add(new Reproduce(20, 100, 500)); 
  for (int i = 0; i < numToMake; i++) {
    Location newLocation = new Location(random(boardX), random(boardY));
    Animal newAnimal = new Animal(new Genome(actions), newLocation, startingBodySize, startingBodySize);
    newAnimal.jaws = startingJaws; 
    organisms.add(newAnimal);
  }
}

void drawOrganisms() {
  Collections.sort(organisms, new SortByHeight()); 
  areOrganismsSorted = false; // they are not sorted by X
  for (Organism organism : organisms) {
    organism.drawOrganism();
  }
}

void drawNumOrganisms() {
  fill(0, 0, 0); 
  textSize(32);
  text(organisms.size(), 10, 30);
}

void ageOrganisms() {
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
void collisionOperations() {
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
        org1.modifyCollidedOrganisms(org2);
        org2.modifyCollidedOrganisms(org1); 
      }
    }
}

void feedPlants() {
  ArrayList<Location> lightRays = makeLightRays();
  Collections.sort(lightRays); 
  HashMap<Location, Plant> plantsToGetLight = plantsToGetLight(lightRays);
  for (Location key : plantsToGetLight.keySet()) {
    plantsToGetLight.get(key).obsorbSunlight(energyPerRay); 
  }
}

ArrayList<Location> makeLightRays() {
  int boardSize = boardX * boardY; 
  float boardSizeIn10kPixeslsSquared = (float) boardSize / 10000.0; 
  int numLightRays = (int) (boardSizeIn10kPixeslsSquared * sunlightPer10kPixels); 
  ArrayList<Location> lightRays = new ArrayList<Location>(); 
  for (int i = 0; i < numLightRays; i++) {
    Location newRay = new Location(random(boardX), random(boardY));
    lightRays.add(newRay); 
    if (displayLightRays) {
      drawRay(newRay);
    }
  }
  return lightRays; 
}

// be careful cleaning this code, the algorithm is clever but quite complicated  
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
        if (!results.containsKey(ray) && org.getType() == "PLANT") {
          results.put(ray, (Plant) org); 
        } else if (results.containsKey(ray) && org.tallerPlantThan(results.get(ray))) {
          results.put(ray, (Plant) org); 
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
    organisms.get(i).homeostasis(energyCostPerFrame); 
  }
}

void killOrganisms() {
  for (int i = 0; i < organisms.size(); i++) {
    if (organisms.get(i).isDead()) {
      organisms.remove(i); 
    }
  }
}
