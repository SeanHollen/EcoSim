import java.util.Random;
static Random genomeRandom = new Random(); 

class Genome {
  
  private ArrayList<Action> lifeEvents; 
  private int eventsIndex; 
  private int[] asColors; 
  
  public Genome(ArrayList<Action> lifeEvents) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
    this.asColors = new int[]{219, 197, 156}; 
  }
  
  public Genome(ArrayList<Action> lifeEvents, int[] colors) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
    this.asColors = colors; 
  }
  
  private Action getNextAction() {
    if (eventsIndex >= lifeEvents.size()) {
      eventsIndex %= lifeEvents.size(); 
    } 
    return lifeEvents.get(eventsIndex++);
  }
  
  public Genome clone() {
    return new Genome(new ArrayList<Action>(lifeEvents), mutatedColor()); 
  }
  
  private int[] mutatedColor() {
    int r = asColors[0] + genomeRandom.nextInt(11) - 5; 
    int g = asColors[1] + genomeRandom.nextInt(11) - 5; 
    int b = asColors[2] + genomeRandom.nextInt(11) - 5; 
    return new int[]{r, g, b}; 
  }
  
  public String asString() {
    StringBuilder b = new StringBuilder(""); 
    for (Action a : lifeEvents) {
      b.append(a.toChar()); 
    }
    return b.toString(); 
  }
  
  public int geneticDistance(Genome other) {
    int diffr = asColors[0] - other.asColors[0]; 
    int diffg = asColors[1] - other.asColors[1]; 
    int diffb = asColors[2] - other.asColors[2]; 
    return abs(diffr) + abs(diffg) + abs(diffb); 
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
  
  public void mutateGene() {
    int idx = genomeRandom.nextInt(lifeEvents.size()); 
    lifeEvents.set(idx, lifeEvents.get(idx).mutation());
  }
  
}
