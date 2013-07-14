import pbox2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;

PBox2D box2d;
CounterWeight cw;
Boundary ground;
Lever lever;
Sling sling;
Projectile projectile;
RevoluteJoint rj, rjS, rjP;
WeaponState state;

boolean paused = true;

void fixtureInit() {
  
  box2d.createWorld();
  box2d.setGravity(0, -10);
  
  state = WeaponState.START;
  
  ground = new Boundary(width/2, height-5, width, 10);
  cw = new CounterWeight(125, height-50, 20, 20);
  lever = new Lever(100, height-70, 50, 4, 4, 15);
  sling = new Sling(lever.getPixelsAnchorB(box2d), 1, 20);
  projectile = new Projectile(sling.getPixelsAnchorB(box2d), 5);

  //joint: lever to counterweight
  RevoluteJointDef rjd = new RevoluteJointDef();
  rjd.bodyA = lever.getLeverBody();
  rjd.bodyB = cw.body;
  rjd.localAnchorA = lever.getLocalAnchorA();
  rjd.localAnchorB = cw.getLocalAnchorA();
  rj = (RevoluteJoint) box2d.world.createJoint(rjd);
  
  //joint: lever to sling
  RevoluteJointDef rjdS = new RevoluteJointDef();
  rjdS.initialize(lever.getLeverBody(), sling.body, lever.getWorldAnchorB());
  rjd.localAnchorA = lever.getLocalAnchorB();
  rjd.localAnchorB = sling.getLocalAnchorA();
  rjS = (RevoluteJoint) box2d.world.createJoint(rjdS);
  
  //joint: sling to projectile 
  RevoluteJointDef rjdP = new RevoluteJointDef();
  rjdP.initialize(projectile.body, sling.body, sling.getPixelsAnchorB(box2d));
  rjdP.localAnchorA = projectile.getLocalAnchorA();
  rjdP.localAnchorB = sling.getLocalAnchorB();
  rjP = (RevoluteJoint) box2d.world.createJoint(rjdP);
}

void setup() {
  size(1200, 500);
  background(0);
  box2d = new PBox2D(this);
  fixtureInit();
}

void draw() {

  background(255);
  if (!paused) {
    if (state == WeaponState.START) {
      state=WeaponState.LAUNCHING;
      lever.lever.body.applyLinearImpulse(new Vec2(0, -7000), lever.getWorldAnchorB());
      //lever.lever.body.setTransform(leverStart, radians(-45));
    }
    box2d.step();  // We must always step through time!
  }

  // display the trebuchet components
  cw.display();
  lever.display();
  if (sling != null) sling.display();
  ground.display();
  projectile.display();
  
  //line connecting cw and lever
  Vec2 end1 = cw.getPixelsAnchorA(box2d);
  Vec2 end2 = lever.getPixelsAnchorA(box2d);
  stroke(50);
  strokeWeight(1);
  line(end1.x, end1.y, end2.x, end2.y);
  
  // test for launch
  if (state == WeaponState.LAUNCHING) {
    float slingAng = sling.body.getAngle();
    if (degrees(slingAng) < -140) { //launch
      box2d.world.destroyJoint((RevoluteJoint)rjP);
      rjP = null;
      state=WeaponState.LAUNCHED;
      box2d.world.destroyBody(sling.body);
      sling = null;
    }
  }
  
  // test for landing of projectile
  float projelev = box2d.coordWorldToPixels(projectile.body.getWorldCenter()).y;
  if (state != WeaponState.LANDED && projelev > (height-20)) {
      landed();
  }
  
}

void landed() {
  println("strike!");
  state=WeaponState.LANDED;
}

void mousePressed() {
  paused = !paused;
}

void keyPressed() {
  if (key == 'r') {
    fixtureInit();
  }
}

