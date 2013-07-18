// http://en.wikipedia.org/wiki/Trebuchet
// http://www.real-world-physics-problems.com/trebuchet-physics.html
// http://www.algobeautytreb.com/trebmath35.pdf

// music from http://freedownloads.last.fm/download/240627899/Imagine%2BThe%2BPlace%2BOf%2BNothingness.mp3
// sound effect https://www.pond5.com/sound-effect/8729634/catapult.html
// other sounds from the family's summer cabin (slamming door, creaking door)

// the nature of code

// angry birds ref image http://www.toptechreviews.net/wp-content/uploads/2013/01/angry_birds.jpg

// http://blog.timesunion.com/derosier/files/2012/01/0113_derosier1002.jpg

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

Structure structure;

int numboulders = 0;
boolean paused = false;
boolean disableSounds = true; // true for faster debugging, false for production
boolean gameover;
String gamemessage;

PFont f;
PImage background, boulder, bigboulder;
color bgColor;

void setup() {
  size(1200, 500);
  //background(0);
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
  gameinit();
  soundinit();
  if (!disableSounds) loop.play();
  f = createFont("Arial", 16, true);           // Arial, 16 point, anti-aliasing on
  background = loadImage("treb-back.jpg");
  boulder = loadImage("boulder.png");        // use png for transparency
  bigboulder = loadImage("boulder.png"); 
  bigboulder.resize(bigboulder.width*2, bigboulder.height*2);              // for the 'boulders remaining' key
}

void gameinit() {
  numboulders = 5;
  gameover = false;
  if (ground != null) ground.killBody();
  ground = new Boundary(width/2, height-31, width, 10);
  if (structure != null) structure.killAll();
  structure = new Structure();
  if (weapon != null) weapon.killAll();
  weapon = new Weapon();
}

void soundinit() { 

  if (disableSounds) return;

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
  release.volume(2.0);
  release.speed(1.0);
  release.setLooping(false);
}

void draw() {

  background(255);
  image(background, 0, 0);
  if (!paused) {
    if (weapon.getState() == WeaponState.LIFTING) {
      weapon.applylift();
    }
    box2d.step();  // We must always step through time!
  }

  // display the items
  weapon.display();
  ground.display();
  structure.display();

  weapon.updateState();
  if (!structure.isStanding()) {
    gameover = true;
    bgColor = color(186, 219, 53); // bright green, happy! 
    gamemessage = "Success!";
  }

  //boulder decoration and boulders remaining
  image(bigboulder, 40, 50);
  textFont(f, 40);                 
  fill(126, 126, 126);                       
  text(numboulders, 80, 76); 

  if (weapon.getState() == WeaponState.REST) {
    if (!gameover) {
      numboulders--;
    }
    if (!gameover && numboulders <= 0) {
      gameover = true;
      bgColor = color(51, 34, 26); // brown, more somber
      gamemessage = "You lose ...";
    }
    weapon.setState(WeaponState.START);
  }

  if (gameover) {
    textFont(f, 72); // game state message
    textAlign(CENTER);
    fill (bgColor);
    text (gamemessage, width/2, height/2);
  }
  
}

void mousePressed() {
  if (!gameover && weapon.getState() == WeaponState.START) {
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
  if (key == 'a') {
    weapon.setState(WeaponState.START); // arm weapon
    numboulders--;
  }
  if (key == 'p')  paused = !paused;
  if (key == 'r')  gameinit();
}

