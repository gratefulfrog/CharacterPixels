
color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;

PImage img;
Checkerboard cb;
int checkDim = 10;  // width of checkerboard squares

DisplayText theText;

void setup(){
  size(1280,720);
  background(white);
  PFont font = loadFont("TeXGyreHeros-Regular-48.vlw");
  textFont(font, 48);
  img = createImage(1280, 720, RGB);
  cb = new Checkerboard(img, checkDim);
  theText = new DisplayText();
}


void draw(){
    background(bg);
    if (displayCB){
      cb.display();
    }
    theText.display();       
}
boolean displayCB = true;
void mousePressed() {
  displayCB = !displayCB;
}