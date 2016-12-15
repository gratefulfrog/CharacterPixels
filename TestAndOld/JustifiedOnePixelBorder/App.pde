color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;
      
class App{
  PGraphics pg;
  boolean displayPG = false;
  PFont font;
  int fontSize;
  int lineWidth;
  int sHeight;
  String textFileName;
  int nbImages = 1,
      outputImageCount = 0;;
  String outputFileName;
  boolean pauseOutput = true;
  
  App(PGraphics p,PFont f, int fs, int lw, int sh,String textFN, String outF){
    pg = p;
    font = f;
    fontSize=fs;
    lineWidth = lw;
    sHeight = sh;
    textFileName = textFN;
    outputFileName = outF;
    pauseOutput = true;
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
    else if (outputFileName == ""){
      ret = false;
    }
    else if (outputImageCount< nbImages){
      ret = true;
      outputImageCount++;
    }
    //println("outfile:",outputFileName,outputImageCount,nbImages,ret);
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

class DemoChooserApp extends App{
  String left = new String("Smoke\nDemo"),
         middle =  new String("Lightning\nDemo"),
         right = new String("Friendly\nRotatating Iguana\nDemo"),
         bottom = new String("Any other key to exit"),
         top = new String("T to display full Text"),
         render =  new String("Rendering: " + (writeImages ? "ON!" : "off"));
  
  DemoChooserApp(PGraphics p,PFont f, int fs,int lw, int sh,String textFN){
    super(p,f,fs,lw,sh,textFN,"");
    displayPG = true;
    renderCount = 0;  // global variable....
  }
  void updatePG(){
    pg.beginDraw();
    pg.background(black);
    pg.textFont(font,fontSize);
    pg.pushMatrix();
    pg.translate(width/2.0, 50);
    pg.text(top,0,0);
    pg.translate(0,150);
    if (writeImages){
      pg.fill(green); 
    }
    else{
      pg.fill(red); 
    }
    pg.text(render,0,0);
    pg.fill(white);
    pg.popMatrix();
    pg.pushMatrix();
    pg.translate(0,height/2.0);
    pg.translate(width/4.0,0);
    pg.textAlign(CENTER,CENTER);
    pg.text(left,0,0);
    pg.translate(width/4.0,0);
    pg.text(middle,0,0);
    pg.translate(width/4.0,0);
    pg.text(right,0,0);
    pg.popMatrix();
    pg.pushMatrix();
    pg.translate(width/2.0, height-50);
    pg.text(bottom,0,0);
    pg.popMatrix();
    pg.endDraw();
  } 
  void mousePressed(){
    if (dist(mouseX,mouseY, width/2.0,200)< 200){
      writeImages = !writeImages;
      render =  new String("Rendering: " + (writeImages ? "ON!" : "off"));
      frameRate(writeImages ? 1 : 30);
    }
    else if(mouseX <=width*3/8.0){
      app= new SmokeDemoApp(pg,font,fontSize,lineWidth,sHeight,textFileName,"SmokeDemoFrame");
    }
    else if (mouseX <=width*5/8.0){
      app= new LightningDemoApp(pg,font,fontSize,lineWidth,sHeight,textFileName,"LightningDemoFrame");
    }
    else {
      app = new IguanaDemoApp(pg,font,fontSize,lineWidth,sHeight,textFileName,"IguanaDemoFrame");
    }
  }
  void keyPressed(){
    if (key=='t' || key == 'T'){
      app = new FullTextDemoApp(pg,font,fontSize,lineWidth, sHeight,textFileName,"FullTextDemoFrame");
    }
    else{
      exit();
    }
  }
}

class CharPixelApp extends App{
  BoundingBoxMap bbm;
  DisplayText    dt;
  boolean        trueBox          = true,
                 rectFillForSpace = false,
                 instructionsRead = true;
  PImage img;
  CharPixelApp(PGraphics p,PFont f, int fs, int lw,int sh,String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    bbm =  new BoundingBoxMap(font,fontSize);
    dt = new DisplayText(bbm,pg,font,fontSize, lineWidth,sHeight, textFileName);
    
    println("Using " + (trueBox ? "True" : "Std") + " Box!");
    println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
  }
  void draw(){
    super.draw();
    if (instructionsRead){
      dt.display(trueBox,rectFillForSpace);
    }
  }
  void mousePressed(){
    if (!instructionsRead){
      instructionsRead =true;
    }
    displayPG = !displayPG;      
  }  
  void showInsructions(){
  }
}

class CheckerboardDemoApp extends CharPixelApp{
  Checkerboard cb;
  int checkDim = 1,  // width of checkerboard squares
      inc = 1;
  boolean animate;
  CheckerboardDemoApp(PGraphics p,PFont f, int fs,int lw,int sh, boolean anim,String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    animate= anim;
    img = createImage(lw,sh, RGB);
    cb = new Checkerboard(img, checkDim, animate);
  }
  void updatePG(){
    if (!instructionsRead){
      showInstructions();
      return;
    }
    if (inc!=0 && frameCount%20==0){
      checkDim =max(1,checkDim+inc);
      cb = new Checkerboard(img, checkDim, animate);
    }
    pg.beginDraw();
    pg.imageMode(CORNER);
    pg.background(black);
    pg.image(img,0,0);
    pg.endDraw();
    pauseOutput =  false;
  }
  
  void showInstructions(){
    String instructions  = "Mouse click:   toggle the display of the underlying image,\n" +
                           "'+' key:   start incrementing the number of squares on the checkerboard\n" +
                           "'-' key:   start decrementing the number of squares on the checkerboard\n" +
                           "'r' or 'R' keys:   toggle use of filled rectangle to replace the ' ' space character\n" +
                           "'t' or 'T' keys:   toggle use of true or standard character bounding box for character color computation, the type of box is displayed in the console.\n\n" +
                           "'q' or 'Q':   return to demo selector\n\n" +
                           "Any other key:   pause the inc/decrementing\n\n\n" +
                           "... mouse click to continue to demo";
    displayPG = true;
    pg.beginDraw();
    pg.textFont(font,fontSize);
    pg.background(black);
    pg.fill(white);
    pg.textAlign(LEFT);
    pg.text(instructions,50,250);
    pg.endDraw();
  }

  void keyPressed(){
    switch(key){
      case '+':
        inc = 1;
        break;
      case '-':
        inc = -1;
        break;
      case 'q':
      case 'Q':
        app = new DemoChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName);
        break;
      case 'r':
      case 'R':
        rectFillForSpace = !rectFillForSpace;
        println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
        break;
      case 't':
      case 'T':
        trueBox = !trueBox;
        println("Using " + (trueBox ? "True" : "Std") + " Box!");
        break;
      default:
        inc=0;
        break;
    }
  }
}

class IguanaDemoApp extends CharPixelApp{
  int count =0;
  boolean rot = true;
  
