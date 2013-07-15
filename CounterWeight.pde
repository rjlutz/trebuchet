/*
 references
 http://www.algobeautytreb.com/trebmath35.pdf
 http://www.real-world-physics-problems.com/trebuchet-physics.html
 
*/

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

class CounterWeight {
  
  Body body;     
  float x,y,w,h;
  
  void reset() {
    setup();
  }
  
  void setup() {
    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
//    this.x = x;
//    this.y = y;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    body.setFixedRotation(true);


    // Define a polygon (this is what we use for a rectangle)
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    ps.setAsBox(box2dW, box2dH);            // rectangle to be the distance from the
                           // center to the edge (so half of what we
                          // normally think of as width or height.) 
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 800;
    fd.friction = 0.9;
    fd.restitution = 0.01;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }

  CounterWeight(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    setup();
  }
  
  Vec2 getLocalAnchorA() {
    return new Vec2(0,box2d.scalarPixelsToWorld(h/2));
  }
  
  Vec2 getWorldAnchorA() {
    return body.getWorldCenter().add(getLocalAnchorA());
  }
  
  Vec2 getPixelsAnchorA(PBox2D box2d) {
    return box2d.coordWorldToPixels(getWorldAnchorA());
  }

  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x,pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
    fill(127);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }

}

