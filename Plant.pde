// Does not move. Has canopy that obsorbs sunlight 
class Plant extends Organism {
  
  public float trunk; 
  public float canopy; 
  
  public Plant(Genome genome, Location location, float energy) {
    this(genome, location, energy, 2, 0); 
  }
  
  public Plant(Genome genome, Location location, float energy, float trunk, float canopy) {
    super(genome, location, energy);
    this.trunk = trunk;
    this.canopy = canopy; 
  }
  
  protected Organism child(Genome genome, Location newLoc, float startingEnergy) {
     return new Plant(genome, newLoc, startingEnergy);
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
    if (canopy < trunk) canopy++; trunk--; // keep this line? 
  }
  
  public void drawOrganism() {
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
  
  public void actOnOrganism(Organism other) {}
  
  public float removeFromCanopy(float toRemove) { 
    toRemove = min(toRemove, canopy); 
    canopy -= toRemove; 
    return toRemove; 
  }
  
  public boolean canBePredatedBy(Animal other) {
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
