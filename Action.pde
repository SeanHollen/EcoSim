interface Action {
  void act(Animal organism, float amount);
  void act(Plant organism, float amount);
  char toChar(); 
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
        newOrg.energy -= (seedDispersal * seedDispersalCost); 
        organisms.add(newOrg); 
      }
    }
  }
  
  public char toChar() { return 'R'; }
}

class GrowBody implements Action {
  public void act(Animal animal, float amount) {
    animal.bodySize += amount; 
  }
 public void act(Plant notapplicable, float amount) {}
 
 public char toChar() { return 'B'; }
}

class GrowCanopy implements Action {
  public void act(Plant plant, float amount) {
    if (plant.trunk * canopyMaxSizeMultiplier >= plant.canopy + amount) {
      plant.canopy += amount; 
    }
  }
  public void act(Animal notapplicable, float amount){}
  
  public char toChar() { return 'C'; }
}

class GrowTrunk implements Action {
  public void act(Plant plant, float amount) {
    plant.trunk += amount; 
  }
  public void act(Animal notapplicable, float amount){}
  
  public char toChar() { return 'T'; }
}

class GrowJaws implements Action {
  public void act(Animal animal, float amount) {
    if (animal.bodySize * jawsMaxSizeMultiplier >= animal.jaws + amount) {
      animal.jaws += amount; 
    }
  }
  public void act(Plant notapplicable, float amount){}
  
  public char toChar() { return 'J'; }
}

class GrowGrazing implements Action {
  public void act(Animal animal, float amount) {
    if (animal.bodySize * grazingMaxSizeMultiplier >= animal.grazing + amount) {
      animal.grazing += amount; 
    }
  }
  public void act(Plant notapplicable, float amount){}
  
  public char toChar() { return 'G'; }
}

// R: reproduce
// B: body
// C: canopy
// T: trunk
// J: jaws
// G: grazing 
