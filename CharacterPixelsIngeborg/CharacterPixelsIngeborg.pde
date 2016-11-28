
PGraphics pg;
App app;
PFont tFont;
int fntSize  = 22;

void setup(){
  size(1884,1080);
  frameRate(25);
  pg = createGraphics(1884,1080);
  tFont = loadFont("Ingeborg-Regular-22.vlw");
  app = new DemoChooserApp(pg,tFont,fntSize);
  String [] lines = split(Screen1Text,'\n');
  textFont(tFont,fntSize);
  for (int i = 0; i< lines.length; i++){
    println(textWidth(lines[i]));
  }
  
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