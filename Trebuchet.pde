// music from http://freedownloads.last.fm/download/240627899/Imagine%2BThe%2BPlace%2BOf%2BNothingness.mp3
// sound effect https://www.pond5.com/sound-effect/8729634/catapult.html

import pbox2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;

PBox2D box2d;
Boundary ground;
Weapon weapon;

Maxim maxim;
AudioPlayer slowwind;
AudioPlayer fastwind;
AudioPlayer slam;
AudioPlayer loop;
AudioPlayer release;

boolean paused = false;

void setup() {
  size(1200, 500);
  background(0);
  box2d = new PBox2D(this);
  gameinit();
  soundinit();
  loop.play();
}

void gameinit() {
  box2d.createWorld();
  box2d.setGravity(0, -10);
  weapon = new Weapon();
  ground = new Boundary(width/2, height-5, width, 10);
}

void soundinit() { 

  // sound initialization
  maxim = new Maxim(this);
  slowwind = maxim.loadFile("slowwind.wav");
  slowwind.volume(1.0);
  slowwind.speed(1.0);
  slowwind.setLooping(false); 

  slam = maxim.loadFile("slam.wav");
  slam.volume(1.0);
  slam.speed(1.0);
  slam.setLooping(false);
  
  loop = maxim.loadFile("Rising Shadows - Imagine The Place Of Nothingness.wav");
  loop.volume(0.9);
  loop.speed(1.0);
  loop.setLooping(true);
  
  release = maxim.loadFile("008729634-catapult.wav");
  release.volume(1.0);
  release.speed(1.0);
  release.setLooping(false);
  
}

void draw() {

  background(255);
  if (!paused) {
    if (weapon.getState() == WeaponState.LIFTING) {
      weapon.applylift();
    }
    box2d.step();  // We must always step through time!
  }

  // display the items
  weapon.display();
  ground.display();

  // test for landing of projectile
  float projelev = box2d.coordWorldToPixels(weapon.getProjectile().getWorldCenter()).y;
  if (weapon.getState() == WeaponState.LAUNCHED && projelev > (height-20)) {
    weapon.setState(WeaponState.LANDED);
  }
}

void mousePressed() {
  if (weapon.getState() == WeaponState.START) {
    weapon.setState(WeaponState.LIFTING);
  }
}

void mouseReleased() {
  if (weapon.getState() == WeaponState.LIFTING) {
    weapon.setState(WeaponState.LAUNCHING);
  } 
  else if (weapon.getState() == WeaponState.LAUNCHING) {
    weapon.setState(WeaponState.LAUNCHED);
  }
}

void keyPressed() {
  if (key == 'r')   gameinit();
  if (key == 'p')  paused = !paused;
}