  IguanaDemoApp(PGraphics p,PFont f, int fs,int lw,int sh,String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    nbImages = 360;
    img = loadImage("iguana1884x1080.jpg");
  }
  boolean updatePgOK(){
    return rot;
  }
  void updatePG(){
    if (!instructionsRead){
      showInstructions();
      return;
    }
    pg.beginDraw();
    pg.pushMatrix();
    pg.background(black);
    pg.imageMode(CENTER);
    pg.translate(width/2.0,height/2.0);
    pg.rotate(radians(count++));
    pg.image(img,0,0);
    pg.popMatrix();
    pg.endDraw();
    pauseOutput =  false;
  }
  
  void showInstructions(){
    String instructions  = "Mouse click:   toggle the display of the underlying image,\n" +
                           "'r' or 'R' keys:   toggle use of filled rectangle to replace the ' ' space character\n" +
                           "'t' or 'T' keys:   toggle use of true or standard character bounding box for character color computation, the type of box is displayed in the console.\n\n" +
                           "'q' or 'Q':   return to demo selector\n\n" +
                           "Any other key:   pause the rotation\n\n\n" +
                           "... mouse click to continue to demo";
    displayPG = true;
    pg.beginDraw();
    pg.textFont(font,fontSize);
    pg.background(black);
    pg.fill(white);
    pg.textAlign(LEFT);
    pg.text(instructions,50,250);
    pg.endDraw();
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        app = new DemoChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName);
        break;
      case 'r':
      case 'R':
        rectFillForSpace = !rectFillForSpace;
        println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
        break;
      case 't':
      case 'T':
        trueBox = !trueBox;
        println("Using " + (trueBox ? "True" : "Std") + " Box!");
        break;
      default:
        rot = !rot;
        break;
    }
  }
}

class LightningDemoApp extends CharPixelApp{
  int count =0;
  boolean animate = true;
  
  LightningDemoApp(PGraphics p,PFont f, int fs,int lw,int sh, String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    nbImages = 300;
  }
  boolean updatePgOK(){
    return animate;
  }
  void updatePG(){
    if (!instructionsRead){
      showInstructions();
      return;
    }
    PImage imgG = loadImage("Lightning_" + nf(count,5) + ".png");
    pg.beginDraw();
    pg.pushMatrix();
    pg.background(black);
    pg.imageMode(CENTER);
    pg.translate(width/2.0,height/2.0);
    pg.image(imgG,0,0);
    pg.popMatrix();
    pg.endDraw();
    count =  (count+1)%nbImages;
    pauseOutput =  false;
  }
  
