class Structure {
  
  ArrayList<StoneBeam> beams;
  
  Structure() {
    beams = new ArrayList<StoneBeam>();
    beams.add(new StoneBeam(950, height-30, 6, 60));
    beams.add(new StoneBeam(990, height-30, 6, 60));
    beams.add(new StoneBeam(1030, height-30, 6, 60)); 
   
    beams.add(new StoneBeam(990, height-57, 90, 6));
    //beams.add(new StoneBeam(1010, height-60, 40, 5)); 
    
    beams.add(new StoneBeam(990, height-96, 6, 60));
  }
  
  void display() {
    for (StoneBeam beam : beams) {
      beam.display(); 
    }
  }
 
 boolean isStanding() {
   boolean demoed = false;
   boolean standing = true;
   for (StoneBeam beam : beams) {
     float delta = abs(beam.body.getAngle());
     print(delta + " ");
     if (delta > PI/3) { // PI/3 = 60 degrees 
       standing = standing & false;
     }
   }
   println();
   return standing;
 }
  
  void killAll() {
    for (StoneBeam beam : beams) {
      beam.killBody();
    }
  }
}
