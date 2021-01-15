// Moves and finds food of various kinds to eat 
class Animal extends Organism {
  
  public float bodySize; 
  public float grazing, jaws, legs, fins, climbing, burrowing, fur, longNeck; 
  private HashMap<Integer, Integer> otherOrganismsConsumedTimes;
  
  public Animal(Genome genome, Location location, float energy) {
    this(genome, location, energy, 0); 
  }
  
  private Animal(Genome genome, Location location, float energy, int generation) {
    super(genome, location, energy, generation);
    initializeTraits(); 
    otherOrganismsConsumedTimes = new HashMap<Integer, Integer>(); 
  }
  
  private void initializeTraits() {
    this.bodySize = 2; 
    this.grazing = 0; 
    this.jaws = 0; 
    this.legs = 0; 
    this.fins = 0; 
    this.climbing = 0; 
    this.burrowing = 0; 
    this.fur = 0; 
    this.longNeck = 0; 
    
  }
  
  protected Organism child(Genome genome, Location loc, float startingEnergy, int generation) {
    return new Animal(genome, loc, startingEnergy, generation);
  }
  
  public void move() {
    float step = getStep(); 
    super.location.moveBy(step, super.orientationInRadians); 
  }
  
  private float getStep() {
    return SPEED_MULTIPLE + (LEGS_SPEED * legs / (bodySize + 0.1)); 
  }
  
  public void drawOrganism() {
    if (shell != 0) {
      stroke(1);
      strokeWeight(shell * SHELL_STROKE);
    } else {
      noStroke(); 
    }
    super.genome.setFillToColor(); 
    drawBody();
    drawHead(); 
    drawLegs(); 
  }
  
  private void drawBody() {
    circle(super.location.getX(), super.location.getY(), this.width());
  }
  
  private void drawHead() {
    Location headLoc = this.location.getLocOffBy(this.width() / 2, super.orientationInRadians);
    if (grazing > jaws) {
      // We have to draw the larger one first so the smaller one is not covered up
      drawCarnivoreHead(headLoc); 
      drawHerbavoreHead(headLoc);
    } else {
      drawHerbavoreHead(headLoc);
      drawCarnivoreHead(headLoc); 
    }
  }
  
  private void drawLegs() {
    if (legs == 0) return; 
    super.genome.setStrokeToColor(); 
    strokeWeight(legs * LEGS_WIDTH_VIEW); 
    float offBy = this.width() * (0.5 + LEGS_LENGTH_VIEW_X); 
    Location newLoc = this.location.getLocOffBy(offBy, super.orientationInRadians + PI + QUARTER_PI); 
    line(location.getX(), location.getY(), newLoc.getX(), newLoc.getY());
    newLoc = this.location.getLocOffBy(offBy, super.orientationInRadians - (PI + QUARTER_PI)); 
    line(location.getX(), location.getY(), newLoc.getX(), newLoc.getY());
  }
  
  private void drawCarnivoreHead(Location headLoc) {
    fill(237, 40, 40); 
    circle(headLoc.getX(), headLoc.getY(), (this.jaws * JAWS_SIZE_VIEW));
  }
  
  private void drawHerbavoreHead(Location headLoc) {
    fill(191, 134, 0); 
    circle(headLoc.getX(), headLoc.getY(), (this.grazing * HEAD_SIZE_VIEW));
  }
  
  public void drawAndDisplayInfo() {
    super.drawAndDisplayInfo();
    text("BODY SIZE " + round(bodySize), textXOffset, panelLoc += panelFont);
    text("GRAZING " + round(grazing), textXOffset, panelLoc += panelFont);
    text("JAWS " + round(jaws), textXOffset, panelLoc += panelFont);
    text("LEGS " + round(legs), textXOffset, panelLoc += panelFont);
    stroke(2); 
    stroke(25, 0, 255); 
    drawBody();
    drawHead();
  }
  
  protected int width() {
    return (int) (this.bodySize * BODY_SIZE_VIEW); 
  }
  
  public void actOnOrganism(Organism other) {
    if (!inGracePeriod(other)) {
      eatOtherIfPossible(other);
      setRandomOrientation(); 
    } 
    otherOrganismsConsumedTimes.put(other.ID, frameCount); 
  }
  
  private void eatOtherIfPossible(Organism other) {
    int toGrowBy = 0;
      toGrowBy += other.removeFromCanopy(this.grazing); 
      if (other.canBePredatedBy(this)) {
        float canEat = max(this.jaws - (other.shell * SHELL_PROTECTION), 0); 
        toGrowBy += other.removeFromBody(canEat); 
      }
      if (toGrowBy > 0) {
        addEnergy(toGrowBy);
      }
  }
  
  public boolean inGracePeriod(Organism other) {
    return otherOrganismsConsumedTimes.containsKey(other.ID) 
      && frameCount - otherOrganismsConsumedTimes.get(other.ID) <= GRACE_PERIOD; 
  }
  
  protected void addEnergy(float energy) {
    super.energy += energy; 
  }
  
  protected float sizeCost() { return bodySize * bodySize * PI * COST_PER_BODY_SIZE; }
  
  protected void reduceBaseBy(float amount) { removeFromBody(amount); }
  
  protected float base() { return this.bodySize; }
  
  protected void takeAction(Action action, float toGrowWith) { action.act(this, toGrowWith); }
  
  protected float removeFromBody(float toRemove) {
    if (toRemove == 0) return 0; 
    toRemove = min(toRemove, bodySize); 
    bodySize -= toRemove; 
    float maxGrazing = min(grazing, bodySize * GRAZING_MAX_SIZE_X); 
    grazing = maxGrazing; 
    float maxJaws = min(jaws, bodySize * JAWS_MAX_SIZE_X); 
    jaws = maxJaws; 
    float maxShell = min(shell, bodySize * SHELL_MAX_SIZE_X); 
    shell = maxShell; 
    float maxLegs = min(legs, bodySize * LEGS_MAX_SIZE_X); 
    legs = maxLegs; 
    return toRemove; 
  }
  
  public float removeFromCanopy(float toRemove) { return 0; }; 
  
  public boolean canBePredatedBy(Animal other) {
    return this.jaws < other.jaws && !this.sameSpecies(other);
  }
  
  public void obsorbSunlight(float sunlight) {} // does not
  public void obsorbSunlight() {} // does not
     
  public String getType() {
    if (this.jaws > this.grazing) {
      return "CARNIVORE"; 
    } else {
      return "HERBAVORE";
    }
  }
  
  public boolean isDead() {
    return super.age >= INFANCY_LENGTH && this.bodySize <= 0; 
  }
  
  public float getPlantHeight() {
    return 0;
  }
  
}