  void showInstructions(){
    String instructions  = "Mouse click:   toggle the display of the underlying image,\n" +
                           "'r' or 'R' keys:   toggle use of filled rectangle to replace the ' ' space character\n" +
                           "'t' or 'T' keys:   toggle use of true or standard character bounding box for character color computation, the type of box is displayed in the console.\n\n" +
                           "'q' or 'Q':   return to demo selector\n\n" +
                           "Any other key:   pause the animation\n\n\n" +
                           "... mouse click to continue to demo";
    displayPG = true;
    pg.beginDraw();
    pg.textFont(font,fontSize);
    pg.background(black);
    pg.fill(white);
    pg.textAlign(LEFT);
    pg.text(instructions,50,250);
    pg.endDraw();
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        app = new DemoChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName);
        break;
      case 'r':
      case 'R':
        rectFillForSpace = !rectFillForSpace;
        println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
        break;
      case 't':
      case 'T':
        trueBox = !trueBox;
        println("Using " + (trueBox ? "True" : "Std") + " Box!");
        break;
      default:
        animate = !animate;
        break;
    }
  }
}

class FullTextDemoApp extends CharPixelApp{
  Checkerboard cb;
  final int checkDim = 1;  // width of checkerboard squares
  FullTextDemoApp(PGraphics p,PFont f, int fs,int lw,int sh, String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    img = createImage(lw,sh, RGB);
    cb = new Checkerboard(img, checkDim, false);
    //nbImages = 5;
  }
  void updatePG(){
    if (!instructionsRead){
      showInstructions();
      return;
    }
    pg.beginDraw();
    pg.imageMode(CORNER);
    pg.background(black);
    pg.image(img,0,0);
    pg.endDraw();
    pauseOutput =  false;
  }
  
  void showInstructions(){
    String instructions  = "Mouse click:   toggle the display of the underlying image,\n" +
                           "'q' or 'Q':   return to demo selector\n\n" +
                           "... mouse click to continue to demo";;
                           
    displayPG = true;
    pg.beginDraw();
    pg.textFont(font,fontSize);
    pg.background(black);
    pg.fill(white);
    pg.textAlign(LEFT);
    pg.text(instructions,50,250);
    pg.endDraw();
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        app = new DemoChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName);
        break;
      default:
        break;
    }
  }
}

class SmokeDemoApp extends CharPixelApp{
  int count =0;
  boolean animate = true;
  
  SmokeDemoApp(PGraphics p,PFont f, int fs,int lw,int sh, String textFN, String outF){
    super(p,f,fs,lw,sh,textFN,outF);
    nbImages = 25;
  }
  boolean updatePgOK(){
    return animate;
  }
  void updatePG(){
    if (!instructionsRead){
      showInstructions();
      return;
    }
    PImage imgG = loadImage("Smoke_" + nf(count,5) + ".png");
    pg.beginDraw();
    pg.pushMatrix();
    pg.background(black);
    pg.imageMode(CENTER);
    pg.translate(width/2.0,height/2.0);
    //pg.image(imgVec[count],0,0);
    pg.image(imgG,0,0);
    pg.popMatrix();
    pg.endDraw();
    count =  (count+1)%nbImages;
    pauseOutput =  false;
  }
  
  void showInstructions(){
    String instructions  = "Mouse click:   toggle the display of the underlying image,\n" +
                           "'r' or 'R' keys:   toggle use of filled rectangle to replace the ' ' space character\n" +
                           "'t' or 'T' keys:   toggle use of true or standard character bounding box for character color computation, the type of box is displayed in the console.\n\n" +
                           "'q' or 'Q':   return to demo selector\n\n" +
                           "Any other key:   pause the animation\n\n\n" +
                           "... mouse click to continue to demo";
    displayPG = true;
    pg.beginDraw();
    pg.textFont(font,fontSize);
    pg.background(black);
    pg.fill(white);
    pg.textAlign(LEFT);
    pg.text(instructions,50,250);
    pg.endDraw();
  }

  void keyPressed(){
    switch(key){
      case 'q':
      case 'Q':
        app = new DemoChooserApp(pg,font,fontSize,lineWidth,sHeight,textFileName);
        break;
      case 'r':
      case 'R':
        rectFillForSpace = !rectFillForSpace;
        println("Using " + (rectFillForSpace ? "Filled rect" : "Background") + " for spaces!");
        break;
      case 't':
      case 'T':
        trueBox = !trueBox;
        println("Using " + (trueBox ? "True" : "Std") + " Box!");
        break;
      default:
        animate = !animate;
        break;
    }
  }
}