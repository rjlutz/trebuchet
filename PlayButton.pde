class PlayButton {
  
  int x,y,w,h;
  PImage playbutton;
  
  PlayButton(int _x, int _y, int _w, int _h) {
    this.x = _x;
    this.y = _y;
    this.w = _w;
    this.h = _h;
    playbutton = loadImage("playbutton.png");
  }
  
  void display() {
    image(playbutton, x-w/2, y-h/2);
  }
  
  boolean contains(int mouseX, int mouseY) {
    return (abs(mouseX-x) < w/2 && abs(mouseY -y) < h/2) ? true : false;
  }
  
}
