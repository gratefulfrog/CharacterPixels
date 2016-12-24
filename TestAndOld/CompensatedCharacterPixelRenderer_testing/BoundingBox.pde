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
  int[] pixBordVec;
  int gHeight;
  
  BoundingBoxMap(PFont f,int fs, int[] pbV){
    font = f;
    fontSize = fs;
    pixBordVec = pbV;
    pushStyle();
    textFont(font,fontSize);
    gHeight =  round(textAscent() + textDescent() + pixBordVec[g_upperIndex] + pixBordVec[g_lowerIndex]);
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
    pg.background(g_white);
    pg.fill(g_black);
    pg.text(c,pixBordVec[g_leftIndex],pixBordVec[g_upperIndex]);
    pg.endDraw();
    b.top    = Top(pg);
    b.bottom = Bottom(pg);
    // optimized: only look for left and right between top and bottom!
    b.left   = Left(pg,b.top+pixBordVec[g_upperIndex],b.bottom+pixBordVec[g_upperIndex]);
    b.right  = Right(pg,b.top+pixBordVec[g_upperIndex],b.bottom+pixBordVec[g_upperIndex]);
    if (c !=' '){
      b.leftCompensation = getLeftCompensation(c,b);
      b.rightCompensation = geRightCompensation(c, b, pg);
    }
    hm.put(c,b);
    return b;
  }
  float getLeftCompensation(char c, BoundingBox b){
    float res = 0.0;
    FixedHorizontalCompensation fhc = g_fHCM.get(c);
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
    FixedHorizontalCompensation fhc = g_fHCM.get(c);
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
        color col = g.get(iw,ih);
        if (col != g_white){
          return ih-pixBordVec[g_upperIndex];
        }
      }
    }
    return 0;
  }
  int Bottom(PGraphics g){
    int ret = 0;
    for (int ih=0;ih<g.height;ih++){
      for (int iw=0; iw<g.width;iw++){
        color col = g.get(iw,ih);
        if (col != g_white){
          ret = max(ih,ret);
        }
      }
    }
    return ret-pixBordVec[g_upperIndex];
  }
  int Left(PGraphics g,int ul, int ll){
    int ret = g.width;
    for (int ih=ul;ih<ll;ih++){
      for (int iw=0; iw<g.width;iw++){
        color col = g.get(iw,ih);
        if (col != g_white){
          ret = min(iw,ret);
        }
      }
    }
    return ret-pixBordVec[g_leftIndex];
  }
  int Right(PGraphics g,int ul, int ll){
    int ret = -1;
    for (int ih=ul;ih<ll;ih++){
      for (int iw=0; iw<g.width;iw++){
        color col = g.get(iw,ih);
        if (col != g_white){
          ret = max(iw,ret);
        }
      }
    }
    return ret-pixBordVec[g_leftIndex];
  }  
}