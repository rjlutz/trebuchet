import pbox2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;

class Weapon { 

  CounterWeight cw;
  Lever lever;
  Sling sling;
  Projectile projectile;
  RevoluteJoint rj, rjS, rjP;
  WeaponState state;
  Block block;

  Weapon() {
 
    setState(WeaponState.START);

    cw = new CounterWeight(125, height-50, 20, 20);
    lever = new Lever(100, height-70, 50, 4, 4, 15);
    sling = new Sling(lever.getPixelsAnchorB(box2d), 1, 20);
    projectile = new Projectile(sling.getPixelsAnchorB(box2d), 5);
    block = new Block(125, height-20, 10, 40);

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

    //soundinit();
  }

  WeaponState getState() {
    return state;
  }

  void setState(WeaponState w) {
    if (w == WeaponState.START) {
      //
    } 
    else if (w == WeaponState.LIFTING) {
      slowwind.cue(0);
      slowwind.play();
    } 
    else if (w == WeaponState.LAUNCHING) {
      slowwind.stop();
    } 
    else if (w == WeaponState.LAUNCHED) {
      release.cue(0);
      release.play();
      box2d.world.destroyJoint((RevoluteJoint)rjP);
      rjP = null;
      box2d.world.destroyBody(sling.body);
      sling = null;
    } 
    else if (w == WeaponState.LANDED) {
      println("strike!");
      slam.cue(0);
      slam.play();
    } 
    else if (w == WeaponState.REST) {
      //
    }
    state=w;
  }

  void applylift() {
    if (block.body != null) block.killBody();
    lever.lever.body.applyForce(new Vec2(0, -10000), lever.getWorldAnchorB());
  }

  void display() {

    // display the trebuchet components
    cw.display();
    lever.display();
    projectile.display();
    if (sling != null) sling.display();
    if (block.body != null) block.display();

    //line connecting cw and lever
    Vec2 end1 = cw.getPixelsAnchorA(box2d);
    Vec2 end2 = lever.getPixelsAnchorA(box2d);
    stroke(50);
    strokeWeight(1);
    line(end1.x, end1.y, end2.x, end2.y);
  }

  Projectile getProjectile() {
    return projectile;
  }

}

