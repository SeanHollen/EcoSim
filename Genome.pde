import java.util.Random;
static Random genomeRandom = new Random(); 

class Genome {
  
  private ArrayList<Action> lifeEvents; 
  private int eventsIndex; 
  private String asString; 
  
  public Genome(ArrayList<Action> lifeEvents) {
    this.lifeEvents = lifeEvents; 
    this.eventsIndex = 0; 
  }
  
  private Action getNextAction() {
    if (eventsIndex >= lifeEvents.size()) {
      eventsIndex %= lifeEvents.size(); 
    } 
    return lifeEvents.get(eventsIndex++);
  }
  
  public String printSequence() {
    if (asString == null) {
      generateAsString();
    }
    return asString; 
  }
  
  private String generateAsString() {
    StringBuilder b = new StringBuilder(""); 
    for (Action a : lifeEvents) {
      b.append(a); 
    }
    return b.toString(); 
  }
  
  public void swap() {
    Collections.swap(lifeEvents, genomeRandom.nextInt(lifeEvents.size()), genomeRandom.nextInt(lifeEvents.size()));
  }
  
  public void lengthen() {
    lifeEvents.add(lifeEvents.get(genomeRandom.nextInt(lifeEvents.size()))); 
  }
  
  // todo should I make lifeEvents a linked list? 
  public void delete() {
    lifeEvents.remove(genomeRandom.nextInt(lifeEvents.size()));
  }
  
  public void mutateGene() {
    lifeEvents.get(genomeRandom.nextInt(lifeEvents.size())).mutate(); 
  }
  
}
