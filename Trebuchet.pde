import pbox2d.*;
import org.jbox2d.dynamics.joints.*;

PBox2D box2d;
CounterWeight cw;
Boundary ground;
Lever lever;
Sling sling;
Projectile projectile;
RevoluteJoint rj, rjS, rjP;
WeaponState state;

boolean paused = true;
boolean launched = false;

void fixtureInit() {
  launched = false;
  box2d.createWorld();
  box2d.setGravity(0, -10);
  ground = new Boundary(width/2, height-5, 500, 10);

  cw = new CounterWeight(125, 420, 20, 20);
  lever = new Lever(100, 400, 50, 4, 4, 15);
  projectile = new Projectile(25, 450, 3);
  
  //sling = new Sling(new Vec2(25, 400), 1, 50);
  sling = new Sling(lever.getPixelsAnchorB(box2d), 1, 50);

  //lever joint for counterweight
  RevoluteJointDef rjd = new RevoluteJointDef();
  rjd.bodyA = lever.getLeverBody();
  rjd.bodyB = cw.body;
  rjd.localAnchorA = lever.getLocalAnchorA();
  rjd.localAnchorB = cw.getLocalAnchorA();
  rj = (RevoluteJoint) box2d.world.createJoint(rjd);
  
  //joint: lever to sling
  RevoluteJointDef rjdS = new RevoluteJointDef();
  //rjdS.initialize(lever.getLeverBody(), sling.body, box2d.coordPixelsToWorld(new Vec2(25, 400)));
  rjdS.initialize(lever.getLeverBody(), sling.body, lever.getWorldAnchorB());
  rjd.localAnchorA = lever.getLocalAnchorB();
  rjd.localAnchorB = new Vec2(0, box2d.scalarPixelsToWorld(25));
  rjS = (RevoluteJoint) box2d.world.createJoint(rjdS);
  
  //joint: sling to projectile 
  RevoluteJointDef rjdP = new RevoluteJointDef();
  rjdP.initialize(projectile.body, sling.body, box2d.coordPixelsToWorld(new Vec2(25, 450)));
  rjdP.localAnchorA = projectile.getAnchor();
  rjdP.localAnchorB = new Vec2(0, -box2d.scalarPixelsToWorld(25));
  rjP = (RevoluteJoint) box2d.world.createJoint(rjdP);
}

void setup() {
  size(500, 500);
  background(0);
  box2d = new PBox2D(this);
  fixtureInit();
}

void draw() {

  background(255);
  if (!paused) {
    box2d.step();  // We must always step through time!
  }

  // display the counterweight
  cw.display();
  lever.display();
  sling.display();
  ground.display();
  projectile.display();
  
  //line connecting cw and lever
  //displayJointLine(cw.body, cw.getLocalAnchorA(), lever.getLeverBody(), lever.getLocalAnchorA(), false); 
  Vec2 end1 = cw.getPixelsAnchorA(box2d);
  Vec2 end2 = lever.getPixelsAnchorA(box2d);
  stroke(50);
  strokeWeight(1);
  line(end1.x, end1.y, end2.x, end2.y);
  
  float slingAng = sling.body.getAngle();
  //println(degrees(slingAng));
  if (degrees(slingAng) < -150) { //launch
    println("chuckit!");
    if (!launched) {
      box2d.world.destroyJoint((RevoluteJoint)rjP);
      rjP = null;
      launched = true;
    }
  }
}

void mousePressed() {
  paused = !paused;
}

void keyPressed() {
  if (key == 'r') {
    fixtureInit();
  }
}

