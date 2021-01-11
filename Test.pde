void addTestItems() {
  Location newLocation1 = new Location(400, 400);
  ArrayList<Action> actions = new ArrayList<Action>(); 
  actions.add(new GrowBody()); 
  Plant newPlant = new Plant(new Genome(actions), newLocation1, 2, 10, 50);
  organisms.add(newPlant);
  
  Location newLocation2 = new Location(300, 400);
  Animal animal1 = new Animal(new Genome(actions), newLocation2, 50);
  animal1.setOrientation(0);
  animal1.grazing = 0; 
  organisms.add(animal1);
  
  Location newLocation3 = new Location(500, 400);
  Animal animal2 = new Animal(new Genome(actions), newLocation3, 50);
  animal2.grazing = 0; 
  animal2.setOrientation(PI);
  organisms.add(animal2);
  
  Location newLocation4 = new Location(400, 300);
  Animal animal3 = new Animal(new Genome(actions), newLocation4, 50);
  animal3.grazing = 0; 
  animal3.setOrientation(0.5 * PI);
  organisms.add(animal3);
  
  Location newLocation5 = new Location(400, 500);
  Animal animal4 = new Animal(new Genome(actions), newLocation5, 50);
  animal4.setOrientation(1.5 * PI);
  animal4.grazing = 0; 
  organisms.add(animal4);
}

void addTestPlants() {
  Location newLocation1 = new Location(400, 400);
  ArrayList<Action> actions = new ArrayList<Action>(); 
  actions.add(new GrowCanopy()); 
  Plant newPlant = new Plant(new Genome(actions), newLocation1, 48, 48, 50);
  organisms.add(newPlant);
  
  Location newLocation2 = new Location(420, 400);
  actions.add(new GrowCanopy()); 
  Plant newPlant2 = new Plant(new Genome(actions), newLocation2, 49, 49, 50);
  organisms.add(newPlant2);
  
}
