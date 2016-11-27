
PGraphics pg;
App app;

void setup(){
  size(1280,720);
  frameRate(25);
  pg = createGraphics(1280,720);
  app = new DemoChooserApp(pg);
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