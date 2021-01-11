import java.util.Comparator;

abstract class Organism implements Comparable<Organism> {
  
  public Location location; 
  private float orientationInRadians; 
  private int age;
  private int ID; 
  private float energy; 
  public float shell, spikes; 
  
  private Genome genome; 
  
  public Organism(Genome genome, Location location, float energy) {
    this.location = location; 
    this.energy = energy; 
    this.genome = genome;
    setRandomOrientation(); 
    age = 1; 
    shell = 0; 
    spikes = 0; 
    ID = OrganismIDMaker.getID(); 
  }
  
  public Organism birth(float energyRequired, float seedDispersal) {
    if (energyRequired > this.energy) {
      return null; 
    }
    Location newLoc = this.location.getLocOffBy(seedDispersal, random(2 * PI));
    this.energy -= energyRequired; 
    return child(this.genome, newLoc, energyRequired);
  }
  
  protected abstract Organism child(Genome genome, Location newLoc, float startingEnergy); 
    
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
    
  public void homeostasis(float toDrain) {
    this.energy -= toDrain; 
    this.energy -= (toDrain * sizeCost());
    if (this.energy < 0) {
      reduceBaseBy(abs(this.energy)); 
      this.energy = 0;
    } else if (this.energy > base()) {
      float toGrowWith = min(this.energy - base(), growthSpeed);
      takeAction(genome.getNextAction(), toGrowWith); 
      this.energy -= toGrowWith;
    }
  }
    
  protected abstract float sizeCost(); 
  
  protected abstract void reduceBaseBy(float amount); 
  
  protected abstract float base(); 
  
  protected abstract void takeAction(Action action, float toGrowWith); 
  
  protected abstract void addEnergy(float energy);
  
  public abstract void drawOrganism();
  
  protected abstract int width();
  
  public abstract void modifyCollidedOrganisms(Organism other);
  
  protected abstract float removeFromBody(float toRemove);
  
  protected abstract float removeFromCanopy(float toRemove);  
    
  public abstract boolean canBeEatenWithJaws(float otherJawsSize);
  
  public abstract void move(); 
  
  public abstract boolean isDead();
  
  public abstract void obsorbSunlight(float sunlight); 
  
  public abstract void obsorbSunlight(); 
  
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
    // return (int) (this.leftMostPoint() - other.leftMostPoint()); // we can't do this because casting to int violates precision 
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
