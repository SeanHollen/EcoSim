// Grow body and grow trunk are the "safest" actions; it guarentees that energy spent on it is not wasted;
// other actions can fail to go through (by design) because of constraints 

interface Action {
  void act(Animal organism, float amount);
  void act(Plant organism, float amount);
  String abbrev(); 
  Action mutation(); 
}

class Reproduce implements Action {
  
  private float childSize; 
  private float seedDispersal; 
  private int minAge;
  
  public Reproduce(float childSize) {
    this(childSize, 0, 0);
  }
  
  public Reproduce(float childSize, float seedDispersal) {
    this(childSize, seedDispersal, 0);
  }
  
  public Reproduce(float childSize, float seedDispersal, int minAge) {
    this.childSize = childSize; 
    this.seedDispersal = seedDispersal; 
    this.minAge = minAge;
  }
  
  public void act(Animal animal, float eggSize) {
    reproduce(animal, eggSize); 
  }
  public void act(Plant plant, float seedEnergy) {
    reproduce(plant, seedEnergy);
  }
  
  private void reproduce(Organism org, float energyUsed) {
    if (org.olderThan(minAge)) {
      Organism newOrg = org.birth(childSize, seedDispersal);
      if (newOrg != null) {
        // total child starting energy is childSize (most significant) + energyUsed - cost of seed dispersal 
        newOrg.energy += energyUsed; 
        newOrg.energy -= (seedDispersal * SEED_DISPERSAL_COST); 
        organisms.add(newOrg); 
      }
    }
  }
  
  public String toString() { return "reproduce"; }
  
  public String abbrev() { 
    return "R(" + round(childSize) + "," + round(seedDispersal) + "," + round(minAge) + ")"; 
  }
  
  Action mutation() { 
    float full = MUTATION_RANGE_PORTION;
    float half = MUTATION_RANGE_PORTION / 2;
    float newChildSize = (random(full) - half) * childSize + childSize;
    newChildSize = max(0, newChildSize); 
    float newSeedDispersal = (random(full) - half) * seedDispersal + seedDispersal;
    int newMinAge = (int) ((random(full) - half) * minAge + minAge);
    return new Reproduce(newChildSize, newSeedDispersal, newMinAge); 
  }
}

class GrowBody implements Action {
  
  public void act(Animal animal, float amount) {
    animal.bodySize += amount; 
  }
  
 public void act(Plant notapplicable, float amount) {}
 
 public String toString() { return "grow body"; }
 
 public String abbrev() { return "B"; }
 
 Action mutation() { return this; }
}

class GrowCanopy implements Action {
  
  public void act(Plant plant, float amount) {
    plant.canopy += amount;
  }
  
  public void act(Animal notapplicable, float amount){}
  
  public String toString() { return "grow canopy"; }
  
  public String abbrev() { return "C"; }
  
  Action mutation() { return this; }
}

class GrowTrunk implements Action {
  
  public void act(Plant plant, float amount) {
    plant.trunk += amount; 
  }
  
  public void act(Animal notapplicable, float amount){}
  
  public String toString() { return "grow trunk"; }
  
  public String abbrev() { return "T"; }
  
  Action mutation() { return this; }
}

class GrowMarine implements Action {
  
  public void act(Plant plant, float amount) {
    plant.marine += amount; 
  }
  
  public void act(Animal notapplicable, float amount){}
  
  public String toString() { return "grow marine"; }
  
  public String abbrev() { return "M"; }
  
  Action mutation() { return this; }
}

class GrowJaws implements Action {
  
  public void act(Animal animal, float amount) {
    animal.jaws += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public String toString() { return "grow jaws"; }
  
  public String abbrev() { return "J"; }
  
  Action mutation() { return this; }
}

class GrowGrazing implements Action {
  
  public void act(Animal animal, float amount) {
    animal.grazing += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public String toString() { return "grow grazing"; }
  
  public String abbrev() { return "G"; }
  
  Action mutation() { return this; }
}

class GrowLegs implements Action {
  
  public void act(Animal animal, float amount) {
    animal.legs += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public String toString() { return "grow legs"; }
  
  public String abbrev() { return "L"; }
  
  Action mutation() { return this; }
}

class GrowFins implements Action {
  
  public void act(Animal animal, float amount) {
    animal.fins += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public String toString() { return "grow fins"; }
  
  public String abbrev() { return "F"; }
  
  Action mutation() { return this; }
}

class GrowShell implements Action {
  
  public void act(Animal animal, float amount) {
    animal.shell += amount; 
  }
  
  public void act(Plant plant, float amount) {
    plant.shell += amount; 
  }
  
  public String toString() { return "grow shell"; }
  
  public String abbrev() { return "S"; }
  
  Action mutation() { return this; }
}

// R: Reproduce
// B: Body
// C: Canopy
// T: Trunk
// J: Jaws
// G: Grazing 
// L: Legs
// F: Fins
// S: Shell
// M: Marine 

ArrayList<Action> allActions;

void setupAllActionsList() {
  allActions = new ArrayList<Action>();
  allActions.add(new Reproduce(40, 100, 500)); 
  allActions.add(new GrowBody()); 
  allActions.add(new GrowCanopy()); 
  allActions.add(new GrowTrunk()); 
  allActions.add(new GrowMarine());
  allActions.add(new GrowJaws()); 
  allActions.add(new GrowGrazing());
  allActions.add(new GrowLegs()); 
  allActions.add(new GrowFins()); 
  allActions.add(new GrowShell());
}
