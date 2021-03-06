
color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;

PImage img;
PGraphics pg;
int inc = 1;
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
  img = loadImage("iguana1280x720.jpg");
  BoundingBoxMap bm =  new BoundingBoxMap();
  theText = new DisplayText(bm,pg);
  println("Using " + (trueBox ? "True" : "Std") + " Box!");
  println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
  updatePG();
}

int count =0;

void draw(){
  background(black);
  if (rot){
    updatePG();
  }
  if (displayPG){
    image(pg,width/2.0,height/2.0);
  }
  theText.display();   
}

void updatePG(){
  pg.beginDraw();
  pg.pushMatrix();
  pg.background(black);
  pg.imageMode(CENTER);
  pg.translate(width/2.0,height/2.0);
  pg.rotate(radians(5*count++));
  pg.image(img,0,0);
  pg.popMatrix();
  pg.endDraw();
}


boolean rot = false,
        displayPG = false,
        trueBox   = true,
        rectFillForSpace = false;

void mousePressed() {
  displayPG = !displayPG;
}

void keyPressed(){
  switch(key){
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
      rot = !rot;
      break;
  }
}