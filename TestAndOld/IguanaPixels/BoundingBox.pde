import java.util.HashMap;


class BoundingBox{
 int left   = -1,
     top    = -1,
     right  = -1,
     bottom = -1;
 BoundingBox(){
 }
}

class BoundingBoxMap{
  HashMap<Character, BoundingBox> hm;
  PFont font = loadFont("FreeSans-12.vlw");
  int fontSize = 12;
  
  BoundingBoxMap(){
    hm = new HashMap<Character,BoundingBox>();
  }
  BoundingBox get(Character c){
    BoundingBox b = hm.get(c);
    if (b == null){
      put(c);
      b = hm.get(c);
    }
    return b;
  }
 
  void put(Character c){
    PGraphics pg = createGraphics(100,100);
    pg.beginDraw();
    pg.textFont(font, fontSize);
    pg.textAlign(LEFT,TOP);
    pg.background(white);
    pg.fill(black);
    pg.text(c,0,0);
    pg.endDraw();
    pg.loadPixels();
    BoundingBox b = new BoundingBox();
    b.top    = Top(pg);
    b.left   = Left(pg);
    b.bottom = Bottom(pg);
    b.right  = Right(pg);
    hm.put(c,b);
  }
  int Top(PGraphics g){
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          return ih;
        }
      }
    }
    return -1;
  }
  int Left(PGraphics g){
    boolean found = false;
    int ret = width;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (!found && c != white){
          found = true;
        }
        if (found && c != white && iw<ret){
          ret = iw;
        }
      }
    }
    return ret;
  }
  
  int Bottom(PGraphics g){
    boolean found = false;
    int ret = -1;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (!found && c != white){
          found = true;
        }
        if (found && c != white && ih> ret){
          ret = ih;
        }
      }
    }
    return ret;
  }
  int Right(PGraphics g){
    boolean found = false;
    int ret = -1;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (!found && c != white){
          found = true;
        }
        if (found && c != white && iw>ret){
          ret = iw;
        }
      }
    }
    return ret;
  }  
}