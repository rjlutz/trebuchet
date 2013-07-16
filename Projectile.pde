// A projectile 
class Projectile {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  // Constructor
  Projectile(float x, float y, float r) {
    // Add the projectile to the box2d world
    makeBody(x, y, r);
  }
  
  Projectile(Vec2 pixelvec, float r) {
    makeBody(pixelvec.x, pixelvec.y, r);
  }
  
  float getVelocity() {
    return body.getLinearVelocity().length();
  }
  
  float getAngularVelocity() {
    return body.getAngularVelocity();
  }
  

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  Vec2 getLocalAnchorA() {
    //Vec2 anchor = new Vec2(0,-box2d.scalarPixelsToWorld(r));
    Vec2 anchor = new Vec2(0,0);
    return anchor;
  }
  
  Vec2 getWorldCenter() {
    return body.getWorldCenter();  
  }
  

//  // Is the particle ready for deletion?
//  boolean done() {
//    // Let's find the screen position of the particle
//    Vec2 pos = box2d.getBodyPixelCoord(body);  
//    // Is it off the bottom of the screen?
//    if (pos.y > height+w*h) {
//      killBody();
//      return true;
//    }
//    return false;
//  }

   void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(0,0,r,0);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(float x, float y, float r_) {

    this.r = r_;
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r_);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 100;
    fd.friction = 0.9;
    fd.restitution = 0.01;
    
    // Attach fixture to body
    body.createFixture(fd);
  }
}


