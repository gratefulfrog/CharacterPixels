
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
final int fntSize  = 220;

// This is the number of pixels at the smallest font, it will be scaled if bigger font is specified!
final int border = 3;

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////   NO USER MODIFIABLE VARIABLES BEYOND THIS POINT   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
PGraphics pg;
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
  pg = createGraphics(800,500);
  fInfo =  loadFont("DejaVuSans-18.vlw");
  doVisu();
}

void draw(){
  image(pg,0,0);
  info();
}

void info(){
  PGraphics pg = createGraphics(screenWidth-infoX,screenHeight-infoY);      
  String[] sVec = {"the RED box is the theoretical postion of the character",
                   "the BLUE box is the computed bounding box of the character",
                   "Type any key to display its boxes"};
  color[] colVec = {red,blue,black};
  
  pg.beginDraw();
  pg.background(white);
  pg.textFont(fInfo,18);
  pg.textAlign(LEFT,TOP);
  for (int i=0; i<sVec.length;i++){    
    pg.fill(colVec[i]);
    pg.text(sVec[i],0,50*i);
  }
  pg.endDraw();
  image(pg,infoX,infoY);
}

void doVisu(){
  pg.beginDraw();
  pg.background(white);
  pg.fill(black);
  pg.textFont(tFont);
  pg.stroke(black);
  pg.textAlign(LEFT,TOP);
  float h = pg.textAscent() + pg.textDescent() + epsilon;
  pg.pushStyle();
  pg.fill(white,0);
  pg.stroke(red);  // RED is the theoretical box
  // theoretical bounding box
  float x1 = left,
        y1 = top,
        x2 = left+pg.textWidth(c),
        y2 = y1,
        x3 = x2,
        y3 = top+h-epsilon,
        x4 = x1,
        y4 = y3;
  pg.quad(x1,y1,x2,y2,x3,y3,x4,y4);
  BoundingBoxMap bbm =  new BoundingBoxMap(tFont,fntSize,pixelBorder);
  BoundingBox bx = bbm.get(c);
  pg.stroke(blue);   // BLUE is the true bounding box
  // real bounding box
   x1 = left + bx.left;
        y1 = top  + bx.top;
        x2 = left + bx.right;
        y2 = y1;
        x3 = x2;
        y3 = top + bx.bottom;
        x4 = x1;
        y4 = y3;
  pg.quad(x1,y1,x2,y2,x3,y3,x4,y4);
  pg.popStyle();
  pg.text(c,left,top);
  pg.endDraw();
  println("\nChar:\t",c);
  println("Height:\t",h-epsilon);
  println("Width:\t",pg.textWidth(c));
  println("left:\t",bx.left,bx.left < 0 ? "!!!" : "");
  println("Right:\t",bx.right, bx.right>pg.textWidth(c) ? "!!!" : "");
  println("Top:\t", bx.top, bx.top < 0 ? "!!!" : "");
  println("Bottom:\t",bx.bottom, bx.bottom>h-epsilon ? "!!!" : "");
}


void keyPressed(){
  if (key != CODED){
    c = key;
    doVisu();
  }
}