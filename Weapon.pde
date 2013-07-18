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
  
  long launchtime;

  Weapon() {
    setState(WeaponState.START);
  }

  WeaponState getState() {
    return state;
  }
  
  void makeTreb() {
   // establish/reestablish trebuchet componenets
      // when re-establishing, need to remove the item from box2d's model before establishing replacement object 
      if (cw != null) cw.killBody();
      cw = new CounterWeight(125, height-76, 20, 20);
      if (lever != null) lever.killAll();
      lever = new Lever(100, height-96, 50, 4, 4, 15);
      if (sling != null) sling.killBody();
      sling = new Sling(lever.getPixelsAnchorB(box2d), 1, 20);
      if (block != null) block.killBody();
      block = new Block(125, height-46, 10, 40);    //joint: lever to counterweight
      if (projectile != null) projectile.killBody();
      projectile = new Projectile(sling.getPixelsAnchorB(box2d), 5);
      
      //joint: cw to lever
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

  void setState(WeaponState w) {
    if (w == WeaponState.START) {
      
      makeTreb();
      
    } else if (w == WeaponState.LIFTING) {
      
      if (!disableSounds) {
        slowwind.cue(0);
        slowwind.play();
      }
      
    } else if (w == WeaponState.LAUNCHING) {
      
      if (!disableSounds) {
        slowwind.stop();
      }
      
    } else if (w == WeaponState.LAUNCHED) {
      
      if (!disableSounds) {
        release.play();
      }
      box2d.world.destroyJoint((RevoluteJoint)rjP);
      rjP = null;
      launchtime = millis();
      
    } else if (w == WeaponState.LANDED) {
      
      if (!disableSounds) {
        slam.play();
      }
      
    } else if (w == WeaponState.REST) {
      
      // TODO maybe animate the bould explding here, with a sound
      
    }
    state=w;
  }
  
  void updateState() {
    
    // test for landing of projectile
    if (weapon.getState() == WeaponState.LAUNCHED) {
      float projelev = box2d.coordWorldToPixels(weapon.getProjectile().getWorldCenter()).y;
      if(projelev > (height-46)) {
        weapon.setState(WeaponState.LANDED);
      }
    }
  
    //check for projectile landed and stopped moving
    if (weapon.getState() == WeaponState.LANDED) {
      float boulderX = box2d.coordWorldToPixels(weapon.getProjectile().getWorldCenter()).x;
      long flightelapsed = millis() - launchtime;
      if (( projectile.getVelocity() < 0.10 && projectile.getAngularVelocity() < 0.01) ||
            boulderX < 0 || 
            boulderX > width ||
            flightelapsed > 10000) { 
        delay(750);
        weapon.setState(WeaponState.REST);
      }
    }
    
  }

  void applylift() {
   
    if (block != null) {
      block.killBody();
      block = null;
    }
    lever.lever.body.applyForce(new Vec2(0, -10000), lever.getWorldAnchorB());
    
  }

  void display() {

    // display the trebuchet components
    if (block != null) block.display();
    cw.display();
    lever.display();
    projectile.display();
    if (sling != null) sling.display();
    

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
  
  void killAll() {
    
    if (cw != null) cw.killBody();
    if (lever != null) lever.killAll();
    if (projectile != null) projectile.killBody();
    if (sling != null) sling.killBody();
    if (block != null) block.killBody();
    
  }

}


