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
  PImage trebframe, trebbeamthick, trebbeamthin;
  
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
    
    trebframe = loadImage("treb-frame.png");        // use png for transparency
    trebbeamthick = loadImage("treb-beam-thick.png");
    trebbeamthin = loadImage("treb-beam-thin.png");
  }
  
  void killAll() {
    box2d.destroyBody(lever.body);
    box2d.destroyBody(support.body);
  }

  void display() {
    
    Vec2 anchor = box2d.coordWorldToPixels(lever.body.getWorldCenter());
    float a = lever.body.getAngle();
    
    // the lever / beam
    pushMatrix();
    translate(anchor.x,anchor.y);
    rotate(-a);
    float ctrthinx = (-beamratio-1)*leverW/4; // x center of the thin portion of the beam 
    image(trebbeamthin, ctrthinx-trebbeamthin.width/2,-trebbeamthin.height/2);
    image(trebbeamthick,-trebbeamthick.width/2,-trebbeamthick.height/2);
    popMatrix();
    
    //support
    image(trebframe,0,-supportH);
    
    // Draw (internal) pivoting anchor
    fill(51, 34, 26);
    noStroke();
    ellipse(anchor.x, anchor.y, 8, 8);
    
  }
}


