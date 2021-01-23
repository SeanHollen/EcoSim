class Plant extends Organism {
  
  public float trunk; 
  public float canopy; 
  public float marine;
  public Terrain terrainOn; 
  
  public Plant(Genome genome, Location location, float energy) {
    super(genome, location, energy, 0); 
    initializeTraits(); 
  }

  public Plant(Genome genome, Location location, float energy, int generation) {
    super(genome, location, energy, generation); 
    terrainOn = terrainAt(location);
    initializeTraits(); 
  }
  
  void initializeTraits() {
    this.trunk = 2; 
    this.marine = 0; 
    this.canopy = 0; 
  }
  
  protected Organism child(Genome genome, Location newLoc, float startingEnergy, int generation) {
    return new Plant(genome, newLoc, startingEnergy, generation);
  }
  
  public void obsorbSunlight() {
    obsorbSunlight(1.0);
  }
  
  public void obsorbSunlight(float energy) {
    super.energy += energy; 
  }
  
  protected float sizeCost() {
    float marineCost = marine * marine * marine * PI * COST_PER_TRUNK; 
    float trunkCost = trunk * trunk * trunk * PI * COST_PER_TRUNK;
    return max(marineCost, trunkCost);
  } 
  
  protected void reduceBaseBy(float amount) {
    if (marine > 0) marine -= amount; 
    else if (trunk > 0) trunk -= amount;
    if (canopy < marine) canopy++; marine--; 
    if (canopy < trunk) canopy++; trunk--; 
  }
  
  protected float base() { return max(this.trunk, this.marine); }
  
  protected void takeAction(Action action, float toGrowWith) { action.act(this, toGrowWith); }
  
  protected void enforceConstraints() {
    if (terrainOn == Terrain.water) {
      canopy = min(canopy, marine * CANOPY_MAX_SIZE_X); 
      shell = min(shell, marine * SHELL_MAX_SIZE_X); 
    } else {
      canopy = min(canopy, trunk * CANOPY_MAX_SIZE_X); 
      shell = min(shell, trunk * SHELL_MAX_SIZE_X); 
    }
    spikes = min(spikes, trunk * SPIKES_MAX_SIZE_X); 
  }
  
  public void drawOrganism() {
    setShell();
    drawTrunk();
    drawCanopy();
    drawSpikes(); 
  }
  
  private void setShell() {
    if (shell > 0) {
      stroke(1);
      strokeWeight(shell * SHELL_STROKE);
    } else {
      noStroke(); 
    }
  }
  
  private void drawTrunk() {
    fill(128, 0, 0); 
    circle(super.location.getX(), super.location.getY(), (this.trunk * TRUNK_SIZE_VIEW));
  }
  
  private void drawCanopy() {
    fill(super.genome.getColor()); 
    circle(super.location.getX(), super.location.getY(), (this.canopy * CANOPY_SIZE_VIEW));
  }
  
  private void drawSpikes() {
    if (spikes <= 0) return; 
    float len = super.spikes * SPIKES_SIZE_VIEW; 
    triangle(
    location.getX() - len, location.getY(), 
    location.getX() + len, location.getY(), 
    location.getX(), location.getY() - len*2
    ); 
  }
  
  public void displayInfo() {
    displayGeneralInfo();
    float xOff = textXOffset;
    text("TRUNK " + round(trunk), xOff, crawldown += panelFont);
    text("MARINE " + round(marine), xOff, crawldown += panelFont);
    text("CANOPY " + round(canopy), xOff, crawldown += panelFont);
  }
  
  protected float width() {
    return canopy * BODY_SIZE_VIEW;
  }
    
  protected float removeFromCanopy(float toRemove) { 
    toRemove = min(toRemove - shell, canopy); 
    canopy -= toRemove; 
    return toRemove; 
  }
      
  public String describe() { return "plant"; }
  
  public boolean isPlant() { return true; }
  
  public boolean isDead() {
    if (super.age < INFANCY_LENGTH) {
      return false; 
    }
    if (terrainOn == Terrain.mountain) {
      return true; 
    } else if (terrainOn == Terrain.water) {
      return marine <= 0; 
    } else {
      return trunk <= 0; 
    }
  }
  
  public float getPlantHeight() { return this.trunk; }
  
}
