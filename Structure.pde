class Structure {
  
  ArrayList<StoneBeam> beams;
  private int HORIZ_THRESHOLD = 15;
  
  Structure() {
    
    beams = new ArrayList<StoneBeam>();
    beams.add(new StoneBeam(950, height-56, 6, 60));   // base
    beams.add(new StoneBeam(990, height-56, 6, 60));   // base
    beams.add(new StoneBeam(1030, height-56, 6, 60));  // base
   
    beams.add(new StoneBeam(990, height-83, 90, 6));   // horizontal member  
    beams.add(new StoneBeam(990, height-122, 6, 60));  // top vertical member
  }
  
  void display() {
    for (StoneBeam beam : beams) {
      beam.display(); 
    }
  }
  
float getMaxBeamVelocity() {
  float maxVel = 0;
  for (StoneBeam beam : beams) {
    float vel = beam.body.getLinearVelocity().length();
    maxVel = max(maxVel, vel);
  }
  return maxVel;
}
  
boolean exceedsThreshold(StoneBeam b) {  
  return (b.getYDisp() > HORIZ_THRESHOLD || b.getAngDisp() > PI/4.0);
}
 
 boolean isStanding() {
   boolean exceeds = exceedsThreshold(beams.get(0)) && exceedsThreshold(beams.get(1)) &&
       exceedsThreshold(beams.get(2)) && exceedsThreshold(beams.get(4));
   return !exceeds;
 } 

  // provide ability to remove this item from the physics engine
  void killAll() {
    for (StoneBeam beam : beams) {
      beam.killBody();
    }
  }
}
