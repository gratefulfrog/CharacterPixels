// change the screen1LinesFile to any text file you want
// each line should end with no extra spaces 
// and the file should end at the end of the last line, with no extra lines
// 
// if the file name is given without a full path, then it must be in the data directory
// if not it can be anywhere!

final String screen1LinesFile = "screen1Text49lines.txt";

// set the following variable to false to prevent writing of image files, may besetto true for HUGE fonts since mouse access is difficult..
boolean writeImages =  true;


// The font size MUST correspond to a font in the data directory!
// Changing the fntSize will change the image size, and the border width;
// Currently available values are 22, 110, 220
// set the processing memory preference to 16384 MB to ensure a results!!
final int fntSize  = 22;

// This is the number of pixels at the smallest font, it will be scaled if bigger font is specified!
final int border = 3;


////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////    NO USER MODIFABLE VARIABLES AFTER THIS POINT    /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
PGraphics pg;
App app;
PFont tFont;

final int pixelBorder = border*fntSize/22;
final int frameR = 30;

int renderCount = 0;

int screenWidth = 1884*(fntSize/22),
    screenHeight = 1080*(fntSize/22);
    
void settings(){
  size(screenWidth,screenHeight);
}


void setup(){
  frameRate(frameR);
  pg = createGraphics(screenWidth,screenHeight);
  tFont = loadFont("Ingeborg-Regular-" +nf(fntSize) + ".vlw");
  println("Unsing font: Ingeborg-Regular-" +nf(fntSize) + ".vlw");
  //exit();
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