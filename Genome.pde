import java.util.Random;
static Random genomeRandom = new Random(); 

class Genome {
  
  private ArrayList<Action> lifeEvents; 
  private int eventsIndex; 
  private color theColor; 
  private int affinityDistance; 
  
  public Genome(ArrayList<Action> lifeEvents) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
    this.theColor = color(219, 197, 156); 
    this.affinityDistance = START_GENETIC_AFFINITY;
  }
  
  public Genome(ArrayList<Action> lifeEvents, color theColor) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
    this.theColor = theColor; 
    this.affinityDistance = START_GENETIC_AFFINITY;
  }
  
  public color getColor() {
    return theColor; 
  }
  
  private Action getNextAction() {
    if (eventsIndex >= lifeEvents.size()) {
      eventsIndex %= lifeEvents.size(); 
    } 
    return lifeEvents.get(eventsIndex++);
  }
  
  private color mutatedColor() {
    int plusOne = COLOR_MUTATION_RANGE + 1;
    int half = COLOR_MUTATION_RANGE / 2;
    float r = red(theColor) + genomeRandom.nextInt(plusOne) - half; 
    float g = green(theColor) + genomeRandom.nextInt(plusOne) - half; 
    float b = blue(theColor) + genomeRandom.nextInt(plusOne) - half; 
    return color(r, g, b); 
  }
  
  public String asString() {
    StringBuilder b = new StringBuilder(""); 
    for (Action a : lifeEvents) {
      b.append(a.abbrev()); 
    }
    return b.toString(); 
  }
  
  public String writeColors() {
    return "R" + (int)red(theColor) + " G" + (int)green(theColor) + " B" + (int)blue(theColor); 
  }
  
  public boolean sameSpecies(Genome other) {
    return geneticDistance(other) <= affinityDistance; 
  }
  
  public float geneticDistance(Genome other) {
    float diffr = red(theColor) - red(other.theColor); 
    float diffg = green(theColor) - green(other.theColor); 
    float diffb = blue(theColor) - blue(other.theColor); 
    return abs(diffr) + abs(diffg) + abs(diffb); 
  }
  
  public Genome getMutation() {
    ArrayList<Action> newSequence = new ArrayList<Action>(); 
    for (Action a : lifeEvents) {
      newSequence.add(a.mutation()); 
    }
    Genome newGenome = new Genome(newSequence, mutatedColor()); 
    if (genomeRandom.nextInt(2) == 1) {
      newGenome.delete(); 
    } else {
      newGenome.duplicate();
    }
    newGenome.swap(); 
    if (genomeRandom.nextFloat() < CHANCE_ACQUIRE_NEW_TRAIT) {
      newGenome.acquireRandomTrait(); 
    } 
    return newGenome; 
  }
  
  public void swap() {
    Collections.swap(lifeEvents, genomeRandom.nextInt(lifeEvents.size()), genomeRandom.nextInt(lifeEvents.size()));
  }
  
  private void duplicate() {
    lifeEvents.add(lifeEvents.get(genomeRandom.nextInt(lifeEvents.size()))); 
  }
  
  private void delete() {
    // todo should I make lifeEvents a linked list? 
    lifeEvents.remove(genomeRandom.nextInt(lifeEvents.size()));
  }
  
  private void acquireRandomTrait() {
    if (allActions == null) setupAllActionsList(); 
    lifeEvents.add(allActions.get(genomeRandom.nextInt(allActions.size()))); 
  }
  
}
