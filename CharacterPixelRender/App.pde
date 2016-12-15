color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;
      
class App{
  PFont     font;
  PGraphics pg;
  boolean   displayPG   = false,
            pauseOutput = true;
  int       fontSize,
            lineWidth,
            sHeight,
            nbImages = 1,
            outputImageCount = 0,
            displayImageCount = 0;
  String    textFileName,
            baseName;
 
  
  App(PGraphics p,PFont f, int fs, int lw, int sh,String textFN, String outF){
    pg = p;
    font = f;
    fontSize=fs;
    lineWidth = lw;
    sHeight = sh;
    textFileName = textFN;
    baseName = outF;
    imageMode(CENTER);
  }
  void draw(){
    background(black);
    if (updatePgOK()){
      updatePG();
    }
    if (displayPG){
      image(pg,width/2.0,height/2.0);
    }
  }
  boolean doSave(){
    boolean ret = false;
    if(pauseOutput){
      ret = false;
    }
    else if (baseName == ""){
      ret = false;
    }
    else if (outputImageCount< nbImages){
      ret = true;
      outputImageCount++;
    }
    else{ // we are done, go back to full speed!
      frameRate(normalFPS);
    }
    return ret;
  }
  boolean updatePgOK(){
    return true;
  }
  void updatePG(){
  }
  void mousePressed(){
  }  
  void keyPressed(){
  }
}

class ChooserApp extends App{
  String top    = "Full Text",
         render = "Rendering: " + (writeImages ? "ON!" : "off"),
         bottom = "Any key to exit";
  String  instructions  = "During Animation and/or Rendering:\n\n" +
                          "   *  Mouse click:   toggle the display of the underlying image,\n\n" +
                          "   *  'q' or 'Q':   return to Start Screen\n\n" +
                          "   *  Any other key:   pause the animation";
  String baseImageFileName;
  
  final int leftMargin = 200,
            lineSpace =  100;
  
  ChooserApp(PGraphics p,PFont f, int fs,int lw, int sh,String textFN, String baseImageFN){
    super(p,f,fs,lw,sh,textFN,"");
    displayPG = true;
    baseImageFileName = baseImageFN;
  }
  
  void updatePG(){
    pg.beginDraw();
    pg.background(black);
    pg.textFont(font,baseFontSize);
    pg.textAlign(LEFT,CENTER);
    pg.pushMatrix();
    pg.translate(leftMargin, lineSpace);
    pg.text(top,0,0);
    pg.translate(0,lineSpace);
    if (writeImages){
      pg.fill(green); 
    }
    else{
      pg.fill(red); 
    }
    pg.text(render,0,0);
    pg.fill(white);
    pg.translate(0,lineSpace);
    pg.text(baseImageFileName,0,0);
    pg.translate(0, lineSpace);
    pg.text(bottom,0,0);
    pg.translate(0, 2*lineSpace);
    pg.text(instructions,0,0);
    pg.popMatrix();
    pg.endDraw();
  } 
  void mousePressed(){
    if (mouseY< 1.5*lineSpace){
      app = new FullTextApp(pg,font,fontSize,lineWidth, sHeight,textFileName,textFileName);
    }
     else if(mouseY< 2.5*lineSpace){
      writeImages = !writeImages;
      render =  new String("Rendering: " + (writeImages ? "ON!" : "off"));
      frameRate(writeImages ? 1 : normalFPS);
    }
    else if(mouseY< 3.5*lineSpace){
     app= new RenderApp(pg,font,fontSize,lineWidth,sHeight,textFileName,baseImageFileName);
    }
    else {
      exit();
    }
  }
  void keyPressed(){
      exit();
  }
}

class CharPixelApp extends App{
  BoundingBoxMap bbm;
  DisplayText    dt;
  boolean        trueBox          = true,
                 rectFillForSpace = false;

  CharPixelApp(PGraphics p,PFont f, int fs, int lw,int sh,String textFN, String baseFN){
    super(p,f,fs,lw,sh,textFN,baseFN);
    bbm =  new BoundingBoxMap(font,fontSize,pixelBorder);
    dt = new DisplayText(bbm,pg,font,fontSize, lineWidth,sHeight, textFileName);
    
    println("Using " + (trueBox ? "True" : "Std") + " Box!");
    println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
  }
  void draw(){
    super.draw();
    dt.display(trueBox,rectFillForSpace);
  }
  void mousePressed(){
    displayPG = !displayPG;      
  }  
}

class RenderApp extends CharPixelApp{
  boolean animate  = true;

  RenderApp(PGraphics p,PFont f, int fs,int lw,int sh, String textFN, String baseFN){
    super(p,f,fs,lw,sh,textFN,baseFN);
    displayImageCount = startFrame;
    nbImages = numberOfFrames;
    specialOneFrameRender = false;
  }
  
  boolean updatePgOK(){
    return animate;
  }
  
  void updatePG(){
    PImage imgG = loadImage(baseName + "_" + nf(displayImageCount,5) + ".png");
    if (!writeImages || !(outputImageCount< nbImages)){
      println("Displaying: " + (baseName + "_" + nf(displayImageCount,5) + ".png"));
    }
    pg.beginDraw();
    pg.pushMatrix();
    pg.background(black);
    pg.imageMode(CENTER);
    pg.translate(width/2.0,height/2.0);
    pg.image(imgG,0,0);
    pg.popMatrix();
    pg.endDraw();
    displayImageCount =  (displayImageCount+1 == startFrame+nbImages ? startFrame : displayImageCount+1);
    pauseOutput =  false;
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        app = new ChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName,baseImageFileName);
        break;
      default:
        animate = !animate;
        break;
    }
  }
}

class FullTextApp extends CharPixelApp{
  PImage img;
  FullTextApp(PGraphics p,PFont f, int fs,int lw,int sh, String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    specialOneFrameRender = true;
    img = createImage(lw,sh, RGB);
    img.loadPixels();
    for (int i=0; i<height;i++){
      for (int j = 0; j<width;j++){
        img.pixels[j+width*i] = white;    
      }
    }
    img.updatePixels();
  }
  void updatePG(){
    pg.beginDraw();
    pg.imageMode(CORNER);
    pg.background(black);
    pg.image(img,0,0);
    pg.endDraw();
    displayImageCount = 0;
    pauseOutput =  false;
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        app = new ChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName,baseImageFileName);
        break;
      default:
        break;
    }
  }
}