import processing.svg.*;

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////               Text Lines Input File Name           /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// change the screenLinesFile to any text file you want
// each line should end with no extra spaces 
// and the file should end at the end of the last line, with no extra lines
// 
// if the file name is given without a full path, then it must be in the data directory
// if not it can be anywhere!

final String screenLinesFile = "screen1Text49lines.txt";

////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////   Font Family & Size and Screen & Border Dimensions   ////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The font name and size MUST correspond to a font in the data directory!
// The fontFamily name should be something like  "Ingeborg-New-f", or "Times" without trailing 
// dash's.
// to ensure correct font generation, place the original font file in the data directory!
final String fontFamily = "Ingeborg-New-f";

// point size of font
final int fntSize  = 22;

// This is the number of pixels to be used as a border on all sides of the text
final int leftborder  = 3;
final int rightborder = 3;
final int upperborder = 2;
final int lowerborder = 8;  // needs to be bigger for charcters with descent, eg. y, g, q, p ...

// screen size in pixels
final int screenWidth  = 1884;
final int screenHeight = 1080;

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////           Image Files Input File Base Name         /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The following variable determines the source file name for the underlying image frames. 
// The source image frames must be placed in the data directory.
// The variable contains the base image file name, and to that will be added _00000.png, _00001.png  etc.
final String baseImageFileName = "Lightning";

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////                 Frames to be Rendered              /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The next variables determine which frames are rendered.  The startFrame is where rendering starts, 
// and the numberOfFrames is how many to render. For example if we start at frame 0 and render 3 frames,
// we will get frame-0, frame-1,frame-2
// These variables are usefull to render only some specific frames after a failure, or if some of the
// underlying images were modified.
final int startFrame     = 0;
final int numberOfFrames = 5; //300;

// directory where the rendered frames are saved

final String renderDirectory = "Render";

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// FONT HORIZONTAL SPACING COMPENSATION ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// setting this variable to true cause the program to try to compensate for font problems in 
// horizontal spacing. Caution should be used since thi may increase line length and cause overlaps.

boolean useCompensatedWidth = true;

// This is the name of the csv file in the data directory that contains any manual horizontal compensation
final String compensationFileName = "compINF22.csv"; 

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////   NO USER MODIFIABLE VARIABLES BEYOND THIS POINT   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
PGraphics pgA;
App app;
PFont tFont;

FixedHorizontalCompensationMap fHCM;

final String separator = "/";
final String renderDir = renderDirectory + separator;

final String svgFileName = split(screenLinesFile,".")[0] + ".svg";

final int[] pixelBorderVec = {leftborder,rightborder,upperborder,lowerborder};
final int leftIndex  = 0,
          rightIndex = 1,
          upperIndex = 2,
          lowerIndex = 3;

final int normalFPS = 30;

boolean writeImages           = false,
        specialOneFrameRender = false,
        writeSVG              = false;

void settings(){
  size(screenWidth,screenHeight);
}

void setup(){
  frameRate(normalFPS);
  pgA = createGraphics(screenWidth,screenHeight);
  String fName = fontFamily+ "-" +nf(fntSize) + ".vlw";
  tFont = createFont(fontFamily,22,true);
  println("Using font: " + fName);
  println("Using " + (useCompensatedWidth ? "Compensated" : "Standard") + " horizontal spacing!");
  fHCM = loadHorizontalCompensation();
  if (useCompensatedWidth && (fHCM.size() !=0)){
    println("Using manual compensation values from file: " + compensationFileName);
  }
  app = new ChooserApp(pgA,tFont,fntSize,screenWidth,screenHeight,screenLinesFile,baseImageFileName);
}

void draw(){
   if (app.doRecordSVG){
      beginRecord(SVG, renderDir + svgFileName);
      println("Rendering SVG file: " + 
             svgFileName + 
              "...");
    }
   app.draw();
   if (writeImages && app.doSave()){
     int currentFrameID = app.outputImageCount-1 + startFrame,
         endFrameID = startFrame+numberOfFrames-1; 
     if (specialOneFrameRender){
        currentFrameID = app.outputImageCount-1;
        endFrameID  = app.nbImages-1;
     }         
     println("Rendering Frame: " + 
             app.baseName + 
             "_" + 
             nf(currentFrameID,5) + 
             " of " + 
             nf(endFrameID,5) + 
             " ...");
     saveFrame(renderDir + 
               app.baseName + 
               "Frame-" + 
               nf(currentFrameID,5) + 
               ".png");
   }
     if(app.doRecordSVG){
      endRecord();
      app.doRecordSVG=false;
      println("SVG Render Complete!");
      app = new ChooserApp(pgA,tFont,fntSize,screenWidth,screenHeight,screenLinesFile,baseImageFileName);
    }
    if (app.stopRendering){
      println("PNG Render Complete!");
      app = new ChooserApp(pgA,tFont,fntSize,screenWidth,screenHeight,screenLinesFile,baseImageFileName);
    }
}

void mousePressed(){
  app.mousePressed();
}
void keyPressed(){
  app.keyPressed();
}