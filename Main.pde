Field grid[][];
int spaceLR = 30; float spaceUD;
int side;
int cols, rows;
float mineDensity = 5.5;

void setup(){
  fullScreen();
  orientation(PORTRAIT); 
  cols = 10;
  rows = 20;
  side = (width-2*spaceLR)/10;
  spaceUD = (height-20*side)/2;
  grid = new Field[cols][rows];
  
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
          grid[i][j] = new Field(i, j, side, (random(mineDensity)<1)? true: false, spaceLR, spaceUD);
          
  for(int i = 0; i < cols; i++)
    for(int j = 0; j < rows; j++)
        if(!grid[i][j].isMine()) grid[i][j].setAdjNumber(findAdjasentMines(i, j));     
  
}

void draw(){
  background(150);
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
        grid[i][j].show();
        if(!grid[i][j].isMine()) grid[i][j].setAdjNumber(findAdjasentMines(i, j));     
    }
  }
  noLoop();
}

void mousePressed(){
  int x = -1;
  if(mouseX > spaceLR && mouseX < width-spaceLR){
    x = round((mouseX-spaceLR)/side);
  }
  int y = -1;
  if(mouseY > spaceUD && mouseY < height-spaceUD){
    y = round(mouseY/side)-2;
  }
  if(x != -1 && y != -1) grid[x][y].setOpen();
  loop();
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
