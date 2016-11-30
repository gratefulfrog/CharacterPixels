// change the screen1LinesFile to any text file you want
// each line should end with no extra spaces 
// and the file should end at the end of the last line, with no extra lines
// 
// if the file name is given without a full path, then it must be in the data directory
// if not it can be anywhere!

final String screen1LinesFile = "screen1Text.txt";

// set the following variable to false to prevent writing of image files;
boolean writeImages =  false;


PGraphics pg;
App app;
PFont tFont;
final int fntSize  = 22;
final int frameR = 30;

int renderCount = 0;

int screenWidth = 1884,
    screenHeight = 1080;
    
void settings(){
  size(screenWidth,screenHeight);
}


void setup(){
  frameRate(frameR);
  pg = createGraphics(screenWidth,screenHeight);
  tFont = loadFont("Ingeborg-Regular-22.vlw");
  app = new DemoChooserApp(pg,tFont,fntSize,screenWidth,screenHeight,screen1LinesFile);
}

void draw(){
   app.draw();
   if (writeImages && app.doSave()){
     println("Rendering Frame: " + nf(renderCount+1,5) + " of " + nf(app.nbImages,5) + "...");
     saveFrame("Render/" + app.outputFileName + "-" + nf(renderCount++,5) + ".png");
   }
}

void mousePressed(){
  app.mousePressed();
}
void keyPressed(){
  app.keyPressed();
}