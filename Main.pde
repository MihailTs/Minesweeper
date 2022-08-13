Field grid[][];
int spaceLR = 30; float spaceUD;
int side;
int rows, cols;
float mineDensity = 5.5;
void setup(){
  fullScreen();
  orientation(PORTRAIT); 
  rows = 10;
  cols = 20;
  side = (width-2*spaceLR)/10;
  spaceUD = (height-20*side)/2;
  grid = new Field[rows][cols];
  
  for(int i = 0; i < rows; i++)
    for(int j = 0; j < cols; j++)
          grid[i][j] = new Field(i, j, side, (random(mineDensity)<1)? true: false, spaceLR, spaceUD);
  
}

void draw(){
  background(150);
  for(int i = 0; i < rows; i++)
    for(int j = 0; j < cols; j++)
        grid[i][j].show();
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
