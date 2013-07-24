import pbox2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;

PBox2D box2d;                  // physics environment
Boundary ground;               // the floor
Weapon weapon;                 // the trebuchet

Maxim maxim;                   // helper library
AudioPlayer slowwind;          // slow winding of trebuchet weapon
AudioPlayer fastwind;          // fast winding 
AudioPlayer slam;              // projectile landing noise
AudioPlayer loop;              // background music
AudioPlayer release;           // swoosh noise

Structure structure;           // object to hold the target

int numboulders = 0;           // total # per game
boolean paused = false;        // flag
boolean disableSounds = false; // true for faster debugging, false for production
boolean gameover = true;       // flag
String gamemessage;            // For success or failure

PFont f;                       // default for screen messages 
PImage background;             // backgrounf canvas
PImage boulder;                // image for projectile
PImage bigboulder;             // scale projectile larger for screen display of boulders remaining
color textColor;               // used for text foreground
Button playbutton;             // starts game

void setup() {
  size(1200, 500);
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
  gameinit();
  soundinit();
  if (!disableSounds) loop.play();
  f = createFont("Handwriting-Dakota", 16, true); // 16 point, anti-aliasing on
  background = loadImage("treb-back.jpg");
  boulder = loadImage("boulder.png");             // use png for transparency
  bigboulder = loadImage("boulder.png"); 
  bigboulder.resize(bigboulder.width*2, bigboulder.height*2);  // for the 'boulders remaining' key
  
  playbutton = new Button("Play", width/2, height*5/8, loadImage("playbutton.png")); // slightly below center
  playbutton.setVisible(true); // no game at startup
}

void gameinit() {
  
  numboulders = 5;
  gamemessage = "";
  
  // for all of the following, we need to remove each item from box2d if it already exists from a prior game
  // priot to instantiation
  if (ground != null) ground.killAll(); 
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
  slowwind.volume(3.0);
  slowwind.speed(1.0);
  slowwind.setLooping(false); 

  slam = maxim.loadFile("slam.wav");
  slam.volume(2.5);
  slam.speed(1.0);
  slam.setLooping(false);

  loop = maxim.loadFile("Rising Shadows - Imagine The Place Of Nothingness.wav");
  loop.volume(2.0);
  loop.speed(1.0);
  loop.setLooping(true);

  release = maxim.loadFile("008729634-catapult.wav");
  release.volume(1.10);
  release.speed(1.0);
  release.setLooping(false);
}

void draw() {

  image(background, 0, 0);
  if (!paused) {
    if (weapon.getState() == WeaponState.LIFTING) {
      weapon.applylift();
    }
    box2d.step();  // step through time!
    if (structure.getMaxBeamVelocity() < 1.0 ) { //skip update when structure is swaying
      weapon.updateState();
    }
  }

  // display the items
  weapon.display();
  ground.display();
  structure.display();
  playbutton.display();

  if (!structure.isStanding()) {
    gameover = true;
    textColor = color(186, 219, 53); // bright green, happy! 
    gamemessage = "Success!";
    playbutton.setVisible(true);
  }

  //boulder decoration and boulders remaining
  if (!gameover) {
    image(bigboulder, 40, 50);
    textFont(f, 40);                 
    fill(126, 126, 126);                       
    text(numboulders, 80, 68); 
  }

  if (weapon.getState() == WeaponState.REST) {
    if (!gameover) {
      delay(750);
      numboulders--;
    }
    if (!gameover && numboulders <= 0) {
      gameover = true;
      textColor = color(51, 34, 26); // brown, more somber
      gamemessage = "You lose ...";
      playbutton.setVisible(true);
    }
    weapon.setState(WeaponState.START);
  }

  if (gameover) {
    textFont(f, 72); // game state message
    textAlign(CENTER);
    fill (textColor);
    text (gamemessage, width/2, height*3/8);  // slightly above center
  }
  
}

void mousePressed() {
  if (playbutton.isVisible() && playbutton.contains(mouseX, mouseY)) {
    gameover = false;
    gameinit();
    playbutton.setVisible(false);
    return;
  }
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
    weapon.setState(WeaponState.START); // arm weapon, sppeds up the process when player impatient
    numboulders--;
  }
  if (key == 's')  disableSounds=!disableSounds;
  if (key == 'p')  paused = !paused;
  if (key == 'r')  gameinit();
  if (key == 'q') exit();
}

