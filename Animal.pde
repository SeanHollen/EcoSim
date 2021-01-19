class Animal extends Organism {
  
  public float bodySize; 
  public float grazing, jaws, legs, fins, climbing, burrowing, fur, longNeck; // last 5 not yet used yet
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
    return NOLEG_SPEED + (LEGS_SPEED * legs / (bodySize + 0.1)); 
  }
  
  public void drawOrganism() {
    drawLegs(); 
    setStroke(); 
    fill(super.genome.getColor()); 
    drawBody();
    drawHead(); 
  }
  
  private void setStroke() {
    if (shell != 0) {
      stroke(1);
      strokeWeight(shell * SHELL_STROKE);
    } else {
      noStroke(); 
    }
  }
  
  private void drawBody() {
    circle(super.location.getX(), super.location.getY(), this.width());
  }
  
  private void drawHead() {
    Location headLoc = this.location.getLocOffBy(this.width() / 2, super.orientationInRadians);
    // Draw the smaller one last so it can be seen
    if (grazing > jaws) {
      drawHerbavoreHead(headLoc);
      drawCarnivoreHead(headLoc);
    } else {
      drawCarnivoreHead(headLoc); 
      drawHerbavoreHead(headLoc);
    }
  }
  
  private void drawLegs() {
    if (legs == 0) return; 
    stroke(super.genome.getColor());
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
  
  public void displayInfo() {
    displayGeneralInfo();
    text("BODY SIZE " + round(bodySize), textXOffset, crawldown += panelFont);
    text("GRAZING " + round(grazing), textXOffset, crawldown += panelFont);
    text("JAWS " + round(jaws), textXOffset, crawldown += panelFont);
    text("LEGS " + round(legs), textXOffset, crawldown += panelFont);
  }
  
  protected int width() {
    return (int) (this.bodySize * BODY_SIZE_VIEW); 
  }
  
  protected void actOnOrganism(Organism other) {
    if (!inGracePeriod(other)) {
      eatOtherIfPossible(other);
      setRandomOrientation(); 
      otherOrganismsConsumedTimes.put(other.ID, frameCount); 
    } 
  }
  
  private boolean inGracePeriod(Organism other) {
    return otherOrganismsConsumedTimes.containsKey(other.ID) 
      && frameCount - otherOrganismsConsumedTimes.get(other.ID) <= GRACE_PERIOD; 
  }
  
  private void eatOtherIfPossible(Organism other) {
    int toGrowBy = 0;
      toGrowBy += other.removeFromCanopy(this.grazing * GRAZING_X); 
      if (other.canBePredatedBy(this)) {
        float canPredate = max((this.jaws * JAWS_X) - (other.shell * SHELL_PROTECTION_X), 0); 
        toGrowBy += other.removeFromBody(canPredate); 
      }
      if (toGrowBy > 0) {
        super.energy += toGrowBy;
      }
  }
  
  protected float sizeCost() { return bodySize * bodySize * PI * COST_PER_BODY_SIZE; }
  
  protected void reduceBaseBy(float amount) { removeFromBody(amount); }
  
  protected float base() { return this.bodySize; }
  
  protected void takeAction(Action action, float toGrowWith) { action.act(this, toGrowWith); }
  
  protected float removeFromBody(float toRemove) {
    if (toRemove == 0) return 0; 
    toRemove = min(toRemove, bodySize); 
    bodySize -= toRemove; 
    return toRemove; 
  }
  
  protected void enforceConstraints() {
    grazing = min(grazing, bodySize * GRAZING_MAX_SIZE_X); 
    jaws = min(jaws, bodySize * JAWS_MAX_SIZE_X); 
    shell = min(shell, bodySize * SHELL_MAX_SIZE_X); 
    legs = min(legs, bodySize * LEGS_MAX_SIZE_X); 
    if (grazing + jaws > bodySize * EATING_COMB_MAX) {
      enforceEatingCombConstraint();
    }
  }
  
  private void enforceEatingCombConstraint() {
    float diff = grazing + jaws - (bodySize * EATING_COMB_MAX);
    float half = diff / 2; 
    assert (half > 0);
    grazing = max(0, grazing - half);
    jaws = max(0, jaws - half);
  }
  
  protected float removeFromCanopy(float toRemove) { return 0; }; 
  
  protected boolean canBePredatedBy(Animal other) {
    return this.jaws < other.jaws && !this.sameSpecies(other);
  }
  
  public void obsorbSunlight(float sunlight) {} 
  public void obsorbSunlight() {} 
     
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
