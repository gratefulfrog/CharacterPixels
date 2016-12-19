
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
final int fntSize  = 22;

// This is the number of pixels at the smallest font, it will be scaled if bigger font is specified!
final int border = 3;

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////   NO USER MODIFIABLE VARIABLES BEYOND THIS POINT   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
PGraphics pgA;
PFont tFont,
      fInfo;

final int baseFontSize = 22;
final int pixelBorder = border*fntSize/baseFontSize;

final color bg = #AFA1A1,// beige,
            red = #FF0000,
            blue =#0000FF,
            green = #00FF00,
            white = #FFFFFF,
            black = #000000;

char c = 'j';   // init value
final float top = 50,
            left = top,
            epsilon = pixelBorder;
            
final int screenWidth  = 800,
          screenHeight = 500,
          infoX        = 200,
          infoY        = 300;
    
void settings(){
  size(screenWidth,screenHeight);
}

void setup(){
  String fName = fontFamily+ "-" +nf(fntSize) + ".vlw";
  tFont = loadFont(fName);
  println("Using font: " + fName);
  pgA = createGraphics(800,500);
  fInfo =  loadFont("DejaVuSans-18.vlw");
  doVisu();
}

void draw(){
  image(pgA,0,0);
  info();
}

void info(){
  PGraphics pgI = createGraphics(screenWidth-infoX,screenHeight-infoY);      
  String[] sVec = {"the RED box is the theoretical postion of the character",
                   "the BLUE box is the computed bounding box of the character",
                   "Type any key to display its boxes"};
  color[] colVec = {red,blue,black};
  
  pgI.beginDraw();
  pgI.background(white);
  pgI.textFont(fInfo,18);
  pgI.textAlign(LEFT,TOP);
  for (int i=0; i<sVec.length;i++){    
    pgI.fill(colVec[i]);
    pgI.text(sVec[i],0,50*i);
  }
  pgI.endDraw();
  image(pgI,infoX,infoY);
}

void doVisu(){
  pgA.beginDraw();
  pgA.background(white);
  pgA.fill(black);
  pgA.textFont(tFont);
  pgA.stroke(black);
  pgA.textAlign(LEFT,TOP);
  float h = pgA.textAscent() + pgA.textDescent() + epsilon;
  pgA.pushStyle();
  pgA.fill(white,0);
  pgA.stroke(red);  // RED is the theoretical box
  // theoretical bounding box
  float x1 = left,
        y1 = top,
        x2 = left+pgA.textWidth(c),
        y2 = y1,
        x3 = x2,
        y3 = top+h-epsilon,
        x4 = x1,
        y4 = y3;
  pgA.quad(x1,y1,x2,y2,x3,y3,x4,y4);
  BoundingBoxMap bbm =  new BoundingBoxMap(tFont,fntSize,pixelBorder);
  BoundingBox bx = bbm.get(c);
  pgA.stroke(blue);   // BLUE is the true bounding box
  // real bounding box
   x1 = left + bx.left;
        y1 = top  + bx.top;
        x2 = left + bx.right;
        y2 = y1;
        x3 = x2;
        y3 = top + bx.bottom;
        x4 = x1;
        y4 = y3;
  pgA.quad(x1,y1,x2,y2,x3,y3,x4,y4);
  pgA.popStyle();
  if (c=='\n'){
    return;
  }
  pgA.text(c,left,top);
  pgA.endDraw();
  println("\nChar:\t",c);
  bx.prin();
}

float textWidth(char c, BoundingBoxMap bm, PFont f, int fs){
  BoundingBox b = bm.get(c);
  pushStyle();
  textFont(f,fs);
  float rawWidth  = (c=='\n' ? 0 :textWidth(c));
  popStyle();
  return rawWidth + b.leftCompensation + b.rightCompensation;
}
float textWidth(String s, BoundingBoxMap bm, PFont f, int fs){
  float ret = 0;
  for (int i=0;i<s.length();i++){
    ret += textWidth(s.charAt(i),bm, f, fs);
  }
  return ret;
}

void keyPressed(){
  if (key != CODED){
    c = key;
    doVisu();
  }
}