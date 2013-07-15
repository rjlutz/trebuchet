import pbox2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;

PBox2D box2d;
Boundary ground;
Weapon weapon;

boolean paused = false;

void setup() {
  size(1200, 500);
  background(0);
  box2d = new PBox2D(this);
  gameinit();
}

void gameinit() {
  box2d.createWorld();
  box2d.setGravity(0, -10);
  weapon = new Weapon();
  ground = new Boundary(width/2, height-5, width, 10);
}

void draw() {
  background(255);
  if (!paused) {
    if (weapon.getState() == WeaponState.LIFTING) {
      println("should be lifting");
      weapon.applylift();
    }
    box2d.step();  // We must always step through time!
  }

  // display the items
  weapon.display();
  ground.display();
  
  // test for launch
  if (weapon.getState() == WeaponState.LAUNCHING) {
//    if (weapon.getSlingAngle() < radians(-140)) { //launch
//      weapon.launch();
//    }
  }
  
  // test for landing of projectile
  float projelev = box2d.coordWorldToPixels(weapon.getProjectile().getWorldCenter()).y;
  if (weapon.getState() == WeaponState.LAUNCHED && projelev > (height-20)) {
      weapon.landed();
  }
  
}

void mousePressed() {
  if (weapon.getState() == WeaponState.START) {
    weapon.state = WeaponState.LIFTING;
  }
}

void mouseReleased() {
  if (weapon.getState() == WeaponState.LIFTING) {
    weapon.state = WeaponState.LAUNCHING;
  } else if(weapon.getState() == WeaponState.LAUNCHING) {
   weapon.launch();
  }
  
}

void keyPressed() {
  if (key == 'r')   gameinit();
  if (key == 'p')  paused = !paused;
}

