import pbox2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;

PBox2D box2d;
Boundary ground;
Weapon weapon;

boolean paused = true;

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
    if (weapon.getState() == WeaponState.START) {
      weapon.start();
    }
    box2d.step();  // We must always step through time!
  }

  // display the items
  weapon.display();
  ground.display();
  
  // test for launch
  if (weapon.getState() == WeaponState.LAUNCHING) {
    if (weapon.getSlingAngle() < radians(-140)) { //launch
      weapon.launch();
    }
  }
  
  // test for landing of projectile
  float projelev = box2d.coordWorldToPixels(weapon.getProjectile().getWorldCenter()).y;
  // projectile.body.getWorldCenter()
  if (weapon.getState() != WeaponState.LANDED && projelev > (height-20)) {
      weapon.landed();
  }
  
}

void mousePressed() {
  paused = !paused;
}

void keyPressed() {
  if (key == 'r') {
    gameinit();
  }
}

