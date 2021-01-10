class Location implements Comparable<Location> {
  
  private float x; 
  private float y; 
  
  public Location(float x, float y) {
    this.x = x; 
    this.y = y;
  }
  
  public float getX() {
    return this.x; 
  }
  
  public float getY() {
    return this.y; 
  }
  
  public void moveBy(float step, float radians) {
    x += step * Math.cos(radians);
    y += step * Math.sin(radians);
    rollOver(); 
  }
  
  public Location getLocOffBy(float amountOff, float radians) {
    float newX = this.x + amountOff * cos(radians); 
    float newY = this.y + amountOff * sin(radians); 
    return new Location(newX, newY); 
  }
  
  public Location clone() {
    return new Location(x, y);
  }
  
  private void rollOver() {
    if (x > boardX) {
      x %= boardX; 
    } else if (x < 0) {
      x = boardX - abs(x); 
    }
    if (y > boardY) {
      y %= boardY;
    } else if (y < 0) {
      y = boardY - abs(y); 
    }
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
  
}
