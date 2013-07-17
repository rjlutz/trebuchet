//

class StoneBeam {
  
  Body body;
  float w, h;
  
  StoneBeam(int _x, int _y, int _w, int _h) {
    w = _w;
    h = _h;
    
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(_x,_y));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    ps.setAsBox(box2dW, box2dH);            // rectangle to be the distance from the
                           // center to the edge (so half of what we
                          // normally think of as width or height.) 
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 150;
    fd.friction = 0.5;
    fd.restitution = 0.1;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }
 
  void killBody() {
    box2d.destroyBody(body);
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(225);
    stroke(100);
    strokeWeight(3);
    rect(0,0,w,h);
    popMatrix();
  }
  
}

