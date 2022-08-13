class Field{
  float SPACELR, SPACEUD; 
  float x;
  float y;
  float side;
  boolean mine;
  boolean open; 
  Field(float xoff, float yoff, float s, boolean m, float lr, float ud){
    x = xoff; y = yoff; side = s; mine = m;
    SPACELR = lr; SPACEUD = ud;
    open = false;
  }
  
  void show(){
    if(open){
     if(mine) {PImage img = loadImage("Flag.png");
     image(img, SPACELR+x*side, SPACEUD+y*side);}
     else {fill(0, 255, 0); square(SPACELR+x*side, SPACEUD+y*side, side);}
    }
    else {fill(255); square(SPACELR+x*side, SPACEUD+y*side, side);}
  }
  
  void setOpen(){
    open = true; 
  }
  
  
}
