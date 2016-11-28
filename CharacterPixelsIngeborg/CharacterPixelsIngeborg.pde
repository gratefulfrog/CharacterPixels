
PGraphics pg;
App app;
PFont tFont;
int fntSize  = 22;

void setup(){
  size(1280,720);
  frameRate(25);
  pg = createGraphics(1280,720);
  tFont = loadFont("Ingeborg-Regular-22.vlw");
  app = new DemoChooserApp(pg,tFont,fntSize);
}

void draw(){
  app.draw();
}

void mousePressed(){
  app.mousePressed();
}
void keyPressed(){
  app.keyPressed();
}