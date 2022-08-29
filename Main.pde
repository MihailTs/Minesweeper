import ketai.ui.*;

Field grid[][];
//space on the left, rightm up and down
int spaceLR = 30; float spaceUD;
int side;
int cols, rows;

//for easier game make it higher
float mineDensity = 6.5;

int mineCnt;
int markedCnt;

int pressedX, pressedY;

String icons[];
PImage restartIcon;

KetaiVibrate vibe;
long[] pattern;

//milliseconds counting how long the press lasted
long m = 0;

boolean gameOn = true;

void setup(){
  fullScreen();
  orientation(PORTRAIT);
  
  cols = 10;
  rows = 20;
  side = (width-2*spaceLR)/10;
  spaceUD = (height-20*side)/2;
  
  vibe = new KetaiVibrate(this);
  pattern = new long[]{0, 30};
  
  icons = new String[]{"R2D2.png", "BB8.png", "BobaFett.png", "DarthVader.png", "KyloRen.png", "Logo1.png",
  "Logo2.png", "Logo3.png", "PodRacer.png", "Stormtrooper.png"};
  
  restartIcon = loadImage(icons[floor(random(10))]);
  
  grid = new Field[cols][rows];
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++){
          grid[i][j] = new Field(i, j, side, (random(mineDensity)<1)? true: false, spaceLR, spaceUD);
          if(grid[i][j].isMine()) {mineCnt++; markedCnt++;}
    }
  
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
          if(!grid[i][j].isMine()) grid[i][j].setAdjNumber(findAdjasentMines(i, j)); 
  
}

void draw(){
  background(150);
  stroke(255, 56, 26); 
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
        grid[i][j].show();
  
  //add an icon to the restart button
  image(restartIcon, (width-side)/2, (spaceUD-side)/2);
  noFill(); square((width-side)/2, (spaceUD-side)/2, side);


  if(!gameOn){
    if(mineCnt == 0) {
        textSize(151); fill(34, 193, 14);
        text("YOU WIN", spaceLR, height/2); 
    }else{
        textSize(127); fill(255, 0, 0);
        text("YOU LOSE", spaceLR, height/2); 
    }
  }
    
  noLoop();
}

void mousePressed(){
    m = millis();
    
    int x = -1;
    if(mouseX > spaceLR && mouseX < width-spaceLR){
      x = round((mouseX-spaceLR)/side);
    }
    int y = -1;
    if(mouseY > spaceUD && mouseY < height-spaceUD){
      y = round(mouseY/side)-2;
    }
    pressedX = x;
    pressedY = y;
    
    if(inGrid(x, y) && !grid[x][y].isOpen())
      vibe.vibrate(pattern, -1);   
}

void mouseReleased(){
   
  //check if restart is clicked
  if(mouseX >= (width-side)/2 && mouseX <= (width-side)/2+side && mouseY >= (spaceUD-side)/2 && mouseY <= (spaceUD-side)/2+side) restart();
  
  if(gameOn){
    //finding the coordinates of the pressed field
    int x = -1;
    if(mouseX > spaceLR && mouseX < width-spaceLR){
      x = round((mouseX-spaceLR)/side);
    }
    int y = -1;
    if(mouseY > spaceUD && mouseY < height-spaceUD){
      y = round(mouseY/side)-2;
    }
    
    if(x != pressedX || y != pressedY) return;
    
    changeField(x, y);
  
     m = 0;
  }
  if(mineCnt == 0 && markedCnt == 0) gameWon();
  loop();
}

void collapse(int i, int j){
  //backtrack to every 'empty' field adjacent to the current one
  if(grid[i][j].getAdjNumber() != 0) return;
  if(inGrid(i-1, j-1) && !grid[i-1][j-1].isOpen() && !grid[i-1][j-1].isMarked()) {grid[i-1][j-1].setOpen(); collapse(i-1, j-1);}
  if(inGrid(i-1, j) && !grid[i-1][j].isOpen() && !grid[i-1][j].isMarked()) {grid[i-1][j].setOpen(); collapse(i-1, j);}
  if(inGrid(i-1, j+1) && !grid[i-1][j+1].isOpen() && !grid[i-1][j+1].isMarked()) {grid[i-1][j+1].setOpen(); collapse(i-1, j+1);}
  if(inGrid(i, j-1) && !grid[i][j-1].isOpen() && !grid[i][j-1].isMarked()) {grid[i][j-1].setOpen(); collapse(i, j-1);}
  if(inGrid(i, j+1) && !grid[i][j+1].isOpen() && !grid[i][j+1].isMarked()) {grid[i][j+1].setOpen(); collapse(i, j+1);}
  if(inGrid(i+1, j-1) && !grid[i+1][j-1].isOpen() && !grid[i+1][j-1].isMarked()) {grid[i+1][j-1].setOpen(); collapse(i+1, j-1);}
  if(inGrid(i+1, j) && !grid[i+1][j].isOpen() && !grid[i+1][j].isMarked()) {grid[i+1][j].setOpen(); collapse(i+1, j);}
  if(inGrid(i+1, j+1) && !grid[i+1][j+1].isOpen() && !grid[i+1][j+1].isMarked()) {grid[i+1][j+1].setOpen(); collapse(i+1, j+1);}
}

