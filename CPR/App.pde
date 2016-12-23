class App{
  PFont     font;
  PGraphics pgA;
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
  boolean doRecordSVG = false;
  boolean stopRendering = false;
  
  App(PGraphics p,PFont f, int fs, int lw, int sh,String textFN, String outF){
    pgA = p;
    font = f;
    fontSize=fs;
    lineWidth = lw;
    sHeight = sh;
    textFileName = textFN;
    baseName = outF;
    imageMode(CENTER);
  }
  void draw(){
    background(g_black);
    if (updatePgOK()){
      updatePG();
    }
    if (displayPG){
      image(pgA,width/2.0,height/2.0);
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
    else{ // we are done, stop, formerlyy went back to full speed!
      stopRendering = true;
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
         render = "Render PNG: " + (g_writeImages ? "ON!" : "off"),
         svgRender = "Generate SVG: " + (g_writeSVG ? "ON!" : "off"),
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
    pgA.beginDraw();
    pgA.background(g_black);
    pgA.textFont(font,fontSize);
    pgA.textAlign(LEFT,CENTER);
    pgA.pushMatrix();
    pgA.translate(leftMargin, lineSpace);
    pgA.text(top,0,0);
    pgA.translate(0,lineSpace);
    if (g_writeImages){
      pgA.fill(g_green); 
    }
    else{
      pgA.fill(g_red); 
    }
    pgA.text(render,0,0);
    pgA.pushMatrix();
    if (g_writeSVG){
      pgA.fill(g_green); 
    }
    else{
      pgA.fill(g_red); 
    }
    pgA.translate(lineSpace*2,0);
    pgA.text(svgRender,0,0);
    pgA.popMatrix();
    pgA.fill(g_white);
    pgA.translate(0,lineSpace);
    pgA.text(baseImageFileName,0,0);
    pgA.translate(0, lineSpace);
    pgA.text(bottom,0,0);
    pgA.translate(0, 2*lineSpace);
    pgA.text(instructions,0,0);
    pgA.popMatrix();
    pgA.endDraw();
  } 
  void mousePressed(){
    if (mouseY< 1.5*lineSpace){
      g_app = new FullTextApp(pgA,font,fontSize,lineWidth, sHeight,textFileName,textFileName);
    }
     else if(mouseY< 2.5*lineSpace && (mouseX < leftMargin +textWidth(render)/2.0+ lineSpace)){
      g_writeImages = !g_writeImages;
      if (g_writeImages){
        g_writeSVG = false;
      }
    }
     else if(mouseY< 2.5*lineSpace){
      g_writeSVG = !g_writeSVG;
      if(g_writeSVG){
        g_writeImages = false;
      }
    }
    else if(mouseY< 3.5*lineSpace){
     g_app= new RenderApp(pgA,font,fontSize,lineWidth,sHeight,textFileName,baseImageFileName);
    }
    else {
      exit();
    }
    render =  new String("Render PNG: " + (g_writeImages ? "ON!" : "off"));
    svgRender = "Generate SVG: " + (g_writeSVG ? "ON!" : "off");
    frameRate(g_writeImages ? 1 : g_normalFPS);
  }
  void keyPressed(){
      exit();
  }
}

class CharPixelApp extends App{
  BoundingBoxMap bbm;
  DisplayText    dt;

  CharPixelApp(PGraphics p,PFont f, int fs, int lw,int sh,String textFN, String baseFN){
    super(p,f,fs,lw,sh,textFN,baseFN);
    bbm =  new BoundingBoxMap(font,fontSize,g_pixelBorderVec);
    dt = new DisplayText(bbm,pgA,font,fontSize, lineWidth,sHeight, textFileName);
  }
  void draw(){
    super.draw();
    dt.display();
  }
  void mousePressed(){
    displayPG = !displayPG;      
  }  
}

class RenderApp extends CharPixelApp{
  boolean animate  = true;
  
  String fullImagePathBaseName;

  RenderApp(PGraphics p,PFont f, int fs,int lw,int sh, String textFN, String baseFN){
    super(p,f,fs,lw,sh,textFN,baseFN);
    displayImageCount = g_startFrame;
    nbImages = g_numberOfFrames;
    g_specialOneFrameRender = false;
    g_writeSVG = false;
    fullImagePathBaseName = g_inputDir + g_separator + baseFN;
  }
  
  boolean updatePgOK(){
    return animate;
  }
  
  void updatePG(){
    PImage imgG = null;
    try{
      imgG = loadImage(fullImagePathBaseName + "_" + nf(displayImageCount,5) + ".png");
      if (imgG == null){
        throw new FileNotFoundException(fullImagePathBaseName + "_" + nf(displayImageCount,5) + ".png");
      }
    }
    catch (Exception e) {
      println("File Not Found in data directory: ",e.getMessage());
       noLoop();
       exit();
    }
    if (!g_writeImages){ 
      println("Displaying: " + (baseName + "_" + nf(displayImageCount,5) + ".png"));
    }
    pgA.beginDraw();
    pgA.pushMatrix();
    pgA.background(g_black);
    pgA.imageMode(CENTER);
    pgA.translate(width/2.0,height/2.0);
    pgA.image(imgG,0,0);
    pgA.popMatrix();
    pgA.endDraw();
    displayImageCount =  (displayImageCount+1 == g_startFrame+nbImages ?g_startFrame : displayImageCount+1);
    pauseOutput =  false;
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        g_app = newChooser();
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
    g_specialOneFrameRender = true;
    img = createImage(lw,sh, RGB);
    img.loadPixels();
    for (int i=0; i<height;i++){
      for (int j = 0; j<width;j++){
        img.pixels[j+width*i] = g_white;    
      }
    }
    img.updatePixels();
    doRecordSVG = g_writeSVG; //true;
  }
  void updatePG(){
    pgA.beginDraw();
    pgA.imageMode(CORNER);
    pgA.background(g_black);
    pgA.image(img,0,0);
    pgA.endDraw();
    displayImageCount = 0;
    pauseOutput =  false;
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        g_app = newChooser();
        break;
      default:
        break;
    }
  }
}