import java.util.HashMap;

class BoundingBox{
 int left   = 0,
     top    = 0,
     right  = 0,
     bottom = 0;
 float leftCompensation = 0,
       rightCompensation = 0;
 BoundingBox(){
 }
 void prin(){
   println("Top: ",top,"Bottom: ",bottom,"Left: ",left,"Right: ",right,"Lcomp: ",leftCompensation,"Rcomp: ",rightCompensation);
 }
}

class BoundingBoxMap{
  HashMap<Character, BoundingBox> hm;
  PFont font;
  int fontSize;
  int pixBord;
  int gHeight;
  
  BoundingBoxMap(PFont f,int fs, int pb){
    font = f;
    fontSize = fs;
    pixBord = pb;
    pushStyle();
    textFont(font,fontSize);
    gHeight =  round(textAscent() + textDescent() + 2*pixBord);
    popStyle();
    hm = new HashMap<Character,BoundingBox>();
  }
  BoundingBox get(Character c){
    BoundingBox b = hm.get(c);
    if (b == null){
      b = put(c);
    }
    return b;
  }
 
  BoundingBox put(Character c){
    BoundingBox b = new BoundingBox();
    if (c == '\n'){
      return b;
    }
    PGraphics pg = createGraphics(gHeight,gHeight); //(100,100);
    pg.beginDraw();
    pg.textFont(font, fontSize);
    pg.textAlign(LEFT,TOP);
    pg.background(white);
    pg.fill(black);
    pg.text(c,pixBord,pixBord);
    pg.endDraw();
    b.top    = Top(pg);
    b.bottom = Bottom(pg);
     if (b.top == b.bottom){
      b.bottom++;
    }
    // optimized: only look for left and right between top and bottom!
    b.left   = Left(pg,b.top+pixBord,b.bottom+pixBord);
    b.right  = Right(pg,b.top+pixBord,b.bottom+pixBord);
    
   
    if (c !=' '){
      b.leftCompensation = b.left<0 ? -b.left :0;
      b.rightCompensation =  b.right > pg.textWidth(c) ? b.right - pg.textWidth(c) : 0; 
    }
    hm.put(c,b);
    return b;
  }
  int Top(PGraphics g){
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          return ih-pixBord;
        }
      }
    }
    return -999;
  }
  int Bottom(PGraphics g){
    int ret = -1;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          ret = max(ih,ret);
        }
      }
    }
    return ret-pixBord;
  }
  int Left(PGraphics g,int ul, int ll){
    int ret = g.width;
    for (int ih=ul;ih<ll;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          ret = min(iw,ret);
        }
      }
    }
    return ret-pixBord;
  }
  int Right(PGraphics g,int ul, int ll){
    int ret = -1;
    for (int ih=ul;ih<ll;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          ret = max(iw,ret);
        }
      }
    }
    return ret-pixBord;
  }  
}