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
   println("Top\t:",top,"Bottom\t",bottom,"Left\t:",left,"Right\t",right,"Lcomp\t",leftCompensation,"Rcomp\t:",rightCompensation);
 }
}

class BoundingBoxMap{
  HashMap<Character, BoundingBox> hm;
  PFont font;
  int fontSize;
  int[] pixBordVec;
  int gHeight;
  
  BoundingBoxMap(PFont f,int fs, int[] pbV){
    font = f;
    fontSize = fs;
    pixBordVec = pbV;
    pushStyle();
    textFont(font,fontSize);
    gHeight =  round(textAscent() + textDescent() + pixBordVec[upperIndex] + pixBordVec[lowerIndex]);
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
    pg.text(c,pixBordVec[leftIndex],pixBordVec[upperIndex]);
    pg.endDraw();
    b.top    = Top(pg);
    b.bottom = Bottom(pg);
    // optimized: only look for left and right between top and bottom!
    b.left   = Left(pg,b.top+pixBordVec[leftIndex],b.bottom+pixBordVec[upperIndex]);
    b.right  = Right(pg,b.top+pixBordVec[leftIndex],b.bottom+pixBordVec[upperIndex]);
    if (c !=' '){
      //b.leftCompensation = b.left<0 ? -b.left :0;
      b.leftCompensation = getLeftCompensation(c,b);
      //b.rightCompensation =  b.right > pg.textWidth(c) ? b.right - pg.textWidth(c) : 0; 
      b.rightCompensation = geRightCompensation(c, b, pg);
    }
    hm.put(c,b);
    return b;
  }
  float getLeftCompensation(char c, BoundingBox b){
    float res = 0.0;
    FixedHorizontalCompensation fhc = fHCM.get(c);
    if (fhc == null || !fhc.compensateLeft){
      res = b.left<0 ? -b.left :0;
    }
    else{
      res = fhc.leftCompensation;
    }
    return res;
  }

  float geRightCompensation(char c, BoundingBox b, PGraphics pg){
    float res = 0.0;
    FixedHorizontalCompensation fhc = fHCM.get(c);
    if (fhc == null || !fhc.compensateRight){
      res = b.right > pg.textWidth(c) ? b.right - pg.textWidth(c) : 0; 
    }
    else{
      res = fhc.rightCompensation;
    }
    return res;
  }
  
  int Top(PGraphics g){
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          return ih-pixBordVec[upperIndex];
        }
      }
    }
    return 0;
  }
  int Bottom(PGraphics g){
    int ret = 0;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color c = g.get(iw,ih);
        if (c != white){
          ret = max(ih,ret);
        }
      }
    }
    return ret-pixBordVec[upperIndex];
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
    return ret-pixBordVec[leftIndex];
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
    return ret-pixBordVec[leftIndex];
  }  
}