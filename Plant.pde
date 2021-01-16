// Does not move. Has canopy that obsorbs sunlight 
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
    addEnergy(energy); 
  }
  
  protected void addEnergy(float energy) {
    super.energy += energy; 
  }
  
  protected float sizeCost() { return trunk * trunk * trunk * PI * COST_PER_TRUNK; }
  
  protected void reduceBaseBy(float amount) { reduceTrunkBy(amount); }
  
  protected float base() { return this.trunk; }
  
  protected void takeAction(Action action, float toGrowWith) { action.act(this, toGrowWith); }
  
  private void reduceTrunkBy(float amount) {
    trunk -= amount; 
    float maxCanopy = min(canopy, trunk * CANOPY_MAX_SIZE_X); 
    canopy = maxCanopy; 
    float maxShell = min(shell, trunk * SHELL_MAX_SIZE_X); 
    shell = maxShell; 
    if (canopy < trunk) canopy++; trunk--; // keep this line? 
  }
  
  public void drawOrganism() {
    if (shell > 0) {
      stroke(1);
      strokeWeight(shell * SHELL_STROKE);
    } else {
      noStroke(); 
    }
    drawTrunk();
    drawCanopy();
  }
  
  public void drawAndDisplayInfo() {
    super.drawAndDisplayInfo();
    text("TRUNK " + round(trunk), textXOffset, panelLoc += panelFont);
    text("CANOPY " + round(canopy), textXOffset, panelLoc += panelFont);
    stroke(2); 
    stroke(25, 0, 255); 
    drawTrunk();
    drawCanopy();
  }
  
  private void drawTrunk() {
    fill(128,0,0); 
    circle(super.location.getX(), super.location.getY(), (this.trunk * TRUNK_SIZE_VIEW));
  }
  
  private void drawCanopy() {
    fill(66, 245, 114); 
    circle(super.location.getX(), super.location.getY(), (this.canopy * CANOPY_SIZE_VIEW));
  }
  
  protected int width() {
    return (int) (canopy * BODY_SIZE_VIEW);
  }
  
  protected void actOnOrganism(Organism other) {}
  
  protected float removeFromCanopy(float toRemove) { 
    toRemove = min(toRemove, canopy); 
    canopy -= toRemove; 
    return toRemove; 
  }
  
  protected boolean canBePredatedBy(Animal other) {
    return false; 
  }
  
  protected float removeFromBody(float toRemove) { return 0; }; 
  
  public void move() {}; 
  
  public String getType() {
    return "PLANT"; 
  }
  
  public boolean isDead() {
    return super.age >= INFANCY_LENGTH && this.trunk <= 0; 
  }
  
  public float getPlantHeight() {
    return this.trunk;
  }
}
