class Button {
  
  int x,y;
  PImage icon;
  PFont bf;
  String label;
  boolean visible;
  
  private int dropshadowoffset = 3; 
  
  Button(String _label, int _x, int _y, PImage _icon) {
    this.x = _x;
    this.y = _y;
    this.icon = _icon;
    this.label = _label;
    bf = createFont("Nanum-Brush", 20, true);
    visible = false;
  }
  
  void setVisible(boolean b) {
    visible = b;
  }
  
  boolean isVisible() {
    return visible;
  }
  
  void display() {
    
    if (!visible) return;
    
    image(icon, x-icon.width/2, y-icon.height/2);
    textAlign(CENTER); 
    textFont(bf, 50);  
    fill(200);
    text(label, x+dropshadowoffset, y-dropshadowoffset+20);
    fill(255);
    text(label, x, y+20);
  }
  
  boolean contains(int mouseX, int mouseY) {
    return (abs(mouseX-x) < icon.width/2 && abs(mouseY -y) < icon.height/2) ? true : false;
  }
  
}
