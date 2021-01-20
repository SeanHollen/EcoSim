class Location implements Comparable<Location> {
  
  private float x; 
  private float y; 
  
  public Location() {
    this.x = random(BOARD_X); 
    this.y = random(BOARD_Y); 
  }
  
  public Location(float x, float y) {
    this.x = x; 
    this.y = y;
  }
  
  public Location onLand() {
    while (isWater(this)) {
      this.x = random(BOARD_X); 
      this.y = random(BOARD_Y); 
    }
    return this;
  }
  
  public Location onWater() {
    while (!isWater(this)) {
      this.x = random(BOARD_X); 
      this.y = random(BOARD_Y); 
    }
    return this;
  }
  
  public float getX() {
    return this.x; 
  }
  
  public float getY() {
    return this.y; 
  }
  
  public void setX(float x) {
    this.x = x; 
  }
  
  public void setY(float y) {
    this.y = y;
  }
  
  public void addToX(float amt) {
    x += amt;
  }
  
  public void subFromX(float amt) {
    x -= amt;
  }
  
  public void addToY(float amt) {
    y += amt;
  }
  
  public void subFromY(float amt) {
    y -= amt;
  }
  
  public void moveBy(float step, float radians) {
    assert (!Float.isNaN(step));
    assert (!Float.isNaN(radians));
    x += step * Math.cos(radians);
    y += step * Math.sin(radians);
    rollOver(); 
  }
  
  public Location getLocOffBy(float step, float radians) {
    float newX = this.x + step * cos(radians); 
    float newY = this.y + step * sin(radians); 
    Location loc = new Location(newX, newY); 
    return loc; 
  }
  
  public Location getBodyLocOffBy(float step, float radians) {
    float newX = this.x + step * cos(radians); 
    float newY = this.y + step * sin(radians); 
    Location loc = new Location(newX, newY); 
    loc.rollOver(); 
    return loc; 
  }
  
  private void rollOver() {
    if (x > BOARD_X) {
      x %= BOARD_X; 
    } else if (x < 0) {
      x = BOARD_X - abs(x); 
    }
    if (y > BOARD_Y) {
      y %= BOARD_Y;
    } else if (y < 0) {
      y = BOARD_Y - abs(y); 
    }
  }
  
  public Location getLocByAdding(Location other) {
    return new Location(this.x + other.x, this.y + other.y); 
  }
  
  public Location getLocBySubtracting(Location other) {
    return new Location(this.x - other.x, this.y - other.y); 
  }
  
  public Location getScaledDownBy(float amt) {
    return new Location(x / amt, y / amt); 
  }
  
  public boolean intersects(Location other, float minCloseness) {
    float distance = sqrt(pow(abs(this.x - other.x), 2) + pow(abs(this.y - other.y), 2));
    return distance <= minCloseness; 
  }
  
  public int compareTo(Location other) {
    if (this.x > other.x) {
      return 1; 
    } else 
    if (this.x < other.x) {
      return -1; 
    } else {
      return 0; 
    }
  }
  
  public String toString() { 
    return "("+round(x)+","+round(y)+")"; 
  }
  
}
