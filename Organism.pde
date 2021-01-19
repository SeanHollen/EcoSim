import java.util.Comparator;

abstract class Organism implements Comparable<Organism> {
  
  public Location location; 
  private float orientationInRadians; 
  private int age;
  private int ID; 
  private float energy; 
  public float shell;
  private float spikes; 
  private int generation;
  
  private Genome genome; 
  
  public Organism(Genome genome, Location location, float energy) {
    this(genome, location, energy, 0);
  }
  
  public Organism(Genome genome, Location location, float energy, int generation) {
    ID = OrganismIDMaker.getID();
    this.location = location; 
    this.energy = energy; 
    this.genome = genome;
    this.generation = generation; 
    setRandomOrientation(); 
    initializeTraits(); 
  }
  
  private void initializeTraits() {
    age = 0; 
    shell = 0; 
    spikes = 0;  
  }
  
  public Organism birth(float energyRequired, float seedDispersal) {
    if (energyRequired > this.energy) {
      return null; 
    }
    Location newLoc = this.location.getLocOffBy(seedDispersal, random(2 * PI));
    this.energy -= energyRequired; 
    return child(this.genome.getMutation(), newLoc, energyRequired, generation + 1);
  }
  
  protected abstract Organism child(Genome genome, Location newLoc, float startingEnergy, int generation); 
    
  public boolean inIntersectingXRange(Organism other) {
    float ourRightMostXPoint = this.location.getX() + (width() / 2);
    float otherLeftMostXPoint = other.location.getX() - (other.width() / 2); 
    return ourRightMostXPoint > otherLeftMostXPoint; 
    
  }
  
  public boolean bodyWestOfXPoint(float xPoint) {
    return this.location.getX() - xPoint > this.width() / 2; 
  }
  
  public boolean bodyEastOfXPoint(float xPoint) {
    return xPoint - this.location.getX() > this.width() / 2; 
  }
  
  public boolean intersects(Organism other) {
    float averageOfBodyWeights = (this.width() + other.width()) / 2; 
    return this.location.intersects(other.location, averageOfBodyWeights);
  }
  
  public boolean intersects(Location location) {
    return this.location.intersects(location, this.width() / 2);
  }
  
  public void setRandomOrientation() {
    orientationInRadians = random(2*PI);
  }
  
  public void setOrientation(float newOrientation) {
    this.orientationInRadians = newOrientation; 
  }
  
  public void reverseOrientation() {
    orientationInRadians = (orientationInRadians + PI) % (2*PI); 
  }
  
  public void ageUp() {
    this.age++; 
  }
  
  public boolean olderThan(int age) {
    return this.age > age; 
  }
    
  public void homeostasis() {
    this.energy -= ageCost(); 
    this.energy -= sizeCost();
    if (this.energy < 0) {
      reduceBaseBy(abs(this.energy)); 
      this.energy = 0;
    } else if (this.energy > base()) {
      float toGrowWith = min(this.energy - base(), GROWTH_SPEED);
      takeAction(genome.getNextAction(), toGrowWith); 
      this.energy -= toGrowWith;
    }
    enforceConstraints(); 
  }
  
  protected abstract void enforceConstraints(); 
  
  private float ageCost() {
    return AGE_COST_PER1K_ONGOING * (float) age / 1000.0;
  }
    
  protected abstract float sizeCost(); 
  
  protected abstract void reduceBaseBy(float amount); 
  
  protected abstract float base(); 
  
  protected abstract void takeAction(Action action, float toGrowWith); 
    
  public abstract void drawOrganism();
  
  public void displayMark() {
    fill(0); 
    float full = INDICATOR_TRIANGLE_SIZE / getScale(); 
    float half = full / 2;
    triangle(
    location.getX(), location.getY(), 
    location.getX() - half, location.getY() - full, 
    location.getX() + half, location.getY() - full
    ); 
  }
  
  public abstract void displayInfo(); 
  
  protected void displayGeneralInfo() {
    crawldown = panelTop;
    float xOff = textXOffset;
    textSize(10);
    fill(0,0,0);
    strokeWeight(3);
    text("TYPE " + getType(), xOff, crawldown += panelFont);
    text("GENOME " + genome.asString(), xOff, crawldown += panelFont);
    text("COLOR " + genome.writeColors(), xOff, crawldown += panelFont);
    text("ID " + ID, xOff, crawldown += panelFont);
    text("GENERATION " + generation, xOff, crawldown += panelFont);
    text("AGE " + age, xOff, crawldown += panelFont);
    text("IS DEAD? " + isDead(), xOff, crawldown += panelFont);
    text("ENERGY " + round(energy), xOff, crawldown += panelFont);
    text("SHELL " + round(shell), xOff, crawldown += panelFont);
  }
  
  protected abstract int width();
  
  protected abstract void actOnOrganism(Organism other);
  
  protected abstract float removeFromBody(float toRemove);
  
  protected abstract float removeFromCanopy(float toRemove);  
    
  protected abstract boolean canBePredatedBy(Animal other);
  
  public abstract void move(); 
  
  public abstract boolean isDead();
  
  public abstract void obsorbSunlight(float sunlight); 
  
  public abstract void obsorbSunlight(); 
  
  protected boolean sameSpecies(Organism other) {
    return this.genome.sameSpecies(other.genome); 
  }
  
  public abstract String getType(); 
  
  public boolean tallerPlantThan(Organism other) {
    return this.getPlantHeight() > other.getPlantHeight();
  }
  
  protected abstract float getPlantHeight();
    
  public int compareTo(Organism other) {
    float thisLeftMostPoint = this.leftMostPoint();
    float otherLeftMostPoint = other.leftMostPoint();
    if (thisLeftMostPoint > otherLeftMostPoint) {
      return 1;
    } else if (otherLeftMostPoint > thisLeftMostPoint) {
      return -1; 
    } else {
      return 0;
    }
  }
  
  private float leftMostPoint() {
    return this.location.getX() - (this.width() / 2); 
  }
  
}

// static class can't be a subclass because processing wraps everything in a class already 
static class OrganismIDMaker {
  private static int ID = 0; 
  public static int getID() {
    return ID++; 
  }
}

public class SortByHeight implements Comparator<Organism> {
  public int compare(Organism a, Organism b) {
    if (a.tallerPlantThan(b)) {
      return 1;
    } else if (b.tallerPlantThan(a)) {
      return -1; 
    } else {
      return a.ID - b.ID; 
    }
  }
}
