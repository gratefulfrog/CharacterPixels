////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////               Text Lines Input File Name           /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// change the screen1LinesFile to any text file you want
// each line should end with no extra spaces 
// and the file should end at the end of the last line, with no extra lines
// 
// if the file name is given without a full path, then it must be in the data directory
// if not it can be anywhere!

final String screen1LinesFile = "screen1Text49lines.txt";

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////       Font Family and Size and Border Dimensions   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The font name and size MUST correspond to a font in the data directory!
// The fontFamily name should be something like  "Ingeborg-Regular", or "Times-Bold" without trailing 
// dash's.
final String fontFamily = "Ingeborg-New-f-Regular";

// Changing the fntSize will change the image size, and the border width;
// Currently available values are 22, 110, 220
// set the processing memory preference to 16384 MB to ensure results!!
// BE SURE TO SET THE FONT INDEX TO THE APPROPRIATE VALUE to get the left and right compensation to work!!
final int fntSize  = 22;
final int fontIndex = 0;   
/* font index:
 * 0: Ingeborg-New-f-Regular 22
 * 1: Ingeborg-New-f-Regular 220
*/

// This is the number of pixels at the smallest font, it will be scaled if bigger font is specified!
final int border = 3;

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
final int numberOfFrames = 300;

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// FONT HORIZONTAL SPACING COMPENSATION ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// setting this variable to true cause the program to try to compensate for font problems in 
// horizontal spacing. Caution should be used since thi may increase line lenght and cause overlaps.

boolean useCompensatedWidth = true;

// BE SURE TO SET UP ANY MANAULLY CALCULATED LEFT and/or RIGHT horizontal compensation 
// in the FontConfig tab!!!!!!!!  I AM SERIOUS, DO IT !!

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////   NO USER MODIFIABLE VARIABLES BEYOND THIS POINT   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
PGraphics pgA;
App app;
PFont tFont;

FixedHorizontalCompensationMap fHCM;

final int baseFontSize = 22;
final int pixelBorder = border*fntSize/baseFontSize;
final int normalFPS = 30;

boolean writeImages           = false,
        specialOneFrameRender = false;

final int screenWidth = 1884*(fntSize/baseFontSize),
          screenHeight = 1080*(fntSize/baseFontSize);
    
void settings(){
  size(screenWidth,screenHeight);
}

void setup(){
  frameRate(normalFPS);
  pgA = createGraphics(screenWidth,screenHeight);
  String fName = fontFamily+ "-" +nf(fntSize) + ".vlw";
  tFont = loadFont(fName);
  println("Using font: " + fName);
  println("Using " + (useCompensatedWidth ? "Compensated" : "Standard") + " horizontal spacing!");
  fHCM = new FixedHorizontalCompensationMap();
  FontConf fc =   new FontConf(fHCM, fontIndex);
  app = new ChooserApp(pgA,tFont,fntSize,screenWidth,screenHeight,screen1LinesFile,baseImageFileName);
}

void draw(){
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
     saveFrame("Render/" + 
               app.baseName + 
               "Frame-" + 
               nf(currentFrameID,5) + 
               ".png");
   }
}

void mousePressed(){
  app.mousePressed();
}
void keyPressed(){
  app.keyPressed();
}