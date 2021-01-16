import java.util.Random;
static Random genomeRandom = new Random(); 

class Genome {
  
  private ArrayList<Action> lifeEvents; 
  private int eventsIndex; 
  private int[] asColors; 
  private int affinityDistance; 
  
  public Genome(ArrayList<Action> lifeEvents) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
    this.asColors = new int[]{219, 197, 156}; 
    this.affinityDistance = START_GENETIC_AFFINITY;
  }
  
  public Genome(ArrayList<Action> lifeEvents, int[] colors) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
    this.asColors = colors; 
    this.affinityDistance = START_GENETIC_AFFINITY;
  }
  
  public void setFillToColor() {
    fill(asColors[0], asColors[1], asColors[2]); 
  }
  
  public void setStrokeToColor() {
    stroke(asColors[0], asColors[1], asColors[2]); 
  }
  
  private Action getNextAction() {
    if (eventsIndex >= lifeEvents.size()) {
      eventsIndex %= lifeEvents.size(); 
    } 
    return lifeEvents.get(eventsIndex++);
  }
  
  private int[] mutatedColor() {
    int plusOne = COLOR_MUTATION_RANGE + 1;
    int half = COLOR_MUTATION_RANGE / 2;
    int r = asColors[0] + genomeRandom.nextInt(plusOne) - half; 
    int g = asColors[1] + genomeRandom.nextInt(plusOne) - half; 
    int b = asColors[2] + genomeRandom.nextInt(plusOne) - half; 
    return new int[]{r, g, b}; 
  }
  
  public String asString() {
    StringBuilder b = new StringBuilder(""); 
    for (Action a : lifeEvents) {
      b.append(a.toChar()); 
    }
    return b.toString(); 
  }
  
  public String writeColors() {
    return "R" + asColors[0] + "G" + asColors[1] + "B" + asColors[2]; 
  }
  
  public boolean sameSpecies(Genome other) {
    return geneticDistance(other) <= affinityDistance; 
  }
  
  public int geneticDistance(Genome other) {
    int diffr = asColors[0] - other.asColors[0]; 
    int diffg = asColors[1] - other.asColors[1]; 
    int diffb = asColors[2] - other.asColors[2]; 
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
      newGenome.lengthen();
    }
    newGenome.swap(); 
    return newGenome; 
  }
  
  public void swap() {
    Collections.swap(lifeEvents, genomeRandom.nextInt(lifeEvents.size()), genomeRandom.nextInt(lifeEvents.size()));
  }
  
  public void lengthen() {
    lifeEvents.add(lifeEvents.get(genomeRandom.nextInt(lifeEvents.size()))); 
  }
  
  public void delete() {
    // todo should I make lifeEvents a linked list? 
    lifeEvents.remove(genomeRandom.nextInt(lifeEvents.size()));
  }
  
}
