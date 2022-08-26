class Field{
  
  //check main
  float SPACELR, SPACEUD; 
  float x;
  float y;
  float side;
  
  //is it a mine
  boolean mine;
  
  //0 - closed, 1 - open, 2 - marked
  byte state; 
  
  //number from 1 to 8
  byte adjMines;
  PFont font = loadFont("ArialRoundedMTBold-48.vlw");
  //necessary icons
  PImage flagImg, mineImg;
  
  Field(float xoff, float yoff, float s, boolean m, float lr, float ud){
    x = xoff; y = yoff; side = s; mine = m;
    SPACELR = lr; SPACEUD = ud;
    state = 0;
    adjMines = -1;
    flagImg = loadImage("Flag.png");
    mineImg = loadImage("Mine.png");
  }
  
  void show(){
    
    if(state >= 1){
      if((x%2==0 && y%2==1) || (x%2==1 && y%2==0)) fill(247, 243, 150);
      else fill(234, 232, 192);
      square(SPACELR+x*side, SPACEUD+y*side, side);
      
      if(state == 2) image(flagImg, SPACELR+x*side, SPACEUD+y*side);
      else if(mine) image(mineImg, SPACELR+x*side, SPACEUD+y*side);
      else {
        if(adjMines > 0){
          textSize(50); textFont(font, 50); fill(52, 227, 18);
          text(adjMines, SPACELR+(x+0.285)*side, SPACEUD+(y+0.775)*side);}
      }
    }
    else {fill(255); square(SPACELR+x*side, SPACEUD+y*side, side);}
  }
  
  //getters and setters
  void setOpen(){
    state = 1; 
  }
  
  boolean isOpen(){
    return state==1; 
  }
  
  byte getAdjNumber(){
    return adjMines; 
  } 
  
  boolean isMine(){
    return mine;
  }
  
  void setAdjNumber(byte n){
     adjMines = n;
  }
  
  void mark(){
     state = 2;
  }
  
  void unmark(){
     state = 0; 
  }
  
  boolean isMarked(){
     return state == 2; 
  }
  
}
