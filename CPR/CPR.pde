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

final String g_screenLinesFile = "screenText49Shortlines.txt";

////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////   Font Family & Size and Screen & Border Dimensions   ////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The font name and size MUST correspond to a font in the data directory!
// The fontFamily name should be something like  "Ingeborg-New-f-Regular.otg", or "Times.ttf"  
// 
// to ensure correct font generation, place the original font file in the data directory!!
// failure to do so can have unexpected random consequences!!!!
final String g_fontFamily = "Ingeborg-New-f-Regular.otf";

// point size of font
final int g_fntSize  = 22;

// This is the number of pixels to be used as a border on all sides of the text
final int g_leftborder  = 3;
final int g_rightborder = 3;
final int g_upperborder = 2;
final int g_lowerborder = 8;  // needs to be bigger for charcters with descent, eg. y, g, q, p ...

// screen size in pixels
final int g_screenWidth  = 1884;
final int g_screenHeight = 1080;

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////           Image Files Input File Base Name         /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The following variables determine the source file names for the underlying image frames. 
//
// The source image frames must be placed in this directory which is in the data directory.
final String g_InputImageDirectory  = "Input_Images";

// The variable contains the base image file name, and to that will be added _00000.png, _00001.png  etc.
final String g_baseImageFileName = "Lightning";

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////                 Frames to be Rendered              /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// The next variables determine which frames are rendered.  The startFrame is where rendering starts, 
// and the numberOfFrames is how many to render. For example if we start at frame 0 and render 3 frames,
// we will get frame-0, frame-1,frame-2
// These variables are usefull to render only some specific frames after a failure, or if some of the
// underlying images were modified.
final int g_startFrame     = 0;
final int g_numberOfFrames = 5; // 300;

// directory where the rendered frames are saved

final String g_renderDirectory = "Render";

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// FONT HORIZONTAL SPACING COMPENSATION ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
// setting this variable to true cause the program to try to compensate for font problems in 
// horizontal spacing. Caution should be used since this may increase line length and cause overlaps.
boolean g_useCompensatedWidth = true;

// This is the name of the csv file in the data directory that contains any manual horizontal compensation
final String g_compensationFileName = "compINF22.csv"; 

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////   NO USER MODIFIABLE VARIABLES BEYOND THIS POINT   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
PGraphics g_pgA;
App g_app;
PFont g_tFont;

FixedHorizontalCompensationMap g_fHCM;

final String g_separator   = "/";
final String g_renderDir   = g_renderDirectory + g_separator;
final String g_inputDir    = g_InputImageDirectory + g_separator;
final String g_svgFileName = split(g_screenLinesFile,".")[0] + ".svg";

final int[] g_pixelBorderVec = {g_leftborder,g_rightborder,g_upperborder,g_lowerborder};
final int g_leftIndex  = 0,
          g_rightIndex = 1,
          g_upperIndex = 2,
          g_lowerIndex = 3;

final int g_normalFPS = 30;

boolean g_writeImages           = false,
        g_specialOneFrameRender = false,
        g_writeSVG              = false;

color g_bg    = #AFA1A1,// beige,
      g_red   = #FF0000,
      g_blue  = #0000FF,
      g_green = #00FF00,
      g_white = #FFFFFF,
      g_black = #000000;

void settings(){
  size(g_screenWidth,g_screenHeight);
}

void setup(){
  frameRate(g_normalFPS);
  g_pgA = createGraphics(g_screenWidth,g_screenHeight);
  String fName = g_fontFamily+ "\nFont Size: " + nf(g_fntSize);
  g_tFont = createFont("data" + g_separator   + g_fontFamily,g_fntSize,true);
  println("Using font: " + fName);
  println("Using " + (g_useCompensatedWidth ? "Compensated" : "Standard") + " horizontal spacing!");
  g_fHCM = loadHorizontalCompensation();
  if (g_useCompensatedWidth && (g_fHCM.size() !=0)){
    println("Using manual compensation values from file: " + g_compensationFileName);
  }
  g_app = newChooser();
}

App newChooser(){
  return new ChooserApp(g_pgA,g_tFont,g_fntSize,g_screenWidth,g_screenHeight,g_screenLinesFile,g_baseImageFileName);
}

void draw(){
  if (g_app.doRecordSVG){
    startRec();
  }
  g_app.draw();
  if (g_writeImages && g_app.doSave()){
    writeAndSave();
  }
  if(g_app.doRecordSVG){
    endRec();
  }
  if (g_app.stopRendering){
    stopRendering();
  }
}

void startRec(){
  beginRecord(SVG, g_renderDir + g_svgFileName);
  println("Rendering SVG file: " + 
          g_svgFileName + 
          "...");
}

void writeAndSave(){
   int currentFrameID = g_app.outputImageCount-1 + g_startFrame,
       endFrameID = g_startFrame+g_numberOfFrames-1;
   String renderFileName = g_baseImageFileName;
   if (g_specialOneFrameRender){
      currentFrameID = g_app.outputImageCount-1;
      endFrameID  = g_app.nbImages-1;
      renderFileName = split(g_screenLinesFile,".")[0];
   }         
   println("Rendering Frame: " + 
           renderFileName + 
           "_" + 
           nf(currentFrameID,5) + 
           " of " + 
           nf(endFrameID,5) + 
           " ...");
   saveFrame(g_renderDir + 
             renderFileName +  "_" +  
             "Frame-" + 
             nf(currentFrameID,5) + 
             ".png");
}

void endRec(){
  endRecord();
  g_app.doRecordSVG=false;
  println("SVG Render Complete!");
  g_app = newChooser();
}

void stopRendering(){
  println("PNG Render Complete!");
  g_app = newChooser();
}

void mousePressed(){
  g_app.mousePressed();
}
void keyPressed(){
  g_app.keyPressed();
}