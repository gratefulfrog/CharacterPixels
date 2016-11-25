
color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;

PImage img;
Checkerboard cb;
int checkDim = 1,  // width of checkerboard squares
    inc = 1;
DisplayText theText;

void setup(){
  size(1280,720);
  frameRate(10);
  background(white);
  //PFont font = loadFont("TeXGyreHeros-Regular-48.vlw");
  PFont font = loadFont("FreeSans-12.vlw");
  textFont(font, 12);
  img = createImage(1280, 720, RGB);
  cb = new Checkerboard(img, checkDim);
  theText = new DisplayText();
}


void draw(){
  if (frameCount%20==0 && inc!=0){
    checkDim =max(1,checkDim+inc);
    cb = new Checkerboard(img, checkDim);
  }
  background(bg);
  if (displayCB){
    cb.display();
  }
  theText.display();       
}

boolean displayCB = false;

void mousePressed() {
  displayCB = !displayCB;
}

void keyPressed(){
  if (key=='+'){
    inc =1;
  }
  else if (key == '-'){
    inc = -1;
  }
  else{
    inc =0;
  }
}