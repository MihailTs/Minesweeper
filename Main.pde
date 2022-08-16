Field grid[][];
int spaceLR = 30; float spaceUD;
int side;
int cols, rows;
float mineDensity = 5.5;
PImage restartIcon;

void setup(){
  fullScreen();
  orientation(PORTRAIT); 
  cols = 10;
  rows = 20;
  side = (width-2*spaceLR)/10;
  spaceUD = (height-20*side)/2;
  restartIcon = loadImage("RestartIcon.png");
  
  restart();
  
}

void draw(){
  background(150);
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
        grid[i][j].show();
        if(!grid[i][j].isMine()) grid[i][j].setAdjNumber(findAdjasentMines(i, j));     
    }
  }
  
  image(restartIcon, (width-side)/2, (spaceUD-side)/2);
  stroke(255, 56, 26); noFill(); square((width-side)/2, (spaceUD-side)/2, side);
  
  noLoop();
}

void mousePressed(){
  
  if(mouseX >= (width-side)/2 && mouseX <= (width-side)/2+side && mouseY >= (spaceUD-side)/2 && mouseY <= (spaceUD-side)/2+side){
      restart();
  }
  
  int x = -1;
  if(mouseX > spaceLR && mouseX < width-spaceLR){
    x = round((mouseX-spaceLR)/side);
  }
  int y = -1;
  if(mouseY > spaceUD && mouseY < height-spaceUD){
    y = round(mouseY/side)-2;
  }
  if(x != -1 && y != -1){
    if(grid[x][y].getAdjNumber() == 0){
      grid[x][y].setOpen();  
      collapse(x, y);
    }
    else grid[x][y].setOpen();
  }
  
  loop();
}

void collapse(int i, int j){
  if(grid[i][j].getAdjNumber() != 0) return;
  if(inGrid(i-1, j-1) && !grid[i-1][j-1].isOpen()) {grid[i-1][j-1].setOpen(); collapse(i-1, j-1);}
  if(inGrid(i-1, j) && !grid[i-1][j].isOpen()) {grid[i-1][j].setOpen(); collapse(i-1, j);}
  if(inGrid(i-1, j+1) && !grid[i-1][j+1].isOpen()) {grid[i-1][j+1].setOpen(); collapse(i-1, j+1);}
  if(inGrid(i, j-1) && !grid[i][j-1].isOpen()) {grid[i][j-1].setOpen(); collapse(i, j-1);}
  if(inGrid(i, j+1) && !grid[i][j+1].isOpen()) {grid[i][j+1].setOpen(); collapse(i, j+1);}
  if(inGrid(i+1, j-1) && !grid[i+1][j-1].isOpen()) {grid[i+1][j-1].setOpen(); collapse(i+1, j-1);}
  if(inGrid(i+1, j) && !grid[i+1][j].isOpen()) {grid[i+1][j].setOpen(); collapse(i+1, j);}
  if(inGrid(i+1, j+1) && !grid[i+1][j+1].isOpen()) {grid[i+1][j+1].setOpen(); collapse(i+1, j+1);}
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
  
  grid = new Field[cols][rows];
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
          grid[i][j] = new Field(i, j, side, (random(mineDensity)<1)? true: false, spaceLR, spaceUD);
          
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
        if(!grid[i][j].isMine()) grid[i][j].setAdjNumber(findAdjasentMines(i, j));     
  
  
  
}
