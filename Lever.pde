import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// Class to describe a fixed plus pivoting object
class Lever {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  RevoluteJoint joint;
  Box support;
  Box lever;
  
  final float beamratio = 3.75;
  
  int leverW, leverH, supportW, supportH;
  
  Body getLeverBody() {
    return lever.body;
  }
  
  Vec2 getLocalAnchorA() {
    float a = lever.body.getAngle();
    float hw = box2d.scalarPixelsToWorld(leverW/2);
    return new Vec2(hw * cos(a), hw * sin(a));
  }
  
  Vec2 getWorldAnchorA() {
    return lever.body.getWorldCenter().add(getLocalAnchorA());
  }
  
  Vec2 getPixelsAnchorA(PBox2D box2d) {
    return box2d.coordWorldToPixels(getWorldAnchorA());
  }
  
  Vec2 getLocalAnchorB() {
    float a = lever.body.getAngle();
    float hw = box2d.scalarPixelsToWorld(beamratio * leverW/2);
    return new Vec2(-hw * cos(a), -hw * sin(a));
  }
  
  Vec2 getWorldAnchorB() {
    return lever.body.getWorldCenter().add(getLocalAnchorB());
  }
  
  Vec2 getPixelsAnchorB(PBox2D box2d) {
    return box2d.coordWorldToPixels(getWorldAnchorB());
  }

  Lever(float x, float y, int leverW, int leverH, int supportW, int supportH) {

    this.leverW = leverW;
    this.leverH = leverH;
    this.supportW = supportW;
    this.supportH = supportH;
  
    // Initialize locations of two boxes
    lever = new Box(x, y-supportH/2, leverW, leverH, false); 
    support = new Box(x, y, supportW, supportH, true); 

    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();
    rjd.initialize(support.body, lever.body, lever.body.getWorldCenter());
    
    // needed to slow the pendulum down
    rjd.maxMotorTorque =6000f;
    rjd.motorSpeed = 0.0f;
    rjd.enableMotor = true;
    
    // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd); 
  }

  void display() {
    
    support.display();
    lever.display();

    // Draw (internal) pivoting anchor, just for debug
    Vec2 anchor = box2d.coordWorldToPixels(lever.body.getWorldCenter());
    fill(0);
    noStroke();
    ellipse(anchor.x, anchor.y, 8, 8);
    
    Vec2 ctr = box2d.coordWorldToPixels(lever.body.getWorldCenter());
    float a = lever.body.getAngle();
    Vec2 end1 = new Vec2(-leverW/2, 0);
    Vec2 end2 = new Vec2(-beamratio*leverW/2, 0);
    pushMatrix();
    translate(ctr.x,ctr.y);
    rotate(-a);
    stroke(127);
    strokeWeight(2);
    line(end1.x, end1.y, end2.x, end2.y);
    popMatrix();
  }
}


