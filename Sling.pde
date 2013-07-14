class Sling {
  
  Body body;
  float w;
  float h;
  
  Sling(Vec2 top, float w_, float h_) {
    w = w_;
    h = h_;
    
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(top.x,top.y+h/2)));
//    if (lock) bd.type = BodyType.STATIC;
//    else
    bd.type = BodyType.DYNAMIC;

    body = box2d.createBody(bd);

    // Define the shape -- a  (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 100;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
  }
  
   Vec2 getAnchorA() {
    float a = body.getAngle();
    float hh = box2d.scalarPixelsToWorld(h/2);
    return new Vec2(-hh * sin(a), hh * cos(a));
  }
  
  Vec2 getAnchorB() {
    float a = body.getAngle();
    float hh = box2d.scalarPixelsToWorld(h/2);
    return new Vec2(hh * sin(a), -hh * cos(a));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Drawing the box
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(127);
    stroke(0);
    strokeWeight(2);
    rect(0,0,w,h);
    popMatrix();
  }
}
