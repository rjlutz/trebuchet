class Block {
 
  Body body;
  float w, h;
  PImage stick;
  
  Block (float _x, float _y, float _w, float _h) {
    w = _w;
    h = _h;
    //body = new Box(_x, _y, w, h, true); 
    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(_x,_y));
    body = box2d.createBody(bd);
    body.setFixedRotation(true);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    ps.setAsBox(box2dW, box2dH);                    // rectangle to be the distance from the
                                                    // center to the edge (so half of what we
                                                    // normally think of as width or height.) 
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 800;
    fd.friction = 0.9;
    fd.restitution = 0.01;

    // Attach Fixture to Body               
    body.createFixture(fd);
    
    stick = loadImage("stick.png");        // use png for transparency
  }
 
 // provide ability to remove thisitem from the physics engine
  void killBody() {
    box2d.destroyBody(body);
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    image(stick,-w,-h/2);
    popMatrix(); 
  }
  
}
