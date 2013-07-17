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
   
   boolean standing = true;
   
   StoneBeam topbeam = beams.get(beams.size()-1);
   StoneBeam fourthbeam = beams.get(3);
   
   float topheight = box2d.coordWorldToPixels(topbeam.body.getWorldCenter()).y;
   float fourthheight = box2d.coordWorldToPixels(fourthbeam.body.getWorldCenter()).y;
   
   if (topheight > height-40 && fourthheight > height-40) {
       standing = false;
   }
   return standing;
 }
  
  void killAll() {
    for (StoneBeam beam : beams) {
      beam.killBody();
    }
  }
}
