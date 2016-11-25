/*
color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;

PGraphics pg;

color textFill = black;

void setup() {
  size(1280, 720);
  char c =  'g';
  pg = createGraphics(400, 400);
  pg.beginDraw();
  PFont font = loadFont("FreeSans-12.vlw");
  pg.textFont(font, 58);
  pg.textAlign(LEFT,TOP);
  pg.background(white);
  pg.fill(textFill);
  pg.text(c,0,0);
  pg.endDraw();
  pg.loadPixels();
  int top = Top(pg),
      bottom = Bottom(pg),
      left = Left(pg),
      right=Right(pg),
      offset=50;
  println("Top", top);
  println("Bottom", bottom);
  println("right", right);
  image(pg, offset, offset);
  stroke(red);
  line(0,offset+top,width,offset+top);
  stroke(blue);
  line(0,offset+bottom,width,offset+bottom);
  stroke(green);
  line(left+offset,0,left+offset,height);
  line(right+offset,0,right+offset,height);
}

*/


void setup() {
  size(1280, 720);
 BoundingBoxMap bm =  new BoundingBoxMap();
  /*Character c =  'g';
  //BoundingBox b = bm.get(c);
  println("Left: ",b.left);
  println("Right: ",b.right);
  println("Top: ",b.top);
  println("Bottom: ",b.bottom);
  */
  background(white);
  for (int i=0; i< alphabet.length(); i++){
    Character c = alphabet.charAt(i);
    BoundingBox b = bm.get(c);
    show(c,b,i*15,i*15);//width/2.0,height/2.0);
  }
}

void show(Character c, BoundingBox b, float x, float y){
  PFont font = loadFont("FreeSans-12.vlw");
  textFont(font,12);
  fill(black);
  textAlign(LEFT,TOP);
  pushMatrix();
  translate(x,y);
  text(c,0,0);
  stroke(red);
  line(-x,b.top,width-x,b.top);
  line(-x,b.bottom,width-x,b.bottom);
  stroke(green);
  line(b.left,-y,b.left,height-y);
  line(b.right,-y,b.right,height-y);
  popMatrix();
}
  

void draw() {
}