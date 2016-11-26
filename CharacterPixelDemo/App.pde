color bg = #AFA1A1,// beige,
      red = #FF0000,
      blue =#0000FF,
      green = #00FF00,
      white = #FFFFFF,
      black = #000000;
      
class App{
  PGraphics pg;
  boolean displayPG = false;
  App(PGraphics p){
    pg = p;
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
  boolean updatePgOK(){
    return true;
  }
  void updatePG(){
  }
  void mousePressed(){
    //displayPG = !displayPG;
  }  
  void keyPressed(){
  }
}

class DemoChooserApp extends App{
  PFont font;
  String left = new String("Checkerboard\nDemo"),
         right = new String("Friendly\nRotatating Iguana\nDemo"),
         bottom = new String("Any key to exit");
  
  DemoChooserApp(PGraphics p){
    super(p);
    font = loadFont("TeXGyreHeros-Regular-48.vlw");
    displayPG = true;
  }
  void updatePG(){
    pg.beginDraw();
    pg.background(black);
    pg.textFont(font,48);
    pg.pushMatrix();
    pg.translate(0,height/2.0);
    pg.translate(width/3.0,0);
    pg.textAlign(CENTER,CENTER);
    pg.text(left,0,0);
    pg.translate(width/3.0,0);
    pg.text(right,0,0);
    pg.popMatrix();
    pg.pushMatrix();
    pg.textFont(font, 24);
    pg.translate(width/2.0, height-50);
    pg.text(bottom,0,0);
    pg.popMatrix();
    pg.endDraw();
  } 
  void mousePressed(){
    if(mouseX <=width/2.0){
      println("left demo");
      app= new CheckerboardDempApp(pg);
    }
    else {
      app = new IguanaDempApp(pg);
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
                 rectFillForSpace = false,
                 instructionsRead = false;
  PImage img;
  CharPixelApp(PGraphics p){
    super(p);
    bbm =  new BoundingBoxMap();
    dt = new DisplayText(bbm,pg);
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

class CheckerboardDempApp extends CharPixelApp{
  Checkerboard cb;
  int checkDim = 1,  // width of checkerboard squares
      inc = 1;
  CheckerboardDempApp(PGraphics p){
    super(p);
    img = createImage(1280, 720, RGB);
    cb = new Checkerboard(img, checkDim);
  }
  void updatePG(){
    if (!instructionsRead){
      showInstructions();
      return;
    }
    if (inc!=0 && frameCount%20==0){
      checkDim =max(1,checkDim+inc);
      cb = new Checkerboard(img, checkDim);
    }
    pg.beginDraw();
    pg.imageMode(CORNER);
    pg.background(black);
    pg.image(img,0,0);
    pg.endDraw();
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
    PFont font = loadFont("TeXGyreHeros-Regular-48.vlw");
    pg.beginDraw();
    pg.textFont(font,18);
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
        app = new DemoChooserApp(pg);
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
class IguanaDempApp extends CharPixelApp{
  int count =0;
  boolean rot = true;
  
  IguanaDempApp(PGraphics p){
    super(p);
    img = loadImage("iguana1280x720.jpg");
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
    pg.rotate(radians(5*count++));
    pg.image(img,0,0);
    pg.popMatrix();
    pg.endDraw();
  }
  
  void showInstructions(){
    String instructions  = "Mouse click:   toggle the display of the underlying image,\n" +
                           "'r' or 'R' keys:   toggle use of filled rectangle to replace the ' ' space character\n" +
                           "'t' or 'T' keys:   toggle use of true or standard character bounding box for character color computation, the type of box is displayed in the console.\n\n" +
                           "'q' or 'Q':   return to demo selector\n\n" +
                           "Any other key:   pause the rotation\n\n\n" +
                           "... mouse click to continue to demo";
    displayPG = true;
    PFont font = loadFont("TeXGyreHeros-Regular-48.vlw");
    pg.beginDraw();
    pg.textFont(font,18);
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
        app = new DemoChooserApp(pg);
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