boolean inGrid(int i, int j){
   return i >= 0 && j >= 0 && i < cols && j < rows; 
}

byte findAdjasentMines(int i, int j){
  byte cnt = 0;
  if(i == 0 && j == 0){
     if(grid[i+1][j].mine) cnt++; 
     if(grid[i+1][j+1].mine) cnt++; 
     if(grid[i][j+1].mine) cnt++; 
     return cnt;
  }
  if(i == cols-1 && j == 0){
     if(grid[i-1][j].mine) cnt++; 
     if(grid[i-1][j+1].mine) cnt++; 
     if(grid[i][j+1].mine) cnt++; 
     return cnt;
  }
  if(i == 0 && j == rows-1){
     if(grid[i+1][j].mine) cnt++; 
     if(grid[i][j-1].mine) cnt++; 
     if(grid[i+1][j-1].mine) cnt++; 
     return cnt;
  }
  if(i == cols-1 && j == rows-1){
     if(grid[i-1][j].mine) cnt++; 
     if(grid[i-1][j-1].mine) cnt++; 
     if(grid[i][j-1].mine) cnt++; 
     return cnt;
  }
  if(i == 0){
    if(grid[i][j+1].mine) cnt++; 
    if(grid[i][j-1].mine) cnt++; 
    if(grid[i+1][j-1].mine) cnt++; 
    if(grid[i+1][j+1].mine) cnt++; 
    if(grid[i+1][j].mine) cnt++; 
    return cnt;
  }
  if(i == cols-1){
    if(grid[i][j+1].mine) cnt++; 
    if(grid[i][j-1].mine) cnt++; 
    if(grid[i-1][j-1].mine) cnt++; 
    if(grid[i-1][j+1].mine) cnt++; 
    if(grid[i-1][j].mine) cnt++; 
    return cnt;
  }
  if(j == 0){
    if(grid[i-1][j].mine) cnt++; 
    if(grid[i+1][j].mine) cnt++; 
    if(grid[i][j+1].mine) cnt++; 
    if(grid[i+1][j+1].mine) cnt++; 
    if(grid[i-1][j+1].mine) cnt++; 
    return cnt;
  }
  if(j == rows-1){
    if(grid[i-1][j].mine) cnt++; 
    if(grid[i+1][j].mine) cnt++; 
    if(grid[i-1][j-1].mine) cnt++; 
    if(grid[i][j-1].mine) cnt++; 
    if(grid[i+1][j-1].mine) cnt++; 
    return cnt;
  }
  
  if(grid[i-1][j-1].mine) cnt++; 
  if(grid[i-1][j].mine) cnt++; 
  if(grid[i-1][j+1].mine) cnt++; 
  if(grid[i][j-1].mine) cnt++; 
  if(grid[i][j+1].mine) cnt++; 
  if(grid[i+1][j-1].mine) cnt++; 
  if(grid[i+1][j].mine) cnt++; 
  if(grid[i+1][j+1].mine) cnt++; 
  return cnt;
}

void restart(){
  gameOn = true;
  mineCnt = 0; markedCnt = 0;
  
  grid = new Field[cols][rows];
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++){
          grid[i][j] = new Field(i, j, side, (random(mineDensity)<1)? true: false, spaceLR, spaceUD);
          if(grid[i][j].isMine()) {mineCnt++; markedCnt++;}
    }
    
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
          if(!grid[i][j].isMine()) grid[i][j].setAdjNumber(findAdjasentMines(i, j)); 
}

void gameWon(){
  gameOn = false;
  
  for(int i = 0; i < cols; i++)
      for(int j = 0; j < rows; j++)
        if(!grid[i][j].isMarked()) grid[i][j].setOpen();  
}

void gameLost(){
  gameOn = false;
  
  for(int i = 0; i < cols; i++)
      for(int j = 0; j < rows; j++)
         grid[i][j].setOpen();  
}

void changeField(int x, int y){
  //check for every possible state of the field and take action for changing it
  if(millis()-m >= 300 && inGrid(x, y) && !grid[x][y].isOpen()) {
      grid[x][y].mark();
      if(grid[x][y].isMine()) mineCnt--;
      markedCnt--;}
  else if(inGrid(x, y)){
     if(grid[x][y].isMarked()){
       if(grid[x][y].isMine()) mineCnt++;
       markedCnt++;
       grid[x][y].unmark();}
     else if(!grid[x][y].isOpen()){
       if(grid[x][y].getAdjNumber() == 0){
         grid[x][y].setOpen();  
         collapse(x, y);}
       else {
         grid[x][y].setOpen();
         if(grid[x][y].isMine()) {
           gameLost(); loop(); return;
         }
       }
     }
  }
}
