class Plant extends Organism {
  
  public float trunk; 
  public float canopy; 
  
  public Plant(Genome genome, Location location, float energy) {
    super(genome, location, energy, 0); 
    initializeTraits(); 
  }
  
  public Plant(Genome genome, Location location, float energy, int generation) {
    super(genome, location, energy, generation); 
    initializeTraits(); 
  }
  
  void initializeTraits() {
    this.trunk = 2; 
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
  
  protected float sizeCost() { return trunk * trunk * trunk * PI * COST_PER_TRUNK; } 
  
  protected void reduceBaseBy(float amount) { 
    trunk -= amount;
    if (canopy < trunk) canopy++; trunk--; 
  }
  
  protected float base() { return this.trunk; }
  
  protected void takeAction(Action action, float toGrowWith) { action.act(this, toGrowWith); }
  
  protected void enforceConstraints() {
    canopy = min(canopy, trunk * CANOPY_MAX_SIZE_X); 
    shell = min(shell, trunk * SHELL_MAX_SIZE_X); 
  }
  
  public void drawOrganism() {
    setShell();
    drawTrunk();
    drawCanopy();
  }
  
  private void setShell() {
    if (shell > 0) {
      stroke(1);
      strokeWeight(shell * SHELL_STROKE);
    } else {
      noStroke(); 
    }
  }
  
  public void displayInfo() {
    displayGeneralInfo();
    float xOff = textXOffset;
    text("TRUNK " + round(trunk), xOff, crawldown += panelFont);
    text("CANOPY " + round(canopy), xOff, crawldown += panelFont);
  }
  
  private void drawTrunk() {
    fill(128, 0, 0); 
    circle(super.location.getX(), super.location.getY(), (this.trunk * TRUNK_SIZE_VIEW));
  }
  
  private void drawCanopy() {
    fill(super.genome.getColor()); 
    circle(super.location.getX(), super.location.getY(), (this.canopy * CANOPY_SIZE_VIEW));
  }
  
  protected int width() {
    return (int) (canopy * BODY_SIZE_VIEW);
  }
  
  protected void actOnOrganism(Organism other) {}
  
  protected float removeFromCanopy(float toRemove) { 
    toRemove = min(toRemove - shell, canopy); 
    canopy -= toRemove; 
    return toRemove; 
  }
  
  protected boolean canBePredatedBy(Animal other) {
    return false; 
  }
  
  protected float removeFromBody(float toRemove) { return 0; }; 
  
  public void move() {}; 
  
  public String describe() {
    return "PLANT"; 
  }
  
  public boolean isDead() {
    return super.age >= INFANCY_LENGTH && this.trunk <= 0; 
  }
  
  public float getPlantHeight() {
    return this.trunk;
  }
}
