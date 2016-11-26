
color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;

PImage img;
PGraphics pg;
Checkerboard cb;
int checkDim = 1,  // width of checkerboard squares
    inc = 1;

DisplayText theText;

BoundingBoxMap bm;  

void setup(){
  size(1280,720);
  frameRate(10);
  background(white);
  imageMode(CENTER);
  pg = createGraphics(1280,720);
  PFont font = loadFont("FreeSans-12.vlw");
  textFont(font, 12);
  img = createImage(1280, 720, RGB); //loadImage("iguana1280x720.jpg");
  cb = new Checkerboard(img, checkDim);
  BoundingBoxMap bm =  new BoundingBoxMap();
  theText = new DisplayText(bm,pg);
  println("Using " + (trueBox ? "True" : "Std") + " Box!");
  println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
  updatePG();
}

void draw(){
  background(black);
  updatePG();
  if (displayPG){
    image(pg,width/2.0,height/2.0);
  }
  theText.display();   
}

void updatePG(){
  if (inc!=0 && frameCount%20==0){
    checkDim =max(1,checkDim+inc);
    cb = new Checkerboard(img, checkDim);
  }
  pg.beginDraw();
  pg.background(black);
  pg.image(img,0,0);
  pg.endDraw();
}

boolean displayPG = false,
        trueBox   = true,
        rectFillForSpace = false;

void mousePressed() {
  displayPG = !displayPG;
}

void keyPressed(){
  switch(key){
    case '+':
      inc = 1;
      break;
    case '-':
      inc = -1;
      break;
    case 't':
    case 'T':
      trueBox = !trueBox;
      println("Using " + (trueBox ? "True" : "Std") + " Box!");
      break;
    case 'r':
    case 'R':
      rectFillForSpace = !rectFillForSpace;
      println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
      break;
    default:
      inc=0;
      break;
  }
}