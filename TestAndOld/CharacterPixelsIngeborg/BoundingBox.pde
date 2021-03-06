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
  PFont font;
  int fontSize;
  
  BoundingBoxMap(PFont f,int fs){
    font = f;
    fontSize = fs;
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
    PGraphics pg = createGraphics(100,100);
    pg.beginDraw();
    pg.textFont(font, fontSize);
    pg.textAlign(LEFT,TOP);
    pg.background(white);
    pg.fill(black);
    pg.text(c,0,0);
    pg.endDraw();
    BoundingBox b = new BoundingBox();
    b.top    = Top(pg);
    b.left   = Left(pg);
    b.bottom = Bottom(pg);
    b.right  = Right(pg);
    hm.put(c,b);
    return b;
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
    int ret = width;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          ret = min(iw,ret);
        }
      }
    }
    return ret;
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
    return ret;
  }
  int Right(PGraphics g){
    int ret = -1;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          ret = max(iw,ret);
        }
      }
    }
    return ret;
  }  
}