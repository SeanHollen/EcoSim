// grow body and grow stem are the "safest" actions; they guarentee that energy spent on them is not wasted, 
// because other actions can fail to go through (by design) in various situations 

interface Action {
  void act(Animal organism, float amount);
  void act(Plant organism, float amount);
  char toChar(); 
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
  
  public char toChar() { return 'R'; }
  
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
 
 public char toChar() { return 'B'; }
 
 Action mutation() { return this; }
}

class GrowCanopy implements Action {
  
  public void act(Plant plant, float amount) {
    plant.canopy += amount;
  }
  
  public void act(Animal notapplicable, float amount){}
  
  public char toChar() { return 'C'; }
  
  Action mutation() { return this; }
}

class GrowTrunk implements Action {
  
  public void act(Plant plant, float amount) {
    plant.trunk += amount; 
  }
  
  public void act(Animal notapplicable, float amount){}
  
  public char toChar() { return 'T'; }
  
  Action mutation() { return this; }
}

class GrowJaws implements Action {
  
  public void act(Animal animal, float amount) {
    animal.jaws += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public char toChar() { return 'J'; }
  
  Action mutation() { return this; }
}

class GrowGrazing implements Action {
  
  public void act(Animal animal, float amount) {
    animal.grazing += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public char toChar() { return 'G'; }
  
  Action mutation() { return this; }
}

class GrowLegs implements Action {
  
  public void act(Animal animal, float amount) {
    animal.legs += amount; 
  }
  
  public void act(Plant notapplicable, float amount){}
  
  public char toChar() { return 'L'; }
  
  Action mutation() { return this; }
}

class GrowShell implements Action {
  
  public void act(Animal animal, float amount) {
    animal.shell += amount; 
  }
  
  public void act(Plant plant, float amount) {
    plant.shell += amount; 
  }
  
  public char toChar() { return 'S'; }
  
  Action mutation() { return this; }
}

// R: reproduce
// B: body
// C: canopy
// T: trunk
// J: jaws
// G: grazing 
// L: legs
// S: shell
