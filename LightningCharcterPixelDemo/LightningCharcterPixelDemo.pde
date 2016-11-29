
PGraphics pg;
App app;
PFont tFont;
int fntSize  = 22;

void setup(){
  size(1884,1080);
  frameRate(15);
  pg = createGraphics(1884,1080);
  tFont = loadFont("Ingeborg-Regular-22.vlw");
  app = new DemoChooserApp(pg,tFont,fntSize,1884);
  /*
  Justifier j = new Justifier(Screen1Lines, tFont,fntSize ,1884);
  textFont(tFont,fntSize);
  for(int i=0; i<j.spaceDeltaVec.length;i++){
    println(textWidth(Screen1Lines[i]), j.spaceDeltaVec[i]);
  }
  */
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